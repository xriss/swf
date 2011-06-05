/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) Kriss Daniels 2006 http://www.XIXs.com
//
/*+-----------------------------------------------------------------------------------------------------------------+*/

#include "src/opts.as"




class ASUE1PlayDat
{

	var up; // RomZom
	
	function delegate(f,d,i)	{	return com.dynamicflash.utils.Delegate.create(this,f,d,i);	}
	

	function ASUE1PlayDat(_up)
	{
		up=_up;
	}
	

	function setup()
	{
	}
	
	function clean()
	{
	}
	
	function update()
	{
	}
	
	
	function saves_reset_temps()
	{
		up.saves.win		=	"shut";		// shut,open
		up.saves.table		=	"shut";		// shut,open
		up.saves.door		=	"shut";		// shut,clicked
	}
	
	function saves_reset()
	{
		up.saves={};
		
		up.score=0;
				
		up.saves.rub				=	"none";		// none,glove,jam,ass
		up.saves.exit				=	"01";		// 01,02,03
		
// items location

		up.saves.item_jam			=	"room";	// room,hand,used
		up.saves.item_glove			=	"room";	// room,hand,used		
	}

	function update_display()
	{
	var i;
	var mc;
	var nams;
	
		for(i=0;i<up.mcs_max;i++)
		{
			mc=up.mcs[i];
			
			nams=mc.nam.split("_");
			
			if(nams[0]==up.state_room) // only show layers that begin with the room name
			{
				mc._visible=true;
				
				switch(nams[1])
				{
					case "tshit":
//						if(nams[2]=="over") //hide at start
						{
							mc._visible=false;
						}
					break
					
					case "start":
					case "scores":
					case "about":
					case "walkthrough":
					case "code":
					
					case "win":
					case "table":
						if(nams[2]) //has state
						{
							if(up.saves[ nams[1] ]==nams[2])
							{
								mc._visible=true;
							}
							else
							{
								mc._visible=false;
							}
						}
					break;
					
					case "glove": // only show glove it it is in the room and the draw is open
					
						mc._visible=false;							
						if	(
								(up.saves.item_glove=="room")
								&&
								(up.saves.table=="open")
							)
						{
							mc._visible=true;
						}
					break;
					
					case "jam": // only show jam if it is in the room
					
						mc._visible=false;							
						if	(
								(up.saves.item_jam=="room")
							)
						{
							mc._visible=true;
						}
					break;
					
					case "rub":
						if(nams[2]) //has state
						{
							if((up.saves.rub=="glove")&&(nams[2]=="glove"))
							{
								mc._visible=true;
							}
							else
							if((up.saves.rub=="jam")&&((nams[2]=="jam")||(nams[2]=="glove")))
							{
								mc._visible=true;
							}
							else
							if((up.saves.rub=="arse")&&(nams[2]=="arse"))
							{
								mc._visible=true;
							}
							else
							{
								mc._visible=false;
							}
						}
					break;
					
					case "exit":
						if(nams[2]) //has state
						{
							if(up.saves[ nams[1] ]==nams[2])
							{
								mc._visible=true;
							}
							else
							{
								mc._visible=false;
							}
						}
					break;
				}
				
			}
			else
			if	(
					(nams[0]=="over") // always show overlay stuff in every real room
					&&	
					(
						(up.state_room!="title")
						&&
						(up.state_room!="rainbow")
					)
				)
			{
				mc._visible=true;
				
				switch(nams[1])
				{
					case "leftarrow":
					case "rightarrow":
						if	(
								(up.state_room=="asue10")
								||
								(up.state_room=="asue11")
							)
						{
							mc._visible=false;
						}
					break;
					
					case "glove": // only show glove it it is in hand
					
						mc._visible=false;							
						if	(
								(up.saves.item_glove=="hand")
								&&
								(
									(up.saves.rub=="none")
								)
							)
						{
							mc._visible=true;
						}
					break;
					
					case "jam": // only show jam if it is in the hand, toggle state depending on if its been used
					
						mc._visible=false;							
						if	(
								(up.saves.item_jam=="hand")
								&&
								(
									(up.saves.rub=="none")
									||
									(up.saves.rub=="glove")
								)
								&&
								(nams[2]=="full")
							)
						{
							mc._visible=true;
						}
						else
						if	(
								(up.saves.item_jam=="hand")
								&&
								(
									(up.saves.rub=="jam")
									||
									(up.saves.rub=="arse")
								)
								&&
								(nams[2]=="less")
							)
						{
							mc._visible=true;
						}
						
					break;
				}
			}
			else
			{
				mc._visible=false;
			}
		}
		
// hide item back when there are no itesm displayed
		if	(
				(up.mcs["over_jam_less"]._visible==false)
				&&
				(up.mcs["over_jam_full"]._visible==false)
				&&
				(up.mcs["over_glove"]._visible==false)
			)
		{
			up.mcs["over_menu"]._visible=false;
		}
		
		switch(up.state_room)
		{
			case "asue01":
				display_title("Why am I in this room?");
			break;
			case "asue02":
				display_title("Why am I in this room?");
			break;
			case "asue03":
				display_title("Why am I in this room?");
			break;
			case "asue04":
				display_title("A horse! In this room, alone, with me. I could do anything and no one would ever, ever, know.");
			break;
			case "asue05":
				display_title("Why am I in this room?");
			break;
			case "asue06":
				display_title("I wonder what that means?");
			break;
			case "asue07":
				if(up.saves.door!="clicked")
				{
					display_title("A door! I shall just walk right out, immediatly.");
				}
				else
				{
					display_title("Darn! The door seems to be stuck.");
				}
			break;
			case "asue08":
				if(up.saves.item_jam=="room")
				{
					display_title("Mmmmm, Jam!");
				}
				else
				{
					display_title("This corner brings back memories of jam. Such happy, happy, days.");
				}
			break;
			
			case "asue10":
				if( up.saves.exit=="01" )
				{
					display_title("I seem to have attracted the attention of a little buzzing chum.");
				}
				else
				if( up.saves.exit=="02" )
				{
					display_title("Stay on target!");
				}
				else
				if( up.saves.exit=="03" )
				{
					display_title("Oooch!");
				}
			break;
			
			case "asue11":
				display_title("Freedom!");
			break;
			
			default:
				display_title("");
			break;
		}
	}
	function display_title(s)
	{
		gfx.set_text_html(up.mc_title.tf1,32,0xffffff,"<p align=\"center\"><b>"+s+"</b></p>");
	}
	
