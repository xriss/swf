#!../../bin/XPP

require 'bake/bake'

bake.cd_base		=	bake.get_cd()
bake.set_cd(bake.get_cd()..'/../../..')
bake.cd=bake.get_cd()
bake.cmd.swfmill	=	bake.path_clean_exe( bake.cd , '/_swfmill/swfmill' )
bake.set_cd(bake.cd_base)

xtra.makedir('out')

local format=string.format

local outdir="out/"

local files=
{
	{
		outname="game",
		infiles="game_%02d.png",
	},
	{
		outname="menu",
		infiles="menu_%02d.png",
	},
}

function exists(n)
	local f=io.open(n)
	if f then
		io.close(f)
		return true
	end
	return false
end


for _,it in ipairs(files) do

local outname=it.outname
local infiles=it.infiles

local boxname=it.boxname


local swf_frames
function swf_start()

	swf_frames={}
end
function swf_add_frame(name,x,y,w,h)
	table.insert(swf_frames,{ name=name,x=x,y=y,w=w,h=h } )
end
function swf_end()
end

function swf_write(filename,w,h)



local head=
[[
<?xml version="1.0" encoding="iso-8859-1" ?>

<movie version="8" width="]]..w..[[" height="]]..h..[[" framerate="50">

  <background color="#000000"/>
	  
]]

local tail=
[[
</movie>
]]



local code=format( "X%08x", os.time() )

local s=""

s=s..head
s=s.."<library>\n"

for i,v in ipairs(swf_frames) do

	s=s..[[<clip id="]]..code..i..[[" import="]]..v.name..[["/>]]
	s=s.."\n"
end

s=s.."</library>\n"

for i,v in ipairs(swf_frames) do

	s=s.."<frame>\n"
	s=s..[[<place id="]]..code..i..[[" x="]]..v.x..[[" y="]]..v.y..[[" depth="1"/> ]]
	s=s.."\n"
	s=s.."</frame>\n"
end
s=s..tail



	local f=io.open(filename..".xml","w")
	f:write(s)
	io.close(f)

	bake.execute( bake.cd_base , bake.cmd.swfmill , '-v simple '..filename..'.xml '..filename..".swf" )
	
end




local ga,gb,gc

swf_start()
for i=1,100 do


local filename=format(infiles,i)

	if not exists(filename) then break end
	
	ga=grd.create("GRD_FMT_U8_BGRA",filename)
	
	print(filename)
	
	local minx=ga.width-1
	local maxx=0
	
	local miny=ga.height-1
	local maxy=0

	
-- pixels are 1=A 2=R 3=G 4=B , so we test for alpha > 0 and clip to smallest area

	for y=0,ga.height-1 do
	
		local clear=true
		local t=ga:pixels(0,y,ga.width,1)
		
		for i=0,ga.width-1 do
			if t[ i*4 + 1 ] > 0 then clear=false break end
		end

		if not clear then
			if y>maxy then maxy=y end
			if y<miny then miny=y end
		end
	end

	for x=0,ga.width-1 do
	
		local clear=true
		local t=ga:pixels(x,0,1,ga.height)
		
		for i=0,ga.height-1 do
			if t[ i*4 + 1 ] > 0 then clear=false break end
		end

		if not clear then
			if x>maxx then maxx=x end
			if x<minx then minx=x end
		end
	end
	
	local width=1+maxx-minx
	local height=1+maxy-miny
	
	print(minx,miny,width,height)
	
	if width>0 and height>0 then

		gb=grd.create("GRD_FMT_U8_BGRA",width,height,1) -- damn bug, but my compiler isn't installed so...
		gb:save(outdir..filename) -- save to fix glitch then 
		gb=grd.create("GRD_FMT_U8_BGRA",outdir..filename) -- open to fix glitch :)
		
		gb:pixels(0,0,width,height, ga:pixels(minx,miny,width,height) )
		
		gb:save(outdir..filename)
		
		
		swf_add_frame(outdir..filename,minx,miny,width,height)
	else
		swf_add_frame("",0,0,0,0)
	end
	
	
	
end
swf_end()

swf_write(outname,ga.width,ga.height)


if boxname then -- create a box info file

	local box={}

	ga=grd.create("GRD_FMT_U8_IDX",boxname)
	
	for y=0,ga.height-1 do
	
		local t=ga:pixels(0,y,ga.width,1)
		
		for x=0,ga.width-1 do
		
			local idx=t[ x + 1 ]
			
			if not box[idx] then -- create info
			
				box[idx]={}
				
				box[idx].x_min=x
				box[idx].y_min=y
				
				box[idx].x_max=x
				box[idx].y_max=y
				
			else -- expand info
			
				if x < box[idx].x_min then box[idx].x_min=x end
				if x > box[idx].x_max then box[idx].x_max=x end
				if y < box[idx].y_min then box[idx].y_min=y end
				if y > box[idx].y_max then box[idx].y_max=y end
			
			end
			
		end

	end
	
	local f=io.open(outname.."_box.as","w") -- create raw data to be included in another file
	
	f:write( string.format("[") )
	
	local addcomma=false
		
	for i=0,255 do
	
		local x=0
		local y=0
		local w=0
		local h=0
		
		if box[i] then
		
			if addcomma then f:write(",") else addcomma=true end
		
			x=box[i].x_min
			y=box[i].y_min
			w=1 + box[i].x_max - box[i].x_min
			h=1 + box[i].y_max - box[i].y_min
	
			f:write(string.format("\n[%3d,%3d,%3d,%3d]",x,y,w,h) )
		
		end
			
	end
	f:write( string.format("\n];\n") )
	
	f:close()


end


end
