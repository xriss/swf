/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) Kriss Daniels 2006 http://www.XIXs.com
//
/*+-----------------------------------------------------------------------------------------------------------------+*/

#include "src/opts.as"

// A collection of stacks of cards making up the game LIES!!!!


class ItsaPlay
{

	var up; // PixlCoopPlay

	var mc;
	var mc_board;
	
	var mcs;
	var bms;
	
	var tfwho;
	
	var itm;
	
	var gd;
	
	var actors;
	var actors_active;
	
	var state;
	var state_done;
	
	var styles; // we grab a copy of the game styles here
	
	var game_done;
	var ourname="";
	var artname="";
	var artword="";
	
	
	function delegate(f,a,b,c)	{	return com.dynamicflash.utils.Delegate.create(this,f,a,b,c);	}
	
// ser
	var rnd_num=0;
	function rnd_seed(n) { rnd_num=n&0xffff; }
	function rnd() // returns a number between 0 and 65535
	{
		rnd_num=(((rnd_num+1)*75)-1)%65537; // all hail the mighty zx spectrum pseudo random number sequence
		return rnd_num;
	}


	function ItsaPlay(_up)
	{
		up=_up;		
		
		gd=up.gd;
	}
	
	var selected;
	var topidx;

	function setup()
	{	
	var m,i;
	var j;
	var it;
	var line,lin;
	var box;
	
		game_done=false;
	
		_root.bmc.clear_loading();

		mc=gfx.create_clip(up.mc,null);
		
		selected=[];
		topidx=[];
		mcs=[];

		for(i=0;i<interface_lines.length-1;i++)
		{
			line=interface_lines[i];
			lin=line.split(",");
			
			if(lin[0]=="") { lin[0]=null; }
			if(lin[1]=="") { lin[1]=null; }
			if(lin[2]=="") { lin[2]=null; }
			
			switch(lin[0])
			{
				case "board":
					m=gfx.create_clip(mc,null,0,0);
					mc_board=m;
				break;
			
				default:
					m=gfx.create_clip(mc,null,0,0);
					m.m=gfx.add_clip(m,"interface",null,0,0);
					m.m.gotoAndStop(i+1);
					m.cacheAsBitmap=true;
					m.active=true;
				break;
			}
			
			
			
			m.idx=i;
			m.nam=lin[0];
			if(lin[1]) { m.nam=m.nam+"_"+lin[1]; }
			m.nams=lin;
			
			
			mcs[i]=m;
			mcs[m.nam]=m; // swing both ways?
			
			switch(lin[0])
			{
				case "line":
				case "alpha":
				case "shape":
				case "color":
				case "menu":
				case "back":
				
					box=m.m.getBounds(m);
					box.x=(box.xMin+box.xMax)/2;
					box.y=(box.yMin+box.yMax)/2;
					box.w=(box.xMax-box.xMin);
					box.h=(box.yMax-box.yMin);
					
					m.m._x=-box.x;
					m.m._y=-box.y;
					
					m._x=box.x;
					m._y=box.y;
					
					make_button(m);
					
				break;
				case "title":
					m._visible=false;
				break;
				case "menu":
					m._visible=false;
				break;
			}
			
			topidx[ lin[0] ]=m.getDepth()
		}
		
//		mcs["shape_star"]._visible=false;
//		mcs["shape_star"].nams[0]="off";

		click( mcs["line_50"] );
		click( mcs["alpha_75"] );
		click( mcs["shape_free"] );
		click( mcs["color_2"] );
		
// create drawing bmap and over mc for building drawing commands in
			
		mc_board.mc=gfx.create_clip(mc_board,null,0,0);
		mc_board.bmp=new flash.display.BitmapData(800,600,false,0xffffff);		
		mc_board.mc.attachBitmap(mc_board.bmp,0,"always",true);
		mc_board.mc.cacheAsBitmap=true;
		
		mc_board.over=gfx.create_clip(mc_board,null,0,0);

		tfwho=gfx.create_text_html(mc,null,0,525,800,100);
		
	
		if(_root.art)
		{
			artword="nothing";
			artname="no one";
			artist_art();
			
			get_art();
		}
		else
		if(gd)
		{
			artist_disable();
			
			styles=null;
			gmsgsend( { gcmd:"styles" , gnam:gd.gamename } );
		}
		else
		{
			artist_enable();
		}
				
		Mouse.addListener(this);		
	}
	
	function clean()
	{
		Mouse.removeListener(this);
		mc.removeMovieClip(); mc=null;	
	}

	var artist=false;
	
// allow this user to draw
	function artist_enable()
	{
	var i;
		
		artist=true;
	
		grab_styles();
		sent_styles={};
		
		for(i=0;i<mcs.length;i++)
		{

			switch(mcs[i].nams[0])
			{
				case "backover":
				case "line":
				case "alpha":
				case "shape":
				case "color":
//				case "menu":
				
					mcs[i]._visible=true;
				
				break;
/*
				case "menu2":
				
					mcs[i]._visible=true;
				
				break;
*/
			}
		}
		
		gfx.set_text_html(tfwho,32,0xffffff,"");
		
//dbg.dump(styles);
	}
// deny this user from drawing
	function artist_disable()
	{
	var i;
	
		artist=false;
		
		grab_styles();
		sent_styles={};
		
		for(i=0;i<mcs.length;i++)
		{

			switch(mcs[i].nams[0])
			{
				case "backover":
				case "line":
				case "alpha":
				case "shape":
				case "color":
//				case "menu":
//				case "menu2":
				
					mcs[i]._visible=false;
				
				break;
			}
		}
		
		gfx.set_text_html(tfwho,32,0xffffff,"<p align=\"center\"><font size=\"32\">Art by "+artname+"</font></p>");
		
	}
	
