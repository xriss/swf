/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) Kriss Daniels 2006 http://www.XIXs.com
//
/*+-----------------------------------------------------------------------------------------------------------------+*/

#include "src/opts.as"

// lets handle some scores

class WetDikeScores
{
	var mc;
	var mcs;
	var tfs;
	var tf_top;
	
	var up; // WetDikePlay
	
	var stars;
	
	var done;
	var steady;

	var php;
	
	var high;
	var rank;
	
	var show_ranks;
	
	function delegate(f,d)	{	return com.dynamicflash.utils.Delegate.create(this,f,d);	}
	

// state to use, set before changing master state to this
	var state;


var str_numst:Array=['1st','2nd','3rd','4th','5th','6th','7th','8th','9th','10th'];



	function WetDikeScores(_up)
	{
		up=_up;

		high=new_reset_scores();
		rank=new_reset_scores();
		
//		up.dikecomms.get_high();
	}
	
	function new_reset_scores()
	{
		var a:Array=new Array();
		
		for(var i=0;i<10;i++)
		{
			a[i]="0;Fetching...";
		}
		return a;
	}
	

	function setup()
	{
	var i;
	var bounds;
	var mct;
	
		up.dikecomms.send_score_check();

		show_ranks=false;
		
		_root.popup=this;
		
		mcs=new Array();
		tfs=new Array();
			
		mc=gfx.create_clip(_root.mc_popup,null);
		mc.cacheAsBitmap=true;
	    mc.filters = [ new flash.filters.DropShadowFilter(5, 45, 0x000000, 1, 20, 20, 2, 3) ];
		
		mc._y=0;
		
		mc.dx=0;
		mc._x=-800;
/*				
		for(i=1;i<=2+16+5;i++)
		{
			mcs[i]=gfx.add_clip(mc,'won',null);
			mcs[i].gotoAndStop(i+1);
			
			if( (i>=2) && (i<=2+16) )
			{
				bounds = mcs[i].getBounds(mc);
				
				bounds.x=(bounds.xMin+bounds.xMax)/2;
				bounds.y=(bounds.yMin+bounds.yMax)/2;

				mcs[i].removeMovieClip();
				mcs[i]=gfx.create_clip(mc,null);
			
				mcs[i]._x=bounds.x;
				mcs[i]._y=bounds.y;
				
				mcs[i].ox=bounds.x;
				mcs[i].oy=bounds.y;
				
				mct=gfx.add_clip(mcs[i],'won',null);
				mct.gotoAndStop(i+1);
				mct._x=-bounds.x;
				mct._y=-bounds.y;
			}
		}
*/		
		mc.onEnterFrame=delegate(update,null);

		done=false;
		steady=false;



//		var i;
		var s;
		var tfi;
		var a:Array;
		
		
		mc.style=new Array();

		switch(state)
		{
			case "none":
			break;

			default:
			case "scores":
			
				mc.style.out=0xffffffff;
				mc.style.fill=0xc0ffffff;
//				gfx.draw_box(mc,0,100+16,0+16,600-32,600-32);
				
				mcs[0]=gfx.add_clip(mc,'scoreback',null);
				mcs[0].gotoAndStop(2);
				mcs[0]._x=0;
				mcs[0]._y=0;

			break;
		}
		
		tfi=0;
		for(i=0;i<10;i++)
		{
			tfs[tfi]=gfx.create_text_html(mc,null,50,150+i*40,200,50);
			tfi++;
			tfs[tfi]=gfx.create_text_html(mc,null,250,150+i*40,150,50);
			tfi++;
			tfs[tfi]=gfx.create_text_html(mc,null,400,150+i*40,550,50);
			tfi++;
		}
		
		tf_top=gfx.create_text_html(mc,null,100,50,600,200);
		
		thunk();

		_root[_root.click_name]=delegate(click_str);
		
		up.dikecomms.get_high();
		
		Mouse.addListener(this);
	}
	
	
	function thunk()
	{
	var i;
	var a;
	var s;
	var tfi;
	
		tfi=0;
		
		for(i=0;i<10;i++)
		{
			if(show_ranks)
			{
				a=rank[i].split(';');
			}
			else
			{
				a=high[i].split(';');
			}

// replace _ in names with spaces for display			
			if(a[1].indexOf('_')!=-1)
			{
				a[1]=(a[1].split('_')).join(' ');
			}
						
			s="";
			s+="<font face=\"Bitstream Vera Sans\" size=\"28\" color=\"#ffffff\">";
			s+="<p align=\"right\"><b>";
//					s+="<a href=\"asfunction:_root."+_root.click_name+",none\"><b>";
			s+=a[0];
//					s+="</b></a>";
			s+="</b></p>";
			s+="</font>";
//			tfs[tfi]=gfx.create_text_html(mc,null,50,150+i*40,200,50);
			tfs[tfi].htmlText=s;
			
			tfi++;

			s="";
			s+="<font face=\"Bitstream Vera Sans\" size=\"28\" color=\"#ffffff\">";
			s+="<p align=\"center\"><b>";
			s+=str_numst[i];
			s+="</b></p>";
			s+="</font>";
//			tfs[tfi]=gfx.create_text_html(mc,null,250,150+i*40,150,50);
			tfs[tfi].htmlText=s;

			tfi++;

			s="";
			s+="<font face=\"Bitstream Vera Sans\" size=\"28\" color=\"#ffffff\">";
			s+="<p align=\"left\"><b>";
//					s+="<a href=\"asfunction:_root."+_root.click_name+",none\"><b>";
			s+=a[1];
//					s+="</b></a>";
			s+="</b></p>";
			s+="</font>";
//			tfs[tfi]=gfx.create_text_html(mc,null,400,150+i*40,550,50);
			tfs[tfi].htmlText=s;

			tfi++;
			
		}

		if(show_ranks)
		{
			s="";
			s+="<font face=\"Bitstream Vera Sans\" size=\"28\" color=\"#ffffff\">";
			s+="<p align=\"center\"><b>";
			s+="GLOBAL RANKS<br>";
			s+="Click anywhere to exit!";
			s+="</b></p>";
			s+="</font>";
			tf_top.htmlText=s;

			tfi++;
		}
		else
		{
			s="";
			s+="<font face=\"Bitstream Vera Sans\" size=\"28\" color=\"#ffffff\">";
			s+="<p align=\"center\"><b>";
			if(up.dikecomms.pack_seed!=null)
			{
				s+="High scores for pack #"+up.dikecomms.pack_seed+"<br>";
			}
			else
			{
				s+="High scores for the current pack<br>";
			}
			s+="Click anywhere to exit!";
			s+="</b></p>";
			s+="</font>";
			tf_top.htmlText=s;

			tfi++;
		}
	}
	
	function clean()
	{
		if(_root.popup != this)
		{
			return;
		}
				
//		up.up.do_str("won");
		
		mc.removeMovieClip();
		
		_root.popup=null;
		
		Mouse.removeListener(this);
	}

	function onMouseDown()
	{
		if(_root.popup != this)
		{
			return;
		}

		if(steady)
		{
			done=true;
			mc.dx=800;
		}
	}

	function click_str(id:String)
	{
		var a:Array;
		
		a=id.split('_');
		
		trace(a);
		
		switch(a[0])
		{
			case "none":
			break;
			case "submit":
			break;
			break;
		}
	}


	function update()
	{
	
		if(_root.popup != this)
		{
			return;
		}
		
		if(mc._xmouse<400)
		{
			if(show_ranks==true)
			{
				show_ranks=false;
				thunk();
			}
		}
		else
		{
			if(show_ranks==false)
			{
				show_ranks=true;
				thunk();
			}
		}
		
		mc._x+=(mc.dx-mc._x)/4;

		if( (mc._x-mc.dx)*(mc._x-mc.dx) < (16*16) )
		{
			steady=true;
			if(done)
			{
				clean();
			}
		}
		else
		{
			steady=false;
		}
	}
		
	

}
