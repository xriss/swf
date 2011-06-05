/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) http://www.WetGenes.com/ 2009
//
/*+-----------------------------------------------------------------------------------------------------------------+*/

#include "src/opts.as"

#GFX="gfx"

// lets handle some scores

class PlayLobby
{
	var up;
	
	var mcb;
	var mc;
	var mc_base;
	var mc_pbem;
	
	var mcs;
	var tfs;
	var butts;
	
	var done;
	var steady;
	
	var gamename;
	var gamebasename;
	var gameversion;
	
	var rooms; //list of rooms we are interested in
	var users; //list of players in the current room
	var owners; //last returned username[0] and then the list of room owners[1++]
	
	var username="me";
	var userauth="user"; // or owner, our last cached state
	
	var players;	 	// which users will play next (names)
	var players_max=2;	// how many users we should choose
	
	var styles;			// the style settings of this game
	var xups;			// the special styles associated with this player (the one running this code)
	
	var rooms_str;
	var users_str;
	var styles_str;
	var pbem_str;

	var state;
	
	var gamedata; // on exit this is filled in with everything you need to know about the game to start, or null if user canceled
	
	
	var opts; // of this code not the gameroom

	function delegate(f,d)	{	return com.dynamicflash.utils.Delegate.create(this,f,d);	}

	function PlayLobby(_up,_opts)
	{
		up=_up;
		
		opts=_opts;
		
		gamebasename=opts.name;
		gameversion=opts.version;
		gamename=gamebasename+"."+gameversion; // what game this is a lobby for
		
	}
	
	function setup()
	{
	var i;
	var bounds;
	var mct;
	var s;
		
		
		if(opts.style=="popup")
		{
			if(_root.popup) { return; }
			_root.popup=this;
			mc=gfx.create_clip(_root.mc_popup,null);
		}
		else
		{
			mcb=gfx.create_clip(up.mc,null);			
			
			if(opts.backswf)
			{
				mcb.back=gfx.add_clip(mcb,opts.backswf,null,0,0);
				mcb.back.gotoAndStop(1);
				mcb.back.cacheAsBitmap=true;
//				mcb.back._alpha=50;
			}
			
			mc=gfx.create_clip(mcb,null);
		}
		
		_root.lobby=this;
		
		username=_root.Login_Name;
		
		gamedata=null;
		
		
		
		players=new Array();
		styles=new Array();
		xups=new Array();
		
		tfs=new Array();
		mcs=new Array();
		butts=new Array();
			
		done=false;
		steady=false;
		
		mc.cacheAsBitmap=true;
//		gfx.dropshadow(mc,5, 45, 0x000000, 1, 20, 20, 2, 3);		
		mc._x=-800;
		mc._y=0;
		mc.dx=0;
		gfx.clear(mc);		
		mc.style.out=0xff000000;
		mc.style.fill=0x40000000;
		gfx.draw_box(mc,0,100+16,0+16,600-32,600-32);

		mc_base=gfx.create_clip(mc,null);
		mc_pbem=gfx.create_clip(mc,null);
		
		
		mcs[0]=gfx.create_clip(mc,null);
		mcs[0].tf=gfx.create_text_html(mcs[0],null,150,50,500,150);
//		set_butt(mcs[0],null);
		
		state="rooms";
		
		new_butt("close","<p align='center'><b>Close</b></p>",150+500-120,40+(40*2),120,20);
		new_butt("rooms","<p align='center'><b>Join</b></p>",150+500-120,40+(40*3),120,20);
		new_butt("host","<p align='center'><b>Host</b></p>",150+500-120,40+(40*4),120,20);
		new_butt("styles","<p align='center'><b>Styles</b></p>",150+500-120,40+(40*5),120,20);
		new_butt("users","<p align='center'><b>Players</b></p>",150+500-120,40+(40*6),120,20);
		new_butt("pickme","<p align='center'><b>PickMe!</b></p>",150+500-120,40+(40*7),120,20);
		new_butt("start","<p align='center'><b>Start!</b></p>",150+500-120,40+(40*8),120,20);
		new_butt("cancel","<p align='center'><b>Cancel!</b></p>",150+500-120,40+(40*9),120,20);
		new_butt("watch","<p align='center'><b>Watch!</b></p>",150+500-120,40+(40*10),120,20);
		new_butt("rejoin","<p align='center'><b>ReJoin!</b></p>",150+500-120,40+(40*10),120,20);
		new_butt("pbem","<p align='center'><b>PBeM!</b></p>",150+500-120,40+(40*11),120,20);
		
		setup_gizmos();
		
		rooms_str="<p>Connecting to server... You should probably think about clicking one of the buttons to the right.</p>";
		users_str=rooms_str;
		
		thunk();
		
		update_do=delegate(update,null);
		MainStatic.update_add(_root.updates,update_do);
		_root.poker.clear_clicks();
		
		
		tfs[0]=gfx.create_text_edit(mc_pbem,null,150,200,500,40);
		tfs[1]=gfx.create_text_edit(mc_pbem,null,150,300,500,40);
		
		var ss=8;
		gfx.clear(mc_pbem);
		draw_boxen(mc_pbem,150-ss,200-ss,500+ss+ss,40+ss+ss);
		draw_boxen(mc_pbem,150-ss,300-ss,500+ss+ss,40+ss+ss);
		
		tfs[0].setNewTextFormat(gfx.create_text_format(32,0xffffffff));
		tfs[1].setNewTextFormat(gfx.create_text_format(32,0xffffffff));

		tfs[0].text="your@email";
		tfs[1].text="their@email";
		
		
		new_butt("ok","<p align='center'><b>OK</b></p>"			,150,			40+(40*12),	120,20,mc_pbem);
		new_butt("cancel","<p align='center'><b>Cancel</b></p>"	,150+500-120,	40+(40*12),	120,20,mc_pbem);


		if(opts.multi=="arena") // arena mode
		{
			butt_press("rooms");
		}
		else
		if(_root.pbem_id)
		{
			butt_press("pbem_start");
		}
		else
		{
			butt_press("styles"); // recap current room
			butt_press("rooms");
		}
		
	}
	
