/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) Kriss Daniels 2006 http://www.XIXs.com
//
/*+-----------------------------------------------------------------------------------------------------------------+*/

#include "src/opts.as"




class ASUE2PlayDat
{

	var up; // RomZom
	
	var anim_frame=1;
	var anim_advance=0;
	
	
	function delegate(f,d,i)	{	return com.dynamicflash.utils.Delegate.create(this,f,d,i);	}
	
	function talky_display(s) { up.talky_display(s); }
	
	function ASUE2PlayDat(_up)
	{
		up=_up;
		
		saves_reset();
	}
	

	function setup()
	{
	}
	
	function clean()
	{
	}
	
	function update()
	{
		if( (up.state_split[0]=="intro")&&(up.state_split[1]=="anim") )
		{
			anim_advance++;
			if(anim_advance>25)
			{
				do_anim(null,"click");
			}
		}
	}
	
	
	function saves_reset_temps()
	{
	var idx;
	
		item_texts_dat={};
	
		for(idx in item_texts)
		{
			item_texts_dat[idx]={n:0};
		}
		
	}
	
	function saves_reset()
	{
		up.saves={};
		
		up.score=0;
		
		up.saves.vase11			=	"room";
		up.saves.note1			=	"room";
		up.saves.note2			=	"room";
		up.saves.gnome			=	"room";
		up.saves.knife			=	"room";
		up.saves.tap			=	"room";
		up.saves.key1			=	"room";
		up.saves.pad1			=	"room";
		up.saves.pad1s			=	"...............";
		up.saves.pad2			=	"room";
		up.saves.pad2s			=	"...............";
		up.saves.pad3			=	"room";
		up.saves.pad3s			=	"00";
		
		up.saves.fish			=	"room";
		
		up.saves.note3			=	"room";
		up.saves.key2			=	"room";
		
		up.saves.egg_room		=	"15";
		up.saves.egg_hand		=	"0";
		up.saves.egg_n			=	"0";
		up.saves.egg_o			=	"0";
		up.saves.egg_g			=	"0";
		
		up.saves.spatula		=	"room";

		up.saves.gum			=	".......................";

		up.saves.endanim		=	"0";

		up.saves.gameover		=	null;

//dbg
//		up.saves.key1			=	"hand";
//		up.saves.fish			=	"hand";


		anim_frame=1;
		anim_advance=0;
		
		saves_reset_temps();
	}
	
	static var buttons_s="xxxx..xxx..xxxx";
	static var buttons_h="x.xx.xxxxx.xx.x";
	static var buttons_i="xxx.x..x..x.xxx";
	
	var room_dat={
	
			s00 : {x:"***/s10/***/s01",	s:"vase_2",				t:""},
			s10 : {x:"s00/s20/***/***",	s:"vase_1/gum_16",				t:""},
			s20 : {x:"s10/***/***/***",	s:"diaz_1/note_1/vase_11_diaz/vase_11_break/note_2/key_1",	t:""},
			                            
			s01 : {x:"***/***/s00/s02",	s:"vase_3",	t:""},
			                            
			s02 : {x:"***/s12/s01/***",	s:"vase_4",	t:""},
			s12 : {x:"s02/s22/***/***",	s:"vase_5",	t:""},
			s22 : {x:"s12/***/***/s23",	s:"vase_6",	t:""},
		 	                            
			s23 : {x:"***/***/s22/s24",	s:"vase_7/vase_8",	t:""},
			                            
			s04 : {x:"***/s14/***/***",	s:"vase_11/vase_11_wall/vase_10/vase_9/vase_8/vase_7/vase_6/vase_5/vase_4/vase_3/vase_2/vase_1",	t:""},
			s14 : {x:"s04/s24/***/***",	s:"vase_9/gum_23",		t:""},
			s24 : {x:"s14/s34/s23/***",	s:"vase_10/gum_22",	t:""},
			s34 : {x:"s24/h04/***/***",	s:"gum_15",	t:""},
			                            
			                            
			h00 : {x:"***/***/***/h01",	s:"stick/gum_14",	t:""},
			h20 : {x:"***/***/***/h21",	s:"frame/tap",	t:""},
			                            
			h01 : {x:"***/***/h00/h02",	s:"gum_13/gum_21",	t:""},
			h21 : {x:"***/***/h20/h22",	s:"gum_12/gum_20",	t:""},
			                            
			h02 : {x:"***/h12/h01/h03",	s:"gum_11/gum_19",	t:""},
			h12 : {x:"h02/h22/***/***",	s:"diaz_2/knife_diaz/frame/tap_over/water/gnome_diaz/gnome_fish_1/gnome_fish_2/fish",	t:""},
			h22 : {x:"h12/***/h21/h23",	s:"gum_10",	t:""},
			                            
			h03 : {x:"***/***/h02/h04",	s:"gum_9/gum_17",	t:""},
			h23 : {x:"***/***/h22/h24",	s:"gum_8/gum_18",	t:""},
			                            
			h04 : {x:"s34/***/h03/***",	s:"knoll_1/gnome/knoll_2",	t:""},
			h24 : {x:"***/h34/h23/***",	s:"gum_7",	t:""},
			h34 : {x:"h24/i04/***/***",	s:"gum_6",	t:""},
			                            
			                            
			i00 : {x:"***/i10/***/***",	s:"egg_3",	t:""},
			i10 : {x:"i00/i20/***/i11",	s:"gum_5",	t:""},
			i20 : {x:"i10/***/***/***",	s:"gum_4",	t:""},
			                            
			i11 : {x:"***/***/i10/i12",	s:"gum_3",	t:""},
			                            
			i12 : {x:"***/***/i11/i13",	s:"egg_2",	t:""},
			                            
			i13 : {x:"***/***/i12/i14",	s:"gum_2",	t:""},
			                            
			i04 : {x:"h34/i14/***/***",	s:"egg_4",	t:""},
			i14 : {x:"i04/i24/i13/***",	s:"gum_1",	t:""},
			i24 : {x:"i14/i34/***/***",	s:"egg_1",	t:""},
			i34 : {x:"i24/i44/***/***",	s:"esc_3_N/esc_3_O/esc_3_G/egg_1_N/egg_2_N/egg_3_N/egg_4_N/egg_1_O/egg_2_O/egg_3_O/egg_4_O/egg_1_G/egg_2_G/egg_3_G/egg_4_G/spatula",	t:""},
			i44 : {x:"***/***/***/***",	s:"esc_3_door/esc_3_torches",	t:""}
			                        
			};
			
