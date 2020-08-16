<h2>Currently supported commands</h2>

<h2>Interactive</h2>

In interactive mode these commands are supported:

<dl>
<dt><a href="https://github.com/bduggan/tmeta/blob/master/lib/commander.pm6#L49">\alias</a></dt>
<dd>&lt;key&gt; [&lt;n&gt; | &lt;str&gt;] show alias key, or set it to a str or history item</dd>
<dt><a href="https://github.com/bduggan/tmeta/blob/master/lib/commander.pm6#L39">\aliases</a></dt>
<dd>show aliases [containing a string]</dd>
<dt><a href="https://github.com/bduggan/tmeta/blob/master/lib/commander.pm6#L14">\append</a></dt>
<dd>append nth shown item to script &lt;file&gt;</dd>
<dt><a href="https://github.com/bduggan/tmeta/blob/master/lib/commander/godot.pm6#L12">\await</a></dt>
<dd>await the appearance of regex in the output, then stop a repeat</dd>
<dt><a href="https://github.com/bduggan/tmeta/blob/master/lib/commands.pm6#L124">\capture &lt;file&gt;</a></dt>
<dd>write to &lt;file&gt;</dd>
<dt><a href="https://github.com/bduggan/tmeta/blob/master/lib/commands.pm6#L239">\cd</a></dt>
<dd>change local working dir</dd>
<dt><a href="https://github.com/bduggan/tmeta/blob/master/lib/commands.pm6#L316">\clear</a></dt>
<dd>clear this pane</dd>
<dt><a href="https://github.com/bduggan/tmeta/blob/master/lib/commands.pm6#L144">\close</a></dt>
<dd>kill the current pane</dd>
<dt><a href="https://github.com/bduggan/tmeta/blob/master/lib/commander/shellish.pm6#L36">\clr</a></dt>
<dd>send a clear screen char</dd>
<dt><a href="https://github.com/bduggan/tmeta/blob/master/lib/commands.pm6#L114">\debug</a></dt>
<dd>set log level to debug</dd>
<dt><a href="https://github.com/bduggan/tmeta/blob/master/lib/commands.pm6#L333">\delay [num]</a></dt>
<dd>set between lines to a (decimal) value</dd>
<dt><a href="https://github.com/bduggan/tmeta/blob/master/lib/commands.pm6#L265">\do</a></dt>
<dd>run a (not-shell) command and send the output slowly</dd>
<dt><a href="https://github.com/bduggan/tmeta/blob/master/lib/commands.pm6#L303">\dosh</a></dt>
<dd>run a shell command and send the output (text mode, line at a time)</dd>
<dt><a href="https://github.com/bduggan/tmeta/blob/master/lib/commands.pm6#L228">\dump &lt;n&gt;</a></dt>
<dd>dump n (or 3000) lines of output to a file</dd>
<dt><a href="https://github.com/bduggan/tmeta/blob/master/lib/commander.pm6#L32">\edit</a></dt>
<dd>edit a file (default /tmp/buffer)</dd>
<dt><a href="https://github.com/bduggan/tmeta/blob/master/lib/commander/godot.pm6#L42">\enq</a></dt>
<dd>Enqueue a command for await (or "clear" to clear the queue).</dd>
<dt><a href="https://github.com/bduggan/tmeta/blob/master/lib/commander/shellish.pm6#L31">\eof</a></dt>
<dd>send an eof char</dd>
<dt><a href="https://github.com/bduggan/tmeta/blob/master/lib/commands.pm6#L158">\even</a></dt>
<dd>split layout vertically evenly</dd>
<dt><a href="https://github.com/bduggan/tmeta/blob/master/lib/commands.pm6#L199">\find &lt;phrase&gt;</a></dt>
<dd>Find commands in the history.</dd>
<dt><a href="https://github.com/bduggan/tmeta/blob/master/lib/commander/shellish.pm6#L23">\grep</a></dt>
<dd>grep for a phrase in the output</dd>
<dt><a href="https://github.com/bduggan/tmeta/blob/master/lib/commands.pm6#L320">\help</a></dt>
<dd>this help</dd>
<dt><a href="https://github.com/bduggan/tmeta/blob/master/lib/commands.pm6#L119">\info</a></dt>
<dd>set log level to info</dd>
<dt><a href="https://github.com/bduggan/tmeta/blob/master/lib/commands.pm6#L218">\last [n]</a></dt>
<dd>show last n (or 10) commands (see alias)</dd>
<dt><a href="https://github.com/bduggan/tmeta/blob/master/lib/commands.pm6#L235">\ls &lt;opts&gt;</a></dt>
<dd>run ls in this pane</dd>
<dt><a href="https://github.com/bduggan/tmeta/blob/master/lib/commands.pm6#L244">\n</a></dt>
<dd>run command in item number n</dd>
<dt><a href="https://github.com/bduggan/tmeta/blob/master/lib/commands.pm6#L338">\newlines [on|off]</a></dt>
<dd>turn on or off always sending a newline</dd>
<dt><a href="https://github.com/bduggan/tmeta/blob/master/lib/commands.pm6#L166">\panes</a></dt>
<dd>list panes</dd>
<dt><a href="https://github.com/bduggan/tmeta/blob/master/lib/commands.pm6#L412">\pause &lt;msg&gt;</a></dt>
<dd>show msg or 'press return to continue'</dd>
<dt><a href="https://github.com/bduggan/tmeta/blob/master/lib/commander/shellish.pm6#L18">\pwd</a></dt>
<dd>print current (meta) working directory</dd>
<dt><a href="https://github.com/bduggan/tmeta/blob/master/lib/commander/godot.pm6#L50">\repeat</a></dt>
<dd>repeat the last M commands every N seconds (or stop a repeat)</dd>
<dt><a href="https://github.com/bduggan/tmeta/blob/master/lib/commands.pm6#L188">\run &lt;script&gt;</a></dt>
<dd>Run a script</dd>
<dt><a href="https://github.com/bduggan/tmeta/blob/master/lib/commander.pm6#L27">\scripts</a></dt>
<dd>show scripts in script library</dd>
<dt><a href="https://github.com/bduggan/tmeta/blob/master/lib/commands.pm6#L177">\select &lt;id&gt;</a></dt>
<dd>send to pane &lt;id&gt; instead select &lt;id&gt; &lt;id&gt;</dd>
<dt><a href="https://github.com/bduggan/tmeta/blob/master/lib/commands.pm6#L250">\send|s &lt;file&gt;</a></dt>
<dd>send a file</dd>
<dt><a href="https://github.com/bduggan/tmeta/blob/master/lib/commands.pm6#L249">\send|s &lt;n&gt;</a></dt>
<dd>send item number n</dd>
<dt><a href="https://github.com/bduggan/tmeta/blob/master/lib/commands.pm6#L86">\set &lt;var&gt; &lt;value&gt;</a></dt>
<dd>set a variable for inline replacement</dd>
<dt><a href="https://github.com/bduggan/tmeta/blob/master/lib/commander/shellish.pm6#L9">\shell</a></dt>
<dd>run command in a local shell</dd>
<dt><a href="https://github.com/bduggan/tmeta/blob/master/lib/commander.pm6#L19">\show</a></dt>
<dd>show contents of a script</dd>
<dt><a href="https://github.com/bduggan/tmeta/blob/master/lib/commands.pm6#L162">\small</a></dt>
<dd>make the command pane small</dd>
<dt><a href="https://github.com/bduggan/tmeta/blob/master/lib/commands.pm6#L152">\split</a></dt>
<dd>split current pane</dd>
<dt><a href="https://github.com/bduggan/tmeta/blob/master/lib/commands.pm6#L133">\stop</a></dt>
<dd>send ^C to the current pane stop &lt;id&gt; ...</dd>
<dt><a href="https://github.com/bduggan/tmeta/blob/master/lib/commands.pm6#L343">\timing [on|off]</a></dt>
<dd>turn on or off showing times in the prompt</dd>
<dt><a href="https://github.com/bduggan/tmeta/blob/master/lib/commands.pm6#L109">\trace</a></dt>
<dd>set log level to trace</dd>
<dt><a href="https://github.com/bduggan/tmeta/blob/master/lib/commands.pm6#L207">\uni &lt;text&gt;</a></dt>
<dd>Look up unicode character to output</dd>
<dt><a href="https://github.com/bduggan/tmeta/blob/master/lib/commands.pm6#L284">\xfer [filename]</a></dt>
<dd>send a file or directory to the remote console</dd>
</dl>
<h3>Scripts</h3>