	function artist_art()
	{
	var i;
	
		artist=false;
		
		grab_styles();
		sent_styles={};
		
		for(i=0;i<mcs.length;i++)
		{

			switch(mcs[i].nams[0])
			{
				case "backover":
				case "line":
				case "alpha":
				case "shape":
				case "color":
				case "menu":
				case "none":
				case "menu2":
				
					mcs[i]._visible=false;
				
				break;
			}
		}
		
		gfx.set_text_html(tfwho,32,0xffffff,"<p align=\"center\"><font size=\"32\">"+artword+" by "+artname+"</font></p>");
		
	}
	
	var xml_art;
	function get_art(nam,num)
	{
		if(!nam) { nam=_root.art; }
		if(!num) { num=_root.artid; }
		if(!num) { num=-1; }
		
		
		xml_art=new XML();
		
		xml_art.onData = delegate(got_art);
		
		if(_root.artuid)
		{
			xml_art.load("http://swf.wetgenes.com/swf/itsacoop.php?uid="+Math.floor(_root.artuid));
		}
		else
		{
			xml_art.load("http://swf.wetgenes.com/swf/itsacoop.php?name="+nam+"&id="+num);
		}
	}
	
	function got_art(dat)
	{
	var aa;
		if(dat)
		{
			aa=dat.split("\t");
			
			artname=aa[0];
			artword=aa[1];
			
			artist_art();
			
			grab_styles();
			mc_board.bmp.fillRect(new flash.geom.Rectangle(0,0,800,600),0xffffffff);

			do_act(aa[2]);
		}
	}
	
	
	var draw_style;
	var draw_points;
	var draw_points_count;
	
	function onMouseDown()
	{
		if(_root.popup) { return; }
		if(state=="done") { return; }
		
		if( mc_board._ymouse > 500 )
		{
			return;
		}
		
		if(!artist)
		{
			if(_root.art)
			{
				if(!_root.artuid)
				{
					get_art(undefined,-1);
				}
			}
			return;
		}
		
		switch( draw_style.shape )
		{
			default:
			case "arrow":
			case "free":
			case "line":
			case "box":
			case "circle":
			case "star":
				draw_points=[];		
				grab_styles();
				draw_points[0]=Math.round(mc_board._xmouse);
				draw_points[1]=Math.round(mc_board._ymouse)-1;
				draw_points[2]=draw_points[0];
				draw_points[3]=draw_points[1]+1;
				draw_points_count=2;
				draw_style.mouse=true;
			break;
			
			case "triangle":
			
				if(!draw_style.mouse)
				{
					draw_points=[];		
					grab_styles();
					draw_points[0]=Math.round(mc_board._xmouse);
					draw_points[1]=Math.round(mc_board._ymouse)-1;
					draw_points[2]=draw_points[0];
					draw_points[3]=draw_points[1]+1;
					draw_points_count=2;
					draw_style.mouse=true;
				}
				else
				{
					draw_points[6]=Math.round(mc_board._xmouse);
					draw_points[7]=Math.round(mc_board._ymouse);
					draw_points_count=4;
				}
				
			break;
		}
	}

	var act_string=""; // left over pieces
	
	
// Fwewewexeue0ere2eqe5ene6ele9ekeAfheDffeGfceJfbeMfYeOfWeRfTeVfQeYfNedfKeefJehfEemfBeqf+dsf9dvf7dyf4dzf3d2f0d5fxd+fvdBgsdCgrdFgodHgmdKgidOgfdRgddUgadXgXdcgWdfgTdggRdjgQdmgOdpgLdrgKdugIdxgFd0gBd4g/c7g8c+g7cBh5cEh2cHh1cKhycMhwcPhvcShscVhqcYhpcbhmcfhhckhecohdcrhbcuhYcxhXc0hUc3hRc8hOc/hMcCiJcFiJcIiGcLiFcOiDcRiCcUi/bXi9bai8bdi6bgi5bji3bmi2bpi0bsizbvi2bvi5bvi8bvi/bviCcviFcviIcviLcwiPcwiScwiVcwiYcwibcyiecyihcyikcyipczisczivcziyczi1c1i4c1i7c1i+c1iBd1iEd1iHd1iKd2iOd1iRd1iWd1iZd1icdzigdzildziodzisdzixdyi1dyi6dyi9dyiBeyiEeyiHewiKewiPewiTewiWewiZewicewifewiiewilewioewirewiwewizewi2ewi6ewi9ewiAfwiFfwiIfviLfviOfviSfwiVfwiYfwibfwigfwijfwimfwiqfwitfwiwfwizfwi2fyi7fyi+fyiBgyiEgziIgziLgziOg1iTg1iWg1iZg2idg2igg2ijg4iog4irg4ivg4iyg5i3g5i6g5i9g5iBh5iEh5iJh5iMh5iPh5iTh5iWh5ibh5ieh5iih4ilh4iqh4ith4iwh4i0h4i3h4i6h2i/h2iCi2iFi2iIi2iLi2iOi2iRi1iUi1iXi1ibi1iei1ijizimizipizisiyiviyiwivivisisipiqimipijimieijiaihiXigiUidiSibiPiYiMiXiJiUiGiRiDiOiAiLi9hIi6hFi3hCi0h9hxh6huh3hrh0hohwhkhthhhqhehlhbhihYhfhVhbhShYhPhVhKhShHhNhEhKhBhHh+gEh7gBh4g+g1g6gyg3gvg0gsgxgpgugmgrgjgmgggjgdgggagdgZgagWgXgTgUgRgTgOgQgLgNgKgKgHgFgCgEg/fBg+f/f7f8f4f7f1f2fwfzfsfyfpfvfmftfjfqfgfpfdfmfafjfXfhfUfefRfbfOfYfMfVfJfSfGfPfDfOfAfLf/eIf9eGf6eDf5eCf2e/eze8exe5ewe2etezereweueuexerezeoe3ele8eheAffeDfceFfZeIfYeLfVeOfSeRfPeUfMeXf