	var room_dat_trans={};
	
				
// descriptions when you clicky on things that dont do anything else			
	var item_texts={
				
vase_1 :
			["This vase won't move, it must be nailed down."],
vase_2 :
			["Someone seems to have covered this vase in butter","I'm not even going to try to pick it up.","Or think about why they did that."],
vase_3 :
			["This one has less butter.", "I'm still not going to risk trying to pick it up."],
vase_4 :
			["There's something icky in this one.", "I really don't want it."],
vase_5 :
			["To the layman this looks like a vase, but when you get close up it's just a painting."],
vase_6 :
			["The back half of this vase is missing.","If I don't touch it then no one can blame me."],
vase_7 :
			["The stench coming from this is unbelievable.", "I don't want it.","If you could smell it you wouldn't want it either."],
vase_8 :
			["As I suspected this isn't even a vase, it's just a hologram."],
vase_9 :
			["I can't lift it, it must be full of purest dark matter."],
vase_10:
			["This seems to be the other half of that other vase."],			

stick:
			["This looks like some early 21st century game art.",
			 "To the untrained eye it seems like badly proportioned stick figures.",
			 "To the trained eye it's even worse.",
			 "Yes it really is just stick figures.",
			 "Actually I'm surprised one of them doesn't have huge hooters.",
			 "You might as well just draw square eyes on a square and call it a web comic."],

esc1_door:
			["It is locked, or stuck, maybe it's even been jammed."],

halfstairs:
			["A way down, I shall use it forthwith.","No click on the hole, not here.","Yes I know that doesn't make sense.","It's just how things are mkay."],
			
fullstairs:
			["A staircase.","Perchance it leads to my dreams?","Perhaps to my nightmares","But how will we ever know?","Unless we explore."]

	};

	var item_texts_dat; // fill in with modifyable stuffs

	var shows; // what basic things we can see in the current room
	var exits; // where the exits u/d/l/r go
	
	var snapshot;
	var snapshot_dir; // use "" for no transition otherwise a direction to scroll into the newroom from
	
