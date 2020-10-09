unit module tmeta::tmux;
use Log::Async;

sub tmux-list is export {
  qx{tmux list-panes}
}

sub restart-using-protocol {
  my $tmux = Proc::Async.new: :w, <tmux -C>;
  $tmux.stdout.lines.tap: -> $l { }
  my $promise = $tmux.start;
  $tmux.put: "split $*PROGRAM";
  shell "tmux attach-session";
  await $promise;
  say "bye!";
}

sub set-up-tmux is export {
  without %*ENV<TMUX> {
    restart-using-protocol;
    exit;
  }
  my @panes = qx{tmux list-panes}.lines.grep: { not /active/ }
  shell 'tmux split-window -b -d' unless @panes > 0;
  @panes = qx{tmux list-panes}.lines.grep:{ not /active/ }
  $*pane = +( @panes[0] ~~ / <( \d+ )> ':' / );
  my @windows = qx{tmux list-windows}.lines.grep:{ /active/ }
  $*window = ~( @windows[0] ~~ / <( '@' \d+ )> \s* '(active)' / );
}

my %pipe-files;
sub tmux-stop-pipe(:$window = $*window, :$pane = $*pane) is export {
  shell "tmux pipe-pane -t $*window.$*pane";
  %pipe-files{ "$*window:$*pane" } = Nil
}

sub tmux-start-pipe(:$window,:$pane,:$file is copy) is export {
  .return with %pipe-files{ "$window:$pane" };
  $file //= "/tmp/tmux-buffer-{$window}-{$pane}-{$*PID}-{now.Int}";
  %pipe-files{ "$window:$pane" } = $file;
  shell "tmux pipe-pane -t $window.$pane 'cat >> $file'";
  trace "creating output stream for $file";
  $file;
}

sub tail($file --> Supply) is export {
  sleep 0.1;
  $file.IO.e or die "cannot tail -- no such file $file";
  supply {
    my $in = $file.IO.open;
    $in.seek(0, SeekFromEnd);
    my $start = $in.read.decode;
    my $last = $in.tell;
    whenever $file.IO.watch -> $e {
      trace "got event $e";
      $in.seek($last) if $last;
      emit $in.read.decode;
      $last = $in.tell;
    }
  }
}

sub output-stream(:$window = $*window, :$pane = $*pane, :$buffer = $*buffer) is export {
  # some consoles (*cough* rails *cough*) send ansi sequences instead of newlines
  # down is 'esc [ 1 B', beginning of line is 'esc [ 0 G'
  my $nl = "\x[1B][1B\x[1B][0G";
  my $file = tmux-start-pipe(:$window,:$pane);
  return tail($file) unless $buffer eq 'lines';
  return supply {
    whenever tail($file).lines -> $line {
      for $line.split(/$nl/) -> $piece {
        emit $piece
      }
    }
  }
}

sub tmux-kill-pane(:$window,:$pane) is export {
  shell "tmux kill-pane -t $window.$pane";
}

sub tmux-split(:$window,:$pane) is export {
  shell "tmux split-window -t $window.$pane -d";
}

sub tmux-even is export {
  shell "tmux select-layout even-vertical";
}

sub tmux-small is export {
  shell "tmux resize-pane -y 10";
}

sub tmux-show is export {
  shell "tmux display-panes";
}

sub tmux-dump(:$window,:$pane,:$lines) is export {
  shell "tmux capture-pane -t $*window.$*pane -S -$lines -p > /tmp/out";
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

sub send-by-char($send,$window,$pane) {
  run <<tmux send-keys -t "$window.$pane" -l>>, |($send.comb.map({ S:g/';'/\\;/ }));
}


