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

#| show the last n entries
multi method show-last(Int:D $n, Str $meta) {
  show(@*history.unique.tail($n).reverse);
}

#| show last 10 entries containing string
multi method show-last(Str:D $str, Str $meta) {
  show(@*history.unique.grep({.contains($str)}).tail(10).reverse);
}

#| show the last 10 entries
multi method show-last(Nil, Str $meta) {
  self.show-last(10, $meta)
}