	function update_display()
	{
	var i;
	var mc;
	var nams;
	var dat;
	
	
		for(i=0;i<up.mcs.length;i++)
		{
			up.mcs[i]._visible=false; // hide all
		}
		
		if(up.state_split[0]=="asue2")
		{
		
		switch( up.state_split[1].substr(0,1) )
		{
			case "s" : // in an s room
			
				up.mcs["inventory"]._visible=true;
				up.mcs["roombase"]._visible=true;
				
				dat=room_dat[ up.state_split[1] ];
			
			break;
			
			case "h" : // in an h room
			
				up.mcs["inventory"]._visible=true;
				up.mcs["roombase"]._visible=true;
				up.mcs["room_1"]._visible=true;
			
				dat=room_dat[ up.state_split[1] ];
				
			break;
			
			case "i" : // in an i room
			
				up.mcs["inventory"]._visible=true;
				up.mcs["roombase"]._visible=true;
				up.mcs["room_1"]._visible=true;
				up.mcs["room_2"]._visible=true;
			
				dat=room_dat[ up.state_split[1] ];
				
			break;
		}
		
		shows=dat.s.split("/");
		exits=dat.x.split("/");
		
		var updn=0;
		
		
		if(exits[0]!="***")
		{
			up.mcs[ "lefthole" ]._visible=true;
		}
		if(exits[1]!="***")
		{
			up.mcs[ "righthole" ]._visible=true;
		}	
		if(exits[2]!="***")
		{
			up.mcs[ "uphole" ]._visible=true;				
			updn|=1;
		}	
		if(exits[3]!="***")
		{
			up.mcs[ "downhole" ]._visible=true;
			updn|=2;
		}
		switch( updn )
		{
			case 0:
			break;
			case 1:
				up.mcs[ "fullstairs" ]._visible=true;				
			break;
			case 2:
				up.mcs[ "halfstairs" ]._visible=true;				
			break;
			case 3:
				up.mcs[ "fullstairs" ]._visible=true;				
			break;
		}
		
		for(i=0;i<shows.length;i++)
		{

			switch( shows[i] )
			{
				default:
					if( room_dat_trans[ shows[i] ] )
					{
						up.mcs[ room_dat_trans[ shows[i] ] ]._visible=true;
					}
					else
					{
						up.mcs[ shows[i] ]._visible=true;
					}
				break;
			}
		}
		
// now things will already be on in rooms where they are, so just turn off without needing to check which room we are in

		switch(up.state_split[1]) // room special codes so some objects can be reused
		{
			case "s24":
			
				if(up.saves.key1!="used")
				{
					up.mcs[ "righthole" ]._visible=false; //hide exit		
					
					up.mcs[ "esc1_door" ]._visible=true; // show locked exit
					up.mcs[ "esc1_lock2" ]._visible=true;
				}

			break;
			
			case "h24":
			
				if(up.saves.key2!="used")
				{
					up.mcs[ "righthole" ]._visible=false; //hide exit		
					
					up.mcs[ "esc1_door" ]._visible=true; // show locked exit
					up.mcs[ "esc1_lock2" ]._visible=true;
				}

			break;
			
			case "s34":
			
				if(up.saves.pad1s!=buttons_s)
				{
					up.mcs[ "righthole" ]._visible=false; //hide exit
					
					up.mcs[ "esc1_door" ]._visible=true; // show locked exit
					up.mcs[ "esc1_lock1" ]._visible=true;
					up.mcs[ "esc1_pad" ]._visible=true;
				}
				else
				{
					up.saves.pad1="used";
				}

			break;
			
			case "h34":
			
				if(up.saves.pad2s!=buttons_h)
				{
					up.mcs[ "righthole" ]._visible=false; //hide exit
					
					up.mcs[ "esc1_door" ]._visible=true; // show locked exit
					up.mcs[ "esc1_lock1" ]._visible=true;
					up.mcs[ "esc1_pad" ]._visible=true;
				}
				else
				{
					up.saves.pad2="used";
				}

			break;
			
			case "i24":
			
				if(up.saves.pad3s!="27")
				{
					up.mcs[ "righthole" ]._visible=false; //hide exit
					
					up.mcs[ "esc1_door" ]._visible=true; // show locked exit
					up.mcs[ "esc1_lock1" ]._visible=true;
					up.mcs[ "esc1_pad" ]._visible=true;
				}
				else
				{
					up.saves.pad3="used";
				}

			break;
			
			case "i34":
				if(up.saves.egg_n!=4) // open door when full of eggs	
				{
					up.mcs[ "righthole" ]._visible=false; //hide exit
				}
			break;
			
			case "i44":
				i=(Math.floor(up.saves.endanim));
				
				if(i<=7)
				{
					up.mcs[ "esc_3_animate_"+i ]._visible=true;
				}
				else
				if(i==8)
				{
					up.mcs[ "esc_3_door" ]._visible=false;
					up.mcs[ "esc_3_unend" ]._visible=true;
				}
				else
				if(i>=9)
				{
					up.mcs[ "esc_3_door" ]._visible=false;
					up.mcs[ "esc_3_torches" ]._visible=false;
					up.mcs[ "esc_3_end" ]._visible=true;
				}
			break;
		}
		
		if(up.saves.pad1=="view")
		{
			up.mcs[ "esc_1" ]._visible=true;
			up.mcs[ "back" ]._visible=true;
			
			for(i=1;i<16;i++)
			{
			var l=up.saves.pad1s.substr(i-1,1);
				if(l==".")
				{
					up.mcs[ "button_"+i ]._visible=true;
				}
				else
				{
					up.mcs[ "button_"+i+"_on" ]._visible=true;
				}
				
			}
		}
		
		if(up.saves.pad2=="view")
		{
			up.mcs[ "esc_1" ]._visible=true;
			up.mcs[ "back" ]._visible=true;
			
			for(i=1;i<16;i++)
			{
			var l=up.saves.pad2s.substr(i-1,1);
				if(l==".")
				{
					up.mcs[ "button_"+i ]._visible=true;
				}
				else
				{
					up.mcs[ "button_"+i+"_on" ]._visible=true;
				}
				
			}
		}
		
		if(up.saves.pad3=="view")
		{
			up.mcs[ "esc_1" ]._visible=true;
			up.mcs[ "back" ]._visible=true;
			up.mcs[ "esc_2" ]._visible=true;
			up.mcs[ "esc_2_write_1" ]._visible=true;
			
			for(i=0;i<10;i++)
			{
				up.mcs[ "button_"+i ]._visible=true;
				up.mcs[ "button_num_"+i ]._visible=true;
			}
			up.mcs[ "button_"+11 ]._visible=true;
			
		}
				
// turn off singiluar objects, they will only be on if in the right room

		switch(up.saves.vase11) // handle vase states
		{
			case "room":
				up.mcs[ "vase_11_small"		]._visible	=false;
//				up.mcs[ "vase_11"			]._visible	=false;
				up.mcs[ "vase_11_diaz"		]._visible	=false;
				up.mcs[ "note_2"			]._visible	=false;
				up.mcs[ "key_1"				]._visible	=false;
				up.mcs[ "vase_11_break"		]._visible	=false;
			break;
			case "hand":
				up.mcs[ "vase_11_small"		]._visible	=true;
				
				up.mcs[ "vase_11"			]._visible	=false;
				up.mcs[ "vase_11_diaz"		]._visible	=false;
				up.mcs[ "note_2"			]._visible	=false;
				up.mcs[ "key_1"				]._visible	=false;
				up.mcs[ "vase_11_break"		]._visible	=false;
			break;
			case "used":
				up.mcs[ "vase_11_small"		]._visible	=false;
				
				up.mcs[ "vase_11"			]._visible	=false;
//				up.mcs[ "vase_11_diaz"		]._visible	=false;
				up.mcs[ "note_2"			]._visible	=false;
				up.mcs[ "key_1"				]._visible	=false;
				up.mcs[ "vase_11_break"		]._visible	=false;
			break;
			case "broke":
				up.mcs[ "vase_11_small"		]._visible	=false;
				
				up.mcs[ "vase_11"			]._visible	=false;
				up.mcs[ "vase_11_diaz"		]._visible	=false;
//				up.mcs[ "note_2"			]._visible	=false;
//				up.mcs[ "key_1"				]._visible	=false;
//				up.mcs[ "vase_11_break"		]._visible	=false;
			break;
			case "tidy":
				up.mcs[ "vase_11_small"		]._visible	=false;
				
				up.mcs[ "vase_11"			]._visible	=false;
				up.mcs[ "vase_11_diaz"		]._visible	=false;
//				up.mcs[ "note_2"			]._visible	=false;
//				up.mcs[ "key_1"				]._visible	=false;
				up.mcs[ "vase_11_break"		]._visible	=false;
			break;
		}
		
		switch(up.saves.note1) // handle note1 states
		{
			case "room":
				up.mcs[ "note_1_small"		]._visible	=false;
//				up.mcs[ "note_1"			]._visible	=false;
			break;
			case "hand":
				up.mcs[ "note_1_small"		]._visible	=true;
				up.mcs[ "note_1"			]._visible	=false;
			break;
		}
		
		switch(up.saves.note2) // handle note2 states
		{
			case "room":
				up.mcs[ "note_2_small"		]._visible	=false;
//				up.mcs[ "note_2"			]._visible	=false;
			break;
			case "hand":
				up.mcs[ "note_2_small"		]._visible	=true;
				up.mcs[ "note_2"			]._visible	=false;
			break;
		}

		switch(up.saves.key1) // handle key1 states
		{
			case "room":
				up.mcs[ "key_1_small"		]._visible	=false;
//				up.mcs[ "key_1"				]._visible	=false;
			break;
			case "hand":
				up.mcs[ "key_1_small"		]._visible	=true;
				up.mcs[ "key_1"				]._visible	=false;
			break;
			case "used":
				up.mcs[ "key_1_small"		]._visible	=false;
				up.mcs[ "key_1"				]._visible	=false;
			break;
		}

		switch(up.saves.gnome) // handle gnome states
		{
			case "room":
				up.mcs[ "gnome_small"		]._visible	=false;
//				up.mcs[ "gnome"				]._visible	=false;
				up.mcs[ "gnome_diaz"		]._visible	=false;
				up.mcs[ "gnome_fish_1"		]._visible	=false;
				up.mcs[ "gnome_fish_2"		]._visible	=false;
				up.mcs[ "fish"				]._visible	=false;
			break;
			case "hand":
				up.mcs[ "gnome_small"		]._visible	=true;
				up.mcs[ "gnome"				]._visible	=false;
				up.mcs[ "gnome_diaz"		]._visible	=false;
				up.mcs[ "gnome_fish_1"		]._visible	=false;
				up.mcs[ "gnome_fish_2"		]._visible	=false;
				up.mcs[ "fish"				]._visible	=false;
			break;
			case "used":
				up.mcs[ "gnome_small"		]._visible	=false;
				up.mcs[ "gnome"				]._visible	=false;
//				up.mcs[ "gnome_diaz"		]._visible	=false;
				up.mcs[ "gnome_fish_1"		]._visible	=false;
				up.mcs[ "gnome_fish_2"		]._visible	=false;
				up.mcs[ "fish"				]._visible	=false;
			break;
			case "fish1":
				up.mcs[ "gnome_small"		]._visible	=false;
				up.mcs[ "gnome"				]._visible	=false;
				up.mcs[ "gnome_diaz"		]._visible	=false;
//				up.mcs[ "gnome_fish_1"		]._visible	=false;
				up.mcs[ "gnome_fish_2"		]._visible	=false;
				up.mcs[ "fish"				]._visible	=false;
			break;
			case "fish2":
				up.mcs[ "gnome_small"		]._visible	=false;
				up.mcs[ "gnome"				]._visible	=false;
				up.mcs[ "gnome_diaz"		]._visible	=false;
				up.mcs[ "gnome_fish_1"		]._visible	=false;
//				up.mcs[ "gnome_fish_2"		]._visible	=false;
//				up.mcs[ "fish"				]._visible	=false;
			break;
		}
		
		switch(up.saves.knife) // handle knife states
		{
			case "room":
				up.mcs[ "knife_small"		]._visible	=false;
//				up.mcs[ "knife_diaz"		]._visible	=false;
			break;
			case "hand":
				up.mcs[ "knife_small"		]._visible	=true;
				up.mcs[ "knife_diaz"		]._visible	=false;
			break;
		}

		switch(up.saves.tap) // handle tap states
		{
			case "room":
				up.mcs[ "tap_small"			]._visible	=false;
//				up.mcs[ "tap"				]._visible	=false;
				up.mcs[ "tap_over_small"	]._visible	=false;
				up.mcs[ "tap_over"			]._visible	=false;
				up.mcs[ "water"				]._visible	=false;
			break;
			case "hand":
				up.mcs[ "tap_small"			]._visible	=true;
				up.mcs[ "tap"				]._visible	=false;
				up.mcs[ "tap_over_small"	]._visible	=false;
				up.mcs[ "tap_over"			]._visible	=false;
				up.mcs[ "water"				]._visible	=false;
			break;
			case "over":
				up.mcs[ "tap_small"			]._visible	=false;
				up.mcs[ "tap"				]._visible	=false;
				up.mcs[ "tap_over_small"	]._visible	=true;
				up.mcs[ "tap_over"			]._visible	=false;
				up.mcs[ "water"				]._visible	=false;
			break;
			case "used":
				up.mcs[ "tap_small"			]._visible	=false;
				up.mcs[ "tap"				]._visible	=false;
				up.mcs[ "tap_over_small"	]._visible	=false;
//				up.mcs[ "tap_over"			]._visible	=false;
				up.mcs[ "water"				]._visible	=false;
			break;
			case "on":
				up.mcs[ "tap_small"			]._visible	=false;
				up.mcs[ "tap"				]._visible	=false;
				up.mcs[ "tap_over_small"	]._visible	=false;
//				up.mcs[ "tap_over"			]._visible	=false;
//				up.mcs[ "water"				]._visible	=false;
			break;
		}

		switch(up.saves.fish)
		{
			case "room":
				up.mcs[ "fish_small"		]._visible	=false;
//				up.mcs[ "fish"				]._visible	=false;
			break;
			case "hand":
				up.mcs[ "fish_small"		]._visible	=true;
				up.mcs[ "fish"				]._visible	=false;
			break;
		}
		
		switch(up.saves.key2)
		{
			case "hand":
				up.mcs[ "key_1_small"		]._visible	=true;
			break;
		}
		
		switch(up.saves.note3)
		{
			case "hand":
				up.mcs[ "note_3_small"		]._visible	=true;
			break;
		}
		
		if((Math.floor(up.saves.egg_room)&1)==0)
		{
			up.mcs[ "egg_1"		]._visible	=false;
		}
		if((Math.floor(up.saves.egg_room)&2)==0)
		{
			up.mcs[ "egg_2"		]._visible	=false;
		}
		if((Math.floor(up.saves.egg_room)&4)==0)
		{
			up.mcs[ "egg_3"		]._visible	=false;
		}
		if((Math.floor(up.saves.egg_room)&8)==0)
		{
			up.mcs[ "egg_4"		]._visible	=false;
		}
		
		if(up.saves.egg_hand>0)
		{
			up.mcs[ "egg_small"		]._visible	=true;
			
			if(up.saves.egg_hand>=4)
			{
				up.mcs[ "egg_text_4"		]._visible	=true;
			}
			else
			if(up.saves.egg_hand>=3)
			{
				up.mcs[ "egg_text_3"		]._visible	=true;
			}
			else
			if(up.saves.egg_hand>=2)
			{
				up.mcs[ "egg_text_2"		]._visible	=true;
			}
			else
			if(up.saves.egg_hand>=1)
			{
				up.mcs[ "egg_text_1"		]._visible	=true;
			}
			
		}
		
		if(up.saves.egg_n<1)
		{
			up.mcs[ "egg_1_N"		]._visible	=false;
		}
		if(up.saves.egg_n<2)
		{
			up.mcs[ "egg_2_N"		]._visible	=false;
		}
		if(up.saves.egg_n<3)
		{
			up.mcs[ "egg_3_N"		]._visible	=false;
		}
		if(up.saves.egg_n<4)
		{
			up.mcs[ "egg_4_N"		]._visible	=false;
			
		}
		if(up.saves.egg_n==4) // hide thingy when full of eggs
		{
			up.mcs[ "esc_3_N"		]._visible	=false;
			up.mcs[ "egg_1_N"		]._visible	=false;
			up.mcs[ "egg_2_N"		]._visible	=false;
			up.mcs[ "egg_3_N"		]._visible	=false;
			up.mcs[ "egg_4_N"		]._visible	=false;
		}
		
		if(up.saves.egg_o<1)
		{
			up.mcs[ "egg_1_O"		]._visible	=false;
		}
		if(up.saves.egg_o<2)
		{
			up.mcs[ "egg_2_O"		]._visible	=false;
		}
		if(up.saves.egg_o<3)
		{
			up.mcs[ "egg_3_O"		]._visible	=false;
		}
		if(up.saves.egg_o<4)
		{
			up.mcs[ "egg_4_O"		]._visible	=false;
		}
		
		if(up.saves.egg_g<1)
		{
			up.mcs[ "egg_1_G"		]._visible	=false;
		}
		if(up.saves.egg_g<2)
		{
			up.mcs[ "egg_2_G"		]._visible	=false;
		}
		if(up.saves.egg_g<3)
		{
			up.mcs[ "egg_3_G"		]._visible	=false;
		}
		if(up.saves.egg_g<4)
		{
			up.mcs[ "egg_4_G"		]._visible	=false;
		}
		
		switch(up.saves.spatula)
		{
			case "room":
				up.mcs[ "spatula_small"		]._visible	=false;
//				up.mcs[ "spatula"			]._visible	=false;
			break;
			case "hand":
				up.mcs[ "spatula_small"		]._visible	=true;
				up.mcs[ "spatula"			]._visible	=false;
			break;
		}
		
			for(i=1;i<=23;i++)
			{
			var g=up.saves.gum.substr(i-1,1);
			
				if(g!=".")
				{
					up.mcs[ "gum_"+i ]._visible=false; //gum got
				}
			}
			
		}
		else
		if(up.state_split[0]=="intro")
		{
			if(up.state_split[1]=="title")
			{
				for(i=0;i<up.mcs.length;i++)
				{
					up.mcs[i]._visible=false; // hide all
				}
				
				up.mcs[ "title_screen"	]._visible	=true;
				up.mcs[ "wetgenes"		]._visible	=true;
				up.mcs[ "play"			]._visible	=true;
				up.mcs[ "about"			]._visible	=true;
				up.mcs[ "score"			]._visible	=true;
//				up.mcs[ "shop"			]._visible	=false;
				up.mcs[ "code"			]._visible	=true;
				up.mcs[ "stumbleupon"	]._visible	=true;
				up.mcs[ "digg"			]._visible	=true;
			}
			else
			if(up.state_split[1]=="anim")
			{
				for(i=0;i<up.mcs.length;i++)
				{
					up.mcs[i]._visible=false; // hide all
				}

					up.mcs["foreground"]._visible=true;
					up.mcs["background"]._visible=true;
					
					up.mcs["anim_"+anim_frame]._visible=true;
					

			}
		}
	}
	
	
	
