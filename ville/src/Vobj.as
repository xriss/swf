/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) Kriss Daniels 2007 http://www.XIXs.com
//
/*+-----------------------------------------------------------------------------------------------------------------+*/

#include "src/opts.as"

class Vobj
{
	var type_name="vobj";
	
	var up;
	
	var mc;

	var xml;
	
	var anim;
	var brain;
	var type;
	
	var talk;
	
	var focus;
	
	var ox,oy,oz; // origin or handle, just add these numbers before calculating 2d display point
	var sx,sy,sz; // the 3d size of this object
		
	var dx,dy,dz; // px+ox , py+oy , pz+oz
	
	var tx,ty,tz; // move to this point
	
	var px,py,pz; // our position
	var rx,ry,rz; // our rotation
	
	var loading;
	
	var nodes;
	
	var vcobj; // the controlling comms object
	
	var room;
	function Vobj(_up)
	{
		up=_up;
		
		room=up.room;
		
//		anim=new Vanim(this);
//		brain=new Vbrain(this);
	}
	
	function delegate(f,d)	{	return com.dynamicflash.utils.Delegate.create(this,f,d);	}


	function setup(url,xmlopts)
	{
	var m;
	var vt;
	
		nodes=[];
	
		mc=gfx.create_clip(up.mc,null);
		mc.cc=this;
		mc._z=0;
		up.insert_mc(mc,true);
		
		ox=0;
		oy=0;
		oz=0;
		
		sx=0;
		sy=0;
		sz=0;
		
		px=0;
		py=0;
		pz=0;
		
		dx=0;
		dy=0;
		dz=0;
		
		tx=0;
		ty=0;
		tz=0;
		
		rx=0;
		ry=0;
		rz=0;
		
		
		if(xmlopts) // part of an xml room load
		{
			parse_xml(xmlopts,0);
		}
		else
		if(url)	// just load from this file
		{
			load_xml(url);
		}
		
	}
	
	function clean()
	{
		talk.clean(); talk=null;
		
		mc.removeMovieClip();
	}
	
	function set_title(str)
	{
	var m;
	
		if(!mc.title)
		{
			m=gfx.create_clip(mc,null,0,-90);
			m.tf=gfx.create_text_html(m,null,0,0,200,25);
			m._visible=false;
			mc.title=m;
		}
		m=mc.title;
		
		gfx.set_text_html(m.tf,16,0xffffff,"<b>"+str+"</b>");
		
		m.w=m.tf.textWidth;
		m.h=m.tf.textHeight;
		m.tf._x=-m.w/2;
		m.tf._y=-m.h/2;
		
		gfx.clear(m);
		m.style.fill=0xff000000;
		gfx.draw_rounded_rectangle(m,10,10,0,-m.w/2-10-2,-m.h/2-10-1,m.w+20+6+4,m.h+20+6);
	}
	
	
	function load_xml(url)
	{
		loading="Loading XML";
		xml=new XML();
		xml.url=url;
		xml.onLoad=delegate(loaded_xml,xml);
		xmlcache.load(xml);
	}
	
	function loaded_xml(suc)
	{
	var frm=suc;
	
		if(frm!="swf")
		{
			frm=frm?"url":"failed";
		}		
//dbg.print("loaded "+frm+" "+xml.url);

		if(suc) //loaded
		{
			parse_xml(xml,0);
		}
		else
		{
dbg.print("failed to load "+xml.url);
		}
		
		loading=null;
	}
	
	function parse_xml(e,d,flavour,id)
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
				case "vobj":
				
					if(e.attributes.src) // load more data from this file
					{
						load_xml(e.attributes.src);
					}
					
					children=true;
					flavour="vobj";
				break;
								
				case "xyz":
				
					if(flavour=="node") // a node is a connection point within another object
					{
						i=e.attributes.x_pos; if(i) { nodes[id].x=Math.floor(i); }
						i=e.attributes.y_pos; if(i) { nodes[id].y=Math.floor(i); }
						i=e.attributes.z_pos; if(i) { nodes[id].z=Math.floor(i); }
//dbg.print(id+" : "+nodes[id].x+" , "+nodes[id].y+" , "+nodes[id].z);
					}
					else
					{
						i=e.attributes.x_pos; if(i) { px=Math.floor(i); }
						i=e.attributes.y_pos; if(i) { py=Math.floor(i); }
						i=e.attributes.z_pos; if(i) { pz=Math.floor(i); }
					
						i=e.attributes.x_siz; if(i) { sx=Math.floor(i); }
						i=e.attributes.y_siz; if(i) { sy=Math.floor(i); }
						i=e.attributes.z_siz; if(i) { sz=Math.floor(i); }
						
						i=e.attributes.x_off; if(i) { ox=Math.floor(i); }
						i=e.attributes.y_off; if(i) { oy=Math.floor(i); }
						i=e.attributes.z_off; if(i) { oz=Math.floor(i); }
					}
					
				break;
				
				case "anim":
					anim=new Vanim(this);
					anim.setup(e);
				break;
				
				case "node":
					children=true;
					flavour="node";
					id=e.attributes.id;
					nodes[id]=[];
				break;
				
				case "brain":
				
					type=e.attributes.type;
					switch(e.attributes.type)
					{
						case "urinal":
							brain=new Vbrain_urinal(this);
						break;
						
						case "sink":
							brain=new Vbrain_sink(this);
						break;
						
						case "toilet":
							brain=new Vbrain_toilet(this);
						break;
						
						case "ball":
							brain=new Vbrain_ball(this);
						break;
						
						case "pot":
							brain=new Vbrain_pot(this);
						break;
						
						case "hook":
							brain=new Vbrain_hook(this);
						break;
						
						case "comic":
							brain=new Vbrain_comic(this);
						break;
						
						case "door":
							brain=new Vbrain_door(this);
						break;
						
						case "candle":
							brain=new Vbrain_candle(this);
						break;
						
						case "talk":
							brain=new Vbrain_talk(this);
						break;
						
						case "poker":
							brain=new Vbrain_poker(this);
						break;
						
						case "cards":
							brain=new Vbrain_cards(this);
						break;
						
						default:
							brain=new Vbrain(this);
						break;
					}
					
					brain.setup(e);
				break;
				
				default:
					children=true;
				break;
			}
			if( children )
			{
				for( ec=e.firstChild ; ec ; ec=ec.nextSibling )
				{
					parse_xml(ec,d+1,flavour,id);
				}
			}
		}
		
	}
	
//
// Vcobj props ave changeds, update the vobj with new settings
//
	function update_vcobj(props)
	{
		brain.update_vcobj(props); // pass onto brain
		
	var aa;
	
		if(!props) { props=vcobj.props; } // if no changes passed in use main props
		
		
		if(props.focus) // new focus
		{
			focus=vcobj.up.vcobjs[props.focus].vobj;
		}
		
	}
	
	function update()
	{
//	var	r=Math.atan2(tx-dx,tz-dz);
//		rz=180*r/Math.PI;
	
		dx=px+ox;
		dy=py+oy;
		dz=pz+oz;
	
		mc._x=up.x2+dx+(dz/4);
		mc._y=up.y2+dy-(dz/4);
		mc._z=dz;
		
		brain.update();
		anim.update();
	}
}
