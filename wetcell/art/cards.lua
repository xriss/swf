#!../../bin/XPP

local format=string.format

outdir="out"


do

local ga,gb,gc
local t

local it,il,ir,ib
local tla,tlb,tra,trb,bla,blb,bra,brb

local gg;

	gb=grd.create("GRD_FMT_U8_BGRA","cards/overlay.png")
	
	it=gb:pixels(0,0,100,2)
	il=gb:pixels(0,0,2,142)
	ir=gb:pixels(98,0,2,142)
	ib=gb:pixels(0,140,100,2)

	tla=gb:pixels(0,0,3,4)
	tlb=gb:pixels(0,0,4,3)

	tra=gb:pixels(100-3,0,3,4)
	trb=gb:pixels(100-4,0,4,3)

	bla=gb:pixels(0,142-4,3,4)
	blb=gb:pixels(0,142-3,4,3)

	bra=gb:pixels(100-3,142-4,3,4)
	brb=gb:pixels(100-4,142-3,4,3)

	for k,v in ipairs({'h','d','s','c','b'}) do
	for i=1,13 do
	if v~='b' or i<2 then
	
	gc=grd.create("GRD_FMT_U8_BGRA",format("cards/%s%02d.png",v,i))
	ga=grd.create("GRD_FMT_U8_BGRA","cards/overlay.png")
	ga:pixels(0,1,100,140, gc:pixels(0,0,100,140) )

	
	print("doing "..format("cards/%s%02d.png",v,i))

--[[ apply grad
	for y=1,142 do
	
		local grad=1
		
		if y<=71 then
		
			grad=0-(((71-y)/71)*(64))
		
		else
		
			grad=0+(((y-71)/71)*(64))
			
		end
			
		gg=ga:pixels(0,y-1,100,1)
	
		for x=1,100 do
		
			for c=1,3 do
			
			local t
			
				t=gg[ 1 + (x-1)*4 + c ]
				
				t=math.floor(t+grad)
				if t<0 then t=0 end
				if t>255 then t=255 end
				
				gg[ 1 + (x-1)*4 + c ]=t
				
			end
		
		end
		
		ga:pixels(0,y-1,100,1,gg)
	
	end
]]	
	ga:pixels(0,0,100,2,it)
	ga:pixels(0,0,2,142,il)
	ga:pixels(98,0,2,142,ir)
	ga:pixels(0,140,100,2,ib)

	ga:pixels(0,0,3,4,tla)
	ga:pixels(0,0,4,3,tlb)

	ga:pixels(100-3,0,3,4,tra)
	ga:pixels(100-4,0,4,3,trb)

	ga:pixels(0,142-4,3,4,bla)
	ga:pixels(0,142-3,4,3,blb)

	ga:pixels(100-3,142-4,3,4,bra)
	ga:pixels(100-4,142-3,4,3,brb)

	ga:convert("GRD_FMT_U8_INDEXED");
	ga:save(format("cards/out/%s%02d.png",v,i))

	end
	end
	end
	

--[[
	gb=grd.create('GRD_FMT_U8_INDEXED',100,142,1)
	gb:palette(0,256, ga:palette(0,256) ) -- copy pal to new grd

	for iy=0,3 do

		for ix=0,7 do

			t=ga:pixels(8+ix*40,8+iy*40,32,32)
			gb:pixels(0,0,32,32,t)
			gb:save(string.format("out/art/part%03d.png",(iy*8+ix)))

		end
	end
]]

end


