

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>

#define MAX_LINE 512

#define MAX_WS 32
#define HELP_MSG "Try 'ws -h' for more information."

void mark_left(char* line, size_t len);
void mark_right(char* line, size_t len);

typedef struct {

        char new_line[MAX_WS];
        char tab[MAX_WS];
        char space[MAX_WS];

} WhiteSpaceRepr;

void usage()
{
        puts("Displays white-space characters.\n");

        puts("Usage:");
        puts("  ws [options]\n");

        puts("Options:");
        puts("  -h           show this message.");
        puts("  -n <repr>    how to display a newline.");
        puts("  -s <repr>    how to display a space.");
        puts("  -t <repr>    how to display a tab.\n");
}

void parse_opts(int argc, char** argv, WhiteSpaceRepr* wsr)
{
        char c;
        opterr = 0;

        while ((c = getopt(argc, argv, "hn:s:t:")) != -1)
            switch (c) {
                case 'h':
                    usage();
                    exit(0);
                case 'n':
                case 's':
                case 't':
                    if (strlen(optarg) > MAX_WS) {
                        fprintf(stderr, "Error: option '-%c' <repr> argument "
                                        "exceed buffer limit.\n", optopt);
                        fprintf(stderr, "%s\n", HELP_MSG);
                        exit(1);
                    }
                    if (optopt == 'n')
                        strcpy(wsr->new_line, optarg);
                    else if (optopt == 's')
                        strcpy(wsr->space, optarg);
                    else
                        strcpy(wsr->tab, optarg);
                    break;
                case '?':
                    fprintf(stderr, "Error: ");
                    if (optopt == 'n' || optopt == 's' || optopt == 't')
                        fprintf(stderr, "option '-%c' requires an argument.\n",
                                optopt);
                    else
                        fprintf(stderr, "unknown option '-%c'.\n", optopt);
                    fprintf(stderr, "%s\n", HELP_MSG);
                    exit(1);
            }
}

int main(int argc, char** argv)
{
        int c, len, seen_words;
        char line[MAX_LINE];

        WhiteSpaceRepr wsr = { "\\n", "\\t", "-" };
        seen_words = 0;

        parse_opts(argc, argv, &wsr);
        printf("Newline is '%s', tab is '%s', space is '%s'\n",
                wsr.new_line, wsr.tab, wsr.space);
//        while ((len = get_line(line, MAX_LINE)) > 0) {
//
//                scan_left(line, len);
//                scan_right(line, len);

                // if we see a space and not yet seen any words.
//                if (c == ' ' && !seen_words)
//                        putchar(SPACE_MARK);
                // if we see a tab and not yet seen any words.
//                else if (c == '\t' && !seen_words)
//                        printf("%s", TAB_MARK);
                // if we reach end of the line, we reset 'seen_words'.
//                else if (c == '\n') {
//                        seen_words = 0;
//                        putchar(c);
//                } else {
//                        seen_words = 1;
//                        putchar(c);
//                }
//        }

        return 0;
}


