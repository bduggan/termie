<h2>Currently supported commands</h2>

<h2>Interactive</h2>

In interactive mode these commands are supported:

<dl>
<dt><a href="https://github.com/bduggan/termie/blob/master/lib/Termie/Commander.rakumod#L54">\alias</a></dt>
<dd>&lt;key&gt; [&lt;n&gt; | &lt;str&gt;] show alias key, or set it to a str or history item</dd>
<dt><a href="https://github.com/bduggan/termie/blob/master/lib/Termie/Commander.rakumod#L44">\aliases</a></dt>
<dd>show aliases [containing a string]</dd>
<dt><a href="https://github.com/bduggan/termie/blob/master/lib/Termie/Commander.rakumod#L14">\append</a></dt>
<dd>append nth shown item to script &lt;file&gt;</dd>
<dt><a href="https://github.com/bduggan/termie/blob/master/lib/Termie/Commander/Godot.rakumod#L12">\await</a></dt>
<dd>await the appearance of regex in the output, then stop a repeat</dd>
<dt><a href="https://github.com/bduggan/termie/blob/master/lib/Termie/Commands.rakumod#L127">\capture &lt;file&gt;</a></dt>
<dd>write to &lt;file&gt;</dd>
<dt><a href="https://github.com/bduggan/termie/blob/master/lib/Termie/Commands.rakumod#L245">\cd</a></dt>
<dd>change local working dir</dd>
<dt><a href="https://github.com/bduggan/termie/blob/master/lib/Termie/Commands.rakumod#L313">\clear</a></dt>
<dd>clear this pane</dd>
<dt><a href="https://github.com/bduggan/termie/blob/master/lib/Termie/Commands.rakumod#L147">\close</a></dt>
<dd>kill the current pane</dd>
<dt><a href="https://github.com/bduggan/termie/blob/master/lib/Termie/Commander/Shellish.rakumod#L36">\clr</a></dt>
<dd>send a clear screen char</dd>
<dt><a href="https://github.com/bduggan/termie/blob/master/lib/Termie/Commands.rakumod#L117">\debug</a></dt>
<dd>set log level to debug</dd>
<dt><a href="https://github.com/bduggan/termie/blob/master/lib/Termie/Commands.rakumod#L330">\delay [num]</a></dt>
<dd>set the delay between sending lines</dd>
<dt><a href="https://github.com/bduggan/termie/blob/master/lib/Termie/Commands.rakumod#L261">\do</a></dt>
<dd>run a (not-shell) command and send the output slowly to the current pane</dd>
<dt><a href="https://github.com/bduggan/termie/blob/master/lib/Termie/Commands.rakumod#L300">\dosh</a></dt>
<dd>run a shell command and send the output (text mode, line at a time)</dd>
<dt><a href="https://github.com/bduggan/termie/blob/master/lib/Termie/Commands.rakumod#L234">\dump &lt;n&gt;</a></dt>
<dd>dump n (or 3000) lines of output to a file</dd>
<dt><a href="https://github.com/bduggan/termie/blob/master/lib/Termie/Commander.rakumod#L36">\edit</a></dt>
<dd>edit a file (default /tmp/buffer)</dd>
<dt><a href="https://github.com/bduggan/termie/blob/master/lib/Termie/Commander/Godot.rakumod#L42">\enq</a></dt>
<dd>Enqueue a command for await (or "clear" to clear the queue).</dd>
<dt><a href="https://github.com/bduggan/termie/blob/master/lib/Termie/Commander/Shellish.rakumod#L31">\eof</a></dt>
<dd>send an eof char</dd>
<dt><a href="https://github.com/bduggan/termie/blob/master/lib/Termie/Commands.rakumod#L161">\even</a></dt>
<dd>split layout vertically evenly</dd>
<dt><a href="https://github.com/bduggan/termie/blob/master/lib/Termie/Commands.rakumod#L202">\find &lt;phrase&gt;</a></dt>
<dd>Find commands in the history.</dd>
<dt><a href="https://github.com/bduggan/termie/blob/master/lib/Termie/Commander/Shellish.rakumod#L23">\grep</a></dt>
<dd>grep for a phrase in the output</dd>
<dt><a href="https://github.com/bduggan/termie/blob/master/lib/Termie/Commands.rakumod#L317">\help</a></dt>
<dd>this help</dd>
<dt><a href="https://github.com/bduggan/termie/blob/master/lib/Termie/Commands.rakumod#L122">\info</a></dt>
<dd>set log level to info</dd>
<dt><a href="https://github.com/bduggan/termie/blob/master/lib/Termie/Commands.rakumod#L224">\last (or history) [n]</a></dt>
<dd>show last n (or 10) commands (see alias)</dd>
<dt><a href="https://github.com/bduggan/termie/blob/master/lib/Termie/Commands.rakumod#L241">\ls &lt;opts&gt;</a></dt>
<dd>run ls in this pane</dd>
<dt><a href="https://github.com/bduggan/termie/blob/master/lib/Termie/Commands.rakumod#L250">\n</a></dt>
<dd>run command in item number n</dd>
<dt><a href="https://github.com/bduggan/termie/blob/master/lib/Termie/Commands.rakumod#L335">\newlines [on|off]</a></dt>
<dd>turn on or off always sending a newline</dd>
<dt><a href="https://github.com/bduggan/termie/blob/master/lib/Termie/Commands.rakumod#L169">\panes</a></dt>
<dd>list panes</dd>
<dt><a href="https://github.com/bduggan/termie/blob/master/lib/Termie/Commander/Shellish.rakumod#L18">\pwd</a></dt>
<dd>print current (meta) working directory</dd>
<dt><a href="https://github.com/bduggan/termie/blob/master/lib/Termie/Commander/Godot.rakumod#L50">\repeat</a></dt>
<dd>repeat the last M commands every N seconds (or stop a repeat)</dd>
<dt><a href="https://github.com/bduggan/termie/blob/master/lib/Termie/Commands.rakumod#L191">\run &lt;script&gt;</a></dt>
<dd>Run a script</dd>
<dt><a href="https://github.com/bduggan/termie/blob/master/lib/Termie/Commander.rakumod#L27">\scripts</a></dt>
<dd>show scripts in script library, optionally search for a name</dd>
<dt><a href="https://github.com/bduggan/termie/blob/master/lib/Termie/Commands.rakumod#L180">\select &lt;id&gt;</a></dt>
<dd>send to pane &lt;id&gt; instead select &lt;id&gt; &lt;id&gt;</dd>
<dt><a href="https://github.com/bduggan/termie/blob/master/lib/Termie/Commands.rakumod#L255">\send &lt;file&gt;</a></dt>
<dd>send a file</dd>
<dt><a href="https://github.com/bduggan/termie/blob/master/lib/Termie/Commands.rakumod#L89">\set &lt;var&gt; &lt;value&gt;</a></dt>
<dd>set a variable for inline replacement</dd>
<dt><a href="https://github.com/bduggan/termie/blob/master/lib/Termie/Commander/Shellish.rakumod#L9">\shell</a></dt>
<dd>run command in a local shell</dd>
<dt><a href="https://github.com/bduggan/termie/blob/master/lib/Termie/Commander.rakumod#L19">\show</a></dt>
<dd>show contents of a script</dd>
<dt><a href="https://github.com/bduggan/termie/blob/master/lib/Termie/Commands.rakumod#L356">\sleep X</a></dt>
<dd>sleep for X seconds</dd>
<dt><a href="https://github.com/bduggan/termie/blob/master/lib/Termie/Commands.rakumod#L165">\small</a></dt>
<dd>make the command pane small</dd>
<dt><a href="https://github.com/bduggan/termie/blob/master/lib/Termie/Commands.rakumod#L155">\split</a></dt>
<dd>split current pane</dd>
<dt><a href="https://github.com/bduggan/termie/blob/master/lib/Termie/Commands.rakumod#L136">\stop</a></dt>
<dd>send ^C to the current pane stop &lt;id&gt; ...</dd>
<dt><a href="https://github.com/bduggan/termie/blob/master/lib/Termie/Commands.rakumod#L340">\timing [on|off]</a></dt>
<dd>turn on or off showing times in the prompt</dd>
<dt><a href="https://github.com/bduggan/termie/blob/master/lib/Termie/Commands.rakumod#L112">\trace</a></dt>
<dd>set log level to trace</dd>
<dt><a href="https://github.com/bduggan/termie/blob/master/lib/Termie/Commands.rakumod#L211">\uni &lt;text&gt;</a></dt>
<dd>Look up unicode character to output</dd>
<dt><a href="https://github.com/bduggan/termie/blob/master/lib/Termie/Commands.rakumod#L351">\unwatch</a></dt>
<dd>stop watching the current window+pane</dd>
<dt><a href="https://github.com/bduggan/termie/blob/master/lib/Termie/Commands.rakumod#L345">\watch [filename]</a></dt>
<dd>start watching the current window+pane by piping to a file</dd>
<dt><a href="https://github.com/bduggan/termie/blob/master/lib/Termie/Commands.rakumod#L281">\xfer [filename]</a></dt>
<dd>send a file or directory to the remote console</dd>
</dl>
<h3>Scripts</h3>

