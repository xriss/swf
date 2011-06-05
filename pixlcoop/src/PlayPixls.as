/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) Kriss Daniels 2006 http://www.XIXs.com
//
/*+-----------------------------------------------------------------------------------------------------------------+*/

#include "src/opts.as"

// A collection of stacks of cards making up the game LIES!!!!


class PlayPixls
{

	var up; // PixlCoopPlay

	var mc;
	var mc_loading;
	
	var mcs;
	var bms;
	
	var itm;
	
	var pixl_tx;	// topleft of grid
	var pixl_ty;
	
	var pixl_w;
	var pixl_h;
	var pixl_bmp;
	var	pixl_typ_count;
	var pixl_typ;
	var pixl_col;
	var pixl_radar;
	var pixl_array;
	var pixl_back;
	var pixl_back_base;
	
	var tween_count;
	var tween_do;
	
	var bonus_mult=1;
	
	var tiles;
	
	var minx,miny;
	var maxx,maxy;
	
	var gd;
	
	var actors;
	var actors_active;
	
	var state;
	var state_done;
	
	var styles; // we grab a copy of the game style in here
	
	var game_done;
	var ourname="";
	
	function delegate(f,a,b,c)	{	return com.dynamicflash.utils.Delegate.create(this,f,a,b,c);	}
	
// ser
	var rnd_num=0;
	function rnd_seed(n) { rnd_num=n&0xffff; }
	function rnd() // returns a number between 0 and 65535
	{
		rnd_num=(((rnd_num+1)*75)-1)%65537; // all hail the mighty zx spectrum pseudo random number sequence
		return rnd_num;
	}


	function PlayPixls(_up)
	{
		up=_up;		
		
		gd=up.gd;
	}
	

	function setup()
	{	
	var i;
	var j;
	var it;
	
		ourname="";
		
		game_done=false;
		state="load";
		state_done="play";
		
		actors=[];
		actors_active=[];
		
		rnd_seed(0);//up.rnd_num);
		
		mc=gfx.create_clip(up.mc,null);
		
		mc_loading=gfx.create_clip(up.mc,null);
		mc_loading.tf=gfx.create_text_html(mc_loading,null,0,0,800,600);
		
		frame=0;
		game_start_ms=getTimer();

		tween_count=0;
		
		minx=0;
		miny=0;
		maxx=400;
		maxy=300;
		
		mcs=[];
		bms=[];
		itm=[];
				
		bms[0]=new flash.display.BitmapData(maxx,maxy,true,0x00000000);
		mcs[0]=gfx.create_clip(mc,null);
		mcs[0].attachBitmap(bms[0],0,"always",false);
		mcs[0]._xscale=200;
		mcs[0]._yscale=200;
		
		
		mcs[1]=gfx.create_clip(mcs[0],null,64,75,200,200);
		mcs[2]=gfx.create_clip(mcs[0],null,18,75,200,200);
		
		mcs[3]=gfx.create_clip(mcs[0],null,-50,142);
		mcs[3].tf1=gfx.create_text_html(mcs[3],null,0, 0,220,20);
		mcs[3].tf2=gfx.create_text_html(mcs[3],null,0,30,220,20);
		mcs[3].tf3=gfx.create_text_html(mcs[3],null,0,60,220,200);
		
		mcs[4]=gfx.create_clip(mcs[0],null,0,112);
		mcs[4].tf=gfx.create_text_html(mcs[4],null,0,0,120,20);
		
		make_button(mcs[1],"orig");
//		make_button(mcs[2],"radar");
		
		make_button(mcs[4],"link");
		
		pixl_tx=122;
		pixl_ty=22;
		
//		load_pixl("joystick",16,16);
//		load_pixl("mario",16,16);
//		load_pixl("ace",16,16);
//		load_pixl("eeyore",16,16);
		
		_root.bmc.clear_loading();

		if(gd)
		{
			styles=null;
			gmsgsend( { gcmd:"styles" , gnam:gd.gamename } );
		}
				
		Mouse.addListener(this);		
	}
	
