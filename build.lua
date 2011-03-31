#! /usr/bin/env lua

--[[
    Why use Makefiles when there is Lua available?
    
    Usage: ./build module absolute_out_path [AMD64]
--]]

sf = string.format

function shell(cmd)
    local f = assert(io.popen(cmd), sf("Couldn't open the pipe for %s!", cmd))
    
    local a = f:read('*a')
    f:close()
    a = a:gsub('\n', '')
    
    return a
end

function pkg(arg, pkgs)
    local p = table.concat(pkgs, ' ')
    return shell( sf('%s %s %s', PKG, arg, p) )
end

function gen_iface(mod)
    local pwd     = shell(PWD)
    local input   = sf('%s/%s/src/%s.ovr' , pwd, mod.name, mod.name)
    local output  = sf('%s/%s/src/iface.c', pwd, mod.name)
    local log     = sf('%s/%s/src/log'    , pwd, mod.name)
    local version = pkg('--modversion'    , {mod.pkg})
    
    local cmd = sf('%s -i %s -o %s -l %s -v %s', GEN, input, output, log, version)
    shell(cmd)
end

function compile(mod)
    local input    = sf('%s/src/%s', mod.name, mod.src or 'iface.c')
    local output   = sf('%s/src/%s.%s', mod.name, mod.name, EXT)
    local pkgflags = pkg('--cflags --libs', {LUA_PKG, mod.pkg})
    local cmd      = sf('%s %s -I%s/include %s -o %s %s', CC, ARGS, DEST, input, output, pkgflags)
    shell(cmd)
end

function install(mod, d)
    local dir   = sf('%s/src', mod.name)
    local inst = mod.inst or {sf('%s.%s', mod.name, EXT)}
    
    for _, f in ipairs(inst) do
        local cmd = sf('%s %s/%s %s/%s/%s', INST, dir, f, DEST, d, f)
        shell(cmd)
    end
end

function clean(mod)
    local dir   = sf('%s/src', mod.name)
    local garb  = mod.garb or {'iface.c', 'log', mod.name .. '.' .. EXT}
    
    for _, f in ipairs(garb) do
        local cmd = sf('%s %s/%s', RM, dir, f)
        shell(cmd)
    end
end

local usage = sf([[Usage: %s module absolute_dest]], arg[0])

MODULE = assert(arg[1], usage)
DEST   = assert(arg[2], usage)
AMD64  = arg[3] == 'AMD64'
GEN    = DEST .. '/bin/lgob-generator'

require('config')
print( sf('** Building module %s with %s**', MODULE, ARGS) )
require( sf('%s/mod', MODULE) )