	var update_do;
	
	function exit()
	{
		if(opts.style=="popup")
		{
			clean();
		}
		else
		{
			up.state_next=opts.state_next;
		}
	}
	
	function clean()
	{
		if(opts.style=="popup")
		{
			if(_root.popup != this) { return; }
			_root.popup=null;
		}
		_root.lobby=null;
		
		if(opts.multi=="arena") // arena mode
		{
			prepgame();
		}
		else
		{
		
//tell the world we are not paying attention anymore

			gmsgsend( { gcmd:"set" , gnam:gamename , gvar:"status" , gset:"idle" } );
			
		}
		

		MainStatic.update_remove(_root.updates,update_do);
		update_do=null;
		
//		mcreq.removeMovieClip();
		mc.removeMovieClip();mc=null;
		mcb.removeMovieClip();mcb=null;
		
//		Mouse.removeListener(this);
		
		_root.poker.clear_clicks();
		_root.poker.ShowFloat(null,0);
	}
	
	function prepgame()
	{
	var i,j;
	var s;
	var a,aa;
	
		gamedata=new Object();
		
		gamedata.gamename=gamename;
		
		gamedata.player_idx=0; // will be 1 or 2 for 1up or 2up 0 for watcher
		for(i=0;i<players.length;i++)
		{
			if(players[i][0]==username)
			{
				gamedata.player_idx=i+1;
			}
			
		}
		
		gamedata.xup=[];
		
// build the 1up 2up etc settings into an easy to use array for each player

		for(i=1;i<10;i++)
		{
			if(styles[i+"up"])
			{
				gamedata.xup[i]=[];
				
				s=Clown.pak_to_str(styles[i+"up"]);
				a=s.split("&");
				for(j in a)
				{
					aa=a[j].split("=");
					if( (aa[0]!="") && (aa[1]) )
					{
						gamedata.xup[i][aa[0]]=aa[1];
					}
				}
			}
		}
		
		
				
		gamedata.styles=styles; // various settings, eg seed
		styles=null;
		
		gamedata.players=new Array();
		for(i=0;i<players.length;i++) // names of each player, grab data from users
		{
			gamedata.players[i]={ name:players[i][0] };
		}
		players=null;
		users=null;
		
		gamedata.players_numof=players_max;
		exit();
		
		if(opts.state_next)
		{
			up.state_next=opts.state_next;
		}
		else
		{
			up.state_next="play";
		}
	}
	
	function watchgame()
	{
		prepgame();
	}
	
	function startgame()
	{
	var i;
	var ingame=false;
		
		if(userauth=="owner")
		{
			gmsgsend( { gcmd:"start" , gnam:gamename , gtyp:"go"} );
		}
		for(i=0;i<players.length;i++)
		{
			if(players[i][0]==username)
			{
				ingame=true;
			}
		}
		if(!ingame) // we are just the host
		{
			state="users";
			thunk();
			return;
		}
		prepgame();				
	}
	
