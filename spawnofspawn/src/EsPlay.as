/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) Kriss Daniels 2006 http://www.XIXs.com
//
/*+-----------------------------------------------------------------------------------------------------------------+*/

#include "src/opts.as"

//import com.wetgenes.gfx;
//import com.wetgenes.dbg;

class EsPlay
{
	var mc:MovieClip;

	var up;
	
	var back;
	
	var frame;
	
	var ship;
	var shot;
	
	var pinger;
	
	var breeder;
	
	var mc_land;
	var mc_water;
	
	var mc_over;
	
	var score;	
	var tf_score;
	
	var tank;	
	var tf_tank;
	
	function EsPlay(_up)
	{
		up=_up;
		back=new EsBack(this);
		ship=new EsShip(this);
		shot=new EsShot(this);
//		heart=new EsHeart(this);
		
		breeder=new EsBreeder(this);
		
		pinger=new EsPinger(this);
	}
	
	function delegate(f,d)	{	return com.dynamicflash.utils.Delegate.create(this,f,d);	}

	var rnd_num:Number=0;
	function rnd_seed(n:Number) { rnd_num=n&65535; }
	function rnd() // returns a number between 0 and 65535
	{
		rnd_num=(((rnd_num+1)*75)-1)%65537; // all hail the mighty zx spectrum pseudo random number sequence
		return rnd_num;
	}


	function setup()
	{
		frame=0;
		
		rnd_seed(up.game_seed);
		
		mc=gfx.create_clip(up.mc,null);
		
		back.setup();
		ship.setup();
		shot.setup();
//		heart.setup();
		
		breeder.setup();
		pinger.setup();

		mc_land=gfx.create_clip(mc,null);
		mc_water=gfx.create_clip(mc,null);
		
/*
		heart.add();
		heart.add();
		heart.add();
		heart.add();
		heart.add();
*/		

		breeder.add();

		tank=100;
		score=0;
		mc_over=gfx.create_clip(up.mc,null);
		tf_score=gfx.create_text_html(mc_over,null,0,0,400,50);
		tf_tank=gfx.create_text_html(mc_over,null,400,0,400,50);
	}
	
	function clean()
	{
		back.clean();
		ship.clean();
		shot.clean();
//		heart.clean();
		
		breeder.clean();
		pinger.clean();

		mc_over.removeMovieClip();
		mc.removeMovieClip();
	}

	function update()
	{
	var s;
	
		if(_root.popup) return;
		
		frame++;
	
		back.update();
		ship.update();
		shot.update();
//		heart.update();

		breeder.update();
		pinger.update();
		
		mc_land.clear();	back.draw_ground(mc_land);
		mc_water.clear();	back.draw_water(mc_water);
		
		s="";
		s+="<p align='center'>";
		s+=score;
		s+="</a>"
		gfx.set_text_html(tf_score,32,0xffffff,s);
		
		s="";
		s+="<p align='center'>";
		s+=tank;
		s+="%</a>"
		gfx.set_text_html(tf_tank,32,0xffffff,s);
		
	}
	
}