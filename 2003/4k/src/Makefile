           PHP = php -q

        SCRIPT = 4k.php
       SOURCES = index.in rules.in submit.in results.in example.in
       TARGETS = $(patsubst %.in, ../%.html, $(SOURCES))

# ok. here's a kludge to exploit a bug in the commandline php. :)
# (allthough another patsubst on '+' should fix things I guess).
          MENU = $(patsubst %.in, %, $(SOURCES))

.SUFFIXES:       # Delete the default suffixes
.SUFFIXES: .php

all: $(TARGETS)

../%.html: %.in $(SCRIPT) $(SOURCES)
	$(PHP) $(SCRIPT) $< $(MENU) > $@

clean:
	$(RM) $(TARGETS)
