/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) Kriss Daniels 2007 http://www.XIXs.com
//
/*+-----------------------------------------------------------------------------------------------------------------+*/

#include "src/opts.as"


import com.wetgenes.gfx;
import com.wetgenes.dbg;


class WetHarvest
{
	var state_last;
	var state;
	var state_next;

	var	setup_done;

	var mc;

//	var choose;
	var play;
//	var title;
	
	var game_seed;
	
//	var levels;
//	var tards;
	
//	var level_idx=1;
//	var tard_idx=1;
	
	var old_time;
	var update_time;
	
//	var skill="easy";
	
	function delegate(f,d)	{	return com.dynamicflash.utils.Delegate.create(this,f,d);	}

	static function main()
	{
		var orset_root=function(a,b)
		{
			if(_root[a]==undefined) { _root[a]=b; }
		}
		orset_root("host","swf.wetgenes.com");
		
		_root.wethidemochiads=true;
		
		_root.gotoAndStop(1); // frame 1 is preload, frame 2 is everything loaded
		
		_root.cacheAsBitmap=false;
		_root.newdepth=1;
		
		_root.mc_popup=gfx.create_clip(_root,16383);
		_root.popup=null;	// put a popup class in here to halt normal operation
		
		_root.bmc=new bmcache();
		
		_root.replay=new Replay();
		
		_root.scalar=new Scalar(800,600);
		_root.poker=new Poker(false);
		_root.loading=new Loading(false);
		
		_root.harvest=new WetHarvest();
		
		_root.wtf=new WTF();
	}



	function WetHarvest()
	{
	var t;
	var tt;
	var lev;
	
		setup_done=false;
		
		mc=gfx.create_clip(_root,null);
		mc.onEnterFrame=delegate(update);
		mc.scrollRect=new flash.geom.Rectangle(0, 0, _root.scalar.ox, _root.scalar.oy);
	}
	
	function setup()
	{
	var date=new Date();
	
		game_seed=Math.floor(((date.getTime()/1000))/(24*60*60))&0xffff;
		
		state_last=null;
		state=null;
		state_next=null;

//		title=new WetBaseMentTitle(this);
//		choose=new WetBaseMentChoose(this);
		play=new WetHarvestPlay(this);
		
		
		state_next="play";
//		state_next="title";
	}	

	function update()
	{		
		var d=new Date();
		var new_time=d.getTime();
		
		_root.scalar.apply(mc);
		
		if( (!setup_done) && (_root.getBytesLoaded()==_root.getBytesTotal()) && (_root.loading.done) && (!_root.wetplay.first_time))
//		if( (!setup_done) && (_root.getBytesLoaded()==_root.getBytesTotal()) )
		{
			_root.gotoAndStop(2); // frame 1 is preload, frame 2 is everything loaded
			setup();
			setup_done=true;
		}
		
		if(!setup_done)	{ return; }	
		
		if(state_next!=null)
		{
			if(state) { this[state].clean(); }
			
			state_last=state;	// change master state
			state=state_next;
			state_next=null;
			
			if(state)
			{
				this[state].setup();
			}
			
			old_time=new_time;
			update_time=0;
		}
		if(state)
		{
			update_time=Math.floor(update_time*3/4);
			update_time+=new_time-old_time;
//			if(update_time>=80) { dbg.print(update_time); }
			if(update_time>200) { update_time=200; }
			while(update_time>=40)
			{
				this[state].update();
				
				update_time-=40;
			}
			
			old_time=new_time;
		}
	}
	
	function clean()
	{
	}

}
