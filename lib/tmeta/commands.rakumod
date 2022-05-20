
use tmeta::commander;

unit class tmeta::commands is tmeta::commander;
use Log::Async;
use tmeta::actions;
use tmeta::waiter;
use tmeta::tester;
use tmeta::tmux;
use tmeta::utils;

method generate-help($for = Nil) {
  my @help;
  for $=pod<>.sort -> $pod {
    next if $for && $pod !~~ / $for /;
    my ($cmd,$desc) = "$pod".split('--');
    next unless $desc;
    my $line = $pod.WHEREFORE.?line;
    my $file = $pod.WHEREFORE.?file;
    $file = Nil if $file && $file ~~ /precomp/;
    if !$file && $?FILE.words[0].IO.e {
      state @lines = $?FILE.words[0].IO.lines;
      with @lines.first(:k, {.contains("$pod")}) {
        $file = $?FILE;
        $line = $_;
      }
    }
    @help.push: { text => sprintf("     \\%-30s %s",$cmd.trim,$desc.trim),
                  file => $file,
                  line => $line,
                  cmd => $cmd.trim,
                  desc => $desc.trim,
                }
  }
  for self.^methods -> $m {
    next unless $m.name ~~ /^ <[a..z]>/;
    next if $for && $m.name !~~ / $for /;
    unless $m.WHY {
      # note "No docs for {$m.name}";
      next;
    }
    my $desc = $m.WHY.Str.trim;
    my $args = '';
    if $desc ~~ /^ $<args>=[.*] '--' $<desc>=[.*] $/ {
      $args = " {$<args>.trim}";
      $desc = $<desc>.trim;
    }
    @help.push: { text => sprintf("     \\%-30s %s",$m.name.trim ~ $args,$desc),
                  file => $m.?file,
                  line => $m.?line,
                  cmd => $m.name.trim,
                  desc => $desc.trim,
    }
  }
  @help;
}

method execute($str) is export {
  if $str ~~ /^ \\ $<rest>=[.*] $ / {
    self.run-meta("$<rest>");
  } else {
    sendit($str);
  }
}

my $grabfile = "/tmp/grabbed".IO;

my @commands = <shell grep pwd eof clr append show scripts edit aliases await enq repeat alias>;

