/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) Kriss Daniels 2006 http://www.XIXs.com
//
/*+-----------------------------------------------------------------------------------------------------------------+*/

#include "src/opts.as"




class #(VERSION_NAME)PlayDat
{

	var up; // RomZom
	
	
	var weight;
	var level;
	var power;
	
	var upgradable;
	
	var level_need;	
	var level_power;
	var level_avail;
	
	var score_str;
	
	
	function delegate(f,d,i)	{	return com.dynamicflash.utils.Delegate.create(this,f,d,i);	}
	
	function talky_display(s) { up.talky_display(s); }
	
	function #(VERSION_NAME)PlayDat(_up)
	{
		up=_up;
				
		saves_reset();
	}
	

	function setup()
	{
		show_glow();
	}
	
	function clean()
	{
	}
	
	function update()
	{
	
/*
		if(true)
		{
			if(level_power[level]<999)
			{
				while(level_power[level]<999) // move to penaultimate level
				{
					level++;
				}
				up.up.over.pixls.add_unlocked();
			}
		}
*/
		
		var p=Math.floor(100*(weight-level_need[level-1])/((level_need[level])-level_need[level-1]));
		if(p>100) { p=100; }
//		score_str=up.score+" <br> "+weight+" <br> "+ p +"%" ;
		score_str=up.score;
	}
	
	
	function saves_reset_temps()
	{		
	}
	
	function saves_reset()
	{
		up.saves={};
		
		weight=0;
		level=1;
		
		upgradable=false;
		
		score_str="";
		
		up.score=0;
		
		level_need=	[	0,	150,	340,	800,	2300,	4000,	5000,	7000,	9000,	10177,	99999999	];
		level_power=[	0,	10,		30,		50,		70,		100,	120,	170,	250,	999,	9999		];
		level_avail=null;
				
//		jiggle_takes();
	}
	
	var snapshot;
	var snapshot_dir; // use "" for no transition otherwise a direction to scroll into the newroom from
	
	var avail;
	var notgone;
	
	
	function launch(me)
	{
	var tmc;
	
		gfx.clear_filters(me);
		
		me.vx=((up.rnd()/32768)-1)*8 + 0;
		me.vy=((up.rnd()/32768)-1)*8 - 16;
		me.ay+=1;
		if(me.ay<2) { me.ay=2; }
		
		if(me.state!="fall")
		{
			me.state="fall";
			tmc=gfx.create_clip(up.topmc,null);
			me.swapDepths(tmc);
		}
	}
	
	function launch_upgrade(me)
	{
	var tmc;
	
		me.wait=10; // wait a bit before we allow upgrade
	
		gfx.glow(me , 0xff0000, 1, 6, 6, 1, 3, false, false );

		if(me.weight<50)
		{
			me._xscale=300;
			me._yscale=300;
		}
		
		me.state="upgrade";
		me.vx=((up.rnd()/32768)-1)*4 + 0;
		me.vy=((up.rnd()/32768)-1)*4 - 0;

		
		if((me.vx>=0)&&(me.vx< 2)){me.vx= 2}
		if((me.vy>=0)&&(me.vy< 2)){me.vy= 2}
		
		if((me.vx<=0)&&(me.vx>-2)){me.vx=-2}
		if((me.vy<=0)&&(me.vy>-2)){me.vy=-2}
		
		tmc=gfx.create_clip(up.topmc,null);
		me.swapDepths(tmc);
		
		upgradable=true;
	}
	
	function update_display()
	{
	var i;
	var me;
		for(i=0;i<up.mcs.length;i++)
		{
			me=up.mcs[i];
			if(me.nam=="take")
			{
				me._visible=true;
			}
		}
	}
	
