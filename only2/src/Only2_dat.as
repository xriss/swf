/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) Kriss Daniels 2007 http://www.XIXs.com
//
/*+-----------------------------------------------------------------------------------------------------------------+*/


// this data should mostly be considered read only, except for the vars array which changes


class Only2_dat
{
	var up;
	
	var vars;
	var room; 		// room data
	var rooms; 		// rooms data
	var items; 		// items data  [(roomid)*1024+item_number]
	
	var combine; 	// named objects that combine to another
	
	var demands;	// demands
	
	var item_nothing;

var hex="0123456789ABCDEF";
	
	function delegate(f,d)	{	return com.dynamicflash.utils.Delegate.create(this,f,d);	}
	
	function center(s)
	{
		return "<p align=\"center\">"+s+"</p>";
	}
	
	function n(id,name)
	{
		if(id>=0) // negative is special
		{
			id+=room.id*1024; // make id unique
		}
		
		var d={};
		
		if(items[name] ) // premade item?
		{
			d=items[name];
			items[id]=d;
		}
		else
		{
			if(name) { items[name]=d; d.name=name}
			items[id]=d;
			
			d.id=id;
			d.sign=delegate(sign,d);
			d.getscore=delegate(getscore,d);
			
			d.hex=hex.charAt(Math.floor(id/16)&0xf)+hex.charAt((id%16));
		}
		return d;
	}
	
	function sign(it,p,d)
	{
		if(d.html) { return "<font face=\"BloomingGrove\"><p align=\"center\">"+(d.html)+"</p></font>"; }
		return null;
	}
	function getscore(it,d)
	{
//dbg.print("stack:"+it.vars.stack);
//dbg.print("score:"+d.score);
	
		if(d.time_start)
		{
			if(d.score)
			{
				var p=0;
				if( it.vars.time>0 )
				{
					p=it.vars.time;
					return Math.floor( p*d.score/100 );
				}
			}
		}
		else
		if(it.vars.stack) // score*stack?
		{
			if(d.score) { return d.score*it.vars.stack; }
		}
		else
		{
			if(d.score) { return d.score; }
		}
		return 0;
	}

	function r(id)
	{
		room=[];
		rooms[id]=room;
		room.id=id;
		
		return room;
	}

	function get_room(id)
	{
		room=rooms[id];
		return room;
	}
	function get_item_in_room(id)
	{
		if(id>=0) // negative is special
		{
			return items[(room.id*1024)+id];
		}
		else
		{
			return items[id];
		}
	}
	function get_item(id)
	{
		return items[id];
	}
	
	function reset_vars() // stuff that changes
	{
		vars=[];
	}
	
	function combine_set(n1,n2,n3)
	{
		combine[n1+n2]=n3;
		combine[n2+n1]=n3;
	}

	function combine_get(n1,n2)
	{
		return combine[n1+n2];
	}

