unit class boda::tester;

has $.count = 0;
has $.passes = 0;
has $.fails = 0;
has $.bail-on-fail = True;

method failed($desc) {
  $!fails++;
  $!count++;
  put "not ok $.count - $desc";
}

method passed($desc) {
  $!passes++;
  $!count++;
  put "ok $.count - $desc";
}

method tested(Bool $status, $desc) {
  if $status {
    self.passed($desc)
  } else {
    self.failed($desc)
  }
}

method complete {
  put "1..$.count"
}

method report {
  return note "no tests" unless $.count;
  note "$.count tests, $.passes passed, $.fails failed";
  if $.fails {
    note "FAIL";
  } else {
    note "PASS";
  }
}
