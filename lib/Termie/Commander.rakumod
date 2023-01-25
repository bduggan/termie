unit class Termie::Commander;

use Termie::Commander::Shellish;
use Termie::Commander::Godot;
also does Termie::Commander::Shellish;
also does Termie::Commander::Godot;

use Termie::Tester;
use Termie::Actions;

our $script-dir is export = $*HOME.child('.termie').child('scripts');

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

#| show scripts in script library, optionally search for a name
method scripts($meta, $name = '') {
  $script-dir.IO.e or return note "no scripts ($script-dir)";
  if $name {
    return shell "ls $script-dir | grep $name || true";
  }
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
  $*alias-file.spurt: join "\n", %*aliases.kv.map: { join ': ', $^key, $^value.raku }
}
multi method alias($meta, $key, |) {
  %*aliases{ $key } = $meta.subst(/^ \s* alias \s* $key /,'').trim;
  $*alias-file.spurt: join "\n", %*aliases.kv.map: { join ': ', $^key, $^value.raku }
}

