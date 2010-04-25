#! /usr/bin/env lua

local lfs = require('lfs')

-- modules to parse a gir file and a devhelp file
local modules = {
	['atk'] = {
		gir 	= 'Atk-1.0.gir',
		devhelp = 'atk.devhelp2'
	},
	
	['clutter'] = {
		gir 	= 'Clutter-1.0.gir',
		devhelp = 'clutter.devhelp2'
	},
	
	['cluttergtk'] = {
		gir 	= 'GtkClutter-0.10.gir',
		devhelp = 'clutter-gtk.devhelp2'
	},
	
	['gdk'] = {
		gir 	= 'Gdk-2.0.gir',
		devhelp = 'gdk.devhelp2'
	},
	
	['goocanvas'] = {
		gir 	= 'GooCanvas-0.10.gir',
		devhelp = 'goocanvas.devhelp2'
	},
	
	['gtk'] = {
		gir 	= 'Gtk-2.0.gir',
		devhelp = 'gtk.devhelp2'
	},
	
	['gtksourceview'] = {
		gir 	= 'GtkSource-2.2.gir',
		devhelp = 'gtksourceview-2.0.devhelp2'
	},
	
	['pango'] = {
		gir 	= 'Pango-1.0.gir',
		devhelp = 'pango.devhelp2'
	},
	
	['pangocairo'] = {
		gir 	= 'PangoCairo-1.0.gir',
		devhelp = 'pango.devhelp2'
	},
	
	['pixbuf'] = {
		gir 	= 'GdkPixbuf-2.0.gir',
		devhelp = 'gdk-pixbuf.devhelp2'
	},
	
	['poppler'] = {
		gir 	= 'Poppler-0.8.gir',
		devhelp = 'poppler.devhelp2'
	},
	
	['vte'] = {
		gir 	= 'Vte-1.0.gir',
		devhelp = 'vte.devhelp2'
	},
}

local ex = function(cmd) print('----') print(cmd) print('----') os.execute(cmd) end
local sf = string.format
ex('mkdir -p def1 def2')

if lfs.attributes('gir-devhelp', 'mode') ~= 'directory' then
	ex('mkdir gir-devhelp')
	lfs.chdir('gir-devhelp')
	ex('tar xf ../gir-devhelp.tar.bz2')
	lfs.chdir('..')
end

-- gir -> def
for name, mod in pairs(modules) do
	ex( sf('lgob-gir-parser -i `pwd`/gir-devhelp/%s -o `pwd`/def1/%s.def -n %s', 
		mod.gir, name, name ) )
end

-- def -> versioned def
lfs.chdir('../codegen/src/')
local p = '../../res'

for name, mod in pairs(modules) do
	ex( sf('./update-version.lua %s/gir-devhelp/%s < %s/def1/%s.def > %s/def2/%s.def', p, 
		mod.devhelp, p, name, p, name ) )
end

-- install in the folders
lfs.chdir(p)

for name, mod in pairs(modules) do
	ex( sf('cp def2/%s.def ../%s/src/', name, name) )
end

-- fix for GdkPixbuf
ex('tail -n +3 def2/pixbuf.def > ../gdk/src/pixbuf.def')

-- fix for GtkSourceView
ex('echo "defLib = \'Gtk\'" > ../gtksourceview/src/gtksourceview.def')
ex('tail -n +2 def2/gtksourceview.def >> ../gtksourceview/src/gtksourceview.def')

-- fix for GooCanvas
ex('echo "defLib = \'GooCanvas\'" > ../goocanvas/src/goocanvas.def')
ex('tail -n +2 def2/goocanvas.def >> ../goocanvas/src/goocanvas.def')

-- clean
ex('rm -r def1 def2')
