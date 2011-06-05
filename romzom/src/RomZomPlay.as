/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) Kriss Daniels 2006 http://www.XIXs.com
//
/*+-----------------------------------------------------------------------------------------------------------------+*/

#include "src/opts.as"

// A collection of stacks of cards making up the game LIES!!!!

#(
rom_names=
{
"rom0",
"rom1",
"rom1_a",
"rom1_b",
"rom1_shoe",
"rom2",
"rom2_boil",
"rom2_rad",
"rom2_belly",
"rom3",
"rom3_ceiling",
"rom3_cock",
"rom3_lock",
"rom3_loo",
"rom3_phone",
"rom3_ham",
"rom3_tub",
"rom3_bowl",
"rom3_peep",
"rom4",
"rom5",
"rom6",
"rom6_left",
"rom6_right",
"wakeup",
"end",
"hole",
}
#)



class RomZomPlay
{

	var up; // RomZom

	var mc_base;
	var mc;
	
	var state_last;
	var state;
	var state_next;
	
	var anim_name;
	var lines;	
	var flames;
	
	var wakeup_state;
	var wakeup_idx;
	var wakeup_frame;
	
	var parallax;
	
	var over; //name of what is currently under the mouse
	
	var mcs;
	
	var saves=null;
	
	
	var display;
	
	var about;
	var high;
	var code;
	
	var mc_score;
	var score;
	
	function delegate(f,d,i)	{	return com.dynamicflash.utils.Delegate.create(this,f,d,i);	}
	
// ser
	var rnd_num=0;
	function rnd_seed(n) { rnd_num=n&0xffff; }
	function rnd() // returns a number between 0 and 65535
	{
		rnd_num=(((rnd_num+1)*75)-1)%65537; // all hail the mighty zx spectrum pseudo random number sequence
		return rnd_num;
	}


	function RomZomPlay(_up,_state)
	{
	
		
		up=_up;
		
		display=new RomZomPlayDisplay(this);
		

		state_last=null;
		state=null;
		state_next=null;
		
		
		state="rom0";
		wakeup_state="blink";
		wakeup_idx=0;
		wakeup_frame=0;
		
		score=0;
		
		if(saves==null)
		{
			_root.signals.signal("romzom","start",this);
			saves_reset();
		}
		
		mc_base=gfx.create_clip(up.mc,null);
		talky_setup();

		
		about=new PlayAbout(this);
		high=new PlayHigh(this);
		code=new PlayCode(this);
	}
	
	function reset()
	{
		_root.signals.signal("romzom","end",this);
		
		state_next="rom0";
		wakeup_state="blink";
		wakeup_idx=0;
		wakeup_frame=0;
		
		saves_reset();
	}
	
	function saves_reset_temps()
	{
		saves.draw_a0		=	"shut";		// shut,open
		saves.draw_a1		=	"shut";		// shut,open
		saves.draw_a2		=	"shut";		// shut,open
		saves.draw_a3		=	"shut";		// shut,open
		
		saves.draw_b0		=	"shut";		// shut,open
		saves.draw_b1		=	"shut";		// shut,open
		saves.draw_b2		=	"shut";		// shut,open
		saves.draw_b3		=	"shut";		// shut,open
		
		saves.mirror		=	"shut";		// bathroom cab: shut,open
		
		saves.exitdoor		=	"shut";		// exitdoor: shut,open
	}
	
	function saves_reset()
	{
		saves={};
		
		score=0;
		
		saves.clicked4lfa	=	"no";		// no,yes
		
		saves.main_light	=	"on";		// main room light: on,off
		
		saves.wc_door		=	"shut";		// bathroom door: shut,open
		
		saves.cockies		=	"hide";		// jar of cockies: hide,shut,open
		saves.cockies_num0	=	"6";		// code on jar 0-9
		saves.cockies_num1	=	"6";		// code on jar 0-9
		saves.cockies_num2	=	"6";		// code on jar 0-9
		
		saves.loolight		=	"empty";	// empty,on,off
		
		saves.cushion		=	"right";	// right,left
		
		saves.rug			=	"flat";		// flat,moved
		
		saves.win1			=	"shut";		// window0: shut,open
		saves.win2			=	"shut";		// window1: shut,open
		saves.win3			=	"shut";		// window2: shut,open
		
		saves.box			=	"shut";		// loobox: shut,open
		
		saves.num023		=	"0";		// show clue, opacity...
		
		saves.pent			=	"shut";		// pent: shut,open
		
		saves.hamglass		=	"on";		// on,off
		
		saves.phoneme		=	"55318008";			// digits to display
		
// items location
		saves.screwhandle	=	"room";	// room,hand,used
		saves.bulb			=	"room";	// room,hand,used
		saves.keya			=	"room";	// room,hand,used
		saves.keyb			=	"room";	// room,hand,used
		saves.dial			=	"room";	// room,hand,used
		saves.screw1		=	"hide";	// hide,room,hand,used
		saves.screw2		=	"room";	// room,hand,used
		saves.screw3		=	"0";	// 0,1,2,room,hand,used
		saves.screw4		=	"room";	// room,hand,used
		saves.screw5		=	"room";	// room,hand,used
		saves.lookey		=	"room";	// room,hand,used
		saves.hammer		=	"room";	// room,hand,used
		saves.shoelace		=	"room";	// room,hand,used
		saves.knife			=	"room";	// room,hang,hand,used



		
		
		
// debug start state changes....

//		saves.keyb			=	"hand";	// room,hand,used
/*
		saves.lookey		=	"used";	// room,hand,used
		saves.loolight		=	"on";	// empty,on,off
*/
		
/*
		saves.screw1		=	"hand";
		saves.screw2		=	"hand";
		saves.screw3		=	"hand";
		saves.screw4		=	"hand";
		saves.screw5		=	"hand";
		saves.knife			=	"hand";
		saves.screwhandle	=	"hand";
*/
/*		
		saves.keya			=	"hand";
		saves.keyb			=	"hand";
*/

/*
		saves.screw2		=	"used";
		saves.screw3		=	"used";
		saves.screw5		=	"used";
		saves.knife			=	"used";
*/
	}

	function saves_update_display()
	{
		display.saves_update_display();
	}
	
var game_seed;
	