	function room_right(room)
	{
		switch( room )
		{
			case "asue01": return "asue02"; break;
			case "asue02": return "asue03"; break;
			case "asue03": return "asue04"; break;
			case "asue04": return "asue05"; break;
			case "asue05": return "asue06"; break;
			case "asue06": return "asue08"; break;
			case "asue07": return "asue01"; break;
			case "asue08": return "asue07"; break;
		}
		return room;
	}
	
	function room_left(room)
	{
		switch( room )
		{
			case "asue01": return "asue07"; break;
			case "asue02": return "asue01"; break;
			case "asue03": return "asue02"; break;
			case "asue04": return "asue03"; break;
			case "asue05": return "asue04"; break;
			case "asue06": return "asue05"; break;
			case "asue07": return "asue08"; break;
			case "asue08": return "asue06"; break;
		}
		return room;
	}
	
	
	function do_this(me,act)
	{
		if(this["do_"+me.nam])
		{
			this["do_"+me.nam](me,act);
		}
		else
		if(this[ "do_"+me.nams[0]+"_"+me.nams[1]+"_"+me.nams[2] ])
		{
			this[ "do_"+me.nams[0]+"_"+me.nams[1]+"_"+me.nams[2] ](me,act);
		}
		else
		if(this[ "do_"+me.nams[0]+"_"+me.nams[1] ])
		{
			this[ "do_"+me.nams[0]+"_"+me.nams[1] ](me,act);
		}
		else
		if(this[ "do_"+me.nams[0] ])
		{
			this[ "do_"+me.nams[0] ](me,act);
		}
		else
		if(this[ "do_"+me.nams[1] ])
		{
			this[ "do_"+me.nams[1] ](me,act);
		}
		else
		{
			do_def(me,act);
		}
	}
	function do_over_leftarrow(me,act)
	{
		switch(act)
		{
			case "click":
				up.state_next="ASUE1_"+room_left(up.state_room);
				up.up.play_sfx("sfx_table");
			break;
			default:
				do_def(me,act)
			break;
		}
	}
	
