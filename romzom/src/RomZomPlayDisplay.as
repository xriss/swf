/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) Kriss Daniels 2006 http://www.XIXs.com
//
/*+-----------------------------------------------------------------------------------------------------------------+*/

#include "src/opts.as"


// run out of code space :)

class RomZomPlayDisplay
{

	var up; // RomZomPlay
	
	
	function RomZomPlayDisplay(_up)
	{
		up=_up;
	}
	
	
	function saves_update_display()
	{
	var i;
	var saves=up.saves;
	var mcs=up.mcs;
	
		switch(up.state)
		{
			case "hole" :
			
			var aa=[
			
					"screwhandle",
					"bulb",
					"keya",
					"keyb",
					"dial",
					"screw1",
					"screw2",
					"screw3",
					"screw4",
					"screw5",
					"lookey",
					"hammer",
					"shoelace",
					"knife"
		
					];

					
				for(i=0;i<aa.length;i++)
				{
					mcs[	aa[i]+"_show"			]._visible=false;
					mcs[	aa[i]+"_used"			]._visible=false;
					
					if	(
							( saves[ aa[i] ]!="room" )
							&&
							( saves[ aa[i] ]!="hide" )
							&&
							( saves[ aa[i] ]!="0" )
							&&
							( saves[ aa[i] ]!="1" )
							&&
							( saves[ aa[i] ]!="2" )
						)
					{
						mcs[	aa[i]+"_show"			]._visible=true;
					}
					
					if	(
							( saves[ aa[i] ]=="used" )
						)
					{
						mcs[	aa[i]+"_used"			]._visible=true;
					}
				}
								
				if(saves.phoneme=="47912643")
				{
					mcs[	"girl"	]._visible=false;
				}
				
			break;
			
			case "rom0" :
				mcs[	"continue"			]._visible=false;
				mcs[	"continue_click"	]._visible=false;
			break;
			
			case "rom3" :
	
				if(saves.exitdoor=="open")
				{
					mcs[	"exitdoor"		]._visible=false;
					mcs[	"rom5"			]._visible=true;
					mcs[	"rom5_door"		]._visible=true;
				}
				else
				{
					mcs[	"exitdoor"		]._visible=true;
					mcs[	"rom5"			]._visible=false;
					mcs[	"rom5_door"		]._visible=false;
				}
					
				if(saves.main_light=="on")
				{
					mcs[	"switch_click"	]._visible=false;
					mcs[	"switch_click2"	]._visible=false;
				}
				else
				{
					mcs[	"switch_click"	]._visible=false;
					mcs[	"switch_click2"	]._visible=true;
					
					if( (saves.wc_door=="open") && (saves.loolight=="on") )
					{
						mcs[	"switch_click"	]._visible=true;
						mcs[	"switch_click2"	]._visible=false;
					}
				}
				
				mcs[	"loodark"	]._visible=true;
				mcs[	"loolight"	]._visible=false;
						
				if(saves.wc_door=="open")
				{
					mcs[	"door"			]._visible=false;
					mcs[	"door_click"	]._visible=true;
					
					if(saves.loolight=="on")
					{
						mcs[	"loodark"	]._visible=false;
						mcs[	"loolight"	]._visible=true;
					}
				}
				else
				{
					mcs[	"door"			]._visible=true;
					mcs[	"door_click"	]._visible=false;
				}
				
				if(saves.cockies=="hide")
				{
					mcs[	"rom3_cock"		]._visible=false;
					mcs[	"rom3_cock2"	]._visible=false;
				}
				else
				if(saves.cockies=="open")
				{
					mcs[	"rom3_cock2"	]._visible=true;
					mcs[	"rom3_cock"		]._visible=false;
				}
				else
				{
					mcs[	"rom3_cock2"	]._visible=false;
					mcs[	"rom3_cock"		]._visible=true;
				}
				
				if(saves.hamglass=="on")
				{
					mcs[	"rom3_ham"			]._visible=true;
					mcs[	"rom3_hambroke"		]._visible=false;
				}
				else
				{
					mcs[	"rom3_ham"			]._visible=false;
					mcs[	"rom3_hambroke"		]._visible=true;
				}
				
				if(saves.hammer=="room")
				{
					mcs[	"hammer"			]._visible=true;
				}
				else
				{
					mcs[	"hammer"			]._visible=false;
				}
				
				
				if	(
						( saves["screw2"]=="used" )
						&&
						( saves["screw3"]=="used" )
						&&
						( saves["screw5"]=="used" )
						&&
						( saves["knife"]=="used" )
					)
				{
					mcs["rom3_lock"]._visible=false;
				}
				else
				{
					mcs["rom3_lock"]._visible=true;
				}
				
			break;
			
			case "rom3_lock":
			
//				if( saves["screw1"]=="used" )	{ mcs["screw1_sock"]._visible=false; }
//				else							{ mcs["screw1_sock"]._visible=true; }
				
				if( saves["screw2"]=="used" )	{ mcs["screw2_sock"]._visible=false; }
				else							{ mcs["screw2_sock"]._visible=true; }
				
				if( saves["screw3"]=="used" )	{ mcs["screw3_sock"]._visible=false; }
				else							{ mcs["screw3_sock"]._visible=true; }
			
				if( saves["screw4"]=="used" )	{ mcs["screw4_sock"]._visible=false; }
				else							{ mcs["screw4_sock"]._visible=true; }
				
				if( saves["screw5"]=="used" )	{ mcs["screw5_sock"]._visible=false; }
				else							{ mcs["screw5_sock"]._visible=true; }
				
				if( saves["knife"]=="used" )	{ mcs["decoy_sock"]._visible=false; }
				else							{ mcs["decoy_sock"]._visible=true; }
				
				if	(
						( saves["screw2"]=="used" )
						&&
						( saves["screw3"]=="used" )
						&&
						( saves["screw5"]=="used" )
						&&
						( saves["knife"]=="used" )
					)
				{
					mcs["rom3_lock_right"]._visible=false;
					mcs["rom3_lock_nob"]._visible=false;
				}
				else
				{
					mcs["rom3_lock_right"]._visible=true;
					mcs["rom3_lock_nob"]._visible=true;
				}
			break;
			
			case "rom3_ham" :
			
				mcs[	"glass_click0"		]._visible=false;
				mcs[	"glass_click1"		]._visible=false;
				mcs[	"glass_click2"		]._visible=false;
				mcs[	"glass_click3"		]._visible=false;
				mcs[	"glass_click4"		]._visible=false;
				mcs[	"glass_click5"		]._visible=false;
				mcs[	"glass_click6"		]._visible=false;
				mcs[	"glass_click7"		]._visible=false;
				mcs[	"glass_click8"		]._visible=false;
				mcs[	"glass_click9"		]._visible=false;
				
				if(saves.hamglass=="on")
				{
					mcs[	"glass"				]._visible=true;
					mcs[	"glass_click"		]._visible=false;
				}
				else
				{
					mcs[	"glass"				]._visible=false;
					mcs[	"glass_click"		]._visible=true;
				}
				
				if(saves.hammer=="room")
				{
					mcs[	"hammer"			]._visible=true;
				}
				else
				{
					mcs[	"hammer"			]._visible=false;
				}
			break;
			
			case "rom3_cock" :
			
				for(i=0;i<10;i++)
				{
					if(i==saves.cockies_num0)
					{
						mcs[	"num0"+i		]._visible=true;
					}
					else
					{
						mcs[	"num0"+i		]._visible=false;
					}
					
					if(i==saves.cockies_num1)
					{
						mcs[	"num1"+i		]._visible=true;
					}
					else
					{
						mcs[	"num1"+i		]._visible=false;
					}
					
					if(i==saves.cockies_num2)
					{
						mcs[	"num2"+i		]._visible=true;
					}
					else
					{
						mcs[	"num2"+i		]._visible=false;
					}
				}
				
				if	(
						(saves.cockies_num0=="0")
						&&
						(saves.cockies_num1=="2")
						&&
						(saves.cockies_num2=="3")
					)
				{
					if(saves.cockies=="shut")
					{
						saves.cockies="open";
						up.up.play_sfx("sfx_jar");
						up.score+=10000;
					}
				}
				
				if(saves.cockies=="shut")
				{
					mcs[	"screw2"		]._visible=false;
					mcs[	"bulb"			]._visible=false;
					mcs[	"screwhandle"	]._visible=false;
					mcs[	"jar"			]._visible=true;
					mcs[	"jar_click"		]._visible=false;
				}
				else
				{
					mcs[	"jar"			]._visible=false;
					mcs[	"jar_click"		]._visible=true;
					
					if(saves.bulb=="room")
					{
						mcs[	"bulb"	]._visible=true;
					}
					else
					{
						mcs[	"bulb"	]._visible=false;
					}
										
					if(saves.screwhandle=="room")
					{
						mcs[	"screwhandle"	]._visible=true;
					}
					else
					{
						mcs[	"screwhandle"	]._visible=false;
					}
				}
			break;
			
			case "rom3_ceiling" :
			
				if(saves.loolight=="empty")
				{
					mcs[	"bulb_click"	]._visible=false;
					mcs[	"bulb_click2"	]._visible=false;
				}
				else
				if(saves.loolight=="on")
				{
					mcs[	"bulb_click"	]._visible=true;
					mcs[	"bulb_click2"	]._visible=false;
				}
				else
				{
					mcs[	"bulb_click"	]._visible=false;
					mcs[	"bulb_click2"	]._visible=true;
				}
			break;
			
			case "rom3_tub" :
			
				if(saves.loolight=="on")
				{
					mcs[	"switch_click2"	]._visible=false;
				}
				else
				{
					mcs[	"switch_click2"	]._visible=true;
				}
				
				if(saves.screw1=="room")
				{
					mcs[	"screw1"	]._visible=true;
				}
				else
				{
					mcs[	"screw1"	]._visible=false;
				}
				
				mcs[	"bubble0"	]._alpha=0;
				mcs[	"bubble1"	]._alpha=0;
				mcs[	"bubble2"	]._alpha=0;
				mcs[	"bubble3"	]._alpha=0;
				
			break;
			
			case "rom3_bowl" :
			
				if(saves.loolight=="on")
				{
					mcs[	"switch_click2"	]._visible=false;
				}
				else
				{
					mcs[	"switch_click2"	]._visible=true;
				}
				
				mcs[	"screw5"	]._visible=false;
						
				if(saves.box=="open")
				{
					mcs[	"box_click"	]._visible=true;
					mcs[	"box"		]._visible=false;
					
					if(saves.screw5=="room")
					{
						mcs[	"screw5"	]._visible=true;
					}
				}
				else
				{
					mcs[	"box_click"	]._visible=false;
					mcs[	"box"		]._visible=true;
				}
				
			break;
			
			case "rom3_loo" :
			
				if(saves.loolight=="on")
				{
					mcs[	"switch_click2"	]._visible=false;
				}
				else
				{
					mcs[	"switch_click2"	]._visible=true;
				}
				
				if(saves.mirror=="open")
				{
					mcs[	"mirror_click"	]._visible=true;
					mcs[	"mirror"		]._visible=false;
				}
				else
				{
					mcs[	"mirror_click"	]._visible=false;
					mcs[	"mirror"		]._visible=true;
				}
				
				if(saves.keyb=="room")
				{
					mcs[	"keyb"	]._visible=true;
				}
				else
				{
					mcs[	"keyb"	]._visible=false;
				}
				
				mcs[	"screw1"	]._visible=false;
			break;
			
			case "rom3_phone" :
			
				gfx.set_text_html(mcs["phone_display"].tf,32,0xff0000,"<p align='center'><b>"+saves.phoneme+"</b></p>");
				
				for(i=0;i<=9;i++)
				{
					mcs["pad1"+i]._visible=false;
					mcs["pad1"+i].onRelease=null;
					mcs["pad0"+i].onPress=up.delegate(up.click,"pad0",i);
					mcs["pad0"+i].onRelease=null;
				}
			break;
			
			case "rom1":
				if(saves.phoneme=="47912643")
				{
					mcs[	"rom1_shoe"			]._visible=false;
					mcs[	"rom1_shoe_unlace"	]._visible=false;
				}
				else
				if(saves.shoelace=="room")
				{
					mcs[	"rom1_shoe"			]._visible=true;
					mcs[	"rom1_shoe_unlace"	]._visible=false;
				}
				else
				{
					mcs[	"rom1_shoe"			]._visible=false;
					mcs[	"rom1_shoe_unlace"	]._visible=true;
				}
					
				if(saves.cushion=="right")
				{
					mcs[	"cushion_click"	]._visible=false;
					mcs[	"cushion"		]._visible=true;
				}
				else
				{
					mcs[	"cushion_click"	]._visible=true;
					mcs[	"cushion"		]._visible=false;
				}
				
				if(saves.lookey=="room")
				{
					mcs[	"lookey"		]._visible=true;
				}
				else
				{
					mcs[	"lookey"		]._visible=false;
				}
				
				if(saves.screw2=="room")
				{
					mcs[	"screw2"	]._visible=true;
				}
				else
				{
					mcs[	"screw2"	]._visible=false;
				}
				
			break;
			
			case "rom1_a":
			
				mcs[	"screw3"		]._visible=false;
				if(saves.screw3=="room")
				{
					mcs[	"screw3"		]._visible=true;
				}
			
				if(saves.draw_a0=="shut")
				{
					mcs[	"drawer_a0_shut"		]._visible=true;
					mcs[	"drawer_a0_open"		]._visible=false;
				}
				else
				{
					mcs[	"drawer_a0_shut"		]._visible=false;
					mcs[	"drawer_a0_open"		]._visible=true;
				}
				if(saves.draw_a1=="shut")
				{
					mcs[	"drawer_a1_shut"		]._visible=true;
					mcs[	"drawer_a1_open"		]._visible=false;
				}
				else
				{
					mcs[	"drawer_a1_shut"		]._visible=false;
					mcs[	"drawer_a1_open"		]._visible=true;
				}
				if(saves.draw_a2=="shut")
				{
					mcs[	"drawer_a2_shut"		]._visible=true;
					mcs[	"drawer_a2_open"		]._visible=false;
				}
				else
				{
					mcs[	"drawer_a2_shut"		]._visible=false;
					mcs[	"drawer_a2_open"		]._visible=true;
				}
				if(saves.draw_a3=="shut")
				{
					mcs[	"drawer_a3_shut"		]._visible=true;
					mcs[	"drawer_a3_open"		]._visible=false;
				}
				else
				{
					mcs[	"drawer_a3_shut"		]._visible=false;
					mcs[	"drawer_a3_open"		]._visible=true;
				}
								
			break;
			
			case "rom1_b":
			
				mcs[	"keya"	]._visible=false;
				if(saves.keya=="room")
				{
					mcs[	"keya"	]._visible=true;
				}
			
				if(saves.draw_b0=="shut")
				{
					mcs[	"drawer_b0_shut"		]._visible=true;
					mcs[	"drawer_b0_open"		]._visible=false;
				}
				else
				{
					mcs[	"drawer_b0_shut"		]._visible=false;
					mcs[	"drawer_b0_open"		]._visible=true;
				}
				if(saves.draw_b1=="shut")
				{
					mcs[	"drawer_b1_shut"		]._visible=true;
					mcs[	"drawer_b1_open"		]._visible=false;
				}
				else
				{
					mcs[	"drawer_b1_shut"		]._visible=false;
					mcs[	"drawer_b1_open"		]._visible=true;
				}
				if(saves.draw_b2=="shut")
				{
					mcs[	"drawer_b2_shut"		]._visible=true;
					mcs[	"drawer_b2_open"		]._visible=false;
				}
				else
				{
					mcs[	"drawer_b2_shut"		]._visible=false;
					mcs[	"drawer_b2_open"		]._visible=true;
				}
				if(saves.draw_b3=="shut")
				{
					mcs[	"drawer_b3_shut"		]._visible=true;
					mcs[	"drawer_b3_open"		]._visible=false;
				}
				else
				{
					mcs[	"drawer_b3_shut"		]._visible=false;
					mcs[	"drawer_b3_open"		]._visible=true;
				}
								
			break;
			
			case "rom2":
			
				mcs[	"dial"	]._visible=false;
						
				if(saves.rug=="flat")
				{
					mcs[	"rug_click"	]._visible=false;
//					mcs[	"rug"		]._visible=true;
				}
				else
				{
					mcs[	"rug_click"	]._visible=true;
//					mcs[	"rug"		]._visible=false;
					
					if(saves.dial=="room")
					{
						mcs[	"dial"	]._visible=true;
					}
				}
				
				if(saves.dial=="used")
				{
					mcs[	"dial_click"	]._visible=true;
					mcs[	"redbutton"		]._visible=true;
				}
				else
				{
					mcs[	"dial_click"	]._visible=false;
					mcs[	"redbutton"		]._visible=false;
				}
				
				if(saves.win1=="open")
				{
					mcs[	"window01"	]._visible=false;
					mcs[	"window11"	]._visible=true;
				}
				else
				{
					mcs[	"window01"	]._visible=true;
					mcs[	"window11"	]._visible=false;
				}
				if(saves.win2=="open")
				{
					mcs[	"window02"	]._visible=false;
					mcs[	"window12"	]._visible=true;
				}
				else
				{
					mcs[	"window02"	]._visible=true;
					mcs[	"window12"	]._visible=false;
				}
				if(saves.win3=="open")
				{
					mcs[	"window03"	]._visible=false;
					mcs[	"window13"	]._visible=true;
				}
				else
				{
					mcs[	"window03"	]._visible=true;
					mcs[	"window13"	]._visible=false;
				}
				
				if(saves.pent=="open")
				{
					mcs[	"rom2_pent"			]._visible=false;
					mcs[	"rom2_pentclick"	]._visible=true;
				}
				else
				{
					mcs[	"rom2_pent"			]._visible=true;
					mcs[	"rom2_pentclick"	]._visible=false;
				}
				
				mcs[	"num023"	]._alpha=saves.num023/40;
				
			break;
			
			case "rom2_boil":
				if(saves.dial=="used")
				{
					mcs[	"dial_done"	]._visible=true;
					mcs[	"redbutton"	]._visible=true;
				}
				else
				{
					mcs[	"dial_done"	]._visible=false;
					mcs[	"redbutton"	]._visible=false;
				}
			break;
			
			case "rom2_belly":
				if(saves.screw4=="room")
				{
					mcs[	"screw4"	]._visible=true;
				}
				else
				{
					mcs[	"screw4"	]._visible=false;
				}
			break;
			
			case "rom2_rad":
				if(saves.knife=="room")
				{
					if(saves.shoelace=="used")
					{
						mcs[	"knife_stuck"		]._visible=false;
						mcs[	"knife"				]._visible=true;
					}
					else
					{
						mcs[	"knife_stuck"		]._visible=true;
						mcs[	"knife"				]._visible=false;
					}
				}
				else
				{
					mcs[	"knife_stuck"		]._visible=false;
					mcs[	"knife"				]._visible=false;
				}
			break;
			
			case "rom1_shoe":
				if(saves.shoelace=="room")
				{
					mcs[	"shoelace"	]._visible=true;
				}
				else
				{
					mcs[	"shoelace"	]._visible=false;
				}
			break;
		}		
	}

}
