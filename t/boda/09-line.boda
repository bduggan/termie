\buffer lines

\wait 1 /^ $<num>=\d ** 4 $/
seq $((100 * 100))
echo waited for ...
\emit num ...
 > /tmp/out
cat /tmp/out
\expect waited for 1000
