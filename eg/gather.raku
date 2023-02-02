#!/usr/bin/env raku

for $*IN.lines -> $l {
  say "got a line: $l";
  last if $l ~~ /^^ 3 $$/;
}

