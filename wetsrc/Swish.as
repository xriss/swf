/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) http://www.WetGenes.com/ 2009
//
// This file made available under the terms of The MIT License : http://www.opensource.org/licenses/mit-license.php
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//
/*+-----------------------------------------------------------------------------------------------------------------+*/

#GFX=GFX or "gfx"
#CLASSNAME = CLASSNAME or "Swish"

class #(CLASSNAME)
{

	var smc; // the snapshoted mc, this is the old screen and is above the new real content
	
	var style; // the style of swish
	
	var smul; // multiplyer fade speed, 0.9 by default
	
	var bms;
	var mcs;
	
	var frame;
	
	var w,h;
	var cw,ch;
	var sw,sh;
	
	var _xmouse;
	var _ymouse;
	
	var setup_done;

	function delegate(f,d)	{	return com.dynamicflash.utils.Delegate.create(this,f,d);	}

// ser
	var rnd_num=0;
	function rnd_seed(n) { rnd_num=n&0xffff; }
	function rnd() // returns a number between 0 and 65535
	{
		rnd_num=(((rnd_num+1)*75)-1)%65537; // all hail the mighty zx spectrum pseudo random number sequence
		return rnd_num;
	}
	
		
	function #(CLASSNAME)(opts)
	{
		if(opts)
		{
			prepare(opts);
		}
	}

	function prepare(opts) // prepare for a swish, take a snapshot and wait
	{
	var bm;
	var x,y;
	
		rnd_seed(getTimer()&0xffff);
	
		bms=[];
		mcs=[];
		
		w=800;
		h=600;
		
		cw=8;
		ch=6;
		style="fade";
		
		_xmouse=0;
		_ymouse=0;

		if( opts.mc )
		{
			_xmouse=opts.mc._xmouse;
			_ymouse=opts.mc._ymouse;
		}
		
		if( opts.style )	{ style=opts.style; }
		if( opts.w )		{ w=opts.w; }
		if( opts.h )		{ h=opts.h; }
		if( opts.cw )		{ w=opts.cw; }
		if( opts.ch )		{ h=opts.ch; }
		
		sw=w/cw;
		sh=h/ch;
		
		var m=new flash.geom.Matrix();
		var ssw=1;
		var ssh=1;
		if( opts.sw )		{ ssw=opts.sw; }
		if( opts.sh )		{ ssh=opts.sh; }
		if( opts.s	)		{ ssw=opts.s; ssh=opts.s; }
		m.scale(ssw,ssh);
		
		if( opts.mc )
		{
			switch(style)
			{
				case "wait":
				
					bms[0]=new flash.display.BitmapData(w,h,false,0x00000000);
					bms[0].draw(opts.mc,m);
					
				break;
				
				case "fade":
				
					smul=0.8;
		
					bms[0]=new flash.display.BitmapData(w,h,false,0x00000000);
					bms[0].draw(opts.mc,m);
					
				break;
				
				case "slide_left":
				case "slide_down":
				
					bms[0]=new flash.display.BitmapData(w,h,false,0x00000000);
					bms[0].draw(opts.mc,m);
					
				break;
				
				case "sqr_plode":
				case "sqr_shrink":
				case "sqr_rollup":
		
					smul=0.95;
		
					bm=new flash.display.BitmapData(w,h,false,0x00000000);
					bm.draw(opts.mc,m);
					
					for(y=0;y<ch;y++)
					{
						for(x=0;x<cw;x++)
						{
						
							bms[y*cw+x]=new flash.display.BitmapData(sw,sh,false,0x00000000);
							bms[y*cw+x].copyPixels(bm , new flash.geom.Rectangle(x*sw,y*sh,sw,sh) , new flash.geom.Point(0,0) );
							
						}
					}
		
				break;
			}
		}
		
		if( opts.smul )		{ smul=opts.smul; }
		
		
		setup_done=false;

//dbg.print("prepare swish "+w+"x"+h);

	}
	
