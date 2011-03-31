mod = {
    name = 'gtkieembed',
    pkg  = 'gtkieembed',
}

gen_iface(mod)
compile  (mod)
install  (mod, LIB)
clean    (mod)
