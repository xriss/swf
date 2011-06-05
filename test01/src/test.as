/**
 * @author kriss
 */
 
class test {

	private var scope:MovieClip;
	
	private var frame;
	private var thunk;
	private var xyz;
	
	
	function test(_scope:MovieClip) {
	
		scope = _scope;

		scope.createTextField("tf", 0, 400, 200, 800, 600);
		scope.tf.text = "Test text";

frame=0;
thunk=0;
xyz = new Array(32*2*64*2);

_scope.createEmptyMovieClip( "dna", 1 );

_scope.dna._x=256;
_scope.dna._y=128;




with ( _scope.dna )
{
//	clear();

	b=2*64*2*frame;

// do the math first time round only, store in array and then just reuse
// so in theory it should run faster after the first pass
// but its not really the math thats slowwing it down so it dont make much
// diference :)

	if(!thunk)
	{
		j=0;
		for(ra=0;ra<=Math.PI;ra+=Math.PI)
		{
			for(i=0;i<64;i++)
			{
				r=ra+Math.PI*(i+(frame))/32;
				x=-256+4+i*8;
				y=Math.sin(r)*128;
				z=1-( ((Math.cos(r)*128)+128)/1536 ) ;
				xyz[b+j+i*2+0]=x*z;
				xyz[b+j+i*2+1]=y*z;
			}
			j=64*2;
		}
	}

	lineStyle( 16, 0x8080ff, 50 );
	moveTo(xyz[b+0],xyz[b+1]); for(i=2;i<128;i+=2) lineTo(xyz[b+i+0],xyz[b+i+1]);
	moveTo(xyz[b+128+0],xyz[b+128+1]); for(i=128+2;i<256;i+=2) lineTo(xyz[b+i+0],xyz[b+i+1]);
	
	lineStyle( 8, 0x8080ff, 50 );
	for(i=4;i<128;i+=8)
	{
		moveTo(xyz[b+i+0],xyz[b+i+1]);
		lineTo(xyz[b+128+i+0],xyz[b+128+i+1]);
	}
		
	lineStyle( 8, 0x8080ff, 80 );
	moveTo(xyz[b+0],xyz[b+1]); for(i=2;i<128;i+=2) lineTo(xyz[b+i+0],xyz[b+i+1]);
	moveTo(xyz[b+128+0],xyz[b+128+1]); for(i=128+2;i<256;i+=2) lineTo(xyz[b+i+0],xyz[b+i+1]);
	
	lineStyle( 4, 0x8080ff, 80 );
	for(i=4;i<128;i+=8)
	{
		moveTo(xyz[b+i+0],xyz[b+i+1]);
		lineTo(xyz[b+128+i+0],xyz[b+128+i+1]);
	}
		
	
}

frame+=1;

if(frame==32)
{
	frame=0;
	thunk=1;
}



	}


	// --- Main Entry Point
	static function main() {		
		var test:test = new test(_root);

	}

}



