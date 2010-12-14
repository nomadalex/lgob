include ../config.mk
PKG_PACKAGES=$(PKG_LUA)
NAME=gtkextra.so
VERSION=`pkg-config --modversion gtkextra-3.0`
include ../flags.mk
CFLAGS+=-pthread -I/usr/include/gtkextra-2.0 -I/usr/include/glib-2.0 -I/usr/lib/glib-2.0/include -I/usr/include/gtk-2.0 -I/usr/lib/gtk-2.0/include -I/usr/include/atk-1.0 -I/usr/include/cairo -I/usr/include/gdk-pixbuf-2.0 -I/usr/include/pango-1.0 -I/usr/include/pixman-1 -I/usr/include/freetype2 -I/usr/include/libpng14
LDFLAGS+=-pthread -lgtkextra-x11-2.0 -lgtk-x11-2.0 -lgdk-x11-2.0 -latk-1.0 -lgio-2.0 -lpangoft2-1.0 -lpangocairo-1.0 -lgdk_pixbuf-2.0 -lm -lcairo -lpng14 -lpango-1.0 -lfreetype -lfontconfig -lgobject-2.0 -lgmodule-2.0 -lgthread-2.0 -lrt -lglib-2.0

$(NAME): gtkextra.o
	$(CC) gtkextra.o -o $(NAME) $(LDFLAGS)

src/iface.c: src/gtkextra.def src/gtkextra.ovr
	$(GEN) -i "$(PWD)/src/gtkextra.ovr" -o "$(PWD)/src/iface.c" -l "$(PWD)/log" -v $(VERSION)

gtkextra.o: src/iface.c src/gtkextra.c
	$(CC) $(CFLAGS) src/iface.c -o gtkextra.o

.PHONY: install
install: $(NAME)
	$(MKDIR) $(DESTDIR)/lib/lua/5.1/lgob/
	$(CP) $(NAME) $(DESTDIR)/lib/lua/5.1/lgob
	
.PHONY: uninstall
uninstall:
	$(RM) $(DESTDIR)/lib/lua/5.1/lgob/$(NAME)
	
clean:
	$(RM) gtkextra.o $(NAME) src/iface.c log
	
.PHONY: help
help:
	@echo Options:
	@echo
	@echo AMD64=1 to build for 64 bits