	function Only2_dat(_up)
	{
		up=_up;
		
		_root.sfx=delegate(sfx);
		
		var t=this;
		var d;
		var i;
		var c;
		
		vars=[];
		items=[];
		rooms=[];
		combine=[];
		demands=[];
		
//------------------------------------------------------------------------
		r(0); // items for room number
//------------------------------------------------------------------------
		
		room.level=new Run1Level_level_00();
		room.bak="level_00_bak";
		room.par="level_00_par";
		room.p01="level_00_p01";
		room.p01w=1280;
		room.p01h=540;
		
		d=n(0x10);
		d.type="door"; // entrance only
		d.img="null"; // do not display

		d=n(0x11);
		d.type="door";
		d.dest_room=1;
		d.dest_door=0x10;
		d.html=("A way out, or is it in?");
		d.room=1;
		d.door=0x10;

		d=n(0x20);
		d.html=("Sometimes I sit here and hug myself.");
		d.idle="embarrassed";
		d.type="sign";
		
		d=n(0x21);
		d.html=("If only I had never woken up.");
		d.idle="sleepy";
		d.type="sign";

/*
		d=n(0x24);
		d.html=("If only I could still sleep.");
		d.idle="sleepy";
		d.type="sign";
*/
		
		d=n(0x23);
		d.html=("My time machine is broken.<br> I may have to learn to live with the consequences of my actions.");
		d.idle="scared";
		d.type="sign";
		
		d=n(0x22);
		d.html=("If you can read this then you are still asleep.");
		d.idle="thoughtful";
		d.type="sign";
		d.sign=delegate(sign_cat_stuck,d);
		
		
		d=n(0x30,"light");
		d.html=("A super radish.");
		d.img="object_light";
		d.fizix="light";
		d.type="item";
		d.score=10*1;
		
		d=n(0x24,"heavy");
		d.html=("A sleeping fat cat.");
		d.img="object_heavy";
		d.fizix="heavy";
		d.type="item";
		d.score=100*10;
		
		d=n(0x31,"help");
		d.tard="xix";
		d.type="tard";
		d.say=delegate(say_help,d);
		d.sign=delegate(sign_convo,d);
		d.jump=delegate(jump_convo,d);

		c=[];
		d.convo=c;
		c.hello=["Welcome to the world of tomorrow!^nerdy",				"Press up (Jump) for more text.","hello2"];
		c.hello2=["Do you know the proper use of an ellipses?^thoughtful",		"Press up (Jump) for more text.","hello3"];
		c.hello3=["Well, I do not. So if you see one, it means I am waiting to say something else and you should press jump to read it.^sleepy",				"...","hello4"];
		c.hello4=["Jolly good. Now sometimes you can even choose a different response, move left or right and choose fish to continue...",		"pineapple","hello4b", "pumpkin","hello4b", "kitten","hello4b", "fish","hello5"];
		c.hello4b=["Try again. Move left or right and choose fish to continue...^sad",		"pineapple","hello4b", "pumpkin","hello4b", "kitten","hello4b", "fish","hello5" ];
		c.hello5=["Well done, your choice is fish. Now why don't you ask me a real question.",		"...","menu"];
		c.menu=["How may I help you?",
			"Is the time machine broken?","time_machine",
			"What are the keys?","keys",
			"Where am I?","where",
			"Who are you?","who",
			"Is this an art game?","art",
			"What should I do?","play",
			"You're weird.","towel",
			"What can I do if I get really, really, really stuck?","stuck"];
		c.time_machine=["I am not sure, maybe we could go forward in time and find out.","...","menu"];
		c.stuck=["Well, if you press Esc, the current world will reset and reload. But that should only be done as a last resort since it gives me the hiccups.^confused","...","menu"];
		c.keys=["The cursor keys are all you need to use. Up jumps up and down jumps down. Left and right are also suprisingly intuitive.^thoughtful","...","menu"];
		c.where=["Welcome to the world of tomorrow!^nerdy",				"...","menu"];
		c.who=["I am but one of the creators of this thing you call a game.^teapot",				"There is another creator?","who2"];
		c.who2=["Yes, but they are shy and believe that appearing in games steals a part of their soul.^embarrassed",				"...","menu"];
		c.art=["I believe you are confusing fashion with art and no, this is not a fashion game, nor is it fashionable to like it.^confused",				"...","menu"];
		c.play=["You should do whatever you want. If you do not know what you want then consider joining a religion.^devious",				"...","menu"];
		c.towel=["You sir, are a towel.^bird",				"...","menu" , "No, you're a towel.","towel2"];
		c.towel2=["Your a towel.^angry",				"...","menu" , "No, you're a towel.","towel"];
		
		
		d=n(0x26);
		d.html=("Some kind of obstacle obstructs me.");
		d.type="sign";
		
		d=n(0x27);
		d.html=("I am moving forwards and conquering obstacles.");
		d.type="sign";
		
		d=n(0x28);
		d.html=("But that obstacle might have been there for a reason.");
		d.type="sign";
		
		d=n(0x29);
		d.html=("I should just go to sleep.");
		d.idle="sleepy";
		d.type="sign";

		d=n(0x2a);
		d.html=("There could be anything ahead,<br> why am I even going there?");
		d.type="sign";

		d=n(0x2b);
		d.html=("Would you kindly spare a thought for my well-being?");
		d.type="sign";

		d=n(0x2c);
		d.html=("Should I jump?");
		d.type="sign";
		
		d=n(0x2d);
		d.html=("If I take risks then there are rewards.");
		d.type="sign";
		
		d=n(0x00,"nothing");
		d.html=("Nothing!");
		d.img="object_nothing";
		d.fizix="base";
		d.type="item";
		item_nothing=d;
//		d.sfx="drop";
		
		
		d=n(-300,"lock");
		d.html=("A lock");
		d.img="object_lock";
		d.type="item";
		
		d=n(-301,"unlock");
		d.html=("An open lock");
		d.img="object_unlock";
		d.type="item";
		
		
		d=n(0x32,"heavy");
		
//------------------------------------------------------------------------
		r(1); // items for room number
//------------------------------------------------------------------------
		
		room.level=new Run1Level_level_01();
		room.bak="level_01_bak";
		room.par="level_01_par";
		room.p01="level_01_p01";
		room.p02="level_01_p02";
		room.p01w=1400;
		room.p01h=540;
		room.p02w=1200;
		room.p02h=480;
		
		d=n(0x10);
		d.type="door";
		d.room=0;
		d.door=0x10;
		d.html=("A familiar door.");
		d.treasure="room_0";
		
		d=n(0x11);
		d.type="door";
		d.room=3;
		d.door=0x10;
		d.html=("A tasty door.");
		d.treasure="room_3";

		d=n(0x12);
		d.type="door";
		d.room=2;
		d.door=0x10;
		d.html=("A soggy door.");
		d.treasure="room_2";

		d=n(0x13);
		d.type="door";
		d.room=4;
		d.door=0x10;
		d.html=("A demanding door.");
		d.treasure="room_4";

		d=n(0x14,"exit_lock");
		d.type="door";
		d.room=5;
		d.door=0x10;
		d.html=("A Locked door.");
		d.sign=delegate(sign_locked,d);
		d.jump=delegate(jump_locked,d);
		d.treasure="room_5";

//		d=n(0x19,"help");
		
		d=n(0x20);
		d.type="sign";
		d.say=delegate(say_well1,d);
		d.sign=delegate(sign_convo,d);
		d.jump=delegate(jump_convo,d);

		c=[];
		d.convo=c;
		c.hello= ["I am the well dweller who lives in a well house for a large spring.",				"...","hello2"];
		c.hello2=["I demand treasure! Your world is my oyster, bring me pearls, bring me food, bring me trinkets, bring me a shrubbery, bring me tribute.",									"...","hello3"];
		c.hello3=["For I am the well dweller who lives in a well house for a large spring and you must heed my words.",									"...","hello4"];
		c.hello4=["Now lead on adventurer and scrump like you have never scrumped before.",				"...","hello"];

		d=n(0x21);
		d.type="sign";
		d.say=delegate(say_well3,d);
		d.sign=delegate(sign_convo,d);
		d.jump=delegate(jump_convo,d);
		
		c=[];
		d.convo=c;
		c.hello= ["The door that is locked shall remain so until you bring me tribute.",				"...","hello"];
		c.unlock= ["The door that was once locked is now unlocked by way of your actions.",				"...","unlock"];
		
		d=n(0x22);
		d.html=("Made it, Ma. Top of the world!");
		d.type="sign";
		d.sign=delegate(sign_top_world,d);

		d=n(0x23);
		d.type="tard";
		d.say=delegate(say_well2,d);
		d.sign=delegate(sign_convo,d);
		d.jump=delegate(jump_convo,d);
		
		c=[];
		d.convo=c;
		c.hello= ["",				"...","hello"]; // an empty hello that releases focus
		c.scrump1= ["Your first tribute is adequate, but be aware that I hunger for more.",				"...","hello"];
		c.scrump2= ["Your second tribute is also adequate, but be aware that I hunger for more.",				"...","hello"];
		c.scrump3= ["Your third tribute is more adequate than the last, but be aware that I hunger for more.",				"...","hello"];
		c.scrump4= ["Your tribute is adequate. The locked door is no longer so. Do remember however, that failure to achieve is its own reward.",			"...","hello"];
		c.scrump5= ["Your tribute is fine. The locked door is no longer so. Before you leave, let me warn you of the handsome stranger at the end of the tunnel.",				"...","hello"];
		c.scrump6= ["Your tribute is good. The locked door is no longer so. Hear me when I say, beware the spectrum of colours.",				"...","hello"];
		c.scrump7= ["Your tribute is great and you have my utmost gratitude. The locked door is no longer so and I shall leave you with this advice, the journey means far more than the destination.",				"...","hello"];
		c.scrump8= ["Your tribute is indeed marvellous and you have my utmost gratitude. I'll have you know, the locked door is no longer so. You may leave me to my feast, friend.",			"...","hello"];

//------------------------------------------------------------------------
		r(2); // items for room number
//------------------------------------------------------------------------
		
		room.level=new Run1Level_level_02();
		room.bak="level_02_bak";
		room.par="level_02_par";
		room.p01="level_02_p01";
		room.p01w=720;
		room.p01h=960;
		
		d=n(0x10);
		d.type="door";
		d.room=1;
		d.door=0x12;
		d.html=("This door seems to be judging me.");
		
		d=n(0x30,"fish");
		d.html=("This is exactly what a kitten would look like if it lived in the sea.");
		d.img="object_fish";
		d.type="item";
		d.time_update=-0.02;
		d.time_start=100;
		d.time_refresh_idx=0x30;
		d.score=1000*1;
		
		d=n(0x50);
		d.tard="fisher";
		d.hold="knife";
		d.type="tard";
		d.sign=delegate(sign_convo,d);
		d.say=delegate(say_fish,d);
		d.jump=delegate(jump_convo,d);

		c=[];
		d.convo=c;
		c.hello=["I have a very sharp knife.<br>Bring me a fish to find out how sharp.",
					"You scare me!","hurt",
					"What will you do to fish?","what",
					"Where is the fish?","where"];
		c.hurt=["Do not be afraid little fishy.","...","hello"];
		c.what=["I will love the fishy for only one, such as I, can truely love the fishy.","...","hello"];
		c.where=["The fish is in the depths, make it quick to keep it fresh.","...","hello"];
		c.got=["Here is your new fish, twice as good as the old fish.","...","done"];
		c.done=["My work here is done, be gone with you.","...","done"];


		d=n(-100,"knife");
		d.html=("A very sharp knife.");
		d.img="object_knife";
		d.type="item";
		d.score=100*1;

		d=n(-101,"sashimi");
		d.html=("Raw tasty fish.");
		d.img="object_sashimi";
		d.type="item";
		d.time_update=0;
		d.time_start=100;
		d.time_refresh_idx=-1;
		d.score=10000*1;
		
		d=n(0x40);
		d.html=("It looks like the only way up is down.");
		d.type="sign";
		
		d=n(0x41);
		d.html=("I should pay attention on the way down so I know how to get back up.");
		d.type="sign";
		
		d=n(0x42);
		d.html=("Or maybe I should just jump down as fast as I can it doesn't seem to hurt.");
		d.type="sign";
		
		d=n(0x43);
		d.html=("43");
		d.type="I could probably jump straight down from here.";
		
		d=n(0x44);
		d.html=("What a lovely view.");
		d.type="sign";
		
		d=n(0x45);
		d.html=("This reminds me of my childhood.");
		d.type="sign";

		d=n(0x46);
		d.html=("I wonder if this side is quicker or slower?");
		d.type="sign";
		
		d=n(0x47);
		d.html=("I can smell something fishy.");
		d.type="sign";
		
		d=n(0x48);
		d.html=("Fish gives you brains!");
		d.type="sign";

		d=n(0x49);
		d.html=("Brains makes you money!");
		d.type="sign";
		
		d=n(0x4a);
		d.html=("Money to buy more fish!");
		d.type="sign";
		
		d=n(0x4b);
		d.html=("The holy trinity of fish, brains and money.");
		d.type="sign";	
/*
		d=n(0x4c);
		d.html=("4c");
		d.type="sign";
*/	
		d=n(0x4d);
		d.html=("That looks like a short cut, Maybe I shall just exit stage left.");
		d.type="sign";
/*		
		d=n(0x4e);
		d.html=("4e");
		d.type="sign";
		
		d=n(0x4f);
		d.html=("4f");
		d.type="sign";
*/
		
//------------------------------------------------------------------------
		r(3); // items for room number
//------------------------------------------------------------------------
		
		room.level=new Run1Level_level_03();
		room.bak="level_03_bak";
		room.par="level_03_par";
		room.p01="level_03_p01";
		room.p01w=1280;
		room.p01h=540;


		d=n(0x10);
		d.type="door";
		d.room=1;
		d.door=0x11;
		d.html=("This door seems to be judging me.");
		
		d=n(0x40,"milk");
		d.html=("Cow juice.");
		d.img="object_milk";
		d.type="item";
		d.fizix="slow";
		d.score=200;

		d=n(0x42,"bread");
		d.html=("There is nothing more wonderful than the scent of freshly baked bread.");
		d.img="object_bread";
		d.type="item";
		d.score=100;

		d=n(0x44,"eggs");
		d.html=("These eggs are not green.");
		d.img="object_eggs";
		d.type="item";
		d.score=200;
		
		d=n(0x46,"cheese");
		d.html=("This cheese is like nectar.");
		d.img="object_cheese";
		d.type="item";
		d.score=500;

		d=n(-200,"sludge");
		d.html=("sludge.");
		d.img="object_sludge";
		d.type="item";
		d.score=10;
		
		d=n(-201,"toast");
		d.html=("Toasted bread.");
		d.img="object_toast";
		d.type="item";
		d.score=1000;
		
		d=n(-202,"cheese_on_toast");
		d.html=("Cheese melted upon toast.");
		d.img="object_cheese_on_toast";
		d.type="item";
		d.score=3000;

		d=n(-203,"boiled_eggs");
		d.html=("Eggs dipped in hot water.");
		d.img="object_boiled_eggs";
		d.type="item";
		d.score=2000;

		d=n(-204,"eggy_soldiers");
		d.html=("Eggy soldiers.");
		d.img="object_eggy_soldiers";
		d.type="item";
		d.score=4000;

		d=n(-205,"french_toast");
		d.html=("French toast.");
		d.img="object_french_toast";
		d.type="item";
		d.score=3000;
		
		d=n(-206,"omelette");
		d.html=("Omelette.");
		d.img="object_omelette";
		d.type="item";
		d.score=4000;
		
		d=n(-207,"cheese_omelette");
		d.html=("Cheese omelette.");
		d.img="object_cheese_omelette";
		d.type="item";
		d.score=6000;

		d=n(-208,"eggy_bread");
		d.html=("Eggy bread.");
		d.img="object_sludge";
		d.type="item";
		d.score=200;

		d=n(-209,"eggy_milk");
		d.html=("Eggy milk.");
		d.img="object_sludge";
		d.type="item";
		d.score=200;
		
		d=n(0x21,"combiner");
		d.html=("A combiner, with this tool two objects may become one.");
		d.img="object_combiner";
		d.type="tool";
		d.inputs=1;
		d.sfx=delegate(sfx,"combine");

		d=n(0x20,"cooker");
		d.html=("A cooker, cooking food for the use of.");
		d.img="object_cooker";
		d.type="tool";
		d.tool="heat";
		d.sfx=delegate(sfx,"cook");

		d=n(0x22);
		d.html=("I am the master taster.");
		d.tard="taster";
		d.type="tard";
		d.sign=delegate(sign_convo,d);
		d.say=delegate(say_taste,d);
		d.jump=delegate(jump_convo,d);
		
		c=[];
		d.convo=c;
		c.hello=["I am the master taster.<br>My taste is legendary.",
					"Already I feel uncomfortable with this conversation.^confused","dump",
					"Do you do anything apart from taste things?^thoughtful","taste",
					"Will you taste this for me?","score"];
		c.dump=["Do not be afraid, little dumpling.","...^scared","hello"];
		c.taste=["Taste is the center of my life so let it be known that I am prepared to be tasted at any time.^nerdy","...^embarrassed","hello"];
		c.score=["CONVO_S","...","hello"];
		
		
		
		d=n(0x30,"nothing");
		d=n(0x31,"nothing");
		
		d=n(0x52,"bread");
		
		d=n(0x50);
		d.html=("Someone has installed a kitchen in the sky.");
		d.type="sign";
		
		d=n(0x51);
		d.html=("I bet I could climb in through the roof if I tried.");
		d.type="sign";
		
		combine_set("heat","bread","toast");
		combine_set("toast","cheese","cheese_on_toast");

		combine_set("heat","eggs","boiled_eggs");
		combine_set("toast","boiled_eggs","eggy_soldiers");

		combine_set("eggs","milk","eggy_milk");
		combine_set("eggs","bread","eggy_bread");
		
		combine_set("heat","eggy_bread","french_toast");
		combine_set("heat","eggy_milk","omelette");
		
		combine_set("omelette","cheese","cheese_omelette");
		
//------------------------------------------------------------------------
		r(4); // items for room number
//------------------------------------------------------------------------
		
		room.level=new Run1Level_level_04();
		room.bak="level_04_bak";
		room.par="level_04_par";
		room.p01="level_04_p01";
		room.p01w=1280;
		room.p01h=960;
		
		d=n(0x10);
		d.type="door";
		d.room=1;
		d.door=0x13;
		d.html=("This door seems to be judging me.");

		d=n(0x30,"weap_knife");
		d.type="item";
		d.flavour="weapon";
		d.img="object_knife";
		d.html=("A device for stabbing and cutting with.");
		d.w_dx=100;
		d.w_dy=75;
		d.w_1=0.25;
		d.w_2=0.05;

		d=n(0x3f);
		d.type="engine";
		d.flavour="mob_fodder";
		d.e_rate=0.001;
		d.e_max=1;

		d=n(0x1000,"mob_fodder");
		d.type="mob";
		d.tard="taster";
		d.hold="weap_knife";
		d.brain="roam";
		
		d=n(0x1001,"loot_coin");
		d.html=("A super radish.");
		d.img="object_light";
		d.fizix="light";
		d.type="loot";
		d.score=10*1;
		
		
//------------------------------------------------------------------------
		r(5); // items for room number
//------------------------------------------------------------------------
		
		room.level=new Run1Level_level_05();
		room.bak="level_05_bak";
		room.par="level_05_par";
		
		d=n(0x10);
		d.type="door";
		d.room=1;
		d.door=0x14;
		d.html=("The way back is blocked but you think you can hear a squeaky voice telling you to go into the light.");
		d.jump=function(){return false;};

		d=n(0x20);
		d.type="sign";
		d.html="What is this place?";
		
		d=n(0x21);
		d.type="sign";
		d.html="Those things...they look like horribly painted portraits captured within tacky golden frames, all of them alike.";
		
		d=n(0x22);
		d.type="sign";
		d.html="They seem to be in a state of much unpleasantness too. One might even say they look horrified.";
		
		d=n(0x23);
		d.type="sign";
		d.html="If only I could go back through that door somehow.";
		
		d=n(0x24);
		d.type="sign";
		d.html="This place makes me feel uncomfortable but I haven't any other choice but to keep moving forwards.";
		
		d=n(0x26);
		d.type="sign";
		d.html="I think I've seen that person in the portrait before.";
		
		d=n(0x27);
		d.type="sign";
		d.html="No, maybe not.";
		
		d=n(0x28);
		d.type="sign";
		d.html="This is ridiculous. I want my mommy.";
		
		d=n(0x29);
		d.type="sign";
		d.html="Wait a minute, I think I hear something.";
		
		d=n(0x2a);
		d.type="sign";
		d.html="The light at the end of the tunnel!";
		
		d=n(0x2f);
		d.type="spesh";
		d.spesh=delegate(sign_exit,d);

		d=n(0x2b);
		d.type="spesh";
		d.img="null";//"object_portrait";
		d.spesh=delegate(sign_portrait,d);
		
//------------------------------------------------------------------------
		r(6); // items for room number
//------------------------------------------------------------------------
		
		room.level=new Run1Level_level_06();
		room.bak="level_06_bak";
		room.par="level_06_par";
		room.p01="level_06_p01";
		room.p01w=800;
		room.p01h=600;
		
		d=n(0x10);
		d.type="door";
		d.room=1;
		d.door=0x13;
		d.html=("This door seems to be judging me.");






//------------------------------------------------------------------------
//------------------------------------------------------------------------

		reset_vars();
	}
	
