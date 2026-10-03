ls the home diractory , and cat the readme and see if there is any hints


```bash
level01@snowcrash:~$ cat README 
Gargoyles never stop collecting.

```
tried to find a file called gargoules or Gargoyles but nothing , let;s try to find a file owend by flag01

```bash
level01@snowcrash:~$ /opt/snowcrash/level01/gargoyle
...
..
/proc/613/ksm_merging_pages
/proc/613/ksm_stat
/sys/fs/cgroup/system.slice/gargoyle.service/memory.pressure
/home/flag01

```

emm, we find a linux cgroup pressure metric for the gargoyle.service
i am seeing here gargoyle , seems to be familer , lets see what the does this file contain
and see 

```bash
level01@snowcrash:~$ cat /sys/fs/cgroup/system.slice/gargoyle.service/memory.pressure
some avg10=0.00 avg60=0.00 avg300=0.00 total=0
full avg10=0.00 avg60=0.00 avg300=0.00 total=0

```

let's to see the statust of this service

```bash

level01@snowcrash:~$ systemctl status gargoyle.service
● gargoyle.service - Snow Crash level01 — Gargoyle data collector
     Loaded: loaded (/etc/systemd/system/gargoyle.service; enabled; preset: enabled)
     Active: active (running) since Sat 2026-10-03 12:13:08 UTC; 25min left
    Process: 564 ExecStart=/opt/snowcrash/level01/gargoyle kooda7puivaav1idi4f57q8iq0 (code=exited, status=0/SUCCESS)
   Main PID: 613 (kworker/0:1H)
      Tasks: 1 (limit: 2263)
     Memory: 236.0K (peak: 1.6M)
        CPU: 17ms
     CGroup: /system.slice/gargoyle.service
             └─613 /opt/snowcrash/level01/gargoyle kooda7puivaav1idi4f57q8iq0

Warning: some journal files were not opened due to insufficient permissions.

```
let's user the this sting kooda7puivaav1idi4f57q8iq0 , seems to be the flag
```bash
level01@snowcrash:~$ su level02
Password: 
level02@snowcrash:/home/level01$ 

```
voilaa....