	function do_act(m)
	{
	var i=0;
	var s;
	var c;
	var x,y,p;

		s=act_string+m;

//dbg.print(m)
		
		while(i<s.length)
		{
		
			c=Clown.tonum(s,i,1);i+=1; // get code
			
			switch(c)
			{
				case 0: // just skip
				break;
				
				case 1: // line a->b
				
					draw_points=[];
					draw_style.shape="line";
				
					x=400+Clown.tonum(s,i,2)-(64*32);i+=2;
					y=250+Clown.tonum(s,i,2)-(64*32);i+=2;
					
					draw_points[0]=x;
					draw_points[1]=y;
					
					x=400+Clown.tonum(s,i,2)-(64*32);i+=2;
					y=250+Clown.tonum(s,i,2)-(64*32);i+=2;
					
					draw_points[2]=x;
					draw_points[3]=y;
					
					draw_points_count=2;

//dbg.print("line "+draw_points[0]+","+draw_points[1]+" : "+draw_points[2]+","+draw_points[3]);

					update_draw();
					update_bitmap();
					
				break;
				
				case 2: // box a->b
				
					draw_points=[];
					draw_style.shape="box";
				
					x=400+Clown.tonum(s,i,2)-(64*32);i+=2;
					y=250+Clown.tonum(s,i,2)-(64*32);i+=2;
					
					draw_points[0]=x;
					draw_points[1]=y;
					
					x=400+Clown.tonum(s,i,2)-(64*32);i+=2;
					y=250+Clown.tonum(s,i,2)-(64*32);i+=2;
					
					draw_points[2]=x;
					draw_points[3]=y;
					
					draw_points_count=2;

//dbg.print("box "+draw_points[0]+","+draw_points[1]+" : "+draw_points[2]+","+draw_points[3]);

					update_draw();
					update_bitmap();
					
				break;
				
				case 3: // circle a->b
				
					draw_points=[];
					draw_style.shape="circle";
				
					x=400+Clown.tonum(s,i,2)-(64*32);i+=2;
					y=250+Clown.tonum(s,i,2)-(64*32);i+=2;
					
					draw_points[0]=x;
					draw_points[1]=y;
					
					x=400+Clown.tonum(s,i,2)-(64*32);i+=2;
					y=250+Clown.tonum(s,i,2)-(64*32);i+=2;
					
					draw_points[2]=x;
					draw_points[3]=y;
					
					draw_points_count=2;

//dbg.print("circle "+draw_points[0]+","+draw_points[1]+" : "+draw_points[2]+","+draw_points[3]);

					update_draw();
					update_bitmap();
					
				break;
				
				case 4: // triangle a->b->c->d
				
					draw_points=[];
					draw_style.shape="triangle";
				
					x=400+Clown.tonum(s,i,2)-(64*32);i+=2;
					y=250+Clown.tonum(s,i,2)-(64*32);i+=2;
					
					draw_points[0]=x;
					draw_points[1]=y;
					
					x=400+Clown.tonum(s,i,2)-(64*32);i+=2;
					y=250+Clown.tonum(s,i,2)-(64*32);i+=2;
					
					draw_points[2]=x;
					draw_points[3]=y;
					
					x=400+Clown.tonum(s,i,2)-(64*32);i+=2;
					y=250+Clown.tonum(s,i,2)-(64*32);i+=2;
					
					draw_points[4]=x;
					draw_points[5]=y;
					
					x=400+Clown.tonum(s,i,2)-(64*32);i+=2;
					y=250+Clown.tonum(s,i,2)-(64*32);i+=2;
					
					draw_points[6]=x;
					draw_points[7]=y;
					
					draw_points_count=4;

//dbg.print("triangle "+draw_points[0]+","+draw_points[1]+" : "+draw_points[2]+","+draw_points[3]);

					update_draw();
					update_bitmap();
					
				break;
				
				case 5: // free line++
				
					draw_points=[];
					draw_style.shape="free";
				
					draw_points_count=0;
					
					var notdone=true;
					while(notdone)
					{
						if(i>=s.length) // error
						{
							notdone=false;
						}
						else
						if( Clown.tonum(s,i,2) == 0) // terminator
						{
							i+=2;
							notdone=false;
						}
						else
						{
							x=400+Clown.tonum(s,i,2)-(64*32);i+=2;
							y=250+Clown.tonum(s,i,2)-(64*32);i+=2;
							
							draw_points[(draw_points_count*2)+0]=x;
							draw_points[(draw_points_count*2)+1]=y;
							
							draw_points_count++;
						}
					}
//dbg.print(draw_points_count);

//dbg.print("free "+draw_points[0]+","+draw_points[1]+" : "+draw_points[2]+","+draw_points[3]);

					update_draw();
					update_bitmap();
					
				break;
				
				case 6: // line a->b
				
					draw_points=[];
					draw_style.shape="arrow";
				
					x=400+Clown.tonum(s,i,2)-(64*32);i+=2;
					y=250+Clown.tonum(s,i,2)-(64*32);i+=2;
					
					draw_points[0]=x;
					draw_points[1]=y;
					
					x=400+Clown.tonum(s,i,2)-(64*32);i+=2;
					y=250+Clown.tonum(s,i,2)-(64*32);i+=2;
					
					draw_points[2]=x;
					draw_points[3]=y;
					
					draw_points_count=2;

//dbg.print("line "+draw_points[0]+","+draw_points[1]+" : "+draw_points[2]+","+draw_points[3]);

					update_draw();
					update_bitmap();
					
				break;
				
				case 63: // line width
				
					draw_style.line=Clown.tonum(s,i,2);i+=2;
					
				break;
				
				case 62: // line alpha
				
					draw_style.alpha=Clown.tonum(s,i,2);i+=2;
					
				break;
				
				case 61: // line color
				
					draw_style.color=Clown.tonum(s,i,4);i+=4;
					
				break;
			}
			
		}
		
		act_string="";

	}
	
