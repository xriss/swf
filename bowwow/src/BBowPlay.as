/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) Kriss Daniels 2006 http://www.XIXs.com
//
/*+-----------------------------------------------------------------------------------------------------------------+*/

#include "src/opts.as"

class BBowPlay
{
	var mc:MovieClip;

	var up;
	
	var bdudes;
	var barrows;
	var baim;
	var back;

// the shots shooter victim and arrow
	var shooter;
	var victim;		
	var focus;
	
	var slowsnap;
	
	var max_scale;
	
	var mc_score;
	var tf_score;
	var tf_radar;
	var score;
	var score_disp;
	var xscore;
	var xscore_disp;
	var radar;
	var radar_disp;
	
	var apples;
	
	var replay;
	
	var showoptions;
	var options;
	var shotmode;
	
	var apple_count=12;
	var won=false;

	
	function BBowPlay(_up)
	{
		up=_up;
		
	}
	
	function delegate(f,d) { return com.dynamicflash.utils.Delegate.create(this,f,d); }
	
	var rnd_num:Number=0;
	function rnd_seed(n:Number) { rnd_num=n&65535; }
	function rnd() // returns a number between 0 and 65535
	{
		rnd_num=(((rnd_num+1)*75)-1)%65537; // all hail the mighty zx spectrum pseudo random number sequence
		return rnd_num;
	}


	function setup()
	{
	var i;
	
		shotmode=1;
		showoptions=false;
		options={};
	
		apple_count=12;
		won=false;

		apples=[];
	
// telleverything to scroll by again
//		_root.wtf_import.setup_adverts();
	
		rnd_seed(up.game_seed);
		
		mc=gfx.create_clip(up.mc,null);
		
		slowsnap=new Object();
		slowsnap.id="slowsnap";
		
		back=new BBowBack(this);

		bdudes=new Array();
		bdudes[0]=new BDude(back);
//		bdudes[1]=new BDude(back);
		
		bdudes[0].x=0;//-1024;
		bdudes[0].y=back.GetY(bdudes[0].x)-40+12;
		bdudes[0].ang=30;
/*		
		bdudes[1].x=1024;
		bdudes[1].y=back.GetY(bdudes[1].x)-40;
		bdudes[1].ang=180-30;
*/		
		shooter=bdudes[0];
		victim=null;//bdudes[1];
		focus=shooter;
		
		back.bprops[8].hit(null); // fake collide to set start tower/position
		back.propshots=0;
		
		
		mc_score=gfx.create_clip(mc,null);
		tf_score=gfx.create_text_html(mc_score,null,400-100,5,200,60);		
		mc_score.id="score";
		make_clickable(mc_score);
		
		tf_radar=[];
		
		for(i=0;i<12;i++)
		{
			tf_radar[i]=gfx.create_text_html(mc,null,450+i*25,15,25,25);
		}
		
		baim=new BAim(this);
		
		
		for(i=0;i<barrows.length;i++)
		{
			barrows[i].clean();
		}
		barrows=new Array();
		
		back.setup();
		baim.setup();
		
		score=0;
		score_disp=-1;
		xscore_disp=-1;
		radar_disp="";
				
		so_load();
		
		buildlogs();
		
		replay=new Array();
		
		Mouse.addListener(this);
		
		_root.signals.signal("#(VERSION_NAME)","start",up);
	}
	
	function clean()
	{
		Mouse.removeListener(this);
		
		_root.signals.signal("#(VERSION_NAME)","end",up);
					
		mc.removeMovieClip();
	}

	function onMouseDown()
	{
		_root.poker.ShowFloat(null,0);
	}
	
	function do_slowsnap()
	{
		slowsnap.x=focus.x;
		slowsnap.y=focus.y;
		focus=slowsnap;
		focus.time=0;
		focus.dx=shooter.x;
		focus.dy=shooter.y;
	}