	function display_title(s)
	{
		gfx.set_text_html(up.mc_title.tf1,32,0xffffff,"<p align=\"center\"><b>"+s+"</b></p>");
	}

	function do_this(me,act)
	{	
		if	(
				( (!me.nams[4]) && (me.nams[3]=="small") )
				||
				( (!me.nams[3]) && (me.nams[2]=="small") )
				||
				( (!me.nams[2]) && (me.nams[1]=="small") )
			)
		{
			do_small(me,act);
			return;
		}
			
		if	(
				( (!me.nams[4]) && (me.nams[3]=="big") )
				||
				( (!me.nams[3]) && (me.nams[2]=="big") )
				||
				( (!me.nams[2]) && (me.nams[1]=="big") )
			)
		{
			do_big(me,act);
			return;
		}
			
		if	(
				(me.nams[0]=="gum")
			)
		{
			do_gum(me,act);
			return;
		}
			
		if	(
				(me.nams[0]=="button")
			)
		{
			do_button(me,act);
			return;
		}
			
		if	(
				(me.nams[0]=="anim")||
				(me.nams[0]=="foreground")||
				(me.nams[0]=="background")
			)
		{
			do_anim(me,act);
			return;
		}
			
		if	(
				(me.nams[0]=="play")||
				(me.nams[0]=="about")||
				(me.nams[0]=="score")||
				(me.nams[0]=="shop")||
				(me.nams[0]=="code")
			)
		{
			do_menu_button(me,act);
			return;
		}
		
		switch(me.nam)
		{
			case "lefthole":
			case "righthole":
			case "uphole":
			case "downhole":
				do_move(me,act);
			break;
						
			default:
			
				if(this["do_"+me.nam])
				{
					this["do_"+me.nam](me,act);
				}
/*
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
*/
				else
				{
					do_def(me,act);
				}
				
			break;
		}
	
	}
	function do_def(me,act)
	{
	var d,t;
	
		switch(act)
		{
			case "on":
//				_root.poker.ShowFloat(me.nam,25*10);
			break;
			case "off":
				_root.poker.ShowFloat(null,0);
			break;
			case "click":
			
				if( item_texts_dat[me.nam] ) // we have a talky thingy
				{
					d=item_texts_dat[me.nam];
					t=item_texts[me.nam];
					
					if( !t[d.n] ) { d.n=0; }
					if( t[d.n] )
					{
						talky_display( t[d.n] );
					}
					d.n++;
					if( !t[d.n] ) { d.n=0; }
				}
				else
				{
//					talky_display( me.nam );
				}
			break;
		}
	}
	
// prepare a room scroll transition	
	function room_scroll(dir)
	{
		if(dir!="")
		{
			up.snapbmp=new flash.display.BitmapData(600,600,false,0x00000000);
			up.snapbmp.draw(up.zmc);
		}
		else
		{
			up.snapbmp=null;
		}
		
		up.snapfrom=dir;
	}
	
