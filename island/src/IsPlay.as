/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) Kriss Daniels 2006 http://www.XIXs.com
//
/*+-----------------------------------------------------------------------------------------------------------------+*/

#include "src/opts.as"


class IsPlay
{
	var mc:MovieClip;

	var up;
	
	var advent;
	
	var mc_look;
	var look;
	
	var mc_back;
	var back;
	var back_name;
	
	var timeslice;
	
//	var high;
	
	function IsPlay(_up)
	{
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
		mc=gfx.create_clip(up.mc,null);
		mc.cacheAsBitmap=true;
		
		mc_back=gfx.create_clip(mc,null);
		
		mc_look=gfx.create_clip(mc,null);
	    mc_look.filters = [ new flash.filters.DropShadowFilter(2, 45, 0x000000, 1, 4, 4, 2, 3) ];
		
		look=gfx.create_text_html(mc_look,null,25,25,750,1000);
		
		back_name=null;
		
//		high=new PlayHigh(this);
		
		initialise();
		
		thunk();
		
		
		_root.signals.signal("adventisland","start",this);
	
		up.high.setup();
	}
	
	function clean()
	{
		_root.signals.signal("adventisland","end",this);
		
		mc.removeMovieClip();
	}

	function update()
	{
		_root.signals.signal("adventisland","update",this);
		
//		thunk();
	}
	
	function scored()
	{
		_root.signals.signal("adventisland","high",this);
		up.high.setup();
	}

