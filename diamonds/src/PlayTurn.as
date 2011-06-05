/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) Kriss Daniels 2006 http://www.XIXs.com
//
/*+-----------------------------------------------------------------------------------------------------------------+*/

#include "src/opts.as"


// lets handle some scores

class PlayTurn
{
	var up;
	
	var mc;
	
	var mcs;
	
	var done;
	var steady;
	

	function delegate(f,d)	{	return com.dynamicflash.utils.Delegate.create(this,f,d);	}

	function PlayTurn(_up)
	{
		up=_up;
	}
	
	function setup()
	{
	var i;
	var bounds;
	var mct;
	var s;
	var m;
		
		_root.popup=this;
		
		mcs=new Array();
			
		mc=gfx.create_clip(_root.mc_popup,null);
		mc.cacheAsBitmap=true;
		gfx.dropshadow(mc,5, 45, 0x000000, 1, 20, 20, 2, 3);
		
//		mc.onRelease=delegate(onRelease,null);
		
		mc._y=0;
		
		mc.dx=0;
		mc._x=-800;
		
		mc.onEnterFrame=delegate(update,null);

		done=false;
		steady=false;
		
		gfx.clear(mc);
		
		mc.style.out=0xff000000;
		mc.style.fill=0x80000000;
		gfx.draw_box(mc,0,100+16,0+16,600-32,600-32);
		
		
		s="<p align='center'>Click here to close this menu and return to the game.</p>";
		m=gfx.create_clip(mc,null,150,50);
		m.tf=gfx.create_text_html(m,null,0,0,500,100)
		gfx.set_text_html(m.tf,24,0xffffff,s);
		set_butt(m,"return");
		mcs[0]=m;

		if(_root.pbem_id)
		{
			s="<p align='center'>Click here to end your turn, you did make a move didn't you?</p>";
		}
		else
		{
			s="<p align='center'>Click here to QUIT the current game and go back to the main menu.</p>";
		}
		m=gfx.create_clip(mc,null,150,250);
		m.tf=gfx.create_text_html(m,null,0,00,500,150)
		gfx.set_text_html(m.tf,32,0xffffff,s);
		set_butt(m,"quit");
		mcs[1]=m;
		


		
		
		show_loaded();
		

		
		thunk();
		
		Mouse.addListener(this);
	}
	
	function show_loaded()
	{
	}
	
	function thunk()
	{
	}
	
	
	
	function clean()
	{
		if(_root.popup != this)
		{
			return;
		}
		
		mc.removeMovieClip();
		_root.popup=null;
		
		Mouse.removeListener(this);
		
		_root.poker.clear_clicks();
	}

	function onMouseUp()
	{
		if(_root.popup != this)
		{
			return;
		}

		if(steady)
		{
			done=true;
			mc.dx=_root.scalar.ox;
		}
	}

	function update()
	{
	
		show_loaded();
		
		if( (_root.popup != this) || (_root.pause) )
		{
			return;
		}
		
		
		mc._x+=(mc.dx-mc._x)/4;

		if( (mc._x-mc.dx)*(mc._x-mc.dx) < (16*16) )
		{
			steady=true;
			if(done)
			{
				clean();
			}
		}
		else
		{
			steady=false;
		}
		
	}
		
	function set_butt(b,id)
	{
		b.onRollOver=delegate(butt_over,id);
		b.onRollOut=delegate(butt_out,id);
		b.onReleaseOutside=delegate(butt_out,id);
		b.onRelease=delegate(butt_press,id);
	}
	
	function butt_over(id)
	{
		switch(id)
		{
			case "quit":
				if(_root.pbem_id)
				{
					_root.poker.ShowFloat("End your turn. You will be emailed again when your opponent makes a move.",25*10);
				}
				else
				{
					_root.poker.ShowFloat("You can rejoin this game, but you might want to let the other players know first so they do not leave as well.",25*10);
				}
			break;
		}
	}
	
	function butt_out(id)
	{
		_root.poker.ShowFloat(null,0);
	}
	
	function butt_up(id)
	{
	}
	
	function butt_press(id)
	{
		switch(id)
		{
			case "quit":
				up.up.state_next="splash";
				_root.swish=new Swish({style:"sqr_plode",mc:up.mc});
				_root.pbem_id=null;
			break;
		}
	}

}
