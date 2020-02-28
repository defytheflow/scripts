#include <io.h>

#include <stdio.h>

#define WRAP 40
#define MAX_LINE 256

void print_wrap(const char line[])
{
        for (int i = 0; i < WRAP; ++i)
                putchar(line[i]);
        puts("");
}

int main(void)
{
        int len, wrap_count;
        char line[MAX_LINE];

        while ((len = get_line(line, MAX_LINE)) > 0) {
                if (len < WRAP)
                       printf("%s", line);
                else {
                        wrap_count = 0;
                        while (len > WRAP) {
                                print_wrap(line + WRAP * wrap_count);
                                len -= WRAP;
                                ++wrap_count;
                        }
                        printf("%s", line + WRAP * wrap_count);
                }
        }

        return 0;
}