	function do_anim(me,act)
	{
		switch(act)
		{
			case "on":
			break;
			case "off":
			break;
			case "click":
				anim_frame++;
				anim_advance=0;
				
				switch(anim_frame)
				{
					case  2:	_root.wetplay.PlaySFX("sfx_001",1,1); break;
					case  3:	_root.wetplay.PlaySFX("sfx_002",2,1); break;
					case  5:	_root.wetplay.PlaySFX("sfx_003",3,1); break;
					case  9:	_root.wetplay.PlaySFX("sfx_004",1,1); break;
					case 22:	_root.wetplay.PlaySFX("sfx_005",2,1); break;
					case 27:	_root.wetplay.PlaySFX("sfx_006",3,1); break;
					case 29:	_root.wetplay.PlaySFX(null,0,0); break;
				}
				
				if(anim_frame>=29)
				{
					up.state_next="asue2_s20";
					room_scroll(null);
				}
				update_display();
			break;
		}
	}
	
	function do_egg_1(me,act)
	{
		if(act=="click")
		if(Math.floor(up.saves.egg_room)&1)
		{
			up.saves.egg_room=Math.floor(up.saves.egg_room)-1;
			up.saves.egg_hand=Math.floor(up.saves.egg_hand)+1;
			update_display();
			inc_score();
		}
	}
	function do_egg_2(me,act)
	{
		if(act=="click")
		if(Math.floor(up.saves.egg_room)&2)
		{
			up.saves.egg_room=Math.floor(up.saves.egg_room)-2;
			up.saves.egg_hand=Math.floor(up.saves.egg_hand)+1;
			update_display();
			inc_score();
		}
	}
	function do_egg_3(me,act)
	{
		if(act=="click")
		if(Math.floor(up.saves.egg_room)&4)
		{
			up.saves.egg_room=Math.floor(up.saves.egg_room)-4;
			up.saves.egg_hand=Math.floor(up.saves.egg_hand)+1;
			update_display();
			inc_score();
		}
	}
	function do_egg_4(me,act)
	{
		if(act=="click")
		if(Math.floor(up.saves.egg_room)&8)
		{
			up.saves.egg_room=Math.floor(up.saves.egg_room)-8;
			up.saves.egg_hand=Math.floor(up.saves.egg_hand)+1;
			update_display();
			inc_score();
		}
	}

	function do_esc_3_N(me,act)
	{
		if(act=="click")
		if(Math.floor(up.saves.egg_hand)>0)
		{
			up.saves.egg_hand=Math.floor(up.saves.egg_hand)-1;
			up.saves.egg_n=Math.floor(up.saves.egg_n)+1;
			update_display();
			
			if(up.saves.egg_n==4)
			{
				inc_score();
				talky_display("Why? Because Ns lay eggs of course.");
			}
		}
	}

	function do_esc_3_O(me,act)
	{
		if(act=="click")
		if(Math.floor(up.saves.egg_hand)>0)
		{
			up.saves.egg_hand=Math.floor(up.saves.egg_hand)-1;
			up.saves.egg_o=Math.floor(up.saves.egg_o)+1;
			update_display();
		}
	}
	
	function do_esc_3_G(me,act)
	{
		if(act=="click")
		if(Math.floor(up.saves.egg_hand)>0)
		{
			up.saves.egg_hand=Math.floor(up.saves.egg_hand)-1;
			up.saves.egg_g=Math.floor(up.saves.egg_g)+1;
			update_display();
		}
	}
	
	function do_egg_1_N(me,act) { egg_N(me,act); }
	function do_egg_2_N(me,act) { egg_N(me,act); }
	function do_egg_3_N(me,act) { egg_N(me,act); }
	function do_egg_4_N(me,act) { egg_N(me,act); }
	function egg_N(me,act)
	{
		if(act=="click")
		if(Math.floor(up.saves.egg_n)>0)
		{
			up.saves.egg_hand=Math.floor(up.saves.egg_hand)+1;
			up.saves.egg_n=Math.floor(up.saves.egg_n)-1;
			update_display();
		}
	}
	
	function do_egg_1_O(me,act) { egg_O(me,act); }
	function do_egg_2_O(me,act) { egg_O(me,act); }
	function do_egg_3_O(me,act) { egg_O(me,act); }
	function do_egg_4_O(me,act) { egg_O(me,act); }
	function egg_O(me,act)
	{
		if(act=="click")
		if(Math.floor(up.saves.egg_o)>0)
		{
			up.saves.egg_hand=Math.floor(up.saves.egg_hand)+1;
			up.saves.egg_o=Math.floor(up.saves.egg_o)-1;
			update_display();
		}
	}
	
	function do_egg_1_G(me,act) { egg_G(me,act); }
	function do_egg_2_G(me,act) { egg_G(me,act); }
	function do_egg_3_G(me,act) { egg_G(me,act); }
	function do_egg_4_G(me,act) { egg_G(me,act); }
	function egg_G(me,act)
	{
		if(act=="click")
		if(Math.floor(up.saves.egg_g)>0)
		{
			up.saves.egg_hand=Math.floor(up.saves.egg_hand)+1;
			up.saves.egg_g=Math.floor(up.saves.egg_g)-1;
			update_display();
		}
	}
	