	function clean()
	{
		Mouse.removeListener(this);
		mc.removeMovieClip(); mc=null;	
		mc_loading.removeMovieClip(); mc_loading=null;	
	}
	
	
	
	var hit;	// item under mouse down
	var hit_d;	// true if mouse is down
	var hit_dx;	// mouse pos on mouse down
	var hit_dy;
	var hit_bx;	// item pos on mouse down
	var hit_by;
	
	function onMouseDown()
	{
		if(state=="done") { return; }
		
		hit_d=true;
		hit_dx=mcs[0]._xmouse;
		hit_dy=mcs[0]._ymouse;
		
		hit=get_hit_item(mcs[0]._xmouse,mcs[0]._ymouse);
		
		if(hit.t==-1) // cant move half stuffs
		{
			hit=null;
		}
		hit_bx=hit._x;
		hit_by=hit._y;
		
//		dbg.print(hit+":"+hit_dx+","+hit_dy);
	}
	
	function onMouseUp()
	{
		if(state=="done") { return; }
		
//	var it;	
//		it=get_hit_item(mcs[0]._xmouse,mcs[0]._ymouse);
		
		hit_update(hit);
		hit_drop(hit);
		
		hit_d=false;
		hit=null;
	}
	
	function onClick(it)
	{
	}
	
	function hit_update(hit)
	{
		if(hit)
		{

			hit.vx=0;
			hit.vy=0;
//			hit._x=Math.floor(mcs[0]._xmouse/16)*16;
//			hit._y=Math.floor(mcs[0]._ymouse/16)*16;
			hit._x=hit_bx+mcs[0]._xmouse-hit_dx;
			hit._y=hit_by+mcs[0]._ymouse-hit_dy;

		}
	}
	
	function hit_draw(hit)
	{
	var x,y,dx,dy;
	
		if(hit)
		{
			x=Math.floor((mcs[0]._xmouse-pixl_tx)/16);
			y=Math.floor((mcs[0]._ymouse-pixl_ty)/16);
			
			if((x<0)||(x>=pixl_w)||(y<0)||(y>=pixl_h)) // check its on grid
			{
				dx=hit.bx;
				dy=hit.by;
			}
			else
			if(pixl_array[x+y*pixl_w]) // no swaping
			{
				dx=hit.bx;
				dy=hit.by;
			}
			else
			{
				dx=x*16+pixl_tx;
				dy=y*16+pixl_ty;
			}
			
			bms[0].merge(tiles ,
			new flash.geom.Rectangle(16*hit.p.i,0,16,16) ,
			new flash.geom.Point( dx , dy ),
			192,192,192,255);

			bms[0].merge(tiles ,
			new flash.geom.Rectangle(16*hit.p.i,0,16,16) ,
			new flash.geom.Point( hit.bx , hit.by ),
			192,192,192,255);
			
			bms[0].copyPixels(tiles , 
			new flash.geom.Rectangle(16*hit.p.i,0,16,16) , 
			new flash.geom.Point( Math.floor(hit._x) , Math.floor(hit._y) ) );
		}
	}
	
	function setup_item(p,x,y)
	{
	var it;
		
		it={};
		
		it.t=0; // 0==normal -1=halfstuff
		
		it.tw=0; // countdown tween
		
		it.bx=pixl_tx+x*16;
		it.by=pixl_ty+y*16;
		
		it.ox=it.bx;
		it.oy=it.by;
		
		it._x=it.bx;
		it._y=it.by;
		it.vx=0;
		it.vy=0;
		it.p=p;
		
//		it.vx=((rnd()%200)-100)/50;
//		it.vy=((rnd()%200)-100)/50;
		
		return it;
	}
	