	function sign_cat_stuck(it,p,d)
	{
		var hold=it.up.player.hold;
		if(hold.d.name=="heavy")
		{
_root.signals.submit_award("cat_stuck");
		}
		return sign(it,p,d);
	}
	
	function sign_top_world(it,p,d)
	{
_root.signals.submit_award("top_world");
		return sign(it,p,d);
	}
	
	// show portrait
	function sign_portrait(it,act)
	{
		var v=it.vars;
		
		if(act=="on")
		{
			if(!v.done_portrait)
			{
				v.done_portrait=true;
				it.set_img("object_portrait");
				it.set_img_xy(-50,-300);
				sfx("portrait");
_root.signals.submit_award("portrait");
			}
		}
	}
	// end game
	function sign_exit(it,p,d)
	{
		up.up.state_next="rainbow";
		if(!_root.swish) // do not cancel old swish
		{
			_root.swish.clean();
			_root.swish=(new Swish({style:"fade",mc:up.mc,w:640,h:480})).setup();
		}
	}
	
	function say_taste(it,p,d)
	{
		var v=it.vars;
		
		var hold=it.up.player.hold;
		var s=d.html;
		
		if(hold.d.name!="nothing")
		{
			v.convo_s="This tastes like "+hold.d.score+" points.^working";
//			v.convo="score";
		}
		else
		{
			v.convo_s="This tastes like pure air with a hint of greasy knuckles.^working";
		}
		_root.sfx("taster1");
		_root.sfx("taster2");
		
		return say_convo(it,p,d);
	}
	
