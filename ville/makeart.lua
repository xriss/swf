



--
-- Process level pngs into data 
--

function do_pos(name)

local img
local tabs

	img=grd.create("GRD_FMT_U8_INDEXED","art/pos/"..name..".png")

local dat

	tabs={}

	for yb=0,500,100 do
	
		for xb=0,700,100 do
		
			local s=""
				
			dat=img:pixels(xb,yb,100,100)
			
			for y=0,99 do
			
				for x=0,99 do
				
					if dat[(y*100+x+1)]~=0 then
					
						s=s..(x-50)..","..(y-100)..","
					end
				
				end
			
			end
			
			table.insert(tabs,s)
		
		end
	
	end



local fp

	fp=io.open("art/pos/"..name .. ".as","w")


	
	fp:write( "var pos_" .. name .. "=[\n" )
	for i=1,#tabs do

		fp:write( tabs[i].."\n" )

	end	
	fp:write( "0,0];\n" )

	fp:close()
	fp=null
	

	
end


do_pos("balloon")


