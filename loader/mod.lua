mod = {
    name = 'loader',
    src  = 'loader.c'
}

compile(mod)
shell( sf('%s loader/src/loader.lua %s/%s/loader.lua', INST, DEST, SHARED) )
shell( sf('%s loader/src/loader.%s %s/%s/_loader.%s', INST, EXT, DEST, LIB, EXT) )
clean  (mod)