	function jiggle_takes()
	{
/*
	var i;
	var me;
	
		for(i=0;i<up.mcs.length;i++)
		{
			me=up.mcs[i];
			if(me.nam=="take")
			{
				if(me.weight<=level_power[level])
				{
					me._xscale=100+Math.floor((up.rnd()/65536)*50);
					me._yscale=100+Math.floor((up.rnd()/65536)*50);
				}
			}
		}
*/
	}
	
	
	function show_glow()
	{

	var i;
	var me;
		for(i=0;i<up.mcs.length;i++)
		{
			me=up.mcs[i];
			if(me.nam=="take")
			{
			
				switch(me.state)
				{
					case "fixed":
					
						if(me.weight<=level_power[level])
						{
							gfx.glow(me , 0x00ff00, 1, 6, 6, 1, 3, false, false );
						}
						
					break;
				}
				
			}
		}

	}
	
	function update_takes()
	{
	var i;
	var me;
	
	
	
		avail=0;
		notgone=0;
		
		for(i=0;i<up.mcs.length;i++)
		{
			me=up.mcs[i];
			if(me.nam=="take")
			{
			
				switch(me.state)
				{
					case "fixed":
					
						me._visible=true;
/*						
						if(me._xscale>100)
						{
							me._xscale--;
						}
						if(me._yscale>100)
						{
							me._yscale--;
						}
*/
						notgone++;
					break;
					
					case "fall":
					
						me.vy+=me.ay;
						me._x+=me.vx;
						me._y+=me.vy;
						if(me._y>=400*3)
						{
							me.state="gone";
							me._visible=false;
						}
						
						me._rotation+=me.vx;
						
						notgone++;
					break;
					
					case "upgrade":
					
						if(me.wait>0)
						{
							me.wait--;
						}
						
						me._x+=me.vx;
						me._y+=me.vy;
// bounce					
						if(me._x>380)
						{
							me._x=380;
							if(me.vx>0)
							{
								me.vx=-me.vx;
							}
						}
						if(me._x<-380)
						{
							me._x=-380;
							if(me.vx<0)
							{
								me.vx=-me.vx;
							}
						}
						if(me._y>280)
						{
							me._y=280;
							if(me.vy>0)
							{
								me.vy=-me.vy;
							}
						}
						if(me._y<-280)
						{
							me._y=-280;
							if(me.vy<0)
							{
								me.vy=-me.vy;
							}
						}
						
						notgone++;
					break;
				}
				
				if(me.weight<=level_power[level])
				{
					avail+=me.weight;
				}			
			}
		}
	}
	

	function do_this(me,act)
	{	
		switch(me.nam)
		{
			default:
			
				if(this["do_"+me.nam])
				{
					this["do_"+me.nam](me,act);
				}
				else
				{
					do_def(me,act);
				}
				
			break;
		}
	
	}
	
	function do_def(me,act)
	{
		switch(act)
		{
			case "on":
			break;
			
			case "click":
			break;
			
			case "off":
			break;
		}
	}
	
	function do_instructions(me,act)
	{
		switch(act)
		{
			case "on":
			break;
			
			case "click":
				up.mcs["instructions"]._visible=false;
			break;
			
			case "off":
			break;
		}
	}
	