	function thunk()
	{
	var i;
	var s;
	var moves;
	var carry;
	var see;
	
	moves=[];
	carry=[];
	see=[];
	
	_root.advent=advent;
	
	var guided = (advent.isCarried(GUIDE) && !(advent.room >= 0x2B && advent.room <= 0x35));
	
	// process object locations
		for( i=0 ; i < advent.item.length ; i++ )
		{
			if(advent.isCarried(i))
			{
				s="";
				s+="<a href=\"asfunction:_root.advent.put,"+i+"\"><b>";
				s+=advent.item[i];
				s+="</b></a>";
				carry[carry.length]=s;
			}
			else
			if(advent.isHere(i))
			{
				s="";
				s+="<a href=\"asfunction:_root.advent.get,"+i+"\"><b>";
				s+=advent.item[i];
				s+="</b></a>";
				see[see.length]=s;
			}

		}
	// available moves
		for(i=0; i < dirnames.length ;i++)
		{
			if( (advent.gate[i]) || (!guided) )
			{
				s="";
				s+="<a href=\"asfunction:_root.advent.move,"+i+"\"><b>";
				s+=dirnames[i];
				s+="</b></a>";
				moves[moves.length]=s;
			}
		}
	
	
		s="";

		s+="<p>" + advent.text + "</p>";
		
		if(see.length>0)
		{
			s+="<p> </p><p>";
			for(i=0;i<see.length;i++)
			{
				if(i==0) // first
				{
					s+="You can see "+see[i];
				}
				else
				if((i>0) && (i==see.length-1)) // last
				{
					s+=" and "+see[i];
				}
				else
				{
					s+=" here, "+see[i];
				}
			}
			s+=".</p>";
		}
		

		if(moves.length>0)
		{
			s+="<p> </p><p>";
			for(i=0;i<moves.length;i++)
			{
				if(i==0) // first
				{
					s+="Go "+moves[i];
				}
				else
				if((i>0) && (i==moves.length-1)) // last
				{
					s+=" or "+moves[i];
				}
				else
				{
					s+=", "+moves[i];
				}
			}
			s+=".</p>";
		}

		s+="<p> </p><p>";
		s+="You have ";
		
		s+="<a href=\"asfunction:_root.island.isplay.scored\"><b>";
		s+="scored";
		s+="</b></a>";
				
		s+=" "+advent.score+" points.";
		s+=".</p>";

		if(carry.length>0)
		{
			s+="<p> </p><p>";
			for(i=0;i<carry.length;i++)
			{
				if(i==0) // first
				{
					s+="You are holding "+carry[i];
				}
				else
				if((i>0) && (i==carry.length-1)) // last
				{
					s+=" and "+carry[i];
				}
				else
				{
					s+=", "+carry[i];
				}
			}
			s+=".</p>";
		}

		gfx.set_text_html(look,28,0xffffff,s);

// bodge scale the text :)
		
		if( look.textHeight>550 )
		{
			look._yscale=100 * (550/look.textHeight);
		}
		else
		{
			look._yscale=100;
		}

// check if the background has changed		

		if(back_name!=advent.pix[advent.room])
		{
			back_name=advent.pix[advent.room];
			
			back.removeMovieClip();

			back=gfx.add_clip(mc_back,back_name,null);
			
		}
		
	}

	
	
/*
This program was written to determine if JavaScript is a good language for 
writting text adventure games. The actual game is intended to be no more than
the mimimum playable game necessary to demonstrate available features.

The conclusion is that not only is JavaScript a good language for writing text
adventures, it is very possibly the ideal choice. In particular, the cookie
feature is well so suited to game saving it could have been designed for it.

The design centres around the Advent object which contains the map, the room
descriptions, the item descriptions and their locations. In response to move,
get and put commands it does nothing more than update its internal state. It
knows nothing of the user interface or special properties of rooms and objects,
these are all implemented by attaching callbacks to state change.


from

http://rays.wetgenes.com/Advent.htm


Now tweaked into AS2 and a simple flash interface

*/

////////////////////////////////////////////////////////////////////////////////
//
//								Button class
//
//	Nothing abstract about this class. It directly accesses members of Advent
//	and also is dependent on the physical buttons.
//
/*
function ButtonObject(nl)
{
	this.guided = true;
	this.buttons = new Array(11);

	for(var i=0; i < 11 ;i++)
		this.buttons[i] = nl.item(i);

	this.buttons[10] = this.buttons.splice(5,1)[0];

	for(i=0; i < 10 ;i++)
		this.buttons[i].onclick = new Function("", "advent.move(" + i + ")");

	this.buttons[10].onclick = new Function("", "advent.move(-1)");
}

ButtonObject.prototype.enable = function()
{
	var i;
	var exit;

	if(this.guided)
	{
		for(i=0; i < 10 ;i++)
			this.buttons[i].disabled = !advent.gate[i];
	}
	else
	{
		exit = false;
		for(i=0; i < 10 ;i++)
			exit |= advent.gate[i];
	
		for(i=0; i < 10 ;i++)
			this.buttons[i].disabled = !exit;
	}
	this.buttons[10].disabled = (advent.back == 0);
}
*/

////////////////////////////////////////////////////////////////////////////////
//
//	Global variables
//

//	objects
//var advent;
var Buttons;

// display elements we write to
var Screen;
var Carrying;
var RoomNo;	// debug only

////////////////////////////////////////////////////////////////////////////////
//
//	onload method of body
//
function initialise()
{
var i;

/*
	Screen = document.getElementById("screen");
	Carrying = document.getElementById("carry");
	RoomNo = document.getElementById("roomno");
*/

	timeslice=0;

	
	itemLocations=[0xffff, 0, 5, 0x11, 9, 0x18, 0x24, 0x34];

	advent = new Advent(map, items , itemLocations);

	for(i=0;i<items.length;i++)
	{
		advent.onGet(		i,		delegate(	gotmisc,i		));
		advent.onPut(		i,		delegate(	putmisc,i		));
	}
	
//	advent.onGet(		0,			delegate(	tryload		));
//	advent.onGet(		1,			delegate(	tryload		));
//	advent.onGet(		GOLD,		delegate(	ballroom	));
//	advent.onGet(		BRASS,		delegate(	ballroom	));
	
//	advent.onPut(		1,			delegate(	save		));
//	advent.onPut(		GOLD,		delegate(	ending		));
	
	advent.onEnter(		8,			delegate(	setdoors	));
	advent.onEnter(		0x35,		delegate(	dead		));
	advent.onEnter(		0x3E,		delegate(	exit		));
	advent.onEnter(		0x3F,		delegate(	finished	));
	
	advent.onMoved = delegate(display);

//	Buttons = new ButtonObject(document.getElementById("Left").getElementsByTagName("button"));

	// if there's a saved game, put the chip in the gazebo
/*
	if(document.cookie.match(/State/))
		advent.here[0] = 2;
*/

//	bottom.innerHTML = document.cookie;

	display();
}

////////////////////////////////////////////////////////////////////////////////
//
//	Called whenever the state changes:- move/get/put
//
function display()
{
	thunk();
/*	
	var tmpScreen = "";
	var tmpCarry = "";

	// process object locations
	for(var i=0; i < advent.item.length ;i++)
	{
		if(advent.isCarried(i))
			tmpCarry = tmpCarry + "<LI class=hot onclick='advent.put(" + i + ")'>" + advent.item[i];
			
		else if(advent.isHere(i))
			tmpScreen = tmpScreen + "There is <SPAN class=hot onclick='advent.get(" + i + ")'>" + advent.item[i] + "</SPAN> here. ";
	}

	// display room description and carrying
	Screen.innerHTML = "<P>You are " + advent.text + "<P>" + tmpScreen;
	Carrying.innerHTML = tmpCarry;

	// if carring guide and not in cave
	Buttons.guided = (advent.isCarried(GUIDE) && !(advent.room >= 0x2B && advent.room <= 0x35));

	Buttons.enable();

	// debug display room number
//	RoomNo.innerHTML = "0x" + advent.room.toString(16);

*/
}

////////////////////////////////////////////////////////////////////////////////
//
//	Move callbacks
//

//	Entered the temple, Set the door locks
function setdoors()
{
	advent.gate[S] = false;
	advent.gate[SW] = false;
	advent.gate[SE] = false;
	advent.gate[NE] = false;
	advent.gate[NW] = false;
	
	if(advent.isCarried(TORCH))
	{
		if(timeslice<4)
		{
			timeslice=4;
		}
	}
	else
	if(advent.isCarried(FLEECE))
	{
		if(timeslice<3)
		{
			timeslice=3;
		}
	}
	else
	if(advent.isCarried(SANDALS))
	{
		if(timeslice<2)
		{
			timeslice=2;
		}
	}
	else
	if(advent.isCarried(SUNNIES))
	{
		if(timeslice<1)
		{
			timeslice=1;
		}
	}
	
	switch(timeslice)
	{
		case 0: advent.gate[S]  = true; break;
		case 1: advent.gate[SW] = true; break;
		case 2: advent.gate[SE] = true; break;
		case 3: advent.gate[NE] = true; break;
		case 4: advent.gate[NW] = true; break;
	}
}

//	ball on head
function dead()
{
	for(var i=0; i < 8 ;i++)
		advent.here[i] = 0xffff;
}

//	penultimate location
function exit()
{
//	advent.gate[W] = !advent.isCarried(GUIDE);	// can't exit carrying guide
}

//	entered final location
function finished()
{
// just auto dump everything
	for(var i=0; i < 8 ;i++) advent.here[i] = 0xffff;
		
	advent.score+=1000;
	
	_root.signals.signal("adventisland","won",this);
		
	advent.back = 0;	// disable back on final screen
}

////////////////////////////////////////////////////////////////////////////////
//
//	get/put callbacks
//

//	chip or guide has been got
function tryload()
{
	if(advent.isCarried(CHIP) && advent.isCarried(GUIDE))
		restore();
}

//	brass star or gold star has been got
function ballroom()
{
	// but not in the ballroom
	if(advent.room != 0x34)
		return;

	// if nether star is now here
	if(!advent.isHere(BRASS) && !advent.isHere(GOLD))
		advent.jump(0x35);	// ball on head
}

//	dropped gold star
function ending()
{
	// but not in temple
	if(advent.room != 9)
		return;

	advent.here[GOLD] = 0xffff;
	
	advent.score+=1000;

	advent.jump(0x36);
}


function gotmisc(id)
{

//	if(advent.room!=0x3E) // no loss or gain of score when droping or getting items at pre exit strip
	{
		advent.score+=scoreof[id];
	}

	if( (id==GOLD) || (id==BRASS) )
	{
		ballroom()
	}
}
function putmisc(id)
{

//	if(advent.room!=0x3E) // no loss or gain of score when droping or getting items at pre exit strip
	{
		advent.score-=scoreof[id];
	}
	
	if( (id==GOLD) )
	{
		ending();
	}
}


////////////////////////////////////////////////////////////////////////////////
//
//	save/restore
//
function save()
{
/*
	var d = new Date();
	var a = Array(advent.room, 0);

	d.setDate(d.getDate()+30);

	if(document.cookie.match(/Room/))
	{
		document.cookie = "Room";
		document.cookie = "ObjectLocations";
	}
	document.cookie = "State=Array(" + a.concat(advent.here.slice(2)) + "); Expires=" + d.toUTCString();
*/
}

function restore()
{
/*
	var State;
	var r = document.cookie.match(/State.*\)/);

	if(!r)
		return;

	eval(r[0]);

	advent.here = Array(0xffff, 0).concat(State.slice(2));
	advent.jump(State[0]);
*/
}

////////////////////////////////////////////////////////////////////////////////
//
//	UI function only, not part of gameplay
//
function swapsides()
{
/*
	var row = document.getElementById("row2");
	var tds = row.getElementsByTagName("TD");

	// replaceChild returns the deleted tds[0] so I can just re-append it
	row.appendChild(row.replaceChild(tds[2], tds[0]));

	document.getElementById("hand").innerHTML = tds[2].id + " Handed";

	return;
*/
}

	

////////////////////////////////////////////////////////////////////////////////
//
//							 Map Data
//
//                 up     nw     n      ne     w      e      sw     s      se     dn
var map = [
/* room 0 */	"0x0001,0x0000,0x0000,0x0000,0x0000,0x0000,0x0000,0x0000,0x0000,0x0000","morn","You are lying face down on a beach. Your head hurts and you've no idea how you got here. You are wearing a shirt and trousers but you can feel the warm surf pulling at your bare feet. From this perspective you can see the sand is like tiny cubes of black glass.</p><p>Some crabs are starting to take an interest in your toes. I'd stand up, if I was you.",
/* room 1 */	"0x0000,0x0000,0x0000,0x0000,0x0000,0x0002,0x0000,0x0000,0x0000,0x0000","morn","You are standing on a deserted beach of black sand under a leaden sky. The palm trees edging the beach are still dripping rainwater but it seems to have cleared up now.</p><p>There is a deserted gazebo in the shade of the trees to the east.",
/* room 2 */	"0x0000,0x0000,0x0000,0x0000,0x0001,0x0003,0x0000,0x0000,0x0000,0x0000","morn","You are standing next to the deserted gazebo. The wood is rotten and the palm leaf roof has mostly blown away. Once apon a time there were brightly coloured posters pinned to the woodwork, but now there are just little triangular scraps of paper under the drawing pin heads. It's a long time since any one sipped pina coladas here. (Pinas coladas surely? Ed.)</p><p>The beach is to the west and there is an overgrown path heading inland to the east.",
/* room 3 */	"0x0000,0x0000,0x0006,0x0000,0x0002,0x0000,0x0000,0x0004,0x0000,0x0000","morn","You are on the north/south beach path not far from the gazebo. There is a row of palm trees separating the path from the beach and a closed tourist information office on the other side. Fixed to the the door is a notice which reads:</p><p>\"Visitors are reminded that electronic guides may not be removed from the island. Please ensure you are not carrying your guide when you leave. Thank you.\"",
/* room 4 */	"0x0000,0x0000,0x0003,0x0000,0x0000,0x0000,0x0000,0x0005,0x0000,0x0000","morn","You are on the beach path. There are fishing boats drawn up high on the sand along the path opposite a row of fishermen's shacks. The boats look as if they haven't been used for a while and shacks are deserted, the doors and windows hanging open. Perhaps they knew you were coming?",
/* room 5 */	"0x0000,0x0000,0x0004,0x0000,0x0000,0x0000,0x0000,0x0000,0x0000,0x0000","morn","You are at the southern end of the beach path. There is a large open area here and a stage has been set up at the far end of it at the foot of the steeply rising headland. There is a projection screen behind the stage that has been ripped to shreds. A huge barbeque had been set up on the beach side but now firewood and cooking utensils are just scattered around.</p><p>It looks as if someone was going to have a hell of a party, but then something came up.",
/* room 6 */	"0x0000,0x0000,0x0007,0x0000,0x0000,0x0000,0x0000,0x0003,0x0000,0x0000","morn","You are on the beach path. There is an impenetrable wall of palm trees on both sides of the path.",
/* room 7 */	"0x0000,0x0000,0x0008,0x0000,0x0000,0x0000,0x0000,0x0006,0x0000,0x0000","temp_morn","You are outside a magnificent five-sided structure that seems to be a temple of some kind. It is covered with obscure carvings of an echinodermic nature.</p><p>It seems to be some time in the morning, but it's hard to tell, the sky is so overcast.",
/* room 8 */	"0x0000,0x0025,0x0000,0x001B,0x0000,0x0000,0x000A,0x0007,0x0012,0x0009","temp_in","You are inside the temple of the starfish god Dhrool, who is known locally as Fiivo. You may suspect this is a pun on Hawaii, but you would be wrong.</p><p>There are five doors and, in the middle of the room in front of a hideously shaped altar, a rope ladder going down.",
/* room 9 */	"0x0008,0x0000,0x0000,0x0000,0x0000,0x0000,0x0000,0x0000,0x0000,0x0000","dias","You are standing in a large round chamber up to your knees in brackish water. This is no surprise as temples of Dhrool are always built in contact with the water table.</p><p>A shaft of light from overhead illuminates the dias designed to hold an effigy of the god. This would be a very small scale model, obviously. He coundn't get one semi-sentient ray in this pokey little hole.",
              
/* room a */	"0x0000,0x0000,0x0008,0x0000,0x0000,0x0000,0x0000,0x000B,0x0000,0x0000","temp","You are outside a fantastic five-sided structure that seems to be a temple of some kind. It is covered with obscure carvings of an echinodermic nature.</p><p>It seems to be the middle of a sunny day.",
/* room b */	"0x0000,0x0000,0x000A,0x0000,0x0000,0x0000,0x0000,0x000C,0x0000,0x0000","day","You are on the beach path. There is an impenetrable wall of palm trees on both sides of the path.",
/* room c */	"0x0000,0x0000,0x000B,0x0000,0x000F,0x0011,0x0000,0x000D,0x0000,0x0000","day","You are on the beach path not far from the gazebo. There is a row of palm trees separating the path from the beach and a tourist information office on the other side.",
/* room d */	"0x0000,0x0000,0x000C,0x0000,0x0000,0x0000,0x0000,0x000E,0x0000,0x0000","day","You are on the beach path. Fishermen are working on the boats drawn up on the beach or mending nets, while outside the fishermen's shacks on the other side of the path, merry fishwives are sitting merrily gutting fish.",
/* room e */	"0x0000,0x0000,0x000D,0x0000,0x0000,0x0000,0x0000,0x0000,0x0000,0x0000","day","You are at the southern end of the beach path. There is a large open area and a stage has been set up at the far end. Roadies are intoning the magic phrase \"one two, one two\" as they set up the equipment. Right in front of the stage a few people are sitting in circles sampling the local produce and satisfying the munchies. To one side an enormous barbeque is being set up, along with bread and veggies by the barrel. Speaking of barrels, there's no shortage of drink, either.",
/* room f */	"0x0000,0x0000,0x0000,0x0000,0x0010,0x000C,0x0000,0x0000,0x0000,0x0000","day","You are standing next to the gazebo. All the stools are occupied and the barman is in full swing juggling bottles and pouring toxicaly coloured drinks stuffed with umbrellas, plastic penny farthings and novelty ice cubes shaped like starfish.",
/* room 10 */	"0x0000,0x0000,0x0000,0x0000,0x0000,0x000F,0x0000,0x0000,0x0000,0x0000","day","You are standing on a crowded beach of soft white sand under an azure sky. Guys with their girlfriends are pretending to read holiday novels while actualy watching four girls playing beach volleyball. There is a tourist transport boat pulled up onto the beach. There is a busy gazebo in the shade of the palms to the east.",
/* room 11 */	"0x0000,0x0000,0x0000,0x0000,0x000c,0x0000,0x0000,0x0000,0x0000,0x0000","day","You are inside the tourist information office. There are posters on the wall advertising tonight's concert. There is no one here, but on the counter there are two notices. The first reads:</p><p>\"Vistitors are reminded that the electronic guides record all actions on a memory chip. Changing the chip will change your actions.\" The second reads:</p><p>\"Closed for lunch.\"",
              
/* room 12 */	"0x0000,0x0008,0x0000,0x0000,0x0000,0x0000,0x0000,0x0013,0x0000,0x0000","temp","You are outside an amazing five-sided structure that seems to be a temple of some kind. It is covered with obscure carvings of an echinodermic nature.</p><p>It seems to be early evening, just before sunset.",
/* room 13 */	"0x0000,0x0000,0x0012,0x0000,0x0000,0x0000,0x0000,0x0014,0x0000,0x0000","day","You are at the foot of a gently climbing path. There is impenetrable jungle to the west and a field of corn to the east.",
/* room 14 */	"0x0000,0x0000,0x0013,0x0000,0x0000,0x0000,0x0000,0x0015,0x0000,0x0000","day","You are part way up the gentle climb. The ground rises steeply to the east and falls away equally steeply to the west. You can see the beach to the west over the tops of the palm trees. it seems deserted.",
/* room 15 */	"0x0000,0x0000,0x0014,0x0000,0x0000,0x0000,0x0000,0x0017,0x0000,0x0000","day","You are at a tricky part of the gentle climb. You have to edge your way around a protruding rock.",
/* room 16 */	"0x0000,0x0000,0x0014,0x0000,0x0000,0x0018,0x0000,0x0017,0x0000,0x0000","day","You are at a tricky part of the gentle climb. You have to edge your way around a protruding rock.",
/* room 17 */	"0x0000,0x0000,0x0016,0x0000,0x0000,0x0000,0x0019,0x0000,0x0000,0x0000","day","You are at the top of the gentle climb.",
/* room 18 */	"0x0000,0x0000,0x0000,0x0000,0x0016,0x0000,0x0000,0x0000,0x0000,0x0000","day","You are in a shallow cave hidden behind a protruding rock. Off to one side is the skeleton of an enormous reptile with five skulls (it's possible that two of the skulls may have been removed). None of the remaining skulls have any teeth.",
/* room 19 */	"0x0000,0x0000,0x0000,0x0017,0x001A,0x0000,0x0000,0x0000,0x0000,0x0000","day","You are at the eastern end of the headland. Below you is the concert area. It's getting pretty crowded now the sun is going down, and the barbeque is in full swing, as is the bar. A DJ is warming the crowd up before the main event.",
/* room 1A */	"0x0000,0x0000,0x0000,0x0000,0x0000,0x0019,0x0000,0x0000,0x0000,0x0000","day","You are at the tip of the headland. The sun is sinking slowly below the horizon, lighting up the clouds like strawberry candyfloss on a royal blue canvas. Fingers of light clutch at the sea like a drowning man at straws. This would be an absolutely perfect spot if it wasn't for the stink of a six-foot hight pile of gorilla droppings. What on earth could have done that?</p><p>Anyway, I expect the concert will be starting soon. Best get on if we want to save all those poor people.",
              
/* room 1B */	"0x0000,0x0000,0x001C,0x0000,0x0000,0x0000,0x0008,0x0000,0x0000,0x0000","temp","You are outside an astounding five-sided structure that seems to be a temple of some kind. It is covered with obscure carvings of an echinodermic nature.</p><p>It seems to be early evening, just after sunset.",
/* room 1C */	"0x0000,0x0000,0x001D,0x0000,0x0000,0x0000,0x0000,0x001B,0x0000,0x0000","maize","You are standing next to a corn field.",
/* room 1D */	"0x0000,0x0000,0x001E,0x0000,0x001F,0x001C,0x0000,0x0020,0x0000,0x0000","maize","You are on a path in a field of twisted maize.",
/* room 1E */	"0x0000,0x0000,0x001F,0x0000,0x001D,0x0020,0x0000,0x0021,0x0000,0x0000","maize","You are on a twisted path in a field of maize.",
/* room 1F */	"0x0000,0x0000,0x0020,0x0000,0x001E,0x0021,0x0000,0x001D,0x0000,0x0000","maize","You are on a maize field twisted path.",
/* room 20 */	"0x0000,0x0000,0x0021,0x0000,0x001D,0x001F,0x0000,0x001E,0x0000,0x0000","maize","You are in a field of twisted maize paths.",
/* room 21 */	"0x0000,0x0000,0x001E,0x0000,0x0022,0x0020,0x0000,0x001F,0x0000,0x0000","maize","You are on a path in a twisted maize field.",
/* room 22 */	"0x0000,0x0000,0x0023,0x0000,0x0000,0x0000,0x0000,0x0021,0x0000,0x0000","maize","You are standing next to a corn field.",
/* room 23 */	"0x0000,0x0000,0x0024,0x0000,0x0000,0x0000,0x0000,0x0022,0x0000,0x0000","day","You are outside one of those picturesque bayou cabins that must be hell to live in. The back looks out over a rotting marsh under an ink streaked sky pierced by evening stars. The ground at the front of the building is scarcely more solid than that at the rear, and yet is home to a red pickup truck up on four beer crates.",
/* room 24 */	"0x0000,0x0000,0x0000,0x0000,0x0000,0x0000,0x0000,0x0023,0x0000,0x0000","day","You are inside the pickup truck.",
              
/* room 25 */	"0x0000,0x0000,0x0026,0x0000,0x0000,0x0000,0x0000,0x0000,0x0008,0x0000","temp_night","You are outside an astonishing five-sided structure that seems to be a temple of some kind. It is covered with obscure carvings of an echinodermic nature.</p><p>It's night time.",
/* room 26 */	"0x0000,0x0000,0x0027,0x0000,0x0000,0x0000,0x0000,0x0025,0x0000,0x0000","night","You are in a rubbish dump under a full moon. At first sight, the rubbish seems to be moving, but it is in fact a large number of robber crabs moving slowly through the rubbish, scavenging.</p><p>At one time it was thought these creatures could open coconuts with their impresive claws, now we know they just take advantage of coconuts that have broken open when they fell on a hard object, such as a robber crab.</p><p>Better keep moving, before they scavenge your legs.",
/* room 27 */	"0x0000,0x0000,0x0028,0x0000,0x0000,0x0000,0x0000,0x0026,0x0000,0x0000","night","You are on a path some distance from the beach. Although you can't see it through the palm trees, you can still hear the gentle sussuration of the ocean as it sweeps the sugary sand. The ground rises quite steeply on the inland side.",
/* room 28 */	"0x0000,0x0000,0x0029,0x0000,0x0000,0x0000,0x0000,0x0027,0x0000,0x002B","night","You are by a shallow bed that crosses the path. There is a narrow opening in the ground here. I expect this is a spring during the rainy season.",
/* room 29 */	"0x0000,0x0000,0x0000,0x0000,0x0000,0x002A,0x0000,0x0028,0x0000,0x0000","night","You are on the bank of a river heading out to sea. The river is too wide to cross at this point, perhaps if you headed inland?",
/* room 2A */	"0x0000,0x0000,0x0000,0x0000,0x0029,0x0000,0x0000,0x0000,0x0000,0x0000","night","You are on the bank of a river heading out to sea. The bank is now quite steep and getting steeper, you cannot go any further inland.",
/* room 2B */	"0x0028,0x0000,0x0000,0x002C,0x0000,0x0000,0x0000,0x0000,0x0000,0x0000","null","You are inside the spring. The guide doesn't work too well here, It needs to see the stars. (Or the GPS satellites, if you must be prosaic.) Just wander about, I'm sure you'll be fine.",
/* room 2C */	"0x0000,0x0000,0x0000,0x0000,0x0000,0x002D,0x002B,0x0000,0x0000,0x0000","null","You are at the end of a long gallery with niches on either side. Most of the niches are occupied by mummified corpses. Many of them have limbs missing. I expect the crabs know about this place.",
/* room 2D */	"0x0000,0x0000,0x0000,0x0000,0x002C,0x002E,0x0000,0x0000,0x0000,0x0000","null","You are in a long gallery with niches on either side.",
/* room 2E */	"0x0000,0x0000,0x0000,0x0000,0x002D,0x002F,0x0000,0x0000,0x0000,0x0000","null","You are in the middle of a long gallery with niches on either side. Mummies are grinning at you.",
/* room 2F */	"0x0000,0x0000,0x0031,0x0000,0x002E,0x0030,0x0000,0x0000,0x0000,0x0000","null","You are in a long gallery with niches on either side.",
/* room 30 */	"0x0000,0x0000,0x0000,0x0000,0x002F,0x0000,0x0000,0x0000,0x0000,0x0000","null","You are at the end of a long gallery with niches on either side. There appears to have been a rockfall here. you can proceed no further.",
/* room 31 */	"0x0000,0x0000,0x0000,0x0000,0x0000,0x0000,0x0000,0x002F,0x0000,0x0032","null","You are in an empty niche in the long gallery.",
/* room 32 */	"0x0031,0x0000,0x0033,0x0000,0x0000,0x0000,0x0000,0x0034,0x0000,0x0000","null","You are under the empty niche. You are also up to your knees in water.",
/* room 33 */	"0x0000,0x0000,0x0000,0x0000,0x0000,0x0000,0x0000,0x0032,0x0000,0x0000","null","You are in what appears to be a dead end, although you can hear water rushing nearby. The floor here is rather strange, like a smooth basin or bowl, with a small grille in the center. That must be where the water comes in, right?",
/* room 34 */	"0x0000,0x0000,0x0032,0x0000,0x0000,0x0000,0x0000,0x0000,0x0000,0x0000","null","You are in a five-sided chamber. There is a picture story on the walls showing how Fiivo treats people who disturb him as he lies dead and dreaming in the ocean depths. Only restoring the gold efigy to it's rightful place and performing the rites will avert disaster.</p><p>In the centre of the room is a raised dias.",
/* room 35 */	"0x0000,0x0000,0x0000,0x0000,0x0000,0x0000,0x0000,0x0000,0x0000,0x0000","null","You are horrified to hear the sound of a massive stone ball being released above you. You run as fast as you can clutching the yellow star but with the ball gaining on you you daren't stop to climb up. You slip up on the smooth floor of the dead end and slide down to the center just as the ball settles in on top of you like a golfball on a tee. Your life blood trickles out of the conveniently placed grille.</p><p>Pity you didn't pay more attention to that movie.",
              
/* room 36 */	"0x0037,0x0000,0x0000,0x0000,0x0000,0x0000,0x0000,0x0000,0x0000,0x0000","dias","You are standing in a large round chamber up to your knees in brackish water. The golden efigy of Fiivo is in it's rightful place on the dias. Something seems to have changed, the quality of light, perhaps, or something more?",
/* room 37 */	"0x0000,0x0000,0x0000,0x0000,0x0000,0x0000,0x0000,0x0038,0x0000,0x0036","temp_in","You are inside the temple of the starfish god Dhrool, who is known locally as Fiivo. You may suspect this is a pun on Hawaii, but you would be wrong.</p><p>There are five doors and, in the middle of the room in front of a hideously shaped altar, a rope ladder going down.",
/* room 38 */	"0x0000,0x0000,0x0037,0x0000,0x0000,0x0000,0x0000,0x0039,0x0000,0x0000","temp_night","You are outside a magnificent five-sided structure that seems to be a temple of some kind. It is covered with obscure carvings of an echinodermic nature.</p><p>It seems to be mid-morning.",
/* room 39 */	"0x0000,0x0000,0x0038,0x0000,0x0000,0x0000,0x0000,0x003A,0x0000,0x0000","night","You are on the beach path. There is an impenetrable wall of palm trees on both sides of the path.",
/* room 3A */	"0x0000,0x0000,0x0039,0x0000,0x003D,0x0000,0x0000,0x003B,0x0000,0x0000","night","You are on the north/south beach path not far from the gazebo. There is a row of palm trees separating the path from the beach and a closed tourist information office on the other side.",
/* room 3B */	"0x0000,0x0000,0x003A,0x0000,0x0000,0x0000,0x0000,0x003C,0x0000,0x0000","night","You are on the beach path. Fishermen are working on the boats drawn up on the beach or mending nets, while outside the fishermen's shacks on the other side of the path merry fishwives are sitting merrily gutting fish.",
/* room 3C */	"0x0000,0x0000,0x003B,0x0000,0x0000,0x0000,0x0000,0x0000,0x0000,0x0000","night","You are at the southern end of the beach path. The roadies have already dismantled and removed the audio and video equipment, a crew is currently breaking down the stage and lighting gantry. To one side the barbeque is being packed up and another crew is clearing up the trash.",
/* room 3D */	"0x0000,0x0000,0x0000,0x0000,0x003E,0x003A,0x0000,0x0000,0x0000,0x0000","night","You are standing next to the gazebo. It is closed.",
/* room 3E */	"0x0000,0x0000,0x0000,0x0000,0x003F,0x003D,0x0000,0x0000,0x0000,0x0000","night","You are standing on a deserted beach of soft white sand under an azure sky. The tourist boat is fully loaded and ready to go, the tour leader is beckoning you over.",
/* room 3F */	"0x0000,0x0000,0x0000,0x0000,0x0000,0x0000,0x0000,0x0000,0x0000,0x0000","night","You are on the boat. You look around at all the happy and exhausted faces, and realize you have saved all these people by using the gold star to perform the Fiivo-rites. (I told you it had nothing to do with Hawaii. (Gold star? Favorites?))</p><p>That concludes your sucessful adventure. Come back anytime. Tell your friends."];
              

//	direction "constants"
var UP = 0;
var NW = 1;
var N  = 2;
var NE = 3;
var W  = 4;
var E  = 5;
var SW = 6;
var S  = 7;
var SE = 8;
var DN = 9;

var dirnames= [
				"up",
				"northwest",
				"north",
				"northeast",
				"west",
				"east",
				"southwest",
				"south",
				"southeast",
				"down"
				];

// names of things you find lying around
var items = ["a guide memory chip",
						"an electronic guide",
						"a pair of sunglasses",
						"a pair of sandals",
						"a brass star",
						"a fleece with a gold zip",
						"a torch",
						"a gold star"];

var scoreof =	[
				0,
				0,
				100,
				200,
				300,
				400,
				500,
				600
				];
						
// location of things you find lying around. 0 = carrying it.
var itemLocations = [];

//	object "constants"
var CHIP	= 0;
var GUIDE	= 1;
var SUNNIES	= 2;
var SANDALS	= 3;
var BRASS	= 4;
var FLEECE	= 5;
var TORCH	= 6;
var GOLD	= 7;



}
