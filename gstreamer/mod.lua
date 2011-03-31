mod = {
    name = 'gstreamer',
    src  = 'interface.c',
    pkg  = 'gstreamer-interfaces-0.10'
}

compile(mod)
install(mod, LIB)
clean  (mod)
