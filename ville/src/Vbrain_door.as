/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) Kriss Daniels 2007 http://www.XIXs.com
//
/*+-----------------------------------------------------------------------------------------------------------------+*/

#include "src/opts.as"

class Vbrain_door
{
	var up;
	
	var dirt;
	
	var vcobj; // the controlling comms object
	
	function Vbrain_door(_up)
	{
		up=_up;
		up.type_name="vobj_door"
	}
	
	function delegate(f,d)	{	return com.dynamicflash.utils.Delegate.create(this,f,d);	}


	function setup(xml)
	{
	var m;
	var vt;
	
		parse_xml(xml,0);
		
		menuset();
		
		dirt=0;
		
		update();
		
		gfx.clear(up.mc.hitArea);
		gfx.draw_box(up.mc.hitArea,0,-20,-80,40,80);
	}
	
	function clean()
	{
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
		m.items.push({	txt:"Use"		});
		m.items.push({	txt:"Home"		});
		m.items.push({	txt:"Clan"		});
		m.items.push({	txt:"Corridor"		});
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
			case "use":
				do_use(cc,"use");
				poke.hidemenu();
			break;
			
			case "home":
				do_use(cc,"home");
				poke.hidemenu();
			break;
			
			case "clan":
				do_use(cc,"clan");
				poke.hidemenu();
			break;
			
			case "corridor":
				do_use(cc,"corridor");
				poke.hidemenu();
			break;
			
			default:
				poke.hidemenu();
			break;
			}
			
		break;
		}
	}
	
	function do_use(cc, dest)
	{
		up.vcobj.send_msg_prop( "use" , dest );
/*
		cc.vcobj.send_msg_prop( "xyz" , (up.px)+":"+up.py+":"+(up.pz) );
		
		use_now=dest;
		
		use_till = up.up.up.tick_time + 25*60 ; // only try for 1 min
*/
	}
	
	
	var dest="home";
	
	function update_vcobj(props)
	{
	var aa;
	
		if(!props) { props=up.vcobj.props; } // if no changes passed in use main props
		
		if(props.xyz) // new server position, tell object to move here
		{
			aa=props.xyz.split(":");
			
			up.px=Math.floor(aa[0]);
			up.py=Math.floor(aa[1]);
			up.pz=Math.floor(aa[2]);
			
		}
		
		if(props.rot) // new server rotaton
		{
//dbg.print(props.rot)
			aa=props.rot.split(":");
			
			up.rx=Math.floor(aa[0]);
			up.ry=Math.floor(aa[1]);
			up.rz=Math.floor(aa[2]);
			
		}
		
		if(props.title) // new server door title
		{
			up.set_title(props.title);
		}
		
		if(props.dest) // last location this door went to
		{
			dest=props.dest;
//dbg.print("DOOR DEST "+dest)
		}
	}
	
	
	var use_now=false;
	var use_last=0;
	var use_till=0;
	function update()
	{
		up.anim.page_base="base";
		
		if( up.ry == 0 )
		{
			up.anim.mc._x=-75;
			up.anim.mc._y=-100;
		}
		else
		if( up.ry == 90 )
		{
			up.anim.mc._x=-13;
			up.anim.mc._y=-111;
		}
		
		if(use_now)
		{
			if( use_till < up.up.up.tick_time ) // do not keep using for ever and ever
			{
				use_now=false;
			}
				
			var dx,dy,dz;
			dx = up.up.focus.cc.px - up.px ;
			dy = up.up.focus.cc.py - up.py ;
			dz = up.up.focus.cc.pz - up.pz ;
			
//dbg.print("close "+(dx*dx + dy*dy + dz*dz));
			
			if( 50*50 > (dx*dx + dy*dy + dz*dz) )
			{
				if( use_last < up.up.up.tick_time ) // do not over use
				{
//dbg.print("use");
					use_last=up.up.up.tick_time+250;
					up.vcobj.send_msg_prop( "use" , use_now );
				}
			}
		}
		
	}
}