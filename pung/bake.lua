
require 'bake/bake'
require 'pp'



-- where we are building from

bake.cd_base		=	bake.get_cd()

-- where we are building to

bake.cd_out		=	'out'

xtra.makedir('out')
xtra.makedir('out/src')
xtra.makedir('out/art')



-- go up a dir from base cd and remember as main CD for building commands

bake.set_cd(bake.get_cd()..'/..')
bake.cd=bake.get_cd()

print('cd','=',bake.cd)


bake.cmd.xpp		=	bake.path_clean_exe( bake.cd , '/bin/xpp' )
bake.cmd.mtasc		=	bake.path_clean_exe( bake.cd , '/_mtasc/mtasc' )
bake.cmd.swfmill	=	bake.path_clean_exe( bake.cd , '/_swfmill/swfmill' )

bake.opt.xpp_pp		=	bake.path_clean( bake.cd , '/bin/lua/pp.lua ' )



bake.files_as=
{
	'gfx',
	'Clown',
	'Replay',
	'pung',
	'pung_scores',
	'wetDNA',
	'pnFlashGames'
}

bake.files_xml=
{
	'pung',
}

bake.files_swf=
{
	'pung',
}

bake.set_cd(bake.cd_base)
xtra.copyfile( 'art/index.html' , 'out/index.html' )

xtra.copyfile( '../_xray/ConnectorOnly.swf' , 'out/ConnectorOnly.swf' )



for i,v in ipairs(bake.files_as) do

	pp.loadsave( 'src/'..v..'.as' , bake.cd_out..'/src/'..v..'.as' )
--	bake.execute( bake.cd_base , bake.cmd.xpp , bake.opt.xpp_pp .. 'src/'..v..'.as '..bake.cd_out..'/src/'..v..'.as' )

end


for i,v in ipairs( bake.files_xml ) do

	bake.execute( bake.cd_base , bake.cmd.swfmill , '-v simple art/'..v..'.xml '..bake.cd_out..'/'..v..'.swf' )

end

for i,v in ipairs( bake.files_swf ) do

	bake.execute( bake.cd_base , bake.cmd.mtasc , '-main -trace com.blitzagency.xray.util.XrayLoader.trace -v -cp '..bake.cd_out..'/src -cp '..bake.cd..'/_xray/classes -swf '..bake.cd_out..'/'..v..'.swf '..bake.cd_out..'/src/'..v..'.as' )

end




-- ..\_swftools\wav2swf.exe -v -E -d -o art\beep1.swf art\beep1.wav
