/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) Kriss Daniels 2007 http://www.XIXs.com
//
/*+-----------------------------------------------------------------------------------------------------------------+*/

#include "src/opts.as"


class PlayField
{
	var up;
	
	var mc_scalar;
	var mc;
	
	var tab_w;
	var tab_h;
	var tab;
	
	var types;
	
	var focus;
	
	var state;
	
	var launches;
	
	var mctop;
	var mcptop;
	
	var mctop_depth;
	var mcptop_depth;
	
	var ripple_wait;
	var ripple_idx;
	
	var swish_t;
	var swish_from;
	var swish_to;
	
	var chain;
	var over;
	
	var available_moves;
	
	var freeze_count;
	
	function PlayField(_up)
	{
		up=_up;
	}
	
	function delegate(f,d)	{	return com.dynamicflash.utils.Delegate.create(this,f,d);	}

	var rnd_num:Number=0;
	function rnd_seed(n:Number) { rnd_num=n&65535; }
	function rnd() // returns a number between 0 and 65535
	{
		rnd_num=(((rnd_num+1)*75)-1)%65537; // all hail the mighty zx spectrum pseudo random number sequence
		return rnd_num;
	}
	
	function setup(nam)
	{
	var it;
	var idx;
	var x,y;
	var i;
	
	
		mc_scalar=gfx.create_clip(up.mc,null);
		
		mc=gfx.create_clip(mc_scalar,null);
//		gfx.dropshadow(mc,5, 45, 0x000000, 1, 10, 10, 2, 3);
//	    mc.filters = [ new flash.filters.DropShadowFilter(5, 45, 0x000000, 1, 10, 10, 2, 3) ];
//		mc.cacheAsBitmap=true;
		
		over=new Object();
		over.up=up;
		over.mc=gfx.create_clip(mc_scalar,null);
//	    over.mc.filters = [ new flash.filters.DropShadowFilter(5, 45, 0x000000, 1, 10, 10, 2, 3) ];	
//		over.mc.cacheAsBitmap=false;

		tab_w=8;
		tab_h=8;
		
		types=new Array("fire","earth","air","water","ether");
		for(i=0;i<5;i++)
		{
			types[ types[i] ]=i;
		}
		launches=new Array();
		
		tab=new Array();
		
		available_moves=new Array(0,0,0,0,0,0);

		build_board();
				
		focus=null;
		state="user";
		freeze_count=0;
		
		ripple_wait=25*10;
		ripple_idx=15;
		
		_root.poker.clear_clicks();
	}
	
	function build_board()
	{
	var it;
	var idx;
	var x,y;
	var i;
	
		chain=0;
		
		for(y=0;y<tab_h;y++)
		{
			for(x=0;x<tab_w;x++)
			{
				it=tab[(y*tab_w)+x];
				it.clean();
				tab[(y*tab_w)+x]=null;
			}
		}
		
		for(y=0;y<tab_h;y++)
		{
			for(x=0;x<tab_w;x++)
			{
				it=new FieldItem(this);
				it.setup(types[up.rnd()%types.length]);
				it.x=50+100*x;
				it.y=50+100*y;
				it.setxy(50+100*x,50+100*y);
				
				it.mc._xscale=0;
				it.mc._yscale=0;
				
				tab[(y*tab_w)+x]=it;
				it.idx=(y*tab_w)+x;
			}
		}
		
		while( check_clears() > 0 )
		{
			for(i=0;i<tab.length;i++)
			{
				if(tab[i].flags)
				{
					tab[i].flags=0;
					tab[i].score=0;
					tab[i].type=null;
					tab[i].draw();
				}
			}
		
			fill_holes();
		}
		
		chain=0;

// lock some of them		
		if(up.gamemode=="puzzle")
		{
			for(i=0;i<8;i++)
			{
				x=up.rnd()%8;
				y=up.rnd()%8;
				
				it=tab[(y*tab_w)+x];
				
				it.locked=true;
				gfx.blur(it.mc , 4,4,4 );
			}
		}

// easy mode? , 6x6		
/*
		for(y=0;y<tab_h;y++)
		{
			for(x=0;x<tab_w;x++)
			{
				it=tab[(y*tab_w)+x];
				
				if((x==0)||(x==tab_w-1)||(y==0)||(y==1))
				{
					it.flags=0;
					it.score=0;
					it.type=null;
					it.draw();
				}
			}
		}
*/
		
		mcptop=gfx.create_clip(mc,null);
		mcptop_depth=mc.newdepth;
		mctop=gfx.create_clip(mc,null);
		mctop_depth=mc.newdepth;		
	}
	
	
	function fill_holes()
	{
	var x,y,it;
	
		for(y=0;y<tab_h;y++)
		{
			for(x=0;x<tab_w;x++)
			{
				it=tab[(y*tab_w)+x];
				
				if(it.type==null)
				{
					it.type=types[up.rnd()%types.length];
					it.draw();
				}
			}
		}
	}
	