method run-meta($meta) is export {
  return unless $meta.words[0];
  my $cmd = $meta.words[0];
  given $cmd {
    when 'grab' {
      #= grab the next line after running a command, and save it to a file
      my $line;
      my ($window,$pane) = ($*window,$*pane);
      my $p = start react whenever output-stream(:$window,:$pane,:buffer<lines>,:new) -> $l {
        $line = $l;
        done if ++$ > 2;
      }
      sendit($meta.subst('grab ',''), :newline);
      await $p;
      $grabfile.spurt: $line;
      note "wrote { $line.chars } chars to $grabfile";
    }
    when 'set' {
      #= set <var> <value> -- set a variable for inline replacement
      $meta ~~ /^ set \s+ $<var>=[\w+] \s+ $<rest>=[.*] $/;
      return note "bad options for set" without $<rest>;
      %*vars{ "$<var>" } = "$<rest>";
      debug "set $<var> to $<rest>";
    }
    when @commands.any {
      my $c = $meta.words[0];
      try self."$c"($meta, |($meta.words[1..*].map({ val($^x) })));
      with $! -> $err is copy {
        $err = $err.Str.lines[0].trans(:g, / $<num>=[\d+] / => -> { $<num> - 2 }) if $err ~~ /'Too ' [few|many]/;
        say "Error: $err";
        if self.^find_method($c) -> $method {
          my $why = $method.WHY.Str;
          my $args = '';
          if $why ~~ s/^^ $<args>=[.*] '--'// {
            $args = " $<args>";
          }
          say "usage: $c$args -- " ~ $why;
        }
      }
    }
    when 'trace' {
      #= trace -- set log level to trace
      logger.close-taps;
      logger.send-to($*ERR, :level( * >= TRACE));
    }
    when 'debug' {
      #= debug -- set log level to debug
      logger.close-taps;
      logger.send-to($*ERR, :level( * >= DEBUG));
    }
    when 'info' {
      #= info -- set log level to info
      logger.close-taps;
      logger.send-to($*ERR, :level( * >= INFO));
    }
    when 'capture' {
      #= capture <file> -- write to <file>
      my $file = $meta.words[1] or return note 'missing filename';
      unless $file ~~ /^ '/' / {
        $file = $*CWD.child($file);
      }
      note "Writing output to $file";
      tmux-start-pipe(:$*window, :$*pane, :$file);
    }
    when 'stop' {
      #= stop -- send ^C to the current pane
      #= stop <id> ... -- send ^C to panes
      if $meta.words > 1 {
        for $meta.words[1..*] -> $pane {
          sendit("\x3", :!newline, :$pane);
        }
      } else {
        sendit("\x3", :!newline);
      }
    }
    when 'close' {
      #= close -- kill the current pane
      return note "close multiple panes not implemented" if $*pane ~~ List;
      tmux-kill-pane(:$*window,:$*pane);
      $*pane-- if $*pane > 0;
      say "sending to $*pane";
      tmux-show;
    }
    when 'split' {
      #= split -- split current pane
      return note "split multiple panes not implemented" if $*pane ~~ List;
      tmux-split(:$*window,:$*pane);
      $*pane++;
    }
    when 'even' {
      #= even -- split layout vertically evenly
      tmux-even;
    }
    when 'small' {
      #= small -- make the command pane small
      tmux-small;
    }
    when 'panes' {
      #= panes -- list panes
      tmux-list.lines.classify:
      { <others current>[so /active/] },
          into => my %panes,
          as => { / <( \d+ )> ':' /; "$/" };
      say %panes;
      say "sending to $*window.$*pane";
      shell "tmux display-panes -d 0";
      get;
    }
    when 'select' {
      #= select <id> -- send to pane <id> instead
      #= select <id> <id> -- send to two panes
      my @words = $meta.words[1..*];
      if @words > 1 {
        $*pane = @words.map: { + $_ }
      } else {
        $*pane = + @words[0];
      }
      say "now sending to window($*window), pane($*pane)";
    }
    when 'run' {
      #= run <script> -- Run a script
      my $script = $meta.words[1];
      trace "running $script";
      $script = $script-dir.child($script) unless $script.IO.f;
      $script.IO.f or return note "no such file: $script";
      my $tester = tmeta::tester.new;
      trace "running {$script.IO.absolute}";
      self.run-script($script, :$tester);
      $tester.report;
    }
    when 'find' {
      #= find <phrase> -- Find commands in the history.
      my $what = arg($meta);
      my $proc = run <<fzf --bind 'j:down,k:up' -e --no-sort --layout=reverse -q "$what">>, :in, :out;
      $proc.in.put($_) for $*log-file.IO.slurp.lines.reverse.unique;
      my $send = $proc.out.get or return;
      confirm-send($send, :add-to-history);
    }
    when 'uni' {
      #= uni <text> -- Look up unicode character to output
      my $what = arg($meta);
      state $chars = (0..0x1ffff).map({chr($_) ~ ' ' ~ uniname(chr($_))});
      my $proc = run <<fzf --bind 'j:down,k:up' --no-sort --layout=reverse -q "$what">>, :in, :out;
      $proc.in.put($_) for $chars.grep: { .fc.contains($what.fc) }
      my $send = $proc.out.slurp(:close) or return;
      my $first = $send.comb[0];
      say $first;
      sendit($first, :!newline);
    }
    when 'last'|'l' {
      #= last [n] -- show last n (or 10) commands (see alias)
      my $count = arg($meta) || 10;
      my @list = @*history.tail($count);
      @*shown = @list;
      my $i = 0;
      for @list -> $s {
        say ++$i ~ ') ' ~ $s;
      }
    }
    when 'dump' {
      #= dump <n> -- dump n (or 3000) lines of output to a file
      my $lines = $meta.words[1] // 3000;
      return note "dump [n] -- where n is the number of lines" unless $lines ~~ Int || val($lines) ~~ Int;
      tmux-dump(:$*window,:$*pane,:$lines);
      say "wrote last $lines lines from pane $*window.$*pane to /tmp/out";
    }
    when 'ls'  {
      #= ls <opts> -- run ls in this pane
      shell($meta)
    }
    when 'cd' {
      #= cd -- change local working dir
      my $where = $meta.words[1] // $*HOME;
      chdir $where or say "failed to change to $where";
    }
    when /^ $<id>=[\d+] $/ {
      #= n -- run command in item number n
      return note 'no options' unless @*shown;
      confirm-send(@*shown[+$<id> - 1])
    }
    when 'send' {
      #= send <file> -- send a file
      my $file = $meta.words[1];
      return note "can't open $file" unless $file.IO.e;
      confirm-send( $file.IO.slurp , :big);
    }
    when 'do' {
      #= do -- run a (not-shell) command and send the output slowly
      my @prog = $meta.words[1..*];
      say "running { @prog.join(' ') }";
      try {
        my $proc = Proc::Async.new(|@prog);
        my $out = $proc.stdout.lines;
        my $p = $proc.start;
        my $pane = $*pane;
        my $window = $*window;
        react whenever $out -> $str {
          say "sending $str";
          sendit($str, newline => True, :nostore, :$pane, :$window);
          sleep 1;
        }
        await $p;
      }
      .Str.say with $!;
    }
    when 'xfer' {
      #= xfer [filename] -- send a file or directory to the remote console
      # see http://www.perladvent.org/2019/2019-12-20.html 
      my $filename = arg($meta);
      $filename.IO.e or return note "$filename does not exist";
      say "sending $filename";
      sendit("stty -echo", newline => True, :nostore);
      sendit("base64 --decode | tar xzf -");
      my $proc = shell "tar czf - $filename | base64 -b 72", :out;
      shell "tput civis";
      react whenever $proc.out.lines -> $l {
        print "\r      \r  " ~ ++$ ~ "      \r";
        sendit($l, newline => True, :nostore);
      }
      print "                 \n";
      shell "tput cnorm";
      self.eof;
      sendit("stty echo", newline => True, :nostore);
    }
    when 'dosh' {
      #= dosh -- run a shell command and send the output (text mode, line at a time)
      my $prog = arg($meta);
      say "running $prog";
      my $proc = shell($prog, :out);
      my $out = $proc.out;
      react whenever $out.lines -> $str {
        my $pane = $*pane;
        my $window = $*window;
        sendit($str, newline => True, :nostore, :$pane, :$window);
        print "\r      \r" ~ ++$ ~ "      \r";
      }
    }
    when 'clear' {
      #= clear -- clear this pane
      shell 'tput clear';
    }
    when 'help'|'h' {
      #= help -- this help
      my $for = $meta.words[1];
      my @help = self.generate-help($for).map({.<text>});
      my ($rows,$cols) = qx{stty size}.split(' ');
      for @help.grep({ .words[0] ne '\\script' } ).sort -> $l {
        if ++$ %% $rows {
          prompt 'press return for more >';
          shell 'tput clear';
        }
        put $l;
      }
    }
    when 'delay' {
      #= delay [num] -- set the delay between sending lines
      return say $*delay without $meta.words[1];
      $*delay = val($meta.words[1])
    }
    when 'newlines' {
      #= newlines [on|off] -- turn on or off always sending a newline
      if arg($meta) -> $setting { $*newlines = ($setting eq 'on') }
      note 'sending newlines is ' ~ ( $*newlines ?? 'on' !! 'off' );
    }
    when 'timing' {
      #= timing [on|off] -- turn on or off showing times in the prompt
      if arg($meta) -> $setting { $*timing = ($setting eq 'on') }
      note 'showing timing is ' ~ ( $*timing ?? 'on' !! 'off' );
    }
    when 'watch' {
      #= watch -- start watching the current window+pane by piping to a file
      my $file = tmux-start-pipe(:$*window,:$*pane);
      note "piping $*window:$*pane to $file";
    }
    when 'unwatch' {
      #= unwatch -- stop watching the current window+pane
      tmux-stop-pipe(:$*window,:$*pane);
      note "stopped watching $*window:$*pane";
    }
    when 'sleep' {
      #= sleep X -- sleep for X seconds
      sleep arg($meta) // 1
    }
    default {
      say "unknown command $_";
    }
  }
}

