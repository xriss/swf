
require 'bake/bake'

local mime = require("mime")


bake.cd_base=bake.get_cd()

bake.set_cd(bake.get_cd()..'/../..')
bake.cd=bake.get_cd()



bake.cmd.wav2swf	=	bake.path_clean_exe( bake.cd , '/_swftools/wav2swf' )
bake.cmd.swfmill	=	bake.path_clean_exe( bake.cd , '/_swfmill/swfmill' )
bake.cmd.sox		=	bake.path_clean_exe( bake.cd , '/_sox/sox' )
bake.cmd.oggdec		=	bake.path_clean_exe( bake.cd , '/_sox/oggdec' )



wav=
{
}


ogg=
{
	"walk",
	"jump01",
	"splat01",
}

aif=
{
}

ogg_mp3=
{
	"dweller",
	"splat02",
	"loading",
	"001",
	"man005",
	"man007",
	"man008",
	"ping04",
	"ping07",
	"scratch01",
	"scratch02",
	"sleeze01",
	"sleeze02",
	"sleeze03",
	"sleeze04",
	"sleeze05",
	"trump01",
	"trump02",
	"trump03",
	"uhm05",
	"uhm08",
	"uhm09",
	"uhm10",
	"well",
	"woman003",
	"woman004",
	"tune001",
	"man010",
	"tards",
	"rain",
	"cook",
	"portrait",
}


-- for some reason the base 64 encode in the mime module is broken?
-- possibly a low memory situation?
-- i have no idea, all i know is it has started crashing
-- so it is now replaced with this one until i work out what has gone wrong
-- http://lua-users.org/wiki/BaseSixtyFour

-- Lua 5.1+ base64 v3.0 (c) 2009 by Alex Kloss <alexthkloss@web.de>
-- licensed under the terms of the LGPL2

-- character table string
local b='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'

