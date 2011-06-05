
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
	'replay',
	'Trans',
	'recoil',
	'recoil_game',
	'recoil_title',
	'wetDNA',
	'Scores',
}

bake.files_xml=
{
--	'puck',
	'recoil',
}

bake.files_swf=
{
	'recoil',
}

bake.set_cd(bake.cd_base)
xtra.copyfile( 'art/index.html' , 'out/index.html' )

--xtra.copyfile( '../_Alcon/Alcon.swf' , 'out/Alcon.swf' )

--[[
do

local ga,gb
local t


	ga=grd.create('GRD_FMT_U8_INDEXED','art/parts.png')

	gb=grd.create('GRD_FMT_U8_INDEXED',32,32,1)
	gb:palette(0,256, ga:palette(0,256) ) -- copy pal to new grd

	for iy=0,3 do

		for ix=0,7 do

			t=ga:pixels(8+ix*40,8+iy*40,32,32)
			gb:pixels(0,0,32,32,t)
			gb:save(string.format("out/art/part%03d.png",(iy*8+ix)))

		end
	end

end
]]


for i,v in ipairs(bake.files_as) do

	pp.loadsave( 'src/'..v..'.as' , bake.cd_out..'/src/'..v..'.as' )
--	bake.execute( bake.cd_base , bake.cmd.xpp , bake.opt.xpp_pp .. 'src/'..v..'.as '..bake.cd_out..'/src/'..v..'.as' )

end


for i,v in ipairs( bake.files_xml ) do

	bake.execute( bake.cd_base , bake.cmd.swfmill , '-v simple art/'..v..'.xml '..bake.cd_out..'/'..v..'.swf' )

end

for i,v in ipairs( bake.files_swf ) do

	bake.execute( bake.cd_base , bake.cmd.mtasc , '-main -pack '..bake.cd..'/class/net/hiddenresource/util/debug -trace net.hiddenresource.util.debug.Debug.trace -v -cp '..bake.cd_out..'/src -cp '..bake.cd..'/class -swf '..bake.cd_out..'/'..v..'.swf '..bake.cd_out..'/src/'..v..'.as' )

end




-- ..\_swftools\wav2swf.exe -v -E -d -o art\beep1.swf art\beep1.wav
