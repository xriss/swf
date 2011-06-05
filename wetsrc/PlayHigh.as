/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) http://www.WetGenes.com/ 2009
//
/*+-----------------------------------------------------------------------------------------------------------------+*/

#include "src/opts.as"

// lets handle some scores

class PlayHigh
{
	var mcb;
	var mc;
	
	var mcs;
	var tfs;
	var mc_res;
	var mc_top;
	var tf_top;
	var mc_topunder;
	var tf_topunder;
	var mc_topsub;
	var tf_topsub;
	var mc_text;
	var tf_text;
	var mc_whore;
	
	var up; // Play
	
	var stars;
	
	var do_exit;
	var not_do_exit;
	var done;
	var steady;

	var php;
	
	var rank;
	var high;
	var last;
	
	var update_do;
	
	var icon_nams=["mochi","day","rank","last","guest","registered","close"];
		
	var retry;
	
	var do_mochi;
	
	var results="";
	
	var finished=true;
	
	function delegate(f,d)	{	return com.dynamicflash.utils.Delegate.create(this,f,d);	}
	
	var state;

// hoe to filter
	var filter;
	
	var play;

var str_numst:Array=[
'1st','2nd','3rd','4th','5th','6th','7th','8th','9th','10th'];


var hide_last=false;
var show_hash=false;

