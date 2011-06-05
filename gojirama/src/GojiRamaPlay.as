/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) Kriss Daniels 2007 http://www.XIXs.com
//
/*+-----------------------------------------------------------------------------------------------------------------+*/

#include "src/opts.as"


class GojiRamaPlay
{
	var up;
	var mc;
	var mc_base;
	var mc_back;
	var mc_ads;
	
	var mc_goji;
	
	var mc_miss;
	
	var mc_ding;
	
	var pops;
	var mc_pops;
	
	var frame;
	var frame_wait;
	
	var mc_over;
	
	var mc_over_b1a;
	var mc_over_b1b;
	var mc_over_b2a;
	var mc_over_b2b;
	
	var mc_over2;
	
	var mc_type;
	
	var mc_score;
	
	var field;
	
	var hud;
	
	var player;
	
	var high;
//	var about;
//	var won;
	
	var gamemode;
	var gameskill;
	
	var done_adds;

	
	var type_word;
	var type_type;
	var type_width;
	
	var type_speed;
	var type_wait;
	
	var score;
	var score_max;
	

	var game_seed;
	
	function GojiRamaPlay(_up)
	{
		gamemode="puzzle";
		gameskill="normal";
		
		up=_up;
	}
	
	function delegate(f,d)	{	return com.dynamicflash.utils.Delegate.create(this,f,d);	}

	var rnd_num:Number=0;
	function rnd_seed(n:Number) { rnd_num=n&65535; grnd_num=n&65535; }
	function rnd() // returns a number between 0 and 65535
	{
		rnd_num=(((rnd_num+1)*75)-1)%65537; // all hail the mighty zx spectrum pseudo random number sequence
		return rnd_num;
	}

	var grnd_num:Number=0;
	function grnd_seed(n:Number) { grnd_num=n&65535; }
	function grnd() // returns a number between 0 and 65535
	{
		grnd_num=(((grnd_num+1)*75)-1)%65537; // all hail the mighty zx spectrum pseudo random number sequence
		return grnd_num;
	}
	

