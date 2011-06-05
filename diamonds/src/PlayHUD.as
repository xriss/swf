/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) Kriss Daniels 2007 http://www.XIXs.com
//
/*+-----------------------------------------------------------------------------------------------------------------+*/

#include "src/opts.as"

class PlayHUD
{
	var up;
	
	var mc;
	var mc2;
	var mc3;
	var mc4;
	var mc5;
	
	var mcs
	
	var mc_play;
	var tf_play;
	var mc_turn;
	
	var tf_pts1;
	var tf_pts2;
	var mc_pts1;
	var mc_pts2;
	
	var mc_rgbs;
	var tf_rgbs;
	
	var mc_stage;
	
	var butts;
	var butt_ids;
	
	var points;
	var points1;
	var points2;
	var chaser;
	
	var mc_choose1;
	var mc_choose2;
	var choosen;
	
	var hover;
	
//	var qual_num;
	
	var last_artist;
	var last_track;
	
	var last_pct;
		
	function PlayHUD(_up)
	{
		up=_up;
	}
	
	function delegate(f,d)	{	return com.dynamicflash.utils.Delegate.create(this,f,d);	}

	function days_to_string(days)
	{
		var d;
		var s;
		
		d=new Date();
		d.setTime(days*24*60*60*1000);
		
		s=alt.Sprintf.format("%04d%02d%02d",d.getFullYear(),d.getMonth()+1,d.getDate());
		
		return s;
	}
	
