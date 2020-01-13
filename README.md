# tmeta

A console for your console

[![Build Status](https://travis-ci.org/bduggan/tmeta.svg?branch=master)](https://travis-ci.org/bduggan/tmeta)

![image](https://user-images.githubusercontent.com/58956/62714100-c4e26780-b9b2-11e9-8fe4-43089b721698.png)

## Description

tmeta is a wrapper for tmux that supports
sending and receiving data to/from tmux panes.

Anything typed into the bottom pane is sent to the top one, but
lines that start with a backslash are commands for `tmeta`.
You can type `\help` to see all possible commands.

## Why

Because you get:

- an uncluttered view of your commands separate from the output
- a local history for commands that are run remotely
- readline interface independent of the remote console
- scripting support for programs that require a TTY
- macros
- the ability to monitor or capture output
- other `expect`-like functionality
- controlled copy-and-paste operations into remote sessions

## Quick start

See below for installation.

There are a few different ways to start `tmeta`.

1. Start `tmux` yourself, then have `tmeta` split a window and
start up in its own pane:
   ```
   $ tmux
   $ tmeta
   ```

2. Let `tmeta` start tmux for you:
  ```
  $ tmeta
  ```

3. Run a tmeta script.  This will split and run in another pane.
   ```
   $ tmux
   $ tmeta script.tm
   ```

I use the `.tm` suffix for my `tmeta` scripts.  If you do too, you
might like the vim syntax file for them (in this repo).


## What do I use it with

tmeta plays well with REPLs, or any console based
application that uses a tty.  For instance, docker, rails
console, interactive ruby shell, the python debugger, the
jupyter console, psql, mysql, regular ssh sessions, local
terminal sessions, whatever

## More documentation

Please see the [documentation](doc.md) for a complete list of commands.

## Examples

  Show a list of commands.
  ```
  > \help
  ```

  Run `date` every 5 seconds until the output contains `02`
  ```
  > date
  > \repeat
  > \await 02
  ```

  Within a debugger session, send `next` every 2 seconds.
  ```
  > next
  > \repeat 2
  ```

  Search the command history for the last occurrence of 'User' using fzf
  (readline keybindings work too)
  ```
  > \find User
  ```

  Search the output for "http"
  ```
  > \grep http
  ```

  Send a local file named `bigfile.rb` to a remote rails console
  ```
  > \send bigfile.rb
  ```

  Same thing, but throttle the copy-paste operation, sending 1 line per second:
  ```
  > \delay 1
  > \send bigfile.rb
  ```

  Similar, but send it to an ssh console by first tarring and base64 encoding
  and not echoing stdout, and note that 'something' can also be a directory:0
  ```
  > \xfer something
  ```

  Run a command locally, sending each line of output to the remote console:
  ```
  > \do echo date
  ```

  Run a shell snippet locally, sending each line of output to the remote console:
  ```
  > \dosh for i in `seq 5`; do echo "ping host-$i"; done
  ```

  Start printing the numbers 1 through 100, one per second, but send a ctrl-c
  when the number 10 is printed:
  ```
  > \enq \stop
  queue is now : \stop
  > for i in `seq 100`; do echo $i; sleep 1; done
  # .. starts running in other pane ...
  > \await 10
  Waiting for "10"
  Then I will send:
  \stop
  Done: saw "10"
  starting enqueued command: \stop
  ```


## Installation

Prerequisites: fzf, tmux, libreadline, perl6 and a few modules

On OS/X
```
brew install fzf
brew install tmux
brew install perl6
zef install Log::Async
zef install Readline
git clone https://github.com/bduggan/tmeta
cd tmeta
./tmeta
```

## See also

* The [documentation](doc.md), with links to the source
* The same [documentation](help.md) as shown by the `\help` command
