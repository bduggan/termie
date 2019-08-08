unit class waiter;
use Log::Async;

has Promise $.promise is rw;
has Int $.countdown is rw = 0;
has Numeric $.timeout is rw = 5;
has $.what is rw = 'something';

method desc {
  "waited for $.what"
}

method decrement {
  return unless $.countdown;
  $!countdown--;
}

method maybe-wait { 
  return Nil without $.promise;
  return Nil if $.countdown;
  trace "waiter will wait for " ~ $.what ~ " for $.timeout seconds";
  my $p = $.promise;
  my $timer = Promise.in($.timeout)
      .then({
        unless $p {
          debug "# timeout ($.timeout seconds)";
        }
      });
  trace "starting await";
  await Promise.anyof($timer,$.promise);
  return so $p.status == Kept;
}