	function jump_convo(it,d)
	{
		var v=it.vars;
		if(!v.convo){v.convo="hello"};
		var c=d.convo[v.convo];
		
		if(v.convo_goto==v.convo) // nothing to say
		{
			return false;
		}
		
		if(d.convo[v.convo_goto]) { v.convo=v.convo_goto; return true; } // goto new state if valid
		
	}
	function sign_convo(it,p,d)
	{
	var i;
	
		var v=it.vars;
		if(!v.convo){v.convo="hello"};
		var c=d.convo[v.convo];
		
		var t=[];//["You scare me!","why?","What will you do to the fish?"];
		for(i=1;i<c.length;i+=2)
		{
			t[(i-1)/2]=c[i];
		}
		
		i=Math.floor(p/(1/t.length))
		if(i<0){i=0;}
		if(i>d.length){i=t.length-1;}
		var s=t[i];
		
		v.convo_goto=c[2+i*2];
		
		var emote="idle";
		var sa=s.split("^");
		if(sa[1]) // got an emote
		{
			s=sa[0];
			emote=sa[1];
		}
		it.up.player.idle_anim=emote;
		
		if((s=="...")&&(v.convo_goto==v.convo)) // hide loops
		{
			if(up.run.focus.force) // unforce
			{
				up.run.focus.set(up.run.player,1/16);
				up.run.focus.force=undefined;
			}
			return undefined;
		}
		
		return "<font face=\"BloomingGrove\" color=\"#00ff00\"><p align=\"center\">"+(s)+"</p></font>";
	}
	function say_convo(it,p,d)
	{
		var s="...";
		var v=it.vars;
		if(!v.convo){v.convo="hello"};
		var c=d.convo[v.convo];
		if(c) { s=c[0]; }
		
		if(s=="") { return null; }
		
		if(s=="CONVO_S")
		{
			s=v.convo_s;
		}
		
		var emote="idle";
		var sa=s.split("^");
		if(sa[1]) // got an emote
		{
			s=sa[0];
			emote=sa[1];
		}
		it.tard.idle_anim=emote;
		
		return "<font face=\"BloomingGrove\"><p align=\"center\">"+(s)+"</p></font>";
	}
	