	function check_clears()
	{
	var x,y,idx;
	var xmatch,ymatch;
	var xb,yb,idxb;
	
	var hits;
	
	var ypos,xpos,maxpos;
	var i;
	var nomorematch;
	
	var lastitem;
	var basescore;
	
// count available moves here as well
		for(i=0;i<=5;i++)
		{
			available_moves[i]=0;
		}
		
		maxpos=0;
	
		hits=0;
	
		for(y=tab_h-1;y>=0;y--)
		{
			for(x=tab_w-1;x>=0;x--)
			{
				idx=(y*tab_w)+x;

				if(tab[idx].type!=null) // check we are not empty
				{
				
					available_moves[ types[ tab[idx].type ] ]++; // count available pieces
				
// check upwards for 3+ lines the same

					nomorematch=false;
					ypos=1;
					ymatch=1;
					xb=x;
					for(yb=y-1;yb>=0;yb--)
					{
						idxb=(yb*tab_w)+xb;
						
						if((tab[idxb].type==tab[idx].type)&&(!nomorematch))
						{
							ypos++;
							ymatch++;
						}
						else
						{
							if(maxpos>=3)
							{
								break;
							}
							else
							if(tab[idxb].type!=null)
							{
								ypos++;
								nomorematch=true; 
							}
							else
							{
								break;
							}
						}
					}
					
					if(maxpos<ypos)
					{
						maxpos=ypos;
					}
					
					
// check left for 3+ lines the same

					nomorematch=false;
					xpos=1;
					xmatch=1;
					yb=y;
					for(xb=x-1;xb>=0;xb--)
					{
						idxb=(yb*tab_w)+xb;
						
						if((tab[idxb].type==tab[idx].type)&&(!nomorematch))
						{
							xpos++;
							xmatch++;
						}
						else
						{
							if(maxpos>=3)
							{
								break;
							}
							else
							if(tab[idxb].type!=null)
							{
								xpos++;
								nomorematch=true; 
							}
							else
							{
								break;
							}
						}
					}
					if(maxpos<xpos)
					{
						maxpos=xpos;
					}
					
// remove y match
					basescore=0;
					if(ymatch>=3) // clear them
					{
						hits+=ymatch;
						xb=x;
						for(yb=y;yb>y-ymatch;yb--)
						{
							idxb=(yb*tab_w)+xb;
							
							if(!(tab[idxb].flags&3)) basescore+=100;
							
							tab[idxb].flags|=1;
							lastitem=tab[idxb];
						}
						
						lastitem.score+=basescore;
						
						if(chain>0)
						{
							lastitem.score+=(10*chain);	// small bonus for any chaining
						}
						
						if(ymatch>=4)
						{
							lastitem.score+=(10*(chain+1));	// small bonus for 4 or 5 in a row
						}
					}
// remove x match
					basescore=0;
					if(xmatch>=3) // clear them
					{
						hits+=xmatch;
						yb=y;
						for(xb=x;xb>x-xmatch;xb--)
						{
							idxb=(yb*tab_w)+xb;
							
							if(!(tab[idxb].flags&3)) basescore+=100;
							
							tab[idxb].flags|=2;
							lastitem=tab[idxb];
						}
						
						lastitem.score+=basescore;
						
						if(chain>0)
						{
							lastitem.score+=(10*chain);	// small multiply bonus for any chaining it adds up slowly
						}
						
						if(xmatch>=4)
						{
							lastitem.score+=(10*(chain+1));	// small bonus for 4 (+10*chain) or 5 (+20*chain) in a row
						}
					}
				}
				
			}
		}
		
		available_moves[5]=maxpos; // if 3+ then there is still space to make a move
		
		if(hits>0) // count a chain of events
		{
			chain++;
		}
		
		return hits;
	}
	
