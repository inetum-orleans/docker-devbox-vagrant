@echo off
SET UNISON_HOST=192.168.1.100:4250

:loop
echo [+] starting unison
unison . socket://%UNISON_HOST%/ -repeat watch -auto -batch -ignore "Path .idea"
echo [!] unison terminated
goto loop