	var sent_styles; // remember what styles we sent so only need to send changes

	function send_act()
	{
	var s="";
	var x,y,p;
	var i;
	
		if(!artist) { return; }
		if(!gd) { return; }


		if( Math.floor(draw_style.line) != Math.floor(sent_styles.line) )
		{
			s="";
			
			sent_styles.line=Math.floor(draw_style.line);
			
			s+=Clown.tostr(63,1);
			s+=Clown.tostr(sent_styles.line,2);
			
			gmsgsend( { gcmd:"act" , gnam:gd.gamename , gtim:-1 , gdat:s } );
		}
		
		if( Math.floor(draw_style.alpha) != Math.floor(sent_styles.alpha) )
		{
			s="";
			
			sent_styles.alpha=Math.floor(draw_style.alpha);
			
			s+=Clown.tostr(62,1);
			s+=Clown.tostr(sent_styles.alpha,2);
			
			gmsgsend( { gcmd:"act" , gnam:gd.gamename , gtim:-1 , gdat:s } );
		}
		
		if( Math.floor(draw_style.color) != Math.floor(sent_styles.color) )
		{
			s="";
			
			sent_styles.color=Math.floor(draw_style.color);
			
			s+=Clown.tostr(61,1);
			s+=Clown.tostr(sent_styles.color,4);
			
			gmsgsend( { gcmd:"act" , gnam:gd.gamename , gtim:-1 , gdat:s } );
		}
		
	
		s="";
		switch(draw_style.shape)
		{
			case "line":
		
				s+=Clown.tostr(1,1);
				
				x=draw_points[0]-400+(64*32);
				y=draw_points[1]-250+(64*32);
				
				s+=Clown.tostr(x,2);
				s+=Clown.tostr(y,2);
					
				x=draw_points[2]-400+(64*32);
				y=draw_points[3]-250+(64*32);
				
				s+=Clown.tostr(x,2);
				s+=Clown.tostr(y,2);
				
				gmsgsend( { gcmd:"act" , gnam:gd.gamename , gtim:-1 , gdat:s } );
							
			break;
			
			case "box":
		
				s+=Clown.tostr(2,1);
				
				x=draw_points[0]-400+(64*32);
				y=draw_points[1]-250+(64*32);
				
				s+=Clown.tostr(x,2);
				s+=Clown.tostr(y,2);
					
				x=draw_points[2]-400+(64*32);
				y=draw_points[3]-250+(64*32);
				
				s+=Clown.tostr(x,2);
				s+=Clown.tostr(y,2);
				
				gmsgsend( { gcmd:"act" , gnam:gd.gamename , gtim:-1 , gdat:s } );
							
			break;
			
			case "circle":
		
				s+=Clown.tostr(3,1);
				
				x=draw_points[0]-400+(64*32);
				y=draw_points[1]-250+(64*32);
				
				s+=Clown.tostr(x,2);
				s+=Clown.tostr(y,2);
					
				x=draw_points[2]-400+(64*32);
				y=draw_points[3]-250+(64*32);
				
				s+=Clown.tostr(x,2);
				s+=Clown.tostr(y,2);
				
				gmsgsend( { gcmd:"act" , gnam:gd.gamename , gtim:-1 , gdat:s } );
							
			break;
			
			case "triangle":
		
				s+=Clown.tostr(4,1);
				
				x=draw_points[0]-400+(64*32);
				y=draw_points[1]-250+(64*32);
				
				s+=Clown.tostr(x,2);
				s+=Clown.tostr(y,2);
					
				x=draw_points[2]-400+(64*32);
				y=draw_points[3]-250+(64*32);
				
				s+=Clown.tostr(x,2);
				s+=Clown.tostr(y,2);
				
				x=draw_points[4]-400+(64*32);
				y=draw_points[5]-250+(64*32);
				
				s+=Clown.tostr(x,2);
				s+=Clown.tostr(y,2);
				
				x=draw_points[6]-400+(64*32);
				y=draw_points[7]-250+(64*32);
				
				s+=Clown.tostr(x,2);
				s+=Clown.tostr(y,2);
				
				gmsgsend( { gcmd:"act" , gnam:gd.gamename , gtim:-1 , gdat:s } );
							
			break;
			
			case "free":
		
				s+=Clown.tostr(5,1);
				
//dbg.print(draw_points_count);

				for(i=0;i<draw_points_count;i++)
				{
					x=draw_points[i*2+0]-400+(64*32);
					y=draw_points[i*2+1]-250+(64*32);
					
					if(x<0)			{ x=0; }
					if(x>(64*64-1)) { x=(64*64-1); }
					if(y<0)			{ y=0; }
					if(y>(64*64-1)) { y=(64*64-1); }
					
					if(x==0) {x=1;} // escape terminator, shouldnt actually happen...
					
					s+=Clown.tostr(x,2);
					s+=Clown.tostr(y,2);
				}
				
				s+=Clown.tostr(0,2); // term
				
				gmsgsend( { gcmd:"act" , gnam:gd.gamename , gtim:-1 , gdat:s } );
							
			break;
			
			case "arrow":
		
				s+=Clown.tostr(6,1);
				
				x=draw_points[0]-400+(64*32);
				y=draw_points[1]-250+(64*32);
				
				s+=Clown.tostr(x,2);
				s+=Clown.tostr(y,2);
					
				x=draw_points[2]-400+(64*32);
				y=draw_points[3]-250+(64*32);
				
				s+=Clown.tostr(x,2);
				s+=Clown.tostr(y,2);
				
				gmsgsend( { gcmd:"act" , gnam:gd.gamename , gtim:-1 , gdat:s } );
							
			break;
		}
		
	}
	
