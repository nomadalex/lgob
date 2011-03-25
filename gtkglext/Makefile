include ../config.mk
PKG_PACKAGES=include ../config.mk
PKG_PACKAGES=gtkglext-1.0 $(PKG_LUA)
NAME=gtkglext.so
VERSION=`pkg-config --modversion gtkglext-1.0`
include ../flags.mk

$(NAME): gtkglext.o
	$(CC) gtkglext.o -o $(NAME) $(LDFLAGS)

gtkglext.o: src/gtkglext.c
	$(CC) $(CFLAGS) src/gtkglext.c -o gtkglext.o

.PHONY: install
install: $(NAME)
	$(MKDIR) $(DESTDIR)/lib/lua/5.1/lgob/
	$(CP) $(NAME) $(DESTDIR)/lib/lua/5.1/lgob
	
.PHONY: uninstall
uninstall:
	$(RM) $(DESTDIR)/lib/lua/5.1/lgob/$(NAME)
	
clean:
	$(RM) gtkglext.o $(NAME)
	
.PHONY: help
help:
	@echo Options:
	@echo
	@echo AMD64=1 to build for 64 bits
