mod = {
    name = 'common',
    src  = 'interface.c'
}

compile(mod)
install(mod, LIB)
clean  (mod)

shell( sf('%s common/src/types.h %s/include/lgob/common/types.h', INST, DEST) )
