/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) Kriss Daniels 2006 http://www.XIXs.com
//
/*+-----------------------------------------------------------------------------------------------------------------+*/

#include "src/opts.as"


class EsPlay
{
	var mc:MovieClip;

	var up;
	
	var back;
	
	var talky;
	
	var ship;
	var shot;
	
	var heart;
	
	var mc_texture;
	var mc_land;
	var mc_water;
	
	var mc_over;
	
	var mc_radar;
	
	var score;	
	var tf_score;
	
	var pops;	
	var pops_heart;
	var tf_pops;
	
	var tank;	
	var tf_tank;
	
	function EsPlay(_up)
	{
		up=_up;
		back=new EsBack(this);
		ship=new EsShip(this);
		shot=new EsShot(this);
		heart=new EsHeart(this);
		talky=new Talky(up);
		
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
		pops=0;
		pops_heart=null;
		
		rnd_seed(up.game_seed);
		
		mc=gfx.create_clip(up.mc,null);
		mc.cacheAsBitmap=false;
		
		talky.setup();
		
		back.setup();
		
		mc_texture=gfx.create_clip(mc,null);
		
		ship.setup();
		shot.setup();
		heart.setup();
		
		mc_land=gfx.create_clip(mc,null);
		mc_water=gfx.create_clip(mc,null);
		
		mc_texture.clear();	back.draw_texture(mc_texture);
		mc_land.clear();	back.draw_ground(mc_land);
		
		heart.add();
		heart.add();
		heart.add();
		heart.add();
		heart.add();
		
		
		mc_radar=gfx.create_clip(up.mc,null);
		mc_radar._xscale=0.5;
		mc_radar._yscale=mc_radar._xscale;
		mc_radar._x=60;
		mc_radar._y=40;
		mc_radar._alpha=50;
		
		mc_radar.land=gfx.create_clip(mc_radar,null);
		mc_radar.land.clear();	back.draw_ground(mc_radar.land);
		mc_radar.land.cacheAsBitmap=true;
		
		mc_radar.dots=gfx.create_clip(mc_radar,null);
		
		tank=100;
		score=0;
		mc_over=gfx.create_clip(up.mc,null);
		
		mc_over.score=gfx.create_clip(mc_over,null);
		tf_score=gfx.create_text_html(mc_over.score,null,0,0,400,50);
		
		tf_tank=gfx.create_text_html(mc_over,null,400,0,400,50);
		
		mc_over.pops=gfx.create_clip(mc_over,null);
		tf_pops=gfx.create_text_html(mc_over.pops,null,0,50,120,25);
		
		mc_over.score.id="score";
		make_clickable(mc_over.score);
		
		_root.signals.signal("#(VERSION_NAME)","start",this);
	}
	
	function click(_mc)
	{
		switch(_mc.id)
		{
			case "score":
				_root.signals.signal("#(VERSION_NAME)","high",this);
				up.high.setup();
			break;
		}
	}
	function hover_on(_mc)
	{
			_root.poker.ShowFloat("Click here to view high scores.",25*5);
	}
	function hover_off(_mc)
	{
			_root.poker.ShowFloat(null,0);
	}
	
	function make_clickable(_mc)
	{
		_mc.onRelease=delegate(click,_mc);
		_mc.onRollOver=delegate(hover_on,_mc);
		_mc.onRollOut=delegate(hover_off,_mc);
		_mc.onReleaseOutside=delegate(hover_off,_mc);
	}
	
	function clean()
	{
		talky.clean();
		back.clean();
		ship.clean();
		shot.clean();
		heart.clean();
		
		mc_over.removeMovieClip();
		mc_radar.removeMovieClip();
		mc.removeMovieClip();
		
		_root.signals.signal("#(VERSION_NAME)","end",this);
	}

	function update()
	{
	var s;
	var _mc;
	var i,h;
	
		if(_root.popup) return;
	
		_root.signals.signal("#(VERSION_NAME)","update",this);
		
		talky.update();
		ship.update();
		back.update();
		shot.update();
		heart.update();
		
		mc_water.clear();	back.draw_water(mc_water);

		_mc=mc_radar.dots;
		gfx.clear(_mc)
		
		var pix=function(x,y)
		{
			var siz=1024;
			gfx.draw_box(_mc,0,x-(siz/2),y-(siz/2),siz,siz);
		}
		
		
		_mc.style.fill=0xffff0000;
		for(i=0;i<heart.max;i++)
		{
			h=heart.mcs[i];
			if(h.active)
			{
				pix(h._x,h._y);
			}
		}
		
		_mc.style.fill=0xff00ff00;
		pix(ship.mc._x,ship.mc._y);


		s="";
		s+="<p align='center'>";
		s+=score;
		s+="</a>"
		gfx.set_text_html(tf_score,32,0xffffff,s);
		
		s="";
		s+="<p align='center'>";
		s+=pops + (heart.filled(pops_heart)/100);
		s+="</a>"
		gfx.set_text_html(tf_pops,16,0xff0000,s);
		
		s="";
		s+="<p align='center'>";
		s+=tank;
		s+="%</a>"
		gfx.set_text_html(tf_tank,32,0xffffff,s);
		
	}
	
}