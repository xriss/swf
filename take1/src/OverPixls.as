/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) Kriss Daniels 2006 http://www.XIXs.com
//
/*+-----------------------------------------------------------------------------------------------------------------+*/

#include "src/opts.as"

// A collection of stacks of cards making up the game LIES!!!!


class OverPixls
{

	var up; // PixlCoopPlay

	var mc;
	
	var mcs;
	var bm;
	var bms;
	
	var minx,miny;
	var maxx,maxy;
	
	var bmp_levelup;
	var bmp_hardcore;
	var bmp_extreme;
	var bmp_ultimate;
	var bmp_unlocked;
	
	function delegate(f,a,b,c)	{	return com.dynamicflash.utils.Delegate.create(this,f,a,b,c);	}
	
// ser
	var rnd_num=0;
	function rnd_seed(n) { rnd_num=n&0xffff; }
	function rnd() // returns a number between 0 and 65535
	{
		rnd_num=(((rnd_num+1)*75)-1)%65537; // all hail the mighty zx spectrum pseudo random number sequence
		return rnd_num;
	}


	function OverPixls(_up)
	{
		up=_up;		
	}
	

	function setup()
	{	
	var i;
	var j;
	var it;
		
		rnd_seed(0);//up.rnd_num);
		
		mc=gfx.create_clip(up.mc,null);
				
		maxx=80;
		maxy=60;
		
		mcs=[];
		bms=[];
		
		for(i=0;i<2;i++)
		{
			bms[i]=new flash.display.BitmapData(maxx,maxy,true,0x00000000);
		}
		
//		bm=new flash.display.BitmapData(maxx,maxy,true,0x00000000);
		mcs[0]=gfx.create_clip(mc,null);
//		mcs[0].attachBitmap(bm,0,"always",false);
		mcs[0]._xscale=1000;
		mcs[0]._yscale=1000;

		
		_root.bmc.remember( "pixl_txt_levelup" , bmcache.create_img , //this is safe as it only works once
		{
			url:"pixl_txt_levelup" ,
			bmpw:64 , bmph:16 , bmpt:true ,
			hx:0 , hy:0 ,
			onload:null
		} );
		
		bmp_levelup=_root.bmc.getbmp("pixl_txt_levelup");
//		bmp_levelup.colorTransform(bmp_levelup.rectangle, new flash.geom.ColorTransform(1, 1, 1, 1, 0, 0, 0, -64));

		_root.bmc.remember( "pixl_txt_hardcore" , bmcache.create_img , //this is safe as it only works once
		{
			url:"pixl_txt_hardcore" ,
			bmpw:64 , bmph:16 , bmpt:true ,
			hx:0 , hy:0 ,
			onload:null
		} );
		
		bmp_hardcore=_root.bmc.getbmp("pixl_txt_hardcore");

		_root.bmc.remember( "pixl_txt_extreme" , bmcache.create_img , //this is safe as it only works once
		{
			url:"pixl_txt_extreme" ,
			bmpw:64 , bmph:16 , bmpt:true ,
			hx:0 , hy:0 ,
			onload:null
		} );
		
		bmp_extreme=_root.bmc.getbmp("pixl_txt_extreme");

		_root.bmc.remember( "pixl_txt_ultimate" , bmcache.create_img , //this is safe as it only works once
		{
			url:"pixl_txt_ultimate" ,
			bmpw:64 , bmph:16 , bmpt:true ,
			hx:0 , hy:0 ,
			onload:null
		} );
		
		bmp_ultimate=_root.bmc.getbmp("pixl_txt_ultimate");
		
		_root.bmc.remember( "pixl_txt_levelup" , bmcache.create_img , //this is safe as it only works once
		{
			url:"pixl_txt_levelup" ,
			bmpw:64 , bmph:16 , bmpt:true ,
			hx:0 , hy:0 ,
			onload:null
		} );
		
		bmp_levelup=_root.bmc.getbmp("pixl_txt_levelup");
	}
	
	function clean()
	{
		mc.removeMovieClip(); mc=null;
	}
	
	
	var txt_scroll_pos=0;
	
	var bmidx=0;
	