	function thunk_users()
	{
	var s;
	var i,aa;
	var nam,stat;
	var ingame=false;
	var meingame=false;
	
		s="";
		s+=gamename+" : "+styles["state"]+"<br><br>";
		
		s+="<a href=\"asfunction:_root.lobby.lineclick,user/0\">";
		for(i=0;i<players_max;i++)
		{
			nam="";
			stat="";
			if(players[i][0]) { nam=players[i][0]; stat=players[i][1]; }
			s+="<b>"+(i+1)+"UP : </b>"+nam+" : "+stat+"<br>";
			
			if(nam==username) // we are in this game
			{
				ingame=true;
			}
			
			if(nam=="me") // ignore mes, they are not real people
			{
				meingame=true;
			}
		}
		s+="</a><br>";
		
		for(i=1;i<users.length;i++)
		{
			aa=users[i];
			s+="<a href=\"asfunction:_root.lobby.lineclick,user/"+i+"\">";
			s+="<b>" + aa[0] + "</b> : " + aa[1] + "</a><br>";
		}
		
		if(users_str=="")
		{
			gizmo_Tlist.str=s;
		}
		else
		{
			gizmo_Tlist.str=users_str;
		}
		
		if(userauth=="owner")
		{
			if((players.length==players_max)&&(state!="start")&&(!meingame)) // ready to roll
			{
				butts["start"]._visible=true;
			}
			
			s="";
			s+="<p><b>Please select which players will play in the next game.</b></p>";
			gfx.set_text_html(mcs[0].tf,22,0xccffcc,s);
		}
		else
		{
			if(state=="users")
			{
				for(i=1;i<users.length;i++)
				{
					if(users[i][0]==username)
					{
						if(users[i][1]!="pickme")
						{
							butts["pickme"]._visible=true;
						}
					}
				}
			}
			
			if(state=="start")
			{
				s="";
				s+="<p><b>You have been choosen. Click start if you want to play, cancel if you do not.</b></p>";
				gfx.set_text_html(mcs[0].tf,22,0xccffcc,s);
			}
			else
			{
				s="";
				s+="<p><b>Please wait while the host decides who will play in the next game.</b></p>";
				gfx.set_text_html(mcs[0].tf,22,0xffcccc,s);
			}
		}
		
		if(styles["state"]=="playing") // watch an in progress game?
		{
			if(ingame)
			{
				s="";
				s+="<p><b>You are in the midle of playing this game and should rejoin.</b></p>";
				gfx.set_text_html(mcs[0].tf,22,0xccffcc,s);
				butts["rejoin"]._visible=true;
				butts["start"]._visible=false;
			}
			else
			{
				s="";
				s+="<p><b>A game is in progress, why not watch them play?.</b></p>";
				gfx.set_text_html(mcs[0].tf,22,0xccffcc,s);
				butts["watch"]._visible=true;
				butts["start"]._visible=false;
			}
		}
	
	}
	
	function thunk()
	{
	var s;
	var i,aa;
	var nam,stat;
	var ready;

		butts["rooms"]._visible=false;
		butts["host"]._visible=false;
		butts["styles"]._visible=false;
		butts["users"]._visible=false;
		butts["pickme"]._visible=false;
		butts["start"]._visible=false;
		butts["cancel"]._visible=false;
		butts["watch"]._visible=false;
		butts["rejoin"]._visible=false;
		butts["pbem"]._visible=false;
	
		mc_base._visible=true;
		mc_pbem._visible=false;
				
		if(styles["ups"])
		{
			if(styles["ups"]=="-")
			{
				players=new Array();
			}
			else
			{
				players=styles["ups"].split(";");
				for(i=0;i<players.length;i++)
				{
					players[i]=players[i].split("/");
				}
			}
		}
					
		switch(state)
		{
	
			case "start":
				for(i=0;i<players.length;i++)
				{
					if(players[i][0]==username)
					{
						if(players[i][1]!="ready") // only show start button if we have yet to say we are ready
						{
							butts["start"]._visible=true;
						}
					}
				}
				butts["cancel"]._visible=true;
				ready=0;
				for(i=0;i<players.length;i++)
				{
					if(players[i][1]=="cancel") // any player can cancel
					{
						state="users";
						players=new Array();
						gmsgsend( { gcmd:"set" , gnam:gamename , gvar:"status" , gset:"idle" } );
						thunk();
						return;
					}
					if(players[i][1]=="ready")
					{
						ready++;
					}
				}
				if(ready==players_max)
				{
					butt_press("styles");
					state="starting";
					thunk();
					return;
				}
				thunk_users();
				
				butts["cancel"]._visible=true;
			break;
			
			case "rooms":
			
				butts["rooms"]._visible=true;
				butts["host"]._visible=true;
				butts["users"]._visible=true;
				butts["styles"]._visible=true;
				butts["pbem"]._visible=true;
		
				s="";
				s+="<p><b>Please select an active gameroom to join or choose to host your own.</b></p>";
				gfx.set_text_html(mcs[0].tf,22,0xccffcc,s);
				
				gizmo_Tlist.str=rooms_str;
			break;
			
			
			
			case "users":
				
				butts["rooms"]._visible=true;
				butts["host"]._visible=true;
				butts["users"]._visible=true;
				butts["styles"]._visible=true;
				
				thunk_users();
				
			break;
			
			case "styles":
				
				butts["rooms"]._visible=true;
				butts["host"]._visible=true;
				butts["users"]._visible=true;
				butts["styles"]._visible=true;
				
				s="";
				s+="<p><b>Behold the style settings of the current game in the current gameroom.</b></p>";
				gfx.set_text_html(mcs[0].tf,22,0xffffff,s);
				
				s="";
				for(i in styles)
				{
					if( styles[i] )
					{
						s+="<a href=\"asfunction:_root.lobby.lineclick,style/"+i+"\">";
						s+="<b>" + i + "</b> : " + styles[i]  + "</a><br>";
					}
				}
							
				if(styles_str=="")
				{
					gizmo_Tlist.str=s;
				}
				else
				{
					gizmo_Tlist.str=styles_str;
				}
				
			break;
			
			case "starting":
				
				s="";
				s+="<p><b>Starting Game.</b></p>";
				gfx.set_text_html(mcs[0].tf,22,0xffffff,s);
				
				gizmo_Tlist.str="";

				
			break;
			
			case "pbem": // special start an email mc
								
				mc_base._visible=false;
				mc_pbem._visible=true;
				
				butts["ok"]._visible=true;
				butts["cancel"]._visible=true;
				
				s="";
				s+="<p><b>Please enter <font color=\"#00ffff\">your email</font> and then the email of the friend you wish to play with. Further instructions will be emailed to you after you click on OK.</b></p>";
				gfx.set_text_html(mcs[0].tf,22,0xffffff,s);
				
			break;
			
			case "pbem_start": // starting a pbem game using data from _root.pbem_*
					
				s="";
				s+="<p>Preparing the PBEM game for play, click START when the button becomes visible.</p>";
				gfx.set_text_html(mcs[0].tf,22,0xffffff,s);
				
				if(pbem_str=="OK")
				{
					butts["start"]._visible=true;
					gizmo_Tlist.str="Game hosting initiated. Press START to continue.";
				}
				else
				{
					gizmo_Tlist.str=pbem_str;
				}
				
			break;
			
		}
		
		if(opts.multi=="arena") // arena mode so hide a buncha buttons that we do not need
		{
			butts["close"]._visible=false;
			butts["styles"]._visible=false;
			butts["users"]._visible=false;
			butts["pickme"]._visible=false;
			butts["start"]._visible=false;
			butts["watch"]._visible=false;
			butts["rejoin"]._visible=false;
			butts["pbem"]._visible=false;
		}
		
	}
	
	
	function butt_over(s)
	{
		if(_root.lobby != this)	{ return; }
		
		butts[s]._alpha=100;
		
		switch(s)
		{
			case "close":
				_root.poker.ShowFloat("Close this plopup.",25*10);
			break;
			case "rooms":
				_root.poker.ShowFloat("List the active gamerooms you can join.",25*10);
			break;
			case "host":
				_root.poker.ShowFloat("Host your own gameroom.",25*10);
			break;
			case "styles":
				_root.poker.ShowFloat("View or modify the game style settings.",25*10);
			break;
			case "users":
				_root.poker.ShowFloat("List the available players in your current game room.",25*10);
			break;
			case "pickme":
				_root.poker.ShowFloat("Signal to the owner of the current gameroom that you wish to play in the next game.",25*10);
			break;
			case "start":
				_root.poker.ShowFloat("Start the game with the selected players. (All players must click start before the game can begin)",25*10);
			break;
			case "cancel":
				_root.poker.ShowFloat("Cancel this game start request.",25*10);
			break;
			case "watch":
				_root.poker.ShowFloat("Watch the game being played in this gameroom.",25*10);
			break;
			case "pbem":
				_root.poker.ShowFloat("Play with a friend through emails and online.",25*10);
			break;
			case "ok":
				_root.poker.ShowFloat("Sends a confirmation email to the first address listed above with further instructions.",25*10);
			break;
			case "cancel":
				_root.poker.ShowFloat("Return to the previous menu.",25*10);
			break;
		}
	}
	
