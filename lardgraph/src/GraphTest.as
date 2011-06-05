/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) Kriss Daniels 2006 http://www.XIXs.com
//
/*+-----------------------------------------------------------------------------------------------------------------+*/

#include "src/opts.as"

import com.wetgenes.gfx;
import com.dynamicflash.utils.Delegate;
import com.wetgenes.dbg;


class GraphTest
{

	var state_last;
	var state;
	var state_next;

	var up;
	
	var mc;
	
	var	xml;
	var	dat;
	var	dat_numof;
	var	dat_max;
	
	var sy;
	
	var tf;
	
	var xmin,ymin,xmax,ymax;	// graph area within clip
	var xsiz,ysiz; 				// max-min
	var xmul,ymul; 				// scale input numbers to fit into output
	
	function delegate(f,d)	{	return Delegate.create(this,f,d);	}
	
	function GraphTest(_up)
	{
		up=_up;
	}
	
	function setup()
	{		
	
//		dbg.print( "test setup " );

		state_last=null;
		state=null;
		state_next=null;

// create master layout mc, I will do smart positioning and scaling
		mc=gfx.create_clip(up.mc,null);
		mc.style=new Array();

// grab input
		Mouse.addListener(this);

// request xml data

		state_next="load";

	}
	
	function onMouseDown()
	{
	}
	
	function onMouseUp()
	{
	}

	function update()
	{
//		dbg.print( "test upate "+state );

		if(state_next!=null)
		{
			state_last=state;
			state=state_next;
			state_next=null;
			
			switch(state_last)
			{
				case "load" :									break;
				case "draw" :			draw_clean();			break;
			}

			switch(state)
			{
				case "load" :			load_xml_pre();			break;
				case "draw" :			draw_setup();			break;
			}
			
		}
	
			switch(state)
			{
				case "load" :									break;
				case "draw" :			draw_update();			break;
			}
			
			
	}
	
	
	function draw_setup()
	{
		var s;
		
		sy=0;
		tf=new Array();
		tf[0]=gfx.create_text_html(mc,null,48,16,200,32);
		tf[1]=gfx.create_text_html(mc,null,800-64,600-48,200,32);
		
		s="";
		s+="<font face=\"Bitstream Vera Sans\" size=\"16\" color=\"#ffffff\">";
		s+="Score";
		s+="</font>";
		tf[0].htmlText=s;
		tf[0]._rotation=90;
		
		s="";
		s+="<font face=\"Bitstream Vera Sans\" size=\"16\" color=\"#ffffff\">";
		s+="Turns";
		s+="</font>";
		tf[1].htmlText=s;

	}
	function draw_clean()
	{
	}
	function draw_update()
	{
		var i;
		var tx,ty;
		
		sy+=(1-sy)/16;
		
		mc.clear();
		
		xmin=(0+16);
		ymin=(0+16);
		
		xmax=(800-16);
		ymax=(600-16);
		
		xsiz=xmax-xmin;
		ysiz=ymax-ymin;
		
		xmul=xsiz/(dat_numof-1);
		ymul=ysiz/dat_max;

		mc.lineStyle( 4, 0x8080ff, 50 );
		
		for(i=0;i<dat_numof;i++)
		{
		
			tx=xmin+i*xmul;
			ty=ymax-dat[i]*ymul*sy;
		
			if(i==0)
			{
				mc.moveTo(tx,ty);
			}
			else
			{
				mc.lineTo(tx,ty);
			}
		}
		
		mc.style.out=0xffffffff;
		mc.style.fill=0xffffffff;
		
		for(i=0;i<dat_numof;i++)
		{
		
			tx=xmin+i*xmul;
			ty=ymax-dat[i]*ymul*sy;

			gfx.draw_box(mc,4,tx-8,ty-8,16,16);
		}
		
		for(i=0;i<dat_numof;i++)
		{
		
		mc.moveTo(xmax,ymax);
		mc.lineTo(xmin,ymax);
		
		}
		
		mc.lineStyle( 4, 0x8080ff, 50 );

		mc.moveTo(xmax,ymax);
		mc.lineTo(xmin,ymax);
		
		mc.moveTo(xmin,ymin);
		mc.lineTo(xmin,ymax);

			
	
/*		
		mc.beginFill(0x8080ff,50);
		mc.moveTo(xmin,ymax);
		for(i=0;i<dat_numof;i++)
		{
			mc.lineTo(xmin+i*xmul,ymax-dat[i]*ymul*sy);
		}
		mc.lineTo(xmax,ymax);
		mc.lineTo(xmin,ymax);
		mc.endFill();
*/


/*
		for(tt=4;tt>=1;tt--)
		{
			var tx,ty;
			
			tx=0.05*tt;
			ty=(tx*xmul)/ymul;
			
			for(i=0;i<dat_numof-1;i++)
			{
				var t;
				
				t=(dat[i]*ymul-dat[i+1]*ymul);
				
				beginFill(0x8080ff,25);
				moveTo(xmin+(i+tx)  *xmul,ymax-ty*ymul);
				lineTo(xmin+(i+tx)  *xmul,ymax-(dat[i]-ty)*ymul+tx*t);
				lineTo(xmin+(i+1-tx)*xmul,ymax-(dat[i+1]-ty)*ymul-tx*t);
				lineTo(xmin+(i+1-tx)*xmul,ymax-ty*ymul);
				lineTo(xmin+(i+tx)  *xmul,ymax-ty*ymul);
				endFill();
			}
		}
*/

	}
	
	function clean()
	{
	}	
	
	function load_xml_pre()
	{
		dbg.print( "load xml pre" );

		xml=new XML();
		
		if(_root.f_args)
		{
			xml.load("xml.php?cmd="+_root.f_cmd+"&user="+_root.f_user+"&min="+_root.f_min+"&max="+_root.f_max);
		}
		else
		{
			xml.load("test.xml");
		}
		
		xml.onLoad=delegate(load_xml_post);

	}
	
	function load_xml_post()
	{
		dbg.print( "load xml post" );

		dat=new Array();
		dat_numof=0;
		dat_max=1;
		
		
		var xml_dat=xml.firstChild.firstChild;
		var i=0;
		
		i=0;
		while(xml_dat)
		{
			if(xml_dat.nodeName=="turn")
			{
				dat[i]=Number(xml_dat.attributes.pop);
				if(dat_max<dat[i]) { dat_max=dat[i]; }
				
				dbg.print( i + "=" + dat[i] );
				
				i++;
				dat_numof=i;
			}
			xml_dat=xml_dat.nextSibling;
		}
		
		state_next="draw";

	}
	
	function do_str(str)
	{
		switch(str)
		{
			default:
			break;
		}
	}		
}


