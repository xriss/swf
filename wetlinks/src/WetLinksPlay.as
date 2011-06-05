/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) Kriss Daniels 2007 http://www.XIXs.com
//
/*+-----------------------------------------------------------------------------------------------------------------+*/

#include "src/opts.as"

#require("src/LinksData")


class WetLinksPlay
{
	var state_last;
	var state;
	var state_next;

	var up;
	
	var mc;
	var links;
	var items;
	var mc_top;

	var frame;
	
	var xp;
	var xpp;
	
	var filter;
	var focus;
	var mct;
	var mctf;
	var fadeout;

	
	function WetLinksPlay(_up)
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


	function setup()
	{
	var i,l;
	
		frame=0;
		
		state_last=null;
		state=null;
		state_next=null;

		rnd_seed(up.game_seed);
		
		mc=gfx.create_clip(up.mc,null);
		
		
		links=[];
		
#for i,v in ipairs(LinksData) do

		l=[];
		
		l.img="#(v.img1)";
		l.url1="#(v.lnk1)";
		l.url2="#(v.lnk2)";
		l.url3="#(v.lnk3)";
		l.url_fb="#(v.lnk_fb)";
		l.nam="#(v.nam1)";
		l.txt1="#(v.txt1)";
		l.txt2="#(v.txt2)";
		l.lnksml="#(v.lnksml)";

		links[#(i-1)]=l;
#end


		filter="none";
		
		if(_root.style=="friends")
		{
			up.setsize(400,100);
			state_next="friends";
		}
		else
		if(_root.style=="hunt")
		{
			up.setsize(800,600);
			state_next="hunt";
		}
		else
		if(_root.style=="join")
		{
			up.setsize(800,600);
			state_next="hunt";
		}
		else
		if(_root.style=="facebook")
		{
			up.setsize(800,600);
			state_next="hunt";
			filter="facebook";
		}
		else
		if( (_root.style=="4lfa") || (_root.style=="alfa") )
		{
			up.setsize(800,600);
			state_next="alfa";
		}
		else
		{
			up.setsize(468,60);
			state_next="ban";
		}
	}
	
	function clean()
	{
		mc.removeMovieClip();
	}

	function update()
	{
	var s;
	
		if(_root.popup) return;
		
		frame++;
		
//		dbg.print("f="+frame);

		if(state_next!=null)
		{
			if(state) { this[state+"_clean"](); }
			
			state_last=state;	// change master state
			state=state_next;
			state_next=null;
			
			if(state) { this[state+"_setup"](); }
		}
		if(state) { this[state+"_update"](); }

	}
	
	function gety(x)
	{
	var y;

		y=Math.sin(Math.PI*x/(468/4));
		
		return y;
	}
	
	
	function do_url(link)
	{
		if(_root.style=="facebook")
		{
			if(link.url_fb!="")
			{
				getURL(link.url_fb,"_blank");
			}
			else
			{
				getURL(link.lnksml,"_blank");
			}
		}
		else
		if(_root.link=="kong")
		{
			getURL(link.lnksml,"_blank");
		}
		else
		if(_root.link=="bot")
		{
			getURL(link.url1,"BOT");
		}
		else
		if(_root.link=="wet")
		{
			getURL(link.lnksml,"_top");
		}
		else
		if(_root.link=="nopop")
		{
			getURL(link.url1);
		}
		else
		{
			getURL(link.lnksml,"_blank");
		}
	}
	
	
	function ban_setup()
	{
	var i,l,j,mcj;
			
		xp=0;
		
		for(i=0;i<links.length;i++)
		{
			l=links[i];
			
			for(j=0;j<3;j++)
			{
				l["mc"+j].removeMovieClip();
				l["mc"+j]=gfx.add_clip(mc,l.img,null);
				l["mc"+j].l=l;
				l["mc"+j].onRelease = delegate(do_url,l);
			}
			
			focus=l;
		}
		fadeout=0;
		
		mc.lxmouse=mc._xmouse;
		xpp=-1;
		
		mct=gfx.create_clip(mc,null);
		gfx.clear(mct);
		mct.style.out=0x80ffffff;
		mct.style.fill=0x80ffffff;
		gfx.draw_rounded_rectangle(mct,0,8,3,-80,-25,160,50);
		mctf=gfx.create_text_html(mct,null,-80,-25,160,50);
		mctf._y+=5;
	}
	
	function ban_clean()
	{
	}
	
	function ban_update()
	{
	var i,l,j,mcj;
	var xs;
	var xi;
	var domouse;
	var xm;
	var newfocus;
	var s;
	
		if(fadeout>0) { fadeout-=1; } 

		xm=mc._xmouse;
			
		domouse=false;
		if(mc.lxmouse!=mc._xmouse) // move mouse over to activate speed control
		{		
			mc.lxmouse=mc._xmouse;
			
			xpp=1-(mc._xmouse/(468/2));
			xpp*=8;
			if(xpp>0)
			{
				xpp=Math.floor(xpp);
			}
			else
			{
				xpp=Math.ceil(xpp);
			}
			if(xpp> 8) {xpp= 8;}
			if(xpp<-8) {xpp=-8;}
			if(xpp==0) {xpp=-1;}
			
			domouse=true;
			
			fadeout=100;
		}
		if(fadeout==0) { xpp=-1; }
		
		xp+=xpp;
		if(xp<-links.length*100)	xp+=links.length*100;
		if(xp>0)					xp-=links.length*100;
		
		newfocus=null;
		
		for(i=0;i<links.length;i++)
		{
			l=links[i];
			
			for(j=0;j<3;j++)
			{
				mcj=l["mc"+j];
				mcj._x=i*100+xp+(links.length*100*j);
				mcj._y=(-20+(gety(mcj._x)*20));

				if(fadeout>0) // mouse is in frame
				{
					if( (mcj._x<xm) && ((mcj._x+100)>xm) )
					{
						newfocus=l;
//						dbg.print(l.url);
					}
				}
			}
		}
		
		mct._y=60/2;
		if(xm<(468/2))
		{
			mct._x=xm+150;
		}
		else
		{
			mct._x=xm-150;
		}
		
		mct._alpha=fadeout;
		
		if((newfocus)&&(newfocus!=focus))
		{
			focus=newfocus;
			
			s="";
			s+="<p align='center'>";
			s+="Click now to PLAY!";
			s+="</p>";
			s+="<p align='center'><b>";
			s+=focus.nam;
			s+="</b></p>";
			
			gfx.set_text_html(mctf,16,0x000000,s);
		}
		
		
	}
	
	function hunt_rotate()
	{
		var i,j,li,lj;
		var dx,dy,ss,s;
		
		for(i=0;i<items.length;i++)
		{	
			li=items[i];
			if(li==over) continue;

			dx=li.mc1._x;
			dy=li.mc1._y;
			
			ss=dx*dx + dy*dy;
			
			s=Math.sqrt(ss);
			if(s==0) { s=1; }
			
			dx=dx/s;
			dy=dy/s;
			
			li.mc1._x+=dy*s/128;
			li.mc1._y+=-dx*s/128;
			
			if(over!=null) // go faster
			{
				li.mc1._x+=dy*s/128;
				li.mc1._y+=-dx*s/128;
			}
		}
	}
	
	function hunt_push()
	{
		var i,j,li,lj;
		var dx,dy,ss,s;
		
		var minx,miny,maxx,maxy;
		
		minx=-200;
		miny=-150;
		maxx=200;
		maxy=150;
		
		for(i=0;i<items.length;i++)
		{
			li=items[i];
			
			li.vx=0;
			li.vy=0;
			li.dist=150;//li.mc1._xscale*1.5;
			
			if(li==over)
			{
				li.mc1._xscale=(li.mc1._xscale*0.75) + (200*0.25);
				li.mc1._yscale=li.mc1._xscale;
			}
			else
			{
				li.mc1._xscale=(li.mc1._xscale*(1-0.125)) + (100*0.125);
				li.mc1._yscale=li.mc1._xscale;
				
				for(j=0;j<items.length;j++)
				{
					lj=items[j];
					
					if(i==j) continue;
					
					dx=lj.mc1._x-li.mc1._x;
					dy=lj.mc1._y-li.mc1._y;
					
					ss=dx*dx + dy*dy;
					
					if(ss<(li.dist*li.dist)) // push away
					{
						s=Math.sqrt(ss);
						if(s==0) { s=1; }
						
						dx=dx/s;
						dy=dy/s;
						
						li.vx+=-dx*(((li.dist-s)/2));
						li.vy+=-dy*(((li.dist-s)/2));
					}
					
				}
				
				li.mc1._x+=li.vx;
				li.mc1._y+=li.vy;
				
				li.mc1._x*=255/256;
				li.mc1._y*=255/256;
			
			}
			
			if(li.mc1._x<minx) { minx=li.mc1._x; }
			if(li.mc1._y<miny) { miny=li.mc1._y; }
			if(li.mc1._x>maxx) { maxx=li.mc1._x; }
			if(li.mc1._y>maxy) { maxy=li.mc1._y; }
			
		}
		
		var xx,yy;
		
		xx=Math.abs(minx);
		if(maxx>xx) xx=maxx;
		
		yy=Math.abs(miny);
		if(maxy>yy) yy=maxy;
		
		xx=300/xx;
		yy=200/yy;
		if(xx<yy) { yy=xx; } // yy is now min
		
		if(over==null) // stop scaling when we are ready to click
		{
			mc._xscale=(mc._xscale*0.75)+((yy*100)*0.25);
			mc._yscale=mc._xscale;
			mc._x=400;
			mc._y=300;
		}
	}
	
	var over;
	function it_over(it)
	{
		over=it;
		
		if(mc_top!=over.mc1)
		{
			mc_top.swapDepths(over.mc1);
			mc_top=over.mc1;
		}
		
		_root.poker.ShowFloat("<b>"+it.link.nam+"</b><br> <font size=\"12\">"+it.link.txt2+"</font>",25*10);
	}
	function it_out(it)
	{
		_root.poker.ShowFloat(null,0);
		over=null;
	}
	function it_click(it)
	{
		do_url(it.link);
	}
	
	function hunt_setup()
	{
	var i,l,j,it;
	
		items=[];
		
		if(_root.redirect)
		{
			getURL(_root.redirect,"_top");
		}
		
		mc._x=400;
		mc._y=300;
	
		for(j=0;j<1;j++)
		{
			for(i=0;i<links.length;i++)
			{
				l=links[i];
				if(filter=="facebook")
				{
					if(!l.url_fb) { continue; }
				}
				it={};it.idx=items.length;items[items.length]=it;
				
//				it.mc1.removeMovieClip();
//				it.mc2.removeMovieClip();
				
				it.link=l;
				it.mc1=gfx.create_clip(mc,null);
				it.mc2=gfx.add_clip(it.mc1,l.img,null,-50,-50);
				
				it.mc2.onRollOver		=delegate(it_over, it);
				it.mc2.onRollOut 		=delegate(it_out,  it);
				it.mc2.onReleaseOutside	=delegate(it_out,  it);
				it.mc2.onRelease		=delegate(it_click,it);
				
				gfx.dropshadow(it.mc2 , 4 , 45, 0x000000, 1, 8, 8, 2, 3);

				
				it.mc1._xscale=100;
				it.mc1._yscale=100;
				
				it.mc1._x=(50+rnd()%700)-400;
				it.mc1._y=(50+rnd()%500)-300;
			}
		}
		
		mc_top=gfx.create_clip(mc,null);
				
		mct=gfx.create_clip(mc,null);
		gfx.clear(mct);
		mct.style.out=0x80ffffff;
		mct.style.fill=0x80ffffff;
		gfx.draw_rounded_rectangle(mct,0,8,3,-80,-25,160,50);
		mctf=gfx.create_text_html(mct,null,-80,-25,160,50);
		mctf._y+=5;
		mct._visible=false;
	}
	
	function hunt_clean()
	{
	}
	
	function hunt_update()
	{
		hunt_rotate();
		hunt_push();
	}

	var done_xml=false;
	var xml=null;
	
	function alfa_setup()
	{
		xml=new XML();
		xml.ignoreWhite=true;
		xml.onLoad=null;
		
		xml.onLoad=delegate(alfa_readxml);
		xml.load("http://4lfa.com/rss.php?image=thumb");
	}
	
	function alfa_parse_xml(n)
	{
		var i,t;

		if(n.nodeName=="item")
		{
			alfa_got_item(n);
		}
		else
		{
			t=n.childNodes;
			
			for(i=0;i<t.length;i++)
			{
				alfa_parse_xml(t[i]);
			}
		}
	}
	
	function alfa_got_item(n)
	{
	var i;
	var t,tr,tt;
	var s1,s2;
	var a1,a2;
	var img;
	var l;
	
		tr=new Object();
	
		t=n.childNodes;
		
		for(i=0;i<t.length;i++)
		{
			tt=t[i];
			
			if( (tt.nodeName) && (tt.firstChild.nodeValue) )
			{
//				dbg.print(tt.nodeName + ":" + tt.firstChild.nodeValue );
				
				tr[tt.nodeName]=tt.firstChild.nodeValue;
			}
		}
		
		a1=tr["description"].split("src=");
		a2=a1[1].split("\"");
		a1=a2[1].split(".png");
		img=a1[0]+".png";		
		tr.img=img;
		
		l=[];
		
		l.img=tr.img;
		l.url1=tr.link;
		l.url2=tr.link;
		l.url3=tr.link;
		l.url4=tr.link;
		l.lnksml=tr.link;
		l.nam=tr.title;
		l.txt1=tr.title;
		l.txt2=tr.pubDate;

		links[links.length]=l;
	}
	
	function alfa_readxml()
	{
	var i,l,j,it;
	
// build links from xml we just read	
	
//dbg.print("loaded xml");

		links=[];
		alfa_parse_xml(xml);
	
		items=[];
		
		mc._x=400;
		mc._y=300;
	
		for(j=0;j<1;j++)
		{
			for(i=0;i<links.length;i++)
			{
				l=links[i];
				it={};it.idx=items.length;items[items.length]=it;
				
//				it.mc1.removeMovieClip();
//				it.mc2.removeMovieClip();
				
				it.link=l;
				it.mc1=gfx.create_clip(mc,null);
				it.mc2=gfx.create_clip(it.mc1,null,-50,-50);
				it.mc3=gfx.create_clip(it.mc2,null);
				it.mc3.loadMovie(l.img);
				
				it.mc2.onRollOver		=delegate(it_over, it);
				it.mc2.onRollOut 		=delegate(it_out,  it);
				it.mc2.onReleaseOutside	=delegate(it_out,  it);
				it.mc2.onRelease		=delegate(it_click,it);
				
				gfx.dropshadow(it.mc2 , 4 , 45, 0x000000, 1, 8, 8, 2, 3);

				
				it.mc1._xscale=100;
				it.mc1._yscale=100;
				
				it.mc1._x=(50+rnd()%700)-400;
				it.mc1._y=(50+rnd()%500)-300;
			}
		}
		
		mc_top=gfx.create_clip(mc,null);
				
		mct=gfx.create_clip(mc,null);
		gfx.clear(mct);
		mct.style.out=0x80ffffff;
		mct.style.fill=0x80ffffff;
		gfx.draw_rounded_rectangle(mct,0,8,3,-80,-25,160,50);
		mctf=gfx.create_text_html(mct,null,-80,-25,160,50);
		mctf._y+=5;
		mct._visible=false;
		
		
		
		done_xml=true;
	}
	
	function alfa_clean()
	{
	}
	
	function alfa_update()
	{
		if(done_xml)
		{
			hunt_rotate();
			hunt_push();
		}
	}

	function fit_over(it)
	{
		if(it.text!=undefined)
		{
		_root.poker.ShowFloat("<b>"+it.text+"</b>",25*10);
		}
//		it.mc1.swapDepths(1024);			
//		_root.poker.ShowFloat("<b>"+it.link.nam+"</b><br> <font size=\"12\">"+it.link.txt2+"</font>",25*10);
	}
	function fit_out(it)
	{
		_root.poker.ShowFloat(null,0);
		over=null;
	}
	function fit_click(it)
	{
		getURL(it.link);
	}

	function friends_setup()
	{
	var i,l,j,it,d;
	
		items=[];
		
		mc._x=200;
		mc._y=50;
	
		mc.depmin=65536;
		mc.depmax=0;
	
		for(i=1;i<32;i++)
		{
		
			if( (_root["a"+i]!=undefined) && (_root["l"+i]!=undefined) )
			{
				it={};it.idx=items.length;items[items.length]=it;

				it.link=_root["l"+i];
				it.text=_root["t"+i];
				
				it.mc1=gfx.create_clip(mc,null);
				
				d=it.mc1.getDepth();
//dbg.print(d);
				if(d>mc.depmax) { mc.depmax=d; }
				if(d<mc.depmin) { mc.depmin=d; }
				
				it.mc2=gfx.create_clip(it.mc1,null,-50,-50);
				it.mc3=gfx.create_clip(it.mc2,null);
				it.mc3.loadMovie(_root["a"+i]);
				
				it.mc2.onRollOver		=delegate(fit_over, it);
				it.mc2.onRollOut 		=delegate(fit_out,  it);
				it.mc2.onReleaseOutside	=delegate(fit_out,  it);
				it.mc2.onRelease		=delegate(fit_click,it);
				
				gfx.dropshadow(it.mc2 , 4 , 45, 0x000000, 1, 8, 8, 2, 3);

				it.mc1._xscale=100;
				it.mc1._yscale=100;
								
			}
			
		}

		for(i=0;i<items.length;i++)
		{
			it=items[i];
			
			it.rot=i/items.length;
		}
			
/*		mct=gfx.create_clip(mc,null);
		gfx.clear(mct);
		mct.style.out=0x80ffffff;
		mct.style.fill=0x80ffffff;
		gfx.draw_rounded_rectangle(mct,0,8,3,-80,-25,160,50);
		mctf=gfx.create_text_html(mct,null,-80,-25,160,50);
		mctf._y+=5;
		mct._visible=false;
*/
	}
	
	function friends_clean()
	{
	}
	
	var f_tim=-0.33;
	function friends_update()
	{
	var i,it;
	var xpp;
	var a,b;
	
		xpp=-(mc._xmouse/(380/2));
		if(xpp> 1) { xpp=0; }
		if(xpp<-1) { xpp=0; }		
		xpp=xpp/50;
	
		if(xpp==0) {xpp=0;}
			
			
		f_tim+=xpp;
		if( f_tim>1 ) { f_tim-=1; }
		if( f_tim<0 ) { f_tim+=1; }
	
		for(i=0;i<items.length;i++)
		{
			it=items[i];
			
			it.mc1._x=150*Math.sin( (f_tim+it.rot)*2*Math.PI );
			it.mc1._y=0;
			
			it.mc1._z=Math.cos( (f_tim+it.rot)*2*Math.PI );
			
			it.mc1._xscale=60 + 30*it.mc1._z;
			it.mc1._yscale=it.mc1._xscale;
			
			it.mc3.forceSmoothing=true; // retarted flash 8++ fix
		}
		
		for(i=mc.depmin;i<mc.depmax;i++)
		{
			a=mc.getInstanceAtDepth(i);
			b=mc.getInstanceAtDepth(i+1);

//dbg.print(a._xscale);
			
			if( a._z > b._z )
			{
				a.swapDepths(b);
			}
		}
		
	}
	
}