	function setup()
	{
	var i;
	
		last_artist="";
		last_track="";
	
		mc=gfx.create_clip(up.mc,null);
//		gfx.dropshadow(mc , 2 , 45, 0x000000, 1, 4, 4, 2, 3);
		
		
		mc_play=gfx.create_clip(mc,null);
		tf_play=gfx.create_text_html(mc_play,null,800-200,10,200,100+10);
		set_butt(mc_play,"mp3")
		
		
		points=0;
		points1=0;
		points2=0;
		chaser=0;
		
		butts=[];
		butt_ids={};
		tf_rgbs=[];
		
		
		

		mcs=new Array()
		
		for(i=0;i<interface_lines.length;i++)
		{
		var lin=interface_lines[i];
		var args=lin.split(",");
		var nam=args[0]
		var nams=nam.split("_");
		var m;
		
			m=gfx.add_clip(mc,"swf_interface",null);
			m.gotoAndStop(i+1);
			
			m._visible=false;
			
			m.nam=nam;
			m.nams=nams;
			
			switch(nams[0])
			{
				case "back":
						m._visible=true;
				break;
				case "play":
					switch(nams[1])
					{
						case "counters":
							m._visible=true;
						break;
						
						case "single":
						case "score1":
							if(!up.gamecomms)
							{
								m._visible=true;
							}
						break;
						
						case "restart":
						case "menu":
							if(!up.gamecomms)
							{
								m._visible=true;
								make_button(m);
							}
						break;
					}
				break;
			}
			
			m.cacheAsBitmap=true;
			
			mcs[ i ]=m;
			mcs[ nam ]=m;
		}
		
		
		if(!up.gamecomms)
		{
			mc_pts1=gfx.create_clip(mc,null);			
			mc_pts1.nam="score";
			make_button(mc_pts1);
			tf_pts1=gfx.create_text_html(mc_pts1,null,200+10,20-20,400-20,60);
		
			mc_rgbs=gfx.create_clip(mc,null);
			gfx.dropshadow(mc_rgbs , 2 , 45, 0x000000, 1, 4, 4, 2, 3);
			
			tf_rgbs[0]=gfx.create_text_html(mc_rgbs,null,200+75,550-10,50,50);
			tf_rgbs[1]=gfx.create_text_html(mc_rgbs,null,250+75,550-10,50,50);
			tf_rgbs[2]=gfx.create_text_html(mc_rgbs,null,300+75,550-10,50,50);
			tf_rgbs[3]=gfx.create_text_html(mc_rgbs,null,350+75,550-10,50,50);
			tf_rgbs[4]=gfx.create_text_html(mc_rgbs,null,400+75,550-10,50,50);
		
/*
			butts[butts.length]=new_butt("restart","<p align='center'><b>Restart</b></p>",10+30,120+(40*0),120,20);
			butts[butts.length]=new_butt("about","<p align='center'><b>About</b></p>",10+30,120+(40*1),120,20);
			butts[butts.length]=new_butt("high","<p align='center'><b>Scores</b></p>",10+30,120+(40*2),120,20);
			butts[butts.length]=new_butt("logoff","<p align='center'><b>Log Out</b></p>",10+30,120+(40*4),120,20);
			butts[butts.length]=new_butt("gamemode","<p align='center'><b>Game Mode</b></p>",10+30,120-(40*1),120,20);
			butts[butts.length]=new_butt("menu","<p align='center'><b>Main Menu</b></p>",10+30,600-100-(40*0),120,20);
			
			butts[butts.length]=new_text("seed","<p align='center'><b>"+days_to_string(up.up.game_seed)+"</b></p>",24,0,120-(40*2),200,20);		
			butts[butts.length]=new_butt("qual","<p align='center'><b>Q.Best @ 30fps</b></p>",10,600-100-(40*1),180,20);		
			butts[butts.length]=new_butt("full","<p align='center'><b>Full screen</b></p>",10+30,120+(40*3),120,20);
			butts[butts.length]=new_text("name","<p align='center'><b>"+(_root.Login_Name)+"</b></p>",16,0,120+(40*5)-10,200,20);
*/


			
			mc2=gfx.create_clip(mc,null,800-160,230,125,125);
			set_butt(mc2,"name1")

			mc2.tf=gfx.create_text_html(mc2,null,0,100,100,30);
			gfx.set_text_html(mc2.tf,16,0xffffffff,"<p align='center'><b>"+(_root.Login_Name)+"</b></p>");
			
			
			_root.bmc.clear_loading();
			_root.bmc.remember( "Login_Img" , bmcache.create_url , 
			{
				url:_root.Login_Img ,
				bmpw:100 , bmph:100 ,
				hx:0 , hy:0
			} );

			mc3=null;
		
		}
		else
		{
			mc_turn=gfx.create_clip(mc,null);
			mc_turn.tf=gfx.create_text_html(mc_turn,null,10,10,180,90);
			
			gfx.clear(mc_turn);
			mc_turn.style.fill=0x80000000;
			mc_turn.style.out=0x80000000;
			gfx.draw_box(mc_turn,3,5,5,190,100);
		
			set_butt(mc_turn,"turn");
			
		
			mc_rgbs=gfx.create_clip(mc,null);
			gfx.dropshadow(mc_rgbs , 2 , 45, 0x000000, 1, 4, 4, 2, 3);
			tf_rgbs[0]=gfx.create_text_html(mc_rgbs,null,200+75,550-10,50,50);
			tf_rgbs[1]=gfx.create_text_html(mc_rgbs,null,250+75,550-10,50,50);
			tf_rgbs[2]=gfx.create_text_html(mc_rgbs,null,300+75,550-10,50,50);
			tf_rgbs[3]=gfx.create_text_html(mc_rgbs,null,350+75,550-10,50,50);
			tf_rgbs[4]=gfx.create_text_html(mc_rgbs,null,400+75,550-10,50,50);
			
			_root.bmc.clear_loading();
			
			mc4=gfx.create_clip(mc,null,10+30+600+62,125+120+(40*5)+10,125,125);
			set_butt(mc4,"name2")
			_root.bmc.remember( "Login_Img1" , bmcache.create_url , 
			{
				url:unescape(up.gamecomms.xup[1].imgurl) ,
				bmpw:100 , bmph:100 ,
				hx:-50 , hy:-100
			} );
			mc5=null;
			
			mc2=gfx.create_clip(mc,null,10+30+62,125+120+(40*5)+10,125,125);
			set_butt(mc2,"name1")
			_root.bmc.remember( "Login_Img2" , bmcache.create_url , 
			{
				url:unescape(up.gamecomms.xup[2].imgurl) ,
				bmpw:100 , bmph:100 ,
				hx:-50 , hy:-100
			} );
			mc3=null;
		
			butts[butts.length]=new_text("name1","<p align='center'><b>"+(up.gamecomms.players[0].name)+"</b></p>",16,  0,120+(40*5)-10,200,20);
			butts[butts.length]=new_text("name2","<p align='center'><b>"+(up.gamecomms.players[1].name)+"</b></p>",16,600,120+(40*5)-10,200,20);
			
			butts[butts.length]=new_text("ups1","<p align='center'><b>1UP : "+(up.player==0?"You":"Them")+"</b></p>" ,16,  0,150+120+(40*5)-10,200,20);
			butts[butts.length]=new_text("ups2","<p align='center'><b>2UP : "+(up.player==1?"You":"Them")+"</b></p>",16,600,150+120+(40*5)-10,200,20);
			

			if(up.player==0)
			{
				butts[butts.length]=new_butt("pass1","<p align='center'><b>Pass</b></p>", 40,120+(40*4),120,20);
			}
			else
			{
				butts[butts.length]=new_butt("pass2","<p align='center'><b>Pass</b></p>",640,120+(40*4),120,20);
			}

			
			mc_pts1=gfx.create_clip(mc,null);
			mc_pts2=gfx.create_clip(mc,null);
			tf_pts1=gfx.create_text_html(mc_pts1,null,  0,120+(40*3)-10,200,40);
			tf_pts2=gfx.create_text_html(mc_pts2,null,600,120+(40*3)-10,200,40);
			
			mc_choose1=gfx.create_clip(mc,null, 50,120+(40*1)-10,50,50);
			mc_choose2=gfx.create_clip(mc,null,650,120+(40*1)-10,50,50);
			
			set_butt(mc_choose1,"choose1");
			set_butt(mc_choose2,"choose2");
			
			choosen=new Array( new FieldItem({mc:mc_choose1}) , new FieldItem({mc:mc_choose1}) , new FieldItem({mc:mc_choose2}) , new FieldItem({mc:mc_choose2}) );
						
			choosen[0].setup("fire");
			choosen[1].setup("fire");
			choosen[2].setup("fire");
			choosen[3].setup("fire");

			choosen[0].setxy( 50, 50);
			choosen[1].setxy(150, 50);
			choosen[2].setxy( 50, 50);
			choosen[3].setxy(150, 50);
			
			choosen[0].mc._visible=false;
			choosen[1].mc._visible=false;
			choosen[2].mc._visible=false;
			choosen[3].mc._visible=false;
			
			mc_stage=gfx.create_clip(mc,null,400,50);
			mc_stage.tf=gfx.create_text_html(mc_stage,null,-200,0,400,50);
			butt_changed("stage");
			
		}
		
		
		
		show_loaded();

		
		hover=null;
		
//		if(_root.qual_num==undefined) { _root.qual_num=2; }
		
//		butt_changed("qual");
//		butt_changed("full");
//		butt_changed("gamemode");
		
		last_pct=-1;
		
//		up.field.redraw_all();
				
//		Mouse.addListener(this);		
	}
	
	
	function make_button(m)
	{		
		m.nam_alt=m.nams[0]+"2_"+m.nams[1];
		m.onRelease=delegate(click,m);
		m.onRollOver=delegate(hover_on,m);
		m.onRollOut=delegate(hover_off,m);
		m.onReleaseOutside=delegate(hover_off,m);
		
		hover_off(m)
	}
	function hover_on(m)
	{
		if(_root.popup) return;
		
		switch(m.nam)
		{
			case "play_restart":		_root.poker.ShowFloat("Reset game and start again.",25*10);		break;
			case "play_menu":			_root.poker.ShowFloat("Return to main menu.",25*10);		break;
			case "score":				_root.poker.ShowFloat("Click to view high scores.",25*10);		break;
		}
		switch(m.nam)
		{
			case "play_restart":		m._alpha=100;	break;
			case "play_menu":			m._alpha=100;	break;
		}
	}
	