-- enconding
function b64enc(data)
    return ((data:gsub('.', function(x) 
        local r,b='',x:byte()
        for i=8,1,-1 do r=r..(b%2^i-b%2^(i-1)>0 and '1' or '0') end
        return r;
    end)..'0000'):gsub('%d%d%d?%d?%d?%d?', function(x)
        if (#x < 6) then return '' end
        local c=0
        for i=1,6 do c=c+(x:sub(i,i)=='1' and 2^(6-i) or 0) end
        return b:sub(c+1,c+1)
    end)..({ '', '==', '=' })[#data%3+1])
end

-- decoding
function b64dec(data)
    return (data:gsub('.', function(x)
        if (x == '=') then return '00' end
        local r,f='',(b:find(x)-1)
        for i=6,1,-1 do r=r..(f%2^i-f%2^(i-1)>0 and '1' or '0') end
        return r;
   end):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x)        
        if (#x ~= 8) then return '' end
        local c=0
        for i=1,8 do c=c+(x:sub(i,i)=='1' and 2^(8-i) or 0) end
        return string.char(c)
    end))
end



function build_xml_8bit_str( dat , nam )

-- mime.b64 is dying on a huge data input, so feed it smaller chunks

local len=string.len(dat)

local tab={}
local chunk=4*1024*6

	for i=0,len,chunk do
	
		local l=chunk
		if i+l > len then
			l=len-i
		end
	
		local s=string.sub(dat,i+1,i+l)
		local d= ( b64enc( s ) )
print(i,"/",len)
		table.insert( tab , d )
		
	end
print(len,"/",len)

local mim=table.concat(tab)

local ret=[[<?xml version="1.0"?>
<swf version="5" compressed="0">
  <Header framerate="9235" frames="1">
    <size>
      <Rectangle left="0" right="6000" top="0" bottom="6000"/>
    </size>
    <tags>
      <SetBackgroundColor>
        <color>
          <Color red="255" green="255" blue="255"/>
        </color>
      </SetBackgroundColor>
	  
      <DefineSound objectID="24" format="]].."3"..[[" rate="]].."2"..[[" is16bit="]].."1"..[[" stereo="]].."0"..[[" samples="]]..string.len(dat)..[[">
        <data>
<data>]]..(mim)..[[</data>
        </data>
      </DefineSound>
<Export>
<symbols>
<Symbol objectID="24" name="]].. nam ..[["/>
</symbols>
</Export>

]]
..
[[
      <StartSound objectID="24" stopPlayback="0" noMultiple="0" hasEnvelope="0" hasLoop="0" hasOutPoint="0" hasInPoint="0"/>
]]
..
[[      <ShowFrame/>
      <End/>
    </tags>
  </Header>
</swf>
]]


	return ret

end




-- convert to 8bit mono in sox...
--sox.exe  sfx/splash.wav -r 5512 -c 1 -s -b sfx/splash.raw



local dat
local fp

for i,v in ipairs(wav) do

-- create raw 8bit file for importing into xml
	bake.execute( bake.cd_base , bake.cmd.sox , 'sfx/'..v..'.wav -r 22050 -c 1 -s -b 16 --endian little sfx/'..v..'.raw' )

	fp=assert(io.open("sfx/"..v..".raw","rb"))
	dat=fp:read("*a")
	fp:close()
	fp=assert(io.open("sfx/"..v..".xml","w"))
	fp:write( build_xml_8bit_str(dat,"sfx_"..v) )
	fp:close()
	bake.execute( bake.cd_base , bake.cmd.swfmill , '-v xml2swf sfx/'..v..'.xml sfx/'..v..'.swf' )
	
	os.remove('sfx/'..v..'.xml');
	os.remove('sfx/'..v..'.raw');

end


for i,v in ipairs(aif) do

-- create raw 8bit file for importing into xml
	bake.execute( bake.cd_base , bake.cmd.sox , 'sfx/'..v..'.aif -r 22050 -c 1 -s -b 16 --endian little sfx/'..v..'.raw' )

	fp=assert(io.open("sfx/"..v..".raw","rb"))
	dat=fp:read("*a")
	fp:close()
	fp=assert(io.open("sfx/"..v..".xml","w"))
	fp:write( build_xml_8bit_str(dat,"sfx_"..v) )
	fp:close()
	bake.execute( bake.cd_base , bake.cmd.swfmill , '-v xml2swf sfx/'..v..'.xml sfx/'..v..'.swf' )
	
	os.remove('sfx/'..v..'.xml');
	os.remove('sfx/'..v..'.raw');

end

for i,v in ipairs(ogg) do

	bake.execute( bake.cd_base.."/sfx/" , bake.cmd.oggdec , v..'.ogg' )
	
-- create raw 8bit file for importing into xml
	bake.execute( bake.cd_base , bake.cmd.sox , 'sfx/'..v..'.wav -r 22050 -c 1 -s -b 16 --endian little sfx/'..v..'.raw' )

	fp=assert(io.open("sfx/"..v..".raw","rb"))
	dat=fp:read("*a")
	fp:close()
	fp=assert(io.open("sfx/"..v..".xml","w"))
	fp:write( build_xml_8bit_str(dat or "","sfx_"..v) )
	fp:close()
	bake.execute( bake.cd_base , bake.cmd.swfmill , '-v xml2swf sfx/'..v..'.xml sfx/'..v..'.swf' )
	
	os.remove('sfx/'..v..'.wav');
	os.remove('sfx/'..v..'.xml');
	os.remove('sfx/'..v..'.raw');

end


for i,v in ipairs(ogg_mp3) do

	bake.execute( bake.cd_base.."/sfx/" , bake.cmd.oggdec , v..'.ogg' )

	bake.execute( bake.cd_base , bake.cmd.wav2swf , '-v -d -b64 -o sfx/'..v..'_.swf '..'sfx/'..v..'.wav' )

	bake.execute( bake.cd_base , bake.cmd.swfmill , '-v swf2xml sfx/'..v..'_.swf sfx/'..v..'_.xml' )

	local fi=io.open('sfx/'..v..'_.xml',"r")
	local fo=io.open('sfx/'..v..'.xml',"w")

	for line in fi:lines() do

		fo:write(line,'\n')

		if string.find(line,'</DefineSound>') then

			fo:write('<Export>\n<symbols>\n<Symbol objectID="24" name="')
			fo:write('sfx_'..v)
			fo:write('"/>\n</symbols>\n</Export>\n')

		end

	end

	fi:close();
	fo:close();
	
	bake.execute( bake.cd_base , bake.cmd.swfmill , '-v xml2swf sfx/'..v..'.xml sfx/'..v..'.swf' )
	
	os.remove('sfx/'..v..'.wav');
	os.remove('sfx/'..v..'_.swf');
	os.remove('sfx/'..v..'_.xml');
	os.remove('sfx/'..v..'.xml');

end
