found a runing serivce called blcaksun and its  c code blacksun.c


the important things are

#define FLAG_PATH       "/home/flag08/.flag"
the read_flag funtion 
and the maroc like funtion

#define CHECK_STATE(ctx, required)                                      \
    ( ((required) == STATE_ADMIN)                                       \
        ? ((ctx)->state >= STATE_AUTH)                                  \
        : ((ctx)->state == (required)) )

since wirting the server the CMD_ADMIN will lead CMD_ADMIN: access denied error ,
because of the CHECK_STATE funtion

we can write at frist the CMD_HELLO this will lead to store ctx.state = STATE_AUTH;
then send CMD_ADMIN in the same connection , 

we will implement this in clinet.py file and run it ,then 

level08@snowcrash:~$ python3 cline.py 
HELLO OK

ACCESS GRANTED
FLAG=s5cAhoAfNT9GrgqykhZavyBg9