	function update()
	{
	var i;
	
		if(_root.popup){return;}
		
		if(won)
		{
			if(won=="exit")
			{
				won="done";
				up.state_next="menu";
			}
			else
			if(won=="high")
			{
				won="exit";
				up.high.setup();
			}
			return;
		}
				
	
//		dbg.print(baim.gizmo_zoom.y_knob);
	
		max_scale=1 - (Math.sqrt(baim.gizmo_zoom.x_knob)*7/8) ;

//		up.replay.update();
	
		for(i=0;i<barrows.length;i++)
		{
			barrows[i].update(back);
		}

		baim.update();
		
		back.x=-400;
		back.y=-300;
		back.w=800;
		back.h=600;
		back.scale=1;
		
		if(focus)
		{
		var x,y,d,dd;
		var pa,pb,pc;
		
		var w=new Array(0,0,0);
		var s=new Array(0,0,0);
		var ratio;
		var t;
		
			if(focus.id=="slowsnap")
			{
				{
					focus.time++;
					if(focus.time>(3*30)) // wait before moving
					{
						focus.x+=(focus.dx-focus.x)*0.25;
						focus.y+=(focus.dy-focus.y)*0.25;
					}
				}
			}
		
			x=focus.x-shooter.x;
			y=0;//focus.y-shooter.y;
			shooter.tofocus=Math.sqrt(x*x+y*y);
			
			x=focus.x-victim.x;
			y=0;//focus.y-victim.y;
			victim.tofocus=Math.sqrt(x*x+y*y);
			
			var max_focus_dist=Math.abs(victim.x-shooter.x)/2;//100*32;
			
			if(max_focus_dist<100*8)
			{
				max_focus_dist=100*8;
			}
			

//			max_focus_dist=100*8;
/*			
			if( (shooter.tofocus<max_focus_dist) && (victim.tofocus<max_focus_dist) ) // close enoough to both
			{
				ratio=victim.tofocus*2/max_focus_dist;
				w[0]=0;
				w[1]=ratio;
				w[2]=2-ratio;
				
				ratio=shooter.tofocus*2/max_focus_dist;
				w[0]+=2-ratio;
				w[1]+=ratio;
				w[2]+=0;
				
				w[1]/=2;

			}
			else
			if(shooter.tofocus<max_focus_dist)
			{
				ratio=shooter.tofocus*2/max_focus_dist;					
				w[0]=2-ratio;
				w[1]=2+ratio;
				w[2]=0;
				w[1]/=2;
			}
			else
			if(victim.tofocus<max_focus_dist)
			{
				ratio=victim.tofocus*2/max_focus_dist;
				w[0]=0;
				w[1]=2+ratio;
				w[2]=2-ratio;
				w[1]/=2;
			}
			else
			{
				w[0]=0;
				w[1]=1;
				w[2]=0;
			}
*/
			
// unit length the weights
/*
			t=1/(w[0]+w[1]+w[2]);
			w[0]*=t;
			w[1]*=t;
			w[2]*=t;
*/			
			
/*
			if(!focus.active)
			{
				focus.deadtime+=1;
				pa=60;
				pb=60-focus.deadtime;
				if(pb<0) { pb=0; }
				pc=pa+pb;
				pa=pa/pc;
				pb=pb/pc;
			}
			else
			{
				pa=0.5;
				pb=0.5;
				pc=1;
			}
*/			
			
//			back.x=(shooter.x*pa+focus.x*pb);
//			back.y=(shooter.y*pa+focus.y*pb);
			
			

//			back.x=( shooter.x*w[0] + focus.x*w[1] + victim.x*w[2] );
//			back.y=( shooter.y*w[0] + focus.y*w[1] + victim.y*w[2] );
			
			back.x=focus.x;
			back.y=focus.y;
/*						
			x=focus.x-back.x;
			y=focus.y-back.y;
			dd=x*x+y*y;
			d=Math.sqrt(dd);
			if(d<256)
			{
				d=256;
			}
*/

// as always simplest is bestist

// just zoom out till you can see the ground under the arrow
// average the height of the ground to keep things smooth


			d=0;
			d+=Math.abs(focus.y-back.GetY(focus.x-100))
			d+=Math.abs(focus.y-back.GetY(focus.x-50))
			d+=Math.abs(focus.y-back.GetY(focus.x))
			d+=Math.abs(focus.y-back.GetY(focus.x+50));
			d+=Math.abs(focus.y-back.GetY(focus.x+100));
			d=(d/5)+100;
			if(d<256)
			{
				d=256;
			}
			
//			back.scale= ( (back.scale*2) + ((256/d)*14) ) / 16 ;			
			back.scale=(256/d);
			
			if(back.scale>max_scale) { back.scale=max_scale; }
			if(back.scale<(1/8)) { back.scale=(1/8); }

			
			back.x-=400/back.scale;
			back.y-=300/back.scale;
			back.w=800/back.scale;
			back.h=600/back.scale;
			
			
// if we are focusing on an arrow not a bdude

			if( focus.id=="arrow" ) // arrow is flying through air
			{
				if(!focus.active) // we hit the ground
				{
				var ttt;
				
					if(back.mcb._visible==true) // handle bomb first...
					{
						ttt=back.GetY(back.mcb._x)-back.mcb._y;
//						dbg.print(ttt);
						if(ttt<50) // check for ground hit
						{
							back.blinks=new Array(); // turn off links

							back.mcb._visible=false;
							
							back.boom(back.mcb._x,128);
						}
					}
					else
					if(shooter.tiedto) // handle movement
					{
						ttt=back.GetY(shooter.x)-shooter.y;
//						dbg.print(ttt);
						if(ttt<50) // check for ground hit
						{
							shooter.tiedto=false;
							
							back.blinks=new Array(); // turn off links

							back.mcb._visible=false;
						}
					}
					else
					{
/*					
						if(baim.gizmo_buttons.active!=true) // only do this swap once
						{
						
							baim.state=BAim.STATE_NONE;
							baim.gizmo_buttons.active=true;
							
//					focus=victim;		// dont set focus just swap between dudes
							ttt=victim;
							victim=shooter;
							shooter=ttt;
							
							slowsnap.x=focus.x;
							slowsnap.y=focus.y;
							focus=slowsnap;
							focus.time=0;
							focus.dx=shooter.x;
							focus.dy=shooter.y;
						}
*/
						if(baim.state!=BAim.STATE_NONE) // only do this swap once
						{
						
							baim.state=BAim.STATE_NONE;
//							baim.gizmo_buttons.active=true;
							
//					focus=victim;		// dont set focus just swap between dudes
//							ttt=victim;
//							victim=shooter;
//							shooter=ttt;
							
							do_slowsnap();
						}
					}
				}
			}
		}

		back.update();
		
		var rad;
        var deg;
		
//		rad = Math.atan2((up.replay.mouse_y+300)-300, (up.replay.mouse_x+400)-200);
//        deg = Math.round((rad*180/Math.PI));
//
//		bdudes[0].ang=deg;
		

//		rad = Math.atan2((up.replay.mouse_y+300)-300, (up.replay.mouse_x+400)-600);
//        deg = Math.round((rad*180/Math.PI));

//		bdudes[1].ang=deg;
		
//		dbg.print(baim.state);
//		dbg.print(bdudes[0].reload);
		
		if( ( (baim.state==BAim.STATE_HOLD) && (shooter.reload==0) ) || (baim.shoot) )
		{
			shooter.pull=baim.power;
			shooter.ang=baim.angle;
		}
		
		bdudes[0].update(); // make sure things are updated before we shoot
		bdudes[1].update();
		
		if(baim.shoot)
		{
			baim.shoot=false;
			shooter.reload=1;
			shooter.shoot=shooter.pull;
//			dbg.print(bdudes[0].shoot);
		}
		
		if(baim.state!=BAim.STATE_HOLD)
		{
			shooter.pull=0;		
			if(shooter.reload<=0.5)
			{
				shooter.ang*=0.75;
			}
		}
		
		
		xscore=50-back.propshots;
		if(xscore<1) { xscore=1; }
			
		if( (score!=score_disp) || (xscore!=xscore_disp) )
		{
			score_disp=score;
			xscore_disp=xscore;
							
			gfx.set_text_html(tf_score,24,0xffffff,"<p align='center'>"+score+"</p><font size='14'><p align='center'>"+xscore+"x</p></font>");		
		}
		
		buildapples();
		
		_root.signals.signal("#(VERSION_NAME)","update",up);
				
		if((apple_count==0)&&(!won))
		{
			_root.signals.signal("#(VERSION_NAME)","won",up);
			up.high.setup("results");
			
			won="high";
		}
	}
	

