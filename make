#!/usr/bin/env raku

constant $readme-src = "lib/App/termie.rakumod";
constant $github-repo = 'bduggan/termie';

if %*ENV<VERBOSE> {
  &shell.wrap: -> |c { say c.raku; callsame; }
  &QX.wrap: -> |c { say c.raku; callsame; }
}

my $module =  q:x[jq -r .name META6.json].trim.?subst('::','-',:g) or exit note 'no name';
my $version = q:x[jq -r .version META6.json].trim or exit note 'no version';

my $badges = qq:to/MD/;
 [![Actions Status](https://github.com/$github-repo/actions/workflows/linux.yml/badge.svg)](https://github.com/$github-repo/actions/workflows/linux.yml)
 [![Actions Status](https://github.com/$github-repo/actions/workflows/macos.yml/badge.svg)](https://github.com/$github-repo/actions/workflows/macos.yml)
 MD

multi MAIN('test', Bool :$v) {
  my $env = '';
  if $*DISTRO ~~ /macos/ {
    $env ~= 'DYLD_LIBRARY_PATH=. ';
  }

  shell "$env TEST_AUTHOR=1 prove {$v ?? '-v' !! ''} -e 'raku {$v ?? '--ll-exception' !! ''} -Ilib' t/*.rakutest";
}

multi MAIN('dist') {
  make-dist($version);
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
  "CHANGES".IO.e and do {
    shell "cat CHANGES >> /tmp/changes && mv /tmp/changes CHANGES";
  }
  shell "nvim CHANGES";
}

multi MAIN('docs') {
  shell q:to/SH/;
    ./gen-docs --html > doc.md
    SH
}

multi MAIN('bumpdist') {
  shell "zef test .";
  my $next = qq:x[raku -e '"$version".split(".") >>+>> <0 0 1> ==> join(".") ==> say()'].trim;
  say "$version -> $next";
  exit note "no next version" unless $next;
  shell qq:to/SH/;
    perl -p -i -e "s/{$version}/{$next}/" META6.json
    SH
  update-changes($version,$next);  
  shell "git commit -am$next";
  shell "git tag $next";
  make-dist($next);
}

multi MAIN('clean') {
  shell 'rm -f dist/*.tar.gz';
}

multi MAIN('tar') {
  my $out = "tar/{$module}-{$version}.tar.gz";
  shell qq:to/SH/;
    echo "Making $version";
    mkdir -p tar
    git archive --prefix={$module}-{$version}/ -o $out {$version}
    SH
  say "wrote $out";
}

multi MAIN('release') {
  "tar/{$module}-{$version}.tar.gz".IO.e or die "no tarfile created for $version, make tar first";
  shell "git push github";
  shell "git push --tags github";
  shell "fez upload --file tar/{$module}-{$version}.tar.gz";
}
