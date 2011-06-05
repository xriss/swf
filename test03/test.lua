#!../../bin/XPP


require("dump")
require("simpxml")




local t={}

t.poop="arrr"

local fp=assert(io.open("screen.svg","r"))
local xmls=fp:read("*all")
fp:close()

local xml=simpxml.parse(xmls)

local xml_svg=assert(simpxml.child(xml,"svg"))

print( "size : " .. xml_svg.width .. "x" .. xml_svg.height )

for i,v in ipairs(xml_svg) do
local tag=string.lower(v[0])

	if tag=="g" then

print( "layer : " .. v.id )

		for i,v in ipairs(v) do
		local tag=string.lower(v[0])
		
			if tag=="rect" then
			
print( "rect : " ..v.id.." : ".. v.x..","..v.y.." : "..v.width.."x"..v.height )

			end
		end
		
	end
	
end


--dump.tree(xml_g)
