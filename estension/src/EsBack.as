/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) Kriss Daniels 2006 http://www.XIXs.com
//
/*+-----------------------------------------------------------------------------------------------------------------+*/

#include "src/opts.as"


class EsBack
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
	var col_max_i;
	var cw;
	
	var maxy;
	var miny;
	
	var bitems;
	var blinks;
	var bprops;
	
	var endlink;
	
	var shots;
	
	var frame;
	
	var min_view_x;
	var max_view_x;
	var min_view_y;
	var max_view_y;

	function EsBack(_up)
	{
		up=_up;	
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
	var i;
	
		frame=0;
	
		mc=gfx.create_clip(up.mc,null);

		cols=new Array();
		col_min=0;
		col_max=0;
		cw=40;
		
		maxy=0;
		miny=0;
		
		rnd_seed(up.rnd());
		
		for(i=0;i<=257;i++)		// +- 8000
		{
			GetCol(i);
		}
		for(i=0;i>=-257;i--)		// +- 8000
		{
			GetCol(i);
		}
		
		
		min_view_x=-10240;
		max_view_x= 10240;
		min_view_y=-4096-2048;
		max_view_y= 2048;
	}
	
	function clean()
	{
	}

	function update()
	{
	var i;
	
//think water flow

	var c1,c2,c3;
	var c1y,c2y,c3y;
	var c1w,c3w;
	var s;
	
	if((frame&1)==0)
	if((frame&2)==0)
	{
		for(i=col_min+1;i<=col_max-1;i+=2)
		{
#check_water=function()
			c2=cols[i];
			
			if(c2.wet>0)
			{
				c1=cols[i-1];
				c3=cols[i+1];
				if(c1&&c3)
				{
					
					c1y=c1.y-c1.wet;
					c2y=c2.y-c2.wet;
					c3y=c3.y-c3.wet;
					
					c1w=c1y-c2y;
					c3w=c3y-c2y;
					
					if(c1w<0) { c1w=0; } else { if(c1w<1) c1w=1; if(c1w>16) c1w=16; }
					if(c3w<0) { c3w=0; } else { if(c3w<1) c3w=1; if(c3w>16) c3w=16; }
					
					if((c1w>0)&&(c3w>0)) // want to go two ways, pick one
					{
						if(c2.wv<0) { c3w=0; }
						else
						if(c2.wv>0) { c1w=0; }
					}
					
					if((c1w+c3w)>c2.wet) // scale it down
					{
						s=c2.wet/(c1w+c3w);
						c1w*=s;
						c3w*=s;
					}
					
					if(c1w)	{ c1.wet+=c1w; c1.wv=-1; c2.wv=-1; }
					if(c3w)	{ c3.wet+=c3w; c3.wv= 1; c2.wv= 1; }
					c2.wet-=c1w+c3w;
				}
			}
			else
			{
				c2.wet=0;
			}
#end
#check_water()
		}
		
		col_max_i=i;
	}
	else
	{
		for(i=col_max_i-3;i>=col_min+1;i-=2)
		{
#check_water()
		}
	}
	frame++;
	

	}
	
	
	function draw_texture(_mc)
	{
	var st=1;	
	var i;
	var x,y;
	var aa,ab;
	var px,py;
	
		aa=512;
		ab=64;
		
//		_mc.lineStyle(16,0x000070 - (px+py) ,100);
		_mc.lineStyle();
		
		for(y=min_view_y,py=0;y<max_view_y;y+=aa,py++)
		{
			for(x=min_view_x,px=0;x<max_view_x;x+=aa,px++)
			{
				if((px+py)&1)
				{
		
					_mc.moveTo(x+ab,y+ab);			_mc.beginFill(0x000070 - (px+py),100);
					_mc.lineTo(x+aa-ab,y+ab);
					_mc.lineTo(x+aa-ab,y+aa-ab);
					_mc.lineTo(x+ab,y+aa-ab);
					_mc.lineTo(x+ab,y+ab);			_mc.endFill();
				}
			}
		}
	}
	
	function draw_ground(_mc)
	{
	var st=1;	
	var i;
	
		_mc.lineStyle(8,0x000000,100);
		
		_mc.moveTo(cols[col_min].x,cols[col_min].y);
		_mc.beginFill(0x000040,100);
		
		for(i=col_min;i<=col_max;i+=st)
		{
			_mc.lineTo(cols[i].x,cols[i].y);
		}
		
		_mc.lineTo(cols[col_max].x,maxy+4096);
		_mc.lineTo(cols[col_min].x,maxy+4096);
		_mc.lineTo(cols[col_min].x,cols[col_min].y);
		
		_mc.endFill();
	}
	
	function draw_water(_mc)
	{
	var st=1;
			
	var draw_wet=false;
	var start_wet;
	var i;
	var ii;
	
		for(i=col_min;i<=col_max;i+=st)
		{
			if(draw_wet)
			{
				if(cols[i].wet<1) // final go back and finish fill
				{
					for(ii=i;ii>=start_wet;ii-=st)
					{
						_mc.lineTo(cols[ii].x,cols[ii].y);
					}
					_mc.endFill();
					draw_wet=false;
				}
				else
				{
					_mc.lineTo(cols[i].x,cols[i].y-cols[i].wet);
				}
			}
			else
			{
				if(cols[i].wet>=1)
				{
					start_wet=i-st;
					_mc.lineStyle(2,0x0000ff,100);	
					_mc.beginFill(0x0000ff,50);
					_mc.moveTo(cols[start_wet].x,cols[start_wet].y);
					_mc.lineTo(cols[i].x,cols[i].y-cols[i].wet);
					draw_wet=true;
				}
			}
		}		
	}
	
	
	function GetCol(idx)	// creates col if it doesnt exist, then return it
	{
	var i;
	
		if(idx>0) // relative to x-1
		{
			for( i=col_max ; i<=idx ; i++ )
			{
				if(!(cols[i]))
				{
					cols[i] = new EsBackCol(this,i);
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
					cols[i] = new EsBackCol(this,i);
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

	function GetYcol(x)	// find y collision value given x, return all extra junk
	{
	var ret=new Object();
	var ca,cb;
	var xa,xb;
	
		xa=Math.floor(x/cw)
		xb=xa+1;
	
		ca=GetCol(xa);
		cb=GetCol(xb);

		ret.ca=ca;
		ret.cb=cb;
		
// interp
		ret.frac=((x-ca.x)/(ca.x-cb.x));
		ret.y=ca.y + ( (ca.y-cb.y) * ret.frac );
		
		ret.wet=ca.wet + ( (ca.wet-cb.wet) * ret.frac );
		
		return  ret;
	}
}
