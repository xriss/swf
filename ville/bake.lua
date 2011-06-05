#!../bin/XPP


swf_name="WetVille"

dofile '../base/bake.lua'







for i,v in ipairs( bake.files_swf ) do

-- create data and copy the swf files 

	local fp=io.open('out/'..v..'.dat',"w")
	for i,v in pairs(urlcache) do
		if v.xml then -- very simple escaped strings table, to read, split on \n then split on = then unescape the data string
			local s=string.gsub(v.xml, "([&=%%\n])", function(c) return string.format("%%%02x", string.byte(c)) end)
			fp:write(v.url.."="..s.."\n")
		end
	end
	fp:close()
	
	xtra.copyfile( 'out/'..v..'.dat' , '../../www/wetgenes/subs/data/swf/'..v.."."..opts.VERSION_NUMBER..'.dat' )
	xtra.copyfile( 'out/'..v..'.dat' , '../../www/wetgenes/subs/data/swf/'..v..'.dat' )
	
	xtra.copyfile( 'out/'..v..'.swf' , '../../www/wetgenes/subs/data/swf/'..v.."."..opts.VERSION_NUMBER..'.swf' )
	xtra.copyfile( 'out/'..v..'.swf' , '../../www/wetgenes/subs/data/swf/'..v..'.swf' )

	
end