	function hover_off(m)
	{
		switch(m.nam)
		{
			case "play_restart":		m._alpha=80;	break;
			case "play_menu":			m._alpha=80;	break;
		}
		_root.poker.ShowFloat(null,0);
	}
	
	function click(m)
	{
		if(_root.popup) return;
		
		_root.poker.ShowFloat(null,0);
		
		switch(m.nam)
		{
			case "score":
				up.up.high.setup();
			break;
			
			case "play_restart":
			
				up.up.state_next="play";
/*
				if(_root.swish) { _root.swish.clean(); _root.swish=null; }
				_root.swish=new Swish({style:"slide_left",mc:up.mc});
				_root.swish.setup();
*/			
			break;
			case "play_menu":
			
				up.up.state_next="menu";
				
				if(_root.swish) { _root.swish.clean(); _root.swish=null; }
				_root.swish=new Swish({style:"sqr_plode",mc:up.mc});
				_root.swish.setup();

			break;
		}
	}
	
	
	function clean()
	{
		choosen[0].clean();
		choosen[1].clean();
		choosen[2].clean();
		choosen[3].clean();
			
		Mouse.removeListener(this);
//		mc.removeMovieClip();		
	}
	

	function show_loaded()
	{
		if(mc3==null) // still need to load
		{
			if(up.gamecomms)
			{
				if( _root.bmc.isloaded("Login_Img1") ) //available
				{
					mc3=_root.bmc.create(mc2,"Login_Img1" ,null); // display
				}
			}
			else
			{
				if( _root.bmc.isloaded("Login_Img") ) //available
				{
					mc3=_root.bmc.create(mc2,"Login_Img" ,null); // display
				}
			}
		}
		if(mc5==null) // still need to load
		{
			if( _root.bmc.isloaded("Login_Img2") ) //available
			{
				mc5=_root.bmc.create(mc4,"Login_Img2" ,null); // display
			}
		}
	}
	