	function do_clears()
	{
	var i;
	var count;
	var p;
	
		count=0;
	
		for(i=0;i<tab.length;i++)
		{
			if(tab[i].flags)
			{
				count+=1;
				
				p=1;
				if(tab[i].flags==3) { p=2; }
				
//				up.scores[(up.player+1)&1].points-=p; // simple damage			
				up.score(tab[i].score);
				
				tab[i].launch( ((up.rnd()&255)-128)/4 , ((up.rnd()&255)-512)/4 , tab[i].score );
		
				tab[i].flags=0;
				tab[i].type=null;
				tab[i].draw();
				
				tab[i].locked=false;
				tab[i].mc.filters=null;
				
				tab[i].score=0;
				
			}
		}
		
		return count;
	}
	
	
	function check_drops()
	{
	var x,y,idx;
	var idxb;
	
	var hits;
	
		hits=0;
	
		for(y=tab_h-2;y>=0;y--) // bottom row doesnt drop
		{
			for(x=tab_w-1;x>=0;x--)
			{
				idx=(y*tab_w)+x;

				if( (tab[idx].type!=null) && (!tab[idx].locked) )// check we are not empty, and not locked
				{
					idxb=((y+1)*tab_w)+x;
					if( ( tab[idxb].type==null ) || (tab[idxb].flags) ) // check bellow is empty or moving
					{
						tab[idx].flags=4; // mark to drop
						hits+=1;
					}
				}
			}
		}

		
		if(up.gamemode=="endurance") // keep putting more in...
		{
			y=0;
			for(x=tab_w-1;x>=0;x--)
			{
				idx=(y*tab_w)+x;

				if(tab[idx].type==null) // add a random one in
				{
					tab[idx].mc._xscale=0;
					tab[idx].mc._yscale=0;
					tab[idx].type=types[up.rnd()%types.length];
					tab[idx].draw();
					hits+=1;
				}
			}
		}
		
		return hits;
	}
	
	function inject_line()
	{
	var x,y,idx;
	var idxb;
	var hits;
	
		y=0;
		for(x=tab_w-1;x>=0;x--)
		{
			idx=(y*tab_w)+x;

			if(tab[idx].type==null) // inject here
			{
				tab[idx].mc._xscale=100;
				tab[idx].mc._yscale=100;
				tab[idx].type=tab[idx+(tab_w*tab_h)].type;
				tab[idx].draw();
				hits+=1;
				
				tab[idx+(tab_w*tab_h)].type=types[up.rnd()%types.length];
				tab[idx+(tab_w*tab_h)].draw();
				
				tab[idx+(tab_w*tab_h)].setxy(tab[idx+(tab_w*tab_h)].x,tab[idx+(tab_w*tab_h)].y);
			}
			
//			tab[idx+(tab_w*tab_h)].mc._y=tab[idx+(tab_w*tab_h)].y;
		}
		
		return hits;
	}
	
