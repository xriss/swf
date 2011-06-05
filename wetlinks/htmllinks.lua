#!../../bin/XPP


require("src/LinksData")

local h=""

for i,v in ipairs(LinksData) do
if v.lnksml then

local s= "\n".. v.nam1 .. " : " .. v.txt2 .. "\n".. v.lnksml .."\n"

h=h..s

end
end


local fp

fp=io.open("art/links.txt","w")
fp:write(h)
fp:close()


local h=""

h=h..[[<?xml version="1.0" encoding="utf-8"?>
<feed xmlns="http://www.w3.org/2005/Atom" xmlns:media="http://search.yahoo.com/mrss/">
]]

for i,v in ipairs(LinksData) do
	if v.dir1 then

	local s= [[
 <entry>
 
   <title>]]..(v.nam1)..[[</title>
   
   <subtitle>]]..(v.txt1 or v.nam1)..[[</subtitle>
   
   <description>]]..(v.txt2 or v.nam1)..[[</description>

   <longdescription>]]..(v.txt3 or v.nam1)..[[</longdescription>
   
   <dir name="]]..(v.dir1)..[[" />   
   <like href="http://like.wetgenes.com/-/game/]]..(v.lnkid or 0)..[[/]]..(v.nam1)..[[" />
   <link href="http://games.wetgenes.com/games/]]..(v.nam1)..[[.php" />
   <icon href="]]..(v.img3)..[[" />
   <game href="http://www.wetgenes.com/link/]]..(v.nam1)..[[.swf" />
   <mochibot href="]]..(v.mbot or "http://www.mochibot.com/")..[[" />
   
 </entry>
]]
	h=h..s

	end
end

h=h..[[
</feed>
]]


fp=io.open("art/games.xml","w")
fp:write(h)
fp:close()





local h=""

h=h..[[<?xml version="1.0" encoding="utf-8"?>
<feed xmlns="http://www.w3.org/2005/Atom" xmlns:media="http://search.yahoo.com/mrss/">
]]

for i,v in ipairs(LinksData) do
	if v.dir1 then
	
	local desc=v.txt2
	if not desc or desc=="" then desc=v.txt1 end
	if not desc or desc=="" then desc=v.nam1 end

	local s= [[
 <entry>

   <title>]]..(v.nam1)..[[</title>
   <media:player url="http://www.wetgenes.com/link/]]..(v.nam1)..[[.swf" width="960" height="480"></media:player>
   
   <media:thumbnail url="]]..(v.img3)..[[" width="100" height="100"></media:thumbnail>
   
   <media:description>
]]..(desc)..[[
   </media:description>
   <media:keywords>wetgenes</media:keywords>
	
</entry>
]]
	h=h..s

	end
end

h=h..[[
</feed>
]]


fp=io.open("art/wetgenes.xml","w")
fp:write(h)
fp:close()

