#!../../bin/XPP

local format=string.format

outdir="out"


do

local ga,gb
local t

local it,il,ir,ib
local tla,tlb,tra,trb,bla,blb,bra,brb

local gg;

for ii,vv in ipairs( {"fire","earth","air","water","ether"} ) do

for i=0,9 do
	ga=grd.create("GRD_FMT_U8_BGRA",format("objs/%s%04d.png",vv,i))
--	ga:scale(50,50,1)
	ga:convert("GRD_FMT_U8_INDEXED");
	ga:save(format("objs2/%s%04d.png",vv,i))
end		  
	
end


end


