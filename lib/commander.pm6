unit class commander;

use commander::shellish;
also does commander::shellish;

use tester;
use actions;

our $script-dir is export = $*HOME.child('.tmeta').child('scripts');

#| <n> <file> -- append nth shown item to script <file>
method append($meta, Int $n, Str $file) {
  $script-dir.child($file).IO.open(:a).say(@*shown[$n - 1]);
}

#| show contents of a script
method show($meta, Str $name) {
  my $file = $script-dir.child($name).IO;
  say "$file:";
  $file.IO.e or return note "could not open $file";
  say ($file.slurp || "$file is empty");
}

#| show scripts in script library
method scripts($meta) {
  shell "ls $script-dir";
}

#| edit a file (default /tmp/buffer)
method edit($meta, $name is copy = '/tmp/buffer') {
  $name = $script-dir.child($name) unless $name.IO.is-absolute;
  my $ed = %*ENV<EDITOR> // 'vim';
  my $ok = shell "$ed $name";
}

#| [<str>] -- show aliases [containing a string]
proto method aliases(|) {*}
multi method aliases($meta, $str = "") {
  for %*aliases.pairs.sort {
    next if $str && (not .key.contains($str) and not .value.contains($str));
    say .key ~ ':';
    say .value.indent(4);
  }
}
