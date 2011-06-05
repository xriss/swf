/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) Kriss Daniels 2006 http://www.XIXs.com
//
/*+-----------------------------------------------------------------------------------------------------------------+*/

#ROCKS_MAX=64
#ROCKS_SIZE=9

#SHOTS_MAX=16
#SHOTS_SIZE=6

#PART_BOUNCE=function(x,y,xv,yv,r,sfx_func)
#
					if(#(x) <   0+#(r) ) { #(x)=0+#(r);		if(#(xv)<0) { #(xv)=-#(xv)} #(sfx_func) }
					if(#(x) > 800-#(r) ) { #(x)=800-#(r); 	if(#(xv)>0) { #(xv)=-#(xv)} #(sfx_func) }
					if(#(y) <   0+#(r) ) { #(y)=0+#(r);		if(#(yv)<0) { #(yv)=-#(yv)} #(sfx_func) }
					if(#(y) > 600-#(r) ) { #(y)=600-#(r); 	if(#(yv)>0) { #(yv)=-#(yv)} #(sfx_func) }
#
#end

#PART_WRAP=function(x,y,xv,yv,r)
#
					if(#(x) <   0 ) { #(x)+=800; }
					if(#(x) > 800 ) { #(x)-=800; }
					if(#(y) <   0 ) { #(y)+=600; }
					if(#(y) > 600 ) { #(y)-=600; }
#
#end

#PART_EDGE=PART_BOUNCE


#MAX_SPEED=8
#LIMIT_SPEED=function(v)
	if(#(v)<-#(MAX_SPEED)) { #(v)=-#(MAX_SPEED); }
	if(#(v)> #(MAX_SPEED)) { #(v)= #(MAX_SPEED); }
#end


import com.dynamicflash.utils.Delegate;



class recoil_game
{
	var main:recoil;
	
	var mc:MovieClip;
	
	var back_mc:MovieClip;
	var action_mc:MovieClip;
	var info_mc:MovieClip;
	var score_txt;
	
	var shots_data:Array;
	var shots_last:Number;

	var rocks_data:Array;
	var rocks_last:Number;
	var rocks_sizes:Array;
	var rocks_counts:Array;
	var rocks_colors:Array;

	var	time_f:Number;
	var time_s:Number;
	var score:Number;


	var ship_x:Number;
	var ship_y:Number;
	var ship_xv:Number;
	var ship_yv:Number;
	
	var ship_reload:Number;
	
	var sfx_pop_order	:Array;
	var sfx_pop_idx		:Number;
	
	function delegate(f:Function) { return Delegate.create(this,f); }

	function recoil_game(t)
	{
		main=t;
		setup();
		clean();
	}
	
	function setup()
	{
		main.replay.reset();
		
		if(!mc) // initial setup
		{
			var t;
			var s;
			
			mc=gfx.create_clip(_root);
			mc.t=this;
			
			action_mc=gfx.create_clip(mc);
			info_mc=gfx.create_clip(mc);
			
			shots_data=new Array(#(SHOTS_SIZE*SHOTS_MAX));
			rocks_data=new Array(#(ROCKS_SIZE*ROCKS_MAX));
			rocks_sizes=new Array(7);

			rocks_sizes=[0,32,48,64,80,100,120];
			rocks_counts=[0,1,2,4,8,16,32];
			rocks_colors=[0xff0000,0xffff00,0x0000ff,0x00ffff];

			sfx_pop_order=[4,3,2,1,3,2,1,6,2,1,6,5,1,5,8,7,8,5,6,8,5,6,1,1,2,3,2,1,1,2,3];
		}
		else
		{
			action_mc.removeMovieClip();
			action_mc=gfx.create_clip(mc);
		}
		
		info_mc.removeMovieClip();
		info_mc=gfx.create_clip(mc);
		
		{
		var cm;
		var cmi;
		var f;
			cm = new ContextMenu();
			f=function()	{	_root.click_next()	};
			cmi = new ContextMenuItem("Quit this game...", f )
			cm.customItems.push(cmi);
			_root.menu=cm;
		}

		sfx_pop_idx=0;

		var i;
		
		for(i=0;i<#(SHOTS_SIZE*SHOTS_MAX);i++)
		{
			shots_data[i]=0;
		}
		shots_last=0;

		for(i=0;i<#(ROCKS_SIZE*ROCKS_MAX);i++)
		{
			rocks_data[i]=0;
		}
		rocks_last=0;

		time_f=0;
		time_s=60;
		
		ship_x=200;
		ship_y=300;
		ship_xv=0;
		ship_yv=0;
		ship_reload=0;
		
		add_rock(600,300,Math.random()*360,-0.5,-0.5,0,6,0);

		action_mc.createEmptyMovieClip("puck",999);
		action_mc.puck.attachMovie("puck","puck",999);
		action_mc.puck.puck._x=-64;
		action_mc.puck.puck._y=-64;
		
		_root.click_next=function()
		{
			_root.main.game.time_f=0;
			_root.main.game.time_s=0;
			_root.main.title.state=recoil_title.STATE_SCORES;
			_root.main.state_next=recoil.STATE_TITLE;
			_root.click_next=null;
		}

		mc._visible=true;
		
		info_mc.newdepth=1;
		score_txt=gfx.create_text_html(info_mc,info_mc.newdepth,0,0,300,100);
		score_txt._alpha=40;

		if(main.replay.state==Replay.STATE_PLAY)
		{
		var t;
		var s;
		
			info_mc.newdepth+=1;
			t=gfx.create_text_html(info_mc,info_mc.newdepth,50,500,800,100);
			s="";
			s+="<font face=\"Bitstream Vera Sans\" size=\"32\" color=\"#00ffff\">";
			s+="<a href=\"asfunction:_root."+_root.click_name+",exit\"><b>";
			s+="Click here to exit this replay.</b></a><br>";
			s+="</font>";
			
			t._alpha=40;
			t.htmlText=s;

			_root[_root.click_name]=delegate(click_id);
		}
	}
	
	function click_id(id:String)
	{
		main.title.state=recoil_title.STATE_SCORES;
		main.state_next=recoil.STATE_TITLE;
	}

	function add_shot(x,y,xv,yv,s)
	{
		shots_data[shots_last+0]=s;
		shots_data[shots_last+1]=x;
		shots_data[shots_last+2]=y;
		shots_data[shots_last+3]=xv;
		shots_data[shots_last+4]=yv;
		shots_data[shots_last+5]=s;
		
		shots_last+=#(SHOTS_SIZE);
		if(shots_last>=#(SHOTS_SIZE*SHOTS_MAX)) { shots_last=0; }
		
		play_shot();
	}

	function build_rock(tmc,rad,id_base,id_count)
	{
		var x,y;
		var i;
		var t;
		var sr,cr;

		for(i=id_base;i<id_base+id_count;i++)
		{
			if(id_count==1)
			{
				x=0;
				y=0;
			}
			else
			if(id_count==2)
			{
				x=0;
				y=-8+(16*(i-id_base));
			}
			else
			if(id_count==4)
			{
				switch( i-id_base )
				{
					case 0: x=-8;y=-8; break;
					case 1: x= 8;y=-8; break;
					case 2: x=-8;y= 8; break;
					case 3: x= 8;y= 8; break;
				}
			}
			else
			{
				x=rad;
				y=rad;
				while( (((x*x)+(y*y))>((rad-16)*(rad-16))) || (((x*x)+(y*y))<(8*8)) )
				{
					x=(Math.random()-0.5)*rad*2;
					y=(Math.random()-0.5)*rad*2;
				}
			}
			
/*
			t=tmc.createEmptyMovieClip("p"+i,i);
			drawbox(t,0,0,32,32,rocks_colors[i%4],100);
			t._rotation=Math.random()*360;
			t._x=x;
			t._y=y;
*/

			t=tmc.attachMovie("puck","p"+i,i);
			t._xscale=100+(Math.random()*20);
			t._yscale=100+(Math.random()*20);
			t._x=x-((64*t._xscale)/100);
			t._y=y-((64*t._xscale)/100);
			t.gotoAndStop(2+(i%5));
			

/*
			t=tmc.attachMovie("p"+(i%16),"p"+i,i);
			t._xscale=100;
			t._yscale=100;
			t._rotation=Math.random()*360;
			cr=Math.cos(Math.PI*t._rotation/180)*-16;
			sr=Math.sin(Math.PI*t._rotation/180)*-16;
			t._x=x+(cr-sr);
			t._y=y+(cr+sr);
*/
		}
	}

	function add_rock(x,y,z,xv,yv,zv,s,id)
	{
		rocks_data[rocks_last+0]=s;
		rocks_data[rocks_last+1]=x;
		rocks_data[rocks_last+2]=y;
		rocks_data[rocks_last+3]=xv;
		rocks_data[rocks_last+4]=yv;
		rocks_data[rocks_last+5]=id;
		rocks_data[rocks_last+6]=gfx.create_clip(action_mc);
		
		build_rock(rocks_data[rocks_last+6],rocks_sizes[s]/2,id,rocks_counts[s])

		rocks_data[rocks_last+7]=z;
		rocks_data[rocks_last+8]=zv;

		
		rocks_last+=#(ROCKS_SIZE);
//		if(rocks_last>=#(ROCKS_SIZE*ROCKS_MAX)) { rocks_last=0; }
	}

	function update()
	{
		main.replay.update();
		
		var i,j,tf;
		
		if(_root.jingle==null)
		{
			_root.jingle=_root.attachMovie("jingle_start","jingle",-999);
		}
		
		time_f-=1;
		if(time_f<0) { time_f+=30; time_s-=1; }
		if(time_s<0)
		{
			time_f=0;
			time_s=0;
			
			_root.main.title.state=recoil_title.STATE_LOSE;
			_root.main.state_next=recoil.STATE_TITLE;
		}
		
		tf=Math.floor((time_f*100)/30);
		if(tf<10) tf="0"+tf;
		
		var s="";
		s+="<font face=\"Bitstream Vera Sans Mono\" size=\"64\" color=\"#ffffff\">";
		if(time_s<100) { s+=' '; }
		if(time_s<10) { s+=' '; }
		s+= time_s + ":" +  tf;
		s+="</font>";
		score_txt.htmlText=s;


		
		action_mc.clear();


		ship_reload--;
		if( (main.replay.key&Replay.KEYM_MBUTTON) && (ship_reload<=0) )	// shoot, but not too fast
		{
			var x,y;
			var xa,ya;
			
			main.replay.record_mouse();
			x=(main.replay.mouse_x+400)-ship_x;
			y=(main.replay.mouse_y+300)-ship_y;

			trace( "shoot=" + main.replay.frame + " : " + main.replay.mouse_x + " , " + main.replay.mouse_y )
			
			xa=Math.abs(x);
			ya=Math.abs(y);
			
			if( xa > ya )
			{
				x=x/xa;
				y=y/xa;
			}
			else
			if( xa < ya )
			{
				x=x/ya;
				y=y/ya;
			}
			else
			{
				x=0;
				y=0;
			}
			
			xa=/*ship_xv+*/(x*16);
			ya=/*ship_yv+*/(y*16);
			add_shot(ship_x+xa,ship_y+ya,xa,ya,8);

			ship_xv-=x*4;
			ship_yv-=y*4;
		
		
			ship_reload=8;
			_root.mouseup=0;
		}
		
		var x,y;
		var xd,yd;
		var xdd,ydd;
		var rr;
		var t;

		for(i=0;i<#(SHOTS_SIZE*SHOTS_MAX);i+=#(SHOTS_SIZE))
		{
			if(shots_data[i]>0) // size / alive number
			{
				shots_data[i+0]-=0.5;
				shots_data[i+1]+=shots_data[i+3];
				shots_data[i+2]+=shots_data[i+4];
				
#PART_EDGE('shots_data[i+1]','shots_data[i+2]','shots_data[i+3]','shots_data[i+4]',6)
//				if(shots_data[i+1] <   0 ) { shots_data[i+1]+=800; }
//				if(shots_data[i+1] > 800 ) { shots_data[i+1]-=800; }
//				if(shots_data[i+2] <   0 ) { shots_data[i+2]+=600; }
//				if(shots_data[i+2] > 600 ) { shots_data[i+2]-=600; }
				
				drawbox(action_mc,shots_data[i+1],shots_data[i+2],12,12,0xffffff,100);//25+shots_data[i+0]*8);

				for(j=0;j<rocks_last;j+=#(ROCKS_SIZE))
				{
					if(rocks_data[j]>0) // size / alive number
					{
						xd=rocks_data[j+1]-shots_data[i+1];
						xdd=xd*xd;
						yd=rocks_data[j+2]-shots_data[i+2];
						ydd=yd*yd;
						rr=(rocks_sizes[rocks_data[j]]/2)+4;
						rr=rr*rr;
						if( (xdd+ydd) < rr ) // hit
						{
							if(rocks_data[j]>1)
							{
								var vx,vy,r,ri;
								
								vx=(shots_data[i+4])*0.125;
								vy=(-shots_data[i+3])*0.125;
								
								shots_data[i+0]=0;
								
								ri=rocks_data[j]-1;
								r=rocks_sizes[ri];
								
								add_rock(rocks_data[j+1]-(vx*r*0.125),rocks_data[j+2]-(vy*r*0.125),0,rocks_data[j+3]-vx,rocks_data[j+3]-vy,0,ri,rocks_data[j+5]+rocks_counts[ri]);
								
								rocks_data[j]=ri;
	
								rocks_data[j+1]+=vx*r*0.125;
								rocks_data[j+2]+=vy*r*0.125;
								
								rocks_data[j+3]+=vx;
								rocks_data[j+4]+=vy;
								
								t=gfx.create_clip(action_mc);
								build_rock(t,rocks_sizes[rocks_data[j]]/2,rocks_data[j+5],rocks_counts[rocks_data[j]])
								rocks_data[j+6].removeMovieClip();
								rocks_data[j+6]=t;
								
								play_pop();
							}
							else
							{
							
								rocks_data[j+0]=-rocks_data[j+0];
								rocks_data[j+6]._alpha=25;
/*						
								var vx,vy,r;
								
								vx=(shots_data[i+3])*0.25;
								vy=(shots_data[i+4])*0.25;

								rocks_data[j+3]+=vx;
								rocks_data[j+4]+=vy;
*/								
								
								shots_data[i+0]=0;
								
								play_pop();
							}
								
							break;
						}
					}
				}
			}
		}
		
		action_mc.puck.puck.gotoAndStop(1);
		
		var rock_count=0;
						
		for(i=0;i<rocks_last;i+=#(ROCKS_SIZE))
		{
			if(rocks_data[i]>0) // size / alive number
			{
				rock_count++;
				
				xd=rocks_data[i+1]-ship_x;
				xdd=xd*xd;
				yd=rocks_data[i+2]-ship_y;
				ydd=yd*yd;
				rr=(rocks_sizes[rocks_data[i]]/2)+16;
				rr=rr*rr;
				
				if( (xdd+ydd) < rr ) // hit
				{
					play_bounce();
					
//					if(rocks_data[i]>1)
					{
						x=rocks_data[i+3]-ship_xv;
						y=rocks_data[i+4]-ship_yv;
						
						rocks_data[i+3]-=x;
						rocks_data[i+4]-=y;
						
						ship_xv+=x;
						ship_yv+=y;
						
						while( (xdd+ydd) < rr )	// stop intersection
						{
							ship_x+=ship_xv;
							ship_y+=ship_yv;
							rocks_data[i+1]+=rocks_data[i+3];
							rocks_data[i+2]+=rocks_data[i+4];
							
							xd=rocks_data[i+1]-ship_x;
							xdd=xd*xd;
							yd=rocks_data[i+2]-ship_y;
							ydd=yd*yd;
							rr=(rocks_sizes[rocks_data[i]]/2)+16;
							rr=rr*rr;
						}
						ship_x-=ship_xv;
						ship_y-=ship_yv;
						rocks_data[i+1]-=rocks_data[i+3];
						rocks_data[i+2]-=rocks_data[i+4];
						
					}
//					else	// eat
//					{
//						action_mc.puck.puck.gotoAndStop(2);

//						rocks_data[i+0]=-rocks_data[i+0];
//						rocks_data[i+6].removeMovieClip();
//						rocks_data[i+6]._alpha=25;
//					}
				}
			}
						
//				if(rocks_data[i]>0) // size / alive number
//				{
//				rocks_data[i+0]-=0.25;

#LIMIT_SPEED('rocks_data[i+3]')
#LIMIT_SPEED('rocks_data[i+4]')

if(rocks_data[i+6]._alpha!=25)
{
					rocks_data[i+1]+=rocks_data[i+3];
					rocks_data[i+2]+=rocks_data[i+4];
					
					t=(Math.abs(rocks_data[i+3])+Math.abs(rocks_data[i+4]))*2;
					if(rocks_data[i+3]<0) { t=-t; }
					if(t<-20) { t=-20; } 
					if(t> 20) { t= 20; } 
					rocks_data[i+7]+=t;
}
					
#PART_EDGE('rocks_data[i+1]','rocks_data[i+2]','rocks_data[i+3]','rocks_data[i+4]','rocks_sizes[rocks_data[i+0]]/2')
//					if(rocks_data[i+1] <   0 ) { rocks_data[i+1]+=800; }
//					if(rocks_data[i+1] > 800 ) { rocks_data[i+1]-=800; }
//					if(rocks_data[i+2] <   0 ) { rocks_data[i+2]+=600; }
//					if(rocks_data[i+2] > 600 ) { rocks_data[i+2]-=600; }
					
					if(rocks_data[i+7] <   0 ) { rocks_data[i+7]+=360; }
					if(rocks_data[i+7] > 360 ) { rocks_data[i+7]-=360; }
					
//					drawbox(action_mc,rocks_data[i+1],rocks_data[i+2],rocks_sizes[rocks_data[i+0]],rocks_sizes[rocks_data[i+0]],0xff0000,50);
					
					rocks_data[i+6]._x=rocks_data[i+1];
					rocks_data[i+6]._y=rocks_data[i+2];
					rocks_data[i+6]._rotation=rocks_data[i+7];
					
//				}
		}
		
		if(rock_count==0)
		{
			_root.main.title.state=recoil_title.STATE_WIN;
			_root.main.state_next=recoil.STATE_TITLE;
		}
		
#LIMIT_SPEED('ship_xv')
#LIMIT_SPEED('ship_yv')

		ship_x+=ship_xv;
		ship_y+=ship_yv;
		
#PART_EDGE('ship_x','ship_y','ship_xv','ship_yv',16,'play_bounce();')

//		if(ship_x<0)	{		ship_x+=800;		}
//		if(ship_x>800)	{		ship_x-=800;		}
//		if(ship_y<0)	{		ship_y+=600;		}
//		if(ship_y>600)	{		ship_y-=600;		}
		
		
		var rad = Math.atan2((main.replay.mouse_y+300)-ship_y, (main.replay.mouse_x+400)-ship_x);
        var deg = Math.round((rad*180/Math.PI));
        
        action_mc.puck._rotation = deg;
        		
		action_mc.puck._x=ship_x;
		action_mc.puck._y=ship_y;
//		action_mc.puck._xscale=50;
//		action_mc.puck._yscale=50;
//		drawbox(action_mc,ship_x,ship_y,48,48,0x00ff00,100);
		
	}

	function clean()
	{
	
//		_root.jingle.stop();
//		_root.jingle.unloadMovie();
		_root.jingle=null;
		_root.menu=null;
		
		mc._visible=false;
		
		score=time_s*100 + Math.floor(time_f*100/30);

		if(main.replay.state==Replay.STATE_PLAY)
		{
			main.replay.end_play();
		}
		else
		if(main.replay.state==Replay.STATE_RECORD)
		{
			main.replay.end_record();
			
			main.scores.insert( score , main.replay.str );
		}
	}

	static function drawbox(t,x,y,w,h,rgb,a)
	{
	
		var ww=w/2;
		var hh=h/2;
	
		t.lineStyle(0,0,0);
	
		t.moveTo(x-ww,y-hh);
	
		var  colors = [ rgb,rgb,rgb ];
		var  alphas = [ a,a,0 ];
		var  ratios = [ 0,192,255 ];
		var  matrix = { matrixType:"box", x:x-ww, y:y-hh, w:w, h:h, r:(w/h)*Math.PI }; 
		
		t.beginGradientFill( "radial", colors, alphas, ratios, matrix );
//		t.beginFill(rgb,a);
	
		t.lineTo(x+ww,y-hh);
		t.lineTo(x+ww,y+hh);
		t.lineTo(x-ww,y+hh);
		t.lineTo(x-ww,y-hh);
	
		t.endFill();
	
	}
	
	function play_pop()
	{
		var sfx=new Sound();
		sfx.attachSound("sfx_p"+sfx_pop_order[sfx_pop_idx]);
		sfx.start();
		
		sfx_pop_idx++;
		
		if(sfx_pop_idx>=sfx_pop_order.length)
		{
		sfx_pop_idx=0;
		}
	}
	
	function play_shot()
	{
		var sfx=new Sound();
		sfx.attachSound("sfx_shot");
		sfx.start();
	}
	
	function play_bounce()
	{
		var sfx=new Sound();
		sfx.attachSound("sfx_bounce");
		sfx.start();
	}

}