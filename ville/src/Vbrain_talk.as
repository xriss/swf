/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) Kriss Daniels 2007 http://www.XIXs.com
//
/*+-----------------------------------------------------------------------------------------------------------------+*/

#include "src/opts.as"

class Vbrain_talk
{
	var up;
	
	var room;
	
	var name;
	
	function Vbrain_talk(_up)
	{
		up=_up;
		room=up.room;
		up.type_name="vobj_talk"
	}
	
	function delegate(f,d)	{	return com.dynamicflash.utils.Delegate.create(this,f,d);	}


	function setup(xml)
	{
	var m;
	var vt;
	
		parse_xml(xml,0);
		
		up.talk=room.talky.create(up.mc,0,0);
		room.up.comms.names[name.toLowerCase()]=up.vobj; // remember players id
			
			
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
		
		if(props.rot) // new server rotaton
		{
//dbg.print(props.rot)
			aa=props.rot.split(":");
			
			up.rx=Math.floor(aa[0]);
			up.ry=Math.floor(aa[1]);
			up.rz=Math.floor(aa[2]);
			
		}
		
	}
	function update()
	{
	}
}