	function do_over_rightarrow(me,act)
	{
		switch(act)
		{
			case "click":
				up.state_next="ASUE1_"+room_right(up.state_room);
				up.up.play_sfx("sfx_table");
			break;
			default:
				do_def(me,act)
			break;
		}
	}
	
	function do_door(me,act)
	{
		switch(act)
		{
			case "click":
				if(up.state=="ASUE1_asue07")
				{
					up.saves.door="clicked";
					up.update_display();
					up.up.play_sfx("sfx_locked");
				}
				else
				{
					up.state_next="ASUE1_asue07";
				}
			break;
			default:
				do_def(me,act)
			break;
		}
	}
	
	function do_table(me,act)
	{
		switch(act)
		{
			case "click":
				if(up.state=="ASUE1_asue08")
				{
					if( up.saves.table=="open" )
					{
						up.saves.table="shut";
						up.up.play_sfx("sfx_table");
					}
					else
					{
						up.saves.table="open";
						up.up.play_sfx("sfx_table");
					}
					up.update_display();
				}
				else
				{
					up.state_next="ASUE1_asue08";
				}
			break;
			default:
				do_def(me,act)
			break;
		}
	}
	
	function do_win(me,act)
	{
		switch(act)
		{
			case "click":
				if(up.state=="ASUE1_asue04")
				{
					if( up.saves.win=="open" )
					{
						up.saves.win="shut";
						
						if(up.saves.rub=="arse")
						{
							up.state_next="ASUE1_asue10_01";
							up.up.play_sfx("sfx_bee");
							up.score+=1000;
						}
						else
						{
							up.up.play_sfx("sfx_down");
						}
					}
					else
					{
						up.saves.win="open";
						up.up.play_sfx("sfx_up");
					}
					up.update_display();
				}
				else
				{
					up.state_next="ASUE1_asue04";
				}
			break;
			default:
				do_def(me,act)
			break;
		}
	}
	
	function do_jam(me,act)
	{
		switch(act)
		{
			case "click":
				if(up.state=="ASUE1_asue08")
				{
					if( up.saves.item_jam=="room" )
					{
						up.saves.item_jam="hand";
						up.up.play_sfx("sfx_object");
						up.score+=1000;
					}
					up.update_display();
				}
				else
				{
					up.state_next="ASUE1_asue08";
				}
			break;
			default:
				do_def(me,act)
			break;
		}
	}
	
	function do_glove(me,act)
	{
		switch(act)
		{
			case "click":
				if( up.saves.item_glove=="room" )
				{
					up.saves.item_glove="hand";
					up.up.play_sfx("sfx_object");
					up.score+=1000;
				}
				up.update_display();
			break;
			default:
				do_def(me,act)
			break;
		}
	}
	
	function do_rub(me,act)
	{
		switch(act)
		{
			case "glove":
				if( up.saves.rub=="none" )
				{
					up.saves.rub="glove";
					up.up.play_sfx("sfx_object");
					up.score+=1000;
				}
				up.update_display();
			break;
			case "jam":
				if( up.saves.rub=="glove" )
				{
					up.saves.rub="jam";
					up.up.play_sfx("sfx_object");
					up.score+=1000;
				}
				up.update_display();
			break;
			case "arse":
				if( up.saves.rub=="jam" )
				{
					up.saves.rub="arse";
					up.up.play_sfx("sfx_arse");
					up.score+=1000;
				}
				up.update_display();
			break;
			default:
				do_def(me,act)
			break;
		}
	}
	