	function update()
	{
	var s;
	var i,b;
	var pct;
	
		show_loaded();
	
		if(!up.gamecomms)
		{
			if(up.field.state=="user") // only count down while you can do somthing about it
			{
				switch(up.gameskill)
				{
					case "easy":
						chaser+=points/(25*120); // assuming we actually run at 25fps, do nothing for 120 secs and die
					break;
					case "normal":
						chaser+=points/(25*60); // assuming we actually run at 25fps, do nothing for 60 secs and die
					break;
					case "hard":
						chaser+=points/(25*30); // assuming we actually run at 25fps, do nothing for 30 secs and die
					break;
				}
			}
			
			if(chaser>0)
			{
				pct=Math.floor(100*chaser/points);
				if(pct>=100)
				{
					if(points>chaser) 	pct=99;
					else				pct=100;
				}
			}
			else
			{
				pct=0;
			}
			
			s ="<p align='center'>"+points+"</p>";
//		s+="<p align='center'><font size=\"24\">"+Math.floor(chaser)+"</font></p>";
//		s+="<p align='center'><font size=\"24\">"+(100-pct)+"%</font></p>";

			if(up.gamemode=="endurance")
			{
				if(last_pct!=pct)
				{
					gfx.clear(mc_rgbs);
					if(pct<50)
					{
						mc_rgbs.style.fill=0xff00ff00+(Math.floor(255*pct/50)<<16);
					}
					else
					{
						mc_rgbs.style.fill=0xffff0000+(Math.floor(255*(100-pct)/50)<<8);
					}
					gfx.draw_box(mc_rgbs,0,200,100-30,400-(pct*4),15);
					
					last_pct=pct;
				}
				
				if(pct==100)
				{
					up.won.setup(); // game over
				}
			}
			
			gfx.set_text_html(tf_pts1,48,0xffffff,s);
		}
		else
		{
			s ="<p align='center'>"+points1+"</p>";
			gfx.set_text_html(tf_pts1,30,0xffffff,s);
			
			s ="<p align='center'>"+points2+"</p>";
			gfx.set_text_html(tf_pts2,30,0xffffff,s);
		}
								
		gfx.set_text_html(tf_rgbs[0],19,0xffff0000,"<p align=\"center\"><b>"+up.field.available_moves[0]+"</b></p>");
		gfx.set_text_html(tf_rgbs[1],19,0xff00ff00,"<p align=\"center\"><b>"+up.field.available_moves[1]+"</b></p>");
		gfx.set_text_html(tf_rgbs[2],19,0xffffff00,"<p align=\"center\"><b>"+up.field.available_moves[2]+"</b></p>");
		gfx.set_text_html(tf_rgbs[3],19,0xff0000ff,"<p align=\"center\"><b>"+up.field.available_moves[3]+"</b></p>");
		gfx.set_text_html(tf_rgbs[4],19,0xffffffff,"<p align=\"center\"><b>"+up.field.available_moves[4]+"</b></p>");
		
		butt_changed("qual");
		
		for(i=0;i<butts.length;i++)
		{
			b=butts[i];
			b._alpha=(b._alpha+b._alpha+b._alpha_dest)/3;
		}
		
		
		var track=_root.wetplay.wetplayMP3.disp_title;
		var artist=_root.wetplay.wetplayMP3.disp_creator;
		
		if( (track!=last_track) || (artist!=last_artist) )
		{
			s="";
			
			s+="<p align='center'>Now Playing<br>";
			s+="<b>"+track+"</b><br>";
			s+="by<br>";
			s+="<b>"+artist+"</b><br>";
		
			gfx.set_text_html(tf_play,14,0xffffffff,s);
			
			last_track=track;
			last_artist=artist;
		}
		
		if( mc_stage._xscale > 100 )
		{
			mc_stage._xscale = Math.floor( mc_stage._xscale - (mc_stage._xscale-100)*0.1 ) ;
			mc_stage._yscale=mc_stage._xscale;
		}
		if( mc2._xscale > 125)
		{
			mc2._xscale = Math.floor( mc2._xscale - (mc2._xscale-125)*0.1 ) ;
			mc2._yscale=mc2._xscale;
		}
		if( mc4._xscale > 125)
		{
			mc4._xscale = Math.floor( mc4._xscale - (mc4._xscale-125)*0.1 ) ;
			mc4._yscale=mc4._xscale;
		}
		
	}
	
