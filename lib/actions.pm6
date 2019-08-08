unit module actions;
use Log::Async;
use tmux;

sub strip-color(Supply $s --> Supply) {
  supply {
    whenever $s -> $line is copy {
        $line ~~ s:g/ \x1b '[' <[0..9;]>* <[a..zA..Z]> //;
        emit($line);
    }
  }
}

sub eval-regex(Str $in) is export {
  given $in {
    when / ^ '/' / {
      use MONKEY-SEE-NO-EVAL;
      EVAL $_;
    }
    default {
      $_;
    }
  }
}

sub wait_for(Str $what, Channel $captured, Supply :$from --> Promise) is export {
  state %evaled;
  %evaled{ $what } //= eval-regex($what);
  my $target = %evaled{ $what };
  my $buffer-method = $*buffer;
  trace "starting wait_for thread";
  start {
    my $buffer;
    react whenever $from -> $l {
      trace "considering : " ~ $l.perl;
      given $buffer-method {
        when 'none' { $buffer ~= $l }
        when 'lines' { $buffer = $l }
        default {
          exit note "unknown buffer method $buffer-method";
        }
      }
      trace "buffer is " ~ $buffer.perl;
      if $target ~~ Str and $buffer.contains($target) {
        debug "contains match: for {$what.perl}: {$buffer.perl}";
        done;
      }
      if $buffer and $buffer ~~ $target {
        debug "match: for {$what.perl}: {$buffer.perl}";
        my $m = $/.clone;
        trace "captured " ~ ( $m.gist.subst(/\n/,',',:g) );
        $captured.send: $m;
        done;
      }
      trace "no match { $buffer.gist } vs { $target.gist }";
      LAST { tmux-stop-pipe }
      QUIT { say "QUIT"; tmux-stop-pipe; }
    }
  }
}

sub show(@list) is export {
  @*shown = @list;
  my $i = 0;
  for @list -> $s {
    say ++$i ~ ') ' ~ $s;
  }
}