	function do_drops()
	{
	var i;
	var it;
	var itb;
	var count;
	var dy;
	
		count=0;
	
		for(i=tab.length-1;i>=0;i--)
		{
			it=tab[i]
			if(it.flags)
			{
				it.nextframe();
				it.nextframe();
				
				count+=1;
				
				it.setxy(it._x,it._y+20);
//				it.mc._y+=20;
				
				dy=it._y-it.y;
				
				if( dy >= 100-20 ) // one step
				{
					itb=tab[i+tab_w];
					itb.type=it.type;
					itb.draw(it);
					
					it.setxy(it._x,it.y);
//					it.mc._y=it.y;
					
					it.type=null;
					
					it.draw();
					
					it.flags=0;
				}
			}
		}
		
		return count;
	}
	
	function do_swish()
	{
	var s,t,tt,tp;
	
	
		tp=Math.sqrt( ((swish_to.x-swish_from.x)*(swish_to.x-swish_from.x)) + ((swish_to.y-swish_from.y)*(swish_to.y-swish_from.y)) );
		
		tp= (tp<200 ? 0.2 : 0.1 );
	
		swish_t+=tp;
		
		t=swish_t;
		t=t*0.5;
		tt=t*t;
		s=((tt+(tt*2))-((tt*t)*2))*2;
		
		if(swish_t>=1)
		{
			swish_from.setxy(swish_from.x,swish_from.y);
//			swish_from.mc._x=swish_from.x;
//			swish_from.mc._y=swish_from.y;
			
			swish_to.setxy(swish_to.x,swish_to.y);
//			swish_to.mc._x=swish_to.x;
//			swish_to.mc._y=swish_to.y;
			
			return 0;
		}
		else
		{
			swish_from.nextframe();
			swish_to.nextframe();
			
			swish_from.mc._xscale=150;
			swish_from.mc._yscale=150;
			
			swish_to.mc._xscale=150;
			swish_to.mc._yscale=150;
		
			swish_from.setxy( swish_from.x+(swish_to.x-swish_from.x)*s , swish_from.y+(swish_to.y-swish_from.y)*s );
//			swish_from.mc._x=swish_from.x+(swish_to.x-swish_from.x)*s;
//			swish_from.mc._y=swish_from.y+(swish_to.y-swish_from.y)*s;
			
			swish_to.setxy( swish_to.x+(swish_from.x-swish_to.x)*s , swish_to.y+(swish_from.y-swish_to.y)*s );
//			swish_to.mc._x=swish_to.x+(swish_from.x-swish_to.x)*s;
//			swish_to.mc._y=swish_to.y+(swish_from.y-swish_to.y)*s;
			
			return 1;
		}
	}
	