	function do_esc_3_end(me,act) { do_end(me,act); }
	function do_esc_3_unend(me,act) { do_end(me,act); }
	function do_esc_3_door(me,act) { do_end(me,act); }
	function do_esc_3_animate_1(me,act) { do_end(me,act); }
	function do_esc_3_animate_2(me,act) { do_end(me,act); }
	function do_esc_3_animate_3(me,act) { do_end(me,act); }
	function do_esc_3_animate_4(me,act) { do_end(me,act); }
	function do_esc_3_animate_5(me,act) { do_end(me,act); }
	function do_esc_3_animate_6(me,act) { do_end(me,act); }
	function do_esc_3_animate_7(me,act) { do_end(me,act); }
	function do_esc_3_torches(me,act) { do_end(me,act); }
	function do_end(me,act)
	{
		if(act=="click")
		{
			up.saves.endanim=Math.floor(up.saves.endanim)+1;
			update_display();
			
			if(up.saves.endanim==9)
			{
				_root.wetplay.PlaySFX("sfx_rainbow",1,1);
			
				up.score+=2000;
				up.saves.gameover=1;
				
				_root.signals.signal("#(VERSION_NAME)","end",this);
				
				up.update();
				
				up.up.high.setup();

			}

			if(up.saves.endanim==10)
			{
				up.state_next="intro_title";
				room_scroll(null);				
			}
		}
	}	
	
	function do_move(me,act)
	{
	var dest;
	var dir;
	
		dest="***";
		dir="";
		
		switch(act)
		{
			case "click":
				switch(me.nam)
				{
					case "lefthole":
						dest=exits[0];
						dir="left";
					break;

					case "righthole":
						dest=exits[1];
						dir="right";
					break;

					case "uphole":
						dest=exits[2];
						dir="up";
					break;

					case "downhole":
						dest=exits[3];
						dir="down";
					break;
				}
				
				if(dest!="***")
				{
					up.state_next="asue2_"+dest;
					room_scroll(dir);
				}

			break;
		}
		
	}
	function do_gum(me,act)
	{
		var num;
		var pre,pst;
		var s,s1,s2,s3;
		
		switch(act)
		{
			case "click":
			
				if(up.saves.spatula=="hand")
				{
					num=Math.floor(me.nams[1]);
					
					pre=num-1;
					pst=23-num;
					
					s=up.saves.gum;
					
					s1=s.substr(0,pre);
					s2=s.substr(num-1,1);
					s3=s.substr(num,pst);
					
					if(s2==".")
					{
						s2="x";
						
						inc_score();
					}
					
					up.saves.gum=s1+s2+s3;
					
					update_display();
					
					var i,ic,dstr;
					ic=0;
					for(i=0;i<up.saves.gum.length;i++)
					{
						if(up.saves.gum.substr(i,1)=="x")
						{
							ic++;
						}
					}
					dstr=ic+" of 23";
					
					talky_display("There we go, "+dstr+" all nice and clean,");
				}
				else
				{
					talky_display("I think it's gum, but whatever it is it's very very stuck.");
				}
			break;
		}
	}
	
	function do_spatula(me,act)
	{		
		switch(act)
		{
			case "click":
				
				talky_display("A spatula, I shall put it to work immediately.");
				up.saves.spatula="hand";
				update_display();
		
				inc_score();
						
			break;
		}
	}
	
	function do_button(me,act)
	{
		var num;
		var pre,pst;
		var s,s1,s2,s3;
		
		if(up.state_split[1]=="i24") // number one
		{
			if(act=="click")
			{
				if(me.nams[1]=="num")
				{
					num=Math.floor(me.nams[2]);
				}
				else
				{
				var	aa=[0,1,2,3,4,5,6,7,8,9,0,0];
					num=Math.floor(me.nams[1]);
					num=aa[num];
				}
				
				up.saves.pad3s+=num;
				up.saves.pad3s=up.saves.pad3s.substr(1,2);
				gfx.set_text_html(up.mcs["esc_2_write_1"].tf,50,0xffff00,"<b>"+up.saves.pad3s+"</b>");
				
				update_display();
				
				if(up.saves.pad3s==27)
				{
					inc_score();
				}
			}
		}
		else
		{
			if(act=="click")
			{
				num=Math.floor(me.nams[1]);
				
				pre=num-1;
				pst=15-num;
				
				if(up.state_split[1]=="s34")
				{
					s=up.saves.pad1s;
				}
				else
				if(up.state_split[1]=="h34")
				{
					s=up.saves.pad2s;
				}
				
				s1=s.substr(0,pre);
				s2=s.substr(num-1,1);
				s3=s.substr(num,pst);
				
				if(s2==".")
				{
					s2="x";
				}
				else
				{
					s2=".";
				}
				
				if(up.state_split[1]=="s34")
				{
					up.saves.pad1s=s1+s2+s3;
					
					if(up.saves.pad1s==buttons_s)
					{
						inc_score();
					}
				}
				else
				if(up.state_split[1]=="h34")
				{
					up.saves.pad2s=s1+s2+s3;
					
					if(up.saves.pad2s==buttons_h)
					{
						inc_score();
					}
				}
				
				update_display();
			}
		}
	}
	
	function do_small(me,act)
	{
	var n={};
	
		if(me.nams[3]=="small")
		{
			n.small=me.nams[0]+"_"+me.nams[1]+"_"+me.nams[2]+"_small";
			n.text =me.nams[0]+"_"+me.nams[1]+"_"+me.nams[2]+"_text";
			n.big  =me.nams[0]+"_"+me.nams[1]+"_"+me.nams[2]+"_big";
		}
		else
		if(me.nams[2]=="small")
		{
			n.small=me.nams[0]+"_"+me.nams[1]+"_small";
			n.text =me.nams[0]+"_"+me.nams[1]+"_text";
			n.big  =me.nams[0]+"_"+me.nams[1]+"_big";
		}
		else
		if(me.nams[1]=="small")
		{
			n.small=me.nams[0]+"_small";
			n.text =me.nams[0]+"_text";
			n.big  =me.nams[0]+"_big";
		}
		
		if((n.text=="note_3_text")||(n.text=="note_2_text"))
		{
			if((up.saves.note2=="hand")&&(up.saves.note3=="hand"))
			{
				n.big  ="note_2+3_big";
			}
		}

		switch(act)
		{
			case "on":
				up.saves.about=n.text;
				up.mcs[ n.text	]._visible	=true;
			break;
			case "off":
				up.saves.about=null;
				up.mcs[ n.text	]._visible	=false;
			break;
			case "click":
			
				if(up.saves.pad1=="view")
				{
					up.saves.pad1="room";
					update_display()
				}
				if(up.saves.pad2=="view")
				{
					up.saves.pad2="room";
					update_display()
				}
				if(up.saves.pad3=="view")
				{
					up.saves.pad3="room";
					update_display()
				}
				
				if( up.saves.show )
				{
					up.mcs[ up.saves.show	]._visible	=false;
					up.saves.show=null;
					update_display();
				}
				else
				{				
					up.saves.show=n.big;
					up.mcs[ up.saves.show	]._visible	=true;
				}

				if( up.saves.show == "fish_big" )
				{
					bigfish=1;
					show_fish();
				}
				
			break;
		}		
	}
	
