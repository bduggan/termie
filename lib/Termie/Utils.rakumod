unit module Termie::Utils;

sub arg($cmd) is export {
  my $wd = $cmd.words[0];
  return $cmd.subst($wd,'').trim;
}