In scripting mode, these additional commands are supported:

<dl>
<dt><a href="https://github.com/bduggan/termie/blob/master/lib/Termie/Commands.rakumod#L416">\buffer [lines|none]</a></dt>
<dd>turn on line buffering</dd>
<dt><a href="https://github.com/bduggan/termie/blob/master/lib/Termie/Commands.rakumod#L466">\done</a></dt>
<dd>indicate that the script is done</dd>
<dt><a href="https://github.com/bduggan/termie/blob/master/lib/Termie/Commands.rakumod#L476">\emit</a></dt>
<dd>emit a value matched in a wait regex</dd>
<dt><a href="https://github.com/bduggan/termie/blob/master/lib/Termie/Commands.rakumod#L360">\exec &lt;script-name&gt;</a></dt>
<dd>execute a program, and send output from the current pane to the program's stdin, and wait for the program to exit</dd>
<dt><a href="https://github.com/bduggan/termie/blob/master/lib/Termie/Commands.rakumod#L424">\pause &lt;msg&gt;</a></dt>
<dd>show msg or 'press return to continue'</dd>
<dt><a href="https://github.com/bduggan/termie/blob/master/lib/Termie/Commands.rakumod#L408">\run &lt;name&gt;</a></dt>
<dd>run another script in the same directory</dd>
<dt><a href="https://github.com/bduggan/termie/blob/master/lib/Termie/Commands.rakumod#L459">\send</a></dt>
<dd>send a file, abort if it cannot be sent.</dd>
<dt><a href="https://github.com/bduggan/termie/blob/master/lib/Termie/Commands.rakumod#L471">\timeout</a></dt>
<dd>set a timeout</dd>
<dt><a href="https://github.com/bduggan/termie/blob/master/lib/Termie/Commands.rakumod#L420">\trace [off|on]</a></dt>
<dd>turn on tracing</dd>
<dt><a href="https://github.com/bduggan/termie/blob/master/lib/Termie/Commands.rakumod#L432">\wait &lt;delay&gt; &lt;regex&gt;</a></dt>
<dd>wait after &lt;delay&gt; more steps for a regex</dd>
<dt><a href="https://github.com/bduggan/termie/blob/master/lib/Termie/Commands.rakumod#L433">\wait begin &lt;regex&gt;</a></dt>
<dd>wait for a regex until we see an end</dd>
<dt><a href="https://github.com/bduggan/termie/blob/master/lib/Termie/Commands.rakumod#L434">\wait end</a></dt>
<dd>end a wait begin</dd>
<dt><a href="https://github.com/bduggan/termie/blob/master/lib/Termie/Commands.rakumod#L431">\wait for &lt;regex&gt;</a></dt>
<dd>wait for a regex immediately</dd>
</dl>

<hr>

For more verbose descriptions of these commands, please refer to the source code!
