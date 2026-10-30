here is what i did
(too larzy to explain)

```bash
level09@snowcrash:~$ ls
README
level09@snowcrash:~$ cat README 
Da5id saw something he shouldn't have.


level09@snowcrash:~$ find / -name "*da5id*" 2>/dev/null
/opt/snowcrash/level09/da5id

level09@snowcrash:~$ ls -al /opt/snowcrash/level09/da5id
-r-sr-x--- 1 flag09 da5id 16896 Jun  9 19:03 /opt/snowcrash/level09/da5id

level09@snowcrash:~$ /opt/snowcrash/level09/da5id
Usage: /opt/snowcrash/level09/da5id <token>


level09@snowcrash:~$ /opt/snowcrash/level09/da5id fdfd
Token does not meet policy requirements.

level09@snowcrash:~$ strings /opt/snowcrash/level09/da5id

.
.
Token contains non-printable characters.
Token does not meet policy requirements.
Iheartpwnage
9*3$"
GCC: (Ubuntu 13.3.0-6ubuntu2~24.04.1) 13.3.0
Scrt1.o
__abi_tag
da5id.c
.
.
.


level09@snowcrash:~$ /opt/snowcrash/level09/da5id Iheartpwnage
checking byte 0...
checking byte 1...
checking byte 2...
checking byte 3...
checking byte 4...
checking byte 5...
checking byte 6...
checking byte 7...
checking byte 8...
checking byte 9...
checking byte 10...
checking byte 11...
TOKEN ACCEPTED.
Flag: s19q3m3u4toaequegh8ahpicel
```