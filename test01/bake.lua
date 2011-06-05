
require 'bake/bake'



-- go up a dir from base cd and remember as CD

bake.cd=bake.get_cd()..'/..'
bake.set_cd(bake.get_cd()..'/..')
bake.cd=bake.get_cd()

print('cd','=',bake.cd)


bake.cmd.mtasc		=	bake.path_clean_exe( bake.cd , '/_mtasc/mtasc' )
bake.cmd.swfmill	=	bake.path_clean_exe( bake.cd , '/_swfmill/swfmill' )


print(bake.cmd.mtasc)


--bake.execute(bake.cd,bake.cmd.mtasc)


bake.execute( bake.cd..'/test01' , bake.cmd.swfmill , 'xml2swf art/master.xml swf/master.swf' )

--bake.execute( bake.cd..'/test01' , bake.cmd.mtasc , '-v -swf swf/master.swf src/master.as' )
bake.execute( bake.cd..'/test01' , bake.cmd.mtasc , '-main -v -swf swf/master.swf src/master.as' )



bake.execute( bake.cd..'/test01' , bake.cmd.swfmill , 'simple art/pung.xml swf/pung.swf' )
bake.execute( bake.cd..'/test01' , bake.cmd.mtasc , '-main -v -cp src -swf swf/pung.swf src/pung.as' )



-- ..\_swftools\wav2swf.exe -v -E -d -o art\beep1.swf art\beep1.wav