	function setup()
	{
	var i;
	
		rnd_seed(up.game_seed);
		game_seed=up.game_seed;
		
		done_adds=false;

		mc=gfx.create_clip(up.mc,null);
		
		mc_base=gfx.create_clip(mc,null);
		mc_back=gfx.create_clip(mc_base,null);
		
		score=0;
		score_max=0;
		
		type_speed=2;
		type_wait=type_speed-1;
		
		
		high=new PlayHigh(this);

//		mc_ads=gfx.create_clip(mc,null);
//		gfx.dropshadow(mc_ads , 2 , 45, 0x000000, 1, 4, 4, 2, 3);
		
		
//		gfx.clear(mc_back);
//		mc_back.style.fill=0xff707090;
//		gfx.draw_box(mc_back,0,0,0,800,600);
		
//		mc_back=gfx.add_clip(mc,"back",null);
//		mc_back.cacheAsBitmap=true;
			
/*
		high=new PlayHigh(this);
		about=new PlayAbout(this);
		won=new PlayWon(this);
		

		field=new PlayField(this);
		field.setup();
		
		field.mc_scalar._x=200;
		field.mc_scalar._y=100;
		field.mc_scalar._xscale=100*(400/800);
		field.mc_scalar._yscale=field.mc_scalar._xscale;

		hud=new PlayHUD(this);
		hud.setup();
		
		player=0;
		
		high.setup();
*/
		
//		setup_ads();
		

		
		for(i=-1;i<7;i++)
		{
			if(i==-1)
			{
				mc_back["b0"+"-1"]=gfx.create_clip(mc_base,null);
				mc_back["b0"+"-1"].cacheAsBitmap=true;
				mc_back["b0"+"-1"].b1=gfx.add_clip(mc_back["b0"+"-1"],"swf_back0"+0,null);
				mc_back["b0"+"-1"].b1.gotoAndStop(1);
				
				mc_back["b0"+"-1"].b2=gfx.add_clip(mc_back["b0"+"-1"],"swf_back0"+0,null);
				mc_back["b0"+"-1"].b2.gotoAndStop(1);
				mc_back["b0"+"-1"].b2._x=2048;
				mc_back["b0"+"-1"].mx=2048;
			}
			else
			{
				mc_back["b0"+i]=gfx.create_clip(mc_base,null);
				mc_back["b0"+i].cacheAsBitmap=true;
				mc_back["b0"+i].b1=gfx.add_clip(mc_back["b0"+i],"swf_back0"+i,null);
				mc_back["b0"+i].b1.gotoAndStop(2);
				
				if((i>0)&&(i<6))
				{
					mc_back["b0"+i].b2=gfx.add_clip(mc_back["b0"+i],"swf_back0"+i,null);
					mc_back["b0"+i].b2.gotoAndStop(2);
					mc_back["b0"+i].b2._x=1024;
					mc_back["b0"+i].mx=1024;
				}
				else
				{
					mc_back["b0"+i].b2=gfx.add_clip(mc_back["b0"+i],"swf_back0"+i,null);
					mc_back["b0"+i].b2.gotoAndStop(2);
					mc_back["b0"+i].b2._x=2048;
					mc_back["b0"+i].mx=2048;
				}
			}
			
			mc_back["b0"+i].vx=-i-3;
			
			if(i==0)
			{
				if(up.actor=="goj")
				{
					mc_goji=gfx.add_clip(mc_base,"swf_goji",null);
				}
				else
				{
					mc_goji=gfx.add_clip(mc_base,"swf_poji",null);
				}
				mc_goji.gotoAndStop(1);
				mc_goji._x=-600;
				mc_goji._y=0;
				frame_wait=0;
				frame=1;
				
				mc_goji.cacheAsBitmap=true;
								
				mc_ding=gfx.create_clip(mc_base,null);
				mc_ding.cacheAsBitmap=true;
				
				mc_miss=gfx.add_clip(mc_base,"swf_miss",null);
				mc_miss.cacheAsBitmap=true;
				mc_miss.gotoAndStop(1);
				mc_miss._visible=false;
				mc_miss.showfor=0;

				mc_pops=gfx.create_clip(mc_base,null);
				pops=PopItem.setup_pops();
			}
		}
		
		mc_type=gfx.create_clip(mc_base,null);
//		mc_type.cacheAsBitmap=true;
		
		mc_type.mcback=gfx.create_clip(mc_type,null);
		mc_type.back=gfx.create_text_html(mc_type.mcback,null,0,0,600,100);
		gfx.dropshadow(mc_type.mcback , 2 , 45, 0x000000, 1, 4, 4, 2, 3);
		
		mc_type.mcover=gfx.create_clip(mc_type,null);
		mc_type.over=gfx.create_text_html(mc_type.mcover,null,0,0,600,100);
		gfx.glow(mc_type.mcover , 0xffffff, .8, 16, 16, 1, 3, false, false );
			
		ding_reset();

		mc_over=gfx.add_clip(mc,"swf_over",null);
		mc_over.gotoAndStop(2);
		mc_over.cacheAsBitmap=true;
				
		mc_over_b1a=gfx.add_clip(mc,"swf_over",null);
		mc_over_b1a.gotoAndStop(3);
		mc_over_b1a.cacheAsBitmap=true;
		mc_over_b1b=gfx.add_clip(mc,"swf_over",null);
		mc_over_b1b.gotoAndStop(4);
		mc_over_b1b.cacheAsBitmap=true;
		mc_over_b2a=gfx.add_clip(mc,"swf_over",null);
		mc_over_b2a.gotoAndStop(5);
		mc_over_b2a.cacheAsBitmap=true;
		mc_over_b2b=gfx.add_clip(mc,"swf_over",null);
		mc_over_b2b.gotoAndStop(6);
		mc_over_b2b.cacheAsBitmap=true;
		mc_over2=gfx.add_clip(mc,"swf_over",null);
		mc_over2.gotoAndStop(7);
		mc_over2.cacheAsBitmap=true;
		
		mc_base._xscale=100*(500/600);
		mc_base._yscale=100*(500/600);
		mc_base._x=0;
		mc_base._y=50;
		
		mc_score=gfx.create_clip(mc,null);
		mc_score.tf1=gfx.create_text_html(mc_score,null,100,10,300,75);
		mc_score.tf2=gfx.create_text_html(mc_score,null,400,10,300,75);
		mc_score.tf2._alpha=50;
		gfx.glow(mc_score , 0xffffff, .8, 16, 16, 1, 3, false, false );
		

		Key.addListener(this);
		Mouse.addListener(this);
		
		_root.signals.signal("gojirama","set",this);
		_root.signals.signal("gojirama","start",this);
		
		
		_root.wetplay.PlaySFX("sfx_gojirama",2,0x7fffffff);	
	}
		
	function clean()
	{
		Mouse.removeListener(this);
		Key.removeListener(this);
		
		_root.signals.signal("gojirama","end",this);
		
		PopItem.clean_pops(pops);
		
		mc.removeMovieClip();
	}


	var firstbuilding;
	
	function ding_reset()
	{
		firstbuilding=true;
		
		rnd_seed(up.game_seed); // reset seed

		score=0;
		type_speed=2;
		type_wait=type_speed-1;

		ding_clean();
		ding_setup();
		
	}
			