	function do_take(me,act)
	{
	var d,t;
	
	
	
		switch(act)
		{
			case "on":
				
				if(me.weight<=level_power[level])
				{
					me.useHandCursor=true;
				}
				else
				{
					me.useHandCursor=false;
				}
				
			break;
			
			case "press":
			
//				talky_display( me.nam );


				if(me.state=="fall") // juggle
				{
					_root.wetplay.PlaySFX("sfx_object",1);
					
					me.xt++;
					up.up.over.replace_floater("<font size=\"48\" color=\"#00ff00\"><b>"+(me.weight*10)*me.xt+"</b></font>",up.up.mc._xmouse , up.up.mc._ymouse-30);
					
					up.up.over.pixls.add_blip( 0xff00ff00 , up.up.mc._xmouse , up.up.mc._ymouse );
				
					up.score+=me.weight*10;
					
					launch(me);
					
#LEVEL_CLICKS=8
					switch(me.xt)
					{
						case 1*#(LEVEL_CLICKS): up.up.over.pixls.add_hardcore(); _root.wetplay.PlaySFX("sfx_rainbow",2); _root.wetplay.PlaySFX("sfx_hardcore",3); break;
						case 2*#(LEVEL_CLICKS): up.up.over.pixls.add_extreme();  _root.wetplay.PlaySFX("sfx_rainbow",2); _root.wetplay.PlaySFX("sfx_extreme",3);  break;
						case 3*#(LEVEL_CLICKS): up.up.over.pixls.add_ultimate(); _root.wetplay.PlaySFX("sfx_rainbow",2); _root.wetplay.PlaySFX("sfx_ultimate",3); break;
						case 4*#(LEVEL_CLICKS): up.up.over.pixls.add_ultimate(); _root.wetplay.PlaySFX("sfx_rainbow",2); _root.wetplay.PlaySFX("sfx_ultimate",3); break;
						case 5*#(LEVEL_CLICKS): up.up.over.pixls.add_ultimate(); _root.wetplay.PlaySFX("sfx_rainbow",2); _root.wetplay.PlaySFX("sfx_ultimate",3); break;
						case 6*#(LEVEL_CLICKS): up.up.over.pixls.add_ultimate(); _root.wetplay.PlaySFX("sfx_rainbow",2); _root.wetplay.PlaySFX("sfx_ultimate",3); break;
						case 7*#(LEVEL_CLICKS): up.up.over.pixls.add_ultimate(); _root.wetplay.PlaySFX("sfx_rainbow",2); _root.wetplay.PlaySFX("sfx_ultimate",3); break;
						case 8*#(LEVEL_CLICKS): up.up.over.pixls.add_ultimate(); _root.wetplay.PlaySFX("sfx_rainbow",2); _root.wetplay.PlaySFX("sfx_ultimate",3); break;
					}
				}
				else
				if((me.state=="upgrade")&&(me.wait==0))
				{
					_root.wetplay.PlaySFX("sfx_object",1);
					_root.wetplay.PlaySFX("sfx_rainbow",2);
					_root.wetplay.PlaySFX("sfx_levelup",3);

					me.xt+=1;
					up.up.over.replace_floater("<font size=\"48\" color=\"#00ff00\"><b>"+(me.weight*10)*me.xt+"</b></font>",up.up.mc._xmouse , up.up.mc._ymouse-30);
						
					up.up.over.pixls.add_blip( 0xff00ff00 , up.up.mc._xmouse , up.up.mc._ymouse );
					
					up.up.over.pixls.add_levelup();
					up.score+=me.weight*10;
					
					level++;
					
					launch(me);
					upgradable=false
					
					jiggle_takes();
					
					if(level_power[level]>=999) // last level, glow what is left
					{
						show_glow();
					}
				}
				else				
				if(me.state=="fixed")
				{
				
				
					if(me.weight<=level_power[level])
					{
						_root.wetplay.PlaySFX("sfx_object",1);
					
						me.xt=1;
					up.up.over.replace_floater("<font size=\"48\" color=\"#00ff00\"><b>"+(me.weight*10)*me.xt+"</b></font>",up.up.mc._xmouse , up.up.mc._ymouse-30);
						
						up.up.over.pixls.add_blip( 0xff00ff00 , up.up.mc._xmouse , up.up.mc._ymouse );
					
						up.score+=me.weight*10;
						
						weight+=me.weight;
						
						if((weight>level_need[level])&&(!upgradable))
						{
							launch_upgrade(me);
						}
						else
						{
							launch(me);
						}
					}
					else
					{
						up.up.over.pixls.add_cross( 0xffff0000 , up.up.mc._xmouse , up.up.mc._ymouse );
					}
				}
				
												
//				score_str=" w: "+weight+" <br> l: "+level+" <br> p: "+level_power[level]+" <br> a: "+avail;
				
//				_root.poker.ShowFloat(me.weight+" item <br> "+weight+" you",25*10);
				
			break;
			
			case "off":
			
//				gfx.clear_filters(me);
				
				_root.poker.ShowFloat(null,0);
				
				me.pulse=null;
			break;
			
		}
	}
	
}
