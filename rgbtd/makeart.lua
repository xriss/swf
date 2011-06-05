



--
-- Process level pngs into data 
--

function do_level(name)

	local tab={}
	local tabs={}
	local bag={}
	local lmap,lkey,lbag

	print( "--CREATING-- data/" .. name .. ".dat\n" )

	lkey=mmap.alloc()

	lkey.image=devil.alloc()
	lkey.image:load( "art/levels/key.col.png")
	lkey:cutup( 5 , 5 )


	lmap=mmap.alloc()
	lmap.image=devil.alloc()
	lmap.image:load( "art/levels/" .. name ..".col.png")
	lmap:cutup( 5 , 5 )
	lmap:merge()
	lmap:keymap(lkey)

	
	
	for y=0 , 29 , 1 do
	local s=""
	local x_start

		for x= 0 , 29 , 1 do
		local t={}
		local tx,ty,id

			lmap:get_master_tile(t,x,y)
			tx=t.x/5
			ty=t.y/5

			id=tx+(ty*16)
			
			table.insert(tab,id)

			s=s..string.format("0x%02x",id)
			if x~=29 or y~=29 then s=s.."," end
		end
		table.insert(tabs,s)
--		print(s.."\n")
	end




local fp

	fp=io.open("src/rgbtd_" .. name .. ".as","w")

	fp:write( "class rgbtd_" .. name .. "\n{\n")
	
--	fp:write( "var img_bak=\""..name.."_bak\";\n" )
--	fp:write( "var img_for=\""..name.."_for\";\n" )
	fp:write( "var name=\""..name.."\";\n" )
	
	fp:write( "var col=[\n" )
	
	for i=1,#tabs do

		fp:write( tabs[i].."\n" )

	end
	
	fp:write( "];\n" )
	
	fp:write( "}\n" )

	fp:close()
	fp=null

--[[
local g

-- build a mini jpg
	g=grd.create("GRD_FMT_U8_RGBA","art/levels/" .. name ..".bak.png")	
	g:scale(400,300,1)
	g:save("art/levels/" .. name ..".bak.mini.jpg")
]]
	
end




do_level("level00")
do_level("level01")
do_level("level02")
do_level("level03")
do_level("level04")
do_level("level05")
do_level("level06")
do_level("level07")
do_level("level08")
do_level("level09")
do_level("level10")
do_level("level11")
do_level("level12")
do_level("level13")
do_level("level14")
do_level("level15")
do_level("level16")
do_level("level17")
do_level("level18")
do_level("level19")
do_level("level20")
do_level("level21")
do_level("level22")
do_level("level23")
do_level("level24")




