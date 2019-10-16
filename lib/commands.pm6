unit module commands;
use Log::Async;
use actions;
use waiter;
use tester;
use commander;
use tmux;

sub arg($cmd) {
  my $wd = $cmd.words[0];
  return $cmd.subst($wd,'').trim;
}

sub generate-help($for = Nil) is export {
  my @help;
  for $=pod<>.sort -> $pod {
    next if $for && $pod !~~ / $for /;
    my ($cmd,$desc) = "$pod".split('--');
    next unless $desc;
    @help.push: { text => sprintf("     \\%-30s %s",$cmd.trim,$desc.trim),
                  file => $pod.WHEREFORE.?file,
                  line => $pod.WHEREFORE.?line,
                  cmd => $cmd.trim,
                  desc => $desc.trim,
                }
  }
  for commander.^methods -> $m {
    next unless $m.name ~~ /^ <[a..z]>/;
    next if $for && $m.name !~~ / $for /;
    next note "No docs for {$m.name}" unless $m.WHY;
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

my %repeating;
sub run-meta($meta) is export {
  return unless $meta.words[0];
  my $cmd = $meta.words[0];
  given $cmd {
    when 'set' {
      #= set <var> <value> -- set a variable for inline replacement
      $meta ~~ /^ set \s+ $<var>=[\w+] \s+ $<rest>=[.*] $/;
      return note "bad options for set" without $<rest>;
      %*vars{ "$<var>" } = "$<rest>";
      debug "set $<var> to $<rest>";
    }
    when <shell grep pwd eof clr append show scripts edit>.any {
      my $c = $meta.words[0];
      try commander."$c"($meta, |($meta.words[1..*].map({ val($^x) })));
      with $! -> $err is copy {
        $err = $err.Str.lines[0].trans(:g, / $<num>=[\d+] / => -> { $<num> - 2 }) if $err ~~ /'Too ' [few|many]/;
        say "Error: $err";
        if commander.^find_method($c) -> $method {
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
    when 'await' {
      #= await [<str> | / <regex> /] -- await the appearance of regex in the output, then stop a repeat
      my $regex = $meta.words[1] or return note 'missing regex';
      $regex = eval-regex($meta.subst(/^ 'await' \s+ /,''));
      note "Waiting for " ~ $regex.perl;
      if $*pane ~~ List {
        note "await on multiple panes not implemented";
        return;
      }
      react whenever output-stream(:$*window,:$*pane) -> $l {
        done if $regex ~~ Str and $l ~~ / $regex /;
        done if $l ~~ $regex;
      }
      note "Done: saw " ~ $regex.perl;
      my $id = "$*window.$*pane";
      with %repeating{$id} -> $repeating {
        note "stopping $id";
        $repeating.close;
      }
    }
    when 'repeat' {
      { #=( repeat <N> -- repeat the last command every N seconds (default 5) ) }
      { #=( repeat <N> <M> -- repeat the last M commands every N seconds ) }
      { #=( repeat stop -- stop repeating (see await) ) }
      if ( ($meta.words[1] || '') eq 'stop') {
        my $key = $meta.words[2] || %repeating.keys.first;
        %repeating{ $key }:exists or return note "can't find $key";
        say "stopping $key";
        .close with %repeating{ $key }:delete;
      } else {
        my $interval = $meta.words[1] // 5;
        my $last = $meta.words[2] // 1;
        my @repeat = @*history[*-$last..*];
        return note "repeat on multiple panes not implemented" if $*pane ~~ List;
        my $pane = $*pane;
        my $window = $*window;
        my $newline = $*newlines;
        say "repeating (in $window.$pane) every $interval seconds: { @repeat.join(',') }";
        %repeating{"$window.$pane"} = Supply.interval($interval).tap: {
          for @repeat {
            sendit($_, :nostore, :$pane, :$window, :$newline);
            sleep 0.5;
          }
        }
      }
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
      $script = $script-dir.child($script) unless $script.IO.e;
      $script.IO.e or return note "can't find $script";
      my $tester = tester.new;
      run-script($script, :$tester);
      $tester.report;
    }
    when 'find' {
      #= find <phrase> -- Find commands in the history.
      my $what = arg($meta);
      my $proc = run <<fzf -e --no-sort --layout=reverse -q "$what">>, :in, :out;
      $proc.in.put($_) for $*log-file.IO.slurp.lines.reverse.unique;
      my $send = $proc.out.get or return;
      confirm-send($send);
    }
    when 'uni' {
      #= uni <text> -- Look up unicode character to output
      my $what = arg($meta);
      state $chars = (0..0x1ffff).map({chr($_) ~ ' ' ~ uniname(chr($_))});
      my $proc = run <<fzf --no-sort --layout=reverse -q "$what">>, :in, :out;
      $proc.in.put($_) for $chars.grep: { .fc.contains($what.fc) }
      my $send = $proc.out.slurp(:close) or return;
      my $first = $send.comb[0];
      say $first;
      sendit($first, :!newline);
    }
    when 'last'|'l' {
      commander.show-last($meta.words[1],$meta);
    }
    when 'dump' {
      #= dump <n> -- dump n (or 3000) lines of output to a file
      my $lines = $meta.words[1] // 3000;
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
    when 'send'|'s' {
      { #=( send|s <n> -- send item number n ) }
      { #=( send|s <file> -- send a file ) }
      my $which = $meta.words[1] // @*shown.elems;
      if val($which) ~~ Int {
        if $which.IO.e {
          return note "ambigous argument: $which is a file";
        }
        confirm-send(@*shown[$which - 1]);
      } else {
        my $file = $which;
        return note "can't open $file" unless $file.IO.e;
        my $contents = $file.IO.slurp;
        confirm-send($contents, :big);
      }
    }
    when 'do' {
      #= do -- run something and send the output
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
    when 'clear' {
      #= clear -- clear this pane
      shell 'tput clear';
    }
    when 'alias' {
      { #=( alias <key> -- show any alias associated with <key> ) }
      { #=( alias <key> <n> -- set <key> to item n from history (see \last) ) }
      { #=( alias <key> <str> -- alias <key> to <str> ) }
      my $key = $meta.words[1];
      my $id = $meta.words[2] or
        return note %*aliases{ $key } // 'no such alias';
      my $str =
        do if $id ~~ /^ \d+ $/ {
          @*shown[$id - 1];
        } else {
          $meta.words[2..*].join(' ');
        }
      note "saving $key = {$str.perl}";
      %*aliases{ $key } = $str;
      $*alias-file.spurt: join "\n", %*aliases.kv.map: { join ': ', $^key, $^value.perl }
    }
    when 'aliases' {
      #= aliases -- show aliases
      for %*aliases.pairs.sort {
        say .key ~ ':';
        say .value.indent(4);
      }
    }
    when 'help'|'h' {
      #= help -- this help
      my $for = $meta.words[1];
      my @help = generate-help($for).map({.<text>});
      my ($rows,$cols) = qx{stty size}.split(' ');
      shell 'tput clear';
      for @help.grep({ .words[0] ne '\\script' } ).sort -> $l {
        if ++$ %% $rows {
          prompt 'press return for more >';
          shell 'tput clear';
        }
        put $l;
      }
    }
    when 'greplines' {
      #= greplines [num] -- set between lines for \grep

    }
    when 'delay' {
      #= delay [num] -- set between lines to a (decimal) value
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

    default {
      say "unknown command $_";
    }
  }
}

sub confirm-send($str, Bool :$big) {
  print "~> ";
  if $big {
    say $str
  } else {
    print $str.perl;
  }
  my $ok = prompt " [q to abort]>";
  return if $ok ~~ /:i 'q'/;
  if ($big) {
    for $str.lines -> $l {
      sendit($l, :nostore);
      sleep $*delay;
    }
  } else {
    sendit($str);
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

sub send-by-char($send,$window,$pane) {
  run <<tmux send-keys -t "$window.$pane" -l>>, |($send.comb.map({ S:g/';'/\\;/ }));
}

sub sendit($str,
  Bool :$nostore = False,
  Bool :$newline = $*newlines,
  :$pane = $*pane,
  :$window = $*window,
) is export {
  add-to-history($str) unless $nostore;
  if $str ~~ /^ $<part> = [.*] '...' \s* $/ {
    my $part = "$<part>";
    for (@$pane) -> $pane {
      if $part ~~ /<[-'"\\;]>/ {
        send-by-char($part);
      } else {
        run <<tmux send-keys -t "$window.$pane" -l "$part">>;
      }
    }
    return;
  }
  my $send = $str;
  for (@$pane) -> $pane {
    trace "sending $send";
    if $send ~~ /<[-'"\\;]>/ {
      send-by-char($send,$window,$pane);
    } else {
      run <<tmux send-keys -t "$window.$pane" -l "$send">>;
    }
    run <<tmux send-keys -t "$window.$pane" enter>> if $newline;
  }
}


sub add-to-history($str) {
  @*history.push: $str.Str;
  $*log.put: ~$str if $*log;
}

sub run-script-command($cmd, :$waiter, :$tester, :$script, :$captured, :@commands, :$i) {
  my @cmd = $cmd.words;
  given @cmd[0] {
    when 'run' {
      my $target = @cmd[1];
      my $new = $script.IO.sibling($target);
      $new.IO.e or return $tester.failed("Cannot open $new");
      debug "running $new";
      run-script($new, :$tester); 
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
      my $what = @cmd[1];
      $what.IO.e or return $tester.failed("could not open $what");
      sendit($what.IO.slurp, :nostore);
      $tester.passed("send $what");
    }
    when 'done' {
      note "Done!";
      $tester.report;
    }
    when 'timeout' {
      #= script timeout -- set a timeout
      $*timeout = val(@cmd[1]);
      $waiter.timeout = +$*timeout;
    }
    when 'sleep' {
      #= script sleep X -- sleep for X seconds
      sleep +@cmd[1];
    }
    when 'emit' {
      #= script emit -- emit a value matched in a wait regex
      my $newline = True;
      $newline = False if @cmd[2] and @cmd[2] eq '...';
      send-capture(@cmd[1], $captured, :$newline);
    }
    default {
      run-meta($cmd);
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

sub run-script($script, :$tester) is export {
  my @commands = $script.IO.lines.grep({has-content($_)});
  my $waiter = waiter.new(timeout => +$*timeout);
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
      run-script-command("$<rest>",
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
  my @aliases = keys %*aliases;
  while $str ~~ /^ \\ $<meta> = [ [ @aliases <?before \s> ] || [ .* $ ] ] / {

    trace "meta command: '$str', will be: $<meta>";

    if %*aliases{ "$<meta>" } -> $a {
      trace "replacing $<meta> with $a";
      $str = $str.subst( / \\ "$<meta>" / , $a );
      next;
    }

    # meta that is not an alias
    last if $str ~~ /^ \\ $<meta> = [ .* ] $ /;
  }
}

sub replace-vars($str is rw) is export {
  $str ~~ s:g/ \\ '=' $<name>=[\w+] /{ %*vars{ "$<name>" } // fail "undefined variable '$<name>'" }/;
}