	function goto_mp3_site()
	{
		if(_root.popup) return;
		
		if(_root.wetplay.wetplayMP3.disp_info!="")
		{
			getURL(_root.wetplay.wetplayMP3.disp_info,"BOT");
		}
	}
	
	function butt_over(id)
	{
		if(_root.popup) return;
		
//		dbg.print("+"+id);
//		hover=id;
		
		switch(id)
		{
			case "turn":
				_root.poker.ShowFloat("Click here for more multiplayer options.",25*10);
			break;
			
			case "mp3":
				if(_root.wetplay.wetplayMP3.disp_info!="")
				{
					_root.poker.ShowFloat("Would you like to know more?",25*10);
				}
			break;
			
			case "gamemode":
				switch(up.gamemode)
				{
					case "puzzle":		_root.poker.ShowFloat("End this game and switch to Endurance mode.",25*10);		break;
					case "endurance":	_root.poker.ShowFloat("End this game and switch to Puzzle mode.",25*10);		break;
				}
			break;
			
			case "qual":
				_root.poker.ShowFloat("Adjust the graphical quality, a lower quality can drastically increase frame rate.",25*10);
			break;
			
			case "restart":
				_root.poker.ShowFloat("Give up, reset the board and try again.",25*10);
			break;
			
			case "about":
				_root.poker.ShowFloat("Would you like to know more?",25*10);
			break;
			
			case "menu":
				_root.poker.ShowFloat("Return to the main menu.",25*10);
			break;
			
			case "logoff":
				_root.poker.ShowFloat("Log Out so you can change your name.",25*10);
			break;
			
			case "pass1":
			case "pass2":
				_root.poker.ShowFloat("Skip your turn. This round will end if all players skip.",25*10);
			break;
			
			case "choose1":
			case "choose2":
				_root.poker.ShowFloat("The first two colours you swap become yours, you get 1000 pts if either colour is totally cleared.",25*10);
			break;
			
			case "high":
				switch(up.gamemode)
				{
					case "puzzle":		_root.poker.ShowFloat("Browse other players scores and click on dates to play an older puzzle.",25*10);		break;
					case "endurance":	_root.poker.ShowFloat("Browse other players scores.",25*10);		break;
				}
			break;
			
			case "full":
				_root.poker.ShowFloat("Toggle fullscreen mode, this only works on sites that allow it and you may need to reduce the quality to maintain frame rate.",25*10);
				butt_changed(id);
			break;
			
/*
			case "name1":
				if(!up.gamecomms)
				{
					_root.poker.ShowFloat("Visit your homepage at www.WetGenes.com.",25*10);
				}
				else
				{
					_root.poker.ShowFloat("Visit "+(up.player==0?"your":"their")+" homepage at www.WetGenes.com.",25*10);
				}

			break;
			case "name2":
				_root.poker.ShowFloat("Visit "+(up.player==1?"your":"their")+" homepage at www.WetGenes.com.",25*10);
			break;
*/
		}
		
		butt_ids[id]._alpha_dest=100;
	}
	function butt_out(id)
	{
//		if(_root.popup) return;
		
//		dbg.print("-"+id);
		
//		if(hover==id) { hover=null;}
		
		butt_ids[id]._alpha_dest=75;
		
		_root.poker.ShowFloat(null,0);
	}
	function butt_up(id)
	{
	}
	
