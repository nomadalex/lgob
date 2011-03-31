mod = {
    name = 'gobject',
    pkg  = 'gobject-2.0'
}

gen_iface(mod)
compile  (mod)
install  (mod, LIB)
clean    (mod)

shell( sf('%s gobject/src/types.h %s/include/lgob/gobject/types.h', INST, DEST) )