	var logs;
	
	function buildapples()
	{
		var i;
		var p;
		var t=1;
		var x=0;
		apple_count=0;
		for(i=0;i<back.bprops.length;i++)
		{
			p=back.bprops[i];
			
			if(p.state=="tower")
			{
//				radar+=" "+"t"+t+" ";
				t++;
			}
			else
			if(p.state=="apple")
			{
//				radar+=" "+"x"+p.order+" ";

				if(p.active)
				{
					if( ( tf_radar[x].order!=p.order ) || (!apples[p.order]) )
					{
						gfx.set_text_html(tf_radar[x],14,0xccffcc,"<p align='center'>"+p.order+"</p>");
						tf_radar[x].order=p.order;
						
						apples[p.order]=true;
					}
					apple_count++;
				}
				else
				{
					if(apples[p.order]==true)
					{						
						gfx.set_text_html(tf_radar[x],14,0x886666,"<p align='center'>"+p.order+"</p>");
						apples[p.order]=false;
						
//						buildlogs();
					}
				}
				
				x++;
			}

		}
	}
	
	static function compare_shots(a,b)
	{
	var tt;
	
		tt=a.hit+b.hit;
		
		switch(tt)
		{
			case "xt":
				return -1;
			break;
			case "tx":
				return 1;
			break;
			case "xx":
			
				if(a.hitnum==b.hitnum)
				{
					if(a.args==b.args)
					{
						return 0;
					}
					else
					{
						return	(a.args<b.args) ? 1:-1;
					}
				}
				else
				{
					return	(a.hitnum<b.hitnum) ? 1:-1;
				}
				
			break;
			case "tt":
			
				if(a.hitnum==b.hitnum)
				{
					if(a.args==b.args)
					{
						return 0;
					}
					else
					{
						return	(a.args<b.args) ? -1:1;
					}
				}
				else
				{
					return	(a.hitnum<b.hitnum) ? -1:1;
				}
			
			break;
		}
		
		return 0;
	}
	
	
	function buildlogs()
	{
	var i;
	var s;
	var l;
	var p;
	var rgb;
	
		buildapples();
	
		logs=[];
		for( var d in up.logs)
		{
//dbg.print(d);
			p=up.logs[d];
			if(p.tower==shooter.tower.order)
			{
				logs[logs.length]=p;
			}
		}
		
		logs.sort(compare_shots);
		
		s="";
		if(showoptions)
		{
			s+="<p><a href=\"asfunction:_root.bowwow.play.click,-3\"><font size=\"14\" color=\"#"+"ffffff"+"\"><b>"+"Remove all the old arrows."+"</b></font></a><br></p>";
				
			s+="<p><a href=\"asfunction:_root.bowwow.play.click,-4\"><font size=\"14\" color=\"#"+"ffffff"+"\"><b>"+"Quit to the main menu."+"</b></font></a><br></p>";
			
			if(so.data.sticky)
			{
				s+="<p><a href=\"asfunction:_root.bowwow.play.click,-2\"><font size=\"14\" color=\"#"+"ff8888"+"\"><b>"+"Tower teleporting is OFF."+"</b></font></a><br></p>";
			}
			else
			{
				s+="<p><a href=\"asfunction:_root.bowwow.play.click,-2\"><font size=\"14\" color=\"#"+"ffffff"+"\"><b>"+"Tower teleporting is ON."+"</b></font></a><br></p>";
			}
			
			if(so.data.hide_hints)
			{
				s+="<p><a href=\"asfunction:_root.bowwow.play.click,-5\"><font size=\"14\" color=\"#"+"ffffff"+"\"><b>"+"Game hints are OFF."+"</b></font></a></p>";
			}
			else
			{
				s+="<p><a href=\"asfunction:_root.bowwow.play.click,-5\"><font size=\"14\" color=\"#"+"ff8888"+"\"><b>"+"Game hints are ON."+"</b></font></a></p>";
			}
		}
		else
		{
			for(i=0;i<logs.length;i++)
			{
				l=logs[i];
				
				rgb="ccffcc";
				
				if(l.hit=="t")
				{
					rgb="ccccff";
				}
				else
				if(l.hit=="x")
				{
					if(!apples[l.hitnum])
					{
						rgb="ffcccc";
					}
				}
				
				if(shotmode<0)
				{
					s+="<p><a href=\"asfunction:_root.bowwow.play.click,"+i+"\"><font color=\"#"+"ff8888"+"\"><b>"+l.args+" : "+l.hit+l.hitnum+"</b></font></a></p>";
				}
				else
				{
					s+="<p><a href=\"asfunction:_root.bowwow.play.click,"+i+"\">"+l.args+" : <font color=\"#"+rgb+"\">"+l.hit+l.hitnum+"</font></a></p>";
				}
			}
			
			if(shotmode<0)
			{
				s+="<p><a href=\"asfunction:_root.bowwow.play.click,-1\"><font size=\"14\" color=\"#"+"ffffff"+"\"><b>"+"Click here to switch to Shoot Mode!"+"</b></font></a></p>";
			}
			else
			{
				s+="<p><a href=\"asfunction:_root.bowwow.play.click,-1\"><font size=\"14\" color=\"#"+"ff8888"+"\"><b>"+"Click here to switch to Forget Mode!"+"</b></font></a></p>";
			}
		}
			
		baim.gizmo_text_list.str=s;
	}
	
	
	function click(id)
	{
		if(_root.popup){return;}
		
		var p;
		var i;
		
		switch(Math.floor(id))
		{
			case -1: // toggle edit/shot mode
				shotmode*=-1;
				buildlogs();
			break;
			
			case -2: // toggle sticky mode
				so.data.sticky=so.data.sticky?false:true;
				so_save();
				buildlogs();
			break;
			
			case -3: // cleanup arrows
				for(i=0;i<barrows.length;i++)
				{
					if(!barrows[i].active)
					{
						barrows[i].clean();
						barrows.splice(i,1);
						i--;
					}
				}
			break;
			
			case -4: // return to menu
			
				up.state_next="menu";
				
			break;
			
			case -5: // toggle show anoying hints mode
				so.data.hide_hints=so.data.hide_hints?false:true;
				so_save();
				buildlogs();
			break;
			
			default:
				p=logs[Math.floor(id)];
				
				if(shotmode<0)
				{
					up.logs[p.id]=null; // forget
					buildlogs();
					so_save();
				}
				else
				{
					baim.doshot(p.args);
				}
			break;
		}
	}
	
