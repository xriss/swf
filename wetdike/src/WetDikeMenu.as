/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) Kriss Daniels 2006 http://www.XIXs.com
//
/*+-----------------------------------------------------------------------------------------------------------------+*/

#include "src/opts.as"



class WetDikeMenu
{
	var mc;
	var up;
	
	var fmt;
	var fmts;

	var mcopt;
	var mcopts;
	
	
	function WetDikeMenu(_up)
	{
		up=_up;
	}

	function setup()
	{
		var s;
		var i;
				
		mc=gfx.create_clip(up.mc,null);
		mc.cacheAsBitmap=true;
		
		fmt=new TextFormat();
		fmt.font="Bitstream Vera Sans";
		fmt.size=26;
		fmt.color=0x00ffffff;
		fmt.bold=false;
		
		fmts=new TextFormat();
		fmts.font="Bitstream Vera Sans";
		fmts.size=17;
		fmts.color=0x00ffffff;
		fmts.bold=false;

		
		mcopt=gfx.create_clip(mc,null);
		mcopt._y=545;
		
		var ns=
		[
			"",
			"pix_back",
			"menu",
			"logoff",
			"restart",
			"shuffle",
			"scores",
			"stats",
			"str_login",
			"str_packcode",
			"about",
			""
		];
		
		mcopts=new Array();
		
		mcopts[0]=gfx.add_clip(mcopt,'table2',null);
		mcopts[0].active=false;
			
		for(i=1;i<=10;i++)
		{
			mcopts[i]=gfx.add_clip(mcopt,'table3',null);
			mcopts[i].gotoAndStop(i);
			mcopts[i].active=true;
			
			if(ns[i].substring(0,4)=="str_")
			{
			var box;
			var tf;
			
				box=mcopts[i].getBounds(mcopt);
			
//				dbg.print("xMin="+box.xMin);
//				dbg.print("yMin="+box.yMin);
//				dbg.print("xMax="+box.xMax);
//				dbg.print("yMax="+box.yMax);
			
				tf=gfx.create_text_edit(mcopt,null,box.xMin,box.yMin,box.xMax-box.xMin,box.yMax-box.yMin);
//				tf.onKillFocus=delegate(onKillFocus,tf);

				mcopts[i].active=false;
				
				tf.setNewTextFormat(fmt);
				tf.text="testing";
				
				mcopts[i].removeMovieClip();
				mcopts[i]=tf;
				
			}
			
			mcopts[i].id=ns[i];
			mcopts[ns[i]]=mcopts[i]; // swing both ways?
		}
		
		mcopts["pix_back"].active=false;
		mcopts["str_login"].active=false;
		mcopts["str_packcode"].active=false;
		
		mcopts["pix_back"]._visible=false;
//		mcopts["str_login"]._visible=false;
//		mcopts["str_packcode"]._visible=false;

		fmt.align="center";
		fmts.align="center";
		mcopts["str_login"].setNewTextFormat(fmt);		
		mcopts["str_packcode"].setNewTextFormat(fmts);		
		fmt.align=null;
		fmts.align=null;


// make non editable for now
		mcopts["str_login"].type="dynamic";
		mcopts["str_packcode"].type="dynamic";

		
//		dbg.print(mcopts.length);
				

//		mcopts["scores"]._visible=false;
//		mcopts["stats"]._visible=false;

if(_root.lardguns!=null) // if playing for lardguns
{
	mcopts["shuffle"].active=false;
	mcopts["shuffle"]._visible=false;
}
		
		Mouse.addListener(this);
	}
	
	function thunk()
	{
		
		mcopts["str_login"].text=_root.Login_Name;
		
/*
		if(up.up.dikecomms.pack_seed!=null)
		{
			mcopts["str_packcode"].text="#"+up.up.dikecomms.pack_seed;
		}
		else
		{
			mcopts["str_packcode"].text=up.up.dikecomms.pack_code;
		}
*/
		
		mcopts["str_packcode"].text=days_to_string(_root.comms.datas.seed);
	}

	function clean()
	{
		Mouse.removeListener(this);
		mc.removeMovieClip();
	}
	
	
	function days_to_string(days)
	{
		var d;
		var s;
		
		d=new Date();
		d.setTime(days*24*60*60*1000);
		
		s=alt.Sprintf.format("%04d%02d%02d",d.getFullYear(),d.getMonth()+1,d.getDate());
		
		return s;
	}
	
	function click_button_layers(tab)
	{
	var i;
		
		for(i=1;i<tab.length;i++)
		{
			if(tab[i].active)
			{
				if(tab[i].hitTest(_root._xmouse,_root._ymouse,false))
				{
					do_str(tab[i].id);
				}
			}
		}
	
	}

	function update_button_layers(tab)
	{
	var i;
		for(i=1;i<tab.length;i++)
		{
			if(tab[i].active)
			{
				if(tab[i].hitTest(_root._xmouse,_root._ymouse,false))
				{
					tab[i]._alpha=100;
				}
				else
				{
					if(tab[i]._alpha>60)
					{
						tab[i]._alpha-=5;
					}
				}
			}
		}
		
	}
	
	function do_str(str)
	{
		switch(str)
		{
			default:
				up.do_str(str)
			break;
			
			case "about":
			
				up.up.dikeabout.setup();
				
			break;
			
			case "scores":
			
				up.up.play.show_scores();
//				up.up.dikescores.setup();
				
			break;
			
			case "stats":
			
//				up.up.dikestats.setup();

				
			break;
			
			case "menu":
			
				if(up.state=="play")
				{
					up.mc.dy=-545;
					up.state="menu";
				}
				else
				if(up.state=="menu")
				{
					up.mc.dy=0;
					up.state="play";
				}
				
// check to send score on menu open/close clicks				

				up.up.dikecomms.send_score_check();
				
			break;			
		}
	}		
	
	function onMouseDown()
	{
		if(_root.popup)
		{
			return;
		}
		
		click_button_layers(mcopts);
	}
		
	function update()
	{
		if(_root.popup)
		{
			return;
		}
		
		update_button_layers(mcopts);		
	}


}