	function say_help(it,p,d)
	{
		_root.sfx("help1");
		_root.sfx("help2");
		return say_convo(it,p,d);
	}
	
	function say_well1(it,p,d)
	{
		_root.sfx("well1");
		_root.sfx("well2");
		return say_convo(it,p,d);
	}

	function say_well3(it,p,d)
	{
		var lock=vars["room_"+5];
		if(lock.name=="unlock")
		{
			it.vars.convo="unlock"; // change to open msg
		}
		
		
		_root.sfx("well1");
		_root.sfx("well2");
		return say_convo(it,p,d);
	}
	
	function say_well2(it,p,d)
	{
		var v=it.vars;
		if((v.convo)&&(v.convo!="hello"))
		{
			_root.sfx("well1");
			_root.sfx("well2");
		}
		return say_convo(it,p,d);
	}

	function say_fish(it,p,d)
	{
		var v=it.vars;
		
		var hold=it.up.player.hold;
		var s=d.html;
		
		if(hold.d.name=="fish")
		{
			_root.sfx("transform");
			
			it.vars.done=true;
			
			var vs={};
			vs.name="sashimi";
			vs.time=hold.vars.time;
			
			hold.setup_id(vs);
			
			v.convo="got";
		}
		
		_root.sfx("fisherman1");
		_root.sfx("fisherman2");
		
		return say_convo(it,p,d);
	}
	
