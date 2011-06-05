/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) Kriss Daniels 2007 http://www.XIXs.com
//
/*+-----------------------------------------------------------------------------------------------------------------+*/

#include "src/opts.as"

class Vbrain_ball
{
	var up;
	
	var vcobj; // the controlling comms object
	
	function Vbrain_ball(_up)
	{
		up=_up;
		
		up.type_name="vobj_ball"
	}
	
	
	function delegate(f,d)	{	return com.dynamicflash.utils.Delegate.create(this,f,d);	}


	function setup(xml)
	{
	var m;
	var vt;
	
		parse_xml(xml,0);
		
//		menuset();

// make unclickable
		up.mc.onRollOver=null;
		up.mc.onRollOut=null;
		up.mc.onReleaseOutside=null;
		up.mc.onRelease=null;

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
				poke.hidemenu();
			break;
			
			default:
				poke.hidemenu();
			break;
			}
			
		break;
		}
	}
	
	function do_use(cc)
	{
//		cc.vcobj.send_msg_prop( "xyz" , (up.px+40)+":"+up.py+":"+(up.pz+80+20) );
//		cc.vcobj.send_msg_prop( "idle" , "idle" );
/*
		cc.tx=up.px+40;
		cc.ty=up.py;
		cc.tz=up.pz+80+20;
		cc.idle_type="idle";
*/		
	}

	function update_vcobj(props)
	{
	var aa;
	
		if(!props) { props=up.vcobj.props; } // if no changes passed in use main props
		
		if(props.xyz) // new server position, tell object to move here
		{
			aa=props.xyz.split(":");
			
			up.tx=Math.floor(aa[0]);
			up.ty=Math.floor(aa[1]);
			up.tz=Math.floor(aa[2]);
			
		}
		
		if(props.goal) // someone has just scored
		{
			up.up.up.up.pixls.add_goal();
		}
	}
	
	var kick_time=0;
	var kick_last=0;
	
	function update()
	{
	var vx,vy,vz,f;
	
	var dx,dy,dz;
	
	kick_time+=1;

// if our user gets close to the ball then send a kick msg

		if( up.px==0 && up.py==0 && up.pz==0 )
		{
			up.px=up.tx;
			up.py=up.ty;
			up.pz=up.tz;
		}
		else // move towards
		{
			vx=up.tx-up.px;
			vy=up.ty-up.py;
			vz=up.tz-up.pz;
			
			f=vx*vx+vz*vz;
			if(f>10*10)
			{
				f=Math.sqrt(f);
				vx=vx*10/f;
				vz=vz*10/f;
			}
			
			up.px+=vx;
			up.pz+=vz;
		}
		
		up.up.mirror_bounce(up);
		
		up.mc._rotation=up.px*2;

		dx = up.up.focus.cc.px - up.px ;
		dy = up.up.focus.cc.py - up.py ;
		dz = up.up.focus.cc.pz - up.pz ;
		
//dbg.print("close "+(dx*dx + dy*dy + dz*dz));
		
		if( 50*50 > (dx*dx + dy*dy + dz*dz) )
		{
			if( kick_last+5 < kick_time ) // do not over kick
			{
				kick_last=kick_time;
				up.up.focus.cc.vcobj.send_msg_prop( "kick" , "1" );
			}
		}

	
	}
}