	function setup()
	{	
	var i;
	var line;
	var dat;
	var box;
	var nmc;
	var smc;
	var pidx;
	var pmc;
	
		if(up.state=="menu") { state="rom0"; } // force menu
	
//		dbg.print("SETUP:"+state);
		
		game_seed=up.game_seed;
		
		
		saves_reset_temps();
		
		mc=gfx.create_clip(mc_base,null);
		
		mcs=new Array();
		
		flames=new Array();
		
		parallax=new Array();
		pidx=0;
		pmc=null;
		
		switch(state)
		{
#for i,v in ipairs(rom_names) do
			case "#(v)":
				anim_name="#(v)";
				lines=#(v)_lines;
			break;
#end
		}
		
		switch(state)
		{
		
			case "rom3_loo":
			case "rom3_tub":
			case "rom3_bowl":
			case "rom3_ceiling":
				up.play_background_loop("sfx_plop");
			break;
			
			case "rom3_phone":
				if(saves.phoneme=="47912643")
				{
					up.play_background_loop("sfx_chant");
				}
				else
				{
					up.play_background_loop("sfx_notone");
				}
			break;
			
			case "rom0":
			case "rom1":
			case "rom1_a":
			case "rom1_b":
			case "rom1_shoe":
			case "rom2":
			case "rom2_boil":
			case "rom2_rad":
			case "rom2_belly":
			case "rom3":
			case "rom3_cock":
			case "rom3_lock":
			case "rom3_ham":
			case "rom3_peep":
			case "rom4":
			case "rom5":
			case "rom6":
			case "rom6_left":
			case "rom6_right":
			case "wakeup":
			case "end":
			case "hole":
				up.play_background_loop("sfx_breeze");
			break;
			
			default:
				up.play_background_loop(null);
			break;
		}
		
		for(i=1;i<lines.length;i++)
		{
			line=lines[i-1];
			dat=line.split(",");
			if(dat[1]=="") { dat[1]=null; }
			
			if( (dat[2]) || (pmc==null) ) // got a new depth
			{	
				pmc=gfx.create_clip(mc,null,400,300);
				if(dat[2])
				{
					pmc.zoom= (dat[2])/100;
				}
				else
				{
					pmc.zoom=1;
				}
				parallax[pidx++]=pmc;
			}
			
			if(dat[0].indexOf("wonderful")==0)
			{
			var adid;
			
				nmc=gfx.add_clip(pmc,anim_name,null,-400,-300);
				nmc.gotoAndStop(i);
				box=nmc.getBounds(nmc);
//					nmc.removeMovieClip();
				
				smc=gfx.create_clip(nmc,null);
			
				adid=dat[0].split("wonderful");
				adid=Number(adid[1])-1;
				
				if(up.wonderfulls[adid]) // wait for php thingy to register before we can display
				{
					smc.loadMovie(up.wonderfulls[adid].img);
				}
				
				smc._x=box.xMin;
				smc._y=box.yMin;
				
				smc._xscale=100*((box.xMax-box.xMin)/117);
				smc._yscale=100*((box.yMax-box.yMin)/30);
				
				nmc.active=false;
				
				mcs[i]=nmc;
				mcs[i].cacheAsBitmap=true;
				
				mcs[i].onRelease=delegate(click,"wonderful",adid);
				mcs[i].onRollOver=delegate(hover,"wonderful",adid);
			}
			else
			if(dat[0]=="phone_display")
			{
				nmc=gfx.add_clip(pmc,anim_name,null,-400,-300);
				nmc.gotoAndStop(i);
				box=nmc.getBounds(nmc);
//				nmc.removeMovieClip();
				
				smc=gfx.create_clip(nmc,null);				
				nmc.tf=gfx.create_text_html(smc,null,box.xMin,box.yMin,box.xMax-box.xMin,box.yMax-box.yMin);
				
				mcs[i]=nmc;
				mcs[i].cacheAsBitmap=true;
			}
			else
			{
				switch(dat[1])
				{
					case "flame" :
					
						nmc=gfx.create_clip(pmc,null,-400,-300);
					
						nmc.mc=gfx.add_clip(nmc,anim_name,null);
						nmc.mc.gotoAndStop(i);
						
						box=nmc.mc.getBounds(nmc);
						box.x=(box.xMin+box.xMax)/2;
						box.y=(box.yMin+box.yMax)/2;
				
						nmc._x=box.x-400;
						nmc._y=box.yMax-300;
						
						nmc.mc._x=-box.x;
						nmc.mc._y=-box.yMax;
					
						flames[flames.length+1]=nmc;
						
						nmc.active=false;
						mcs[i]=nmc;
						mcs[i].cacheAsBitmap=true;
					break;
					
					case "stumbleupon":
						nmc=gfx.add_clip(pmc,anim_name,null,-400,-300);
						nmc.gotoAndStop(i);
						box=nmc.getBounds(nmc);
						smc=gfx.add_clip(nmc,"icon_stumble",null);
						smc._x=box.xMin;
						smc._y=box.yMin;
						smc._xscale=100*(box.xMax-box.xMin)/16;
						smc._yscale=100*(box.yMax-box.yMin)/16;
//						nmc.active=false;
						mcs[i]=nmc;
						mcs[i].cacheAsBitmap=true;
						mcs[i].onRelease=delegate(click,"stumble",i);
						mcs[i].onRollOver=delegate(hover,"stumble",i);
						
					break;
					
					case "digg":
						nmc=gfx.add_clip(pmc,anim_name,null,-400,-300);
						nmc.gotoAndStop(i);
						box=nmc.getBounds(nmc);
						smc=gfx.add_clip(nmc,"icon_digg",null);
						smc._x=box.xMin;
						smc._y=box.yMin;
						smc._xscale=100*(box.xMax-box.xMin)/16;
						smc._yscale=100*(box.yMax-box.yMin)/16;
//						nmc.active=false;
						mcs[i]=nmc;
						mcs[i].cacheAsBitmap=true;
						mcs[i].onRelease=delegate(click,"digg",i);
						mcs[i].onRollOver=delegate(hover,"digg",i);
						
					break;
					
					case "rand4lfa":
						nmc=gfx.add_clip(pmc,anim_name,null,-400,-300);
						nmc.gotoAndStop(i);
						box=nmc.getBounds(nmc);
						
						smc=gfx.add_clip(nmc,"thumb"+((rnd()%13)+1),null);
						
//					nmc.removeMovieClip();
						
//						smc=gfx.create_clip(nmc,null);
/*
						if( _root.bmc.isloaded("icon4lfa") ) //available
						{
							smc["icon4lfa"]=_root.bmc.create( smc , "icon4lfa" ,null ); // display
						}
*/
//						smc.loadMovie("http://4lfa.com/random/jpgthumbs.php/icon.jpg");
						smc._x=box.xMin;
						smc._y=box.yMin;
						
						smc._xscale=box.xMax-box.xMin;
						smc._yscale=box.yMax-box.yMin;
						
						nmc.active=false;
						
						mcs[i]=nmc;
						mcs[i].cacheAsBitmap=true;
						
						mcs[i].onRelease=delegate(click,"4lfa",i);
						mcs[i].onRollOver=delegate(hover,"4lfa",i);
					break;
					
					default:
						mcs[i]=gfx.add_clip(pmc,anim_name,null,-400,-300);
						mcs[i].gotoAndStop(i);
						mcs[i].active=true;
						mcs[i].cacheAsBitmap=true;
						if(dat[1])
						{
							mcs[i].onRelease=delegate(click,dat[1],i);
							mcs[i].onRollOver=delegate(hover,dat[1],i);
							mcs[i].tabEnabled=false;
						}
						else
						if(dat[0])
						{
							mcs[i].onRelease=delegate(click,dat[0],i);
							mcs[i].onRollOver=delegate(hover,dat[0],i);
							mcs[i].tabEnabled=false;
						}
					break;
				}
			}			
			mcs[i].id=dat[0];
			mcs[i].flavour=dat[1];
			
			mcs[dat[0]]=mcs[i]; // swing both ways?
		}
		
		saves_update_display();
				
		Mouse.addListener(this);
		
		mc_score=gfx.create_clip(mc,null);
		mc_score.tf1=gfx.create_text_html(mc_score,null,300,0,200,75);
		gfx.glow(mc_score , 0xffffff, .8, 16, 16, 1, 3, false, false );
		
	}
	
