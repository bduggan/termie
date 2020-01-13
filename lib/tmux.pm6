unit module tmux;
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

sub tmux-stop-pipe is export {
  shell "tmux pipe-pane -t $*window.$*pane";
}

sub tmux-start-pipe(:$window,:$pane,:$file is copy) is export {
  $file //= "/tmp/tmux-buffer-{$window}-{$pane}-{$*PID}-{now.Int}";
  shell "tmux pipe-pane -t $window.$pane 'cat >> $file'";
  trace "creating output stream for $file";
  $file;
}

sub tail($file --> Supply) is export {
  if $*PERL.compiler.version ~~ v2019.07.* {
    # See rakudo#3100 on github
    my $proc = Proc::Async.new(<<tail -f $file>>);
    my $supply = $proc.stdout;
    $proc.start;
    return supply {
      whenever $supply { .emit }
      CLOSE {
        trace "stopping tail";
        $proc.kill;
      }
      QUIT {
        trace "stopping tail";
        $proc.kill;
      }
    }
  }
  sleep 0.1;
  $file.IO.e or die "cannot tail -- no such file $file";
  supply {
    my $in = $file.IO.open;
    emit $in.read.decode;
    my $last = $in.tell;
    whenever $file.IO.watch -> $e {
      $in.seek($last) if $last;
      emit $in.read.decode;
      $last = $in.tell;
    }
  }
}

sub output-stream(:$window = $*window, :$pane = $*pane) is export {
  my $file = tmux-start-pipe(:$window,:$pane);
  return tail($file).lines if $*buffer eq 'lines';
  tail($file);
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