	function clean()
	{	
		while(launches.length)
		{
			launches[0].clean();
			launches.splice(0,1);
		}
		
		mc.removeMovieClip();		
	}

	
	var clear_sfx_chan=0;
	
	
// allow user to modify the board
	function update_user()
	{
	var mx,my,mk,i,it;
	var x,y,idx;
	var ckdx,ck;
	
		if(focus.type==null) { focus=null; }
		
		if(focus)
		{
			if(focus.locked) { focus=null; }
		}
		
		if(focus)
		{
			focus.nextframe();
		}
			
		if(up.turnactive)
		{
		for(ckdx=0;ckdx<_root.poker.clicks.length+1;ckdx++)
		{
			ck=_root.poker.clicks[ckdx];
			if(ck)
			{
				mc.globalToLocal(ck);

				mx=ck.x;
				my=ck.y;
				mk=ck.click;
			}
			else
			{
				mk=0;
				mx=mc._xmouse;
				my=mc._ymouse;
			}
						
			if( (mx>=0) && (mx<800) && (my>0) && (my<800) ) // mouse on grid
			{
				mx=Math.floor(mx/100);
				my=Math.floor(my/100);
				
				i=mx+my*tab_w;
				
				if(tab[i]!=focus)
				{
					if((tab[i].type!=null)&&(!tab[i].locked))
					{
						tab[i].mc._xscale=150;
						tab[i].mc._yscale=150;
						tab[i].nextframe();
					}
				}
				
				
				if(!focus)
				{
					tab[i].mc.swapDepths(mctop_depth);
//					mctop=tab[i].mc;
				}
				else
				if(tab[i]!=focus)
				{
					tab[i].mc.swapDepths(mcptop_depth);
				}
				
				
				if(mk==1)
				{
					if(tab[i]!=focus)
					{
						if((tab[i].type!=null)&&(!tab[i].locked))
						{
							if(focus==null)
							{
								tab[i].mc._xscale=150;
								tab[i].mc._yscale=150;
								focus=tab[i];
							}
						}
					}
					else
					{
						focus=null;
					}
					
				}
				
				if(mk==-1)
				{
					if(tab[i]!=focus)
					{
						if((tab[i].type!=null)&&(!tab[i].locked))
						{					
							if(focus!=null)
							{							
								swish_from=focus;
								swish_to=tab[i];
							
								tab[i].mc._xscale=150;
								tab[i].mc._yscale=150;
															
								focus=null;
								
								swish_t=0;
								state="swish";
								
								
								_root.wetplay.PlaySFX("sfx_swish",3);
		
								freeze_count+=1;
								
								up.next_turn( swish_from.idx + "/" + swish_to.idx ); // very simple turn msg eg "6/43"
								up.choose_color(swish_from.type);
								up.choose_color(swish_to.type);
								up.score(-1);
							}
						}
					}
					
				}
				
			}
		}
		}
		else
		{
			focus=null; //check for in coming moves
			
			var s=up.next_turn(); // ask what to do
			
			if(s) // we gots a turn
			{
			
				if(s=="-1/-1") // pass
				{
					focus=null;
					up.next_turn(s); // signal that turn has been completed
				}
				else
				if(s=="-2/-2") // jiggle player order (possible padding at the end of each stage)
				{
					focus=null;
					up.next_turn(s); // signal that turn has been completed
				}
				else
				{			
				var a=s.split("/");
				var ia=Math.floor(a[0]);
				var ib=Math.floor(a[1]);
				
					swish_from=tab[ia];
					swish_to=tab[ib];
				
					tab[ia].mc._xscale=150;
					tab[ia].mc._yscale=150;
					
					tab[ib].mc._xscale=150;
					tab[ib].mc._yscale=150;
												
					focus=null;
					
					swish_t=0;
					state="swish";
					
					
					_root.wetplay.PlaySFX("sfx_swish",3);

					freeze_count+=1;
					
					up.next_turn(s); // signal that turn has been completed
					up.choose_color(swish_from.type);
					up.choose_color(swish_to.type);
					up.score(-1);
				}
			}
			
		}
		_root.poker.clear_clicks();
	}
	
