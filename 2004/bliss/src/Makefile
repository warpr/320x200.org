#  This file is part of Fairy, a Gameboy Advance test screen.
#  Copyright 2002 Kuno Woudt <warp-tmt@dds.nl>
#
#  This program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 2 of the License, or
#  (at your option) any later version.
#  
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with this program; see the file COPYING; if not, write to
#  the Free Software Foundation, Inc., 59 Temple Place, Suite 330,
#  Boston, MA  02111-1307  USA

           PHP = php -q

        SCRIPT = bliss_msg.php
       SOURCES = home.in releases.in members.in pictures.in attic.in links.in
       TARGETS = $(patsubst %.in, ../%.html, $(SOURCES))
        IMAGES = ../1 ../2 ../bg
   EXTRA_CLEAN = 1.xpm 2.xpm bg.xpm

# ok. here's a kludge to exploit a bug in the commandline php. :)
# (allthough another patsubst on '+' should fix things I guess).
          MENU = $(patsubst %.in, %, $(SOURCES))

.SUFFIXES:       # Delete the default suffixes
.SUFFIXES: .php

all: $(TARGETS)
img: $(IMAGES)


../%.html: %.in $(SCRIPT) $(SOURCES)
	$(PHP) $(SCRIPT) $< $(MENU) > $@

../%: %.xpm
	convert $< png:$@

1.xpm: $(SCRIPT)
	./1_xpm.sh `$(PHP) $(SCRIPT) border` > 1.xpm

2.xpm: $(SCRIPT)
	./2_xpm.sh `$(PHP) $(SCRIPT) marker` > 2.xpm

bg.xpm: $(SCRIPT)
	./bg_xpm.sh `$(PHP) $(SCRIPT) bg` > bg.xpm

clean:
	$(RM) $(TARGETS) $(IMAGES) $(EXTRA_CLEAN)
