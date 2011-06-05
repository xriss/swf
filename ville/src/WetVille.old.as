/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) Kriss Daniels 2007 http://www.XIXs.com
//
/*+-----------------------------------------------------------------------------------------------------------------+*/

#include "src/opts.as"


import com.wetgenes.gfx;
import com.wetgenes.dbg;


class WetVille
{
	var state_last;
	var state;
	var state_next;

	var	setup_done;

	var mc;

	var play;
	
	var game_seed;
	
	function delegate(f,d)	{	return com.dynamicflash.utils.Delegate.create(this,f,d);	}

	static function main()
	{
		var orset_root=function(a,b)
		{
			if(_root[a]==undefined) { _root[a]=b; }
		}
		orset_root("host","swf.wetgenes.com");
		
		
		_root.gotoAndStop(1); // frame 1 is preload, frame 2 is everything loaded
		
		_root.cacheAsBitmap=false;		
		_root.newdepth=1;
		
		_root.replay=new Replay();
		
		_root.scalar=new Scalar(800,600);
		_root.poker=new Poker(false);
		
		_root.links=new WetVille();		
	}



	function WetVille()
	{
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

		play=new WetVillePlay(this);
		
		state_next="play";
	}	

	function update()
	{		
		_root.scalar.apply(mc);
		
		if( (!setup_done) && (_root.getBytesLoaded()==_root.getBytesTotal()) )
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
			
			if(state) { this[state].setup(); }
		}
		if(state) { this[state].update(); }
	}
	
	function clean()
	{
	}

}