	function update()
	{
	var mx,my,i,it;
	var x,y,idx;
	
		switch(state)
		{
		
			case "check":
				
				if(check_clears()>0)
				{
//					_root.wetplay.PlaySFX("sfx_jingle",2);
					clear_sfx_chan++;
				}
				if( do_clears()>0 )
				{					
					state="fall_check";
				}
				else
				{
					state="user";
					
					ripple_wait=0;
					ripple_idx=0;
					
				}
				if(up.gamemode=="endurance")
				{
					update_user();
				}
			break;
			
			case "fall_check":
			
				if(check_drops()>0) // repeat until stop moving
				{
					do_drops();
					state="fall";
				}
				else
				{
					state="check";
				}
				if(up.gamemode=="endurance")
				{
					update_user();
				}
			break;
			
			case "fall":
			
				if(do_drops()==0) // repeat until end
				{
					if(check_clears()>0)
					{
//						_root.wetplay.PlaySFX("sfx_jingle",2);
						clear_sfx_chan++;
					}
					do_clears();
					state="fall_check";
				}
				if(up.gamemode=="endurance")
				{
					update_user();
				}
			break;
			
			case "swish":
			
				if(do_swish()==0) // repeat until end
				{
				var t;
					
					chain=0;
					
					t=swish_from.type;
					swish_from.type=swish_to.type;
					swish_to.type=t;
					
					swish_to.draw(swish_from);
					swish_from.draw();
								
								
					if(check_clears()>0)
					{
//						_root.wetplay.PlaySFX("sfx_jingle",2);
						clear_sfx_chan++;
					}
					do_clears();
					state="fall_check";
				}
			break;
			
			case "user":
			
			for(i=0;i<freeze_count;i++)
			{
				if(up.gamemode=="endurance") // randomly freeze one piece after each move
				{
					x=up.rnd()%8;
					y=up.rnd()%8;
					
					it=tab[(y*tab_w)+x];
					
					if(it.type!=null)
					{
						it.locked=true;
						gfx.blur(it.mc , 4,4,4 );
					}
				}
			}
			freeze_count=0;
	
			update_user();
			
// do random ripples
			
			if(ripple_wait>0)
			{
				ripple_wait--;
				ripple_idx=15;
			}
			else
			{

				if(ripple_idx<=0)
				{
					ripple_wait=(up.rnd()%(30*15))+(30*5);
				}
				else
				{
					ripple_idx--;
					
					for(y=0;y<tab_h;y++)
					{
						for(x=0;x<tab_w;x++)
						{
							if((x+y)==ripple_idx)
							{
								idx=y*tab_w+x;
								if(((tab[idx].type!=null)&&(!tab[idx].locked)))
								{
									if( tab[idx].mc._xscale < 125 )
									{
										tab[idx].mc._xscale=125;
										tab[idx].mc._yscale=125;
									}
								}
							}
						}
					}
					
				}
				
			}
		
			break;
		}

		var siz;
		for(i=0;i<tab_w*tab_h;i++)
		{
			if(tab[i].locked)
			{
				if(tab[i].mc._xscale!=50)
				{
					siz=Math.ceil((50+tab[i].mc._xscale)/2);
					tab[i].mc._xscale=siz;
					tab[i].mc._yscale=siz;
				}
			}
			else
			{
				if(tab[i].mc._xscale!=100)
				{
					if(tab[i]!=focus)
					{
						siz=Math.ceil((100+tab[i].mc._xscale)/2);
						tab[i].mc._xscale=siz;
						tab[i].mc._yscale=siz;
					}
				}
			}
		}
		
		
		
		
		for(i=0;i<launches.length;i++)
		{
			if(launches[i].update_launch())
			{
				launches[i].clean();
				launches.splice(i,1);
				i--;
//				dbg.print("killed launch");
//				launches.length--;
			}
		}
		
//dbg.print(launches.length);

		if(launches.length==0) // check for finished
		{
/*
dbg.print(available_moves[5] + " , " +
	available_moves[4] + " , " +
	available_moves[3] + " , " +
	available_moves[2] + " , " +
	available_moves[1] + " , " +
	available_moves[0] );
*/
			if
				(
					( available_moves[5] <3 ) // there is no space to make a move
					||
					(
						(available_moves[0]<3) // or there are no pieces to make a move
						&&
						(available_moves[1]<3)
						&&
						(available_moves[2]<3)
						&&
						(available_moves[3]<3)
						&&
						(available_moves[4]<3)
					)
				)
			{
				up.stage_end();
			}
			
		}
		
		
		
//		gfx.clear(mc);
//		render_all();



	}
	
	function render_all()
	{
	var i;
		for(i=0;i<tab_w*tab_h;i++)
		{
			tab[i].render(mc,tab[i]._x,tab[i]._y,tab[i].mc._xscale);
		}
//dbg.print(i);
	}
	
	function redraw_all()
	{
	var i;
		var siz;
		for(i=0;i<tab_w*tab_h;i++)
		{
			tab[i].draw(tab[i]);
		}
	}
}