	function butt_press(id)
	{
		if(_root.popup) return;
		
//dbg.print(id);
		
		switch(id)
		{
			case "turn":
				up.turnmenu.setup();
			break;
			
			case "pass1":
			case "pass2":
				up.next_turn("-1/-1"); //pass this go, do nothing
			break;
			
			case "mp3":
				goto_mp3_site();
			break;
			
			case "qual":
				_root._highquality=(_root._highquality+1)%3;
//				_root._highquality=_root.qual_num;
				up.field.redraw_all();
			break;
			
			case "restart":
				up.do_str(id);
			break;
			
			case "logoff":
				points=0; // clear score...
				up.do_str(id);
			break;
			
			case "high":
				_root.signals.signal("diamonds","high",up);
				up.up.high.setup();
			break;
			
			case "about":
				up.up.about.setup();
			break;
			
			case "menu":
				up.up.state_next="splash";
				_root.swish=new Swish({style:"sqr_plode",mc:up.mc});
			break;
			
			case "full":
				if( Stage["displayState"] == "normal" )
				{
					Stage["fullScreenSourceRect"] = new flash.geom.Rectangle( 0,0 , 600,450 );
					Stage["displayState"] = "fullScreen";
				}
				else
				{
					Stage["displayState"] = "normal";
				}
			break;
			
			case "gamemode":
				switch(up.gamemode)
				{
					case "puzzle":		up.gamemode="endurance";	break;
					case "endurance":	up.gamemode="puzzle";		break;
				}
				up.do_str("restart");
			break;
			
/*
			case "name1":
				getURL("http://like.wetgenes.com/-/profile/"+_root.Login_Name,"_BLANK");
			break;
*/
		}
		
		butt_changed(id);
	}
	