	function update()
	{
	var p0=new flash.geom.Point(0, 0);
	var r0=new flash.geom.Rectangle(0, 0, maxx, maxy);
	var blur=new flash.filters.BlurFilter(2, 0, 1);
	var glow=new flash.filters.GlowFilter(0xff0000, 0.5, 2, 0, 1, 3, false, false);
	var bmnxt=(bmidx+1)%2;


//		bms[bmidx].applyFilter(bms[bmidx], r0, p0, glow );

		bms[bmnxt].applyFilter(bms[bmidx], r0, p0, blur );
		bms[bmnxt].colorTransform(r0, new flash.geom.ColorTransform(1.1, 1.1, 1.1, 1.1, 0, 0, 0, 0));
		

		bms[bmidx].merge(bms[bmnxt], new flash.geom.Rectangle(0, 1, maxx, maxy-1), new flash.geom.Point(0, 0), 128, 128, 128, 128);
		bms[bmidx].merge(bms[bmidx], new flash.geom.Rectangle(0, 1, maxx, maxy-1), new flash.geom.Point(0, 0), 128, 128, 128, 128);
		bms[bmidx].merge(bms[bmidx], new flash.geom.Rectangle(0, 1, maxx, maxy-1), new flash.geom.Point(0, 0), 128, 128, 128, 128);

		bms[bmidx].fillRect(new flash.geom.Rectangle(0, maxy-1, maxx, 1), 0x00000000);
		bms[bmnxt].fillRect(new flash.geom.Rectangle(0, maxy-1, maxx, 1), 0x00000000);

//		bm.copyPixels(bms[bmidx], new Rectangle(0, 0, maxx, maxy), new Point(0, 0));
		
		mcs[0].attachBitmap(bms[bmidx],0,"always",false);

		
/*
		if(txt_scroll_pos < (maxx+128) )
		{
		var p1=new flash.geom.Point(0, maxy-34);
		var r1=new flash.geom.Rectangle(0, 0, 128, 32);
	
			txt_scroll_pos+=4;
			

			p1.x=maxx-txt_scroll_pos;
			
			if(p1.x<0)
			{
				r1.width+=p1.x;
				r1.x=-p1.x;
				p1.x=0;
			}
			
			if( p1.x+r1.width > maxx )
			{
				r1.width=maxx-p1.x;
			}
			
			bms[bmidx].copyPixels(bmp_levelup, r1, p1,null,null,true);
		}
*/

//		bmidx=bmnxt;
	}
	
	function add_blip(c,x,y)
	{
	var xp,yp;
	
txt_scroll_pos=0;

//		dbg.print(x+","+y);

		xp=Math.floor(x/10);
		yp=Math.floor(y/10);

		bms[bmidx].setPixel32( xp   , yp   , c );
		bms[bmidx].setPixel32( xp+1 , yp   , c );
		bms[bmidx].setPixel32( xp-1 , yp   , c );
		bms[bmidx].setPixel32( xp   , yp+1 , c );
		bms[bmidx].setPixel32( xp   , yp-1 , c );
		
//		add_levelup();
	}
	
	function add_cross(c,x,y)
	{
	var xp,yp;
	
txt_scroll_pos=0;

//		dbg.print(x+","+y);

		xp=Math.floor(x/10);
		yp=Math.floor(y/10);

		bms[bmidx].setPixel32( xp   , yp   , c );
		bms[bmidx].setPixel32( xp+1 , yp+1 , c );
		bms[bmidx].setPixel32( xp-1 , yp-1 , c );
		bms[bmidx].setPixel32( xp-1 , yp+1 , c );
		bms[bmidx].setPixel32( xp+1 , yp-1 , c );
		
//		add_levelup();
	}
	
	function add_levelup()
	{
	var p1=new flash.geom.Point((maxx-64)/2, maxy-18);
	var r1=new flash.geom.Rectangle(0, 0, 64, 16);
	
		bms[bmidx].copyPixels(bmp_levelup, r1, p1,null,null,true);
	}
	function add_hardcore()
	{
	var p1=new flash.geom.Point((maxx-64)/2, maxy-18);
	var r1=new flash.geom.Rectangle(0, 0, 64, 16);
	
		bms[bmidx].copyPixels(bmp_hardcore, r1, p1,null,null,true);
	}
	function add_extreme()
	{
	var p1=new flash.geom.Point((maxx-64)/2, maxy-18);
	var r1=new flash.geom.Rectangle(0, 0, 64, 16);
	
		bms[bmidx].copyPixels(bmp_extreme, r1, p1,null,null,true);
	}
	function add_ultimate()
	{
	var p1=new flash.geom.Point((maxx-64)/2, maxy-18);
	var r1=new flash.geom.Rectangle(0, 0, 64, 16);
	
		bms[bmidx].copyPixels(bmp_ultimate, r1, p1,null,null,true);
	}
	
	function add_unlocked()
	{
	var p1=new flash.geom.Point((maxx-64)/2, maxy-18);
	var r1=new flash.geom.Rectangle(0, 0, 64, 16);
	
		bms[bmidx].copyPixels(bmp_unlocked, r1, p1,null,null,true);
	}
}
