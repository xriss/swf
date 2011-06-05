/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) Kriss Daniels 2006 http://www.XIXs.com
//
/*+-----------------------------------------------------------------------------------------------------------------+*/

#include "src/opts.as"

// A collection of stacks of cards making up the game LIES!!!!


class #(VERSION_NAME)Play
{

	var up; // RomZom

	var mc;
	
	var pixls;

	var gd;
	
	var score=0;
	
	function delegate(f,d,i)	{	return com.dynamicflash.utils.Delegate.create(this,f,d,i);	}
	

	function #(VERSION_NAME)Play(_up)
	{
		up=_up;		

	}
			

	function setup()
	{	
	var i;
	var j;
	
		score=0;
			
		mc=gfx.create_clip(up.mc,null);
		
		if(up.lobby.gamedata) // is this a request to play a multiplayer game?
		{
			
			gd=up.lobby.gamedata;
//			up.lobby.gamedata=null;
			
			up.game_seed=0;//Math.floor(gd.styles.seed);
			
//dbg.print("multi "+gd.gamename);

		}
		else
		{
			gd=null;
		}
		
		pixls=new PlayPixls(this);
		
		pixls.setup();
	}
	
	function clean()
	{
		pixls.clean();
		
		mc.removeMovieClip(); mc=null;	
	}
	
	

	function update()
	{
	var i;
	
		if(_root.popup) return;
	
		_root.signals.signal("#(VERSION_NAME)","update",this);
		
		pixls.update();
		
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
