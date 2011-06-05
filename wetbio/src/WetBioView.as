/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) Kriss Daniels 2006 http://www.XIXs.com
//
/*+-----------------------------------------------------------------------------------------------------------------+*/

#include "src/opts.as"

import com.Sprintf;
import com.dynamicflash.utils.Delegate;


class WetBioView
{
	var wetbio:WetBio;
	var mc:MovieClip;
	var mcm:MovieClip;

	var opts:WetBioOpts;
	var curve:WetBioCurve;
	var about:WetBioAbout;
	

	var dest_x:Number;

// state to use, set before changing master state to this
	var state		:Number;
	
	var fmt:TextFormat;
	
	var styles;
	var stylesets;

	function delegate(f:Function) { return Delegate.create(this,f); }

// onetime setup
	function WetBioView(_wetbio)
	{
		wetbio=_wetbio;
		
		fmt=new TextFormat();
		fmt.font="Bitstream Vera Sans";
		fmt.size=32;
		fmt.color=0x000000;
		fmt.bold=true;
		
		dest_x=0;
	
		setup();
		clean();

		opts=new WetBioOpts(wetbio);
		curve=new WetBioCurve(wetbio);
		about=new WetBioAbout(wetbio);
	}

// on entering this state
	function setup()
	{
		if(mc)	// rebuild main movieclip
		{
			mc.removeMovieClip();
			mc=null;
		}
		mc=gfx.create_clip(wetbio.layout,null);
		mc.t=this;
		mc._visible=true;
		
		if(mcm)	// rebuild mask movieclip
		{
			mcm.removeMovieClip();
			mcm=null;
		}
		mcm=gfx.create_clip(wetbio.layout,null);
		mcm.t=this;
		mcm._visible=false;
		mc.setMask(mcm);
		
		
		var tf;
		var s;
		
		stylesets={};
		
		styles={};
		styles.mask={				fill:0xffffffff,	out:0xffffffff,	text:0xffffffff		};
		styles.box_about={			fill:0xffccccff,	out:0xff000000,	text:0xff000000		};
		styles.box_title={			fill:0xffccccff,	out:0xff000000,	text:0xff000000		};
		styles.box_options={		fill:0xffccccff,	out:0xff000000,	text:0xff000000		};
		styles.box_view={			fill:0xffccccff,	out:0xff000000,	text:0xff000000		};
		styles.box_sel={			fill:0x40000000,	out:0xc0ffffff,	text:0xff000000		};
		styles.box_pop={			fill:0xc0ffffff,	out:0xffffffff,	text:0xff000000		};
		styles.box_pop_day={		fill:0xc0ffffff,	out:0xffffffff,	text:0xff000080		};
		styles.box_pop_excelent={	fill:0xc0ffffff,	out:0xffffffff,	text:0xff008000		};
		styles.box_pop_good={		fill:0xc0ffffff,	out:0xffffffff,	text:0xff008000		};
		styles.box_pop_ok={			fill:0xc0ffffff,	out:0xffffffff,	text:0xff800000		};
		styles.box_pop_bad={		fill:0xc0ffffff,	out:0xffffffff,	text:0xff800000		};
		styles.box_pop_emo={		fill:0xc0ffffff,	out:0xffffffff,	text:0xff800000		};
		styles.box_pop_phy={		fill:0xc0ffffff,	out:0xffffffff,	text:0xff008000		};
		styles.box_pop_int={		fill:0xc0ffffff,	out:0xffffffff,	text:0xff000080		};
		styles.box_input={			fill:0xffffffff,	out:0xff800000,	text:0xff000000		};
		styles.curve_red={			fill:0x40ff0000,	out:0x80800000,	text:0xffffffff		};
		styles.curve_grn={			fill:0x4000ff00,	out:0x80008000,	text:0xffffffff		};
		styles.curve_blu={			fill:0x400000ff,	out:0x80000080,	text:0xffffffff		};
		styles.lighter={			fill:0x10ffffff,	out:0x08ffffff,	text:0xffffffff		};
		styles.darker={				fill:0x10000000,	out:0x08000000,	text:0xffffffff		};
		stylesets['pastelblue']=styles;

		styles={};
		styles.mask={			fill:0xffffffff,	out:0xffffffff,	text:0xffffffff		};
		styles.box_about={		fill:0xff333333,	out:0xff000000,	text:0xffcccccc		};
		styles.box_title={		fill:0xff000000,	out:0xff000000,	text:0xff33ff33		};
		styles.box_options={	fill:0xff333333,	out:0xff000000,	text:0xffcccccc		};
		styles.box_view={		fill:0xff333333,	out:0xff000000,	text:0xff000000		};
		styles.box_sel={		fill:0x80000000,	out:0x00000000,	text:0xff000000		};
		styles.box_pop={		fill:0x80000000,	out:0x00000000,	text:0x80ffffff		};
		styles.box_pop_day={		fill:0xc0ffffff,	out:0xffffffff,	text:0xffffffff		};
		styles.box_pop_excelent={	fill:0xc0ffffff,	out:0xffffffff,	text:0xffcc00ff		};
		styles.box_pop_good={		fill:0xc0ffffff,	out:0xffffffff,	text:0xff00ffcc		};
		styles.box_pop_ok={			fill:0xc0ffffff,	out:0xffffffff,	text:0xff00ffff		};
		styles.box_pop_bad={		fill:0xc0ffffff,	out:0xffffffff,	text:0xffffff00		};
		styles.box_pop_emo={		fill:0xc0ffffff,	out:0xffffffff,	text:0xffff33cc		};
		styles.box_pop_phy={		fill:0xc0ffffff,	out:0xffffffff,	text:0xff33ff33		};
		styles.box_pop_int={		fill:0xc0ffffff,	out:0xffffffff,	text:0xff0000ff		};
		styles.box_input={		fill:0xffffffff,	out:0xff33ff33,	text:0xff000000		};
		styles.curve_red={		fill:0x40000000,	out:0xffff33cc,	text:0xffffffff		};
		styles.curve_grn={		fill:0x40000000,	out:0xff33ff33,	text:0xffffffff		};
		styles.curve_blu={		fill:0x40000000,	out:0xff0000ff,	text:0xffffffff		};
		styles.lighter={		fill:0x20666666,	out:0x20666666,	text:0xffffffff		};
		styles.darker={			fill:0x20000000,	out:0x20000000,	text:0xffffffff		};
		stylesets['noneon']=styles;
		
		styles={};
		styles.mask={			fill:0xffffffff,	out:0xffffffff,	text:0xffffffff		};
		styles.box_about={		fill:0xffff99cc,	out:0xffff99cc,	text:0xffffffff		};
		styles.box_title={		fill:0xffffffff,	out:0xffccffcc,	text:0xffff99cc		};
		styles.box_options={	fill:0xffff99cc,	out:0xffff99cc,	text:0xffffffff		};
		styles.box_view={		fill:0xffffffff,	out:0xffffffff,	text:0xff000000		};
		styles.box_sel={		fill:0x80ffffff,	out:0x80ccffcc,	text:0xff000000		};
		styles.box_pop={		fill:0x80ffffff,	out:0x80ccffcc,	text:0x80999999		};
		styles.box_pop_day={		fill:0x80ffffff,	out:0xffffffff,	text:0xffff99cc		};
		styles.box_pop_excelent={	fill:0xc0ffffff,	out:0xffffffff,	text:0xffff99cc		};
		styles.box_pop_good={		fill:0xc0ffffff,	out:0xffffffff,	text:0xffff99cc		};
		styles.box_pop_ok={			fill:0xc0ffffff,	out:0xffffffff,	text:0xff00ccff		};
		styles.box_pop_bad={		fill:0xc0ffffff,	out:0xffffffff,	text:0xffff9900		};
		styles.box_pop_emo={		fill:0x80ffffff,	out:0xffffffff,	text:0xffff6699		};
		styles.box_pop_phy={		fill:0x80ffffff,	out:0xffffffff,	text:0xff66cc99		};
		styles.box_pop_int={		fill:0x80ffffff,	out:0xffffffff,	text:0xff6699ff		};
		styles.box_input={		fill:0xffffffff,	out:0xffccffcc,	text:0xff000000		};
		styles.curve_red={		fill:0xc0ffcccc,	out:0xffffcccc,	text:0xffffffff		};
		styles.curve_grn={		fill:0xc0ccffcc,	out:0xffccffcc,	text:0xffffffff		};
		styles.curve_blu={		fill:0xc0ccccff,	out:0xffccccff,	text:0xffffffff		};
		styles.lighter={		fill:0x80ffcccc,	out:0x80ffcccc,	text:0xffffffff		};
		styles.darker={			fill:0x40ffcccc,	out:0x40ffcccc,	text:0xffffffff		};
		stylesets['candystriptease']=styles;
		
		styles={};
		styles.mask={			fill:0xffffffff,	out:0xffffffff,	text:0xffffffff		};
		styles.box_about={		fill:0xff000000,	out:0xff000000,	text:0xffffffff		};
		styles.box_title={		fill:0xff333333,	out:0xff000000,	text:0xffffffff		};
		styles.box_options={	fill:0xff000000,	out:0xff000000,	text:0xffffffff		};
		styles.box_view={		fill:0xff666666,	out:0xff666666,	text:0xff000000		};
		styles.box_sel={		fill:0x80cccccc,	out:0x00000000,	text:0xff000000		};
		styles.box_pop={		fill:0x80cccccc,	out:0x00000000,	text:0x80ffffff		};
		styles.box_pop_day={		fill:0xc0ffffff,	out:0xffffffff,	text:0xff000000		};
		styles.box_pop_excelent={	fill:0xc0ffffff,	out:0xffffffff,	text:0xffffff00		};
		styles.box_pop_good={		fill:0xc0ffffff,	out:0xffffffff,	text:0xff333333		};
		styles.box_pop_ok={			fill:0xc0ffffff,	out:0xffffffff,	text:0xff333333		};
		styles.box_pop_bad={		fill:0xc0ffffff,	out:0xffffffff,	text:0xff333333		};
		styles.box_pop_emo={		fill:0xc0ffffff,	out:0xffffffff,	text:0xffffff00		};
		styles.box_pop_phy={		fill:0xc0ffffff,	out:0xffffffff,	text:0xff000000		};
		styles.box_pop_int={		fill:0xc0ffffff,	out:0xffffffff,	text:0xffffffff		};
		styles.box_input={		fill:0xffffffff,	out:0xffffff00,	text:0xff000000		};
		styles.curve_red={		fill:0x40000000,	out:0xffffff00,	text:0xffffffff		};
		styles.curve_grn={		fill:0x40000000,	out:0xff000000,	text:0xffffffff		};
		styles.curve_blu={		fill:0x40000000,	out:0xff666666,	text:0xffffffff		};
		styles.lighter={		fill:0x20999999,	out:0x20999999,	text:0xffffffff		};
		styles.darker={			fill:0x20cccccc,	out:0x20cccccc,	text:0xffffffff		};
		stylesets['minimono']=styles;
		
		styles={};
		styles.mask={			fill:0xffffffff,	out:0xffffffff,	text:0xffffffff		};
		styles.box_about={		fill:0xffff9900,	out:0xffcc00ff,	text:0xffffffff		};
		styles.box_title={		fill:0xffcc00ff,	out:0xffcc00ff,	text:0xffffffff		};
		styles.box_options={	fill:0xffff9900,	out:0xffcc00ff,	text:0xffffffff		};
		styles.box_view={		fill:0xffffffff,	out:0xffffffff,	text:0xff000000		};
		styles.box_sel={		fill:0xc0ffccff,	out:0x80ff9900,	text:0xff000000		};
		styles.box_pop={		fill:0xc0ffccff,	out:0x80ff9900,	text:0x80ffffff		};
		styles.box_pop_day={		fill:0xc0ffffff,	out:0xffffffff,	text:0xffcc00ff		};
		styles.box_pop_excelent={	fill:0xc0ffffff,	out:0xffffffff,	text:0xff9933cc		};
		styles.box_pop_good={		fill:0xc0ffffff,	out:0xffffffff,	text:0xff9933cc		};
		styles.box_pop_ok={			fill:0xc0ffffff,	out:0xffffffff,	text:0xff9933cc		};
		styles.box_pop_bad={		fill:0xc0ffffff,	out:0xffffffff,	text:0xffff9900		};
		styles.box_pop_emo={		fill:0xc0ffffff,	out:0xffffffff,	text:0xff66ccff		};
		styles.box_pop_phy={		fill:0xc0ffffff,	out:0xffffffff,	text:0xffff9900		};
		styles.box_pop_int={		fill:0xc0ffffff,	out:0xffffffff,	text:0xffcc00ff		};
		styles.box_input={		fill:0xffffffff,	out:0xffcc00ff,	text:0xff000000		};
		styles.curve_red={		fill:0x4066ffcc,	out:0xff66ffcc,	text:0xffffffff		};
		styles.curve_grn={		fill:0x40ff9900,	out:0xffff9900,	text:0xffffffff		};
		styles.curve_blu={		fill:0x40cc00ff,	out:0xffcc00ff,	text:0xffffffff		};
		styles.lighter={		fill:0x40cc00ff,	out:0x40cc00ff,	text:0xffffffff		};
		styles.darker={			fill:0x20cc00ff,	out:0x20cc00ff,	text:0xffffffff		};
		stylesets['luluinthesky']=styles;



		styles=stylesets[opts.theme_str];
		
		if(!styles) {	styles=stylesets['pastelblue'];	}


		{
		var cm;
		var cmi;
		var f;
			cm = new ContextMenu();
			f=function()	{	_root.wetbio.view.opts.theme_str='pastelblue'; _root.wetbio.view.clean(); _root.wetbio.view.setup();	};
			cmi = new ContextMenuItem("Set theme to pastelblue", f )
			cm.customItems.push(cmi);
			f=function()	{	_root.wetbio.view.opts.theme_str='noneon'; _root.wetbio.view.clean(); _root.wetbio.view.setup();	};
			cmi = new ContextMenuItem("Set theme to noneon", f )
			cm.customItems.push(cmi);
			f=function()	{	_root.wetbio.view.opts.theme_str='candystriptease'; _root.wetbio.view.clean(); _root.wetbio.view.setup();	};
			cmi = new ContextMenuItem("Set theme to candystriptease", f )
			cm.customItems.push(cmi);
			f=function()	{	_root.wetbio.view.opts.theme_str='minimono'; _root.wetbio.view.clean(); _root.wetbio.view.setup();	};
			cmi = new ContextMenuItem("Set theme to minimono", f )
			cm.customItems.push(cmi);
			f=function()	{	_root.wetbio.view.opts.theme_str='luluinthesky'; _root.wetbio.view.clean(); _root.wetbio.view.setup();	};
			cmi = new ContextMenuItem("Set theme to luluinthesky", f )
			cm.customItems.push(cmi);
			_root.menu=cm;
		}

		mcm.style=styles.mask;
		gfx.draw_box(mcm,undefined,0,0,600,200)

		opts.setup();
		curve.setup();
		about.setup();
// setup click handler
		_root[_root.click_name]=delegate(click_id);
	}

