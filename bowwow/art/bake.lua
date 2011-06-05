#!../../bin/XPP

local format=string.format

outdir="out"



xtra.makedir('out')
xtra.makedir('out/binion')
xtra.makedir('out/brush')


-- convert brushs to lossy jpgs
if true then

local ga,gb
local ta,tb
local tab=
{
	"sky00",
	"dirt00",
	"flat00",
}

	for i,v in ipairs(tab) do
	
		ga=grd.create("GRD_FMT_U8_BGRA",format("brush/%s.png",v))
		gb=grd.create("GRD_FMT_U8_BGRA",256+3,512+3,1)
		
		gb:pixels(0,0,256,512,ga:pixels(0,0,256,512))
		
-- dupe pixels to the right/bottom to reduce flash holes
		gb:pixels(0,512,256,1,gb:pixels(0,511,256,1))
		gb:pixels(256,0,1,512,gb:pixels(255,0,1,512))
		gb:pixels(256,512,1,1,gb:pixels(0,0,1,1))
		
		gb:pixels(0,513,257,2,gb:pixels(0,511,257,2))
		gb:pixels(257,0,2,513,gb:pixels(255,0,2,513))
		gb:pixels(257,513,2,2,gb:pixels(0,0,2,2))
		
		gb:save(format("out/brush/%s.jpg",v))
	end

end




if true then

local ga,gb
local basename

local meatname,maskname

local ta,tb
		
	basename='bbow_arms_00'
	maskname='bbow_arms_mask00'
	meatname='bbow_arms_meat00'
	
	for i=40,60 do
	
		ga=grd.create("GRD_FMT_U8_BGRA",format("binion/%s%02d.png",maskname,i))
		gb=grd.create("GRD_FMT_U8_BGRA",format("binion/%s%02d.png",meatname,i))
		
		ga:conscale(128,1.5)
		
		for y=0,255 do
		
			ta=ga:pixels(0,y,256,1)
			tb=gb:pixels(0,y,256,1)
			
			for x=0,255 do

				tb[x*4+1]=ta[x*4+2]
			
			end
			
			gb:pixels(0,y,256,1,tb)
			
		end

		gb:save(format("out/binion/%s%02d.png",basename,i))

	end
	
	basename='bbow_feet_00'
	maskname='bbow_feet_mask00'
	meatname='bbow_feet_meat00'
	
	for i=40,60 do
	
		ga=grd.create("GRD_FMT_U8_BGRA",format("binion/%s%02d.png",maskname,i))
		gb=grd.create("GRD_FMT_U8_BGRA",format("binion/%s%02d.png",meatname,i))
		
		ga:conscale(128,1.5)
		
		for y=0,255 do
		
			ta=ga:pixels(0,y,256,1)
			tb=gb:pixels(0,y,256,1)
			
			for x=0,255 do

				tb[x*4+1]=ta[x*4+2]
			
			end
			
			gb:pixels(0,y,256,1,tb)
			
		end

		gb:save(format("out/binion/%s%02d.png",basename,i))

	end

	
end