	function butt_out(s)
	{
		if(_root.lobby != this) { return; }
		
		_root.poker.ShowFloat(null,0);
	}
	
	function butt_press(s)
	{
	var p;
	var i;
	
		if(_root.lobby != this) { return; }
		
		switch(s)
		{
			case "close":
				if(steady)
				{
					up.do_str("lobby_close");
					done=true;
					mc.dx=_root.scalar.ox;
				}
			break;
			
			case "ok":
			
				if(tfs[0].text=="your@email") // they didnt type anything so just cancel
				{
					gmsgsend( { gcmd:"rooms" , gnam:gamename } );
				}
				else
				{
					gmsgsend( { gcmd:"rooms" , gnam:gamename } );
					
					_root.comms.send_pbemstart(gamebasename,tfs[0].text,tfs[1].text);			
					done=true;
					mc.dx=_root.scalar.ox;
					
				}
				
			break;
			
			case "cancel": // return to main view
			case "rooms":			
			
				gmsgsend( { gcmd:"rooms" , gnam:gamename } );
				
			break;
			
			case "host":			
			
				if(opts.multi=="arena") // arena mode
				{
					gmsgsend( { gcmd:"host"  , gnam:gamename , gvar:"multi" , gset:"arena" } );
				}
				else
				{
					gmsgsend( { gcmd:"host"  , gnam:gamename , gvar:"multi" , gset:"ws" } );
					gmsgsend( { gcmd:"style" , gnam:gamename , gvar:"seed" , gset:(Math.floor(65536*Math.random())&0xffff)  } ); // pick a random seed
				}
				
			break;
			
			case "styles":
			
				gmsgsend( { gcmd:"styles" , gnam:gamename } );
				
			break;
			
			case "users":
			
				gmsgsend( { gcmd:"users" , gnam:gamename } );
				
			break;
			
			case "pickme":
			
				gmsgsend( { gcmd:"set" , gnam:gamename , gvar:"status" , gset:"pickme" } );
				
			break;
			
			case "start":
			
				if(state=="pbem_start")
				{
					xups["imgurl"]=escape(_root.Login_Img);
					check_send_xup();
					
					butt_press("styles");
					state="starting";
				}
				else
				if(userauth=="owner")
				{
					if(players.length==players_max)
					{
						if(state!="start")
						{
							p="";
							for(i=0;i<players.length;i++)
							{
								if(p!="") { p+=";"; }
								p+=players[i][0]+"/idle"; // everyone is idle to start with
							}
							
							
							gmsgsend( { gcmd:"start" , gnam:gamename , garg:p , gtyp:"ready"} );
							xups["imgurl"]=escape(_root.Login_Img);
							check_send_xup();
							gmsgsend( { gcmd:"set" , gnam:gamename , gvar:"status" , gset:"ready" } ); // say we, the owner is ready
			
							state="start";
						}
					}
				}
				else
				if(state=="start")
				{
					xups["imgurl"]=escape(_root.Login_Img);
					check_send_xup();					
					gmsgsend( { gcmd:"set" , gnam:gamename , gvar:"status" , gset:"ready" } );
					
				}
				
				thunk();
				
			break;
			
			case "cancel":
			
				if(state=="start")
				{
					gmsgsend( { gcmd:"set" , gnam:gamename , gvar:"status" , gset:"cancel" } );
				}
				
			break;
			
			case "rejoin":
			case "watch":
			
				watchgame();
				
			break;
			
			case "pbem":
			
				state="pbem";
				thunk();
				
			break;
			
			
			case "pbem_start":
			
				pbem_str="Connecting.";
				
				gmsgsend( { gcmd:"pbem_start" , gnam:gamename , gpid:Math.floor(_root.pbem_id) , gphash0:escape(_root.pbem_hash0) , gphash1:escape(_root.pbem_hash1) } );

				state="pbem_start";
				thunk();
				
			break;
		}
	}
	
var done_simple_login=false;
	function gmsgsend(msg)
	{
	var idx;
	var s;
	
		if(_root.sock.connected)
		{
			if((_root.skip_wetlogin)&&(!done_simple_login)) // try simple login
			{
				if(_root.name)
				{
					_root.sock.chat("/login "+_root.name);
					done_simple_login=true;
				}
			}
				
			_root.sock.gmsg( msg , delegate(gmsgback,msg) );
			lastmsg=msg;
			_root.sock.gmsg( null , delegate(gmsgback,null) ); // request all other game msgs as well
			
			
//dbg.print("*****SEND:"+msg.gcmd);
//dbg.dump(msg);
		}
	}
	
