unit role termie::commander::godot;
use termie::utils;
use termie::tmux;
use termie::actions;

# handles await-ey things

my $queued;
my %repeating;

#| [regex] -- await the appearance of regex in the output, then stop a repeat
method await($meta, Str $what) {
  my $regex = eval-regex($meta.subst(/^ 'await' \s+ /,''));
  say "Waiting for " ~ $regex.raku;
  if $queued {
    say "Then I will send:";
    say $queued;
  }
  if $*pane ~~ List {
    note "await on multiple panes not implemented";
    return;
  }
  react whenever output-stream(:$*window,:$*pane) -> $l {
    done if $regex ~~ Str and $l ~~ / $regex /;
    done if $l ~~ $regex;
  }
  note "Done: saw " ~ $regex.raku;
  my $id = "$*window.$*pane";
  with %repeating{$id} -> $repeating {
    say "stopping $id";
    $repeating.close;
  }
  if $queued {
    say "starting enqueued command: $queued";
    self.execute($queued);
  } else {
    say "nothing queued";
  }
}

#| <command> -- Enqueue a command for await (or "clear" to clear the queue).
method enq($meta, |rest) {
  my $what = $meta.subst( / ^enq \s+ /,'');
  $queued = $what if $what;
  $queued = Nil if $what eq 'clear';
  note "queue is now : " ~ ($queued || '(empty)');
}

#| <N> <M> | <stop> -- repeat the last M commands every N seconds (or stop a repeat)
method repeat($meta, $n?, $m?, $how?) {
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

