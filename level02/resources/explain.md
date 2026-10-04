cat the readme 

```bash
level02@snowcrash:~$ cat README 
A Kourier never loses a package. Even after delivery.

```

let's try to find a file called kourier

```bash
level02@snowcrash:~$ find / -name "kourier" 2>/dev/null
/opt/snowcrash/level02/kourier

```

let;s inspect it using strings

```bash
level02@snowcrash:~$ strings /opt/snowcrash/level02/kourier
/lib64/ld-linux-x86-64.so.2
u`i'!
syslog
fgets
closelog
strncpy
setsid
__stack_chk_fail
...
....
open %s: %s
qi0mauch9ahksha8b6dfe3p0kq
write %s: %s

```

here is the flag qi0mauch9ahksha8b6dfe3p0kq

```bash
level02@snowcrash:~$ su level03
Password: 
level03@snowcrash:/home/level02$ 
```