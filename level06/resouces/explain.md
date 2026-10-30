```bash
level06@snowcrash:~$ cat README 
Nothing passes through the Raven unread.

```

try to find any file called or has the word raven , of owend by flag06 user

the two intreated files are : 
```bash
/opt/snowcrash/level06/raven
/opt/snowcrash/level06/raven.pl

```


after checking the perl code , we figure out that we inject a code to the the prel progam and can be executed 

```bash use re 'eval';``` 
This enables special Perl regular-expression constructs that can execute Perl code, such as: (?{ ... })

and later:

```bash if ($line =~ /$pattern/)```
where $pattern ultimately comes from:
```bash $CONFIG{loglevel_pattern} ```
and the configuration file is:
/etc/raven/raven.conf

i added the code to be runed by the progam ranven runs as flag06, still can;t get anything



