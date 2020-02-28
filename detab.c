#include <stdio.h>

#define TAB 8

int main(void)
{
	char c;

	while ((c = (char) getchar()) != EOF) {
		if (c == '\t')
			for (int i = 0; i < TAB; ++i)
			putchar(' ');
		else
			putchar(c);
	}

	return 0;
}