	function update_item(it)
	{
	var dx,dy;
	
/*
	
		it._x+=it.vx;
		it._y+=it.vy;
		
		if(it._x>=maxx-16)	{ it._x=maxx-16; 	if(it.vx>0) {it.vx=-it.vx;} }
		if(it._x<=minx)		{ it._x=minx;  	 	if(it.vx<0) {it.vx=-it.vx;} }
		if(it._y>=maxy-16)	{ it._y=maxy-16;	if(it.vy>0) {it.vy=-it.vy;} }
		if(it._y<=miny)		{ it._y=miny;   	if(it.vy<0) {it.vy=-it.vy;} }
*/

		if(it.tw>0) // keep on tweening to base till we hit 0
		{
		
			dx=(it.bx-it._x)*0.35;
			dy=(it.by-it._y)*0.35;
			if((dx>0)&&(dx< 1)) dx= 1;
			if((dx<0)&&(dx>-1)) dx=-1;
			if((dy>0)&&(dy< 1)) dy= 1;
			if((dy<0)&&(dy>-1)) dy=-1;
			it._x+=Math.round(dx);
			it._y+=Math.round(dy);

			it.tw--;
			if(it.tw==0) // final fix when we hit 0
			{
				it._x=it.bx;
				it._y=it.by;
				it.t=0;
			}
			
			got_tw++;
		}
	
		
//		if(it!=hit) // do not draw dragging pixel
		
		if(it.t==0)
		{
			bms[0].copyPixels(tiles , new flash.geom.Rectangle(16*it.p.i,0,16,16) , new flash.geom.Point( Math.floor(it._x) , Math.floor(it._y) ) );
			
			pixl_radar.setPixel32( Math.floor((it._x-pixl_tx)/16) , Math.floor((it._y-pixl_ty)/16) , it.p.c );
		}
		else
		{
			bms[0].merge(tiles ,
			new flash.geom.Rectangle(16*it.p.i,0,16,16) ,
			new flash.geom.Point( it.bx , it.by ),
			192,192,192,255);

			bms[0].merge(tiles ,
			new flash.geom.Rectangle(16*it.p.i,0,16,16) ,
			new flash.geom.Point( it._x , it._y ),
			192,192,192,255);
		}
		
		if(pixl_array[it.basenum].p.c==it.p.c) // correct color
		{
			got_right++;
		}
		if(it.num==it.basenum) // correct location
		{
			got_perfect++;
		}
	}


	function hit_drop()
	{
	var x,y;
	var tit;
	
		if(hit)
		{
		
			x=Math.floor((mcs[0]._xmouse-pixl_tx)/16);
			y=Math.floor((mcs[0]._ymouse-pixl_ty)/16);
			
			if((x<0)||(x>=pixl_w)||(y<0)||(y>=pixl_h)) // check its on grid
			{
				hit._x=hit.bx;
				hit._y=hit.by;
			}
			else
			if(pixl_array[x+y*pixl_w]) // no swaping
			{
				hit._x=hit.bx;
				hit._y=hit.by;
			}
			else
			{
				if(gd)
				{
					hit.t=-1;
					hit._x=pixl_tx+x*16;
					hit._y=pixl_ty+y*16;
					gmsgsend( { gcmd:"act" , gnam:gd.gamename , gtim:-1 , gdat:hit.num+"/"+(x+y*16) } ); // broadcast turn
				}
				else
				{
					pixl_array[hit.num]=null
					hit.num=x+y*pixl_w;
					pixl_array[hit.num]=hit;
					hit.bx=pixl_tx+x*16;
					hit.by=pixl_ty+y*16;
					hit._x=hit.bx;
					hit._y=hit.by;
				}
			}			
		}
	}
	
