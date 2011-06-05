/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) Kriss Daniels 2006 http://www.XIXs.com
//
/*+-----------------------------------------------------------------------------------------------------------------+*/

class gfx
{


	static function create_text_html(mc:MovieClip,depth:Number,x:Number,y:Number,w:Number,h:Number)
	{
		var t	:TextField;
	
		if(mc.newdepth==undefined)	{	mc.newdepth=0;	}
		if(depth==null)		{	depth=++mc.newdepth;	}

		mc.createTextField( "tf"+depth , depth , x , y , w , h );
		t=mc["tf"+depth];
		t.type="dynamic";
		t.embedFonts=true;
		t.html=true;
		t.multiline=true;
		t.selectable=false;
		t.wordWrap=true;
//		t.cacheAsBitmap=true;
	
		return t;
	}

	static function create_clip(mc:MovieClip,depth:Number)
	{
		var r	:MovieClip;
	
		if(mc.newdepth==undefined)	{	mc.newdepth=0;	}
		if(depth==null)		{	depth=++mc.newdepth;	}
		
		mc.newdepth+=1;
		r=mc.createEmptyMovieClip("mc"+depth,depth);
		r.newdepth=0;
		
//		r.cacheAsBitmap=true;
		return r;
	}
	
	static function add_clip(mc:MovieClip,str:String,depth:Number)
	{
		var r	:MovieClip;
	
		if(mc.newdepth==undefined)	{	mc.newdepth=0;	}
		if(depth==null)		{	depth=++mc.newdepth;	}
		
		r=mc.attachMovie(str,"mc"+depth,depth);
		r.newdepth=0;
//		r.cacheAsBitmap=true;

		return r;
	}

// build a rounded button(drawing) and return a html tf we can write stuff into
// use mc.style for colors / etc
	static function create_rounded_text_button(mc:MovieClip,depth:Number,x:Number,y:Number,w:Number,h:Number)
	{
		var tf:TextField;
		var bord:Number=6;
		var b:Number;
		var c:Number;
		
		if(mc.newdepth==undefined)	{	mc.newdepth=0;	}
		if(depth==null)		{	depth=++mc.newdepth;	}

		draw_rounded_rectangle(mc,3,8,2,x,y,w,h);

		tf=gfx.create_text_html(mc,depth,x,y,w,h);
		
		return tf;
	}

	static function draw_rounded_rectangle(mc:MovieClip,b:Number,c:Number,l:Number,x:Number,y:Number,w:Number,h:Number)
	{
		mc.lineStyle(l,mc.style.out&0xffffff,((mc.style.out>>24)&0xff)*100/255);
		mc.moveTo(x+b+c,y+b);
		mc.beginFill(mc.style.fill&0xffffff,((mc.style.fill>>24)&0xff)*100/255);
		mc.lineTo(x+w-b-c,y+b);
		mc.curveTo(x+w-b,y+b,x+w-b,y+b+c);
		mc.lineTo(x+w-b,y+h-b-c);
		mc.curveTo(x+w-b,y+h-b,x+w-b-c,y+h-b);
		mc.lineTo(x+b+c,y+h-b);
		mc.curveTo(x+b,y+h-b,x+b,y+h-b-c);
		mc.lineTo(x+b,y+b+c);
		mc.curveTo(x+b,y+b,x+b+c,y+b);
		mc.endFill();
	}

	static function draw_box(mc:MovieClip,l:Number,x:Number,y:Number,w:Number,h:Number)
	{
		mc.lineStyle(l,mc.style.out&0xffffff,((mc.style.out>>24)&0xff)*100/255);
		mc.moveTo(x,y);
		mc.beginFill(mc.style.fill&0xffffff,((mc.style.fill>>24)&0xff)*100/255);
		mc.lineTo(x+w,y);
		mc.lineTo(x+w,y+h);
		mc.lineTo(x,y+h);
		mc.lineTo(x,y);
		mc.endFill();
	}

}