	function ding_half()
	{
		firstbuilding=true;
		
//		rnd_seed(up.game_seed); // reset seed

		score=Math.floor(score/2);
		type_speed=type_speed-2;
		if(type_speed<2) { type_speed=2; }
		type_wait=type_speed-1;

		ding_clean();
		ding_setup();
		
	}
	
	function ding_setup()
	{
			mc_ding.dong=gfx.add_clip(mc_ding,"swf_ding0"+(1+(grnd()%10)),null);
			
			if(firstbuilding)
			{
				gfx.add_clip(mc_ding.dong,"swf_type",null);
				firstbuilding=false;
			}
			
			mc_ding._x=700;
			mc_ding.vx=-type_speed;
			
			type_setup();
	}
	function ding_update()
	{
			type_update();
			
			mc_ding._x+=mc_ding.vx;
			if(mc_ding._x<-400)		// dead
			{
				_root.signals.signal("gojirama","end",this);
				
				ding_half(); // less harsh death
//				ding_reset();
				
				_root.signals.signal("gojirama","start",this);
			}
			
			if(mc_goji._x<400) // slowly move towards right of screen
			{
				mc_goji._x+=2;
			}
			
			if(mc_goji._x>(mc_ding._x-200)) // get pushed off screen
			{
				mc_goji._x=(mc_ding._x-200);
			}
			
			
	}
	function ding_clean()
	{
			type_clean();
			mc_ding.dong.removeMovieClip();
	}
	
	function type_setup()
	{
		type_word=words[ rnd()%(words.length-1) ];
		type_type="";
		
		gfx.set_text_html(mc_type.back,64,0x888888,"<b>"+type_word+"</b>");
		
		type_width=mc_type.back.textWidth;
		

		type_update();
	}
	function type_update()
	{
		mc_type._x=mc_ding._x+400-(type_width/2);
		mc_type._y=mc_ding._y+200;
		
		gfx.set_text_html(mc_type.over,64,0xffffff,"<b>"+type_type+"</b>");
		gfx.set_text_html(mc_score.tf1,32,0xffffff,"<p align=\"center\"><font size=\"12\"><b>1up</b></font></p><p align=\"center\"><b>"+score+"</b></p>");
		if(score_max<score) { score_max=score; }
		gfx.set_text_html(mc_score.tf2,32,0xffffff,"<p align=\"center\"><font size=\"12\"><b>high</b></font></p><p align=\"center\"><b>"+score_max+"</b></p>");

	}
	function type_clean()
	{
	}
	
	function onKeyDown()
	{
	var i;
	var k;
	var s;
	
		k=Key.getAscii();
		s=(String.fromCharCode(k)).toLowerCase();
		
		if( s == type_word.slice(type_type.length,type_type.length+1) ) // next letter
		{
			type_type+=s;
		}
		
		if(type_type.length==type_word.length)
		{
			var r=(grnd()%5)
			
			frame_wait=12;
			mc_goji.gotoAndStop(1);
			mc_goji.gotoAndStop(7+r);
			
			sfx_play(r);
			
			if( mc_goji._x<(mc_ding._x-300) ) // miss?
			{
				type_type="";
				
				mc_miss._x=mc_goji._x+200;
				mc_miss.gotoAndStop(2+(grnd()%2));
				mc_miss._visible=true;
				mc_miss.showfor=25;
				
			}
			else // hit
			{
			
				score+=type_speed*type_type.length; // score speed per letter
			
				type_wait--;
				if(type_wait<=0)
				{
					type_speed++;
					type_wait=type_speed-1;
				}
				
				for(i=0;i<8;i++)
				{
				var tx,ty,txv,tyv;
				
					tx=mc_ding._x+400+50 + (grnd()%129)-64;
					ty=300 + (grnd()%257)-128;
					txv=(grnd()%33)-16;
					tyv=-30 + (grnd()%33)-16;
					PopItem.insert_pops(pops,mc_pops,1+(grnd()%10),tx,ty,txv,tyv);
				}
				
				ding_clean();
				ding_setup();
			}
		}

		
	}
	
var hover=null;

	function onMouseUp()
	{
		if( (_root.popup) || (_root.pause) )
		{
			return;
		}
		
		switch(hover)
		{
			case "over_b1" :
				up.state_next="splash";
			break;
			case "over_b2" :
				_root.signals.signal("gojirama","high",this);
				high.setup();
			break;
		}
	}



