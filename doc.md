<h2>Currently supported commands</h2>

<h2>Interactive</h2>

In interactive mode these commands are supported:

<dl>
<dt>\alias &lt;key&gt;</dt>
<dd>show any alias associated with &lt;key&gt;</dd>
<dt>\alias &lt;key&gt; &lt;n&gt;</dt>
<dd>set &lt;key&gt; to item n from history (see \last)</dd>
<dt>\alias &lt;key&gt; &lt;str&gt;</dt>
<dd>alias &lt;key&gt; to &lt;str&gt;</dd>
<dt><a href="https://github.com/bduggan/tmeta/blob/master/lib/commander.pm6#L37">\aliases</a></dt>
<dd>show aliases [containing a string]</dd>
<dt><a href="https://github.com/bduggan/tmeta/blob/master/lib/commander.pm6#L12">\append</a></dt>
<dd>append nth shown item to script &lt;file&gt;</dd>
<dt>\await [&lt;str&gt; | / &lt;regex&gt; /]</dt>
<dd>await the appearance of regex in the output, then stop a repeat</dd>
<dt>\capture &lt;file&gt;</dt>
<dd>write to &lt;file&gt;</dd>
<dt>\cd</dt>
<dd>change local working dir</dd>
<dt>\clear</dt>
<dd>clear this pane</dd>
<dt>\close</dt>
<dd>kill the current pane</dd>
<dt><a href="https://github.com/bduggan/tmeta/blob/master/lib/commander/shellish.pm6#L35">\clr</a></dt>
<dd>send a clear screen char</dd>
<dt>\debug</dt>
<dd>set log level to debug</dd>
<dt>\delay [num]</dt>
<dd>set between lines to a (decimal) value</dd>
<dt>\do</dt>
<dd>run a (not-shell) command and send the output slowly</dd>
<dt>\do</dt>
<dd>run a shell command and send the output (text mode, line at a time)</dd>
<dt>\dump &lt;n&gt;</dt>
<dd>dump n (or 3000) lines of output to a file</dd>
<dt><a href="https://github.com/bduggan/tmeta/blob/master/lib/commander.pm6#L30">\edit</a></dt>
<dd>edit a file (default /tmp/buffer)</dd>
<dt>\enq [&lt;command&gt;]</dt>
<dd>Enqueue a command for await (or clear the queue).</dd>
<dt><a href="https://github.com/bduggan/tmeta/blob/master/lib/commander/shellish.pm6#L30">\eof</a></dt>
<dd>send an eof char</dd>
<dt>\even</dt>
<dd>split layout vertically evenly</dd>
<dt>\find &lt;phrase&gt;</dt>
<dd>Find commands in the history.</dd>
<dt><a href="https://github.com/bduggan/tmeta/blob/master/lib/commander/shellish.pm6#L22">\grep</a></dt>
<dd>grep for a phrase in the output</dd>
<dt>\help</dt>
<dd>this help</dd>
<dt>\info</dt>
<dd>set log level to info</dd>
<dt>\ls &lt;opts&gt;</dt>
<dd>run ls in this pane</dd>
<dt>\n</dt>
<dd>run command in item number n</dd>
<dt>\newlines [on|off]</dt>
<dd>turn on or off always sending a newline</dd>
<dt>\panes</dt>
<dd>list panes</dd>
<dt><a href="https://github.com/bduggan/tmeta/blob/master/lib/commander/shellish.pm6#L17">\pwd</a></dt>
<dd>print current (meta) working directory</dd>
<dt>\repeat &lt;N&gt;</dt>
<dd>repeat the last command every N seconds (default 5)</dd>
<dt>\repeat &lt;N&gt; &lt;M&gt;</dt>
<dd>repeat the last M commands every N seconds</dd>
<dt>\repeat stop</dt>
<dd>stop repeating (see await)</dd>
<dt>\run &lt;script&gt;</dt>
<dd>Run a script</dd>
<dt><a href="https://github.com/bduggan/tmeta/blob/master/lib/commander.pm6#L25">\scripts</a></dt>
<dd>show scripts in script library</dd>
<dt><a href="https://github.com/bduggan/tmeta/blob/master/lib/commands.pm6#L211">\select &lt;id&gt;</a></dt>
<dd>send to pane &lt;id&gt; instead select &lt;id&gt; &lt;id&gt;</dd>
<dt>\send|s &lt;file&gt;</dt>
<dd>send a file</dd>
<dt>\send|s &lt;n&gt;</dt>
<dd>send item number n</dd>
<dt>\set &lt;var&gt; &lt;value&gt;</dt>
<dd>set a variable for inline replacement</dd>
<dt><a href="https://github.com/bduggan/tmeta/blob/master/lib/commander/shellish.pm6#L9">\shell</a></dt>
<dd>run command in a local shell</dd>
<dt><a href="https://github.com/bduggan/tmeta/blob/master/lib/commander.pm6#L17">\show</a></dt>
<dd>show contents of a script</dd>
<dt>\split</dt>
<dd>split current pane</dd>
<dt><a href="https://github.com/bduggan/tmeta/blob/master/lib/commands.pm6#L171">\stop</a></dt>
<dd>send ^C to the current pane stop &lt;id&gt; ...</dd>
<dt>\timing [on|off]</dt>
<dd>turn on or off showing times in the prompt</dd>
<dt>\trace</dt>
<dd>set log level to trace</dd>
<dt>\uni &lt;text&gt;</dt>
<dd>Look up unicode character to output</dd>
<dt>\xfer [filename]</dt>
<dd>send a file or directory to the remote console</dd>
</dl>
<h3>Scripts</h3>

In scripting mode, these additional commands are supported:

<dl>
<dt>\script buffer [lines|none]</dt>
<dd>turn on line buffering</dd>
<dt>\script color [on|off]</dt>
<dd>turn off color (i.e. filter out ansi escapes)</dd>
<dt>\script emit</dt>
<dd>emit a value matched in a wait regex</dd>
<dt>\script sleep X</dt>
<dd>sleep for X seconds</dd>
<dt>\script timeout</dt>
<dd>set a timeout</dd>
<dt>\script trace [off|on]</dt>
<dd>turn on tracing</dd>
<dt>\script wait &lt;delay&gt; &lt;regex&gt;</dt>
<dd>wait after &lt;delay&gt; more steps for a regex</dd>
<dt>\script wait begin &lt;regex&gt;</dt>
<dd>wait for a regex until we see an end</dd>
<dt>\script wait end</dt>
<dd>end a wait begin</dd>
<dt>\script wait for &lt;regex&gt;</dt>
<dd>wait for a regex immediately</dd>
</dl>

<hr>

For more verbose descriptions of these commands, please refer to the source code!
