/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) Kriss Daniels 2006 http://www.XIXs.com
//
/*+-----------------------------------------------------------------------------------------------------------------+*/


class wetDNA 
{
	var mc;

	var thunked;
	var frame;
	var xyz;
	var color=0x8080ff;


	function wetDNA(master,name,level)
	{
		mc=master.createEmptyMovieClip(name,level);
		mc.t=this;

		thunked=false;
		frame=0;
		xyz=new Array(32*2*64*2);


		mc.onEnterFrame=function()
		{
			if(!this._visible) { return; }
			
			var t=this;

			t.clear();

			t.t.thunk();
			t.t.draw();
			t.t.update();
		}
	}


	function thunk()
	{
		if(!thunked)
		{
			var i,j;
			var b,ra;
			var r,x,y,z;

			b=2*64*2*frame;

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

			if(frame==31)
			{
				thunked=true;
			}
		}
	}

	function draw()
	{
		var i;
		var b;

		b=2*64*2*frame;

		mc.lineStyle( 16, color, 50 );
		mc.moveTo(xyz[b+0],xyz[b+1]); for(i=2;i<128;i+=2) mc.lineTo(xyz[b+i+0],xyz[b+i+1]);
		mc.moveTo(xyz[b+128+0],xyz[b+128+1]); for(i=128+2;i<256;i+=2) mc.lineTo(xyz[b+i+0],xyz[b+i+1]);
		
		mc.lineStyle( 8, color, 50 );
		for(i=4;i<128;i+=8)
		{
			mc.moveTo(xyz[b+i+0],xyz[b+i+1]);
			mc.lineTo(xyz[b+128+i+0],xyz[b+128+i+1]);
		}
			
		mc.lineStyle( 8, color, 80 );
		mc.moveTo(xyz[b+0],xyz[b+1]); for(i=2;i<128;i+=2) mc.lineTo(xyz[b+i+0],xyz[b+i+1]);
		mc.moveTo(xyz[b+128+0],xyz[b+128+1]); for(i=128+2;i<256;i+=2) mc.lineTo(xyz[b+i+0],xyz[b+i+1]);
		
		mc.lineStyle( 4, color, 80 );
		for(i=4;i<128;i+=8)
		{
			mc.moveTo(xyz[b+i+0],xyz[b+i+1]);
			mc.lineTo(xyz[b+128+i+0],xyz[b+128+i+1]);
		}
	}

	function update()
	{
		frame+=1;

		if(frame==32)
		{
			frame=0;
		}
	}

	function remove()
	{
		mc.removeMovieClip();
	}

}


