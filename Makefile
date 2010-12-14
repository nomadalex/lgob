# Usage: make DESTDIR=/absolute/path
SUBDIRS=codegen common gobject loader cairo gdk gtk \
	pango pangocairo atk vte webkit gstreamer gtkspell gtksourceview goocanvas \
	poppler clutter cluttergtk gtkextra

.PHONY: $(SUBDIRS)

all:
	for dir in $(SUBDIRS); do \
		$(MAKE) -C $$dir; \
		$(MAKE) -C $$dir install; \
	done

clean:
	for dir in $(SUBDIRS); do $(MAKE) -C $$dir clean; done
