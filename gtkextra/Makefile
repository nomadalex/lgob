include ../config.mk
PKG_PACKAGES=gtkextra-3.0 $(PKG_LUA)
NAME=gtkextra.so
VERSION=`pkg-config --modversion gtkextra-3.0`
include ../flags.mk

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
