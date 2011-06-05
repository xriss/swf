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







class Advent
{

var pix;

var desc;
var	dest;
var	item;
var	here;
var	room;
var	back;
var	text;
var	gate;
var	gets;
var	puts;
var	func;

var score;

var onMoved;
//var onMoved;


////////////////////////////////////////////////////////////////////////////////
//
//								Advent class
//
//	This class is "clean", it has no dependencies. It just potters around the
//	map and calls back when something of interest happens.
//
function Advent(map, _item, _here)
{
var i,j,idx;

	desc = new Array();
	pix = new Array();
	dest = new Array();
	item = _item;
	here = _here;
	room = 0;
	back = 0;
	text = "";
	gate = new Array(10);
	gets = new Array();
	puts = new Array();
	func = new Array();
	
	for(i=0;i<map.length;i+=3)
	{
		idx=i/3;
		
		dest[idx]=map[i+0].split(",");
		pix[idx]=map[i+1];
		desc[idx]=map[i+2];
		
		for(j=0;j<dest[idx].length;j++)
		{
			dest[idx][j]=Number(dest[idx][j]);
		}
	}
	
	onMoved=null;
	
	score=0;
	
	jump(0);

	
// debug quick keys...	
//	Key.addListener(this);
}

 function move(dir)
{
	dir=Number(dir);
	
	if(dir == -1)	// if back
	{
		if(this.back)
		{
			this.jump(this.back);
			
			score-=1;
		}
	}
	else if(dir >= 0 && dir <= 9)
	{
		if(this.gate[dir])
		{
			this.jump(this.dest[this.room][dir], true);
			
			score-=1;
		}
	}
	else
		return;

	this.callBack(this.onMoved);
}

//	set room, back, text & gate
 function jump(rm, bk)
{
var i;

	if(bk)
		this.back = this.room;
	else
		this.back = 0;

	this.room = Number(rm);

	if(this.room >= 0 && this.room < this.dest.length)
	{
		this.text = this.desc[this.room];
		for(i=0; i < 10 ;i++)
			this.gate[i] = Boolean(this.dest[this.room][i]);
	}
	else	// fail gracefuly if fallen off the map
	{
		this.text = "nowhere.";
		for(i=0; i < 10 ;i++)
			this.gate[i] = false;
	}
	this.callBack(this.func[this.room]);
	
	this.callBack(this.onMoved);
}

 function get(it)
{
	if(isHere(it))
	{
		score-=1;
			
		this.here[it] = 0;
		this.callBack(this.gets[it]);
		this.callBack(this.func[this.room]);
		this.callBack(this.onMoved);
	}
}

 function put(it)
{
	if(isCarried(it))
	{
		score-=1;
			
		this.here[it] = this.room;
		this.callBack(this.puts[it]);
		this.callBack(this.func[this.room]);
		this.callBack(this.onMoved);
	}
}

 function isCarried(it)
{
	return (this.here[it] == 0);
}

 function isHere(it)
{
	return (this.here[it] == this.room);
}

 function onGet(it, fn)
{
	this.gets[it] = fn;
}

 function onPut(it, fn)
{
	this.puts[it] = fn;
}

 function onEnter(rm, fn)
{
	this.func[rm] = fn;
}

 function callBack(fn)
{
	if(typeof fn == "function")
		fn.call(this);
}


//
// debug jumps
//
	function onKeyDown()
	{
	}
	
	function onKeyUp()
	{
	var k;
/*	
		k=String.fromCharCode(Key.getAscii());
		
		if( k == "1" )
		{
			jump(this.room-1);
			dbg.print(this.room);
		}
		else
		if( k == "2" )
		{
			jump(this.room+1);
			dbg.print(this.room);
		}
*/
	}

};
