/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) Kriss Daniels 2006 http://www.XIXs.com
//
/*+-----------------------------------------------------------------------------------------------------------------+*/

#include "src/opts.as"


class BProp
{
	var mc;
	var mci;
	var tf;
	
	var state;
	var state_last;
	
	var x,y;		// this pos
	var vx,vy;		// this vel
	var rad;
	
	var mx,my,px,py; // bounding box
	
	var back;
	
	var score; // how much this apple is worth
	var score_disp;
	
	var order;
	
	var active;
	var falling;
	
	var arrow;
	var arrow_p;
	
	
	function BProp(_up)
	{
		back=_up;
		x=0;
		y=0;
		state="none";
		state_last="none";
	}

	function setup(_xx,_state,_order)
	{
		score=0;
		order=_order;
		score_disp=-1;
		
		clean();
		
		x=_xx;
		y=back.GetY(x);
		state=_state;
		
		active=true;
		falling=false;
		
		update();
	}
	
	function clean()
	{
		mc.removeMovieClip(); mc=null;
	}

	function update()
	{
		if(state!=state_last) // update mc
		{
			mc.removeMovieClip(); mc=null;
					
			switch(state)
			{
				case "tower":
					mc=gfx.add_clip(back.mc2,"towers",null);
					back.rnd(); // keep the random hit...
					mc.gotoAndStop(order); 
					mc._x=x;
					mc._y=y+16;
					
					mx=x-50;
					px=x+50;
					my=y+16-200;
					py=y+16;
				break;
				
				case "apple":
				
					y-=256+(back.rnd()%1024);
					rad=50;
				
					mc=gfx.create_clip(back.mc2);
					
					
					mci=gfx.add_clip(mc,"apple",null);
					mci.gotoAndStop(1+(back.rnd()%1));
					
					tf=gfx.create_text_html(mc,null,-100,-120,200,50);
					
					mc._x=x;
					mc._y=y;
				break;
			}
			
			state_last=state;
		}
		
		if(state=='apple')
		{
			if(active)
			{
				score=50-back.propshots;
				if(score<1) { score=1; }
				score*=order;
			}
			else
			{
				score=0;
			}
			
			if(score!=score_disp)
			{
				score_disp=score;

				if(score>0)
				{
					gfx.set_text_html(tf,48,0xffffff,"<p align='center'>x"+order+"</p>");
				}
				else
				{
					gfx.set_text_html(tf,48,0xffffff,"");
				}
			}
			
			if(falling==true)
			{
			var by;
			
				vy+=2;
				
				x+=vx;
				y+=vy;
				
				by=back.GetY(x);
				
				if(y>(by-50))
				{
					y=by-50;
					falling=false;
					
					_root.wetplay.PlaySFX("sfx_thud",3);
				}
				
				mc._x=x;
				mc._y=y;
					
				var p=new Object(); 
				
				p.x=arrow_p.x;
				p.y=arrow_p.y;
				
				mc.localToGlobal(p);
				
				arrow.upmc.globalToLocal(p);
//				arrow.x=p.x;
//				arrow.y=p.y;
				arrow.mc._x=x;
				arrow.mc._y=y;
			}
		}
	}
	
	function hit(by)
	{
	var p=new Object(); 
			
		switch(state)
		{
			case "tower":
			
			
				if(back.up.shooter.tower)
				{
					_root.wetplay.PlaySFX("sfx_thunk",3);
				}
				
				if((!back.up.so.data.sticky)||(!back.up.shooter.tower))
				{
					back.up.logshot(this);
					
					if( back.up.shooter.tower!=this )
					{
						back.up.shooter.tower=this;
						
						back.up.shooter.x=x;
						back.up.shooter.y=y-40+12-200;
						back.propshots++;
						
						_root.wetplay.PlaySFX("sfx_teleport",2);
						
					}
					
					back.up.buildlogs();
				}
				
			break;
			
			case "apple":
			
				_root.wetplay.PlaySFX("sfx_crunch",3);
					
				if(active)
				{
					
					
					p.x = by.x; p.y = by.y;
					by.upmc.localToGlobal(p);
					
					mc.globalToLocal(p);
					
					arrow=by;
					arrow_p=p;				
					falling=true;
					
					vx=by.vx/8;
					vy=by.vy/8;
					
/*				
					y=back.GetY(x)-50;
					mc._x=x;
					mc._y=y;
					mc.localToGlobal(p);
					
					by.upmc.globalToLocal(p);
					by.x=p.x;
					by.y=p.y;
*/
					back.up.score+=score;
					active=false;
					update();
					
					back.propshots++;
					
					back.up.logshot(this);
					back.up.buildlogs();
					
				}
				
			break;
		}
	}
	
}