	function butt_changed(id)
	{
	var s;
	
		switch(id)
		{
			case "stage":
				gfx.set_text_html(mc_stage.tf,24,0xffffffff,"<p align='center'><b>STAGE "+(up.stage+1)+"</b></p>");
				mc_stage._xscale=300;
				mc_stage._yscale=300;
			break;
			
			case "qual":
//				_root._highquality=_root.qual_num;
				var qa=["Bad","Good","Best"];		
				s="<p align='center'><b>Q."+qa[_root._highquality]+" @ "+_root.scalar.t_fps+"fps</b></p>";
				if(butt_ids[id].s!=s)
				{
					butt_ids[id].s=s;
					gfx.set_text_html(butt_ids[id].tf,16,0xffffff,s);
				}
			break;
			
			case "full":
				if( Stage["displayState"] == "normal" )
				{
					s="<p align='center'><b>Full screen</b></p>";
				}
				else
				{
					s="<p align='center'><b>Windowed</b></p>";
				}
				
				butt_str("full",s);
			break;
			
			case "gamemode":
				if(up.gamemode=="puzzle")
				{
					s="<p align='center'><b>Daily Puzzle</b></p>";
				}
				else
				{
					s="<p align='center'><b>Endurance</b></p>";
				}
				butt_str("gamemode",s);
			break;
		}
	}
	
	function set_butt(b,id)
	{
		b.onRollOver=delegate(butt_over,id);
		b.onRollOut=delegate(butt_out,id);
		b.onReleaseOutside=delegate(butt_out,id);
		b.onRelease=delegate(butt_press,id);
	}
	
	function new_butt(id,s,x,y,w,h)
	{
	var b;
	
		b=gfx.create_clip(mc,null);
		set_butt(b,id);
		b._x=x;
		b._y=y;
		b.tf=gfx.create_text_html(b,null,0,0,w,h+4);
		gfx.clear(b);
		b.style.fill=0x80000000;
		b.style.out=0x80000000;
		gfx.draw_box(b,3,-4,-4,w+8,h+8);
		gfx.set_text_html(b.tf,16,0xffffff,s);
		
		b._alpha_dest=75;
		b._alpha=b._alpha_dest;
		butt_ids[id]=b;
		
		b.cacheAsBitmap=true;
		
		return b;
	}
	
	function new_text(id,s,fs,x,y,w,h)
	{
	var b;
	
		b=gfx.create_clip(mc,null);
		b._x=x;
		b._y=y;
//		b.onRollOver=delegate(butt_over,id);
//		b.onRollOut=delegate(butt_out,id);
//		b.onRelease=delegate(butt_press,id);
		b.tf=gfx.create_text_html(b,null,0,0,w,h+4);
//		gfx.clear(b);
//		b.style.fill=0x80000000;
//		b.style.out=0x80000000;
//		gfx.draw_box(b,3,-4,-4,w+8,h+8);
		gfx.set_text_html(b.tf,fs,0xffffff,s);
		
		b._alpha_dest=100;
		b._alpha=b._alpha_dest;
		butt_ids[id]=b;
		
		b.cacheAsBitmap=true;
		
		return b;
	}
	
	function butt_str(id,s)
	{
		gfx.set_text_html(butt_ids[id].tf,16,0xffffff,s);
	}
	
	function turn_str(s)
	{
		gfx.set_text_html(mc_turn.tf,18,0xffffff,s);
	}
	
	static var interface_lines=[
#for line in io.lines("art/interface.txt") do 
#line=line:gsub("^%s*(.-)%s*$", "%1")
	"#(line)",
#end
	""
	];
}