In scripting mode, these additional commands are supported:

<dl>
<dt><a href="https://github.com/bduggan/tmeta/blob/master/lib/commands.pm6#L404">\script buffer [lines|none]</a></dt>
<dd>turn on line buffering</dd>
<dt><a href="https://github.com/bduggan/tmeta/blob/master/lib/commands.pm6#L400">\script color [on|off]</a></dt>
<dd>turn off color (i.e. filter out ansi escapes)</dd>
<dt><a href="https://github.com/bduggan/tmeta/blob/master/lib/commands.pm6#L465">\script emit</a></dt>
<dd>emit a value matched in a wait regex</dd>
<dt><a href="https://github.com/bduggan/tmeta/blob/master/lib/commands.pm6#L461">\script sleep X</a></dt>
<dd>sleep for X seconds</dd>
<dt><a href="https://github.com/bduggan/tmeta/blob/master/lib/commands.pm6#L456">\script timeout</a></dt>
<dd>set a timeout</dd>
<dt><a href="https://github.com/bduggan/tmeta/blob/master/lib/commands.pm6#L408">\script trace [off|on]</a></dt>
<dd>turn on tracing</dd>
<dt><a href="https://github.com/bduggan/tmeta/blob/master/lib/commands.pm6#L419">\script wait &lt;delay&gt; &lt;regex&gt;</a></dt>
<dd>wait after &lt;delay&gt; more steps for a regex</dd>
<dt><a href="https://github.com/bduggan/tmeta/blob/master/lib/commands.pm6#L420">\script wait begin &lt;regex&gt;</a></dt>
<dd>wait for a regex until we see an end</dd>
<dt><a href="https://github.com/bduggan/tmeta/blob/master/lib/commands.pm6#L421">\script wait end</a></dt>
<dd>end a wait begin</dd>
<dt><a href="https://github.com/bduggan/tmeta/blob/master/lib/commands.pm6#L418">\script wait for &lt;regex&gt;</a></dt>
<dd>wait for a regex immediately</dd>
</dl>

<hr>

For more verbose descriptions of these commands, please refer to the source code!
