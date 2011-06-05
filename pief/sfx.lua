
require 'bake/bake'

local mime = require("mime")


bake.cd_base=bake.get_cd()

bake.set_cd(bake.get_cd()..'/..')
bake.cd=bake.get_cd()



bake.cmd.wav2swf	=	bake.path_clean_exe( bake.cd , '/_swftools/wav2swf' )
bake.cmd.swfmill	=	bake.path_clean_exe( bake.cd , '/_swfmill/swfmill' )
bake.cmd.sox		=	bake.path_clean_exe( bake.cd , '/_sox/sox' )
bake.cmd.oggdec		=	bake.path_clean_exe( bake.cd , '/_sox/oggdec' )


sfx=
{
	'rightthere',
	'ohyea',
	'win',
	'smooch',
	'back',
}


mp3=
{
}


function build_xml_8bit_str( dat , nam )

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
	  
      <DefineSound objectID="24" format="]].."0"..[[" rate="]].."1"..[[" is16bit="]].."0"..[[" stereo="]].."0"..[[" samples="]]..string.len(dat)..[[">
        <data>
<data>]]..((mime.b64(dat)))..[[</data>
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




for i,v in ipairs(sfx) do
local dat
local fp

	bake.execute( bake.cd_base.."/art/sfx/" , bake.cmd.oggdec , v..'.ogg' )

	-- create raw 8bit file for importing into xml
--	bake.execute( bake.cd_base , bake.cmd.sox , 'art/sfx/'..v..'.wav -r 5512  -c 1 -u -b art/sfx/'..v..'.raw' )
	bake.execute( bake.cd_base , bake.cmd.sox , 'art/sfx/'..v..'.wav -r 11025 -c 1 -u -b art/sfx/'..v..'.raw' )

	fp=assert(io.open("art/sfx/"..v..".raw","rb"))
	dat=fp:read("*a")
	fp:close()
	fp=assert(io.open("art/sfx/"..v..".xml","w"))
	fp:write( build_xml_8bit_str(dat,"sfx_"..v) )
	fp:close()
	bake.execute( bake.cd_base , bake.cmd.swfmill , '-v xml2swf art/sfx/'..v..'.xml art/sfx/'..v..'.swf' )
	
	os.remove('art/sfx/'..v..'.wav');
	os.remove('art/sfx/'..v..'.xml');
	os.remove('art/sfx/'..v..'.raw');

end



for i,v in ipairs(mp3) do

	bake.execute( bake.cd_base.."art/sfx/" , bake.cmd.oggdec , v..'.ogg' )
	
	bake.execute( bake.cd_base , bake.cmd.wav2swf , '-v -d art/sfx/'..v..'.wav'..' -oart/sfx/'..v..'.orig.swf' )

	bake.execute( bake.cd_base , bake.cmd.swfmill , '-v swf2xml art/sfx/'..v..'.orig.swf art/sfx/'..v..'.orig.xml' )

	local fi=io.open('art/sfx/'..v..'.orig.xml',"r")
	local fo=io.open('art/sfx/'..v..'.xml',"w")

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
	
	bake.execute( bake.cd_base , bake.cmd.swfmill , '-v xml2swf art/sfx/'..v..'.xml art/sfx/'..v..'.swf' )

-- cleanup working files

	os.remove('art/sfx/'..v..'.orig.swf');
	os.remove('art/sfx/'..v..'.orig.xml');
	os.remove('art/sfx/'..v..'.xml');
	os.remove('art/sfx/'..v..'.wav');

end