	function swap_pixls(ax,ay,bx,by)
	{
	var at,bt;
	var ac,bc;
	
				ac=ax+ay*pixl_w;
				bc=bx+by*pixl_w;
				
				at=pixl_array[ac];
				bt=pixl_array[bc];
		
				pixl_array[ac]=null;
				pixl_array[bc]=null;
	
				if(at) // swaping
				{
					at.bx=pixl_tx+bx*16;
					at.by=pixl_ty+by*16;
					at.num=bc;
					pixl_array[bc]=at;
					if(!tween_do) // only if not full tweening
					{
						at.tw=15;
						at._x=pixl_tx+ax*16;
						at._y=pixl_ty+ay*16;
					}
					else
					{
						at.tw=0;
						at.tx=at.ox;
						at.ty=at.oy;
						at._x=at.tx;
						at._y=at.ty;
					}
					
					if((at.bx==at.ox)&&(at.by==at.oy)) // perfect placement
					{
						_root.wetplay.PlaySFX("sfx_object",1);
					}
					_root.wetplay.PlaySFX("sfx_swish",2);
				}
				
				if(bt) // swaping
				{
					bt.bx=pixl_tx+ax*16;
					bt.by=pixl_ty+ay*16;
					bt.num=ac;
					pixl_array[ac]=bt;
					if(!tween_do) // only if not full tweening
					{
						bt.tw=15;
						bt._x=pixl_tx+bx*16;
						bt._y=pixl_ty+by*16;
					}
					else
					{
						bt.tw=0;
						bt.tx=bt.ox;
						bt.ty=bt.oy;
						bt._x=bt.tx;
						bt._y=bt.ty;
					}
					
					if((bt.bx==bt.ox)&&(bt.by==bt.oy)) // perfect placement
					{
						_root.wetplay.PlaySFX("sfx_object",1);
					}
					_root.wetplay.PlaySFX("sfx_swish",2);
				}
	}
	
	function load_pixl_id(id)
	{
		rnd_seed(id);
		load_xml("http://swf.wetgenes.com/game/s/pixlcoop/pixl/xml/"+id);
	}
	
	var xml;
	
