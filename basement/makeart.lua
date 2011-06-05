



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

	
	
	for y=29 , 0 , -1 do
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

	fp=io.open("src/WetBaseMentLevel_" .. name .. ".as","w")

	fp:write( "class WetBaseMentLevel_" .. name .. "\n{\n")
	
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


local g

-- build a mini jpg
	g=grd.create("GRD_FMT_U8_RGBA","art/levels/" .. name ..".bak.png")	
	g:scale(400,300,1)
	g:save("art/levels/" .. name ..".bak.mini.jpg")
	
end


do_level("level_test")


do_level("level_01")
do_level("level_02")
do_level("level_03")
do_level("level_04")
do_level("level_05")
do_level("level_06")
do_level("level_07")
do_level("level_08")
do_level("level_09")
do_level("level_10")