	function logshot(p)
	{
	var s;
	var o;
	
		if	(
				(shooter.tower==null)	// ignore first shot
				||
				(shooter.tower==p)		// or shooting ourselves in the foot
			)
		{
			return;
		}
		
//		dbg.print("logshot: "+shooter.tower.order+" -> "+p.state+" "+p.order+" : "+baim.shotargs);
		
		s=shooter.tower.order+":"+baim.shotargs+":"+(p.state=="apple"?"x":"t")+p.order;
		
		o={};
		o.id=s;
		o.tower=shooter.tower.order;
		o.args=baim.shotargs;
		o.hit=(p.state=="apple"?"x":"t"); // x for apple t for tower
		o.hitnum=p.order;
		
		up.logs[s]=o;
		
		replay[replay.length]=o; // remember all important shots in replay array as well...
		
		so_save();
//		dbg.print(s);
		
//		up.logs
	}
	
	function get_replay_moves()
	{
		return replay.length;
	}
	
	function get_replay_str()
	{
	var i;
	var s;
	
		s="v=1";
	
		for(i=0;i<replay.length;i++)
		{
			s+=";"+replay[i].args;
		}
		
		return s;
	}
	
	var so;
	
	function so_load()
	{
		so=SharedObject.getLocal("logs");
		
//		dump_stuff(so);
		
		if(so.data[up.game_seed]!=undefined)
		{
			up.logs=so.data[up.game_seed];
		}
		else
		{
			up.logs=new Array();
		}
	}
	