	function onMouseMove()
	{
		if(_root.popup) { return; }
		if(state=="done") { return; }
		
		if(!artist) { return; }
		
		if(draw_style.mouse)
		{
			update_mouse();
		}
	}
	
	function onMouseUp()
	{
		if(_root.popup) { return; }
		if(state=="done") { return; }
		
		if(!artist) { return; }
		
		if(!draw_style.mouse) { return; }
		
		switch( draw_style.shape )
		{
			default:
			case "free":
			case "line":
			case "arrow":
			case "box":
			case "circle":
			case "star":
				update_mouse();
				update_draw();
				send_act();
				update_bitmap();
				draw_style.mouse=false;
			break;
			
			case "triangle":
			
				if(draw_points_count==4)
				{
					update_mouse();
					update_draw();
					send_act();
					update_bitmap();
					draw_style.mouse=false;
				}
				else
				{
					update_mouse();
					
					draw_points[4]=Math.round(mc_board._xmouse);
					draw_points[5]=Math.round(mc_board._ymouse);
					draw_points_count=3;
					
					update_draw();
				}
				
			break;
		}
		
	}
	
	function update_mouse()
	{
		if(_root.popup) { return; }
		if(state=="done") { return; }
		
		if(!artist) { return; }
		
		switch( draw_style.shape )
		{
			default:
			case "free":
			
				var xx=draw_points[draw_points_count*2-2] - Math.round(mc_board._xmouse);
				var yy=draw_points[draw_points_count*2-1] - Math.round(mc_board._ymouse);
				
				if( (xx*xx+yy*yy) >= 3*3 ) // require some movement to lower the squigles
				{
					draw_points[draw_points_count*2+0]=Math.round(mc_board._xmouse);
					draw_points[draw_points_count*2+1]=Math.round(mc_board._ymouse);
					draw_points_count++;
				}
			break;
			case "arrow":
			case "line":
			case "box":
			case "circle":
			case "star":
			
				draw_points[2]=Math.round(mc_board._xmouse);
				draw_points[3]=Math.round(mc_board._ymouse);
				
			break;
			
			case "triangle":
			
				if( draw_points_count==2 )
				{
					draw_points[2]=Math.round(mc_board._xmouse);
					draw_points[3]=Math.round(mc_board._ymouse);
				}
				else
				if( draw_points_count==3 )
				{
					draw_points[4]=Math.round(mc_board._xmouse);
					draw_points[5]=Math.round(mc_board._ymouse);
				}
				else
				{
					draw_points[6]=Math.round(mc_board._xmouse);
					draw_points[7]=Math.round(mc_board._ymouse);
				}
				
			break;
		}
	}
	
	function grab_styles()
	{
		if(state=="done") { return; }
		
		draw_style={};
		draw_style.line=50;
		draw_style.alpha=100;
		draw_style.shape="line";
		draw_style.color=0x000000;
			
		if(!artist) { return; }
		
		draw_style={};
		draw_style.line=selected[ "line" ].nams[1];
		draw_style.alpha=selected[ "alpha" ].nams[1];
		draw_style.shape=selected[ "shape" ].nams[1];
		draw_style.color=selected[ "color" ].nams[2];
	}
	