	function clean()
	{
//		dbg.print("CLEAN:"+state);
		
		Mouse.removeListener(this);
		
//		talky_clean();
		mc.removeMovieClip(); mc=null;	
	}
	
	function onMouseDown()
	{
		if(_root.popup) return;
		
		talky_hide();
	}
	function onMouseUp()
	{
		if(_root.popup) return;
		
	var i;
	
		if(state=="rom3_phone")
		{
			for(i=0;i<=9;i++)
			{
				mcs["pad0"+i]._visible=true;
				mcs["pad1"+i]._visible=false;
			}
		}
	}
	
	function hover(nam,idx)
	{
		if(_root.popup) return;
		
		if(over!=nam)
		{
			switch(nam)
			{
				case "start_click":
					up.play_sfx("sfx_honk");
				break;
				case "code_click":
					_root.poker.ShowFloat("Get the code to place this game on your blog profile or website.",10*25);
					up.play_sfx("sfx_honk");
				break;
				case "shop_click":
					up.play_sfx("sfx_honk");
				break;
				case "start_click":
					up.play_sfx("sfx_honk");
				break;
				case "suicide_click":
					up.play_sfx("sfx_honk1");
				break;
				case "about_click":
					_root.poker.ShowFloat("Did you know this game was made by real people?",10*25);
					up.play_sfx("sfx_honk2");
				break;
				case "scores_click":
					up.play_sfx("sfx_honk3");
				break;
				case "walkthrough_click":
					up.play_sfx("sfx_honk2");
				break;
				
				case "hole":
					_root.poker.ShowFloat("That hole looks really really safe and inviting.",10*25);
				break;
				
				case "digg":
					_root.poker.ShowFloat("If you like this game, please tell your friends on Digg!",10*25);
				break;
				case "stumble":
					_root.poker.ShowFloat("If you like this game, please tell your friends on StumbleUpon!",10*25);
				break;
				
				case "quitgame":
					_root.poker.ShowFloat("You will lose all progress if you quit.",10*25);
				break;
				
				case "4lfa":
				case "wonderful":
				case "tshit":
					_root.poker.ShowFloat("Hi, I'm a popup warning popup. I've popped up to warn you that clicking here will open a popup. Thanks for reading, please enjoy your popup experience.",10*25);
				break;
				
				default:
					_root.poker.ShowFloat(null,0);
				break;
			}
		}
		over=nam;
	}

	
	function click(nam,idx)
	{
		if(_root.popup) return;
		
		if(hand_do) // no clicky during hand anim but do rush it along
		{
			if(hand_count<24)
			{
				hand_count=24;
				return;
			}
			if(hand_count<49)
			{
				hand_count=49;
				return;
			}
			if(hand_count<74)
			{
				hand_count=74;
				return;
			}
			return;
		}
	var t;
	var i;
	
//	dbg.print(nam+" : "+idx);
	
		switch(nam)
		{
			case "start_click":
				state_next="wakeup";
				up.state_next="skip";
				_root.signals.signal("romzom","start",this);
			break;
			case "walkthrough_click":
				getURL("http://www.wetgenes.com/link/RomZomWalk","_blank");
			break;
			case "shop_click":
				getURL("http://www.wetgenes.com/link/RomZom.shop","_blank");
			break;
			case "suicide_click":
				state_next="rom5";
				up.state_next="play";
				_root.signals.signal("romzom","start",this);
			break;
			case "about_click":
				about.setup();
			break;
			case "code_click":
				code.setup();
			break;
			case "scores_click":
				high.setup("rank");
			break;

			case "digg":
				getURL("http://digg.com/submit?phase=2&url=romzom.wetgenes.com&title=There+is+no+escape+from+the+clowns!&bodytext=There+is+no+escape+from+the+clowns!&topic=playable_web_games","_blank");
			break;
			case "stumble":
				getURL("http://www.stumbleupon.com/submit?url=http://romzom.wetgenes.com&title=There+is+no+escape+from+the+clowns!","_blank");
			break;
							
			
			case "rom3_lock_nob":
					talky_display("It will not budge, really, you will have to think outside of the boxroom.");
					up.play_sfx("sfx_clink");
			break;
			
			case "rom3_lock_left":
				if( (saves.screwhandle=="hand") && ( saves.screw1=="hand" ) && ( saves.screw4=="hand" ) )
				{
					talky_display("I don't think circles are unscrewable...");
//					hand_setup("use","screwhandle");
				}
				else
				{
					talky_display("If you had the circle and star screw heads and tool, you might be able to remove this.");
				}
			break;
			
			case "rom3_lock_right":
				if( (saves.screwhandle=="hand") && ( saves.screw2=="hand" ) && ( saves.screw3=="hand" ) && ( saves.screw5=="hand" ) && ( saves.knife=="hand" ) )
				{
//					hand_setup("use","knife",null,"rom3_lock_right");
				}
				else
				{
					talky_display("If you had the square, pentagon, triangle and flat screw heads and tool, you might be able to remove this.");
				}
			break;
			
			case "pad0":
				if(saves.phoneme=="47912643")
				{
					talky_display("The phone seems to be one use only.");
				}
				else
				{
					if(saves.phoneme.length==8)
					{
						saves.phoneme="";
					}
					saves.phoneme+=(""+idx);
					saves_update_display();
					mcs["pad0"+idx]._visible=false;
					mcs["pad1"+idx]._visible=true;
					
					
					switch(idx)
					{
						case 0:
						case 1:
							up.play_sfx("sfx_tone");
						break;
						case 2:
						case 3:
							up.play_sfx("sfx_tone1");
						break;
						case 4:
						case 5:
							up.play_sfx("sfx_tone2");
						break;
						case 6:
						case 7:
							up.play_sfx("sfx_tone3");
						break;
						case 8:
						case 9:
							up.play_sfx("sfx_tone4");
						break;
					}
					
					if(saves.phoneme=="47912643") // start chant
					{
						up.play_background_loop("sfx_chant");
						score+=10000;
					}
				}
			break;
						
			case "hole":
				state_next="hole";
			break;
			
			case "quitgame":
				reset();
			break;
			
			case "leftarrow":
				switch(state)
				{
					case "rom1":
						state_next="rom2";
					break;
					case "rom3":
						state_next="rom1";
					break;
					case "rom3_loo":
						state_next="rom3_bowl";
					break;
					case "rom3_tub":
						state_next="rom3_loo";
					break;
					case "rom6":
						state_next="rom6_left";
					break;
					case "rom6_left":
						state_next="rom5";
					break;
					case "rom6_right":
						state_next="rom6";
					break;
					case "wakeup":
						state_next="rom1";
					break;
				}
			break;
			
			case "rightarrow":
				switch(state)
				{
					case "rom1":
						state_next="rom3";
					break;
					case "rom2":
						state_next="rom1";
					break;
					case "rom3_loo":
						state_next="rom3_tub";
					break;
					case "rom3_bowl":
						state_next="rom3_loo";
					break;
					case "rom6":
						state_next="rom6_right";
					break;
					case "rom6_left":
						state_next="rom6";
					break;
					case "rom6_right":
						state_next="rom5";
					break;
				}
			break;
			
			case "uparrow":
				switch(state)
				{
					case "rom3_loo":
						state_next="rom3_ceiling";
					break;
				}
			break;
			
			case "backarrow":
				switch(state)
				{
					case "rom1_a":
					case "rom1_b":
					case "rom1_shoe":
						state_next="rom1";
					break;
					
					case "rom2_boil":
					case "rom2_rad":
					case "rom2_belly":
					case "hole":
						state_next="rom2";
					break;
					
					case "rom3_cock":
					case "rom3_lock":
					case "rom3_phone":
					case "rom3_loo":
					case "rom3_ham":
					case "rom3_peep":
						state_next="rom3";
					break;
					case "rom3_ceiling":
						state_next="rom3_loo";
					break;
				}
			break;
			
			case "rom3_cock":
			case "rom3_cock2":
				state_next="rom3_cock";
			break;
			
			case "rom3_peep":
				state_next="rom3_peep";
				up.play_sfx("sfx_screw");
			break;
			
			case "rom3_lock":
				state_next="rom3_lock";
			break;
			
			case "rom3_phone":
				state_next="rom3_phone";
			break;
			
			case "rom3_ham":
			case "rom3_hambroke":
				state_next="rom3_ham";
			break;
			
			case "rom3_loo":
			case "loodark":
				state_next="rom3_loo";
			break;
			
			case "rom5": // exit door
				if(saves.hammer=="hand")
				{
					state_next="rom6"; // hurrah for update :)
				}
				else
				{
					talky_display("I'm not going anywhere without the hammer, it might not be safe out there.");
				}
			break;
			
			case "door":
				if(saves.lookey=="used")
				{
					if(saves.cockies=="hide") // magically apear
					{
						saves.cockies="shut";
					}
					saves.wc_door="open";
					saves_update_display();
					
					up.play_sfx("sfx_door");
				}
				else
				if(saves.lookey=="hand")
				{
					hand_setup("use","lookey");
				}
				else
				{
					talky_display("It rattles just like a locked door would.");
				}
			break;
			
			case "door_click":
				saves.wc_door="closed";
				saves_update_display();
				up.play_sfx("sfx_door");
			break;
			
			
			case "switch":
				saves.main_light="off";
				saves_update_display();
				
				up.play_sfx("sfx_click");
							
//				talky_display("Light goes off.");
			break;
			
			case "string":
				if(saves.loolight=="off")
				{
					saves.loolight="on";
					saves_update_display();
					up.play_sfx("sfx_click");
				}
				else
				if(saves.loolight=="on")
				{
					saves.loolight="off";
					saves_update_display();
					up.play_sfx("sfx_click");
				}
			break;
			
			case "switch_click":
			case "switch_click2":
				switch(state)
				{
					case "rom3":
						saves.main_light="on";
						saves_update_display();
						up.play_sfx("sfx_click");
						
//						talky_display("Light goes on.");
					break;
					
					case "rom3_tub":
					case "rom3_bowl":
					case "rom3_loo":
						if(saves.loolight=="off")
						{
							saves.loolight="on";
							saves_update_display();
							up.play_sfx("sfx_click");
						}
						else
						{
							up.play_sfx("sfx_click");
							talky_display("Dark in here, isn't it?");
						}
					break;
				}
			break;
			
			case "rom1_a":
				state_next="rom1_a";
			break;
			case "rom1_b":
				state_next="rom1_b";
			break;
			case "rom1_shoe":
				talky_display("This is as close as I'm going to get to them.");
				state_next="rom1_shoe";
			break;
			case "rom1_shoe_unlace":
				state_next="rom1_shoe";
			break;
			
			case "cushion":
				saves.cushion="left";
				saves_update_display();
				
//				talky_display("Fi fi fo fum, I smell a key that's been under a bum.");
			break;
/*			
			case "cushion_click":
				saves.cushion="right";
				saves_update_display();
			break;
*/			
			case "num00":
			case "num01":
			case "num02":
			case "num03":
			case "num04":
			case "num05":
			case "num06":
			case "num07":
			case "num08":
			case "num09":
				up.play_sfx("sfx_num");
				t=Number(saves.cockies_num0)+1;
				if(t>=10) { t=0; }
				saves.cockies_num0=""+t;
				saves_update_display();
			break;
			
			case "num10":
			case "num11":
			case "num12":
			case "num13":
			case "num14":
			case "num15":
			case "num16":
			case "num17":
			case "num18":
			case "num19":
				up.play_sfx("sfx_num");
				t=Number(saves.cockies_num1)+1;
				if(t>=10) { t=0; }
				saves.cockies_num1=""+t;
				saves_update_display();
			break;
			
			case "num20":
			case "num21":
			case "num22":
			case "num23":
			case "num24":
			case "num25":
			case "num26":
			case "num27":
			case "num28":
			case "num29":
				up.play_sfx("sfx_num");
				t=Number(saves.cockies_num2)+1;
				if(t>=10) { t=0; }
				saves.cockies_num2=""+t;
				saves_update_display();
			break;
			
			case "bulb":
				hand_setup("get","bulb");
			break;

			case "hammer":
				hand_setup("get","hammer");
				
				talky_display("Oooh a hammer, I'm sure that will come in handy.");
			break;
			
			case "screwhandle":
				hand_setup("get","screwhandle");
				
				talky_display("I think I can combine this with something.");
			break;
			
			case "socket":
				if(saves.loolight=="empty")
				{
					if(saves.bulb=="hand")
					{
						hand_setup("use","bulb","bulb_click2");
					}
				}
			break;
			
			case "exitdoor":
				if(mcs["rom3_lock"]._visible==false)
				{
					talky_display("Freedom!");
					saves.exitdoor="open";
					saves_update_display();
					up.play_sfx("sfx_door");
				}
			break;
			case "rom5_door":
				saves.exitdoor="shut";
				saves_update_display();
				up.play_sfx("sfx_door");
			break;
			
			case "mirror":
				saves.mirror="open";
				saves_update_display();
				up.play_sfx("sfx_door");
			break;
			case "mirror_click":
				saves.mirror="shut";
				saves_update_display();
				up.play_sfx("sfx_door");
			break;
			
			case "keya":
				hand_setup("get","keya");
				
//				talky_display("Wheee a key");
			break;
			
			case "keyb":
				hand_setup("get","keyb");
				
//				talky_display("Wheee a key");
			break;
			
			case "rug":
				saves.rug="moved";
				saves_update_display();
			break
			
			case "dial":
				hand_setup("get","dial");
				
				talky_display("Why would someone hide a dial under a rug?");
			break;
			
			case "rom2_boil":
				state_next="rom2_boil";
			break;
			
			case "rom2_rad":
				state_next="rom2_rad";
			break;
			
			case "tshit":
				getURL("http://4lfa.com/tshit/","_blank");
			break;
			
			case "4lfa":
				getURL("http://4lfa.com","_blank");
				if(saves.clicked4lfa=="no")
				{
					saves.clicked4lfa="yes";
					score+=1000;
				}
			break;
			
			case "wonderful":
				if(up.wonderfulls[idx]) // wait for php thingy to register before we can go anywhere
				{
					getURL(up.wonderfulls[idx].url,"_blank");
				}
			break;
			
			case "window01":
				saves.win1="open";
				saves_update_display();
				up.play_sfx("sfx_down");
			break			
			case "window11":
				saves.win1="shut";
				saves_update_display();
				up.play_sfx("sfx_up");
			break

			case "window02":
				saves.win2="open";
				saves_update_display();
				up.play_sfx("sfx_down");
			break			
			case "window12":
				saves.win2="shut";
				saves_update_display();
				up.play_sfx("sfx_up");
			break

			case "window03":
				saves.win3="open";
				saves_update_display();
				up.play_sfx("sfx_down");
			break			
			case "window13":
				saves.win3="shut";
				saves_update_display();
				up.play_sfx("sfx_up");
			break
			
			case "rom2_pent":
				saves.pent="open";
				saves_update_display();
				up.play_sfx("sfx_rip");
			break
			
			case "rom2_pentclick":
				state_next="rom2_belly";
				up.play_sfx("sfx_blow");
			break
			
			case "screw1":
				hand_setup("get","screw1");
			break;
			case "screw2":
				hand_setup("get","screw2");
			break;
			case "screw3":
				hand_setup("get","screw3");
			break;
			case "screw4":
				hand_setup("get","screw4");
			break;
			case "screw5":
				hand_setup("get","screw5");
			break;
			
			case "shoelace":
				hand_setup("get","shoelace");
			break;
			
			case "screw1_sock":
				if(saves.screwhandle=="hand")
				{
					if(saves.screw1=="hand")
					{
						hand_setup("use","screw1");
					}
				}
				else
				{
					if(saves.screw1=="hand")
					{
						talky_display("I need a handle to do that.");
					}
				}
			break;
			case "screw2_sock":
				if(saves.screwhandle=="hand")
				{
					if(saves.screw2=="hand")
					{
						hand_setup("use","screw2");
					}
				}
				else
				{
					if(saves.screw2=="hand")
					{
						talky_display("I need a handle to do that.");
					}
				}
			break;
			case "screw3_sock":
				if(saves.screwhandle=="hand")
				{
					if(saves.screw3=="hand")
					{
						hand_setup("use","screw3");
					}
				}
				else
				{
					if(saves.screw3=="hand")
					{
						talky_display("I need a handle to do that.");
					}
				}
			break;
			case "screw4_sock":
				if(saves.screwhandle=="hand")
				{
					if(saves.screw4=="hand")
					{
						hand_setup("use","screw4");
					}
				}
				else
				{
					if(saves.screw4=="hand")
					{
						talky_display("I need a handle to do that.");
					}
				}
			break;
			case "screw5_sock":
				if(saves.screwhandle=="hand")
				{
					if(saves.screw5=="hand")
					{
						hand_setup("use","screw5");
					}
				}
				else
				{
					if(saves.screw5=="hand")
					{
						talky_display("I need a handle to do that.");
					}
				}
			break;
			case "decoy_sock":
//			dbg.print(saves.knife);
				if(saves.knife=="hand")
				{
					hand_setup("use","knife");
				}
			break;
			
			case "dial_dont":
				if(saves.dial=="hand")
				{				
					hand_setup("use","dial","dial_done");
					talky_display("The heating is now on");
					up.play_sfx("sfx_ecto");
				}
				else
				{
					talky_display("The dial is missing.");
				}
			break;
			
#for i=0,3 do
			case "drawer_a#(i)_shut":
				if(saves.keya=="hand")
				{
					hand_setup("use","keya");
				}
				else
				if(saves.keya=="used")
				{
					saves.draw_a#(i)="open";
					saves_update_display();
					up.play_sfx("sfx_door");
				}
				else
				{
					talky_display("I suspect the keyhole may be a clue.");
				}
			break;
			case "drawer_a#(i)_open":
				if(saves.keya=="used")
				{
					saves.draw_a#(i)="shut";
					
					if("#(i)"==saves.screw3)
					{
						saves.screw3="#(i+1)";
						talky_display("I think something just fell down the back.");
						up.play_sfx("sfx_key");
					}
					if(saves.screw3=="3") { saves.screw3="room"; }
					
					saves_update_display();
					up.play_sfx("sfx_door");
				}
			break;
			
			case "drawer_b#(i)_shut":
				if(saves.keyb=="hand")
				{
					hand_setup("use","keyb");
				}
				else
				if(saves.keyb=="used")
				{
					saves.draw_b#(i)="open";
					saves_update_display();
					up.play_sfx("sfx_door");
				}
				else
				{
					talky_display("If only I had some sort of keyhole filling device.");
				}
			break;
			case "drawer_b#(i)_open":
				if(saves.keyb=="used")
				{
					saves.draw_b#(i)="shut";
					saves_update_display();
					up.play_sfx("sfx_door");
				}
			break;
#end
			
			case "glass":			
				saves.hamglass="off";
				saves_update_display();
				
				for(i=0;i<=9;i++)
				{
				var tm=mcs["glass_click"+i];
					tm._visible=true;
					tm.vx= 8*(((rnd()%512)-256)/256);
					tm.vy= -8*((rnd()%512)/256);
					tm.vrotation= 2*(((rnd()%512)-256)/256);
				}
				
				up.play_sfx("sfx_glass");
			break;
			
			case "lookey":
				hand_setup("get","lookey");
			break;
			
			
			case "knife_stuck":
				if(saves.shoelace=="hand")
				{
					hand_setup("use","shoelace","knife");
				}
				else
				{
					talky_display("Can't quite reach...");
				}
			break;
			
			case "knife":
				if(saves.shoelace=="used")
				{
					hand_setup("get","knife");
				}
			break;
			
			case "box":
				saves.box="open";
				saves_update_display();
				up.play_sfx("sfx_door");
			break
			
			case "box_click":
				saves.box="shut";
				saves_update_display();
				up.play_sfx("sfx_door");
			break
			
			case "ring":
				if(saves.screw1=="hide")
				{
					up.play_sfx("sfx_drop");
					saves.screw1="room";
					mcs["screw1"]._visible=true;
				}
			break
		}
		
	}

