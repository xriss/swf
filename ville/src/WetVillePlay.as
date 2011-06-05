/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) Kriss Daniels 2007 http://www.XIXs.com
//
/*+-----------------------------------------------------------------------------------------------------------------+*/

#include "src/opts.as"

class WetVillePlay
{
	var up;
	
	var mc;
	
	var comms;
	
	var room;

	var state;
	
	var pixls;
	
	function WetVillePlay(_up)
	{
		up=_up;
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
	var m;
	var vt;
	
		state="none";
		
		mc=gfx.create_clip(up.mc,null);
		_root.replay.reset();

		comms=new Vcomms(this);
		
		room=new Vroom(this);
		
		comms.setup();
		

//		room.setup("http://data.wetgenes.com/game/s/ville/test/room/bog_small.xml");

//		pixls=new OverPixls(up); pixls.setup(); // effect layer
		
	}
	
	function clean()
	{
//		pixls.clean();
		
		room.clean();
		
		comms.clean();
		
		mc.removeMovieClip();
	}

	function loadcheck()
	{
		if(comms.state!="ready")
		{
			comms.setup();
			return "connecting";
		}
		
		if(state=="connecting")
		{
			comms.vmsgsend({vcmd:"setup"});
			return "ready";
		}
		
		return "ready";
	}
	
	
	function update()
	{
	var i;
	
		_root.bmc.check_loading();
	
		if(_root.urlmap.state!="ready")
		{
			_root.urlmap.loadcheck();
			_root.poker.ShowFloat(_root.urlmap.state,10);
			return;
		}
//		return;
		
		if(state!="ready")
		{
			state=loadcheck();
			_root.poker.ShowFloat(state,10);
			return;
		}
		
		if(comms.state=="loading")
		{
			if(comms.check_loading())
			{
				_root.poker.ShowFloat(comms.loading,10);
			}
		}
	
		_root.replay.apply_keys_to_prekey();		
		_root.replay.update();
		
//		pixls.update();
		room.update();
		
	}
}