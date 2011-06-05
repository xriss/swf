
	static function create_clip(mc,depth,px,py,sx,sy,rot)
	{
		var r;
	
		if(mc.newdepth==undefined)	{	mc.newdepth=0;	}
		if(depth==null)		{	depth=++mc.newdepth;	}
		
		r=mc.createEmptyMovieClip("mc"+depth,depth);
		r.newdepth=0;
		
//		r.style=new Array();
//		r.cacheAsBitmap=_root.cacheAsBitmap;

		if(px!=null) { r._x=px; }
		if(py!=null) { r._y=py; }
		if(sx!=null) { r._xscale=sx; }
		if(sy!=null) { r._yscale=sy; }
		if(rot!=null) { r._rotation=rot; }

		return r;
	}
	
	static function create_text_format(fntsiz,fntcol,boldit)
	{
		var t;
		
		t=new TextFormat();
		
//		t.font="Bitstream Vera Sans";
//		t.font="#(DEFAULT_FONT)";
		t.color=fntcol&0xffffff;
		t.size=fntsiz;
		t.bold=boldit?true:false;
		
		return t;
	}
	
	static function create_text_html(mc,depth,x,y,w,h)
	{
		var t	:TextField;
		var f;
		
		if(mc.newdepth==undefined)	{	mc.newdepth=0;	}
		if(depth==null)		{	depth=++mc.newdepth;	}

		mc.createTextField( "tf"+depth , depth , x , y , w , h );
		t=mc["tf"+depth];
		t.html=true;
		t.multiline=true;
		t.selectable=false;
		t.wordWrap=true;

		t.setNewTextFormat(create_text_format(32,0xffffffff));

		return t;
	}

	static var rnds={};
	static function rnd_seed(id,n) { 	if(!id)id="a"; rnds[id]=n&65535; }
	static function rnd(id) // returns a number between 0 and 65535
	{
		if(!id)id="a";
		rnds[id]=(((rnds[id]+1)*75)-1)%65537; // all hail the mighty zx spectrum pseudo random number sequence
		return rnds[id];
	}

	
static var dbg_t=0;
static var dbg_i=0;

	static function dbg()
	{
		var d=new Date();
		var t=d.getTime();
		
		dbg_i--;
		if(dbg_i<=0)
		{
			m.tf.htmlText="t="+(t-dbg_t)/10+"\n";
			dbg_t=t;
			dbg_i=10;
		}
		
	}

	
	static function blob(r)
	{
	var seed=r.seed&0xffff;  // bottom 16 bits are random seed
	var style=r.seed>>16; // top 16 bits are style info
	
	var f,m,k,j,x,y,b;
	var ff,xx,yy,x2,y2;
	var ox,oy,dx,dy,d;
	
		if(style==0x0000)
		{
			r.clear();
			
			m=create_clip(r,0,32,32);
			r.f=[];
			
			
			for(f=0;f<4;f++)
			{
				m.clear();
				
				m.lineStyle(undefined,undefined);
			
				rnd_seed("_",seed);
				rnd_seed("+",seed);
			
				var c=(rnd("_")*rnd("_")+rnd("_"))&0xffffff;
				
				for(k=0;k<10;k++)
				{
					var cc=(rnd("_")*rnd("_")+rnd("_"))&0xffffff;
					
					var cmsk=0xff;
					var cmax=0xdf;
					var cmin=0x20;
				
					while(cmsk!=0xff000000)
					{
						if( (cc&cmsk) > (c&cmsk) )
						{
							if((c&cmsk)<cmax) c+=cmin;
						}
						else
						{
							if((c&cmsk)>cmin) c-=cmin;
						}
						cmsk=cmsk<<8;
						cmax=cmax<<8;
						cmin=cmin<<8;
					}
					
					for(j=0;j<20;j++)
					{
						x=((rnd("_")-32768)/32768);
						y=((rnd("_")-32768)/32768);
						
						x2=((rnd("+")-32768)/32768);
						y2=((rnd("+")-32768)/32768);
						
						xx=x*x*x + x2*x2*x2*f/10;
						yy=y*y*y + y2*y2*y2*f/10;
						
						if(j==0)
						{
							m.moveTo(xx*24,yy*24);
							m.beginFill(c,25);
						}
						else
						{
							dx=xx-ox;
							dy=yy-oy;
							d=0.125;
							if( dx> d ) dx= d;
							if( dx<-d ) dx=-d;
							
							if( dy> d ) dy= d;
							if( dy<-d ) dy=-d;
							
							xx=ox+dx;
							yy=oy+dy;
							m.lineTo(xx*30,yy*30);
						}
						ox=xx;
						oy=yy;
					}
					m.endFill();
				}
				
//				m.filters = [ new flash.filters.BlurFilter(2, 2, 1) ];
				m.filters = [ new flash.filters.GlowFilter(0xffffff,100,2,2,1,1) ];
				
				b=new flash.display.BitmapData(64,64,true,0x00000000);
				
				b.draw(r);
				
				r.f[f]=b;
			}
			
			m.clear();
			m.removeMovieClip();
			
			r.m=create_clip(r,0,-32,-32);
			blobf(r,0);
		}
	}
	
	static function blobf(r,f)
	{
		f=f%((r.f.length*2)-1);
		
		if( f >= r.f.length ) { f= ((r.f.length*2)-1) -f; }
		
		r.m.attachBitmap(r.f[f],0,"auto",true);
	}
