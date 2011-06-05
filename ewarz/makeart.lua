#!../../bin/XPP


require("dump")
require("simpxml")


local images={}

local coma_data={}

function coma(id)
	if coma_data[id] then
		return true
	else
		coma_data[id]=true
		return false
	end
end

function coma_clear(id)
	coma_data[id]=false
end

-----------------------------------------------------------------------------
--
-- split a string into a table
--
-----------------------------------------------------------------------------
function str_split(div,str)

  if (div=='') or not div then error("div expected", 2) end
  if (str=='') or not str then error("str expected", 2) end
  
  local pos,arr = 0,{}
  
  -- for each divider found
  for st,sp in function() return string.find(str,div,pos,true) end do
	table.insert(arr,string.sub(str,pos,st-1)) -- Attach chars left of current divider
	pos = sp + 1 -- Jump past current divider
  end
  
  if pos~=0 then
	table.insert(arr,string.sub(str,pos)) -- Attach chars right of last divider
  else
	table.insert(arr,str) -- return entire string
  end
  
  
  return arr
end


local art_base="art/pages/"


local fp=assert(io.open("art/pages/layout.svg","r"))
local xmls=fp:read("*all")
fp:close()

local xml=simpxml.parse(xmls)

local xml_svg=assert(simpxml.child(xml,"svg"))

print( "size : " .. xml_svg.width .. "x" .. xml_svg.height )

local fp=assert(io.open("art/data.as","w"))

--fp:write("\tstatic var 	".."pages".."={\n")

coma_clear("pages")

for i,v in ipairs(xml_svg) do
local tag=string.lower(v[0])

	if tag=="g" then

print( "layer : " .. v.label )

fp:write((coma("pages")and",\n")or"")
fp:write("\t\t"..(v.label)..":{\n")

local depth=0

		coma_clear("tags")
		for i,v in ipairs(v) do
		local tag=string.lower(v[0])
		local id=string.lower(v.id)
		local ids=str_split(".",id)
		
			if tag=="rect" then
				depth=depth+1
			
print( "rect : " ..v.id.." : ".. v.x..","..v.y.." : "..v.width.."x"..v.height )

fp:write((coma("tags")and",\n")or"")
fp:write("\t\t\t"..(ids[2] or id )..":{\n")
fp:write("\t\t\t\ttype:\""..ids[1].."\",\n")
fp:write("\t\t\t\tdepth:"..depth..",\n")
fp:write("\t\t\t\t"..string.format("w:%d,h:%d,x:%d,y:%d",v.width,v.height,v.x,v.y).."\n")
fp:write("\t\t\t}")


			elseif tag=="image" then
				depth=depth+1
			
print( "image : " ..v.id.." : ".. v.x..","..v.y.." : "..v.width.."x"..v.height.." : "..v.href )

				local filename=art_base..v.href
			
				images[filename]=true
				
fp:write((coma("tags")and",\n")or"")
fp:write("\t\t\t"..(v.id)..":{\n")
fp:write("\t\t\t\ttype:\"image\",\n")
fp:write("\t\t\t\tdepth:"..depth..",\n") 
fp:write("\t\t\t\tsrc:\""..filename.."\",\n")
fp:write("\t\t\t\t"..string.format("w:%d,h:%d,x:%d,y:%d",v.width,v.height,v.x,v.y).."\n")
fp:write("\t\t\t}")

			end
		end
		
fp:write((coma("tags")and"\n")or"")
fp:write("\t\t}")
	end
	
end
fp:write((coma("pages")and"\n")or"")
--fp:write("\t}\n")
fp:close()

--[[
	static var 	pages={
		main:{
			display:{
				type:"xhtml",
				w:600,h:440,x:20,y:20
			}
		}
	};
]]
	
	
local fp=assert(io.open("art/data.xml","w"))

for n,v in pairs(images) do

fp:write(string.format("<clip id=\"%s\" import=\"%s\"/>\n",n,n))

end

fp:close()

--dump.tree(xml_g)