	function update()
	{
		if(_root.popup) return;
	
		_root.signals.signal("romzom","update",this);
		
		if(state_next!=null)
		{
			if(state) { clean(); }
			
			state_last=state;	// change master state
			state=state_next;
			state_next=null;
			
			if(state) { setup(); }
		}
		
	var pmc;
	
		if((score>0))//&&(pickups.length>0))
		{
			if	(
					(state!="end")
					&&
					(state!="rom5")
				)
			{
				score--;
			}
		}
		gfx.set_text_html(mc_score.tf1,18,0xffffff,"<p align=\"center\"><b>"+score+"</b></p>");
		
		if	(
				(state=="wakeup")
				||
				(state=="rom0")
			)
		{
			mc_score._visible=false;
		}
		else
		{
			mc_score._visible=true;
		}
		

		
		if(state=="rom5") // all spesh stuffs
		{
			if(wakeup_state!="done_rom5")
			{
				wakeup_idx=0;
				wakeup_state="done_rom5"
			}
			switch(wakeup_idx)
			{
				case 0:
					talky_display("!!!");
					wakeup_idx++;
					up.play_sfx("sfx_boo");
				break;
				case 2:
					state_next="end";
					wakeup_state="reset";
				break;
				
				default:
					if(talky_state=="hiden") wakeup_idx++;
				break;

			}
			talky_update();
			return;
		}
		else
		if(state=="end") // all spesh stuffs
		{
			pmc=parallax[0];
			
			if(wakeup_state!="done_end")
			{
				wakeup_idx=0;
				wakeup_state="done_end"
			}
			switch(wakeup_idx)
			{
				case 0:
					mcs["background"]._visible=false;
					mcs["cum"]._visible=false;
					mcs["cum"]._alpha=0;
					mcs["blood"]._visible=false;
//					mcs["blood"]._alpha=75;
					mcs["black"]._visible=true;					
					talky_display("...");
					wakeup_idx++;
				break;
				case 2:
					talky_display("Mmmmph");
					wakeup_idx++;
				break;
				case 4:
					mcs["background"]._visible=true;
					mcs["black"]._visible=false;					
					pmc.zoom=20;
					talky_display("Mmmmph Mmmmph");
					wakeup_idx++;
				break;
				case 6:
					pmc.zoom=10;
					talky_display("Mmmmph Mmmmph Mmmmph");
					wakeup_idx++;
				break;
				case 8:
					pmc.zoom=5;
					talky_display("Mmmmmmmmmph");
					wakeup_idx++;
				break;
				case 10:
					pmc.zoom=2.5;
					talky_display("Mmmgh Mmmmph Mmmmgh");
					wakeup_idx++;
				break;
				case 12:
					pmc.zoom=1.75;
					talky_display("Mmmmmmmmmmmmmmmmmgh");
					wakeup_idx++;
				break;
				case 14:
					pmc.zoom=1;
					talky_display("Mmmmmmgh Mmmmmmph");
					wakeup_idx++;
				break;
				case 16:
					pmc.zoom=1;
					wakeup_idx+=2;
					mcs["blood"]._visible=true;
					mcs["blood"]._y-=600;
					up.play_sfx("sfx_blood");
					score+=10000;
				break;
				case 18:
					pmc.zoom=1;
					mcs["blood"]._y+=10;
					if(mcs["blood"]._y>=280)
					{
						wakeup_idx+=2;
					}
				break;
				case 20:
					mcs["cum"]._visible=true;
					mcs["cum"]._alpha+=2;
					if(mcs["cum"]._alpha>=80)
					{
						wakeup_idx+=2;
					}
				break;
				case 22:
					reset();
				break;
				
				default:
					if(talky_state=="hiden") wakeup_idx++;
				break;

			}
			
			pmc._xscale=pmc.zoom*100;
			pmc._yscale=pmc._xscale;
			pmc._x=400+(-400*(pmc.zoom-1)*-0.14);
			pmc._y=300+(-300*(pmc.zoom-1)*-0.25);
		
			talky_update();
			return;
		}
		else
		if(state=="wakeup") // all spesh stuffs
		{
		
			pmc=parallax[0];
			
			switch(wakeup_state)
			{
				case "blink":
				switch(wakeup_idx)
				{
					case 0:
						mcs["leftarrow"]._visible=false;
						talky_display("...");
						pmc.zoom=7;
						wakeup_idx++;
					break;
					case 2:
						mcs["leftarrow"]._visible=false;
						talky_display("My head hurts.");
						pmc.zoom=6;
						wakeup_idx++;
					break;
					case 4:
						talky_display("Something smells icky.");
						pmc.zoom=5;
						wakeup_idx++;
					break;
					case 6:
						talky_display("Where was I last night?");
						pmc.zoom=4;
						wakeup_idx++;
					break;
					case 8:
						talky_display("I remember clowns and OMFG!");
						pmc.zoom=3;
						wakeup_idx++;
					break;
					case 10:
						talky_display("Who is that?");
						pmc.zoom=2.5;
						wakeup_idx++;
					break;
					case 12:
						talky_display("They don't look so good.");
						pmc.zoom=2.25;
						wakeup_idx++;
					break;
					case 14:
						talky_display("I hope they are just sleeping.");
						pmc.zoom=2.0;
						wakeup_idx++;
					break;
					case 16:
						talky_display("They don't seem to be breathing.");
						pmc.zoom=1.75;
						wakeup_idx++;
					break;
					case 18:
						talky_display("Did I do that?");
						pmc.zoom=1.5;
						wakeup_idx++;
					break;
					case 20:
						talky_display("I really need to just get the hell out of here.");
						pmc.zoom=1.25;
						wakeup_idx++;
					break;
					case 22:
						mcs["leftarrow"]._visible=true;
						pmc.zoom=1.0;
						wakeup_idx++;
					break;
					
					default:
						if(talky_state=="hiden") wakeup_idx++;
					break;

				}
				break;
			}
			
			pmc._xscale=pmc.zoom*100;
			pmc._yscale=pmc._xscale;
			pmc._x=400+(-400*(pmc.zoom-1)*0.75);
			pmc._y=300+(-300*(pmc.zoom-1)*0.75);
		
			talky_update();
			return;
		}
		
	var i;
	var f;
	var dx,dy,dd;
	
	var mx,my;
	
	
		mx=mc._xmouse;
		my=mc._ymouse;
		mx=(mx-400)/400;
		my=(my-300)/300;
		if(mx<-1) mx=-1;
		if(mx> 1) mx= 1;
		if(my<-1) my=-1;
		if(my> 1) my= 1;
			
		for(i=0;i<parallax.length;i++)
		{
			pmc=parallax[i];
			
			pmc._xscale=pmc.zoom*100;
			pmc._yscale=pmc._xscale;
			
			pmc._x=400+(-400*(pmc.zoom-1)*mx);
			pmc._y=300+(-300*(pmc.zoom-1)*my);
		}
		
		for(i=0;i<flames.length;i++)
		{
			f=flames[i];
			
			f._alpha=25+(rnd()%75);
			f._yscale=75+(rnd()%50);
			f._rotation-=f._rotation/16;
			
			dx=mc._xmouse-f._x;
			dy=mc._ymouse-f._y;
			dd=(dx*dx)+(dy*dy);
			if(dd<(32*32))
			{
				dx=_root.poker.dx;
//				dx/=2;
				if(dx> 45) { dx= 45; }
				if(dx<-45) { dx=-45; }
				f._rotation=dx;
			}
			if(dd<(16*16))
			{
				if(_root.poker.poke_down)
				{
					f._visible=f._visible?false:true;
				}
			}
		}
		
		mcs["num023"	]._alpha=saves.num023/40;
		
		if(saves.dial=="used")
		{
			if(saves.num023<4000)
			{
				saves.num023=""+(Number(saves.num023)+1);
			}
		}
		
		if(state=="rom0")
		{
		var aa=["start_click","walkthrough_click","suicide_click","about_click","scores_click","shop_click","code_click"]
		var over_it=false;
		
			for(i=0;i<aa.length;i++)
			{
				if(over==aa[i]) { over_it=true; }
				
				mcs[ aa[i] ]._alpha-=5;
				if(mcs[ aa[i] ]._alpha<=0) { mcs[ aa[i] ]._alpha=0; }
			}
			
			if(over_it)
			{
				mcs[ over ]._alpha=100;
			}
		
		}
		else
		if(state=="rom3_loo")
		{
			if(mcs["screw1"]._visible==true) // do screw drop, you can catch it :)
			{
				mcs["screw1"]._y+=20;
				if(mcs["screw1"]._y>600)
				{
					mcs["screw1"]._visible=false;
				}
			}
		}
		else
		if(state=="rom3_ham")
		{
			for(i=0;i<=9;i++)
			{
			var tm=mcs["glass_click"+i];
			
				if(tm._visible==true)
				{
					tm.vy+=2;
					tm._x+=tm.vx;
					tm._y+=tm.vy;
					tm._rotation+=tm.vrotation;
				}
			}
		}
		else
		if(state=="rom3_tub")
		{
			mcs["bubble0"]._alpha=100;
			
//			if(mcs[	"bubble0"	]._alpha>=0) { mcs[	"bubble0"	]._alpha-=10; }
			if(mcs[	"bubble1"	]._alpha>=0) { mcs[	"bubble1"	]._alpha-=2; }
			if(mcs[	"bubble2"	]._alpha>=0) { mcs[	"bubble2"	]._alpha-=2; }
			if(mcs[	"bubble3"	]._alpha>=0) { mcs[	"bubble3"	]._alpha-=2; }

			if((rnd()%32)==0)
			{
				var r=rnd()%3;
				mcs[	"bubble"+(r+1)	]._alpha=100;
			}
		}
		
		hand_update();
		talky_update();
	}

