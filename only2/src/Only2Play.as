/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) Kriss Daniels 2007 http://www.XIXs.com
//
/*+-----------------------------------------------------------------------------------------------------------------+*/

#include "src/opts.as"



class  Only2Play
{
	var up;
	
	var vars;
	var dat;
	var run;
	
	var mc;
	
	var next_room; // used to setup the next level only
	var next_door;
	
	var next_trigger;
	var next_convo;
	
	var room;
	var door;
	
	var score;
	
	function  Only2Play(_up)
	{
		up=_up;
		reset();
	}
	
	function reset()
	{
		score=0;
		
		next_room=0;
		next_door=0x10;
		
		dat=new Only2_dat(this);
		dat.setup();
		vars=dat.vars;
		
		vars["room_"+5]=dat.get_item("lock");

// debug		
		next_room=6;
		vars["room_do_unlock"]=true;
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
		
		mc=gfx.create_clip(up.mc,null);
		

		run=new RunPlay(this);
		run.setup(next_room,next_door);
		
		room=next_room;
		door=next_door;
		
		if(room==5)
		{
			dat.sfx("tards");
			run.player.fizix=run.player["fizix_slow"];
		}
		else
		if(room==1)
		{
			dat.sfx("rain");
			run.player.fizix=run.player["fizix_base"];
		}
		else
		{
			dat.sfx_stop(4);
			run.player.fizix=run.player["fizix_base"];
		}
		
		if(next_trigger)
		{
			trigger(next_trigger,1/16,next_convo);
			next_trigger=null;
		}
	}
	
	function change_room(_room,_door)
	{
	var i,v;
	var amount=0;
	var value=0;
	
		_root.sfx("loading");
		
		if(_room==1) // going to treasure room
		{
			if(room!=1) // taking an item to the treasure room
			{
				var hold=run.player.hold;
				if(hold.d.name!="nothing") // ignore when holding nothing
				{
				
					hold.vars.score=hold.d.getscore(hold);
					if	(
							(!vars["room_"+room].score)
							||
							( (hold.vars.score>0) && ( hold.vars.score > vars["room_"+room].score ) ) // show best item
						)
					{
						vars["room_"+room]=run.player.hold.vars;
						
						if(hold.vars.name=="light")
						{
							if(hold.vars.score==10500)
							{
_root.signals.submit_award("radish_full");
							}
						}
						else
						if(hold.vars.name=="sashimi")
						{
							if(hold.d.time_start)
							{
								if(hold.vars.score<8500)
								{
_root.signals.submit_award("sashimi");
								}
								else
								{
_root.signals.submit_award("sashimi_fresh");
								}
							}
						}
						
						
_root.sock.chat("/me has scrumped "+hold.d.html+" Worth "+hold.vars.score+"pts.");

						next_trigger=0x23;
						next_convo="scrump1";

						for(i=0;i<5;i++)
						{
							if(i!=1)
							{
								v=vars["room_"+i]
								if(v)
								{
									if(v.name!="nothing")
									{
										amount++;
										value+=v.score;
									}
								}
							}
						}
						
						score=value; // remember score
						
						if(amount>=4)
						{
							var unlock=dat.get_item("unlock");
							if( vars["room_"+5]!=unlock )
							{
//								vars["room_"+5]=unlock;
								vars["room_do_unlock"]=true; // triger some particles and animation
							}


							if(value>10000+1000+6000+100)
							{
								amount=8;
							}
							else
							if(value>1000+1000+6000+100)
							{
								amount=7;
							}
							else
							if(value>1000+1000+100+100)
							{
								amount=6;
							}
							else
							if(value>1000+100+100+100)
							{
								amount=5;
							}
						}
						if(amount<1)
						{
							amount=1;
						}
						

						next_convo="scrump"+amount;


					}
				}
			}
		}
	
		up.state_next="play"; // restart ourselves
		next_room=_room;
		next_door=_door;
			
//		run.player.mc._visible=false;
		_root.swish.clean();
		_root.swish=(new Swish({style:"fade",mc:mc,w:640,h:480})).setup();
	}
	
	function clean()
	{
		
		run.clean();
		mc.removeMovieClip();
	}

	function update()
	{
//		if(_root.popup) { return; }
		
		run.update();
	}
	
	var do_trigger;
	var do_slack;
	var do_convo;
	function trigger(_id,_slack,_convo)
	{
//dbg.print(_id);
		do_trigger=_id;
		do_slack=_slack;
		do_convo=_convo;
	}
}



