/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) Kriss Daniels 2007 http://www.XIXs.com
//
/*+-----------------------------------------------------------------------------------------------------------------+*/

#include "src/opts.as"



class Vtv
{
	var up;
	
	var type_name="vtv";
		
	var mc;
	var dx,dy,dz; // draw position
	var sx,sy,sz;
	var px,py,pz;
	var ox,oy,oz;
	
	var loading;	
	
	var vcobj; // the controlling comms object, if it has one?
	
	var vplay;
	
	var mcs;
	
	function Vtv(_up)
	{
		up=_up;
		
		vplay=new WetVPlay(this);
	}
	
	function delegate(f,d)	{	return com.dynamicflash.utils.Delegate.create(this,f,d);	}

	function setup(url,xmlopts)
	{
		dx=0;
		dy=0;
		dz=0;
		sx=0;
		sy=0;
		sz=0;
	
		ox=0;
		oy=0;
		oz=0;		
		px=0;
		py=0;
		pz=0;
		
		mc=gfx.create_clip(up.mc,null);
		mc.cc=this;
		up.insert_mc(mc,false);
		

		if(xmlopts) // part of an xml room load
		{
			parse_xml(xmlopts,0);
		}
		
		vplay.setup(true,"1067x600");
		
		
		mcs=[];
		
		mcs.title=gfx.create_clip(mc,null,0,-50);
		mcs.title.tf=gfx.create_text_html(mcs.title,null,0,0,1067,50);

		mcs.time=gfx.create_clip(mc,null,-400,0);
		mcs.time.tf=gfx.create_text_html(mcs.time,null,0,0,400,200);
		
		update();
		
	}
	
	function clean()
	{
		vplay.clean();
		
		mc.cc=null;
		mc.removeMovieClip();
	}
	
	function parse_xml(e,d,flavour)
	{
	var ec;
	var children;
	var i;
	
		children=false;
		
		if(e.nodeType==1)
		{
//dbg.print(d+":"+e.nodeType+":"+e.nodeName);

			switch(e.nodeName)
			{
				case "xyz":
				
					i=e.attributes.x_pos; if(i) { px=Math.floor(i); }
					i=e.attributes.y_pos; if(i) { py=Math.floor(i); }
					i=e.attributes.z_pos; if(i) { pz=Math.floor(i); }
				
					i=e.attributes.x_siz; if(i) { sx=Math.floor(i); }
					i=e.attributes.y_siz; if(i) { sy=Math.floor(i); }
					i=e.attributes.z_siz; if(i) { sz=Math.floor(i); }
					
					i=e.attributes.x_off; if(i) { ox=Math.floor(i); }
					i=e.attributes.y_off; if(i) { oy=Math.floor(i); }
					i=e.attributes.z_off; if(i) { oz=Math.floor(i); }
					
				break;
				
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
	
//
// Vcobj props ave changeds, update the vobj with new settings
//
	function update_vcobj(props)
	{
		if(!props) { props=vcobj.props; } // if no changes passed in use main props
	}
	
	
	function update()
	{

		dx=px;
		dy=py-sy;
		dz=pz;
	
		mc._xscale=100*sx/1067;
		mc._yscale=100*sy/600;
		
		
		mc._x=up.x2+dx+(dz/4);
		mc._y=up.y2+dy-(dz/4);
		mc._z=dz;
		
		vplay.update();
		
		gfx.set_text_html(mcs.title.tf,32,0xffffffff,"<p align=\"center\">"+vplay.info.title+"</p>");
		
		var n1=Math.floor(Math.ceil(vplay.info.lock)-vplay.info.pos);
		var n2=Math.floor(Math.ceil(vplay.info.len )-vplay.info.pos);
		if(n1<0) { n1=0; }
		
		gfx.set_text_html(mcs.time.tf,64,0xffffffff,"<p align=\"right\">"+n1+"<br>"+n2+"</p>");
	}
}