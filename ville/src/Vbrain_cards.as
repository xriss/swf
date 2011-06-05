/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) Kriss Daniels 2007 http://www.XIXs.com
//
/*+-----------------------------------------------------------------------------------------------------------------+*/

#include "src/opts.as"

class Vbrain_cards
{
	var up;
	
	var vcobj; // the controlling comms object
	
	var k;
	
	var mc;
	
	var suits_hash;
	var ranks_hash;
	var suits_hashn;
	var ranks_hashn;
	
	var cardxyz={x:0,y:0,z:0};
	
	function Vbrain_cards(_up)
	{
	var i;
		up=_up;
		up.type_name="vobj_cards"
			
		suits_hashn=["h","s","d","c"];
		suits_hash=[];
		for(i=0;i<4;i++)
		{
			suits_hash[ suits_hashn[i] ] = i;
		}
		ranks_hashn=["A","2","3","4","5","6","7","8","9","X","J","Q","K"];
		ranks_hash=[];
		for(i=0;i<13;i++)
		{
			ranks_hash[ ranks_hashn[i] ] = i;
		}
	}
	
	function delegate(f,d)	{	return com.dynamicflash.utils.Delegate.create(this,f,d);	}


	function setup(xml)
	{
	var m;
	var vt;
	var i;
	if(xml) { parse_xml(xml,0); }
		
		mc=gfx.create_clip(up.mc,null);
		
//		menuset();
		
		k=[];
		
//		update_vcobj( { cards:"AsKh" , title:"Testing!"} )
			
// make unclickable
		delete(up.mc.onRollOver);
		delete(up.mc.onRollOut);
		delete(up.mc.onReleaseOutside);
		delete(up.mc.onRelease);
		up.mc.useHandCursor=false;
		
		update();
		
//		set_title("POOP");
	}
	
	function clean()
	{
	}
	
	function set_title(str)
	{
	var m;
	
		if(!mc.title)
		{
			m=gfx.create_clip(mc,null,-50,-50);
			m.tf=gfx.create_text_html(m,null,0,0,200,25);
			mc.title=m;
		}
		m=mc.title;
		
		gfx.set_text_html(m.tf,16,0xffffff,"<b>"+str+"</b>");
		
		m.w=m.tf.textWidth;
		m.h=m.tf.textHeight;
		m.tf._x=-m.w/2;
		m.tf._y=-m.h/2;
		
		m._x=40+(m.h/2);
		m._y=80;
		
		gfx.clear(m);
		m.style.fill=0xff000000;
		gfx.draw_rounded_rectangle(m,10,10,0,-m.w/2-10-2,-m.h/2-10-1,m.w+20+6+4,m.h+20+6);
		
		if(str=="-")
		{
			m._visible=false;
		}
		else
		{
			m._visible=true;
		}
	}
	
	function parse_xml(e,d,flavour)
	{
	var ec;
	var children;
	
		children=false;
		
		if(e.nodeType==1)
		{
//dbg.print(d+":"+e.nodeType+":"+e.nodeName);

			switch(e.nodeName)
			{
				default:
					children=true;
				break;
			}
			if( children )
			{
				for( ec=e.firstChild ; ec ; ec=ec.nextSibling )
				{
					parse_xml(ec,d+1,flavour);
				}
			}
		}
		
	}
	
	function menuset()
	{
	var m;
	
		up.mc.menu={};
	
		m={};
		m.name="base";
		m.items=[];
		m.items.push({	txt:"Cancel"	});
		m.menuclick=delegate(menuclick,m);
		
		up.mc.menu.base=m;

		up.mc.getmenu=delegate(getmenu,null);

	}
	
	function getmenu(poke)
	{
		if( up.mc.vcobj_menu.base ) // server has suplied a menu to use, so override with it
		{
			return up.mc.vcobj_menu.base;
		}
		return up.mc.menu.base;
	}

	function menuclick(poke,item,menu)
	{
	var cc=poke.up.focus.cc;
	
		switch(menu.name)
		{
		default:
			switch(item.txt.toLowerCase())
			{
			default:
				poke.hidemenu();
			break;
			}
			
		break;
		}
	}
	
	function do_use(cc, dest)
	{
	}
	
	
	function update_vcobj(props)
	{
	var m;
	var aa,i,nam;
	
		if(!props) { props=up.vcobj.props; } // if no changes passed in use main props
		
		if(props.xyz) // new server position, tell object to move here
		{
			aa=props.xyz.split(":");
			
			up.px=Math.floor(aa[0]);
			up.py=Math.floor(aa[1]);
			up.pz=Math.floor(aa[2]);
			
		}
		if(props.cardxyz) // card start x/y
		{
			aa=props.cardxyz.split(":");
			
			mc._x=Math.floor(aa[0]);
			mc._y=Math.floor(aa[1]);
		}
		if(props.cards) // card display
		{
			for(i=0;i<k.length;i++) // kill old cards
			{
				k[i].removeMovieClip();
			}
			k=[]; // clear array of displayed cards
			if(props.cards!="-") // if we have some cards to display
			{
				for(i=0;i<props.cards.length;i+=2)
				{
					var rank=ranks_hash[ props.cards.substr(i,1)   ];
					var suit=suits_hash[ props.cards.substr(i+1,1) ];

/* looks like strings get converted to numbers when referencing an array? How problematic.
					var d1,d2,d3,d4;
				
					d1=props.cards.substr(i,1);
					d2=props.cards.substr(i+1,1);
					d3=ranks_hash[d1];
					d4=suits_hash[d2];
					dbg.print( d1+" "+d2+" "+d3+" "+d4);
*/
					
					m=gfx.add_clip(mc,alt.Sprintf.format('k%02X',suit*16 + rank+1),1000+i);
					k[i/2]=m;
					m._x=50*i/2;
					m._y=0;
					m._xscale=50;
					m._yscale=50;
					
					m.cacheAsBitmap=true;
				}
			}
		}
		if(props.title) // title display
		{
			set_title(props.title);
		}
/*
		if(props.image) // server says to display this image
		{
//dbg.print(props.image);
			m=gfx.create_clip(up.anim.mc,1);
			m._xscale=125;
			m._yscale=125;
			m.loadMovie(props.image);
			m._x=up.anim.x_min;
			m._y=up.anim.y_min;
		}
*/
	}

	function update()
	{
//		m.forceSmoothing=true; // keep on setting it till flash decides to pay attention, sometimes it doesnt
	}
}