	function do_str(str)
	{
		switch(str)
		{
			default:
				up.do_str(str)
			break;
		}
	}
	
var hand_do=false;

var hand_mc;
var hand_mc_base;
var hand_mc_item;
var hand_mc_item2;

var hand_count;
var hand_item_name;
var hand_fadein;
var hand_fadeout;


	function hand_setup(item_do,item_name,fadein,fadeout)
	{
	var i;
	var line;
	var dat;
	var item_name2="nothingtouse";
	
		hand_item_name=item_name;
		hand_fadein=fadein;
		hand_fadeout=fadeout;
	
		hand_mc=gfx.create_clip(mc,null);
		hand_mc._y=600;
		
		if(item_do=="use")
		{
			switch(hand_item_name)
			{
				case "screw1":
				case "screw2":
				case "screw3":
				case "screw4":
				case "screw5":
					item_name2="screwhandle";
				break;
			}
		}

		for(i=1;i<rom4_lines.length;i++)
		{
			line=rom4_lines[i-1];
			dat=line.split(",");
			
			if(dat[0]=="background") //back
			{
					hand_mc_base=gfx.add_clip(hand_mc,"rom4",null);
					hand_mc_base.gotoAndStop(i);
					hand_mc_base.cacheAsBitmap=true;
			}
			else
			if(dat[0]==item_name)
			{
					hand_mc_item=gfx.add_clip(hand_mc,"rom4",null);
					hand_mc_item.gotoAndStop(i);
					hand_mc_item.cacheAsBitmap=true;
			}
			else
			if(dat[0]==item_name2)
			{
					hand_mc_item2=gfx.add_clip(hand_mc,"rom4",null);
					hand_mc_item2.gotoAndStop(i);
					hand_mc_item2.cacheAsBitmap=true;
			}
		}
		
			
		hand_count=0;
		hand_do=item_do;
		
		if(hand_do=="get")
		{
			hand_mc_item._alpha=0;
		}
		else
		if(hand_do=="use")
		{
			hand_mc_item._alpha=100;
			hand_mc_item2._alpha=100;
		}
	}
	
