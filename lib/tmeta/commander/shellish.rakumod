unit role tmeta::commander::shellish;

sub arg($cmd) {
  my $wd = $cmd.words[0];
  return $cmd.subst($wd,'').trim;
}

#| run command in a local shell
method shell($meta, |rest) {
 my $proc = shell(arg($meta));
 unless $proc.exitcode==0 {
   say "exit status " ~ $proc.exitcode;
 }
 put "";
}

#| print current (meta) working directory
method pwd($meta) {
  say ~$*CWD;
}

#| grep for a phrase in the output
method grep($meta, |rest) {
  my $phrase = arg($meta);
  note "searching for $phrase";
  shell "tmux capture-pane -t $*window.$*pane -S -$*greplines -p > /tmp/grepme";
  .put for '/tmp/grepme'.IO.lines.grep: { /:i "$phrase" / };
}

#| send an eof char
method eof($meta = '') {
  run <<tmux send-keys -t "$*window.$*pane" '-l' "">>;
}

#| send a clear screen char
method clr($meta = '') {
  run <<tmux send-keys -t "$*window.$*pane" '-l' "">>;
}
