/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) Kriss Daniels 2006 http://www.XIXs.com
//
/*+-----------------------------------------------------------------------------------------------------------------+*/

#include "src/opts.as"

class BBowBack
{
	var mc:MovieClip;
	
	var mcb;
	
	var mc1;
	var mc2;
	var mc3;
	var mc4;

	var up;

// top left view into real space
	var x,y;
	var w,h;	// size of viewed area
	var scale;	// scale to show view as

// array of collums data

	var cols;
	var col_min;
	var col_max;
	var cw;
	
	var maxy;
	var miny;
	
	var bitems;
	var blinks;
	var bprops;
	
	var endlink;
	
	var shots;
	var propshots;

	function BBowBack(_up)
	{
	var i;
	
		shots=0;
		propshots=0;
	
		up=_up;
		mc=gfx.create_clip(up.mc,null);

		mc1=gfx.create_clip(mc,null);
		mc2=gfx.create_clip(mc,null);
		mc3=gfx.create_clip(mc,null);
		mc4=gfx.create_clip(mc,null);

		bitems=new Array();
		blinks=new Array();
		bprops=new Array();
		
		cols=new Array();
		col_min=0;
		col_max=0;
		cw=40;
		
		maxy=0;
		miny=0;
		
//		var date=new Date();
//		rnd_seed(date.getTime());
		rnd_seed(up.rnd());
		
		for(i=-256;i<=256;i++)		// +- 8000
		{
			GetCol(i);
		}
		
// add props into mc2

		var x;
		var p;
/*		
		x=-256*32;
		while(x<256*32)
		{
			x+=128+(rnd()%512);
			
			p=gfx.add_clip(mc2,"props",null);
			p.gotoAndStop(1+(rnd()%17));
			p._x=x;
			p._y=GetY(x)+4;
			p._xscale=100+(rnd()%100);
			p._yscale=100+(rnd()%100);
		}
*/
/*
		x=0;
		p=gfx.add_clip(mc2,"towers",null);
		p.gotoAndStop(1+(rnd()%1));
		p._x=x;
		p._y=GetY(x)+16;
*/
		for(p=0;p<=16;p++)
		{
			bprops[p]=new BProp(this);
		}
		
		bprops[8].setup(0,"tower",3);
		
		for(p=7;p>=0;p--)
		{
			x=bprops[p+1].x;
			x-=512+(rnd()%512);
			if( (p==5) )
			{
				bprops[p].setup(x,"tower",2);
			}
			else
			if( (p==2) )
			{
				bprops[p].setup(x,"tower",1);
			}
			else
			{
				bprops[p].setup(x,"apple",0);
			}
		}
		
		for(p=9;p<=16;p++)
		{
			x=bprops[p-1].x;
			x+=512+(rnd()%512);
			if( (p==11) )
			{
				bprops[p].setup(x,"tower",4);
			}
			else
			if( (p==14) )
			{
				bprops[p].setup(x,"tower",5);
			}
			else
			{
				bprops[p].setup(x,"apple",0);
			}
		}
		
		var pos=[1,2,3,4,5,6,8,10,12,14,16,24];
		var bp;
		var bi;
		
		for(p=0;p<=16;p++)
		{
			bp=bprops[p];
			
			if(bp.state=='apple')
			{
				bi=rnd()%pos.length;
				bp.order=pos[bi];
				pos.splice(bi,1);
				
				bp.score=50*bp.order;
				bp.update();
			}
		}
		
		
			

//		mcb=gfx.create_clip(mc,null);
		mcb=gfx.add_clip(mc,"boom");
		mcb._visible=false;

	}

	
	function GetCol(idx)	// creates col if it doesnt exist, then return it (and the ones it depends on first)
	{
	var i;
	
		if(idx>0) // relative to x-1
		{
			for( i=col_max ; i<=idx ; i++ )
			{
				if(!(cols[i]))
				{
					cols[i] = new BBowBackCol(this,i);
				}				
				col_max=i;
			}
		}
		else
		if(idx<0) // relative to x+1
		{
			for( i=col_min ; i>=idx ; i-- )
			{
				if(!(cols[i]))
				{
					cols[i] = new BBowBackCol(this,i);
				}
				col_min=i;
			}
		}
		
		return cols[idx];
	}
	
	function GetY(x)	// find y collision value given x
	{
	var ca,cb;
	var xa,xb;
	
		xa=Math.floor(x/cw)
		xb=xa+1;
	
		ca=GetCol(xa);
		cb=GetCol(xb);

// interp

		return ca.y + ( (ca.y-cb.y) * ((x-ca.x)/(ca.x-cb.x)) ) ;
	}

