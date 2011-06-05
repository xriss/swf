/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) Kriss Daniels 2007 http://www.XIXs.com
//
/*+-----------------------------------------------------------------------------------------------------------------+*/

#include "src/opts.as"

import com.wetgenes.gfx;
import com.wetgenes.dbg;

class WetHarvestPlay
{
	var up;
	
	var mc;
	
	var frame;
	var score;
	
	function WetHarvestPlay(_up)
	{
	}
	
	function delegate(f,d)	{	return com.dynamicflash.utils.Delegate.create(this,f,d);	}

	var rnd_num:Number=0;
	function rnd_seed(n:Number) { rnd_num=n&65535; rndg_num=n&65535; }
	function rnd() // returns a number between 0 and 65535
	{
		rnd_num=(((rnd_num+1)*75)-1)%65537; // all hail the mighty zx spectrum pseudo random number sequence
		return rnd_num;
	}

	var rndg_num:Number=0;
	function rndg_seed(n:Number) { rndg_num=n&65535; }
	function rndg() // returns a number between 0 and 65535
	{
		rndg_num=(((rndg_num+1)*75)-1)%65537; // all hail the mighty zx spectrum pseudo random number sequence
		return rndg_num;
	}


	
	

	function setup()
	{
		rnd_seed(up.game_seed);
		
		frame=0;
		score=0;
		mc=gfx.create_clip(up.mc,null);
	}
	
	function clean()
	{
		mc.removeMovieClip();
	}
	
	function update()
	{
	
		frame++;
		
		_root.replay.apply_keys_to_prekey();		
		_root.replay.update();
	}

}