	function hand_update()
	{
		if(!hand_do) return;
		
		hand_count+=1*_root.gofaster;
		
		
		if(hand_count<=25)
		{
			hand_mc._y=600-((hand_count-0)/25)*500;
		}
		else
		if(hand_count<=50)
		{
			if(hand_do=="get")
			{
				hand_mc_item._alpha=((hand_count-25)/25)*100;
				mcs[hand_item_name]._alpha=((50-hand_count)/25)*100;
				
				if(hand_count==26)
				{
					up.play_sfx("sfx_dropecho");
					score+=1000;
					
					if((state=="rom3")&&(hand_item_name=="hammer")) // get hammer from afar bonus
					{
						score+=1000;
					}
				}
			}
			else
			if(hand_do=="use")
			{
				hand_mc_item._alpha=((50-hand_count)/25)*100;
				hand_mc_item2._alpha=((50-hand_count)/25)*100;
			}
			if(hand_fadein)
			{
				mcs[hand_fadein]._alpha=((hand_count-25)/25)*100;
				mcs[hand_fadein]._visible=true;
			}
			if(hand_fadeout)
			{
				mcs[hand_fadeout]._alpha=((50-hand_count)/25)*100;
				mcs[hand_fadeout]._visible=true;
			}
		}
		else
		if(hand_count<=75)
		{
			if(hand_fadein)
			{
				mcs[hand_fadein]._alpha=100;
				mcs[hand_fadein]._visible=true;
			}
			if(hand_fadeout)
			{
				mcs[hand_fadeout]._visible=false;
				mcs["rom3_lock_nob"]._visible=false; // cheap trick :) moslt this wont exist so will do nothing.
			}
			hand_mc._y=600-((75-hand_count)/25)*500;
		}
		else
		if(hand_count>75)
		{
			hand_clean()
		}
	}
	
