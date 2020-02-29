/*
 * Compile with: gcc -o detab detab.c
 */

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

#define HELP_MSG "Try 'detab -h' for more information."

void usage()
{
        puts("Converts tabs to spaces.\n");

        puts("Usage:");
        puts("  detab [options]\n");

        puts("Options:");
        puts("  -h           show this message.");
        puts("  -t <size>    number of spaces per tab.\n");
}

void parse_opts(int argc, char** argv, int* tab_out)
{
        char c;
        opterr = 0;

        while ((c = getopt(argc, argv, "ht:")) != -1)
            switch (c) {
              case 'h':
                  usage();
                  exit(0);
              case 't':
                *tab_out = atoi(optarg);
                break;
              case '?':
                  fprintf(stderr, "Error: ");
                  if (optopt == 't')
                      fprintf(stderr, "option -'%c' requires an argument.\n",
                              optopt);
                  else
                      fprintf(stderr, "unknown option '-%c'.\n",
                              optopt);
                  fprintf(stderr, "%s\n", HELP_MSG);
                  exit(1);
            }
}

int main(int argc, char** argv)
{
        char c;
        int tab = 8;

        parse_opts(argc, argv, &tab);

        while ((c = (char) getchar()) != EOF) {
                if (c == '\t')
                        for (int i = 0; i < tab; ++i)
                        putchar(' ');
                else
                        putchar(c);
        }

        return 0;
}
