/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) Kriss Daniels 2006 http://www.XIXs.com
//
/*+-----------------------------------------------------------------------------------------------------------------+*/


class Replay
{
	static var VERSION	:Number	=	4;
	
	static var STATE_NONE	:Number	=	0;
	static var STATE_RECORD	:Number	=	1;
	static var STATE_PLAY	:Number	=	2;


	static var CODE_VERSION			:Number	=	0;	//+2
	static var CODE_TIME_64			:Number	=	1;	//+1
	static var CODE_TIME_4096		:Number	=	2;	//+2
	static var CODE_KEY				:Number	=	3;	//+1
	static var CODE_MOUSE_XY_4096	:Number	=	4;	//+4

	var code_data_sizes:Array=[2,1,2,1,4];

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


	var state:Number;

// Key data

	var key:Number;		// bit keys state, code 0 is the mouse button rest are user defined
	var key_on:Number;	// bit keys on this frame, code 0 is the mouse button rest are user defined
	var key_off:Number;	// bit keys off this frame, code 0 is the mouse button rest are user defined

	var mouse_x:Number; // current mouse x pos
	var mouse_y:Number; // current mouse y pos


// prekey, story keypresses here on recieving of msgs so we can control when to actually update the real state

	var prekey:Array;	// key on/off : 0-31 key on , 32-63 key off
	var prekey_idx:Number;
	var premouse_x:Number;
	var premouse_y:Number;


// record into this

	var dat:Array;	// replay data, expanded into an array for easy writing, one event str per idx
	var dat_idx:Number;
	var dat_idx_chunk:Number; // counter to record in small string chunks

// play from this

	var str:String;	// replay data as a string
	var str_idx:Number;	// where we currently are
	
	var play_mouse_x_old:Number;
	var play_mouse_y_old:Number;
	var play_mouse_f_old:Number;

// blend between these two numbers, precise mouse position is only guaranteed on sampled frames

	var play_mouse_x_new:Number;
	var play_mouse_y_new:Number;
	var play_mouse_f_new:Number;

	var frame_recorded:Number;	// the last frame we recorded
	var frame:Number;			// current frame to recored or play

	var frame_wait:Number;		// the frame to wait till before looking at the replay stream again

	function Replay()
	{
		setup();
	}

	function setup()
	{
		
		prekey= new Array(64);
		
		dat= new Array(1024);
		
		str="";
		
		state=STATE_NONE;

		reset();
	}
	
