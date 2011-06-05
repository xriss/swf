



--
-- Process level pngs into data 
--

function do_level(name)

	local tab={}
	local tabs={}
	local bag={}
	local lmap,lkey,lbag

	print( "\n--CREATING-- data/" .. name .. ".dat\n" )

	lkey=mmap.alloc()

	lkey.image=devil.alloc()
	lkey.image:load( "art/levels/key.col.png")
	lkey:cutup( 20 , 20 )


	lmap=mmap.alloc()
	lmap.image=devil.alloc()
	lmap.image:load( "art/levels/" .. name ..".col.png")
	lmap:cutup( 20 , 20 )
	lmap:merge()
	lmap:keymap(lkey)

	
	
	for y=(30*5)-1 , 0 , -1 do
	local s=""
	local x_start

		for x= 0 , 39 , 1 do
		local t={}
		local tx,ty,id

			lmap:get_master_tile(t,x,y)
			tx=t.x/20
			ty=t.y/20

			id=tx+(ty*16)
			
			table.insert(tab,id)

			s=s..id
			if x~=39 or y~=0 then s=s.."," end
		end
		table.insert(tabs,s)
		print(s.."\n")
	end




local fp

	fp=io.open("src/MuteLevel_" .. name .. ".as","w")

	fp:write( "class MuteLevel_" .. name .. "\n{\n")
	
	fp:write( "var img_bak=\""..name.."_bak\";\n" )
	fp:write( "var img_for=\""..name.."_for\";\n" )
	fp:write( "var name=\""..name.."\";\n" )
	
	fp:write( "var col=[\n" )
	
	for i=1,#tabs do

		fp:write( tabs[i].."\n" )

	end
	
	fp:write( "];\n" )
	
	fp:write( "}\n" )

	fp:close()
	fp=null


local g,gs

-- split the level into screen size chunks as I think 3000 pixels will anoy flash

	gs=grd.create("GRD_FMT_U8_INDEXED",800,600,1)	
	
	g=grd.create("GRD_FMT_U32_RGBA","art/levels/" .. name ..".bak.png")
	g:convert("GRD_FMT_U8_INDEXED")
	
	
	for i=0,4 do
	
		for y=0,599 do
			gs:pixels( 0,599-y,800,1, g:pixels(0,i*600+y,800,1) )	--stoopidhax, must replace devil
		end
		
		gs:palette( 0,256, g:palette(0,256) )
	
		gs:save("art/levels/" .. name ..".bak."..i..".png")
		
	end
	
end



do_level("level_01")

