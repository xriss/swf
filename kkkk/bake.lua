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


bake.set_cd(bake.cd_base)

bake.files_as={}
for i,v in ipairs(xtra.dir("src/*.as")) do -- do all .as files in the src dir

	v=string.gsub( v , "%.as" , "") -- remove .as , it will only be at the end but this kills it anywhere
	table.insert(bake.files_as,v)
	
end

bake.files_as=
{
	'kkkk',
}

bake.files_xml=
{
	'kkkk',
}

bake.files_swf=
{
	'kkkk',
}

bake.set_cd(bake.cd_base)
xtra.copyfile( 'art/index.html' , 'out/index.html' )
xtra.copyfile( 'art/swfobject.js' , 'out/swfobject.js' )


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

end
end

for i,v in ipairs( bake.files_swf ) do

	bake.execute( bake.cd_base , bake.cmd.mtasc , '-main -version 8 -v -cp '..bake.cd_out..'/src -cp '..bake.cd..'/class -swf '..bake.cd_out..'/'..v..'.swf '..bake.cd_out..'/src/'..v..'.as' )

-- copy the swf files into my serving area for testing
	xtra.copyfile( 'out/'..v..'.swf' , '../../www/wetgenes/swf/'..v..'.swf' )
	
end
