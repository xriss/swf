/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) Kriss Daniels 2007 http://www.XIXs.com
//
/*+-----------------------------------------------------------------------------------------------------------------+*/

#include "src/opts.as"



class WetDiamondsPlay
{
	var up;
	var mc;
	var mc_back;
	var mc_ads;
	
	var field;
	
	var hud;
	
	var player; // which player you are 0 or 1
	
	var turn;
	var scoreturn; //score belongs to this use
	
//	var high;
//	var about;
	var won;
	var turnmenu;
	
	var gamemode;
	var gameskill;
	var gamecomms;
	
	var done_adds;

	var skip_high=false;
	
	var turnactive; // we should move or the other player should move
	
	var acts;
	
	var choosen;
	
	var stage;
	var stage_turn;
	var noscore;
	
	var gameover;
	
	function WetDiamondsPlay(_up)
	{
		gamemode="endurance";
		gameskill="normal";
		
		gamecomms=null;
		
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
		gameover=false;
/*	
		up.lobby.gamedata={};
		up.lobby.gamedata.styles={}
		up.lobby.gamedata.styles.seed=1234;
		up.lobby.gamedata.gamename="diamonds";
*/		
		turn=0;
		stage_turn=0;
		player=0;
		stage=0;
		noscore=false;
		
		acts=null;
		
		turnactive=true;

		
		gamecomms=null;
		if(up.lobby.gamedata) // is this a request to play a multiplayer game?
		{
			
			gamecomms=up.lobby.gamedata;
			up.lobby.gamedata=null;
			
			up.game_seed=Math.floor(gamecomms.styles.seed);
			
			gamemode="puzzle";
			
			player=gamecomms.player_idx-1;
			
			choosen=new Array({t:"",used:false},{t:"",used:false},{t:"",used:false},{t:"",used:false});
		}
	
	
		rnd_seed(up.game_seed);
	
	
		_root.signals.signal("diamonds","start",this);
		
		done_adds=false;

		mc=gfx.create_clip(up.mc,null);
//		mc_back=gfx.create_clip(mc,null);
//		mc_back=gfx.add_clip(mc,"back",null);
//		mc_ads=gfx.create_clip(mc,null);
		
//		gfx.dropshadow(mc_ads , 2 , 45, 0x000000, 1, 4, 4, 2, 3);
		
/*
		gfx.clear(mc_back);
		mc_back.style.fill=0xff404080;
		gfx.draw_box(mc_back,0,0,0,800,600);
		mc_back.cacheAsBitmap=true;
*/
		
			
//		high=new PlayHigh(this);
//		about=new PlayAbout(this);
		won=new PlayWon(this);
		turnmenu=new PlayTurn(this);
		

		hud=new PlayHUD(this);
		hud.setup();
		
		field=new PlayField(this);
		field.setup();
		
		field.mc_scalar._x=200;
		field.mc_scalar._y=100;
		field.mc_scalar._xscale=100*(400/800);
		field.mc_scalar._yscale=field.mc_scalar._xscale;

		

		
		if(!skip_high)
		{
			if(!gamecomms) // multiplayer doesnt want a score shown
			{
//				up.high.setup();
			}
		}
		skip_high=false;
		
//		setup_ads();
		
//won.setup();

		thunk();
		
		if(player==-1) //  just watching
		{
			gmsgsend( { gcmd:"acts" , gnam:gamecomms.gamename , gtim:0 , gtyp:"watch" } ); // request recap of all acts and add me to the list of people to send new msgs too
		}
		else
		{
			gmsgsend( { gcmd:"acts" , gnam:gamecomms.gamename , gtim:0 , gtyp:"play" } ); // request recap of all acts, probably none
		}
		
		
//gfx.add_clip(mc,"obj_test",null);


//won.setup("ws");
				
	}
	
	function clean()
	{
		_root.signals.signal("diamonds","end",this);
		
		field.clean();
		mc.removeMovieClip();
		
		_root.poker.ShowFloat(null,0);
	}

	function thunk()
	{
		if(!gamecomms) { return; }
		
		if(acts==null) // wait for acts to fill up
		{
			hud.turn_str("<p align=\"center\">Please wait for network connection.</p>");
			turnactive=false;
		}
		else
		{
			if(acts[turn]) // we have a recorded turn to play
			{
				hud.turn_str("<p align=\"center\"><font color=\"#ffffff\"><b>Please wait whilst the recorded turns are replayed.</font></b></p>");
				turnactive=false;
				hud.butt_ids["pass1"]._visible=false;
				hud.butt_ids["pass2"]._visible=false;
			}
			else
			if( (turn&1) == player )
			{
				hud.turn_str("<p align=\"center\"><font color=\"#88ff88\"><b>You have no chance to survive make your time.</font></b></p>");
				turnactive=true;
				hud.butt_ids["pass1"]._visible=true;
				hud.butt_ids["pass2"]._visible=true;
			}
			else
			{
				hud.turn_str("<p align=\"center\"><font color=\"#ff8888\"><b>Waiting for the other player.</font></b></p>");
				turnactive=false;
				hud.butt_ids["pass1"]._visible=false;
				hud.butt_ids["pass2"]._visible=false;
			}
		}
		
	}

