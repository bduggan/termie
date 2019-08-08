TMP=$PS1
export PS1="$ "

true
\expect /^^ '$' /

sleep 0.1
\expect /^^ '$' /

export PS1=$TMP
