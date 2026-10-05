# 

```bash
level05@snowcrash:~$ ls
README
level05@snowcrash:~$ cat README 
The Metaverse runs on code. Code can be rewritten.
level05@snowcrash:~$ find / -user flag05 2>/dev/null
/home/flag05
level05@snowcrash:~$ find / -name "metaverse" 2>/dev/null
level05@snowcrash:~$ find / -name "*metaverse*" 2>/dev/null
/etc/systemd/system/timers.target.wants/metaverse.timer
/etc/systemd/system/metaverse.timer
/etc/systemd/system/metaverse.service
/opt/snowcrash/level05/metaverse.wasm
/opt/snowcrash/level05/metaverse.wat

level05@snowcrash:~$ cat /etc/systemd/system/metaverse.service
[Unit]
Description=Metaverse WASM runtime (one-shot)
After=network.target

[Service]
Type=oneshot
User=flag05
ExecStart=/usr/local/bin/wasmtime --dir=/ /opt/snowcrash/level05/metaverse.wasm
StandardOutput=journal
StandardError=journal
level05@snowcrash:~$ cat /etc/systemd/system/metaverse.timer
[Unit]
Description=Metaverse WASM runtime — runs every 30 seconds
Requires=metaverse.service

[Timer]
OnBootSec=15s
OnUnitActiveSec=30s
AccuracySec=1s

[Install]
WantedBy=timers.target

```
systemd  starts metaverse.wasm every 30 seconds and runs it as user: flag05
sice the .wasm file is writable by the metaverse group and level05

i created a .c file that cat the flag and store it , i compile it to .wasm file in my machine copy the wasm file to : 
/opt/snowcrash/level05/metaverse.wasm