	function hand_clean()
	{
	var hand_done=hand_do;
	
		hand_mc_base.removeMovieClip();
		hand_mc_item.removeMovieClip();
		hand_mc_item2.removeMovieClip();
		hand_mc.removeMovieClip();
		
		hand_do=false;
		
		
		if(hand_done=="get")
		{
			saves[hand_item_name]="hand";
			saves_update_display();
		}
		else
		if(hand_done=="use")
		{
			switch(hand_item_name)
			{
				case "bulb":
					saves[hand_item_name]="used";
					saves.loolight="off";
					saves_update_display();
					score+=1000;
				break;
				case "dial":
					saves[hand_item_name]="used";
					saves_update_display();
					score+=1000;
				break;
				case "lookey":
					saves[hand_item_name]="used";
					saves_update_display();
					click("door",-1);
					score+=1000;
				break;
				case "keya":
					saves[hand_item_name]="used";
					saves_update_display();
					score+=1000;
				break;
				case "keyb":
					saves[hand_item_name]="used";
					saves_update_display();
					score+=1000;
				break;
				case "shoelace":
					saves[hand_item_name]="used";
					saves_update_display();
					score+=1000;
				break;
				case "knife":
					talky_display("I knew that knife would come in handy.");
					saves[hand_item_name]="used";
					saves_update_display();
					score+=1000;
				break;
				case "screw1":
					talky_display("This doesn't seem to be working.");
//					saves[hand_item_name]="used";
//					saves_update_display();
				break;
				case "screw2":
					saves[hand_item_name]="used";
					saves_update_display();
					score+=1000;
				break;
				case "screw3":
					saves[hand_item_name]="used";
					saves_update_display();
					score+=1000;
				break;
				case "screw4":
					saves[hand_item_name]="used";
					saves_update_display();
					score+=1000;
				break;
				case "screw5":
					saves[hand_item_name]="used";
					saves_update_display();
					score+=1000;
				break;

			}
		}
	}
	
var talky_mc;
var talky_tf;
var talky_state;
	