	function update_style()
	{
		if(state=="done") { return; }
		
	var m=mc_board.over;
	
		draw_style.wide=10;
	
		switch( Math.floor(draw_style.line) )
		{
			case 25:
				draw_style.wide=2;
			break;
			case 50:
				draw_style.wide=5;
			break;
			case 75:
				draw_style.wide=10;
			break;
			case 100:
				draw_style.wide=40;
			break;
		}
	
		m.lineStyle(draw_style.wide,Math.floor(draw_style.color),Math.floor(draw_style.alpha));	
	}
	
	function update_preview()
	{
	var m=mc_board.over;
	
		if(state=="done") { return; }
		if(!artist) { return; }
		
		m.clear();
		update_style();
		
		m.moveTo(Math.round(mc_board._xmouse),Math.round(mc_board._ymouse)-1);
		m.lineTo(Math.round(mc_board._xmouse),Math.round(mc_board._ymouse));
	}
	
function drawellipse(mc, x, y, rx,ry)
{
mc.moveTo(x+rx, y);

mc.beginFill(Math.floor(draw_style.color),Math.floor(draw_style.alpha));
				
mc.curveTo(rx+x, Math.tan(Math.PI/8)*ry+y, Math.sin(Math.PI/4)*rx+x, 
Math.sin(Math.PI/4)*ry+y);
mc.curveTo(Math.tan(Math.PI/8)*rx+x, ry+y, x, ry+y);
mc.curveTo(-Math.tan(Math.PI/8)*rx+x, ry+y, -Math.sin(Math.PI/4)*rx+x, 
Math.sin(Math.PI/4)*ry+y);
mc.curveTo(-rx+x, Math.tan(Math.PI/8)*ry+y, -rx+x, y);
mc.curveTo(-rx+x, -Math.tan(Math.PI/8)*ry+y, -Math.sin(Math.PI/4)*rx+x,
-Math.sin(Math.PI/4)*ry+y);
mc.curveTo(-Math.tan(Math.PI/8)*rx+x, -ry+y, x, -ry+y);
mc.curveTo(Math.tan(Math.PI/8)*rx+x, -ry+y, Math.sin(Math.PI/4)*rx+x, 
-Math.sin(Math.PI/4)*ry+y);
mc.curveTo(rx+x, -Math.tan(Math.PI/8)*ry+y, rx+x, y);

mc.endFill();
}

	function update_draw()
	{
		if(state=="done") { return; }
		
	var m=mc_board.over;
	var i;
		
		m.clear();
		update_style();
		
		switch( draw_style.shape )
		{
			default:
			case "free":
			case "line":
			
				m.moveTo(draw_points[0],draw_points[1]);
				for(i=2;i<draw_points_count*2;i+=2)
				{
					m.lineTo(draw_points[i+0],draw_points[i+1]);
				}
				
			break;
			
			case "arrow":
			
			var x1,y1,len;
			var x2,y2,l;
			var x3,y3;
			
			
				x1=draw_points[0]-draw_points[2];
				y1=draw_points[1]-draw_points[3];
				len=Math.sqrt(x1*x1+y1*y1);
				if(len>0)
				{
					x1=x1/len;
					y1=y1/len;
					l=Math.floor(draw_style.line)/2;
					if(l>len/2){l=len/2;}
					
					x2=x1*l;
					y2=y1*l;
					
					x3=y1*l;
					y3=-x1*l;
				
					m.moveTo(draw_points[2],draw_points[3]);
					m.lineTo(draw_points[0],draw_points[1]);
					
					m.moveTo(draw_points[2],draw_points[3]);
					m.lineTo(draw_points[2]+x2+x3,draw_points[3]+y2+y3);
					
					m.moveTo(draw_points[2],draw_points[3]);
					m.lineTo(draw_points[2]+x2-x3,draw_points[3]+y2-y3);
				}
					
			break;
			
			case "triangle":
			
				if(Math.floor(draw_style.line)==25) // no line on fine line
				{
					m.lineStyle(undefined,undefined,undefined);
				}

				m.moveTo(draw_points[0],draw_points[1]);
				
				if( draw_points_count==3 )
				{
					m.beginFill(Math.floor(draw_style.color),Math.floor(draw_style.alpha));
					m.lineTo(draw_points[2],draw_points[3]);
					m.lineTo(draw_points[4],draw_points[5]);
					m.lineTo(draw_points[0],draw_points[1]);
					m.endFill();
				}
				else
				if( draw_points_count==4 )
				{
					m.beginFill(Math.floor(draw_style.color),Math.floor(draw_style.alpha));
					m.lineTo(draw_points[2],draw_points[3]);
					m.lineTo(draw_points[4],draw_points[5]);
					m.lineTo(draw_points[6],draw_points[7]);
					m.lineTo(draw_points[0],draw_points[1]);
					m.endFill();
				}
				else
				{
					m.lineTo(draw_points[2],draw_points[3]);
				}
				
			break;
			
			case "box":
			
				if(Math.floor(draw_style.line)==25) // no line on fine line
				{
					m.lineStyle(undefined,undefined,undefined);
				}

				m.moveTo(draw_points[0],draw_points[1]);
				m.beginFill(Math.floor(draw_style.color),Math.floor(draw_style.alpha));
				m.lineTo(draw_points[2],draw_points[1]);
				m.lineTo(draw_points[2],draw_points[3]);
				m.lineTo(draw_points[0],draw_points[3]);
				m.lineTo(draw_points[0],draw_points[1]);
				m.endFill();
			break;
			
			case "circle":
			
				if(Math.floor(draw_style.line)==25) // no line on fine line
				{
					m.lineStyle(undefined,undefined,undefined);
				}
				
				drawellipse(m, draw_points[0] , draw_points[1] , (draw_points[0]-draw_points[2]) , (draw_points[1]-draw_points[3]) );
				
			break;
			
			case "star":
			
				if(Math.floor(draw_style.line)==25) // no line on fine line
				{
					m.lineStyle(undefined,undefined,undefined);
				}

				drawellipse(m, (draw_points[0]+draw_points[2])/2 , (draw_points[1]+draw_points[3])/2 , (draw_points[0]-draw_points[2])/2 , (draw_points[1]-draw_points[3])/2 );
				
			break;
		}
	}
	
