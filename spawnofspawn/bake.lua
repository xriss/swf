#!../../bin/XPP

require 'bake/bake'
require 'pp'



-- where we are building from

bake.cd_base		=	bake.get_cd()

-- where we are building to

bake.cd_out		=	'out'

xtra.makedir('out')
xtra.makedir('out/src')



-- go up a dir from base cd and remember as main CD for building commands

bake.set_cd(bake.get_cd()..'/..')
bake.cd=bake.get_cd()

print('cd','=',bake.cd)


bake.cmd.xpp		=	bake.path_clean_exe( bake.cd , '/bin/xpp' )
bake.cmd.mtasc		=	bake.path_clean_exe( bake.cd , '/_mtasc/mtasc' )
bake.cmd.swfmill	=	bake.path_clean_exe( bake.cd , '/_swfmill/swfmill' )


bake.files_as=
{
	'gfx',
	'dbg',
	'Gizmo',
	'GizmoButt',
	'GizmoKnob',
	'GizmoLine',
	'GizmoList',
	'GizmoMaster',
	'GizmoText',
	'Login',
	'fbsig',
	'Scalar',
	'Poker',
	'Replay',
	'Clown',
	'ScrollOn',
	'xmlcache',
	'MainStatic',
	'Swish',
	'Mochiad',

	'Scalar',
	'Poker',
	'Loading',
	'WTF',
	'SpawnOfSpawn',
	'EsPlay',
	'EsShip',
	'EsShot',
	'EsBreeder',
	'EsPinger',
	'EsBack',
	'EsBackCol',
	'WetPlayIcon',
	'WetPlayGFX',
	'WetPlayMP3',
}

bake.files_xml=
{
	'SpawnOfSpawn',
}

bake.files_swf=
{
	'SpawnOfSpawn',
}

bake.set_cd(bake.cd_base)
xtra.copyfile( 'art/index.html' , 'out/index.html' )
xtra.copyfile( 'art/swfobject.js' , 'out/swfobject.js' )

xtra.copyfile( '../import/out/WTF_import.swf' , 'out/WTF_import.swf' )


for i,v in ipairs(bake.files_as) do

	pp.loadsave( 'src/'..v..'.as' , bake.cd_out..'/src/'..v..'.as' )

end

io.flush()

for i,v in ipairs( bake.files_xml ) do

	bake.execute( bake.cd_base , bake.cmd.swfmill , '-v simple art/'..v..'.xml '..bake.cd_out..'/'..v..'.swf' )

end

for i,v in ipairs( bake.files_swf ) do

	bake.execute( bake.cd_base , bake.cmd.mtasc , '-main -version 8 -v -cp '..bake.cd_out..'/src -cp '..bake.cd..'/class -swf '..bake.cd_out..'/'..v..'.swf '..bake.cd_out..'/src/'..v..'.as' )

end