	var lastmsg;
	
	function gmsgback(msg,sentmsg)
	{
	var idx;
	var s;
	var a,i,aa;
	
//	dbg.print(msg.gcmd);
	
		if(_root.lobby != this) { return; }
		
		if(!sentmsg) // incoming
		{
//dbg.print("*****PUSH:"+msg.gcmd);
//dbg.dump(msg);

			switch(msg.gcmd)
			{
				case "start":
				
					players=msg.garg.split(";");
					for(i=0;i<players.length;i++)
					{
						players[i]=players[i].split("/");
					}
//dbg.print(msg.garg)					
					state="start";
					thunk();
					
				break;
				
				case "set":
				
/*
					if(msg.gvar=="imgurl")
					{
						aa=users[msg.guser];
						aa[msg.gvar]=unescape(msg.gset);						
						thunk();
					}
					else
*/
					if(msg.gvar=="status")
					{
						for(i=0;i<players.length;i++)
						{
							aa=players[i];
							if(aa[0]==msg.guser)
							{
								aa[1]=msg.gset;
								break;
							}
						}						
						for(i=1;i<users.length;i++)
						{
							aa=users[i];
							if(aa[0]==msg.guser)
							{
								aa[1]=msg.gset;
								break;
							}
						}
						if(i==users.length) // not found so add to list
						{
							users[i]=new Array();
							users[i][0]=msg.guser;
							users[i][1]=msg.gset;
							users[msg.guser]=users[i];
							users[i]["name"]=msg.guser;
							users[i]["state"]=msg.gset;
						}
						
						check_send_ups();

						thunk();
					}
				break;
				
				case "style":
									
					styles[msg.gvar]=msg.gset;
					thunk();
					
				break;
								
				default:
/*
					s="";
					for(idx in msg)
					{
						s+=idx+"="+msg[idx]+"<br>";
					}					
					gizmo_Tlist.str=s;
*/
				break;
			}
		}
		else
//		if(sentmsg==lastmsg) // only care about one return msg at a time, ignore all other return msgs
		{
//dbg.print("*****PULL:"+sentmsg.gcmd+":"+msg.gcmd);
//dbg.dump(msg);

			switch(sentmsg.gcmd)
			{
				case "rooms":
				
					a=msg.gret.split(",");
					if(a[0]=="OK")
					{
						rooms=new Array();
						
						s="";
						s+=gamename+" : "+"searching"+"<br><br>";
		
						for(i=1;i<a.length;i++)
						{
							aa=a[i].split(":");							
							rooms[i]=aa;
							
							s+="<a href=\"asfunction:_root.lobby.lineclick,room/"+i+"\">";
							s+="<b>" + aa[0] + "</b> : " + aa[1] + " : " + aa[3] + "</a><br>";
						}
						rooms_str=s;
					}
					else
					{
						rooms_str=msg.gret;
					}
					
					state="rooms";
					thunk();
					
				break;
				
				case "styles":
				
					a=msg.gret.split(",");
					if(a[0]=="OK")
					{
						styles=new Array();
						
						for(i=1;i<a.length;i++)
						{
							aa=a[i].split(":");							
							styles[aa[0]]=aa[1];
						}
						styles_str="";
					}
					else
					{
						styles_str=msg.gret;
					}
					
					if(state=="starting") // do exit with all game settings
					{
						startgame();
					}
					else
					{
						state="styles";
						thunk();
					}
					
					if(opts.multi=="arena") // arena mode, exit after getting styles for a room
					{
						exit();
					}
						
				break;
				
				case "users":
				
					a=msg.gret.split(",");
					if(a[0]=="OK")
					{
						users=new Array();
						
						for(i=1;i<a.length;i++)
						{
							aa=a[i].split(":");
							
							aa.name=aa[0];
							aa.status=aa[1];
							
							users[ i ]=aa;
							users[ aa.name ]=aa;
						}
						
						a=msg.gret2.split(",");	// fill in owners with my name and then the list of owners
						owners=new Array();
						username="me";
						userauth="user";
						for(i=0;i<a.length;i++)
						{
							owners[i]=a[i];
							if(i>0)
							{
								if(a[i]==a[0].toLowerCase())
								{
									userauth="owner";
								}
							}
							else
							{
								username=a[0];
							}
						}
						users_str="";
					}
					else
					{
						users_str=msg.gret;
					}
				
					if( state != "pbem_start" )
					{
						players=new Array(); // forget anyone who may have been picked					
						state="users";
					}
					thunk();
					
				break;
				
				case "host":
				
					a=msg.gret.split(",");
					if(a[0]=="OK")
					{
						if(opts.multi=="arena") // arena mode
						{
							gizmo_Tlist.str="Game arena hosting initiated.";
							butt_press("styles");
						}
						else
						{
							gizmo_Tlist.str="Game hosting initiated. Fetching list of users in room.";
							butt_press("styles");
							butt_press("users");
						}
					}
					else
					{
						gizmo_Tlist.str=msg.gret;
					}
				
				break;
				
				case "pbem_start":
				
					a=msg.gret.split(",");
					if(a[0]=="OK")
					{
						pbem_str="OK";
					}
					else
					{
						pbem_str=msg.gret;
					}
					thunk();
				
				break;
				
				
				case "set": //do nothing here, we get another msg that does something instead
				case "start": //do nothing here, we get another msg that does something instead
				break;
				
				default:
/*
					s="";
					for(idx in msg)
					{
						s+=idx+"="+msg[idx]+"<br>";
					}					
					gizmo_Tlist.str=s;
*/				
				break;
			}
		}
	}
	