	function next_turn(msg)
	{
		if(!gamecomms) { return null; }
		
		if(msg==null)
		{
			if(acts[turn]) // poll for incoming turn
			{
				return acts[turn];
			}
			else
			{
				return null;
			}
		}
		else
		{
//			.print(msg);
			
			if(!acts[turn]) // send msg out
			{
//				dbg.print("sending:"+turn+":"+msg);
				gmsgsend( { gcmd:"act" , gnam:gamecomms.gamename , gtim:turn , gdat:msg } ); // broadcast turn
			}
			
			turn++;
			stage_turn++;
			
			if( (stage_turn>1) && (msg=="-1/-1") && (acts[turn-2]=="-1/-1") )
			{
				stage_end();
			}
			
			if(turn&1) // throb the player whoes turn it is
			{
				hud.mc2._xscale=200;
				hud.mc2._yscale=200;
			}
			else
			{
				hud.mc4._xscale=200;
				hud.mc4._yscale=200;
			}
			
			thunk();	// always thunk
			
			return null;
		}
	}
	
	function choose_update()
	{
	var i,d,p;
		if(gamecomms)
		{
			for(i=0;i<4;i++)
			{
				if(choosen[i].t!="")
				{
					d= field.types[ choosen[i].t ];
					
					if( field.available_moves[d]==0 ) // all gone
					{
						if(!choosen[i].used)
						{
							choosen[i].used=true;
							if(i<2)
							{
								hud.points1+=1000;
							}
							else
							{
								hud.points2+=1000;
							}
							p={x:0,y:0};
							hud.choosen[i].mc.localToGlobal(p);
							up.over.mc.globalToLocal(p);
							up.over.add_floater("<b>"+1000+"</b><font size=\"12\">pts</font>",p.x,p.y);
						}
					}
				}
			}
		}
	}
	
	function choose_color(t)
	{
	var i;
		if(gamecomms)
		{
			for(i=0;i<4;i++)
			{
				if(choosen[i].t==t)
				{
					return; // already taken
				}
			}
			if((turn-1)&1==0)
			{
				if(choosen[0].t=="")
				{
					choosen[0].t=t;
					hud.choosen[0].type=t;
					hud.choosen[0].draw();
					hud.choosen[0].mc._visible=true;
				}
				else
				if(choosen[1].t=="")
				{
					choosen[1].t=t;
					hud.choosen[1].type=t;
					hud.choosen[1].draw();
					hud.choosen[1].mc._visible=true;
				}
			}
			else
			{
				if(choosen[2].t=="")
				{
					choosen[2].t=t;
					hud.choosen[2].type=t;
					hud.choosen[2].draw();
					hud.choosen[2].mc._visible=true;
				}
				else
				if(choosen[3].t=="")
				{
					choosen[3].t=t;
					hud.choosen[3].type=t;
					hud.choosen[3].draw();
					hud.choosen[3].mc._visible=true;
				}
			}
		}
	}
	
//
// Signal either the end of the stage, possibly the end of the game
//
	function stage_end()
	{
		if(!gamecomms)
		{
			won.setup();
		}
		else
		{
			if(stage==0)
			{
				stage++; // next stage, reset board
				hud.butt_changed("stage");
				stage_turn=0;
				
				noscore=true;

				rnd_seed(up.game_seed); // reset seed used to build board
		
				field.build_board();
			
				if( ((turn)&1==0) && ((stage&1)==1) ) //jiggle user order so first player gets swapped each round
				{
					turn++;
					stage_turn++;
//					next_turn("-2/-2"); 
				}
				
				choosen=new Array({t:"",used:false},{t:"",used:false},{t:"",used:false},{t:"",used:false});				
				
				hud.choosen[0].mc._visible=false;
				hud.choosen[1].mc._visible=false;
				hud.choosen[2].mc._visible=false;
				hud.choosen[3].mc._visible=false;
				
				noscore=false;
			}
			else
			{
				if(player!=-1) // watcher doesn't do this
				{
					gmsgsend( { gcmd:"start" , gnam:gamecomms.gamename , garg:(hud.points1+","+hud.points2) , gtyp:"finish"} ); // well if pressing start to end is good enough for microsoft :)
					won.setup("ws");
				}
				else
				{
					won.setup("ws");
				}
			}
		}
	}

	
	function update()
	{
//		setup_ads();
		
		if( (_root.popup) || (_root.pause) )
		{
			return;
		}
		
		if(gameover)
		{
			do_str("won");
			return;
		}
		
		_root.signals.signal("diamonds","update",this);
		
		field.update();
		
		choose_update(); // +1000pts on clears in multiplayer
		
		hud.update();
		
	}	
	