	function load_xml(url)
	{
		xml=new XML();
		xml.url=url;
		xml.ignoreWhite=true;
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
			
//dbg.print(pixl_id);
//dbg.print(pixl_name);
//dbg.print(pixl_url);
//dbg.print(pixl_link);
//dbg.print(pixl_text);

			pixl_w=16; // forced
			pixl_h=16;
			
			up.up.game_seed=pixl_id;
			
			_root.signals.signal("#(VERSION_NAME)","set",this); // we need to do this after we have the "seed"
			_root.signals.signal("#(VERSION_NAME)","start",this); // we need to do this after we have the "seed"
			
			load_pixl();
		}
	}
	
	var pixl_name="";
	var pixl_url="";
	var pixl_link="";
	var pixl_text="";
	var pixl_id=0;
	
	function parse_xml(e,d,parent)
	{
	var ec;
	var children;
	
		children=false;
		
		if(e.nodeType==1)
		{
//dbg.print(d+":"+e.nodeType+":"+e.nodeName);

			switch(e.nodeName)
			{
				case "pixl":
					pixl_name=e.attributes.name;
					pixl_id=Math.floor(e.attributes.id);
					children=true;
				break;
				
				case "link":
					pixl_link=e.attributes.href;
				break;
								
				case "text":
					children="text";
				break;
				
				case "img":
					pixl_url=e.attributes.src;
				break;
				
				default:
					children=true;
				break;
			}
			if( children )
			{
				for( ec=e.firstChild ; ec ; ec=ec.nextSibling )
				{
					parse_xml(ec,d+1,children);
				}
			}
		}
		else
		if(e.nodeType==3)
		{
//dbg.print(d+":"+e.nodeType+":"+e.nodeName);

			switch(parent)
			{
				case "text":
					pixl_text=trim_str(e.nodeValue);
				break;
			}
		}		
	}

	function trim_str(s)
	{
		var i=0;
		var l=0;
		var r=s.length-1;
		for(i=0;i<s.length;i++)
		{
			if(s.charCodeAt(i)>32)
			{
				l=i;
				break;
			}
		}
		for(i=s.length-1;i>=0;i--)
		{
			if(s.charCodeAt(i)>32)
			{
				r=i;
				break;
			}
		}
		return(s.substr(l,r+1-l));
	}
	
	function load_pixl_done()
	{
		var i;
		var it;
		var x,y,p;
				
		_root.bmc.remember( "back_pixl" , bmcache.create_img , //this is safe as it only works once
		{
			url:"back_pixl" ,
			bmpw:400 , bmph:300 , bmpt:true ,
			hx:0 , hy:0 ,
			onload:null
		} );
		
		setup_pixl(pixl_url);
		
		for(y=0;y<pixl_h;y++)
		{
			for(x=0;x<pixl_w;x++)
			{
				p=pixl_col[x+y*pixl_w];
				
				if(p.i!=0)
				{
					it=setup_item(p,x,y);
					it.idx=itm.length;
					itm[itm.length]=it;
					it.num=x+y*pixl_w;
					it.basenum=it.num;
					pixl_array[it.num]=it;
				}
			}
		}
		
		for(i=0;i<256;i++) // randomize
		{
			swap_pixls(rnd()%16,rnd()%16,rnd()%16,rnd()%16);
		}
		
		if(gd)
		{
			acts=null;
			gmsgsend( { gcmd:"acts" , gnam:gd.gamename , gtim:0 , gtyp:"watch" } ); // request recap of all acts and add me to the list of people to send new msgs too
		}
		
		state="play";
	}


	function load_pixl()
	{		
		pixl_radar=new flash.display.BitmapData(pixl_w,pixl_h,true,0x00000000);
		
		_root.bmc.remember( pixl_url , bmcache.create_url , //this is safe as it only works once
		{
			url:pixl_url ,
			bmpw:pixl_w , bmph:pixl_h , bmpt:true ,
			hx:0 , hy:0 ,
			onload:delegate(load_pixl_done)
		} );
		
	}
		
	function setup_pixl(nam)
	{
	var x,y,c,sc,t,p;
	
		pixl_back_base=_root.bmc.getbmp("back_pixl");
		
		pixl_bmp=_root.bmc.getbmp(nam);
		pixl_typ_count=0;
		pixl_typ=[];
		pixl_col=[];
		pixl_array=[];

		mcs[1].attachBitmap(pixl_bmp,0,"always",false);
		mcs[2].attachBitmap(pixl_radar,0,"always",false);
		
// make transparent as color 0 always
		
		t={};
		t.sc="x0";
		t.c=0;
		t.i=pixl_typ_count;
		
		pixl_typ[t.sc]=t;
		pixl_typ[t.i]=t;
		pixl_typ_count++;
		
						
		for(y=0;y<pixl_h;y++)
		{
			for(x=0;x<pixl_w;x++)
			{
				c=pixl_bmp.getPixel32(x,y);
				
				c=c&0xf0f0f0f0; // only allow 4bits per rgb
				
				if((c&0x80000000)==0) // force capped transparancy
				{
					c=0;
					sc="x0";
				}
				else
				{
					c=c|0xff000000;
					sc="c"+(c&0xffffff); // force a storage string id
				}
				
				if(!pixl_typ[sc]) // make new?
				{
					t={};
					t.sc=sc;
					t.c=c;
					t.i=pixl_typ_count;
					
					pixl_typ[t.sc]=t;
					pixl_typ[t.i]=t;
					pixl_typ_count++;
				}
				
				p=pixl_typ[sc];
				pixl_col[x+y*pixl_w]=p;
			}
		}
		
		setup_tiles();
		
		gfx.set_text_html(mcs[4].tf,12,0xffffff,"<p align='center'>"+pixl_name+"</p>");
	}
	
	function setup_tiles()
	{
	var i,j;
	
		tiles=new flash.display.BitmapData(pixl_typ_count*16,16,true,0x00000000);
		
		for(i=0;i<pixl_typ_count;i++)
		{
		var bse;
		var hih;
		var low;
		var c,d;
		
			bse=pixl_typ[i].c;
			hih=0xff000000;
			low=0xff000000;
			for(j=0;j<3;j++)
			{
				c=( bse&(0xff<<(j*8)) ) >> (j*8);
				
				d=c+0x10;
				
				if(d>255) { d=255; }
				if(d<0)   { d=0;   }
				
				hih+=(d<<(j*8));
				
				
				c=( bse&(0xff<<(j*8)) ) >> (j*8);
				
				d=c-0x10;
				
				if(d>255) { d=255; }
				if(d<0)   { d=0;   }
				
				low+=(d<<(j*8));
			}
			
			if(bse)
			{
				tiles.fillRect(new flash.geom.Rectangle( 0+i*16,  0, 16, 16), bse);
				tiles.fillRect(new flash.geom.Rectangle( 0+i*16,  0,  2, 14), hih);
				tiles.fillRect(new flash.geom.Rectangle( 0+i*16,  0, 14,  2), hih);
				tiles.fillRect(new flash.geom.Rectangle(14+i*16,  2,  2, 14), low);
				tiles.fillRect(new flash.geom.Rectangle( 2+i*16, 14, 14,  2), low);
			}
		}
	}
	
	
