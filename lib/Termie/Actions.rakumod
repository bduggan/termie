unit module Termie::Actions;
use Log::Async;
use Termie::Tmux;

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
      trace "considering : " ~ $l.raku;
      given $buffer-method {
        when 'none' { $buffer ~= $l }
        when 'lines' { $buffer = $l }
        default {
          exit note "unknown buffer method $buffer-method";
        }
      }
      trace "buffer is " ~ $buffer.raku;
      given $target {
        when Str {
          if $buffer.contains($target) {
            debug "contains match: for {$what.raku}: {$buffer.raku}";
            done;
          }
        }
        when Regex {
          if $buffer ~~ $target {
            debug "match: for {$what.raku}: {$buffer.raku}";
            my $m = $/.clone;
            trace "captured " ~ ( $m.gist.subst(/\n/,',',:g) );
            $captured.send: $m;
            done;
          }
        }
      }
      trace "no match { $buffer.gist } vs { $target.gist }";
      LAST { tmux-stop-pipe }
      QUIT { say "QUIT"; tmux-stop-pipe; }
    }
  }
}


