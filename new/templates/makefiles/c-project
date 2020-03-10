CC=gcc
CFLAGS=-g -Wall -W -Wconversion -Wshadow -Wwrite-strings -Wextra -std=c11
LDFLAGS=

INCS =
SRCS =
OBJS =

TARGET =

$(TARGET): $(OBJS)
	$(CC) $^ $(CFLAGS) $(LDFLAGS) -o $@

$(OBJS): $(SRCS) $(INCS)
	$(CC) -c $(CFLAGS) $^

.PHONY: clean
clean:
	rm -f *.o

.PHONY: install
install:
	#

.PHONY: uninstall
	#