	function lineclick(str)
	{
	var a,i;
	var idx;
	var s;
	
		if(_root.lobby != this) { return; }
		
		a=str.split("/");
		
		switch(a[0])
		{
			case "room":
							
				_root.sock.chat("/join "+ rooms[ Math.floor(a[1]) ][0] );
				
				butt_press("styles");
				butt_press("users");
			
			break;
			
			case "user":
			
				if((userauth=="owner")&&(state!="start"))
				{
					idx=Math.floor(a[1]);
					
					if(idx==0) // clear out all selected players
					{
						players=new Array();
					}
					else
					{
						if(users[idx])
						{
							for(i=0;i<players.length;i++)
							{
								if(players[i][0]==users[idx][0]) break;
							}
							if(i==players.length) // name is not allowed in list twice
							{
								if(players.length==players_max)
								{
									players=new Array();
								}
								players[players.length]=[ users[idx][0] , "idle" ];
							}
						}
					}
					
					check_send_ups();

			}
				thunk();
				
			break;
		}
		
	}
	
	function check_send_ups()
	{
	var i,s;
	
		s="";
		for(i=0;i<players.length;i++)
		{
			if(s!="") { s+=";"; }
			s+=players[i][0]+"/"+players[i][1];
		}
		if(s=="") { s="-"; }
		if( (styles.ups!=s) && (userauth=="owner") )
		{
			gmsgsend( { gcmd:"style" , gnam:gamename , gvar:"ups" , gset:s } );
			styles.ups=s;
		}
	}
		
	function check_send_xup()
	{
	var xup;
	var i,s;
		
		xup=null;
		for(i=0;i<players.length;i++)
		{
//dbg.print( username +" : "+ i + " : " + players[i][0] );
			if( username == players[i][0] )
			{
				xup=(i+1)+"up";
				break;
			}
		}
		if(!xup) return; // not a player
		
		s="";
		for(i in xups)
		{
			s+="&"+i+"="+xups[i];
		}
		s=Clown.str_to_pak(s);
		
		if(styles[xup]!=s)
		{
			gmsgsend( { gcmd:"style" , gnam:gamename , gvar:xup , gset:s } );
			styles[xup]=s;
		}
	}