	function score(p)
	{
		if(gamecomms)
		{
			if(!noscore)
			{
				if((turn-1)&1==0)
				{
					hud.points1+=p;
				}
				else
				{
					hud.points2+=p;
				}
			}
		}
		else
		{
			hud.points+=p;
		}
	}
	
/*
	function setup_ads()
	{
	var i,x,y,m,w,m2;
	
		if( up.wonderfulls && (!done_adds) )
		{
			if(gamecomms)
			{
				x=Math.floor((800-(147*5))/2);
				y=500-4;
				for(i=0;i<8;i++)
				{
					w=up.wonderfulls[i];
					
					m=gfx.create_clip(mc_ads,null);
					m2=gfx.create_clip(m,null);
					m2._lockroot=true;
					m.onRelease=delegate(goad,w);
					m.onRollOver=delegate(onad,w);
					m.onRollOut=delegate(offad,w);

					m._x=x;
					m._y=y;
					m._xscale=100*600/480;
					m._yscale=100*600/480;
					m2.loadMovie(w.img);
					
					x+=147;
					if(i==3)
					{
						x-=147*3;
						y+=39;
					}
				}
			}
			else
			{
				x=800+10-180;
			
			y=120;
				for(i=0;i<8;i++)
				{
					w=up.wonderfulls[i];
					
					m=gfx.create_clip(mc_ads,null);
					m2=gfx.create_clip(m,null);
					m2._lockroot=true;
					m.onRelease=delegate(goad,w);
					m.onRollOver=delegate(onad,w);
					m.onRollOut=delegate(offad,w);

					m._x=x;
					m._y=y;
					m._xscale=100*600/480;
					m._yscale=100*600/480;
					m2.loadMovie(w.img);
					
					y+=45;
					
//				dbg.print(w.img);
				}
			}
			
			
			
			
				
			done_adds=true;
		}
	}
	function goad(w)
	{
		if(!_root.popup) // ignore while a popup is displayed
		{
			getURL(w.url,w.target);
		}
	}
	function onad(w)
	{
		if(!_root.popup) // ignore while a popup is displayed
		{
			_root.poker.ShowFloat(w.txt,25*10);
		}
	}
	function offad(w)
	{
		if(!_root.popup) // ignore while a popup is displayed
		{
			_root.poker.ShowFloat(null,0);
		}
	}
*/
	
	
	function do_str(str)
	{
		switch(str)
		{
			case "won":
				if(gamecomms)
				{
					up.state_next="splash";
				}
				else
				{
					up.do_str("restart");
				}
			break;
			
			default:
				up.do_str(str);
			break;
		}
	}
	
	function gmsgsend(msg)
	{
	var idx;
	var s;
	
		if(_root.sock)
		{
			_root.sock.gmsg( msg , delegate(gmsgback,msg) );
			lastmsg=msg;
			_root.sock.gmsg( null , delegate(gmsgback,null) ); // request all other game msgs as well
		}
	}
	
	var lastmsg;
	
	function gmsgback(msg,sentmsg)
	{
	var idx;
	var s;
	var a,i,aa,j;
	
		if(!sentmsg) // incoming
		{
			switch(msg.gcmd)
			{
				case "act":

//dbg.print( "act "+ Math.floor(msg.gtim) +" : "+ msg.gdat );

					acts[ Math.floor(msg.gtim) ]=msg.gdat;
								
					thunk();
					
				break;
				
				default:
				break;
			}
		}
		else
//		if(sentmsg==lastmsg) // only care about one return msg at a time, ignore all other return msgs
		{
			switch(sentmsg.gcmd)
			{
				case "acts":
				
//dbg.print("acts");

					acts=new Array();
				
					a=msg.gret.split(";");
					for(i=0;i<a.length;i++)
					{
						a[i]=a[i].split(",");
					}
					
					if(a[0][0]=="OK")
					{
						a[0].splice(0,1); // throw away the OK
						
						for(i=0;i<a.length;i++)
						{
							for(j=0;j<a[i].length;j++)
							{
								aa=a[i][j].split(":");
								if(aa[0]!="")
								{
									acts[ Math.floor(aa[0]) ]=aa[1];
								}
							}
						}
					}
					else
					{
					}
					
					thunk();
 	
				break;

				default:
				break;
			}
		}
	}
}