	function talky_setup()
	{
		talky_mc=gfx.create_clip(up.mc,null,400,200);
//		talky_mc.onRelease=delegate(click,"talky",-1);
		
		talky_tf=gfx.create_text_html(talky_mc,null,-250,-150,500,300);
		
		talky_hiden();
	}
	
	function talky_hiden()
	{
		talky_mc._xscale=0;
		talky_mc._yscale=0;
		talky_state="hiden";
		talky_mc._visible=false;
	}
	
	function talky_display(str)
	{
		talky_mc._visible=true;
		talky_mc._xscale=0;
		talky_mc._yscale=0;
		talky_state="show";
		
		gfx.set_text_html(talky_tf,32,0x000000,"<b>"+str+"</b>");
		
		gfx.clear(talky_mc);
		talky_mc.style.out=0xc0ffffff;
		talky_mc.style.fill=0xc0ffffff;
		talky_tf._x=-(talky_tf.textWidth/2);
		talky_tf._y=-(talky_tf.textHeight/2);
		talky_mc.topy=50-((talky_tf._y-16)*1);
		talky_mc.midy=50-((talky_tf._y-16)*2);
		talky_mc.boty=50-((talky_tf._y-16)*3);
		talky_mc._y=talky_mc.topy;
		gfx.draw_rounded_rectangle(talky_mc,16,16,0,-(talky_tf.textWidth/2)-24,-(talky_tf.textHeight/2)-16,(talky_tf.textWidth)+48,(talky_tf.textHeight)+32+8);
	}
	
	function talky_update()
	{
		if(talky_state=="show")
		{
			talky_mc._xscale+=20;
			talky_mc._yscale+=20;
			
			if(talky_mc._xscale>=100)
			{
				talky_mc._xscale=100;
				talky_mc._yscale=100;
				talky_state="shown";
			}
		}
		else
		if(talky_state=="hide")
		{
			talky_mc._xscale-=20;
			talky_mc._yscale-=20;
			
			if(talky_mc._xscale<=0)
			{
				talky_hiden();
			}
		}
	
		if(mc._ymouse>talky_mc.midy)
		{
			talky_mc._y=talky_mc.topy;
		}
		else
		{
			talky_mc._y=talky_mc.boty;
		}
		
	}
	
	function talky_hide()
	{
		if(talky_state!="hiden")
		{
			talky_state="hide";
		}
	}
		
	function talky_clean()
	{
		talky_mc.removeMovieClip();
	}
	
	
	
#for i,v in ipairs(rom_names) do
	static var #(v)_lines=[
#for line in io.lines("art/"..v..".txt") do 
#line=line:gsub("^%s*(.-)%s*$", "%1")
	"#(line)",
#end
	""
	];	
#end

}
