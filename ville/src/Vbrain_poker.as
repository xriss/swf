/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) Kriss Daniels 2007 http://www.XIXs.com
//
/*+-----------------------------------------------------------------------------------------------------------------+*/

#include "src/opts.as"

class Vbrain_poker
{
	var up;
	
	var vcobj; // the controlling comms object
	
	var mc;
	
	var k;

	var cards; // steal a card vbrain to display some cards on the table
		
// 140 120 140
	function Vbrain_poker(_up)
	{
		up=_up;
		up.type_name="vobj_poker"
	}
	
	function delegate(f,d)		{	return com.dynamicflash.utils.Delegate.create(this,f,d);	}
	function delegate2(f,d,d2)	{	return com.dynamicflash.utils.Delegate.create(this,f,d,d2);	}


	function setup(xml)
	{
	var m;
	var vt;
	var i;
		mc=gfx.create_clip(up.mc,null);
		
		parse_xml(xml,0);
		
//		menuset();
		
		k=[];
/*
		k[1]=gfx.add_clip(up.mc,alt.Sprintf.format('k%02x',0x01),1001, 50,-100,70,40);
		k[2]=gfx.add_clip(up.mc,alt.Sprintf.format('k%02x',0x11),1002,100,-100,70,40);
		k[3]=gfx.add_clip(up.mc,alt.Sprintf.format('k%02x',0x21),1003,150,-100,70,40);
		k[4]=gfx.add_clip(up.mc,alt.Sprintf.format('k%02x',0x31),1004,200,-100,70,40);
		k[5]=gfx.add_clip(up.mc,alt.Sprintf.format('k%02x',0x02),1005,250,-100,70,40);
*/
/*
		for(i=0;i<5;i++)
		{
	
			k[i]=gfx.add_clip(up.mc,alt.Sprintf.format('k%02x',0x01+i*6),null);
			k[i]._x=100+50*i;
			k[i]._y=-80;
			k[i]._xscale=50;
			k[i]._yscale=50;
			
		}
*/
// make unclickable
		delete(up.mc.onRollOver);
		delete(up.mc.onRollOut);
		delete(up.mc.onReleaseOutside);
		delete(up.mc.onRelease);
		
		up.mc.useHandCursor=false;
		
		up.mc.hitArea.removeMovieClip();
		up.mc.hitArea=undefined;// so buttons work?
		
		cards=new Vbrain_cards(up); // share a brain...
		cards.setup();
		
		update_vcobj( { cardxyz:"80:-80:0" } )
			
		mc.b1=gfx.add_clip(up.mc,"poker_button1",1000+1,  0-40-20,10-10);
		mc.b2=gfx.add_clip(up.mc,"poker_button2",1000+2,140-20-20,10-10);
		mc.b3=gfx.add_clip(up.mc,"poker_button3",1000+3,260-20-20,10-10);
		
		mc.b2.use="fold";
		mc.b3.use="raise";
			
		mc.b1.tf=gfx.create_text_html(mc.b1,null,0,4,140,60);
		
		mc.b3.tf=gfx.create_text_html(mc.b3,null,45,15,120,60);
		
		mc.tf1=gfx.create_text_html(up.mc,1000+4,380-20,10-10,200,60);
		
		mc.tf2=gfx.create_text_html(up.mc,1000+5,380-20,10-10,200,60);
		
		disable_button(mc.b2);
		disable_button(mc.b3);
		
		thunk();
		
		update();
	}
	
	var timer_tocall=0;
	var timer_tocall_frames=0;
	var cookies_tocall=0;
	var cookies_raise=0;
	var cookies_pot=0;
	var cookies_bet=0;
	var cookies_yourbet=0;
	
	function thunk()
	{
		gfx.set_text_html(mc.b1.tf,32,0xffffff,"<p align=\"center\"><b>"+timer_tocall+"</b><br><font size=\"12\"><b>"+cookies_tocall+"c</b></font></p>");
		
		gfx.set_text_html(mc.b3.tf,24,0xffffff,"<p align=\"center\"><b>"+cookies_raise+"c</b></p>");
		
		gfx.set_text_html(mc.tf1,24,0xffffff,"<p align=\"left\">POT:<br>BET:</p>");
		
		gfx.set_text_html(mc.tf2,24,0xffffff,"<p align=\"right\"><b>"+cookies_pot+"c</b><br><b>"+cookies_bet+"c</b></p>");
	}
	
	function clean()
	{
		cards.clean();
	}
	
	function enable_button(m)
	{
		if(m.state!="enabled")
		{
			m.state="enabled"
				
			m.onRollOver=delegate2(button_act,m,"over");
			m.onRollOut=delegate2(button_act,m,"out");
			m.onReleaseOutside=delegate2(button_act,m,"out");
			m.onRelease=delegate2(button_act,m,"click");
			m.useHandCursor=true;
			
			button_act(m,"out");
		}
	}
	
	function disable_button(m)
	{
		if(m.state!="disabled")
		{
			m.state="disabled"
				
			m.onRollOver=undefined;
			m.onRollOut=undefined;
			m.onReleaseOutside=undefined;
			m.onRelease=undefined;
			m.useHandCursor=false;
			
			button_act(m,"out");
		}
	}
	
	function button_act(m,act)
	{
		switch(act)
		{
			case "over":
				m._alpha=100;
				up.up.over=m;
			break;
			
			case "out":
				m._alpha=75;
				up.up.over=null;
			break;
			
			case "click":
				if(m.use=="fold")
				{
					up.vcobj.send_msg_prop( "use" , "fold" ); // send fold command
				}
				else
				if(m.use=="raise")
				{
					up.vcobj.send_msg_prop( "use" , "raise "+(cookies_bet+cookies_raise) ); // send raise command (send desired maximum bid for serverside check)
				}
			break;
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
	var aa,i,nam;
	
		if(!props) { props=up.vcobj.props; } // if no changes passed in use main props
		
		if(props.xyz) // new server position, tell object to move here
		{
			aa=props.xyz.split(":");
			
			up.px=Math.floor(aa[0]);
			up.py=Math.floor(aa[1]);
			up.pz=Math.floor(aa[2]);
			
		}
		if(props.cardxyz) // card display set position
		{
			cards.update_vcobj({cardxyz:props.cardxyz});
		}
		if(props.cards) // card display
		{
			cards.update_vcobj({cards:props.cards});
		}
		if(props.title) // title display
		{
			cards.update_vcobj({title:props.title});
		}
		
		if(props.poker) // poker data
		{
			aa=props.poker.split(":");
			
			timer_tocall=Math.floor(aa[0]);
			timer_tocall_frames=0;
			
			cookies_pot=		Math.floor(aa[1]);
			cookies_bet=		Math.floor(aa[2]);
			cookies_yourbet=	Math.floor(aa[3]); // set to 0 after you fold or when you are not in a game
			cookies_raise=		Math.floor(aa[4]);
			cookies_tocall=		cookies_bet-cookies_yourbet;
			
			if( cookies_yourbet==0 ) // can nolonger raise or fold
			{
				disable_button(mc.b2);
				disable_button(mc.b3);
				
				cookies_tocall=0;
			}
			else
			{
				enable_button(mc.b2);
				enable_button(mc.b3);
			}
			thunk(); // display new datas
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
		if(timer_tocall>0)
		{
			timer_tocall_frames++;
			if( timer_tocall_frames > 25 ) // we should be locked to 25ish, not guaranteed but meh
			{
				timer_tocall_frames=0;
				timer_tocall--;
				
				thunk();
			}
		}
	}
}
