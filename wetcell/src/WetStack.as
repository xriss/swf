/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) Kriss Daniels 2006 http://www.XIXs.com
//
/*+-----------------------------------------------------------------------------------------------------------------+*/

#include "src/opts.as"

// a collection of single cards, 
// either for display or maybe the entire pack for shuffling etc

class WetStack
{
	var cards:Array;		// array of cards in this stack

	var disp:Boolean	// should we show this stack?

	var mc:MovieClip;
	
	var up;
	
	var layout:String;
	var pickup:String;
	var place:String;

	var place_legal:Boolean; // legal to play floating cards to this stack
	var place_pos:Number; // how close we are to the position of this stack, lower is better

	var place_x; // where the next card should be placed x,y
	var place_y;
	
	var pickupable; // how many cards it is valid to pickup from this stack possibly 0
	
	var fadeout;
	
	function WetStack(_up)
	{
		up=_up;
		
		cards=new Array();
		
		mc=gfx.create_clip(up.mc,null);
		mc._xscale=Math.floor(100*#(CARD_SCALE));
		mc._yscale=Math.floor(100*#(CARD_SCALE));
		mc.cacheAsBitmap=true;
		
		layout='spread_down';
	}
	
	function setup()
	{
	}
	

// fill this stack with all 52 cards
	function add_all_cards(from)
	{
	var i,j;
	
//			cards[j].mc._x=0-4+(up.up.rnd()&7);
//			cards[j].mc._y=0+j*25;

// my IDs
// 0x01 - 0x0d hearts ace to king
// 0x11 - 0x1d spades ace to king
// 0x21 - 0x2d diamonds ace to king
// 0x31 - 0x3d clubs ace to king
var microsuits=[0x31,0x21,0x01,0x11];
// microsoft IDs
// clubs ace to king
// diamonds ace to king
// hearts ace to king
// spades ace to king
// interleaved, so first 4 aces then 4 2s etc
				
		if(from) // use this msoft freecell style array which must contain all cards, 0-51 in the desired order
		{
			for(j=0;j<52;j++)
			{
				i=from[51-j];

				i=microsuits[i%4]+Math.floor(i/4);
				
				cards[j]=new WetCard(this,i)
			}
		}
		else
		{

			j=0;
			for(i=0x01;i<=0x0d;i++)
			{
				cards[j]=new WetCard(this,i)
				j++;
			}
			for(i=0x11;i<=0x1d;i++)
			{
				cards[j]=new WetCard(this,i)
				j++;
			}
			for(i=0x21;i<=0x2d;i++)
			{
				cards[j]=new WetCard(this,i)
				j++;
			}
			for(i=0x31;i<=0x3d;i++)
			{
				cards[j]=new WetCard(this,i)
				j++;
			}
		}
		
	}

// shuffle this stack of cards

	function shuffle()
	{
	var i;
	var a=new Array();
	
		while(cards.length>0)
		{
			i=up.up.rnd()%cards.length;
			a.push(new WetCard(this,cards[i].id)); // make new
			cards[i].remove_mc(); // hide it
			cards.splice(i,1); // delete it
		}
		cards=a; // new array
	}

// get list of cards in this pack as a pack_code

	function pack_code()
	{
	var i;
	var str;
	
		str="";
		
		for(i=0;i<cards.length;i++)
		{
			str+=Clown.tostr(cards[i].id,1);
		}
		
		return str;
	}

	function spread_layout_force()
	{
	var i;
		for(i=0;i<cards.length;i++)
		{
			cards[i].x=null;
			cards[i].y=null;
		}
		spread_layout();
	}
	
	function spread_layout()
	{
		this[this.layout]();
		this[this.pickup]();
	}

// spread cards in this stack downwards

	function spread_down()
	{
	var i;
	var y;
	
		y=0;
		for(i=0;i<cards.length;i++)
		{
			if(cards[i].x==null) // assign position on first draw
			{
				cards[i].x=0;
				cards[i].y=y;
			}
			cards[i].mc._x=cards[i].x;
			cards[i].mc._y=cards[i].y;

			if(cards[i].back)
			{
				y+=10
			}
			else
			{
				y+=25
			}
		}
		
		place_x=0;
		place_y=y;
		
	}

// spread cards in this stack ontop

	function spread_top()
	{
	var i;
	
		for(i=0;i<cards.length;i++)
		{
			if(cards[i].x==null) // assign position on first draw
			{
				cards[i].x=0+i*0.5;
				cards[i].y=0-i*0.5;
			}
			cards[i].mc._x=cards[i].x;
			cards[i].mc._y=cards[i].y;
		}

		place_x=0+i*0.5;
		place_y=0-i*0.5;
		
	}

	function spread_side()
	{
	var i;
	
		place_x=24;
		place_y=0;
			
		for(i=0;i<cards.length;i++)
		{
			if(cards[i].x==null) // assign position on first draw
			{
				cards[i].x=place_x;
				cards[i].y=place_y;
			}
			cards[i].mc._x=cards[i].x;
			cards[i].mc._y=cards[i].y;

			place_x=cards[i].x+((112-48)/2);
			if(place_x>24+(112-48)+1)
			{
				place_x=24;
			}
			place_y=0;
		}
		
	}

// allow 0 card pickup

	function pickup_0()
	{
		pickupable=0;
	}
	
// allow 1 card pickup

	function pickup_1()
	{
		pickupable=1;
	}

// check weaved/faceup from top of stack, minimum of 1 card pickup

	function pickup_weave()
	{
	var i;
	
		pickupable=1;
		
		for(i=cards.length-2;i>=0;i--)
		{
			if( (cards[i].back==true) || (cards[i+1].back==true) )
			{
				break;
			}
			
			if( (cards[i].id&0x0f) != (cards[i+1].id&0x0f)+1 ) // numerical order
			{
				break;
			}

			if((cards[i].id&0x10) == (cards[i+1].id&0x10)) // color
			{
				break;
			}
			
			pickupable=cards.length-i;
		}
	}


// test if we can validly place the given stack or a portion of it here (num is max number of cards to move)

	function place_test(from,num)
	{
		if(typeof(num)!="number")
		{
			num=from.cards.length;
		}
	
		return this[this.place](from,num);
	}


// no placing here
	function place_0(from,num)
	{
		return 0;
	}

// can placing one card here only
	function place_1(from,num)
	{
		if(cards.length==0)
		{
			if(num==1) { return 1; }
		}
		return 0;
	}
	
// ace -> king of same suit, first ace suit doesn't matter, only one card at a time
	function place_atok_same_1(from,num)
	{
	var cf,cc;
	
		if(num!=1) { num=1; }
		if(cards.length==0)
		{
			if(from.cards.length==0) { return 0; }
			cf=from.cards[from.cards.length-1];
			if(cf.back==true ) { return 0; }
			if((cf.id&0x0f) != 1 ) { return 0; }
		}
		else
		{
			if(from.cards.length==0) { return 0; }
			cf=from.cards[from.cards.length-1];
			cc=cards[cards.length-1];
			
			if(cf.back==true ) { return 0; }
			
			if(cc.back==true) { return 0; }
						
			if((cc.id&0x30) != (cf.id&0x30) ) { return 0; }
			if((cc.id&0x0f) != (cf.id&0x0f)-1 ) { return 0; }
		}
		return num;
	}

// king -> ace of weave black/red suit, first king suit doesn't matter, any number of cards
	function place_ktoa_weave(from,num)
	{
	var ret;
	var i;
	
		ret=num;
		
		if(cards.length==0)
		{
			for(i=num;i>0;i--)
			{
				if(from.cards[from.cards.length-i].back==true ) continue;
				if((from.cards[from.cards.length-i].id&0x0f) != 13 ) continue;				
				break;
			}
			ret=i;
		}
		else
		{
			if(cards[cards.length-1].back==true) { return 0; }
			
			for(i=num;i>0;i--)
			{
				if(from.cards[from.cards.length-i].back==true ) continue;
					
				if((cards[cards.length-1].id&0x10) == (from.cards[from.cards.length-i].id&0x10) ) continue;
				if((cards[cards.length-1].id&0x0f) != (from.cards[from.cards.length-i].id&0x0f)+1 ) continue;
			
				break;
			}
			ret=i;
		}
		
		return ret;
	}

// weave black/red suit, any card can start, any number of cards
	function place_weave(from,num)
	{
	var ret;
	var i;
	
		ret=num;
		
		if(cards.length==0)
		{
			for(i=num;i>0;i--)
			{
				if(from.cards[from.cards.length-i].back==true ) continue;
//				if((from.cards[from.cards.length-i].id&0x0f) != 13 ) continue;				
				break;
			}
			ret=i;
		}
		else
		{
			if(cards[cards.length-1].back==true) { return 0; }
			
			for(i=num;i>0;i--)
			{
				if(from.cards[from.cards.length-i].back==true ) continue;
					
				if((cards[cards.length-1].id&0x10) == (from.cards[from.cards.length-i].id&0x10) ) continue;
				if((cards[cards.length-1].id&0x0f) != (from.cards[from.cards.length-i].id&0x0f)+1 ) continue;
			
				break;
			}
			ret=i;
		}
		
		return ret;
	}
	
// deal num cards from top of this stack to another

	function deal(num:Number,to:WetStack,setback)
	{
	var i;
	
		for(i=cards.length-num;i<cards.length;i++)
		{
			if(typeof(setback)=='boolean')
			{
				cards[i].setback(setback);
			}
			to.cards.push(new WetCard(to,cards[i])); // make new
			cards[i].remove_mc(); // hide old card
		}
		cards.splice(cards.length-num,num); // delete it

// update layouts
		this.spread_layout();
		to.spread_layout();
	}

	
// deal num cards from top of this stack to another

	function clone(to:WetStack)
	{
	var i;

// remove any cards in the to stack
		to.clear_cards();
		
// add all cards in exactly as they are

		if(cards.length>0)
		{
			for(i=0;i<cards.length;i++)
			{
				to.cards.push(new WetCard(to,cards[i])); // make new
				to.cards[i].x=cards[i].x;
				to.cards[i].y=cards[i].y;
				to.spread_layout();
			}
		}
		
	}


	function update()
	{
	}

// delete all cards from this stack
	function clear_cards()
	{
	var i;
		if(cards.length>0)
		{
			for(i=0;i<cards.length;i++)
			{
				cards[i].remove_mc(); // hide it
			}
			cards.splice(0,cards.length); // delete it
		}
	}


}
