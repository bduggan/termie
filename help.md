## Currently supported commands

## Interactive

In interactive mode these commands are supported:

```
     \alias                          <key> [<n> | <str>] show alias key, or set it to a str or history item
     \aliases <str>                  show aliases [containing a string]
     \append <n> <file>              append nth shown item to script <file>
     \await [regex]                  await the appearance of regex in the output, then stop a repeat
     \capture <file>                 write to <file>
     \cd                             change local working dir
     \clear                          clear this pane
     \close                          kill the current pane
     \clr                            send a clear screen char
     \debug                          set log level to debug
     \delay [num]                    set between lines to a (decimal) value
     \do                             run a (not-shell) command and send the output slowly
     \dosh                           run a shell command and send the output (text mode, line at a time)
     \dump <n>                       dump n (or 3000) lines of output to a file
     \edit                           edit a file (default /tmp/buffer)
     \enq <command>                  Enqueue a command for await (or "clear" to clear the queue).
     \eof                            send an eof char
     \even                           split layout vertically evenly
     \find <phrase>                  Find commands in the history.
     \grep                           grep for a phrase in the output
     \help                           this help
     \info                           set log level to info
     \last [n]                       show last n (or 10) commands (see alias)
     \ls <opts>                      run ls in this pane
     \n                              run command in item number n
     \newlines [on|off]              turn on or off always sending a newline
     \panes                          list panes
     \pause <msg>                    show msg or 'press return to continue'
     \pwd                            print current (meta) working directory
     \repeat <N> <M> | <stop>        repeat the last M commands every N seconds (or stop a repeat)
     \run <script>                   Run a script
     \scripts                        show scripts in script library
     \select <id>                    send to pane <id> instead select <id> <id>
     \send|s <file>                  send a file
     \send|s <n>                     send item number n
     \set <var> <value>              set a variable for inline replacement
     \shell                          run command in a local shell
     \show                           show contents of a script
     \small                          make the command pane small
     \split                          split current pane
     \stop                           send ^C to the current pane stop <id> ...
     \timing [on|off]                turn on or off showing times in the prompt
     \trace                          set log level to trace
     \uni <text>                     Look up unicode character to output
     \xfer [filename]                send a file or directory to the remote console
```
### Scripts

In scripting mode, these additional commands are supported:

```
     \buffer [lines|none]     turn on line buffering
     \color [on|off]          turn off color (i.e. filter out ansi escapes)
     \emit                    emit a value matched in a wait regex
     \sleep X                 sleep for X seconds
     \timeout                 set a timeout
     \trace [off|on]          turn on tracing
     \wait <delay> <regex>    wait after <delay> more steps for a regex
     \wait begin <regex>      wait for a regex until we see an end
     \wait end                end a wait begin
     \wait for <regex>        wait for a regex immediately
```

---

For more verbose descriptions of these commands, please refer to the source code!