	function update()
	{
	var i;
	
//		setup_ads();
		
		if( (_root.popup) || (_root.pause) )
		{
			return;
		}
		
		_root.signals.signal("gojirama","update",this);
		
		
		hover=null;
			
		if	(
				( mc_over_b1a.hitTest( _root._xmouse, _root._ymouse, false) )
//				||
//				( mc_over_b1b.hitTest( _root._xmouse, _root._ymouse, false) )
			)
		{
			mc_over_b1a._visible=false;
			mc_over_b1b._visible=true;
			hover="over_b1";
		}
		else
		{
			mc_over_b1a._visible=true;
			mc_over_b1b._visible=false;
		}
		if	(
				( mc_over_b2a.hitTest( _root._xmouse, _root._ymouse, false) )
//				||
//				( mc_over_b2b.hitTest( _root._xmouse, _root._ymouse, false) )
			)
		{
			mc_over_b2a._visible=false;
			mc_over_b2b._visible=true;
			hover="over_b2";
		}
		else
		{
			mc_over_b2a._visible=true;
			mc_over_b2b._visible=false;
		}
		
		for(i=-1;i<7;i++)
		{			
			mc_back["b0"+i]._x+=mc_back["b0"+i].vx;
			if(mc_back["b0"+i]._x<-mc_back["b0"+i].mx) { mc_back["b0"+i]._x+=mc_back["b0"+i].mx; }
			if(mc_back["b0"+i]._x> mc_back["b0"+i].mx) { mc_back["b0"+i]._x-=mc_back["b0"+i].mx; }
		}
		
		frame_wait--;
		if(frame_wait<=0)
		{
			frame_wait=3;
			frame++;
			if(frame>6)
			{
				frame=1;
			}
			mc_goji.gotoAndStop(1);
			mc_goji.gotoAndStop(frame);
		}
		
		ding_update();

		
		PopItem.update_pops(pops);
		
		if(mc_miss.showfor>0)
		{
			mc_miss.showfor--;
			mc_miss._visible=true;
		}
		else
		{
			mc_miss._visible=false;
			mc_miss.showfor=0;
		}
		
//		field.update();
		
//		hud.update();
	}	
		
	function setup_ads()
	{
	var i,x,y,m,w,m2;
	
		if( up.wonderfulls && (!done_adds) )
		{
			x=800+10-180;
			y=120;
			for(i=0;i<8;i++)
			{
				w=up.wonderfulls[i];
				
				m=gfx.create_clip(mc_ads,null);
				m2=gfx.create_clip(m,null);
				m2._lockroot=true;
				m.onRelease=delegate(goad,w);

				m._x=x;
				m._y=y;
				m._xscale=100*600/480;
				m._yscale=100*600/480;
				m2.loadMovie(w.img);
				
				y+=45;
				
//				dbg.print(w.img);
			}
			
			w=up.wonderfulls[i];
			
			m=gfx.create_clip(mc_ads,null);
			m.onRelease=delegate(goad,w);

			m._x=x-20;
			m._y=y;
			m.tf=gfx.create_text_html(m,null,0,0,180,45);
			gfx.set_text_html(m.tf,10,0xffffff,"<p align='center'>"+w.txt+"</p>");
				
			done_adds=true;
		}
	}
	function goad(w)
	{
		if(!_root.popup) // ignore while a popup is displayed
		{
			getURL(w.url,w.target);
		}
	}
	
	function sfx_play(id)
	{
		if(up.actor=="goj")
		{
			switch(id)
			{
				case 0:
					_root.wetplay.PlaySFX("sfx_roar",1);	
				break;
				case 1:
					_root.wetplay.PlaySFX("sfx_kick",1);	
				break;
				case 2:
					_root.wetplay.PlaySFX("sfx_roar",1);	
				break;
				case 3:
					_root.wetplay.PlaySFX("sfx_kick",1);	
				break;
				case 4:
					_root.wetplay.PlaySFX("sfx_roar",1);	
				break;
			}
		}
		else
		{
			switch(id)
			{
				case 0:
					_root.wetplay.PlaySFX("sfx_peihit",1);
				break;
				case 1:
					_root.wetplay.PlaySFX("sfx_peihit",1);
				break;
				case 2:
					_root.wetplay.PlaySFX("sfx_peipunch",1);
				break;
				case 3:
					_root.wetplay.PlaySFX("sfx_peiroar",1);	
				break;
				case 4:
					_root.wetplay.PlaySFX("sfx_peikick",1);
				break;
			}
		}
	
	}
	
	function do_str(str)
	{
		up.do_str(str);
	}
	
	static var words=[
#for line in io.lines("../wetsrc/art/adjectives.txt") do 
#line=line:gsub("^%s*(.-)%s*$", "%1")
	"#(line)",
#end
#for line in io.lines("../wetsrc/art/nouns.txt") do 
#line=line:gsub("^%s*(.-)%s*$", "%1")
	"#(line)",
#end
	""];
}