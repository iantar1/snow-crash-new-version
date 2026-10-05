#include <fcntl.h>
#include <unistd.h>

int main(void)
{
    int in = open("/home/flag05/.flag", O_RDONLY);
    int out = open("/tmp/flag05_result", O_WRONLY | O_CREAT | O_TRUNC, 0644);

    char buffer[4096];
    ssize_t n;

    while ((n = read(in, buffer, sizeof(buffer))) > 0)
        write(out, buffer, n);

    close(in);
    close(out);

    return 0;
}