
require "tdata"
require "dump"



for _,nam in ipairs{"0"} do


local dat=tdata.load_xml( "art/data/pixl/"..nam..".xml" )

-- dump.tree(dat)

	if dat[1][0]=="pixls" then

		for i,v in ipairs(dat[1]) do

			if v[0]=="pixl" then
			
				local ox={v}
				
				table.insert(v,{[0]="img",src="http://data.wetgenes.com/game/s/pixlcoop/pixl/"..nam.."/img/"..v.name..".png"})
				
				print(v.id,v.name)
					
				tdata.save_xml( ox , "art/data/pixl/"..nam.."/xml/"..v.id )
				
			end

		end

	end

end
