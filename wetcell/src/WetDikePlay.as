/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) Kriss Daniels 2006 http://www.XIXs.com
//
/*+-----------------------------------------------------------------------------------------------------------------+*/

#include "src/opts.as"


// A collection of stacks of cards making up the game

class WetDikePlay
{
	var table;
	var menu;

	var popup_won;
	
	var pack_code;
	
	var start_time;	// in ms
	
	var game_time;	// in ms
	
	var last_time;
	
	var mc:MovieClip;
	
	var state;

	var up;
	
	var seed;
	var next_seed;
	
	var PackSeed:Number=null;
	
	var exit_after_scores;
	
	function delegate(f,d)		{	return com.dynamicflash.utils.Delegate.create(this,f,d);		}
	
	
	function WetDikePlay(_up)
	{
		
		up=_up;
		mc=gfx.create_clip(up.mc,null);
//		mc.cacheAsBitmap=true;
				
		PackSeed=null;
		// pull in settings
		if(_root.PackSeed)		{	PackSeed=_root.PackSeed;	}
		


		{
		var cm;
		var cmi;
		var f;
					
			cm = new ContextMenu();
			cm.hideBuiltInItems();
/*

if(_root.lardguns!=null) // if playing for lardguns
{
			f=function()
			{
				if(!_root.popup)
				{
					_root.wetcell.state_next="play";
				}
			};
			cmi = new ContextMenuItem("Submit score and Restart", delegate(f,null) );
			cm.customItems.push(cmi);
}
else
{
			f=function()
			{
				if(!_root.popup)
				{
					this.final_scores(null);
//					_root.wetcell.state_next=wetcell.STATE_PLAY;
				}
			};
			cmi = new ContextMenuItem("Give up and play the same pack again.", delegate(f,null) );
			cm.customItems.push(cmi);
			
			f=function()
			{
				if(!_root.popup)
				{
				var date=new Date();
					this.final_scores(Math.floor(((date.getTime()/1000))/(24*60*60))&0xffff);
//					_root.wetcell.game_seed=Math.floor(((date.getTime()/1000))/(24*60*60))&0xffff;
//					_root.wetcell.state_next=wetcell.STATE_PLAY;
				}
			};
			cmi = new ContextMenuItem("Give up and play todays pack.", delegate(f,null) );
			cm.customItems.push(cmi);

			f=function()
			{
				if(!_root.popup)
				{
					this.final_scores((_root.wetcell.game_seed+1)&0xffff);
//					_root.wetcell.game_seed=(_root.wetcell.game_seed+1)&0xffff;
//					_root.wetcell.state_next=wetcell.STATE_PLAY;
				}
			};
			cmi = new ContextMenuItem("Give up and play the next pack.", delegate(f,null) );
			cm.customItems.push(cmi);
			
			f=function()
			{
				if(!_root.popup)
				{
					this.final_scores((_root.wetcell.game_seed-1)&0xffff);
//					_root.wetcell.game_seed=(_root.wetcell.game_seed-1)&0xffff;
//					_root.wetcell.state_next=wetcell.STATE_PLAY;
				}
			};
			cmi = new ContextMenuItem("Give up and play the previous pack.", delegate(f,null) );
			cm.customItems.push(cmi);
			
			f=function()
			{
				if(!_root.popup)
				{
					this.final_scores(Math.floor(Math.random()*65536)&0xffff);
//					_root.wetcell.game_seed=Math.floor(Math.random()*65536)&0xffff;
//					_root.wetcell.state_next=wetcell.STATE_PLAY;
				}
			};
			cmi = new ContextMenuItem("Give up and play a random pack.", delegate(f,null) );
			cm.customItems.push(cmi);
}

			f=function()
			{
				if(!_root.popup)
				{
					this.show_scores();
				}
			};
			cmi = new ContextMenuItem("View high scores.", delegate(f,null) );
			cm.customItems.push(cmi);
*/
/*
			f=function()
			{
				if(!_root.popup)
				{
					_root.wetcell.dikestats.setup();
				}
			};
			cmi = new ContextMenuItem("View stats.", f );
			cm.customItems.push(cmi);
			
			f=function()
			{
				if(!_root.popup)
				{
					_root.wetcell.dikeabout.setup();
				}
			};
			cmi = new ContextMenuItem("View about.", f );
			cm.customItems.push(cmi);
*/
			
/*
			f=function()
			{
				if( Stage["displayState"] == "normal" )
				{
					Stage["displayState"] = "fullScreen";
				}
				else
				{
					Stage["displayState"] = "normal";
				}
			};
			cmi = new ContextMenuItem("Toggle fullscreen mode.", f );
			cm.customItems.push(cmi);
*/
/*
			f=function()
			{
				_root.audit=_root.audit?false:true;
			};
			cmi = new ContextMenuItem("Toggle audit mode.", delegate(f,null) );
			cm.customItems.push(cmi);
*/			
			cm=MainStatic.get_base_context_menu(up,cm);
			
			_root.menu=cm;
		}
		


		table=new WetTable(this);
		menu=new WetDikeMenu(this);
		popup_won=new WetDikeWon(this);
	}
	
// ser
	var rnd_num:Number=0;
	function rnd_seed(n:Number) { rnd_num=n&65535; }
	function rnd() // returns a number between 0 and 65535
	{
		rnd_num=(((rnd_num+1)*75)-1)%65537; // all hail the mighty zx spectrum pseudo random number sequence
		return rnd_num;
	}