	function reset()
	{
		key=0;
		key_on=0;
		key_off=0;

		prekey_idx=0;

		dat[0]=Clown.tostr(CODE_VERSION,1)+Clown.tostr(VERSION,2);
		dat_idx=0;
		dat_idx_chunk=64;

		str_idx=0;
		
		frame=0;
		frame_recorded=0;
		frame_wait=0;
		
		premouse_x=0;
		premouse_y=0;
		
		mouse_x=0;
		mouse_y=0;

		play_mouse_x_old=0;
		play_mouse_y_old=0;
		play_mouse_f_old=0;
		
		play_mouse_x_new=0;
		play_mouse_y_new=0;
		play_mouse_f_new=0;

	}


// make sure we are at the current time when recording
	function record_time()
	{
		var t:Number;
		var s:String;
		
		t=frame-frame_recorded;
		
		while(t>0)	// do we need to step forward
		{
			if(t<=64) // small step
			{
				dat[dat_idx]+=Clown.tostr(CODE_TIME_64,1) + Clown.tostr(t-1,1);
				if(--dat_idx_chunk<0) { dat_idx_chunk=64; dat[++dat_idx]=''; }
				t=0;
			}
			else
			if(t<=4096) // large step
			{
				dat[dat_idx]+=Clown.tostr(CODE_TIME_4096,1) + Clown.tostr(t-1,2);
				if(--dat_idx_chunk<0) { dat_idx_chunk=64; dat[++dat_idx]=''; }
				t=0;
			}
			else // part of a very very large step
			{
				dat[dat_idx]+=Clown.tostr(CODE_TIME_4096,1) + Clown.tostr(4096-1,2);
				if(--dat_idx_chunk<0) { dat_idx_chunk=64; dat[++dat_idx]=''; }
				t-=4096;
			}
		}
		
		frame_recorded=frame;	// step recorded frame forward
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
		
		if(state==STATE_RECORD)
		{
			for(i=0;i<prekey_idx;i++)
			{
				k=prekey[i];
				if(k>=32)
				{
					record_key_off(k-32);
				}
				else
				{
					record_key_on(k);
				}
			}
		}
		else
		if(state==STATE_NONE) // if state is none we just abstract keys without recording or playing
		{
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
	function record_key_on(k:Number)
	{
		var m=1<<k;
		if((key&m)==0) // ignore if already on
		{
			play_key_on(k);
			record_time();
			dat[dat_idx]+=Clown.tostr(CODE_KEY,1) + Clown.tostr(k,1);
			if(--dat_idx_chunk<0) { dat_idx_chunk=64; dat[++dat_idx]=''; }
		}
	}
	
	function play_key_off(k:Number)
	{
		var m=1<<k;
		key&=~m;
		key_on&=~m;
		key_off|=m;
	}
	function record_key_off(k:Number)
	{
		var m=1<<k;
		if((key&m)==m) // ignore if already off
		{
			play_key_off(k);
			record_time();
			dat[dat_idx]+=Clown.tostr(CODE_KEY,1) + Clown.tostr(32+k,1);
			if(--dat_idx_chunk<0) { dat_idx_chunk=64; dat[++dat_idx]=''; }
		}
	}

// call when the current mouse position must be what it is right now, precisly.
// Any other time the playback will just tween
	function record_mouse()
	{
		if(state==STATE_RECORD)
		{
			if(play_mouse_f_old!=frame) // only once per frame
			{
				record_time();
				dat[dat_idx]+=Clown.tostr(CODE_MOUSE_XY_4096,1) + Clown.tostr(mouse_x+2048,2) + Clown.tostr(mouse_y+2048,2);
				if(--dat_idx_chunk<0) { dat_idx_chunk=64; dat[++dat_idx]=''; }
			
				play_mouse_x_old=mouse_x;
				play_mouse_y_old=mouse_y;
				play_mouse_f_old=frame;
			}
		}
	}

	function start_play(_str:String)
	{
		str=_str;
		trace("start_play");
		trace("replay str_length:"+str.length);
		trace("replay str:"+str);
		reset();
		state=STATE_PLAY;
	}
	function end_play()
	{
		trace("end_play");
		state=STATE_NONE;
	}

	function start_record()
	{
		trace("start_record");
		reset();
		find_next_mouse_pos();
		state=STATE_RECORD;
	}
	function end_record()
	{
		trace("end_record");
		state=STATE_NONE;
		str=dat_tostr();
		trace(str);
	}

// call at start of frame, if you are recording then add any keychanges via record_key_on/off imediatly afterwards
// use the prekey/premouse system to setup changes to happen on update

// then you can just check the keybits in regardless as to play or record modes
	function update()
	{
		key_on=0;
		key_off=0;
		
		if(state==STATE_PLAY)
		{
			frame++;
			prekey_update();
			play_update();
		}
		else
		if(state==STATE_RECORD)
		{
			frame++;
			mouse_x=Math.floor(premouse_x);
			mouse_y=Math.floor(premouse_y);
			prekey_update();
		}
		else
		if(state==STATE_NONE)
		{
			mouse_x=Math.floor(premouse_x);
			mouse_y=Math.floor(premouse_y);
			prekey_update();
		}
		
	}

// turn the recorded table into a string
	function dat_tostr()
	{

// not sure on the performance issues but I think building a table then doing a join is the safest
// since it stops a very long str being appended to repeatedly. But maybe this is bad, we will see.

		var i:Number;
		var s:String;

		s='';
		for(i=0;i<=dat_idx;i++)
		{
			s+=dat[i];
		}
		
		return s;
	}


// check the input stream, step forward to the current frame pushing any key press' into the state
	function play_update()
	{
		var c:Number;
		var k:Number;
		
		if( typeof(str)!='string' )
		{
			return; //sanity
		}
		
		while(frame_wait<=frame) // we have finished waiting
		{
			if(str_idx>str.length) return;	// sanity
			
			c=Clown.tonum(str,str_idx++,1);
			
			switch(c)
			{
				case CODE_VERSION:
					if( Clown.tonum(str,str_idx,2) != VERSION)
					{
						str_idx-=1; // step back as this stream is bad
						frame_wait+=64;
					}
					else
					{
						str_idx+=2;
					}
				break;
				
				case CODE_TIME_64:
					frame_wait+=Clown.tonum(str,str_idx++,1)+1;
				break;
				
				case CODE_TIME_4096:
					frame_wait+=Clown.tonum(str,str_idx,2)+1;
					str_idx+=2;
				break;
				
				case CODE_KEY:
					k=Clown.tonum(str,str_idx++,1);
					
					if(k>=32)
					{
						play_key_off(k-32);
					}
					else
					{
						play_key_on(k);
					}
					
				break;
				
				case CODE_MOUSE_XY_4096:
				
					play_mouse_x_old=Clown.tonum(str,str_idx,2)-2048;str_idx+=2;
					play_mouse_y_old=Clown.tonum(str,str_idx,2)-2048;str_idx+=2;
					play_mouse_f_old=frame;
					
					find_next_mouse_pos();
					
//					trace( "old=" + play_mouse_f_old + " : " + play_mouse_x_old + " , " + play_mouse_y_old )
//					trace( "new=" + play_mouse_f_new + " : " + play_mouse_x_new + " , " + play_mouse_y_new )
					
				break;
			}
		}
		
// tween mouse position

		if(play_mouse_f_old<=frame) && (play_mouse_f_new>frame)
		{
			var f;

			f=frame-play_mouse_f_old;
			f=f/(play_mouse_f_new-play_mouse_f_old);
			
			mouse_x=play_mouse_x_old + ((play_mouse_x_new-play_mouse_x_old)*f);
			mouse_y=play_mouse_y_old + ((play_mouse_y_new-play_mouse_y_old)*f);
		}
		else // just use new
		{
			mouse_x=play_mouse_x_new;
			mouse_y=play_mouse_y_new;
		}
	}

// scan ahead in the string and find the next mouse pos
	function find_next_mouse_pos()
	{
		var c:Number;
		var k:Number;
		var f:Number;
		var i:Number;
		
		play_mouse_x_new=play_mouse_x_old;
		play_mouse_y_new=play_mouse_y_old;
		play_mouse_f_new=play_mouse_f_old;
		
		i=str_idx;
		f=frame;
		
		while(play_mouse_f_new==play_mouse_f_old) // changes when we have found what we want
		{
			if(i>str.length) return;	// sanity
			
			c=Clown.tonum(str,i++,1);
			
			switch(c)
			{
				case CODE_TIME_64:
					f+=Clown.tonum(str,i++,1)+1;
				break;
				
				case CODE_TIME_4096:
					f+=Clown.tonum(str,i,2)+1;i+=2;
				break;
				
				case CODE_MOUSE_XY_4096:
					play_mouse_x_new=Clown.tonum(str,i,2)-2048;i+=2;
					play_mouse_y_new=Clown.tonum(str,i,2)-2048;i+=2;
					play_mouse_f_new=f;
					return;
				break;
				
				default:
					i+=code_data_sizes[c];
				break;
			}
		}
	}

	function clean()
	{
	}

}