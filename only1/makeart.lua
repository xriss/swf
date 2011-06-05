

if arg[1]=="skip" then skip_argb=true end

	
local gamename="Run1"

--
-- Process level pngs into data 
--


function do_argb_jpeg(name)

	if skip_argb then return end


	local g=grd.create("GRD_FMT_U8_BGRA","art/levels/"..name..".png")
	
	for y=0,g.height-1 do -- illustrator creates crap, clean it up
	
		local d=g:pixels(0,y, g.width,1)
		
		for x=0,g.width-1 do
		
			if d[x*4+1]==0 then 
				d[x*4+4]=0
				d[x*4+3]=0
				d[x*4+2]=0
			end
		end
	
		g:pixels(0,y, g.width,1, d)
		
	end
	
	g:save("art/levels/"..name..".rgb.jpg")
	
	for y=0,g.height-1 do
	
		local d=g:pixels(0,y, g.width,1)
		
		for x=0,g.width-1 do
		
			d[x*4+4]=d[x*4+1]
			d[x*4+3]=d[x*4+1]
			d[x*4+2]=d[x*4+1]
			d[x*4+1]=255
		end
	
		g:pixels(0,y, g.width,1, d)
		
	end
	
	g:save("art/levels/"..name..".a.jpg")

end

function do_level(name)

	local tab={}
	local tabs={}
	local bag={}
	local lmap,lkey,lbag

	print( "\n--CREATING-- data/" .. name .. ".dat\n" )

	lkey=mmap.alloc()

	lkey.grd=grd.create("GRD_FMT_U8_INDEXED","art/levels/key.col.png")
	lkey:cutup( 20 , 20 )


	lmap=mmap.alloc()
	lmap.grd=grd.create("GRD_FMT_U8_INDEXED","art/levels/" .. name ..".col.png")
	lmap:cutup( 20 , 20 )
	lmap:merge()
	lmap:keymap(lkey)

	for y=(lmap.grd.height/20)-1 , 0 , -1 do
	local s=""
	local x_start

		for x= 0 , (lmap.grd.width/20)-1 , 1 do
		local t={}
		local tx,ty,id

			lmap:get_master_tile(t,x,y)
			tx=t.x/20
			ty=t.y/20

			id=tx+(ty*16)
			
			table.insert(tab,id)

			s=s..id
			if x~=(lmap.grd.width/20)-1 or y~=0 then s=s.."," end
		end
		table.insert(tabs,s)
		print(s.."\n")
	end




local fp

	fp=io.open("src/"..gamename.."Level_" .. name .. ".as","w")

	fp:write( "class "..gamename.."Level_" .. name .. "\n{\n")
	
	fp:write( "var img_bak=\""..name.."_bak\";\n" )
	fp:write( "var img_for=\""..name.."_for\";\n" )
	fp:write( "var name=\""..name.."\";\n" )
	
	fp:write( "var pw="..lmap.grd.width..";\n" )
	fp:write( "var ph="..lmap.grd.height..";\n" )
	
	fp:write( "var cw="..(lmap.grd.width/20)..";\n" )
	fp:write( "var ch="..(lmap.grd.height/20)..";\n" )
	
	fp:write( "var col=\"\n" )
	
	for i=1,#tabs do

		fp:write( tabs[i].."\n" )

	end
	
	fp:write( "\";\n" )
	
	fp:write( "}\n" )

	fp:close()
	fp=null
	
	
	do_argb_jpeg(name..".bak")
	
	for i=1,5 do
	
		local fn=name..".p0"..i
		
		local f=io.open("art/levels/"..fn..".png","r")
		if f then
			f:close()
			do_argb_jpeg(fn)
		end
	
	end
	
end



do_level("level_00")
do_level("level_01")
do_level("level_02")
do_level("level_03")
do_level("level_04")
do_level("level_05")