	function do_back(me,act)
	{
		if(act=="click")
		{
			if(up.saves.pad1=="view")
			{
				up.saves.pad1="room";
				update_display()
			}
			if(up.saves.pad2=="view")
			{
				up.saves.pad2="room";
				update_display()
			}
			if(up.saves.pad3=="view")
			{
				up.saves.pad3="room";
				update_display()
			}
		}
	}
	
	function do_big(me,act)
	{
	var n={};
	
		if(me.nams[3]=="big")
		{
			n.small=me.nams[0]+"_"+me.nams[1]+"_"+me.nams[2]+"_small";
			n.text =me.nams[0]+"_"+me.nams[1]+"_"+me.nams[2]+"_text";
			n.big  =me.nams[0]+"_"+me.nams[1]+"_"+me.nams[2]+"_big";
		}
		else
		if(me.nams[2]=="big")
		{
			n.small=me.nams[0]+"_"+me.nams[1]+"_small";
			n.text =me.nams[0]+"_"+me.nams[1]+"_text";
			n.big  =me.nams[0]+"_"+me.nams[1]+"_big";
		}
		else
		if(me.nams[1]=="big")
		{
			n.small=me.nams[0]+"_small";
			n.text =me.nams[0]+"_text";
			n.big  =me.nams[0]+"_big";
		}

		switch(act)
		{
			case "on":
				up.saves.about=n.text;
				up.mcs[ n.text	]._visible	=true;
			break;
			case "off":
				up.saves.about=null;
				up.mcs[ n.text	]._visible	=false;
			break;
			case "click":
			
				if( up.saves.show == "tap_big" ) // slip tap over
				{
					up.mcs[ up.saves.show	]._visible	=false;
					up.saves.show=null;
					up.saves.tap="over";
					talky_display("The back of this painting seems much more interesting. It must be modern art.");
					update_display();
					inc_score();
				}
				else
				if( up.saves.show == "fish_big" )
				{
					if(me.nam=="key_2_big")
					{
						do_key_2_big(me,act);
					}
					else
					if(me.nam=="note_3_rolled_big")
					{
						do_note_3_rolled_big(me,act);
					}
					else
					{
						up.saves.show=null;
						update_display();
					}					
				}
				else
				if( up.saves.show )
				{
					up.mcs[ up.saves.show	]._visible	=false;
					up.saves.show=null;
					update_display();
				}
		
				
			break;
		}
	}
	
	var bigfish;
	
	function do_fish_big_1_over(me,act)
	{
		if(act=="click") { bigfish=2; show_fish(); }
	}
	function do_fish_big_2_over(me,act)
	{
		if(act=="click") { bigfish=3; show_fish(); }
	}
	function do_fish_big_3_over(me,act)
	{
		if(act=="click") { bigfish=4; show_fish(); }
	}
	function do_fish_big_4_over(me,act)
	{
		if(act=="click") { bigfish=5; show_fish(); }
	}
	
	function do_key_2_big(me,act)
	{
		if(act=="click")
		{
			up.saves.key2="hand";
			up.mcs[ "key_1_small"		]._visible	=true;
			show_fish();
			inc_score();
		}
	}
	
	function do_note_3_rolled_big(me,act)
	{
		if(act=="click")
		{
			up.saves.note3="hand";
			up.mcs[ "note_3_small"		]._visible	=true;
			show_fish();
			inc_score();
		}
	}
	
	
	
	
	function show_fish()
	{
	
		up.mcs[ "fish_big_1"]._visible	=false;
		up.mcs[ "fish_big_2"]._visible	=false;
		up.mcs[ "fish_big_3"]._visible	=false;
		up.mcs[ "fish_big_4"]._visible	=false;
		
		up.mcs[ "fish_big_1_over"]._visible	=false;
		up.mcs[ "fish_big_2_over"]._visible	=false;
		up.mcs[ "fish_big_3_over"]._visible	=false;
		up.mcs[ "fish_big_4_over"]._visible	=false;
		
		up.mcs[ "note_3_rolled_big"]._visible	=false;
		up.mcs[ "key_2_big"]._visible	=false;



		switch(bigfish)
		{
			case 1:
				up.mcs[ "fish_big_1_over"]._visible	=true;
			break;
			case 2:
				up.mcs[ "fish_big_1"]._visible	=true;
				up.mcs[ "fish_big_2_over"]._visible	=true;
			break;
			case 3:
				up.mcs[ "fish_big_1"]._visible	=true;
				up.mcs[ "fish_big_2"]._visible	=true;
				up.mcs[ "fish_big_3_over"]._visible	=true;
			break;
			case 4:
				up.mcs[ "fish_big_1"]._visible	=true;
				up.mcs[ "fish_big_2"]._visible	=true;
				up.mcs[ "fish_big_3"]._visible	=true;
				up.mcs[ "fish_big_4_over"]._visible	=true;
			break;
			case 5:
				up.mcs[ "fish_big_1"]._visible	=true;
				up.mcs[ "fish_big_2"]._visible	=true;
				up.mcs[ "fish_big_3"]._visible	=true;
				up.mcs[ "fish_big_4"]._visible	=true;
				
				if(up.saves.note3=="room")
				{
					up.mcs[ "note_3_rolled_big"]._visible	=true;
				}
				
				if(up.saves.key2=="room")
				{
					up.mcs[ "key_2_big"]._visible	=true;
				}
				
			break;
		}

	}
	
	
	function do_note_1(me,act)
	{		
		switch(act)
		{
			case "on":
				_root.poker.ShowFloat("What was that?",25*10);
			break;
			case "off":
				_root.poker.ShowFloat(null,0);
			break;
			case "click":
			
				_root.poker.ShowFloat(null,0);
				talky_display("A note! I think there was some writing on it, maybe it's readable?");
				up.saves.note1="hand";
				update_display();
		
				inc_score();
			
			break;
		}
	}
	
	function do_note_2(me,act)
	{		
		switch(act)
		{
			case "on":
				_root.poker.ShowFloat("What was that?",25*10);
			break;
			case "off":
				_root.poker.ShowFloat(null,0);
			break;
			case "click":
			
				_root.poker.ShowFloat(null,0);
				talky_display("Another note! I think there was some writing on it, maybe it's readable?");
				up.saves.note2="hand";
				update_display();
		
				inc_score();
				
			break;
		}
	}
	
	function do_key_1(me,act)
	{		
		switch(act)
		{
			case "on":
				_root.poker.ShowFloat("What was that?",25*10);
			break;
			case "off":
				_root.poker.ShowFloat(null,0);
			break;
			case "click":
			
				_root.poker.ShowFloat(null,0);
				talky_display("Now I am the keymaster, are you the gate keeper?");
				up.saves.key1="hand";
				update_display();
		
				inc_score();
				
			break;
		}
	}
	
	function do_esc1_lock2(me,act)
	{
		switch(act)
		{
			case "click":
			
				if(up.state_split[1]=="s24")
				{
					if(up.saves.key1=="hand")
					{
						talky_display("It saddens me that I am no longer the keymaster.");
						up.saves.key1="used";
						update_display();
						
						inc_score();
					}
					else
					if(up.saves.key1=="room")
					{
						talky_display("You see the thing about keyholes, their one main attribute, is that they require a key to operate.");
						update_display();
					}
				}
				else
				if(up.state_split[1]=="h24")
				{
					if(up.saves.key2=="hand")
					{
						talky_display("It saddens me that I am no longer the keymaster, again.");
						up.saves.key2="used";
						update_display();
						
						inc_score();
					}
					else
					if(up.saves.key2=="room")
					{
						talky_display("You see the thing about keyholes, their one main attribute, is that they require a key to operate.");
						update_display();
					}
				}
				
		
			break;
		}
	}
	
