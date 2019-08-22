unit role commander::shellish;

#| run command in a local shell
method shell($meta) {
 my $runme = $meta.subst('shell ','');
 my $proc = shell $runme;
 unless $proc.exitcode==0 {
   say "exit status " ~ $proc.exitcode;
 }
}

#| print current (meta) working directory
method pwd($meta) {
  say ~$*CWD;
}

#| grep for a phrase in the output
method grep($meta) {
  my $phrase = $meta.subst(/^ 'grep' /,'').trim;
  note "searching for $phrase";
  shell "tmux capture-pane -t $*window.$*pane -S -$*greplines -p > /tmp/grepme";
  .put for '/tmp/grepme'.IO.lines.grep: { /:i "$phrase" / };
}

#| send an eof char
method eof($meta) {
  run <<tmux send-keys -t "$*window.$*pane" '-l' "">>;
}

#| send a clear screen char
method clr($meta) {
  run <<tmux send-keys -t "$*window.$*pane" '-l' "">>;
}
