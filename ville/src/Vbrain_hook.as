/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) Kriss Daniels 2007 http://www.XIXs.com
//
/*+-----------------------------------------------------------------------------------------------------------------+*/

#include "src/opts.as"

class Vbrain_hook
{
	var up;
	
	var vcobj; // the controlling comms object
	
	function Vbrain_hook(_up)
	{
		up=_up;
		up.type_name="vobj_hook"
	}
	
	function delegate(f,d)	{	return com.dynamicflash.utils.Delegate.create(this,f,d);	}


	function setup(xml)
	{
	var m;
	var vt;
	
		parse_xml(xml,0);
		
		menuset();
		
		
//		gfx.clear(up.mc.hitArea);
//		gfx.draw_box(up.mc.hitArea,0,-20,-80,40,80);

		up.nodes["1"].balloon=new Vballoon(up.up);
		
		up.nodes["1"].balloon.owner = up;
		up.nodes["1"].balloon.node = up.nodes["1"] ;
		
		up.nodes["1"].balloon.setup();
		
//		up.nodes["1"].balloon.set_style( "items1" , 0 , 40 , 40 );
		
		update();
	}
	
	function clean()
	{
		up.nodes["1"].balloon.clean();
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
			
			default:
				poke.hidemenu();
			break;
			}
			
		break;
		}
	}
	
	function do_use(cc, dest)
	{

/*
		cc.vcobj.send_msg_prop( "xyz" , (up.px)+":"+up.py+":"+(up.pz) );
		
		use_now=dest;
		
		use_till = up.up.up.tick_time + 25*60 ; // only try for 1 min
*/
		
	}
	
	
	function update_vcobj(props)
	{
	var aa,i,nam;
	
		if(!props) { props=up.vcobj.props; } // if no changes passed in use main props
		
		for(i=1;i<=1;i++)
		{
			nam="balloon"+i;
			if(props[nam]) // new balloon settings
			{
				aa=props[nam].split(":");
				
				up.nodes[(""+i)].balloon.set_style( aa[1] , Math.floor(aa[2]) , Math.floor(aa[3]) , Math.floor(aa[4]) , aa[5] );
			
			}
		}
		
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
		
		if(props.jiggle) // jiggle balloons
		{
			up.nodes["1"].balloon.jiggle( props.jiggle/1 );
		}
	}
	function update()
	{
		up.anim.page_base="base";
		
		up.nodes["1"].balloon.update();
		
		
	}
}