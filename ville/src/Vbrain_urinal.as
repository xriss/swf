/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) Kriss Daniels 2007 http://www.XIXs.com
//
/*+-----------------------------------------------------------------------------------------------------------------+*/

#include "src/opts.as"

class Vbrain_urinal
{
	var up;
	
	var dirt;
	
	var vcobj; // the controlling comms object
	
	function Vbrain_urinal(_up)
	{
		up=_up;
		up.type_name="vobj_urinal"
	}
	
	function delegate(f,d)	{	return com.dynamicflash.utils.Delegate.create(this,f,d);	}


	function setup(xml)
	{
	var m;
	var vt;
	
		parse_xml(xml,0);
		
		menuset();
		
		dirt=0;
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
		m.items.push({	txt:"Clean"		});
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
	var cc;
	
		switch(menu.name)
		{
		default:
			switch(item.txt.toLowerCase())
			{
			case "use":
				cc=poke.up.focus.cc;
				do_use(cc);
				do_dirt(cc);
				poke.hidemenu();
			break;
			
			case "clean":
				cc=poke.up.focus.cc;
				do_clean(cc);
				poke.hidemenu();
			break;
			
			default:
				poke.hidemenu();
			break;
			}
			
		break;
		}
	}
	
	function do_dirt()
	{
		up.vcobj.send_msg_prop( "dirt" , dirt+1 );
	}
	
	function do_clean()
	{
		up.vcobj.send_msg_prop( "dirt" , dirt-1 );
	}
	
	function do_use(cc)
	{
		up.vcobj.send_msg_prop( "focus" , cc.vcobj.id );
		cc.vcobj.send_msg_prop( "focus" , up.vcobj.id );
		
		cc.vcobj.send_msg_prop( "xyz" , (up.px)+":"+up.py+":"+(up.pz-20) );
		cc.vcobj.send_msg_prop( "idle" , "idle_back" );
	}
	
	function update_vcobj(props)
	{
	var aa;
	
		if(!props) { props=up.vcobj.props; } // if no changes passed in use main props
		
		if(props.dirt) // new dirt setting
		{
			dirt=Math.floor(props.dirt);
			if(dirt>4) {dirt=4;}
			if(dirt<0) {dirt=0;}
			up.anim.page_base="dirt"+dirt;
		}
		
		if(props.xyz) // new server position, tell object to move here
		{
			aa=props.xyz.split(":");
			
			up.px=Math.floor(aa[0]);
			up.py=Math.floor(aa[1]);
			up.pz=Math.floor(aa[2]);
			
		}
	}
	
	function update()
	{
	}
}