	function dent(x,s)	// make a dent
	{
	var fx,tx,ix;
	var c,d,dd;
	
		fx=Math.floor((x-(s+cw))/cw)
		tx=Math.floor((x+(s+cw))/cw)
		
		for(ix=fx;ix<=tx;ix++)
		{
			c=GetCol(ix);
			
			d=Math.abs(c.x-x);
			
			if(d<s)
			{
				dd=(d)/s;
				dd=dd*dd;
				
				c.y+=((1-dd)*s*2);
			}
		}
	}
	
	function boom(x,s)	// make a boom + dent
	{
		dent(x,s);
	}
	
	var rnd_num:Number=0;
	function rnd_seed(n:Number) { rnd_num=n&65535; }
	function rnd() // returns a number between 0 and 65535
	{
		rnd_num=(((rnd_num+1)*75)-1)%65537; // all hail the mighty zx spectrum pseudo random number sequence
		return rnd_num;
	}


	function setup()
	{
	}
	
	function clean()
	{
	}

	function update()
	{
	var i;
	
		for(i=0;i<=16;i++)
		{
			bprops[i].update();
		}

		for(i=0;i<bitems.length;i++)
		{
			bitems[i].update();
		}

		for(i=1;i<blinks.length;i++)
		{
			blinks[i].update(1);
		}
		
		if(up.focus.id=="arrow") // remember for later when we change the focus
		{
			blinks[0].focus=up.focus;
		}
		
		if( (up.focus.id=="slowsnap") || (up.focus.id=="arrow") )
		{
			blinks[0].x=-90;
			blinks[0].y=0;
			
			blinks[0].focus.mc.localToGlobal(blinks[0]);
			mc.globalToLocal(blinks[0]);
			
			blinks[0].__x=blinks[0].x;
			blinks[0].__y=blinks[0].y;
		}
		
		for(i=1;i<blinks.length;i++)
		{
			blinks[i].update(2);
		}
		endlink=blinks[blinks.length-1];
		
		mcb._x=endlink.x;
		mcb._y=endlink.y;

		
		mc._x=-x*scale;
		mc._y=-y*scale;
		mc._xscale=scale*100;
		mc._yscale=scale*100;
		

		mc1.clear();
		
		mc1.lineStyle(0,0,0);
		
		mc1.moveTo(-16384,-16384);
        mc1.beginGradientFill( "linear",
			[	0x0080ff,	0x0000ff,	0x000080	],
			[	100,		100,			100			],
			[	0,	 		0x80,		0xff		],
			{	a:0,	b:-8192,	c:0,
				d:8192,	e:0,		f:0,
				g:0,	h:0,		i:1		}	);
		mc1.lineTo(-16384,16384);
		mc1.lineTo(16384,16384);
		mc1.lineTo(16384,-16384);
		mc1.lineTo(-16384,-16384);
		mc1.endFill();
				
		
		mc3.clear();
		mc3.lineStyle(16,0x000000,50);
		
		mc3.moveTo(cols[col_min].x,cols[col_min].y);
		
//		mc.style={	fill:0xff804010,	out:0x80000000,	text:0xffffffff		};
//		mc.beginFill(mc.style.fill&0xffffff,((mc.style.fill>>24)&0xff)*100/255);

        mc3.beginGradientFill( "linear",
			[	0x804010,	0x201004	],
			[	100,		100			],
			[	0,	 		0xFF		],
			{	a:0,	b:4096,	c:0,
				d:4096,	e:0,	f:0,
				g:0,	h:2048,	i:1		}	);

		for(i=col_min;i<=col_max;i++)		// +- 8000
		{
			mc3.lineTo(cols[i].x,cols[i].y);
		}
		
		mc3.lineTo(cols[col_max].x,maxy+4096);
		mc3.lineTo(cols[col_min].x,maxy+4096);
		mc3.lineTo(cols[col_min].x,cols[col_min].y);
		
		mc3.endFill();
		
		mc4.clear();
		
		var l=null;
		var	lp=null;
		for(i=0;i<blinks.length;i++)
		{
			l=blinks[i];
			if(lp==null)
			{
				mc4.lineStyle(4,0x000000,100);
				mc4.moveTo(l.x,l.y);
			}
			else
			{
				mc4.lineTo(l.x,l.y);
			}
			lp=l;
		}
		
	}
	
}
