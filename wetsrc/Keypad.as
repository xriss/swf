/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) http://www.WetGenes.com/ 2009
//
/*+-----------------------------------------------------------------------------------------------------------------+*/


class Keypad
{
// key ids

	static var KEY_MBUTTON		:Number	=	0;
	static var KEY_FIRE			:Number	=	1;
	static var KEY_UP			:Number	=	2;
	static var KEY_DOWN			:Number	=	3;
	static var KEY_LEFT			:Number	=	4;
	static var KEY_RIGHT		:Number	=	5;
	static var KEY_MAX			:Number	=	6;

// key masks

	static var KEYM_MBUTTON		:Number	=	1;
	static var KEYM_FIRE		:Number	=	2;
	static var KEYM_UP			:Number	=	4;
	static var KEYM_DOWN		:Number	=	8;
	static var KEYM_LEFT		:Number	=	16;
	static var KEYM_RIGHT		:Number	=	32;
	static var KEYM_MAX			:Number	=	64;


// Key data

	var key:Number;		// bit keys state, code 0 is the mouse button rest are user defined
	var key_on:Number;	// bit keys on this frame, code 0 is the mouse button rest are user defined
	var key_off:Number;	// bit keys off this frame, code 0 is the mouse button rest are user defined


// prekey, story keypresses here on recieving of msgs so we can control when to actually update the real state

	var prekey:Array;	// key on/off : 0-31 key on , 32-63 key off
	var prekey_idx:Number;
	var premouse_x:Number;
	var premouse_y:Number;
	

	function Keypad()
	{
		setup();
	}

	function setup()
	{
		
		prekey= new Array(64);
		
		reset();
		
		Key.addListener(this);
		Mouse.addListener(this);
	}
	
	function reset()
	{
		key=0;
		key_on=0;
		key_off=0;

		prekey_idx=0;
		
	}


// pre keys are key changes that should effect the next frame advance, ignore until then.

	function prekey_on(k:Number)
	{
//		trace("prekeyon "+k);
		prekey[prekey_idx++]=k;
	}
	function prekey_off(k:Number)
	{
//		trace("prekeyoff "+k);
		prekey[prekey_idx++]=32+k;
	}
	function prekey_update() // send prekey presses into real keys, or ignore them if we are recording
	{
		var i:Number;
		var k:Number;
		
		for(i=0;i<prekey_idx;i++)
		{
			k=prekey[i];
			if(k>=32)
			{
				play_key_off(k-32);
			}
			else
			{
				play_key_on(k);
			}
		}
		
		prekey_idx=0;
	}


	function play_key_on(k:Number)
	{
		var m=1<<k;	
		key|=m;
		key_on|=m;
		key_off&=~m;
	}
	
	function play_key_off(k:Number)
	{
		var m=1<<k;
		key&=~m;
		key_on&=~m;
		key_off|=m;
	}
	

// call at start of frame, if you are recording then add any keychanges via record_key_on/off imediatly afterwards
// use the prekey/premouse system to setup changes to happen on update

// then you can just check the keybits in regardless as to play or record modes
	function update()
	{
		key_on=0;
		key_off=0;
		
		prekey_update();
		
	}


	function clean()
	{
		Key.removeListener(this);
		Mouse.removeListener(this);
	}
	
	function onKeyDown()
	{
		apply_keys_to_prekey();
	}
	
	function onKeyUp()
	{
		apply_keys_to_prekey();
	}
	
	function onMouseDown()
	{
		prekey_on(KEY_MBUTTON);
	}
	
	function onMouseUp()
	{
		prekey_off(KEY_MBUTTON);
	}
	
	function apply_keys_to_prekey()
	{
		if(Key.isDown(Key.SPACE))
		{
			prekey_on(KEY_FIRE);
		}
		else
		{
			prekey_off(KEY_FIRE);
		}
		
		if(Key.isDown(Key.UP))
		{
			prekey_on(KEY_UP);
		}
		else
		{
			prekey_off(KEY_UP);
		}
		
		if(Key.isDown(Key.DOWN))
		{
			prekey_on(KEY_DOWN);
		}
		else
		{
			prekey_off(KEY_DOWN);
		}
		
		if(Key.isDown(Key.LEFT))
		{
			prekey_on(KEY_LEFT);
		}
		else
		{
			prekey_off(KEY_LEFT);
		}
		
		if(Key.isDown(Key.RIGHT))
		{
			prekey_on(KEY_RIGHT);
		}
		else
		{
			prekey_off(KEY_RIGHT);
		}
	}

}