	function say_demand(it,p,d)
	{
		var v=it.vars;
		var hold=it.up.player.hold;
		var s=d.html;
		
		if(!it.vars.demnum) {it.vars.demnum=0;}
		
		var dem=demands[ it.vars.demnum ];
		
		
		if(dem)
		{
			v.convo_s=dem.s;
			
			if(hold.d.name=="dem_"+dem.name) // got it
			{
				_root.sfx("transform");
				
				it.launch("hearts");
			
				it.vars.demnum++;
			
				var vt={};
				vt.name="light";
				vt.stack=10*it.vars.demnum;
				
				hold.setup_id(vt);
				
				v.convo="got";
			}
		}
		else
		{
			v.convo="done";
		}
		
		_root.sfx("demand1");
		_root.sfx("demand2");
			
		return say_convo(it,p,d);
	}
	
	function sign_locked(it,p,d)
	{
		if(vars["room_do_unlock"])
		{
			var unlock=get_item("unlock");
			vars["room_"+5]=unlock;
			it.treasure.setup_id(unlock);
			it.launch("confetti");
			vars["room_do_unlock"]=false;
			sfx("unlock");
		}
		
		
		var lock=vars["room_"+5]
		var s=d.html;
		
		if(lock.name=="unlock")
		{
			s="An unlocked door!";
		}
		else
		{
			s="A locked door!";
		}
		return "<font face=\"BloomingGrove\"><p align=\"center\">"+(s)+"</p></font>";
	}
	
