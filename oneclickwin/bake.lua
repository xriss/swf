#!../../bin/XPP

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


bake.files_as=
{
	'Clown',
	'gfx',
	'dbg',
	'Swish',
	'Gizmo',
	'GizmoButt',
	'GizmoKnob',
	'GizmoLine',
	'GizmoList',
	'GizmoMaster',
	'GizmoText',
	'Loading',
	'Login',
	'fbsig',
	'Scalar',
	'Poker',
	'Replay',
	'Clown',
	'ScrollOn',
	'OverPixls',
	'Swish',
	'WTF',
	'BetaComms',
	'BetaSignals',
	'xmlcache',
	'bmcache',
	'bmcache_item',
	'MainStatic',
	'NonobaAPI',
	'MochiAd',
	'WetPlayIcon',
	'WetPlayGFX',
	'WetPlayMP3',
	
	'PlayCode',
	'PlayAbout',
	'PlayHigh',
	'PlayPaste',
	
	'Talky',
	'TalkyBub',
	
	'OneClickWin',
	'ocwMenu',
	'ocwPlay',
	'ocwSelect',

	'tdmap',
	
	'ocw_level00',
	'ocw_level01',
	'ocw_level02',
	'ocw_level03',
	'ocw_level04',
	'ocw_level05',
	'ocw_level06',
	'ocw_level07',
	'ocw_level08',
	'ocw_level09',
	'ocw_level10',
	'ocw_level11',
	'ocw_level12',
	'ocw_level13',
	'ocw_level14',
	'ocw_level15',
	'ocw_level16',
	'ocw_level17',
	'ocw_level18',
	'ocw_level19',
	'ocw_level20',
	'ocw_level21',
	'ocw_level22',
	'ocw_level23',
	'ocw_level24',
	
}

bake.files_xml=
{
	'OneClickWin',
}

bake.files_swf=
{
	'OneClickWin',
}

bake.set_cd(bake.cd_base)
xtra.copyfile( 'art/index.html' , 'out/index.html' )
xtra.copyfile( 'art/swfobject.js' , 'out/swfobject.js' )

--xtra.copyfile( '../import/out/WTF_import.swf' , 'out/WTF_import.swf' )


for i,v in ipairs(bake.files_as) do

	pp.loadsave( 'src/'..v..'.as' , bake.cd_out..'/src/'..v..'.as' )

end

io.flush()

if arg[1]=="noart" then
print('****')
print('**SKIPING**SWFMILL**BUILD**STEP**')
print('****')
else
for i,v in ipairs( bake.files_xml ) do

	pp.loadsave( 'art/'..v..'.xml' , bake.cd_out..'/art/'..v..'.xml' )
	
	bake.execute( bake.cd_base , bake.cmd.swfmill , '-v simple '..bake.cd_out..'/art/'..v..'.xml '..bake.cd_out..'/'..v..'.swf' )
--	bake.execute( bake.cd_base , bake.cmd.swfmill , '-v swf2xml '..bake.cd_out..'/'..v..'.swf '..bake.cd_out..'/'..v..'.xml' )

end
end

for i,v in ipairs( bake.files_swf ) do

	bake.execute( bake.cd_base , bake.cmd.mtasc , '-main -version 8 -v -cp '..bake.cd_out..'/src -cp '..bake.cd..'/class -swf '..bake.cd_out..'/'..v..'.swf '..bake.cd_out..'/src/'..v..'.as' )

-- copy the swf files into my serving area for testing

	xtra.copyfile( 'out/'..v..'.swf' , '../../www/wetgenes/swf/'..v..'0.swf' )

end


