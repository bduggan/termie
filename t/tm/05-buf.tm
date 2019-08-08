\color strip

# some comments here
echo hello
TMP=$PS1
export PS1='findthisprompt'

# and here, too
\expect findthisprompt

# let's send something
echo 'echo hi' > /tmp/output.tmeta-test.txt
\cd /tmp
\send /tmp/output.tmeta-test.txt

echo 'still going'
export PS1=$TMP
