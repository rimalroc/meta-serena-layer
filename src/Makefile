# Cross compiler
CC := aarch64-linux-gnu-gcc
CFLAGS := -O2 -Wall

# Output directory
BINDIR := bin/aarch64

# Sources and corresponding binaries
SRCS := gpio_toggle.c mempeek.c myaccip_uio.c ps_gpio_toggle.c
BINS := $(SRCS:%.c=$(BINDIR)/%)

.PHONY: all clean

all: $(BINDIR) $(BINS)

# Ensure output directory exists
$(BINDIR):
	mkdir -p $(BINDIR)

# Compile each source into bin/aarch64/<name>
$(BINDIR)/%: %.c
	$(CC) $(CFLAGS) $< -o $@

clean:
	rm -rf $(BINDIR)
