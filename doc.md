<h2>Currently supported commands</h2>

<h2>Interactive</h2>

In interactive mode these commands are supported:

<dl>
<dt><a href="https://github.com/bduggan/tmeta/blob/master/lib/tmeta/commander.rakumod#L51">\alias</a></dt>
<dd>&lt;key&gt; [&lt;n&gt; | &lt;str&gt;] show alias key, or set it to a str or history item</dd>
<dt><a href="https://github.com/bduggan/tmeta/blob/master/lib/tmeta/commander.rakumod#L41">\aliases</a></dt>
<dd>show aliases [containing a string]</dd>
<dt><a href="https://github.com/bduggan/tmeta/blob/master/lib/tmeta/commander.rakumod#L14">\append</a></dt>
<dd>append nth shown item to script &lt;file&gt;</dd>
<dt><a href="https://github.com/bduggan/tmeta/blob/master/lib/tmeta/commander/godot.rakumod#L12">\await</a></dt>
<dd>await the appearance of regex in the output, then stop a repeat</dd>
<dt><a href="https://github.com/bduggan/tmeta/blob/master/lib/tmeta/commands.rakumod#L125">\capture &lt;file&gt;</a></dt>
<dd>write to &lt;file&gt;</dd>
<dt><a href="https://github.com/bduggan/tmeta/blob/master/lib/tmeta/commands.rakumod#L240">\cd</a></dt>
<dd>change local working dir</dd>
<dt><a href="https://github.com/bduggan/tmeta/blob/master/lib/tmeta/commands.rakumod#L307">\clear</a></dt>
<dd>clear this pane</dd>
<dt><a href="https://github.com/bduggan/tmeta/blob/master/lib/tmeta/commands.rakumod#L145">\close</a></dt>
<dd>kill the current pane</dd>
<dt><a href="https://github.com/bduggan/tmeta/blob/master/lib/tmeta/commander/shellish.rakumod#L36">\clr</a></dt>
<dd>send a clear screen char</dd>
<dt><a href="https://github.com/bduggan/tmeta/blob/master/lib/tmeta/commands.rakumod#L115">\debug</a></dt>
<dd>set log level to debug</dd>
<dt><a href="https://github.com/bduggan/tmeta/blob/master/lib/tmeta/commands.rakumod#L324">\delay [num]</a></dt>
<dd>set the delay between sending lines</dd>
<dt><a href="https://github.com/bduggan/tmeta/blob/master/lib/tmeta/commands.rakumod#L256">\do</a></dt>
<dd>run a (not-shell) command and send the output slowly</dd>
<dt><a href="https://github.com/bduggan/tmeta/blob/master/lib/tmeta/commands.rakumod#L294">\dosh</a></dt>
<dd>run a shell command and send the output (text mode, line at a time)</dd>
<dt><a href="https://github.com/bduggan/tmeta/blob/master/lib/tmeta/commands.rakumod#L229">\dump &lt;n&gt;</a></dt>
<dd>dump n (or 3000) lines of output to a file</dd>
<dt><a href="https://github.com/bduggan/tmeta/blob/master/lib/tmeta/commander.rakumod#L33">\edit</a></dt>
<dd>edit a file (default /tmp/buffer)</dd>
<dt><a href="https://github.com/bduggan/tmeta/blob/master/lib/tmeta/commander/godot.rakumod#L42">\enq</a></dt>
<dd>Enqueue a command for await (or "clear" to clear the queue).</dd>
<dt><a href="https://github.com/bduggan/tmeta/blob/master/lib/tmeta/commander/shellish.rakumod#L31">\eof</a></dt>
<dd>send an eof char</dd>
<dt><a href="https://github.com/bduggan/tmeta/blob/master/lib/tmeta/commands.rakumod#L159">\even</a></dt>
<dd>split layout vertically evenly</dd>
<dt><a href="https://github.com/bduggan/tmeta/blob/master/lib/tmeta/commands.rakumod#L200">\find &lt;phrase&gt;</a></dt>
<dd>Find commands in the history.</dd>
<dt><a href="https://github.com/bduggan/tmeta/blob/master/lib/tmeta/commander/shellish.rakumod#L23">\grep</a></dt>
<dd>grep for a phrase in the output</dd>
<dt><a href="https://github.com/bduggan/tmeta/blob/master/lib/tmeta/commands.rakumod#L311">\help</a></dt>
<dd>this help</dd>
<dt><a href="https://github.com/bduggan/tmeta/blob/master/lib/tmeta/commands.rakumod#L120">\info</a></dt>
<dd>set log level to info</dd>
<dt><a href="https://github.com/bduggan/tmeta/blob/master/lib/tmeta/commands.rakumod#L219">\last [n]</a></dt>
<dd>show last n (or 10) commands (see alias)</dd>
<dt><a href="https://github.com/bduggan/tmeta/blob/master/lib/tmeta/commands.rakumod#L236">\ls &lt;opts&gt;</a></dt>
<dd>run ls in this pane</dd>
<dt><a href="https://github.com/bduggan/tmeta/blob/master/lib/tmeta/commands.rakumod#L245">\n</a></dt>
<dd>run command in item number n</dd>
<dt><a href="https://github.com/bduggan/tmeta/blob/master/lib/tmeta/commands.rakumod#L329">\newlines [on|off]</a></dt>
<dd>turn on or off always sending a newline</dd>
<dt><a href="https://github.com/bduggan/tmeta/blob/master/lib/tmeta/commands.rakumod#L167">\panes</a></dt>
<dd>list panes</dd>
<dt><a href="https://github.com/bduggan/tmeta/blob/master/lib/tmeta/commander/shellish.rakumod#L18">\pwd</a></dt>
<dd>print current (meta) working directory</dd>
<dt><a href="https://github.com/bduggan/tmeta/blob/master/lib/tmeta/commander/godot.rakumod#L50">\repeat</a></dt>
<dd>repeat the last M commands every N seconds (or stop a repeat)</dd>
<dt><a href="https://github.com/bduggan/tmeta/blob/master/lib/tmeta/commands.rakumod#L189">\run &lt;script&gt;</a></dt>
<dd>Run a script</dd>
<dt><a href="https://github.com/bduggan/tmeta/blob/master/lib/tmeta/commander.rakumod#L27">\scripts</a></dt>
<dd>show scripts in script library</dd>
<dt><a href="https://github.com/bduggan/tmeta/blob/master/lib/tmeta/commands.rakumod#L178">\select &lt;id&gt;</a></dt>
<dd>send to pane &lt;id&gt; instead select &lt;id&gt; &lt;id&gt;</dd>
<dt><a href="https://github.com/bduggan/tmeta/blob/master/lib/tmeta/commands.rakumod#L250">\send &lt;file&gt;</a></dt>
<dd>send a file</dd>
<dt><a href="https://github.com/bduggan/tmeta/blob/master/lib/tmeta/commands.rakumod#L87">\set &lt;var&gt; &lt;value&gt;</a></dt>
<dd>set a variable for inline replacement</dd>
<dt><a href="https://github.com/bduggan/tmeta/blob/master/lib/tmeta/commander/shellish.rakumod#L9">\shell</a></dt>
<dd>run command in a local shell</dd>
<dt><a href="https://github.com/bduggan/tmeta/blob/master/lib/tmeta/commander.rakumod#L19">\show</a></dt>
<dd>show contents of a script</dd>
<dt><a href="https://github.com/bduggan/tmeta/blob/master/lib/tmeta/commands.rakumod#L163">\small</a></dt>
<dd>make the command pane small</dd>
<dt><a href="https://github.com/bduggan/tmeta/blob/master/lib/tmeta/commands.rakumod#L153">\split</a></dt>
<dd>split current pane</dd>
<dt><a href="https://github.com/bduggan/tmeta/blob/master/lib/tmeta/commands.rakumod#L134">\stop</a></dt>
<dd>send ^C to the current pane stop &lt;id&gt; ...</dd>
<dt><a href="https://github.com/bduggan/tmeta/blob/master/lib/tmeta/commands.rakumod#L334">\timing [on|off]</a></dt>
<dd>turn on or off showing times in the prompt</dd>
<dt><a href="https://github.com/bduggan/tmeta/blob/master/lib/tmeta/commands.rakumod#L110">\trace</a></dt>
<dd>set log level to trace</dd>
<dt><a href="https://github.com/bduggan/tmeta/blob/master/lib/tmeta/commands.rakumod#L208">\uni &lt;text&gt;</a></dt>
<dd>Look up unicode character to output</dd>
<dt><a href="https://github.com/bduggan/tmeta/blob/master/lib/tmeta/commands.rakumod#L344">\unwatch</a></dt>
<dd>stop watching the current window+pane</dd>
<dt><a href="https://github.com/bduggan/tmeta/blob/master/lib/tmeta/commands.rakumod#L339">\watch</a></dt>
<dd>start watching the current window+pane by piping to a file</dd>
<dt><a href="https://github.com/bduggan/tmeta/blob/master/lib/tmeta/commands.rakumod#L275">\xfer [filename]</a></dt>
<dd>send a file or directory to the remote console</dd>
</dl>
<h3>Scripts</h3>

