unit class tmeta::commander;

use tmeta::commander::shellish;
use tmeta::commander::godot;
also does tmeta::commander::shellish;
also does tmeta::commander::godot;

use tmeta::tester;
use tmeta::actions;

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
  $script-dir.IO.e or return note "no scripts ($script-dir)";
  shell "ls $script-dir";
}

#| edit a file (default /tmp/buffer)
method edit($meta, $name is copy = '/tmp/buffer') {
  $script-dir.IO.d or mkdir $script-dir;
  $name = $script-dir.child($name) unless $name.IO.is-absolute;
  my $ed = %*ENV<EDITOR> // 'vim';
  my $ok = shell "$ed $name";
}

#| <str> -- show aliases [containing a string]
proto method aliases(|) {*}
multi method aliases($meta, $str = "") {
  for %*aliases.pairs.sort {
    next if $str && (not .key.contains($str) and not .value.contains($str));
    say .key ~ ':';
    say .value.indent(4);
  }
}

#| <key> [<n> | <str>] show alias key, or set it to a str or history item
proto method alias(|) {*}
multi method alias($meta) {
  note 'aliases: ' ~ %*aliases.keys.sort.join(' ');
}
multi method alias($meta, $key) {
  note %*aliases{ $key } // 'no such alias';
}
multi method alias($meta, $key, Str $n where /^\d+$/ ) {
  my $str = @*shown[$n - 1];
  %*aliases{ $key } = $str;
  $*alias-file.spurt: join "\n", %*aliases.kv.map: { join ': ', $^key, $^value.perl }
}
multi method alias($meta, $key, |) {
  %*aliases{ $key } = $meta.subst(/^ \s* alias \s* $key /,'').trim;
  $*alias-file.spurt: join "\n", %*aliases.kv.map: { join ': ', $^key, $^value.perl }
}