	function update_bitmap()
	{
		if(state=="done") { return; }
		
	var m=mc_board.over;
	
		mc_board.bmp.draw(m);
//		mc_board.bmp.draw(m,new flash.geom.Matrix(),new flash.geom.ColorTransform(),"normal",new flash.geom.Rectangle(0,0,800,600),true);
		
		m.clear();
	}
	
	
	
	function make_button(m)
	{
		m.onRelease=delegate(click,m);
		m.onRollOver=delegate(hover_on,m);
		m.onRollOut=delegate(hover_off,m);
		m.onReleaseOutside=delegate(hover_off,m);
		m.tabEnabled=false;
		
		m._alpha=90;
		m.oalpha=90;
	}
	
	function click(m)
	{
	var mo;
	
		if(_root.popup) { return; }
		
//dbg.print(m.nam);

		if( m.nams[0]=="back")
		{
			if(_root.art) // click to visit profile
			{
				getURL("http://like.wetgenes.com/-/profile/"+artname,"_blank");
			}
			return;
		}
		
		if( m.nams[0]=="menu")
		{
		
			if( m.nams[1]=="menu" )
			{
				if(artist)
				{
					up.menu.setup("draw");
				}
				else
				{
					up.menu.setup("guess");
				}
			}
			else
			if( m.nams[1]=="end" )
			{
				if(artist)
				{
					if(!game_done)
					{
						gmsgsend( { gcmd:"do" , gnam:gd.gamename , gdo:"artist_end" } ); // artist is starting
						up.menu.setup("end");
						game_done=true; // server says game is over
						_root.signals.signal("#(VERSION_NAME)","end",this);						
						_root.wetplay.PlaySFX("sfx_rainbow",0);
					}
				}
				else
				{
					up.up.state_next="menu";
				}
			}
		
			return;
		}
	
		mo=selected[ m.nams[0] ];
		
		if(mo)
		{
			mo._xscale=100;
			mo._yscale=100;
			mo._alpha=90;
			mo.oalpha=90;
		}
		m._xscale=80;
		m._yscale=80;
		m._alpha=100;
		m.oalpha=100;
		
		m.swapDepths(topidx[ m.nams[0] ]);
			
		selected[ m.nams[0] ]=m;
	}
	
	function hover_on(m)
	{
		if(_root.popup) { return; }
		
		if( m.nams[0]=="back")
		{
			return;
		}
		
		m._alpha=100;
	}
	function hover_off(m)
	{
		if(_root.popup) { return; }
		
		if( m.nams[0]=="back")
		{
			return;
		}
		
		m._alpha=m.oalpha;
	}
	
	var frame;
	var game_start_ms;
	
	function update()
	{
	var i,it,dx,dy;
	var s;
	
		_root.bmc.check_loading();
		
		if(game_done)
		{
			if(_root.popup) { return; }
		
			up.up.state_next="play"; // next arena level ( pull in styles from the server again )

			return;
		}
		
		if(artist)
		{

			if(draw_style.mouse)
			{
				update_mouse();
				update_draw();
			}
			else
			{
				grab_styles();
				update_preview();
			}
			
		}

	}
	
	
	function gmsgsend(msg)
	{
	var idx;
	var s;
	
		if(_root.sock)
		{
			_root.sock.gmsg( msg , delegate(gmsgback,msg) );
			lastmsg=msg;
			_root.sock.gmsg( null , delegate(gmsgback,null) ); // request all other game msgs as well
			
//dbg.print("msgsend : "+msg.gcmd);

		}
	}
	
	var lastmsg;
	var acts;
	
	
	function thunk()
	{

	}
	
	
	
