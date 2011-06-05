#!../../bin/XPP

local format=string.format

outdir="out"


do

local ga,gb
local t

local it,il,ir,ib
local tla,tlb,tra,trb,bla,blb,bra,brb

local gg;

local	tp,pp

	for k,v in ipairs({'h','d','s','c','b'}) do	for i=1,13 do if v~='b' or i<3 then
	
	ga=grd.create("GRD_FMT_U8_BGRA",format("cards/out/%s%02d.png",v,i))
	
	print("doing "..format("cards/out/%s%02d.png",v,i))
	
	ga:scale(50,71,1)
	ga:convert("GRD_FMT_U8_INDEXED")
	ga:save(format("cards/wii/%s%02d.png",v,i))

	end	end	end

end


