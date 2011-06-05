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

	gb=grd.create("GRD_FMT_U8_BGRA","cards/mask_test.png")
	
	tp=gb:pixels(0,0,100,142)

	for k,v in ipairs({'h','d','s','c','b'}) do
	for i=1,13 do
	if v~='b' or i<3 then
	
	ga=grd.create("GRD_FMT_U8_BGRA",format("cards/out/%s%02d.png",v,i))
	
	print("doing "..format("cards/out/%s%02d.png",v,i))

	pp=ga:pixels(0,0,100,142)
	
	for i=0,((142*100)-1) do
		if tp[i*4+3]==0 then pp[i*4+0+1]=0; pp[i*4+1+1]=0; pp[i*4+2+1]=0; pp[i*4+3+1]=0; end
	end
	
	ga:pixels(0,0,100,142,pp)
	ga:convert("GRD_FMT_U8_INDEXED")
	ga:save(format("cards/out2/%s%02d.png",v,i))

	end
	end
	end

end