	function jump_locked(it,d)
	{

		var lock=vars["room_"+5]
		if(lock.name=="unlock")
		{
			up.change_room(d.room,d.door);
			return true;
		}
		else
		{
			return false;
		}
	}
	
	function sfx_stop(c)
	{
		_root.wetplay.wetplayMP3.PlaySFX(null,c);
	}
	
	function sfx(nam)
	{
	var p_name;
	var p_chan=0;
	var p_loop=1;
	var p_volume=1;
	var p_check=false;
	
		switch(nam)
		{
			case "drop":
				p_name="sfx_ping04"; p_chan=1;
			break;
			
			case "step":
				p_name="sfx_walk"; p_chan=0; p_volume=0.5;
			break;
			
			case "fisherman1":
				p_name="sfx_sleeze03"; p_chan=3; p_check=true;
			break;
			case "fisherman2":
				p_name="sfx_man005"; p_chan=2; p_check=true;
			break;
			
			case "help1":
				p_name="sfx_tune001"; p_chan=3; p_check=true;  p_volume=0.5;
			break;
			case "help2":
				p_name="sfx_man010"; p_chan=2; p_check=true;  p_volume=2;
			break;
			
			case "well1":
				p_name="sfx_dweller"; p_chan=3; p_check=true;
			break;
			case "well2":
				p_name="sfx_man007"; p_chan=2; p_check=true;  p_volume=3;
			break;
			
			case "demand1":
				p_name="sfx_sleeze01"; p_chan=3; p_check=true;
			break;
			case "demand2":
				p_name="sfx_woman004"; p_chan=2; p_check=true;
			break;
			
			case "taster1":
				p_name="sfx_sleeze02"; p_chan=3; p_check=true;
			break;
			case "taster2":
				p_name="sfx_man008"; p_chan=2; p_check=true;
			break;
			
			case "transform":
				p_name="sfx_uhm05"; p_chan=1; p_check=true;
			break;
			
			case "cook":
				p_name="sfx_cook"; p_chan=1; p_check=true;
			break;
			
			case "unlock":
				p_name="sfx_trump02"; p_chan=1; p_check=true;
			break;
			
			case "portrait":
				p_name="sfx_portrait"; p_chan=1; p_check=true;
			break;
			
			case "combine":
				p_name="sfx_scratch02"; p_chan=1; p_check=true;
			break;
			
			case "loading":
				p_name="sfx_loading"; p_chan=1;
				_root.wetplay.wetplayMP3.PlaySFX(null,0); // stop all other sounds
				_root.wetplay.wetplayMP3.PlaySFX(null,2);
				_root.wetplay.wetplayMP3.PlaySFX(null,3);
				_root.wetplay.wetplayMP3.PlaySFX(null,4);
				_root.wetplay.wetplayMP3.PlaySFX(null,5);
			break;
			
			case "splat":
				p_name="sfx_splat01"; p_chan=1;
			break;
			
			case "jump":
				p_name="sfx_jump01"; p_chan=1;
			break;
			
			case "tards":
				p_name="sfx_tards"; p_chan=4; p_loop=65536;
			break;
			
			case "rain":
				p_name="sfx_rain"; p_chan=4; p_loop=65536;
			break;
		}
		
		if(p_name)
		{
//dbg.print(p_name);
			if(p_check) // do not start the same sound again until it stops
			{
				p_check=!_root.wetplay.wetplayMP3.CheckSFX(p_name,p_chan);
			}

			if(!p_check)
			{
				_root.wetplay.wetplayMP3.PlaySFX(p_name,p_chan,p_loop,p_volume);
			}
		}
	}
}