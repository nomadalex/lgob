#! /usr/bin/env lua

--[[
    Usage: ./build_all.lua 
--]]

local LUA = 'lua'

local modules = {
    'codegen',
    'common',
    'loader',
    'gobject',
    'gdk',
    'gtk',
    'cairo',
    'atk','clutter',
    'cluttergtk',
    'goocanvas',
    'gstreamer',
    'gtkextra',
    'gtkglext',
--  'gtkieembed',
    'gtksourceview',
    'gtkspell',
    'pango',
    'pangocairo',
    'poppler',
    'vte',
    'webkit',
}

local out   = assert(arg[1])
local flags = arg[2] or ''
local ex    = function(...) os.execute(string.format(...)) end

for _, mod in ipairs(modules) do
    ex('%s build.lua %s %s %s', LUA, mod, out, flags)    
end
