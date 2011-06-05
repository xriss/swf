

local gamename="Run1"

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
	
end



do_level("level_01")