	function do_esc1_pad(me,act)
	{
		switch(act)
		{
			case "click":
			
				if(up.state_split[1]=="s34")
				{
					up.saves.pad1="view";
				}
				else
				if(up.state_split[1]=="h34")
				{
					up.saves.pad2="view";
				}
				else
				if(up.state_split[1]=="i24")
				{
					up.saves.pad3="view";
				}
				
				up.saves.about="";
				update_display();
		
			break;
		}
	}
	
	function do_vase_11(me,act)
	{		
		switch(act)
		{
			case "click":
				
				talky_display("This one is mine, all mine!.");
				up.saves.vase11="hand";
				update_display();
		
				inc_score();
				
			break;
		}
	}
	
	function do_diaz_1(me,act)
	{		
		switch(act)
		{
			case "click":
				
				if(up.saves.vase11=="hand")
				{
					talky_display("There we go, although it's not quite centered. Should I fix that?");
					up.saves.vase11="used";
					update_display();
					
					inc_score();
				}
		
			break;
		}
	}
	
	function do_vase_11_diaz(me,act)
	{		
		switch(act)
		{
			case "click":
				
				talky_display("Whoopsie daisy.");
				up.saves.vase11="broke";
				update_display();
		
				inc_score();
				
			break;
		}
	}
	
	function do_vase_11_break(me,act)
	{		
		switch(act)
		{
			case "click":
				
				talky_display("Let me tidy this mess away.");
				up.saves.vase11="tidy";
				update_display();
		
				inc_score();
				
			break;
		}
	}
	
	function do_gnome(me,act)
	{		
		switch(act)
		{
			case "on":
				_root.poker.ShowFloat("What was that?",25*10);
			break;
			case "off":
				_root.poker.ShowFloat(null,0);
			break;
			case "click":
			
				_root.poker.ShowFloat(null,0);
				
				talky_display("I spy a gnome!");
				up.saves.gnome="hand";
				update_display();
		
				inc_score();
				
			break;
		}
	}
	
	function do_knife_diaz(me,act)
	{
		switch(act)
		{
			case "click":
				
				talky_display("Ooch, sharpy.");
				up.saves.knife="hand";
				update_display();
		
				inc_score();
				
			break;
		}
	}
	
	function do_diaz_2(me,act)
	{		
		switch(act)
		{
			case "click":
				
				if( (up.saves.knife=="hand")&&(up.saves.gnome=="hand") )
				{
					talky_display("A perfect place to keep my gnome.");
					up.saves.gnome="used";
					update_display();
					
					inc_score();
				}
		
			break;
		}
	}
	
	function do_tap(me,act)
	{		
		switch(act)
		{
			case "click":
				
				if( (up.saves.knife=="hand") )
				{
					talky_display("Yay, I'm an art vandal!");
					up.saves.tap="hand";
					update_display();
					
					inc_score();
				}
				else
				{
					talky_display("It is stuck and will not move.");
				}
		
			break;
		}
	}
	
	function do_frame(me,act)
	{
		switch(act)
		{
			case "click":
			
				if(up.state_split[1]=="h12")
				{
					if( up.saves.tap=="over" )
					{
						talky_display("Yay, I'm an anti art vandal!");
						up.saves.tap="used";
						update_display();
						
						inc_score();
					}
					else
					{
						talky_display("It's just an empty picture frame.");
					}
				}
		
			break;
		}
	}
	
	function do_tap_over(me,act)
	{
		switch(act)
		{
			case "click":
			
				if( up.saves.tap=="used" )
				{
					talky_display("It's like a magick painting of a tap that can fill a room full of water.");
					up.saves.tap="on";
					update_display();
					
					inc_score();
				}
		
			break;
		}
	}
	
	function do_gnome_diaz(me,act)
	{
		switch(act)
		{
			case "click":
			
				if( up.saves.tap=="on" )
				{
					talky_display("Here fishy fishy.");
					up.saves.gnome="fish1";
					update_display();
					
					inc_score();
				}
		
			break;
		}
	}
	function do_gnome_fish_1(me,act)
	{
		switch(act)
		{
			case "click":
			
				if( up.saves.tap=="on" )
				{
					talky_display("What luck, we caught a fish.!");
					up.saves.gnome="fish2";
					update_display();
					
					inc_score();
				}
		
			break;
		}
	}
	function do_fish(me,act)
	{
		switch(act)
		{
			case "click":
			
				if( up.saves.tap=="on" )
				{
					talky_display("I touch it, with my hands. It's slimy, I no likey.");
					up.saves.fish="hand";
					update_display();
					
					inc_score();
				}
		
			break;
		}
	}
	
	function inc_score()
	{
		up.score+=500;
		_root.wetplay.PlaySFX("sfx_object",1,1);
	}
	
	function do_menu_button(me,act)
	{
		switch(act)
		{
			case "on":
				switch(me.nams[0])
				{
					case "play":
						_root.poker.ShowFloat(#(XLT("Shall we play a game?")),25*10);
						up.mcs[ "play_over"		]._visible	=true;
					break;
					case "about":
						_root.poker.ShowFloat(#(XLT("Did you know that this game was made by real people?")),25*10);
						up.mcs[ "about_over"	]._visible	=true;
					break;
					case "score":
						_root.poker.ShowFloat(#(XLT("I score, you score, we all score for high scores.")),25*10);
						up.mcs[ "score_over"	]._visible	=true;
					break;
					case "shop":
						_root.poker.ShowFloat(#(XLT("Because you love us and we love you (all night long baby!).")),25*10);
						up.mcs[ "shop_over"		]._visible	=true;
					break;
					case "code":
						_root.poker.ShowFloat(#(XLT("Embed this game anywhere on the wild webby woo.")),25*10);
						up.mcs[ "code_over"		]._visible	=true;
					break;
				}
			break;
			case "off":
				up.mcs[ "play_over"		]._visible	=false;
				up.mcs[ "about_over"	]._visible	=false;
				up.mcs[ "score_over"	]._visible	=false;
				up.mcs[ "shop_over"		]._visible	=false;
				up.mcs[ "code_over"		]._visible	=false;
				_root.poker.ShowFloat(null,0);
			break;
			case "click":
				switch(me.nams[0])
				{
					case "play":
						up.up.state_next="play";
						up.state="intro_anim";
						room_scroll(null);

						_root.wetplay.PlaySFX("sfx_asue2",0,65536,1);
						
						saves_reset();
						
						_root.signals.signal("#(VERSION_NAME)","start",this);
						
					break;
					case "about":
						up.up.about.setup();
					break;
					case "score":
						up.up.high.setup();
					break;
					case "shop":
						getURL("http://link.wetgenes.com/link/ASUE2.shop","_blank");
					break;
					case "code":
						up.up.code.setup();
					break;
				}
			break;
		}
	}
	
}
