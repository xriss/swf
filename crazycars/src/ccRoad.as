/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) Kriss Daniels 2006 http://www.XIXs.com
//
/*+-----------------------------------------------------------------------------------------------------------------+*/

#include "src/opts.as"



class ccRoad
{

	var up; // Main

	var mcs;
	var mc;
	
	var bmp;
	
	var brl;
	var brr;
				
	function delegate(f,d,i)	{	return com.dynamicflash.utils.Delegate.create(this,f,d,i);	}
	
// ser
	var rnd_num=0;
	function rnd_seed(n) { rnd_num=n&0xffff; }
	function rnd() // returns a number between 0 and 65535
	{
		rnd_num=(((rnd_num+1)*75)-1)%65537; // all hail the mighty zx spectrum pseudo random number sequence
		return rnd_num;
	}


	function ccRoad(_up)
	{
		
		up=_up;
		

	}
			

	function setup()
	{	
	var i;
	
		_root.bmc.remember( "roadl" , bmcache.create_img , //this is safe as it only works once
		{
			url:"roadl" ,
			bmpw:629 , bmph:16 , bmpt:true ,
			hx:629 , hy:0 ,
			onload:null
		} );
		_root.bmc.remember( "roadr" , bmcache.create_img , //this is safe as it only works once
		{
			url:"roadr" ,
			bmpw:629 , bmph:16 , bmpt:true ,
			hx:0 , hy:0 ,
			onload:null
		} );
		
		brl=_root.bmc.getbmp("roadl");
		brr=_root.bmc.getbmp("roadr");
		
		
	
		mcs=gfx.create_clip(up.mc);
		mcs._xscale=100*800/640;
		mcs._yscale=mcs._xscale;
		
		mc=gfx.create_clip(mcs);
			
		bmp=new flash.display.BitmapData(1280,480+32,true,0x00000000);
		
		mc.r0=gfx.create_clip(mc);
		mc.r0.attachBitmap(bmp,0,"auto",true);
		mc.r0._x=-320;
		mc.r0._y=0;
		
		mc.r1=gfx.create_clip(mc);
		mc.r1.attachBitmap(bmp,0,"auto",true);
		mc.r1._x=-320;
		mc.r1._y=-(480+32);
			
//		gfx.add_clip(mc.r0,"roadl");


//		bmp.fillRect( new flash.geom.Rectangle( 320+0,0 , 64,64 ) , 0xffff0000);
//		bmp.fillRect( new flash.geom.Rectangle( 320+64,64 , 64,64 ) , 0xffffff00);
//		bmp.fillRect( new flash.geom.Rectangle( 320+0,128 , 64,64 ) , 0xffff0000);
		
	
		var x,y,xs;
		
		x=128;
		xs=128;
		for(y=0;y<480+32;y+=16)
		{
		var m,s;
			m=(rnd()%16)-8;
			s=(rnd()%16)-4;
			x+=m-(s/2);
			xs-=m-(s/2);
			bmp.copyPixels(brl, new flash.geom.Rectangle(0+x, 0, 629-x, 16), new flash.geom.Point(0, y));
			bmp.copyPixels(brr, new flash.geom.Rectangle(0, 0, 629-xs, 16), new flash.geom.Point(1280-629+xs, y));
			
		}
		
		mc.vy=4;

	}
	
	
	function clean()
	{		
		mc.removeMovieClip(); mc=null;	
	}
	
	function update()
	{
	var i;
	
	
		if( mc.vy>0 )
		mc._y=(mc._y+mc.vy)%(480+32);
	
	}
	
}