	function so_save()
	{
		so.data[up.game_seed]=up.logs;
		so.flush();
	}

	function dump_stuff(stuff)
	{
		for( var idx in stuff)
		{
			dbg.print(idx+" : "+stuff[idx]);
			if	(
					(typeof(stuff[idx])=="array")
					||
					(typeof(stuff[idx])=="object")
				)
			{
				dump_stuff(stuff[idx]);
			}
		}
	}
	
	function click_mc(_mc)
	{
		if(_root.popup){return;}
		
		switch(_mc.id)
		{
			case "score":
				_root.signals.signal("#(VERSION_NAME)","high",up);
				up.high.setup();
			break;
		}
	}
	function hover_on(_mc)
	{
		if(_root.popup){return;}
		
			_root.poker.ShowFloat("Click here to submit your score then view other high scores.",25*5);
	}
	function hover_off(_mc)
	{
//		if(_root.popup){return;}
		
			_root.poker.ShowFloat(null,0);
	}
	
	function make_clickable(_mc)
	{
		_mc.onRelease=delegate(click_mc,_mc);
		_mc.onRollOver=delegate(hover_on,_mc);
		_mc.onRollOut=delegate(hover_off,_mc);
		_mc.onReleaseOutside=delegate(hover_off,_mc);
	}
	
}