//find which item is under the x,y pos
	function get_hit_item(x,y)
	{
	var i,it,im;
	var xm,ym;
		xm=x-16;
		ym=y-16;		
		im=itm.length;
		for(i=0;i<im;i++)
		{
			it=itm[i];
			
			if( (it._x<=x) && (it._y<=y) && (it._x>xm) && (it._y>ym) )
			{
				return it;
			}
		}
		
		return null;
	}
	
	var got_right;
	var got_perfect;
	var got_tw;
	
	var frame;
	var game_start_ms;
	
	function update()
	{
	var i,it,dx,dy;
	var s;
	
		_root.bmc.check_loading();
		
		
		if(state=="load")
		{
			gfx.set_text_html(mc_loading.tf,32,0xffffff,"<p align='center'><br><br><br>Loading</p>");
			
			mc._visible=false;
			mc_loading._visible=true;
			return;
		}
		else
/*
		if(state=="done")
		{
			return;
		}
		else
*/
		{
			mc._visible=true;
			mc_loading._visible=false;
		}
		
		
		frame++;
	
		if(tween_count>0)
		{
			tween_count--;
			
			if(tween_count>0)
			{
				for(i=0;i<itm.length;i++)
				{
					it=itm[i];
					it.t=0;
					it.tw=0;
					dx=(it.tx-it._x)*0.35;
					dy=(it.ty-it._y)*0.35;
					if((dx>0)&&(dx< 1)) dx= 1;
					if((dx<0)&&(dx>-1)) dx=-1;
					if((dy>0)&&(dy< 1)) dy= 1;
					if((dy<0)&&(dy>-1)) dy=-1;
					it._x+=Math.round(dx);
					it._y+=Math.round(dy);
				}
			}
			else
			{
				for(i=0;i<itm.length;i++)
				{
					it=itm[i];
					it._x=it.tx;
					it._y=it.ty;
				}
			}
		}
		
		hit_update(hit);
		
		bms[0].copyPixels( pixl_back_base , new flash.geom.Rectangle(0,0,400,300) , new flash.geom.Point( 0 , 0 ) );

//		bms[0].fillRect(new flash.geom.Rectangle(0, 0, maxx, maxy), 0x00000000);
		
		pixl_radar.fillRect(new flash.geom.Rectangle(0, 0,pixl_w,pixl_h), 0x00000000);
		
		got_right=0;
		got_perfect=0;
		got_tw=0;
		for(i=0;i<itm.length;i++)
		{
			update_item(itm[i]);
		}
		bonus_mult=( 1 + (got_perfect/itm.length) ) * itm.length/64;
		
		var bscore;
		bscore=9000-Math.floor((getTimer()-game_start_ms)/100);
		if(bscore<0) { bscore=0; }
		bscore= Math.floor( bscore*bonus_mult );
		
		
		if(state!="done")
		{
			s="<p align='center'>"+bscore+"</p>";
			gfx.set_text_html(mcs[3].tf1,16,0xffffff,s);
		
		
			s="<p align='center'>"+Math.floor((got_right/itm.length)*100)+"%</p>";
			gfx.set_text_html(mcs[3].tf2,16,0xffffff,s);
		
			s="<font size=\"8\"><p align=\"center\"><b>";
			for(i=0;i<10;i++) // find and remove
			{
				if(actors_active[i])
				{
					s+=actors_active[i]+"<br>";
				}
				else
				{
					break;
				}
			}
			s+="</b></p></font>";
			gfx.set_text_html(mcs[3].tf3,16,0xffffff,s);
		}
		
//		bms[0].copyPixels(pixl_bmp   , new flash.geom.Rectangle(0,0,pixl_w,pixl_h) , new flash.geom.Point( 8 , 8 ) );
//		bms[0].copyPixels(pixl_radar , new flash.geom.Rectangle(0,0,pixl_w,pixl_h) , new flash.geom.Point( 40 , 8 ) );
		
		hit_draw(hit);

// check for end of game

		if(state!="done")
		{
			if(got_right==itm.length) // finished
			{
				gmsgsend( { gcmd:"done" , gnam:gd.gamename , garg:bscore , gtyp:"done"} ); // we won
				state="done";
			}
			else
			if(bscore==0) // timed out
			{
				gmsgsend( { gcmd:"done" , gnam:gd.gamename , garg:bscore , gtyp:"time"} ); // we timed out
				state="done";
			}
		}
		else // handle end of game states
		{
		
// first wait for animation to end

			if(got_tw==0) // let animations finish before we do anything
			{
				if(state_done=="play")
				{
					state_done="high";
					up.up.high.setup();
				}
				else
				if(state_done=="high")
				{
					if(up.up.high.state=="done")
					{
						up.up.state_next="play";
						state_done="done";
					}
				}
			}
			
		}

	}
	
	function button(m,nam,typ)
	{
	var i,it;
	
		switch(nam)
		{
			case "orig":
				switch(typ)
				{
					case "press":
					
						if(state=="done") { break; }
						for(i=0;i<itm.length;i++)
						{
							it=itm[i];
							it.tx=it.ox;
							it.ty=it.oy;
						}
						tween_count=15;
						tween_do=true;
						_root.wetplay.PlaySFX("sfx_swish",0);
					break;
					
					case "click":
					case "out":
						for(i=0;i<itm.length;i++)
						{
							it=itm[i];
							it.tx=it.bx;
							it.ty=it.by;
						}
						tween_count=15;
						tween_do=false;
						_root.wetplay.PlaySFX("sfx_swish",0);
					break;
				}
			break;
			case "link":
				switch(typ)
				{
					case "click":
						_root.wetplay.PlaySFX("sfx_object",0);
						getURL(pixl_link,"_blank");
					break;
					case "on":
//						_root.wetplay.PlaySFX("sfx_swish",0);
						_root.poker.ShowFloat(pixl_text,25*10);
					break;
					case "off":
					case "out":
						_root.poker.ShowFloat(null,0);
					break;
				}
			break;
		}
	}
	
	function make_button(m,nam)
	{
		m.onPress=delegate(button,m,nam,"press");
		m.onRelease=delegate(button,m,nam,"click");
		m.onRollOver=delegate(button,m,nam,"on");
		m.onRollOut=delegate(button,m,nam,"off");
		m.onReleaseOutside=delegate(button,m,nam,"out");
	}
	
	
	
	function thunk()
	{
		if(!gd) { return; }
		
		if(acts==null) // wait for acts to fill up
		{
//			hud.turn_str("<p align=\"center\">Please wait for network connection.</p>");
//			turnactive=false;
		}
		else
		{
/*
			if(acts[turn]) // we have a recorded turn to play
			{
				hud.turn_str("<p align=\"center\"><font color=\"#ffffff\"><b>Please wait whilst the recorded turns are replayed.</font></b></p>");
				turnactive=false;
				hud.butt_ids["pass1"]._visible=false;
				hud.butt_ids["pass2"]._visible=false;
			}
			else
			if( (turn&1) == player )
			{
				hud.turn_str("<p align=\"center\"><font color=\"#88ff88\"><b>You have no chance to survive make your time.</font></b></p>");
				turnactive=true;
				hud.butt_ids["pass1"]._visible=true;
				hud.butt_ids["pass2"]._visible=true;
			}
			else
			{
				hud.turn_str("<p align=\"center\"><font color=\"#ff8888\"><b>Waiting for the other player.</font></b></p>");
				turnactive=false;
				hud.butt_ids["pass1"]._visible=false;
				hud.butt_ids["pass2"]._visible=false;
			}
*/
		}
		
	}
	
	function bump_actor(idx)
	{
	var i;
	var s=actors[idx];
	
		if(!s) { return; }
		
		for(i=0;i<actors_active.length;i++) // find and remove
		{
			if(actors_active[i]==s)
			{
				actors_active.splice(i,1);
				break;
			}
		}
		actors_active.splice(0,0,s); // insert at begioning
	}
	
	function set_actors(s)
	{
	var i;
		if(s=="-") // no active actors yet
		{
			actors=[];
		}
		else
		{
			actors=s.split(";");
		}
		
/*
		for(i=0;i<actors.length;i++) // add to list
		{
			bump_actor(i);
		}
*/
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
	
	
	function do_act(m)
	{
	var a;
	var x1,x2,y1,y2,i1,i2;
	
		a=m.split("/");
		
		i1=Math.floor(a[0]);
		i2=Math.floor(a[1]);
		
		x1=i1%16;
		y1=(i1-x1)/16;
		
		x2=i2%16;
		y2=(i2-x2)/16;
		
		swap_pixls(x1,y1,x2,y2);
	}
	
	function gmsgback(msg,sentmsg)
	{
	var idx;
	var s;
	var a,i,aa,j;
	
	
		if(game_done)	{	return;	} // ignore any left over msgs

		if(!sentmsg) // incoming
		{
//dbg.print("msgrecv : ***");
//dbg.dump(msg);

			switch(msg.gcmd)
			{
				case "act":
				
					if(state=="done") { break; }


//					frame=Math.floor(msg.atim*25);
					game_start_ms=getTimer()-(msg.atim*1000);
					
//dbg.print( "act "+ Math.floor(msg.gtim) +" : "+ msg.gdat );

					acts[ Math.floor(msg.gtim) ]=msg.gdat;
					
					
					do_act(msg.gdat);
					
					bump_actor(msg.gups-1); // push this player to top of active actor list
					
					thunk();
					
				break;
				
				case "style":
				
					switch(msg.gvar)
					{
						case "ups":
							set_actors(msg.gset);
						break;
					}

				break;
				
				case "done":
				
//					up.up.state_next="play"; // next arena level ( pull in styles from the server again )

// build final score
					if(!game_done)
					{
						up.score=9000-Math.floor((msg.atim*1000)/100);
						if(up.score<0) { up.score=0; }
						up.score= Math.floor( up.score*bonus_mult );


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
						
//dbg.dump(styles);

					load_pixl_id(styles.seed);
		
				break;
				
				case "acts":
				
//					frame=Math.floor(msg.atim*25);
					game_start_ms=getTimer()-(msg.atim*1000);
				
//dbg.print("acts");

					acts=new Array();
				
					a=msg.gret.split(";");
					for(i=0;i<a.length;i++)
					{
						a[i]=a[i].split(",");
					}
					
					if(a[0][0]=="OK")
					{
						a[0].splice(0,1); // throw away the OK
						
						for(i=0;i<a.length;i++)
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
						
						for(i=1;i<acts.length;i++)
						{
							do_act(acts[i]);
						}
					}
					else
					{
					}
					
					set_actors(msg.gset);

					thunk();
 	
				break;
				
				default:
				break;
			}
		}
	}
	
}
