
require "tdata"
require "dump"



local tab={}


for _,nam in ipairs{"0"} do


local dat=tdata.load_xml( "art/data/pixl/"..nam..".xml" )

-- dump.tree(dat)

	if dat[1][0]=="pixls" then

		for i,v in ipairs(dat[1]) do

			if v[0]=="pixl" then
			
			
				v.id=tonumber(v.id)
			
				tab[v.id]={}
			
				local ox={v}
				
				tab[v.id].img="http://data.wetgenes.com/game/s/pixlcoop/pixl/"..nam.."/img/"..v.name..".png";
				
				table.insert(v,{[0]="img",src=tab[v.id].img})
				
				print(v.id,v.name)
					
				tdata.save_xml( ox , "art/data/pixl/"..nam.."/xml/"..v.id )
				
				for ii,vv in ipairs(v) do
				
					if vv[0]=="text" then
					
						tab[v.id].text=vv[1];
						
					end
				
					if vv[0]=="link" then
					
						tab[v.id].link=vv["href"];
						
					end
				end
				
			end

		end

	end

end


local fp=io.open("art/data/pixl/all.html","w")

if fp then

fp:write(
[[
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html lang="en">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>PixlCoop artwork</title>
</head>
<body>

<center><h1>
<a href="http://pixlcoop.wetgenes.com/">
Pixel artwork used in the game PixlCoop, click here to play it.
</a>
</h1></center>
]]
)
	for i,v in ipairs(tab) do

		fp:write("<center><div style='margin:64px'>\n")
		fp:write("<img src='"..v.img.."' width='256' height='256' />\n")
		fp:write("<img src='"..v.img.."' width='128' height='128' />\n")
		fp:write("<img src='"..v.img.."' width='64' height='64' />\n")
		fp:write("<img src='"..v.img.."' width='32' height='32' />\n")
		fp:write("<img src='"..v.img.."' width='16' height='16' />\n")
		fp:write("<br /><a href='"..v.link.."'>"..v.text.."</a>\n")
		fp:write("</div></center>\n")

	end

	
fp:write(
[[
</body>
</html>
]]
)

	fp:close()

end