	function PlayHigh(_up,stropts)
	{
	var i;
	var aa;
	
		up=_up;
		
		play=up.play;

		hide_last=false;
		show_hash=false;
	
		if(stropts)
		{
		var aaopts;
		var opt;
	
			aaopts=stropts.split(",");
			for(i=0; i<aaopts.length ; i++ )
			{
				aa=aaopts[i].split("=");
				switch(aa[0])
				{
					case "show_hash":
						show_hash=true;
					break;
					case "hide_last":
						hide_last=true;
					break;
					case "results":
						results=aa[1];
					break;
				}
			}
		}
				
		rank=new_reset_scores();
		high=new_reset_scores();
		last=new_reset_scores();
		
		state="high";
		filter="global";
		
		if(up.high_state)  { state =up.high_state; }
		if(up.high_filter) { filter=up.high_filter; }
		
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
	
	function days_to_string(days)
	{
		var d;
		var s;
		
		if(show_hash) { return "#"+days; } // special date mode that isnt really a date
		
		d=new Date();
		d.setTime(days*24*60*60*1000);
		
		s=alt.Sprintf.format("%04d%02d%02d",d.getFullYear(),d.getMonth()+1,d.getDate());
		
		return s;
	}

	function setup(usestate)
	{
	var i;
	var bounds;
	var mct;
	
		
		if(_root.skip_wetlogin) { return; }
		if(!finished) { return; } // lets not setup twice
		finished=false;
		
		state="done";
		
			
		retry=false;
	
		if(_root.signals.ranksys=="max") // always remove last state for max ranksystems...
		{
			hide_last=true;
		}
	
		if( ( state!="high" ) && (state!="rank") && (state!="last") )
		{
			state="high";
		}
		
		if(hide_last || show_hash)
		{
			if(state=="last")
			{
				state="high";
			}
		}
		if(show_hash)
		{
			if(state=="rank")
			{
				state="high";
			}
		}
		
		if(usestate)
		{
			state=usestate;
		}
		
		
//		up.dikecomms.send_score_check();

//		show_ranks=false;
		
		_root.popup=this;
		
		mcs=new Array();
		tfs=new Array();
			
		mcb=gfx.create_clip(_root.mc_popup,null);
		if( _root.scalar.oy==600 ) // our size
		{
			mc=mcb;
		}
		else
		{
			mcb._xscale=Math.floor(100 * (_root.scalar.oy/600));
			mcb._yscale=Math.floor(100 * (_root.scalar.oy/600));
			mc=gfx.create_clip(mcb,null);
		}
		mcb.cacheAsBitmap=true;
		
		gfx.dropshadow(mc,5, 45, 0x000000, 1, 20, 20, 2, 3);
//	    mc.filters = [ new flash.filters.DropShadowFilter(5, 45, 0x000000, 1, 20, 20, 2, 3) ];
		
//		mc.onRelease=delegate(onRelease,null);
		
		mc._y=0;
		
		mc.dx=0;
		mc._x=-800;
		
		
		
		do_exit=false;
		not_do_exit=30; // wait a bit before alowing exit
		done=false;
		steady=false;



//		var i;
		var s;
		var tfi;
		var a:Array;
		
		
		do_mochi=false;
		
		gfx.clear(mc);
		
/*
		switch(state)
		{
			case "none":
			break;

			default:
			case "scores":
*/			
				mc.style.out=0xff000000;
				mc.style.fill=0x50000000;
				gfx.draw_box(mc,0,100+16,0+16,600-32,600-32);
				
/*
				mcs[0]=gfx.add_clip(mc,'scoreback',null);
				mcs[0].gotoAndStop(2);
				mcs[0]._x=0;
				mcs[0]._y=0;
*/
/*
			break;
		}
*/		
		switch(state)
		{
			case "results": // display results page
			
				mc_top=gfx.create_clip(mc,null,100,25);
				tf_top=gfx.create_text_html(mc_top,null,0,0,600,50);
				mc_top.onRelease=delegate(click,"top");
/*
				mc_topunder=gfx.create_clip(mc,null,100,75-10);
				tf_topunder=gfx.create_text_html(mc_topunder,null,0,0,600,25);
				mc_topunder.onRelease=delegate(click,"topunder");
				
				mc_topsub=gfx.create_clip(mc,null,100,100);
				tf_topsub=gfx.create_text_html(mc_topsub,null,0,0,600,75);
				mc_topsub.onRelease=delegate(click,"topsub");
*/			

				mc_text=gfx.create_clip(mc,null,150,100);
				tf_text=gfx.create_text_html(mc_text,null,0,0,500,300);
				mc_text.onRelease=delegate(click,"text");
				
				mc_whore=gfx.create_clip(mc,null,200,425);
				mc_whore.onRelease=delegate(click,"whore");
				mc_whore.text=gfx.create_text_html(mc_whore,null,175,0,250,175);
				
			break;
			
			
			default:
		
				mc_res=gfx.create_clip(mc,null);
				tfi=0;
				for(i=0;i<10;i++)
				{
					mcs[i]=gfx.create_clip(mc_res,null,0,25+150+i*40);
					
					mcs[i].onRelease=delegate(click,"score"+i);
					mcs[i].onRollOver=delegate(over_on,"score"+i);
					mcs[i].onRollOut=delegate(over_off,"score"+i);
					mcs[i].onReleaseOutside=delegate(over_off,"score"+i);

					tfs[tfi]=gfx.create_text_html(mcs[i],null,50,0,200,50);
					tfi++;
					tfs[tfi]=gfx.create_text_html(mcs[i],null,250,0,150,50);
					tfi++;
					tfs[tfi]=gfx.create_text_html(mcs[i],null,400,0,550,50);
					tfi++;
				}
				
				mc_top=gfx.create_clip(mc,null,100,25);
				tf_top=gfx.create_text_html(mc_top,null,0,0,600,50);
				mc_top.onRelease=delegate(click,"top");

				mc_topunder=gfx.create_clip(mc,null,100,75-10);
				tf_topunder=gfx.create_text_html(mc_topunder,null,0,0,600,25);
				mc_topunder.onRelease=delegate(click,"topunder");
				
				mc_topsub=gfx.create_clip(mc,null,100,100);
//				tf_topsub=gfx.create_text_html(mc_topsub,null,0,0,600,75);
//				mc_topsub.onRelease=delegate(click,"topsub");

			break;
		}
		
		for(i=0;i<icon_nams.length;i++)
		{
			var nam=icon_nams[i];
			mc_topsub[nam]=gfx.add_clip(mc_topsub,"icon_"+nam,null,(300-(20*icon_nams.length))+i*40,10,200,200);
			gfx.glow(mc_topsub[nam] , 0xffffff, 1, 8, 8, 1, 1, false, false );
			mc_topsub[nam]._alpha=50;
			mc_topsub[nam].id=nam;
			mc_topsub[nam].idx=i;
			mc_topsub[i]=mc_topsub[nam];
			
			mc_topsub[i].onRelease=delegate(click,nam);
			mc_topsub[i].onRollOver=delegate(over_on,nam);
			mc_topsub[i].onRollOut=delegate(over_off,nam);
			mc_topsub[i].onReleaseOutside=delegate(over_off,nam);
		}
#if not VERSION_MOCHISCORES then
			mc_topsub["mochi"]._visible=false;;
#end
		if(hide_last)
		{
			mc_topsub["last"]._visible=false;;
		}
		if(show_hash)
		{
			mc_topsub["last"]._visible=false;;
			mc_topsub["rank"]._visible=false;;
			mc_topsub["day"]._visible =false;;
		}
		
		
		thunk();
		get_high();
		
			

//		_root[_root.click_name]=delegate(click_str);
		
//		up.dikecomms.get_high();
		
//		Mouse.addListener(this);
		
		update_do=delegate(update,null);
		MainStatic.update_add(_root.updates,update_do);
		_root.poker.clear_clicks();
	}
	
	function clean()
	{
		if(_root.popup != this)
		{
			return;
		}
		
		finished=true;
		
		mc_whore=null;
		
		MainStatic.update_remove(_root.updates,update_do);
		update_do=null;
		
				
//		Mouse.removeListener(this);
		
//		up.up.do_str("won");
		
		mcb.removeMovieClip();
		mc.removeMovieClip();
		
		_root.popup=null;
		
		if(up.next_game_seed)
		{
			up.do_str("restart");
		}

// remember last state/filter		

		up.high_state=state;
		up.high_filter=filter;
		
		_root.poker.clear_clicks();
		
		state="done";
	}
	
	
/*	
	function onRelease()
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
*/
	
var high_id=0;

	function get_high()
	{
//dbg.print("+playget_high");

		if(state=="rank")
		{
			rank=new_reset_scores();
		}
		else
		if(state=="high")
		{
			high=new_reset_scores();
		}
		else
		if(state=="last")
		{
			last=new_reset_scores();
		}
		else
		{
			return;
		}

		high_id++;
		
		_root.comms.get_high(state,filter,delegate(got_high,high_id));
	}
	
	function got_high(a,tid)
	{
//dbg.print("+playgot_high");

		if(tid==high_id) // only act on most recent request
		{
			if(state=="rank")
			{
				rank=a;
			}
			else
			if(state=="high")
			{
				high=a;
			}
			else
			if(state=="last")
			{
				last=a;
			}
		
			thunk();
		}
	}
	
	function thunk()
	{
	var i;
	var a;
	var s;
	var tfi;
	
	
	for(i=0;i<icon_nams.length;i++)
	{
		mc_topsub[i]._alpha=50;
	}
	
	
		if( (state=="rank") || (state=="high") || (state=="last") )
		{
		
			tfi=0;
			
			for(i=0;i<10;i++)
			{
				if(state=="rank")
				{
					a=rank[i].split(';');
				}
				else
				if(state=="high")
				{
					a=high[i].split(';');
				}
				else
				if(state=="last")
				{
					a=last[i].split(';');
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

				if(state=="last")
				{
					s="";
					s+="<font face=\"Bitstream Vera Sans\" size=\"8\" color=\"#ffffff\">";
					s+="<br></font>";
					s+="<font face=\"Bitstream Vera Sans\" size=\"16\" color=\"#ffffff\">";
					s+="<p align=\"center\"><b>";
					if(a[2])
					{
						s+=days_to_string(a[2]);
					}
					else
					{
						s+="#";
					}
					s+="</b></p>";
					s+="</font>";
					tfs[tfi].htmlText=s;
				}
				else
				{
					s="";
					s+="<font face=\"Bitstream Vera Sans\" size=\"28\" color=\"#ffffff\">";
					s+="<p align=\"center\"><b>";
					s+=str_numst[i];
					s+="</b></p>";
					s+="</font>";
					tfs[tfi].htmlText=s;
				}

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

			s="";
			s+="<font face=\"Bitstream Vera Sans\" size=\"14\" color=\"#888888\">";
			s+="<p align=\"center\"><b>";
			switch(state)
			{
				case "rank":
					s+="Click title above to cycle views<br>";
					s+="Click here to cycle filters<br>";
					s+="Click anywhere else to exit<br>";
					
					mc_topsub["rank"]._alpha=100;
				break;
				
				case "high":
					s+="Click title above to cycle views<br>";
					s+="Click here to cycle filters<br>";
					s+="Click anywhere else to exit<br>";
					
					mc_topsub["day"]._alpha=100;
				break;
				
				case "last":
					s+="Click title above to cycle view<br>";
					s+="Click a score below to play that game<br>";
					s+="Click anywhere else to exit<br>";
					
					mc_topsub["last"]._alpha=100;
				break;
				case "mochi":
					mc_topsub["mochi"]._alpha=100;
				break;
			}
			s+="</b></p>";
			s+="</font>";
			tf_topsub.htmlText=s;
				
			s="";
			s+="<font face=\"Bitstream Vera Sans\" size=\"16\" color=\"#cccccc\">";
			s+="<p align=\"center\"><b>";
			switch(state)
			{
				case "rank":
				case "high":
					switch(filter)
					{
						case "global" : 	
							s+="no filter";						
							mc_topsub["guest"]._alpha=100;
						break;
						case "registered" : 
							s+="showing registered users only";	
							mc_topsub["registered"]._alpha=100;
						break;
						case "friends" :	
							s+="showing friends only";			
						break;
					}				
				break;
				
				case "last":
				break;
			}
			s+="</b></p>";
			s+="</font>";
			tf_topunder.htmlText=s;
		}
		else
		if(state=="mochi")
		{
		
#if VERSION_MOCHISCORES then

			if(!do_mochi)
			{
				do_mochi=true;
				mochi.MochiScores.showLeaderboard({res:"540x450",onClose:delegate(mochi_close)});
				mc_res._visible=false;
//				mc_top._visible=false;
				mc_topunder._visible=false;
				mc_topsub._visible=false;
				_root.poker.ShowFloat(null,0);
			}
#end
		}
		else
		if(state=="results")
		{
			switch(results)
			{
				case "bowwow":
					s="";
					s+="<font face=\"Bitstream Vera Sans\" size=\"26\" color=\"#ffffff\">";
					s+="<p align=\"center\">";
					
					s+="You scored <b>"+(play.score)+"</b>pts<br><br>";
													
					s+="<b>Click here</b> or press anykey to continue.<br><br>";
					
					s+="</p>";
					s+="</font>";
					tf_text.htmlText=s;
				break;
				
				default:
					s="";
					s+="<font face=\"Bitstream Vera Sans\" size=\"28\" color=\"#ffffff\">";
					s+="<p align=\"center\">";
					
					s+="<b>Click here</b> to return to the menu or press anykey to try again.<br><br>";
					
					s+="You scored <b>"+(play.scores_best_new)+"</b>pts<br><br>";
					
					if( play.scores_best_old < play.scores_best_new )
					{
						s+="Congratulations, that's a whole <b>"+(play.scores_best_new-play.scores_best_old)+"</b>pts better than "+(play.scores_best_old)+"pts.<br><br>";
					}
					else
					{
						s+="Your previous best score was <b>"+(play.scores_best_old)+"</b>pts<br><br>";
					}
								
					s+="</p>";
					s+="</font>";
					tf_text.htmlText=s;
				break;
			}
		}
		
		s="";
		s+="<font face=\"Bitstream Vera Sans\" size=\"28\" color=\"#ffffff\">";
		s+="<p align=\"center\"><b>";
		switch(state)
		{
			case "rank":
				if(_root.signals.ranksys=="max")
				{
					s+="Highest scores in last 10 days.<br>";
				}
				else
				{
					s+="Rankings, last 10 days added.<br>";
				}
			break;
			
			case "high":
				s+="High scores for "+days_to_string(up.game_seed)+".<br>";
			break;
			
			case "last":
				s+="Your last 10 scores.<br>";
			break;
			
			case "results":
				s+="Congratulations!<br>";
			break;
			
			case "mochi":
				s+="Checking Mochi Bucket for scores.<br>";
			break;
		}
		s+="</b></p>";
		s+="</font>";
		tf_top.htmlText=s;
		
	}
	
	function mochi_close()
	{
		do_mochi=false;
		state="high";
		get_high();
		thunk();
		not_do_exit=5;
		mc_res._visible=true;
		mc_top._visible=true;
		mc_topunder._visible=true;
		mc_topsub._visible=true;
	}
	
	function over_on(s)
	{
	if(do_mochi) { return; }
	
		switch(s)
		{
			case "score0": showgame(0); break;
			case "score1": showgame(1); break;
			case "score2": showgame(2); break;
			case "score3": showgame(3); break;
			case "score4": showgame(4); break;
			case "score5": showgame(5); break;
			case "score6": showgame(6); break;
			case "score7": showgame(7); break;
			case "score8": showgame(8); break;
			case "score9": showgame(9); break;
			
			case "day":
				_root.poker.ShowFloat("Show scores for todays game.",25*5);
				highlight_icon(s,true);
			break;
			case "rank":
				_root.poker.ShowFloat("Show rank. This is built using scores from the last 10 days.",25*5);
				highlight_icon(s,true);
			break;
			case "last":
				_root.poker.ShowFloat("Your score each day for the last 10 days. Play these games again to improve your rank.",25*5);
				highlight_icon(s,true);
			break;
			case "guest":
				_root.poker.ShowFloat("Show scores of all players.",25*5);
				highlight_icon(s,true);
			break;
			case "registered":
				_root.poker.ShowFloat("Show registered players scores only.",25*5);
				highlight_icon(s,true);
			break;
			case "mochi":
				_root.poker.ShowFloat("Display a Mochi Bucket of scores.",25*5);
				highlight_icon(s,true);
			break;
			case "close":
				_root.poker.ShowFloat("Close this plopup. Clicking almost anywhere also closes this plopup.",25*5);
				highlight_icon(s,true);
			break;
			
		}
	}
	
	function highlight_icon(nam,onoff)
	{
		if(mc_topsub[nam]._alpha<100)
		{
			if(onoff)
			{
				mc_topsub[nam]._alpha=75;
			}
			else
			{
				mc_topsub[nam]._alpha=50;
			}
		}
	}
	
	function over_off(s)
	{
	if(do_mochi) { return; }
		highlight_icon(s,false);
		_root.poker.ShowFloat(null,0);
	}
	
	function click(s)
	{
	if(do_mochi) { mochi_close(); return; }
	
//	dbg.print(s);
		switch(s)
		{
			case "whore":
			
				if(_root.wonderfulls[0].url)
				{
					getURL(_root.wonderfulls[0].url,"_blank");
				}
				
				if(state=="results") // return to menu when you click on an ad
				{
					if(steady)
					{
						do_exit=true;
					}
				}
				
			break;

			case "text":
			
				if(state=="results")
				{
					if(steady)
					{
						do_exit=true;
					}
				}
				
			break;
			
			case "top":
//				statechange();
//				not_do_exit=5;
			break;
			
			case "mochi":
				if(state!="mochi")
				{
					state="mochi";
					thunk();
				}
				not_do_exit=5;
			break;
			
			case "day":
				if(state!="high")
				{
					state="high";
					get_high();
					thunk();
				}
				not_do_exit=5;
			break;
			case "rank":
				if(state!="rank")
				{
					state="rank";
					get_high();
					thunk();
				}
				not_do_exit=5;
			break;
			case "last":
				if(state!="last")
				{
					state="last";
					get_high();
					thunk();
				}
				not_do_exit=5;
			break;
			case "guest":
				if(filter!="global")
				{
					filter="global";
					get_high();
					thunk();
				}
				not_do_exit=5;
			break;
			case "registered":
				if(filter!="registered")
				{
					filter="registered";
					get_high();
					thunk();
				}
				not_do_exit=5;
			break;
			
			case "topunder":
//				if(state!="last")
//				{
//					filterchange();
//					not_do_exit=5;
//				}
			break;
			
			case "topsub":
//				if(state!="last")
//				{
//					filterchange();
//					not_do_exit=5;
//				}
			break;
			
			case "score0": gotoplaygame(0); break;
			case "score1": gotoplaygame(1); break;
			case "score2": gotoplaygame(2); break;
			case "score3": gotoplaygame(3); break;
			case "score4": gotoplaygame(4); break;
			case "score5": gotoplaygame(5); break;
			case "score6": gotoplaygame(6); break;
			case "score7": gotoplaygame(7); break;
			case "score8": gotoplaygame(8); break;
			case "score9": gotoplaygame(9); break;
			
			break;
		}
	}
	
	function gotoplaygame(num)
	{
	var a;
		if(state=="last")
		{
			a=last[num].split(';');
			if(a[2])
			{
				up.next_game_seed=Math.floor(a[2]);
				
				if(up.next_game_seed == up.game_seed)
				{
					up.next_game_seed=null; // no change
				}
//				else
//				{
//					up.skip_high=true;
//				}
			}

// display normal high scores list next time			

			state="high";

		}
	}
	function showgame(num)
	{
	var a;
		if(state=="last")
		{
			a=last[num].split(';');
			if(a[2])
			{
				var day=days_to_string(Math.floor(a[2]));				
				
				_root.poker.ShowFloat("Clicking here will end this game and start the game for "+day+" so be careful...",25*5);
			}
		}
	}
	
	function statechange()
	{
		switch(state)
		{
			case "results" : break;
			
			case "high" : state="rank"; break;
			
			case "rank" :
				if(hide_last||show_hash)
				{
					state="high";
				}
				else
				{
					state="last";
				}
			break;
			
			case "last" : state="high"; break;
			
			default :  state="high"; break;
		}
		
		get_high();
		thunk();
	}
	
	function filterchange()
	{
		switch(filter)
		{
			case "global" : 	filter="registered"; break;
			case "registered" : filter="global"; 	break;
			case "friends" :	filter="global"; 	break;
		}
		
		get_high();
		thunk();
	}
	

/*
	function onMouseUp()
	{
		if(_root.popup != this)
		{
			return;
		}

		if(steady)
		{
			do_exit=true;
		}
	}
*/

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
	var s;
	
	var mouse_over=(mc._xmouse>0)&&(mc._ymouse>0)&&(mc._xmouse<800)&&(mc._ymouse<600);
	
		
	
		if(!do_mochi)
		{
			if((_root.popup == this)&&((_root.poker.anykey&&mouse_over)))
			{
				if(steady)
				{
					if(!do_exit)
					{
						if(state=="results")
						{
							retry=true;
						}
						do_exit=true;
					}
				}
			}
		}
		
		if( (_root.popup != this) || (_root.pause) )
		{
			return;
		}

// load on an ad?
		if(mc_whore)
		{
			if(!mc_whore.ad) // check if we have loaded an ad
			{
				if(_root.wonderfulls) // check if we know what ad to load
				{
					mc_whore.ad=gfx.create_clip(mc_whore, null);
					mc_whore.ad.loadMovie(_root.wonderfulls[0].img);

					s="";
					s+="<font face=\"Bitstream Vera Sans\" size=\"24\" color=\"#ffffff\">";
					s+="<p align=\"center\">";
					s+=_root.wonderfulls[0].txt;
					s+="</p>";
					s+="</font>";
					mc_whore.text.htmlText=s;
				}
			}
		}
/*
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
*/
		
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
		
		if(do_exit && not_do_exit==0)
		{
			done=true;
			mc.dx=_root.scalar.ox;
		}
		do_exit=false;
		if(not_do_exit>0)
		{
			not_do_exit--;
		}
	}
		
	

}