	function click_id(id:String)
	{
		var a:Array;
		
		a=id.split('_');
		
		switch(a[0])
		{
			case "options":
				dest_x=600;
			break;

			case "about":
				dest_x=-600;
			break;
			
			case "view":
				dest_x=0;
			break;
			
			case "save":
				opts.go_set_data();
			break;
		}
		
		if(wetbio.state_next!=WetBio.STATE_NONE)
		{
			_root[_root.click_name]=null;
		}
	}
	
// every frame while in this state	
	function update()
	{
		if( ((mc._x-dest_x)*(mc._x-dest_x)) < 1 ) { mc._x=dest_x; } // final snap
		else { mc._x=mc._x + ((dest_x-mc._x)/4); } // speed tween
	
// retarded click box problem crap fix...
		if(mc._x==600)
		{
			opts.mc._visible=true;
			curve.mc._visible=false;
			about.mc._visible=false;
		}
		else
		if(mc._x==0)
		{
			opts.mc._visible=false;
			curve.mc._visible=true;
			about.mc._visible=false;
		}
		else
		if(mc._x==-600)
		{
			opts.mc._visible=false;
			curve.mc._visible=false;
			about.mc._visible=true;
		}
		else // tweening, show everything
		{
			opts.mc._visible=true;
			curve.mc._visible=true;
			about.mc._visible=true;
		}
		
		opts.update();
		curve.update();
		about.update();
	}

// on leaving this state
	function clean()
	{
		opts.clean();
		curve.clean();
		about.clean();
		mc._visible=false;
	}
}