	function do_over_glove(me,act)
	{
		if(up.state_room=="asue04")
		{
			do_rub(me,act=="click"?"glove":act);
		}
	}
	function do_over_jam(me,act)
	{
		if(up.state_room=="asue04")
		{
			do_rub(me,act=="click"?"jam":act);
		}
	}
	function do_asue04_arse(me,act)
	{
		if(up.saves.rub=="jam")
		{
			do_rub(me,act=="click"?"arse":act);
		}
	}
	
	function do_horse(me,act)
	{
		switch(act)
		{
			case "click":
				if( up.state!="ASUE1_asue04")
				{
					up.state_next="ASUE1_asue04";
				}
			break;
			default:
				do_def(me,act)
			break;
		}
	}
	
	function do_exit(me,act)
	{
		switch(act)
		{
			case "click":
				if( up.saves.exit=="01" )
				{
					up.saves.exit="02";
					up.up.play_sfx("sfx_bee");
					up.score+=1000;
				}
				else
				if( up.saves.exit=="02" )
				{
					up.saves.exit="03";
					up.up.play_sfx("sfx_door");
					up.score+=1000;
				}
				up.update_display();
			break;
			default:
				do_def(me,act)
			break;
		}
	}
	
	function do_asue10_exit_03_door(me,act)
	{
		switch(act)
		{
			case "click":
				if( up.saves.exit=="03" )
				{
					up.state_next="ASUE1_asue11";
				}
				up.update_display();
			break;
			default:
				do_def(me,act)
			break;
		}
	}
	
	function do_asue11(me,act)
	{
		switch(act)
		{
			case "click":
				up.state_next="ASUE1_rainbow";
				up.up.play_sfx("sfx_rainbow");
				up.score+=1000;
			break;
			default:
				do_def(me,act)
			break;
		}
	}
	
	function butt_over(nam,me,act)
	{
		switch(act)
		{
			case "click":
				switch(nam)
				{
					case "start":
						_root.signals.signal("#(VERSION_NAME)","start",this);
						saves_reset();
						up.state="ASUE1_asue01";
						up.up.play_sfx("sfx_arse");
						up.up.state_next="play";
					break;
					case "scores":
						up.up.high.setup();
					break;
					case "about":
						up.up.about.setup();
					break;
					case "code":
						up.up.code.setup();
					break;
					case "walkthrough":
						getURL("http://4lfa.com/page.php?t=1169251911","_blank");
					break;
					case "tshit":
//						getURL("http://link.wetgenes.com/link/ASUE1.shop","_blank");
					break;
				}
				up.mcs[up.state_room+"_"+nam]._visible=true;
				up.mcs[up.state_room+"_"+nam+"_over"]._visible=false;
			break;
			case "on":
				up.mcs[up.state_room+"_"+nam]._visible=false;
				up.mcs[up.state_room+"_"+nam+"_over"]._visible=true;
				up.up.play_sfx("sfx_table");
			break;
			case "off":
				up.mcs[up.state_room+"_"+nam]._visible=true;
				up.mcs[up.state_room+"_"+nam+"_over"]._visible=false;
			break;
			default:
				do_def(me,act)
			break;
		}
	}
	
	function do_start(me,act)
	{
		butt_over("start",me,act);
	}
	function do_scores(me,act)
	{
		butt_over("scores",me,act);
	}
	function do_about(me,act)
	{
		butt_over("about",me,act);
	}
	function do_code(me,act)
	{
		butt_over("code",me,act);
	}
	function do_walkthrough(me,act)
	{
		butt_over("walkthrough",me,act);
	}
	function do_tshit(me,act)
	{
		butt_over("tshit",me,act);
	}
	
	function do_rainbow(me,act)
	{
		switch(act)
		{
			case "click":
				_root.signals.signal("#(VERSION_NAME)","end",this);
				saves_reset();
				up.state_next="ASUE1_title";
			break;
			default:
				do_def(me,act)
			break;
		}
	}
	
	function do_def(me,act)
	{
		switch(act)
		{
			case "on":
//				_root.poker.ShowFloat(me.nam,25*10);
			break;
			case "off":
				_root.poker.ShowFloat(null,0);
			break;
			case "click":
			break;
		}
	}
}