	function onRelease()
	{
		if(_root.lobby != this) { return; }

		if(steady)
		{
			done=true;
			mc.dx=_root.scalar.ox;
		}
	}

	function update()
	{
	var idx;
	var b;
	
	
		if( (_root.lobby != this) || (_root.pause) )
		{
			return;
		}
		
		update_gizmos(_root.poker.snapshot());


		for(idx in butts)
		{
			b=butts[idx];
			
			if(b._alpha!=b._alpha_dest)
			{
				if(b._alpha_dest>b._alpha)
				{
					b._alpha+=1;
				}
				else
				if(b._alpha_dest<b._alpha)
				{
					b._alpha-=1;
				}
			}
		}
		
		
		mc._x+=(mc.dx-mc._x)/4;

		if( (mc._x-mc.dx)*(mc._x-mc.dx) < (16*16) )
		{
			steady=true;
			if(done)
			{
				exit();
			}
		}
		else
		{
			steady=false;
		}
		
	}
			
	function new_butt(id,s,x,y,w,h,mcu)
	{
	var b;
	
		if(mcu)
		{
			b=gfx.create_clip(mcu,null);
		}
		else
		{
			b=gfx.create_clip(mc_base,null);
		}
		b._x=x;
		b._y=y;
		
		set_butt(b,id);
		
		b.tf=gfx.create_text_html(b,null,0,0,w,h+4);
		gfx.clear(b);
		b.style.fill=0x80000000;
		b.style.out=0x80000000;
		gfx.draw_box(b,3,-4,-4,w+8,h+8);
		gfx.set_text_html(b.tf,16,0xffffff,s);
		
		b._alpha_dest=60;
		b._alpha=b._alpha_dest;
		butts[id]=b;
		
		b.cacheAsBitmap=true;
		
		return b;
	}
	
	function set_butt(b,id)
	{
		b.onRollOver=delegate(butt_over,id);
		b.onRollOut=delegate(butt_out,id);
		b.onReleaseOutside=delegate(butt_out,id);
		b.onRelease=delegate(butt_press,id);
	}
	

	var gizmo;
	
	var gizmoT;
	var gizmoM;
	var gizmoB;

	
	var gizmo_Tlist;
	var gizmo_Tscroll;
	var gizmo_Tscroll_knob;
	
	var gizmo_Blist;
/*	
	var gizmo_Bscroll;
	var gizmo_Bscroll_knob;
*/	
	var gizmo_Titems;
	var gizmo_Bitems;
	
	var gizmo_send;

	var typehere;
	
	var keyListener;
	
	var foreground=0xffffff;
	var background=0x008000;
	
	function update_gizmos(snapshot)
	{
		gizmo.mc.globalToLocal(snapshot);
		gizmo.focus=gizmo.input(snapshot);		
		gizmo.update();
	}
	
