unit class commander;

use commander::shellish;
also does commander::shellish;

use tester;
use actions;

our $script-dir is export = $*HOME.child('.metaterm').child('scripts');

#| <n> <file> -- append nth shown item to script <file>
method append($meta) {
  my $n = $meta.words[1];
  val($n) ~~ Int or return note "append <n> <file>";
  my $file = $meta.words[2] or return note 'missing file';
  $script-dir.child($file).IO.open(:a).say(@*shown[$n - 1]);
}

#| show contents of a script
method show($meta) {
  my $name = $meta.words[1] or return note 'no name';
  my $file = $script-dir.child($name).IO;
  $file.IO.e or return note "could not open $file";
  say $file.slurp;
}

#| show scripts in script library
method scripts($meta) {
  shell "ls $script-dir";
}

#| edit a file (default /tmp/buffer)
method edit($meta) {
  my $name = '/tmp/buffer';
  with $meta.words[1] {
    $name = $script-dir.child($_);
  }
  my $ok = shell "vi $name";
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

