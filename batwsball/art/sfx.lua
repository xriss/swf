
require 'bake/bake'


bake.cd_base=bake.get_cd()

bake.set_cd(bake.get_cd()..'/../..')
bake.cd=bake.get_cd()



bake.cmd.wav2swf	=	bake.path_clean_exe( bake.cd , '/_swftools/wav2swf' )
bake.cmd.swfmill	=	bake.path_clean_exe( bake.cd , '/_swfmill/swfmill' )



sfx=
{
	'beep1',
	'beep2',
	'beep3',
}

for i,v in ipairs(sfx) do

	bake.execute( bake.cd_base , bake.cmd.wav2swf , '-v -d -o sfx/'..v..'_.swf '..'sfx/'..v..'.wav' )

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

-- cleanup working files

	os.remove('sfx/'..v..'_.swf');
	os.remove('sfx/'..v..'_.xml');
	os.remove('sfx/'..v..'.xml');

end
