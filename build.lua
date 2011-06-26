#! /usr/bin/env lua

--[[
    Why use Makefiles when there is Lua available?
    
    Usage: ./build module absolute_out_path [AMD64]
--]]

local base = _G
local _expandStr_mt = { __index = base }
function expandStr(str, t)
	if not t then t = { } end
	str = str:gsub('%$(%b())', function (s)
								   s = s:sub(2, #s-1)
								   local func = loadstring('return ' .. s)
								   local env = setmetatable(t, _expandStr_mt)
								   setfenv(func, env)
								   return tostring(func())
						   end)
	str = str:gsub('%$([%w_]+)', function (s)
								  return tostring(t[s] or base[s])
						  end)
	return str
end

sf = string.format
local sf = sf
es = expandStr
local es = es

local usage = es'Usage: $(arg[0]) module absolute_dest'

MODULE = assert(arg[1], usage)
DEST   = assert(arg[2], usage)
AMD64  = arg[3] == 'AMD64'
GEN    = DEST .. '/bin/lgob-generator'

function shell(cmd)
    local f = assert(io.popen(cmd), sf("Couldn't open the pipe for %s!", cmd))
    
    local a = f:read('*a')
    f:close()
    a = a:gsub('\n', '')
    
    return a
end

require('config')

function pkg(arg, pkgs)
    local p = table.concat(pkgs, ' ')
	local t = { p = p, arg = arg }
    return shell( es('$PKG $arg $p', t) )
end

function gen_iface(mod)
	local t = { pwd = shell(PWD), name = mod.name }
    t.input   = es('$pwd/$name/src/$name.ovr' , t)
    t.output  = es('$pwd/$name/src/iface.c', t)
    t.log     = es('$pwd/$name/src/log', t)
    t.version = pkg('--modversion', {mod.pkg})
    
    shell(es('$GEN -i $input -o $output -l $log -v $version', t))
end

function compile(mod)
	local t = { name = mod.name, src = mod.src or 'iface.c' }
    t.input    = es('$name/src/$src', t)
    t.output   = es('$name/src/$name.$EXT', t)
    t.pkgflags = pkg('--cflags --libs', {LUA_PKG, mod.pkg})

    shell(es('$CC $COMPILE_FLAGS -I$DEST/include $input -o $output $pkgflags', t))
end

function install(mod, d)
	local t = { name = mod.name, d = d }
    t.dir   = es('$name/src', t)
    local inst = mod.inst or {es('$name.$EXT', t)}
    
    for _, f in ipairs(inst) do
		t.f = f
        shell(es('$INST $dir/$f $DEST/$d/$f', t))
    end
end

function clean(mod)
	local t = {}
    t.dir   = mod.name .. '/src'
    local garb  = mod.garb or {'iface.c', 'log', mod.name .. '.' .. EXT}
    
    for _, f in ipairs(garb) do
		t.f = f
        shell(es('$RM $dir/$f', t))
    end
end

print( es'** Building module $MODULE with $COMPILE_FLAGS **' )
require( MODULE .. '/mod' )
