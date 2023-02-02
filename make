#!/usr/bin/env raku

if %*ENV<VERBOSE> {
  &shell.wrap: -> |c { say c.raku; callsame; }
  &QX.wrap: -> |c { say c.raku; callsame; }
}

my $module = 'App::termie';
my $version = q:x[jq -r .version META6.json].trim or exit note 'no version';

multi MAIN('test') {
  shell "TEST_AUTHOR=1 prove -e 'raku -Ilib' t/*";
}

sub make-dist($version) {
  my $out = "tar/{$module}-{$version}.tar.gz";
  shell qq:to/SH/;
    echo "Making $version";
    mkdir -p tar
    git archive --prefix={$module}-{$version}/ -o $out {$version}
    SH
  say "wrote $out";
}

sub update-changes($version, $next) {
  "/tmp/changes".IO.spurt: $next ~ ' ' ~ now.Date.yyyy-mm-dd ~ "\n\n";
  shell "git log --format=full $version...HEAD >> /tmp/changes"; 
  shell "echo >> /tmp/changes";
  shell "cat Changes >> /tmp/changes && mv /tmp/changes Changes";
  shell "nvim Changes";
}

multi MAIN('docs') {
  shell q:to/SH/;
    script/gen-docs
    SH
}

multi MAIN('bumpdist') {
  shell "zef test .";
  my $next = qq:x[raku -e '"$version".split(".") >>+>> <0 0 1> ==> join(".") ==> say()'].trim;
  say "$version -> $next";
  exit note "no next version" unless $next;
  shell qq:to/SH/;
    perl -p -i -e "s/{$version}/{$next}/" META6.json bin/termie
    SH
  update-changes($version,$next);  
  shell "git commit -am$next";
  shell "git tag $next";
  make-dist($next);
}

multi MAIN('clean') {
  shell 'rm -f dist/*.tar.gz';
}