In scripting mode, these additional commands are supported:

<dl>
<dt><a href="https://github.com/bduggan/tmeta/blob/master/lib/tmeta/commands.rakumod#L405">\buffer [lines|none]</a></dt>
<dd>turn on line buffering</dd>
<dt><a href="https://github.com/bduggan/tmeta/blob/master/lib/tmeta/commands.rakumod#L401">\color [on|off]</a></dt>
<dd>turn off color (i.e. filter out ansi escapes)</dd>
<dt><a href="https://github.com/bduggan/tmeta/blob/master/lib/tmeta/commands.rakumod#L454">\done</a></dt>
<dd>indicate that the script is done</dd>
<dt><a href="https://github.com/bduggan/tmeta/blob/master/lib/tmeta/commands.rakumod#L468">\emit</a></dt>
<dd>emit a value matched in a wait regex</dd>
<dt><a href="https://github.com/bduggan/tmeta/blob/master/lib/tmeta/commands.rakumod#L413">\pause &lt;msg&gt;</a></dt>
<dd>show msg or 'press return to continue'</dd>
<dt><a href="https://github.com/bduggan/tmeta/blob/master/lib/tmeta/commands.rakumod#L393">\run &lt;name&gt;</a></dt>
<dd>run another script in the same directory</dd>
<dt><a href="https://github.com/bduggan/tmeta/blob/master/lib/tmeta/commands.rakumod#L447">\send</a></dt>
<dd>send a file, abort if it cannot be sent.</dd>
<dt><a href="https://github.com/bduggan/tmeta/blob/master/lib/tmeta/commands.rakumod#L464">\sleep X</a></dt>
<dd>sleep for X seconds</dd>
<dt><a href="https://github.com/bduggan/tmeta/blob/master/lib/tmeta/commands.rakumod#L459">\timeout</a></dt>
<dd>set a timeout</dd>
<dt><a href="https://github.com/bduggan/tmeta/blob/master/lib/tmeta/commands.rakumod#L409">\trace [off|on]</a></dt>
<dd>turn on tracing</dd>
<dt><a href="https://github.com/bduggan/tmeta/blob/master/lib/tmeta/commands.rakumod#L420">\wait &lt;delay&gt; &lt;regex&gt;</a></dt>
<dd>wait after &lt;delay&gt; more steps for a regex</dd>
<dt><a href="https://github.com/bduggan/tmeta/blob/master/lib/tmeta/commands.rakumod#L421">\wait begin &lt;regex&gt;</a></dt>
<dd>wait for a regex until we see an end</dd>
<dt><a href="https://github.com/bduggan/tmeta/blob/master/lib/tmeta/commands.rakumod#L422">\wait end</a></dt>
<dd>end a wait begin</dd>
<dt><a href="https://github.com/bduggan/tmeta/blob/master/lib/tmeta/commands.rakumod#L419">\wait for &lt;regex&gt;</a></dt>
<dd>wait for a regex immediately</dd>
</dl>

<hr>

For more verbose descriptions of these commands, please refer to the source code!
