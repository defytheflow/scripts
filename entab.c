#include <io.h>

#include <stdio.h>

#define TAB 8
#define MAX_LINE 256

int check_next(char line[], int index, int count, char c)
{
        for (int i = 0; i < count; ++i, ++index) {
                if (line[index] != c)
                        return 0;
        }
        return 1;
}

int main(void)
{
        int i, len;
        char line[MAX_LINE];

        while ((len = get_line(line, MAX_LINE)) > 0) {

                for (i = 0; i < len - TAB + 1; ++i) {
                        if (line[i] == ' ' && check_next(line, i + 1, TAB - 1, ' ')) {
                                putchar('\t');
                                i += TAB - 1;
                        } else
                                putchar(line[i]);
                }
                for (; i < len; ++i)
                        putchar(line[i]);
        }

        return 0;
}
