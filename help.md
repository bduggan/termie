## Currently supported commands

## Interactive

In interactive mode these commands are supported:

```
     \alias <key>                    show any alias associated with <key>
     \alias <key> <n>                set <key> to item n from history (see \last)
     \alias <key> <str>              alias <key> to <str>
     \aliases                        show aliases
     \append <n> <file>              append nth shown item to script <file>
     \await [<str> | / <regex> /]    await the appearance of regex in the output, then stop a repeat
     \capture <file>                 write to <file>
     \cd                             change local working dir
     \clear                          clear this pane
     \close                          kill the current pane
     \clr                            send an clear screen char
     \debug                          set log level to debug
     \delay [num]                    set between lines to a (decimal) value
     \dump <n>                       dump n (or 3000) lines of output to a file
     \edit                           edit a file (default /tmp/buffer)
     \eof                            send an eof char
     \even                           split layout vertically evenly
     \find <phrase>                  Find commands in the history.
     \grep                           grep for a phrase in the output
     \greplines [num]                set between lines for \grep
     \help                           this help
     \info                           set log level to info
     \ls <opts>                      run ls in this pane
     \n                              run command in item number n
     \newlines [on|off]              turn on or off always sending a newline
     \panes                          list panes
     \pwd                            print current (meta) working directory
     \repeat <N>                     repeat the last command every N seconds (default 5)
     \repeat <N> <M>                 repeat the last M commands every N seconds
     \repeat stop                    stop repeating (see await)
     \run <script>                   Run a script
     \scripts                        show scripts in script library
     \select <id>                    send to pane <id> instead select <id> <id>
     \send|s <file>                  send a file
     \send|s <n>                     send item number n
     \set <var> <value>              set a variable for inline replacement
     \shell                          run command in a local shell
     \show                           show contents of a script
     \split                          split current pane
     \stop                           send ^C to the current pane stop <id> ...
     \trace                          set log level to trace
     \uni <text>                     Look up unicode character to output
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
