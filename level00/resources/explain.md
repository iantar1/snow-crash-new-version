after listing the files in the home diractory we notice a readme , it seems to be useless

```bash
level00@snowcrash:~$ ls 
README
level00@snowcrash:~$ cat README 
Hiro Protagonist. Last of the freelance hackers. Or so he thinks.
```
let;s try to find a file owend by level01

```bash
level00@snowcrash:~$ find / -user flag00  2>/dev/null
/home/flag00
/opt/snowcrash/level00/hiro
```

runt the excutable file hiro , and try to cat the .flag

```bash
level00@snowcrash:~$ /opt/snowcrash/level00/hiro
[*] Checking credentials...
[*] Access granted — welcome, flag00
flag00@snowcrash:~$ ls
total 12
drwxr-x--- 2 flag00 flag00 4096 Jan  1 00:00 .
drwxr-xr-x 22 root   root   4096 Jan  1 00:00 ..
-r-------- 1 flag00 flag00   32 Jan  1 00:00 .flag
-rwsr-x--- 1 flag00 level00  12288 Jan  1 00:00 hiro
flag00@snowcrash:~$ cat .fla	
cat: permission denied
flag00@snowcrash:~$ cat .flag
cat: permission denied

```
let's try to inspect the hiro file using strings

```bash
level00@snowcrash:~$ strings /opt/snowcrash/level00/hiro
/lib64/ld-linux-x86-64.so.2
eNa%
mfUa
fgets
snprintf
...
...
...
>@f2av5il02puano7naaf6adaf3a

```

after analysing the output , we can notice an interesting string >@f2av5il02puano7naaf6adaf3a it seems to be the flag we are looking for :

```bash
level00@snowcrash:~$ su level01
Password: 
level01@snowcrash:/home/level00$ 
```