sub confirm-send($str, Bool :$big, Bool :$add-to-history = False) {
  print "~> ";
  if $big {
    say $str
  } else {
    put $str;
  }
  my $ok = prompt " [q to abort, e to edit (from history)]>";
  $*readline.add-history($str) if $ok ~~ /:i e/;
  return if $ok ~~ /:i [ q | e ]/;
  if ($big) {
    for $str.lines -> $l {
      sendit($l, :nostore);
      sleep $*delay;
    }
  } else {
    sendit($str);
  }
  if $add-to-history {
    $*readline.add-history($str);
  }
}

sub send-capture($key, Channel $captured, :$newline) {
  debug "ready to send $key";
  my $msg;
  loop {
    debug "waiting for $key";
    $msg = $captured.receive;
    last if $msg{$key}:exists;
  }
  debug "got " ~ $msg{$key};
  sendit( ~$msg{$key}, :$newline );
}

method run-script-command($cmd, :$waiter, :$tester, :$script, :$captured, :@commands, :$i) {
  my @cmd = $cmd.words;
  given @cmd[0] {
    when 'run' {
      #= script run <name> -- run another script in the same directory
      my $target = @cmd[1];
      my $new = $script.IO.sibling($target);
      $new.IO.e or return $tester.failed("Cannot open $new");
      debug "running $new";
      self.run-script($new, :$tester); 
    }
    when 'color' {
      #= script color [on|off] -- turn off color (i.e. filter out ansi escapes)
      $*color = @cmd[1];
    }
    when 'buffer' {
      #= script buffer [lines|none] -- turn on line buffering
      $*buffer = @cmd[1];
    }
    when 'trace' {
      #= script trace [off|on] -- turn on tracing
      $*trace = @cmd[1];
    }
    when 'pause' {
      #= script pause <msg>-- show msg or 'press return to continue'
      my $msg = $cmd.subst('pause','').trim;
      sleep 0.3;
      my $got = prompt ($msg || "press return to continue (q to abort):");
      fail "aborted" if $got.trim eq 'q';
    }
    when 'wait' {
      { #=( script wait for <regex> -- wait for a regex immediately ) }
      { #=( script wait <delay> <regex> -- wait after <delay> more steps for a regex ) }
      { #=( script wait begin <regex> -- wait for a regex until we see an end ) }
      { #=( script wait end -- end a wait begin ) }
      trace "found a wait";
      my $what = $cmd.subst(
        /^ 'wait ' [
              | 'for'
              | $<begin>='begin'
              | $<end>='end'
              | $<steps>=[\d+]
            ] /,'').trim;
      my $steps = +( $<steps> // 0 );
      return 0 if $<end>;
      if $<begin> {
        trace "Finding matching end for begin on line $i";
        my $end = @commands[$i..*].first: :k, * eq '\\wait end'
            or exit note "Could not find matching end for begin around line $i";
        $steps = $end - 1;
        trace "Setting countdown to $steps";
      }
      $waiter.what = $what;
      trace "calling wait_for";
      $waiter.promise = wait_for( $what, $captured, from => output-stream );
      trace "done";
      $waiter.countdown = +$steps;
    }
    when 'send' {
      { #=( script send -- send a file, abort if it cannot be sent.) }
      my $what = @cmd[1];
      $what.IO.e or return $tester.failed("could not open $what");
      sendit($what.IO.slurp, :nostore);
      $tester.passed("send $what");
    }
    when 'done' {
      { #=( script done -- indicate that the script is done ) }
      note "Done!";
      $tester.report;
    }
    when 'timeout' {
      #= script timeout -- set a timeout
      $*timeout = val(@cmd[1]);
      $waiter.timeout = +$*timeout;
    }
    when 'emit' {
      #= script emit -- emit a value matched in a wait regex
      my $newline = True;
      $newline = False if @cmd[2] and @cmd[2] eq '...';
      send-capture(@cmd[1], $captured, :$newline);
    }
    default {
      self.run-meta($cmd);
    }
  }
  return 0;
}

sub reorder(@commands) {
  my @indexes = @commands.grep( { / ^ '\\expect ' / }, :k);
  for @indexes -> $k {
    trace "Converting expect (line $k) to wait";
    @commands.splice( $k-1, 2,
         ["\\wait 1 { @commands[$k].subst('\\expect ','') }",
         @commands[$k-1]]
       );
  }
}

sub has-content($str) {
  return False if $str ~~ /^ \s* '#'/;
  return so $str ~~ /\S/;
}

method run-script($script, :$tester) is export {
  my @commands = $script.IO.lines.grep({has-content($_)});
  my $waiter = tmeta::waiter.new(timeout => +$*timeout);
  my Channel $captured .= new;
  reorder(@commands);
  my $run-ahead = 0;
  for @commands.kv -> $i, $cmd is copy {
    next unless has-content($cmd);
    debug "$cmd";
    note "# --> $cmd" if $*trace eq 'on';
    replace-aliases($cmd);
    replace-vars($cmd);
    if $cmd ~~ / ^ '\\' $<rest>=[.*] $ / {
      self.run-script-command("$<rest>",
        :$waiter,
        :$tester,
        :$script,
        :$captured,
        :@commands,
        :$i) orelse .exception.note && return;
    } else {
      sendit($cmd, :nostore);
      $waiter.decrement;
    }
    with $waiter.maybe-wait {
      $tester.tested($_, $waiter.desc);
      $waiter = $waiter.new(timeout => +$*timeout);
    }
    if $tester.fails and $tester.bail-on-fail {
      error "Test failed, bailing out";
      return;
    }
    sleep $*delay;
  }
}

sub replace-aliases($str is rw) is export {
  trace "expanding alias $str";
  my @aliases = keys %*aliases;
  while $str ~~ /^ \\ $<meta> = [ [ @aliases <?before \s> ] || [ .* $ ] ] / {

    trace "meta command: '$str', will be: $<meta>";

    if %*aliases{ "$<meta>" } -> $a {
      my $got = "$<meta>";
      trace "replacing $got with $a";
      $str = $str.subst( / \\ "$got" / , $a );
      next;
    }

    # meta that is not an alias
    last if $str ~~ /^ \\ $<meta> = [ .* ] $ /;
  }
}

sub replace-vars($str is rw) is export {
  $str ~~ s:g/ \\ '=' $<name>=[\w+] /{ %*vars{ "$<name>" } // fail "undefined variable '$<name>'" }/;
}