	function gmsgback(msg,sentmsg)
	{
	var idx;
	var s;
	var a,i,aa,j;
	
		if(!sentmsg) // incoming
		{
			if(msg.gcmd=="do")
			{
				if(msg.gdo=="drawing") // remove final menu when a new game starts
				{
					if( _root.popup==up.menu )
					{
						up.menu.done=true;
					}
				}
			}
		}
		
		if(game_done)	{	return;	} // ignore any left over msgs

		if(!sentmsg) // incoming
		{
//dbg.print("msgrecv : ***");
//dbg.dump(msg);

			switch(msg.gcmd)
			{				
				case "act":
				
					if(state=="done") { break; }
					
					if(Math.floor(msg.gups)!=1) { break; } // only the artist sends draw commands


//					frame=Math.floor(msg.atim*25);
					game_start_ms=getTimer()-(msg.atim*1000);
					
//dbg.print( "act "+ Math.floor(msg.gtim) +" : "+ msg.gdat );

					acts[ Math.floor(msg.gtim) ]=msg.gdat;
					
					if(!artist) // artist will have already drawn this for fast response
					{
						do_act(msg.gdat);
					}
					
//					bump_actor(msg.gups-1); // push this player to top of active actor list
					
					thunk();
					
				break;
				
				case "style":
				
					switch(msg.gvar)
					{
						case "ups":
						
							var domenu=false;
							if( (styles.ups=="") || (styles.ups=="-") ) // this is our first ups set so show the menu
							{
								domenu=true;
							}
						
							styles.ups=msg.gset;
							aa=styles.ups.split(";");
							
							artname=aa[0];
							
							if(aa[0]==ourname) // we are the artist :)
							{
								artist_enable();
								if(domenu)
								{
									up.menu.setup("draw");
									gmsgsend( { gcmd:"do" , gnam:gd.gamename , gdo:"artist_start" } ); // artist is starting
								}
							}
							else
							{
								if(domenu)
								{
									artist_disable();
									up.menu.setup("guess");
								}
							}
							
//							set_actors(msg.gset);
						break;
						
						default:
							styles[msg.gvar]=msg.gset;
						break;
					}

				break;
				
				case "done":
				
//					up.up.state_next="play"; // next arena level ( pull in styles from the server again )

// build final score
					if(!game_done)
					{
						if(!_root.popup) // unless we alredy display something?
						{
							up.menu.setup("end");
						}
						game_done=true; // server says game is over
						_root.signals.signal("#(VERSION_NAME)","end",this);						
						_root.wetplay.PlaySFX("sfx_rainbow",0);
					}
					
					
				break;
				
//{cmd="game",gcmd="set",gid=0,guser=user.name,gvar="status",gset=msg.gset}


				case "set": // check if we have left the game
				
					if( msg.gcmd=="set" )
					{
						if( (msg.gvar=="status") && (msg.gset=="gone") )
						{
//dbg.print(msg.guser)
							if(msg.guser==ourname) // we left the room
							{
								up.up.state_next="menu";
//								state="done";
							}
						}
					}
				
				break;
				
			}
		}
		else
//		if(sentmsg==lastmsg) // only care about one return msg at a time, ignore all other return msgs
		{
		
//dbg.print("msgrecv : "+sentmsg.gcmd);
//dbg.dump(msg);

			switch(sentmsg.gcmd)
			{
				case "act":
				
//dbg.print("act");

//					frame=Math.floor(msg.atim*25);
					game_start_ms=getTimer()-(msg.atim*1000);
					
				break;
				

				case "styles":
				
					ourname=msg.gyou; // get our name from the server, trust the server
				
					a=msg.gret.split(",");
					if(a[0]=="OK")
					{
						styles=new Array();
						
						for(i=1;i<a.length;i++)
						{
							aa=a[i].split(":");							
							styles[aa[0]]=aa[1];
						}
					}
					
					acts=null;
					gmsgsend( { gcmd:"acts" , gnam:gd.gamename , gtim:0 , gtyp:"watch" } ); // request recap of all acts and add me to the list of people to send new msgs too
									

//					if(ourname=="poop")
//					{
//						artist_enable();
//					}

			
//					load_pixl_id(styles.seed);
		
				break;
				
				case "acts":
				
//					frame=Math.floor(msg.atim*25);
					game_start_ms=getTimer()-(msg.atim*1000);
				
//dbg.print("acts");

					acts=new Array();
					act_string="";
				
					a=msg.gret.split(";");
					for(i=0;i<a.length;i++)
					{
						a[i]=a[i].split(",");
					}
					
					if(a[0][0]=="OK")
					{
						a[0].splice(0,1); // throw away the OK
						
						for(i=0;i<1;i++) // ignore other players
						{
							for(j=0;j<a[i].length;j++)
							{
								aa=a[i][j].split(":");
								if(aa[0]!="")
								{
									acts[ Math.floor(aa[0]) ]=aa[1];
								}
							}
						}
						
						styles.ups=msg.gset;
						aa=styles.ups.split(";");
						
						artname=aa[0];
						if(aa[0]==ourname) // we are the artist :)
						{
							artist_enable();
							up.menu.setup("draw");
							gmsgsend( { gcmd:"do" , gnam:gd.gamename , gdo:"artist_start" } ); // artist is starting
						}
						else
						if( (styles.ups=="") || (styles.ups=="-") )// try to claim the artist spot
						{
							gmsgsend( { gcmd:"act" , gnam:gd.gamename , gtim:-1 , gdat:"0" } ); // broadcast a hello msg
						}
						else
						{
							artist_disable();
							up.menu.setup("guess");
						}


						for(i=1;i<acts.length;i++)
						{
							do_act(acts[i]);
						}
						
//dbg.dump(styles);
					
						
					}
					else
					{
					}
					
					
 	
				break;
				
				default:
				break;
			}
		}
	}
	
	static var interface_lines=[
#for line in io.lines("art/interface.txt") do 
#line=line:gsub("^%s*(.-)%s*$", "%1")
	"#(line)",
#end
	""
	];

}