	function setup() // start a swish
	{
	var x,y;
	var mc;
	var lmc;
	
//dbg.print("setup swish "+w+"x"+h);

		if(!_root.mc_swish)    { _root.mc_swish=gfx.create_clip(_root,16382); _root.scalar.apply(_root.mc_swish); }
		if(!_root.mc_swish.mc) { _root.mc_swish.mc=gfx.create_clip(_root.mc_swish); MainStatic.apply_800x600_scale(_root.mc_swish.mc); }
		
		
		smc=_root.mc_swish.mc;
		
		smc._alpha=100;
		
		frame=-2;
				
		switch(style)
		{
			case "wait":
			case "fade":
			case "slide_left":
			case "slide_down":
			
				mcs[0]=gfx.create_clip(smc,null,800/2,600/2);
				mcs[1]=gfx.create_clip(mcs[0],null,-800/2,-600/2,100*800/w,100*600/h);
				mcs[1].attachBitmap(bms[0],0,"auto",true);
				
			break;
			
			case "sqr_plode":
			
				for(y=0;y<ch;y++)
				{
					for(x=0;x<cw;x++)
					{						
						mc=gfx.create_clip(smc,null,(x+0.5)*sw,(y+0.5)*sw);
						mcs[y*cw+x]=mc;
						
						mc.mc=gfx.create_clip(mc,null,-sw/2,-sh/2);
						mc.mc.attachBitmap(bms[y*cw+x],0,"always",false);
						
						mc.vx=((rnd()/0x8000)-1)*16;
						mc.vy=-16+(rnd()/0x10000)*-16;
						mc.vr=mc.vx*0.5;
					}
				}
				
			break;
			
			case "sqr_shrink":
			
				for(y=0;y<ch;y++)
				{
					for(x=0;x<cw;x++)
					{						
						mc=gfx.create_clip(smc,null,(x+0.5)*sw,(y+0.5)*sw);
						mcs[y*cw+x]=mc;
						
						mc.mc=gfx.create_clip(mc,null,-sw/2,-sh/2);
						mc.mc.attachBitmap(bms[y*cw+x],0,"always",false);
						
						mc.vx=0;
						mc.vy=0;
						mc.vr=4;
					}
				}
				
			break;
			
			case "sqr_rollup":
			
				for(y=0;y<ch;y++)
				{
					lmc=null;
					if(y&1)
					{
						for(x=0;x<cw;x++)
						{
							if(lmc)
							{
								mc=gfx.create_clip(lmc,null,sw,0);
								lmc=mc;
							}
							else
							{
								mc=gfx.create_clip(smc,null,(x)*sw,(y+1)*sw);
								lmc=mc;
							}
							mcs[y*cw+x]=mc;
							
							mc.mc=gfx.create_clip(mc,null,0,-sh);
							mc.mc.attachBitmap(bms[y*cw+x],0,"always",false);
							
//							mc.mc._xscale=70;
//							mc.mc._yscale=70;
						}
					}
					else
					{
						for(x=cw-1;x>=0;x--)
						{						
							if(lmc)
							{
								mc=gfx.create_clip(lmc,null,-sw,0);
								lmc=mc;
							}
							else
							{
								mc=gfx.create_clip(smc,null,(x+1)*sw,(y+1)*sw);
								lmc=mc;
							}
							mcs[y*cw+x]=mc;
							
							mc.mc=gfx.create_clip(mc,null,-sw,-sh);
							mc.mc.attachBitmap(bms[y*cw+x],0,"always",false);
							
//							mc.mc._xscale=70;
//							mc.mc._yscale=70;
						}
					}
				}
				
			break;
		}
		
		update_do=delegate(check_update,null);
		MainStatic.update_add(_root.updates,update_do);
		
		setup_done=true;
		
		return this;
	}
	
	var update_do;
	
	function check_update()
	{
		if(!update())
		{
			clean();
		}
	}

	function clean() // finish a swish
	{
	var i;
	
		if(!setup_done) { return false; }
	
		MainStatic.update_remove(_root.updates,update_do);
		update_do=null;
		
		setup_done=false;
		
		for(i=0;i<mcs.length;i++)
		{
			if(mcs[i])
			{
				mcs[i].removeMovieClip();
			}
		}
		bms=[];
		mcs=[];
		
		frame=0;
		
//dbg.print("clean swish");

		_root.swish=null;
			
		return true;

	}
	
//
// update a swish
// (returns null when swish has finished swishing, call clean to free up memory at this point)
//
	function update()
	{
	var i,x,y;
	var mc;
	
		if(!setup_done) { return true; } // waiting to start

		
		frame++;
		if(frame<0) { return true; } // tiny pause at begining before we start animation
				
		switch(style)
		{
			case "wait":
				if(frame>25)
				{
					return false;
				}
			break;
			
			case "fade":
			
				smc._alpha = ( smc._alpha*smul ) ;
				
				if( (smc._alpha<3) && (smc._alpha>-1) )
				{
					smc._alpha=0;
					return false;
				}
		
				return true;
			break;
			
			case "slide_left":
			
				mcs[0]._x = (-900) + ( mcs[0]._x-(-900) )*0.9 ;

				if( (mcs[0]._x<-800) )
				{
					return false;
				}
				
				return true;
			break;
			
			case "slide_down":
			
				mcs[0]._y = (300+700) + ( mcs[0]._y-(300+700) )*0.9 ;

				if( (mcs[0]._y>300+600) )
				{
					return false;
				}
				
				return true;
			break;
			
			case "sqr_plode":
			
				if(frame>200) // force time out just in case
				{
					return false;
				}
				
				var keepalive=false;
				
				for(y=0;y<ch;y++)
				{
					for(x=0;x<cw;x++)
					{
						mc=mcs[y*cw+x];
						
						mc._x+=mc.vx;
						mc._y+=mc.vy;
						mc._rotation+=mc.vr;
						
						mc.vy+=2;
						
						if(frame>10)
						{
							mc._xscale*=smul;
							mc._yscale*=smul;
						}
						
						if(mc._y<1200)
						{
							keepalive=true;
						}
					}
				}
				
				if(!keepalive) // faster timeout
				{
					return false;
				}
				
				return true;
			break;
			
			case "sqr_shrink":
			
				if(frame>200)
				{
					return false;
				}
				
				for(y=0;y<ch;y++)
				{
					for(x=0;x<cw;x++)
					{
						mc=mcs[y*cw+x];
						
						mc._x+=mc.vx;
						mc._y+=mc.vy;
						mc._rotation+=mc.vr;
						
						mc._xscale*=smul;
						mc._yscale*=smul;
					}
				}
				
				
				return true;
			break;
			
			case "sqr_rollup":
			
//				smc._alpha = smc._alpha-1 ;
				
				i=Math.floor(frame/6);
				
//dbg.print(frame+" : "+i);
				if(i>=8)
				{
					return false;
				}
				
				for(y=0;y<ch;y++)
				{
					if((y&1))
					{
						if(i<8)
						{
							mc=mcs[y*cw+(cw-1-i)];
						
							mc._rotation-=90/5;
						}
					}
					else
					{
						if(i<8)
						{
							mc=mcs[y*cw+(i)];
							
							mc._rotation+=90/5;
						}
					}
				}
				
				
				return true;
			break;
		}
		
	}

}