	function setup_gizmos()
	{
	var i;
	
	var w,h,ss;
	var g,gmc,gp;
		
	var hrats=[23,4,8];
	var ty;
	
		w=360;
		h=400;
		ss=20;
	
// master gizmo
		gizmo=new GizmoMaster#(CLASSVERSION)({mc:mc_base});
		gizmo.top=gizmo;
		g=gizmo;
		g.set_area(150,100,w,h);
		
		ty=0;
		
		gp=gizmo;
		
		g=gp.child(new Gizmo#(CLASSVERSION)(gp))
		g.set_area(0,ty*ss,w,hrats[0]*ss);
		gizmoT=g;
		
		ty+=hrats[0];
		
		g=gp.child(new Gizmo#(CLASSVERSION)(gp))
		g.set_area(0,ty*ss,w,hrats[1]*ss);
		gizmoM=g;
		
		ty+=hrats[1];
		
		g=gp.child(new Gizmo#(CLASSVERSION)(gp))
		g.set_area(0,ty*ss,w,hrats[2]*ss);
		gizmoB=g;
		
		gp=gizmoT;
// scroll slider container		
		g=gp.child(new Gizmo#(CLASSVERSION)(gp))
		g.set_area(w-ss*1,ss,ss,(hrats[0]-1)*ss);
		g.mc.style={	fill:0x80000000+foreground,	out:0xff000000+foreground,	text:0xff000000+foreground		};
		draw_boxen(g.mc,0,0,g.w,g.h);
	
		gizmo_Tscroll=g;
		
		gp=g;
// scroll slider knob
		g=gp.child(new GizmoKnob#(CLASSVERSION)(gp))
		g.set_area(0,gp.h-ss*4,ss,ss*4);
		
		gmc=#(GFX).create_clip(g.mc,null,0,0,100,100);
		gmc.style={	fill:0x80000000+foreground,	out:0xff000000+foreground,	text:0xff000000+foreground		};
		draw_puck(gmc,0,0,ss,ss*4);
		g.mc_base=gmc;
		
		gmc=#(GFX).create_clip(g.mc,null,0,0,100,100);
		gmc.style={	fill:0xff000000+foreground,	out:0xff000000+foreground,	text:0xff000000+foreground		};
		draw_puck(gmc,0,0,ss,ss*4);
		g.mc_over=gmc;
		
		gmc=#(GFX).create_clip(g.mc,null,0,0,100,100);
		gmc.style={	fill:0xff000000+foreground,	out:0xff000000+foreground,	text:0xff000000+foreground		};
		draw_puck(gmc,0,0,ss,ss*4);
		g.mc_down=gmc;
		
		gizmo_Tscroll_knob=g;

		gp=gizmoT;
//a TF scroll area
		g=gp.child(new GizmoText#(CLASSVERSION)(gp));
		g.set_area(0,ss,w-ss*1,(hrats[0]-1)*ss);
		g.tf_fmt.size=ss-2;
		g.tf_fmt.color=0xff000000+foreground;
		g.vgizmo=gizmo_Tscroll_knob;
		
		gizmo_Tlist=g;


//		gizmo_Bitems=[];
		gizmo_Titems=[];
		
//		gizmo_Blist.items=gizmo_Bitems;
//		gizmo_Blist.onClick=delegate(Bclick);
		
/*
		
		gp=gizmoM;
		g=gp.child(new Gizmo#(CLASSVERSION)(gp))
		g.set_area(0,0,gp.w-ss*1,ss*2);
		g.mc.style={	fill:0x80000000+foreground,	out:0xff000000+foreground,	text:0xff000000+foreground		};
		draw_boxen(g.mc,0,0,g.w,g.h);
		
		typehere=#(GFX).create_text_edit(gizmoM.mc,null,ss*0.25,ss*0.25,w-ss*1.5,ss*1.5);
		typehere.setNewTextFormat(#(GFX).create_text_format(ss+2,0xff000000+foreground));
		typehere.text="";
		
//		typehere.onEnterKeyHasBeenPressed=delegate(onEnter);
*/		
		gizmo.update();
	}
	
	function draw_boxen( mc , x,y , w,h )
	{
	var sw,sh,ss;

		sw=w/16;
		sh=h/16;
		ss=sw; if(ss>sh) { ss=sh; }
		
		mc.lineStyle(undefined);
		mc.beginFill(mc.style.fill&0xffffff,((mc.style.fill>>24)&0xff)*100/255);

		mc.moveTo(x+ss,y+ss);
		mc.lineTo(x+w-ss,y+ss);
		mc.lineTo(x+w-ss,y+h-ss);
		mc.lineTo(x+ss,y+h-ss);
		mc.lineTo(x+ss,y+ss);
		
		mc.moveTo(x+ss*2,y+ss*2);
		mc.lineTo(x+w-ss*2,y+ss*2);
		mc.lineTo(x+w-ss*2,y+h-ss*2);
		mc.lineTo(x+ss*2,y+h-ss*2);
		mc.lineTo(x+ss*2,y+ss*2);
		
		mc.endFill();
	}
	
	function draw_puck( mc , x,y , w,h )
	{
	var sw,sh,ss;

		sw=w/16;
		sh=h/16;
		ss=sw; if(ss>sh) { ss=sh; }
		
		mc.lineStyle(undefined);
		mc.beginFill(mc.style.fill&0xffffff,((mc.style.fill>>24)&0xff)*100/255);

		mc.moveTo(x+ss*3,y+ss*3);
		mc.lineTo(x+w-ss*3,y+ss*3);
		mc.lineTo(x+w-ss*3,y+h-ss*3);
		mc.lineTo(x+ss*3,y+h-ss*3);
		mc.lineTo(x+ss*3,y+ss*3);
		
		mc.endFill();
	}

	function draw_box( mc , x,y , w,h )
	{
	var sw,sh,ss;

		sw=w/16;
		sh=h/16;
		ss=sw; if(ss>sh) { ss=sh; }
		
		mc.lineStyle(undefined);
		mc.beginFill(mc.style.fill&0xffffff,((mc.style.fill>>24)&0xff)*100/255);

		mc.moveTo(x+ss*1,y+ss*1);
		mc.lineTo(x+w-ss*1,y+ss*1);
		mc.lineTo(x+w-ss*1,y+h-ss*1);
		mc.lineTo(x+ss*1,y+h-ss*1);
		mc.lineTo(x+ss*1,y+ss*1);
		
		mc.endFill();
	}
	
	
/*
	var mcreq;
	
	function showreq(s)
	{
		if(_root.lobby != this) { return; }
	
		mcreq=gfx.create_clip(_root.mc_popup,null); // requester
		mcreq.cacheAsBitmap=true;
		gfx.clear(mcreq);
		mcreq.style.out=0xff000000;
		mcreq.style.fill=0xcc000000;
		gfx.draw_box(mcreq,10,100+16,150+16,600-32,300-32);
		mcreq.tf=gfx.create_text_html(mcreq,null,150,200,500,250);
		
		gfx.set_text_html(mcreq.tf,22,0xffffff,s);
				
		mcreq.click=delegate(clickreq,null);
		
		_root.lobby=mcreq;
	}
	
	function clickreq(s)
	{
		switch(s)
		{
			case "play":
				hidereq();
			break;
			
			case "close":
				hidereq();
			break;
		}
	}
	
	function hidereq()
	{
		if(_root.lobby != mcreq) { return; }
		
		mcreq.removeMovieClip();
		
		_root.lobby=this;
	}
*/

}
