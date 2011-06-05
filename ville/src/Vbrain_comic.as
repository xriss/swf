/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) Kriss Daniels 2007 http://www.XIXs.com
//
/*+-----------------------------------------------------------------------------------------------------------------+*/

#include "src/opts.as"

class Vbrain_comic
{
	var up;
	
	var vcobj; // the controlling comms object
	
	var m;
	
	function Vbrain_comic(_up)
	{
		up=_up;
		up.type_name="vobj_comic"
	}
	
	function delegate(f,d)	{	return com.dynamicflash.utils.Delegate.create(this,f,d);	}


	function setup(xml)
	{
	var m;
	var vt;
	
		parse_xml(xml,0);
		
		menuset();
		
		update();
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
	}
	function update()
	{
		m.forceSmoothing=true; // keep on setting it till flash decides to pay attention, sometimes it doesnt
	}
}