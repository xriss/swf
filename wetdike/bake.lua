#!../../bin/exe/lua
require("apps").default_paths()

local bake_swf=require("wetgenes.bake.swf")

local opts={

	swf_name="WetDike"

}

opts.arg={...}

bake_swf.build(opts)