	function setup(_seed)
	{	
//dbg.print("dikeplay setup");

//		rnd_num=(1123);
//		rnd_seed(Math.floor(Math.random()*65536)&0xffff);

		state="play";
		mc.dy=0;
		mc.dx=0;
		
//		if(PackSeed==null)
//		{
			seed=up.game_seed;
			rnd_seed(seed);
//		}
//		else
//		{
//			seed=PackSeed;
//			rnd_seed(seed);
//		}
		next_seed=seed;
		
//		dbg.print(seed); //13366


		_root.signals.signal("wetcell","set",this);


		table.setup();
		menu.setup();
		
//		up.dikescores.setup();
		
		var date=new Date();
		start_time=date.getTime();
		game_time=0;
		
		last_time=date.getTime();
		
// build comms defaults
		up.dikecomms.thunk();
		menu.thunk();

		exit_after_scores=false;		
		
		_root.signals.signal("wetcell","start",this);
	}
	
	function clean()
	{
		_root.signals.signal("wetcell","end",this);
		
		up.dikecomms.send_score();
		menu.clean();
//		up.dikescores.clean();
		table.clean();
	}
	
	function final_scores(_next_seed)
	{
		if(_next_seed)
		{
			next_seed=_next_seed
		}
		show_scores();
		exit_after_scores=true;
	}

	function show_scores()
	{
		_root.signals.signal("wetcell","high",this);
		up.high.setup();
	}
	
	function update()
	{
		var date=new Date();
		var diff;

		
/*
		if(display_scores==0)
		{
			if((_root.popup==null)&&(_root.Login_Done))
			{
				if(table.playback==null)
				{
					up.dikescores.setup();
					display_scores=-1;
				}
				else
				{
					display_scores=-1;
				}
			}
		}
		else
		if(display_scores>0)
		{
			display_scores--;
		}
*/

		
		// clamp max 1 sec per update for recording game time
		
		diff=date.getTime()-last_time;
		if(diff>1000) { diff=1000; }
		if(diff<0) { diff=0; }
		game_time+=diff;		
		last_time=date.getTime();
		
	
		mc._y+=(mc.dy-mc._y)/4;
		if(Math.abs(mc.dy-mc._y)<2)
		{
			mc._y=mc.dy;
		}

		mc._x+=(mc.dx-mc._x)/4;
		if(Math.abs(mc.dx-mc._x)<2)
		{
			mc._x=mc.dx;
		}
		
		menu.update();
			
//		if((up.dikescores.state==WetDikeScores.STATE_NONE) && (state=="play") && (!_root.popup))
		{
			up.replay.update();
			table.update();
		}
		
		table.update_status();

		
//		up.dikescores.update();
		up.dikecomms.update();
		
		_root.signals.signal("wetcell","update",this);
		
		if(exit_after_scores)
		{
			if(_root.popup==null)
			{
				_root.wetcell.game_seed=next_seed;
				_root.wetcell.state_next="play";
			}
		}
		
		if(up.next_game_seed)
		{
			_root.wetcell.game_seed=_root.wetcell.next_game_seed;
			_root.wetcell.state_next="play";
			_root.wetcell.next_game_seed=null;
		}
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
	
}
