/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) http://www.WetGenes.com/ 2009
//
// This file made available under the terms of The MIT License : http://www.opensource.org/licenses/mit-license.php
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//
//
/*+-----------------------------------------------------------------------------------------------------------------+*/

#SWF_VERSION = SWF_VERSION or 8

#CLASSNAME = CLASSNAME or "gfx"

#GFX=CLASSNAME

#DEFAULT_FONT=DEFAULT_FONT or "Bitstream Vera Sans"
//#DEFAULT_FONT=DEFAULT_FONT or "Linux Libertine"

class #(CLASSNAME)
{

	static function create_text_edit(mc,depth,x,y,w,h)
	{
		var t	:TextField;
	
		if(mc.newdepth==undefined)	{	mc.newdepth=0;	}
		if(depth==null)		{	depth=++mc.newdepth;	}

		mc.createTextField( "tf"+depth , depth , x , y , w , h );
		t=mc["tf"+depth];
		t.embedFonts=true;
		t.html=false;
		t.multiline=false;
		t.wordWrap=false;
		t.type="input";
		t.selectable=true;
		t.onSetFocus = function()	// activate on click bug fix...
		{
			var ci = (int)Selection.getCaretIndex();
			if(ci<0) {ci=0;}
			Selection.setFocus(this);
			Selection.setSelection(0,0);
			Selection.setSelection(ci,ci);
		}

		t.setNewTextFormat(create_text_format(16,0xffffffff));
		
		return t;
	}

	static function create_text(mc:MovieClip,depth:Number,x:Number,y:Number,w:Number,h:Number)
	{
		var t	:TextField;
	
		if(mc.newdepth==undefined)	{	mc.newdepth=0;	}
		if(depth==null)		{	depth=++mc.newdepth;	}

		mc.createTextField( "tf"+depth , depth , x , y , w , h );
		t=mc["tf"+depth];
		t.type="dynamic";
		t.embedFonts=true;
		t.html=false;
		t.multiline=true;
		t.selectable=true;
		t.wordWrap=false;
//		t.cacheAsBitmap=true;
	
		t.setNewTextFormat(create_text_format(16,0xffffffff));
		
		return t;
	}
	
	static function create_text_format(fntsiz,fntcol,boldit)
	{
		var t;
		
		t=new TextFormat();
		
//		t.font="Bitstream Vera Sans";
		t.font="#(DEFAULT_FONT)";
		t.color=fntcol&0xffffff;
		t.size=fntsiz;
		t.bold=boldit?true:false;
		
		return t;
	}
	
	static function create_text_html(mc:MovieClip,depth:Number,x:Number,y:Number,w:Number,h:Number)
	{
		var t	:TextField;
		var f;
		
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

		t.setNewTextFormat(create_text_format(16,0xffffffff));

		return t;
	}
	static function set_text_html(tf,fntsiz,fntcol,str)
	{
	var s;
	
//		s="<font face=\"Bitstream Vera Sans\" size=\""+fntsiz+"\" color=\"#"+Sprintf.format("%06x",fntcol&0xffffff)+"\">";
		s="<font face=\"#(DEFAULT_FONT)\" size=\""+fntsiz+"\" color=\"#"+((fntcol&0xffffff).toString(16))+"\">";
		s+=str;
		s+="</font>";
		tf.htmlText=s;	
		return s;
	}

	static function create_clip(mc:MovieClip,depth:Number,px,py,sx,sy,rot)
	{
		var r	:MovieClip;
	
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
	
	static function add_clip(mc:MovieClip,str:String,depth:Number,px,py,sx,sy,rot)
	{
		var r	:MovieClip;
	
		if(mc.newdepth==undefined)	{	mc.newdepth=0;	}
		if(depth==null)		{	depth=++mc.newdepth;	}
		
		r=mc.attachMovie(str,"mc"+depth,depth);
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
	
	static function clear(mc)
	{
		mc.style=[];
		mc.style.out=0xffffffff;
		mc.style.fill=0xffffffff;
		mc.clear();
	}

// build a rounded button(drawing) and return a html tf we can write stuff into
// use mc.style for colors / etc
	static function create_rounded_text_button(mc:MovieClip,depth:Number,x:Number,y:Number,w:Number,h:Number,b,c,l)
	{
		var tf:TextField;
		
		if(b==null) { b=3; }
		if(c==null) { c=8; }
		if(l==null) { l=2; }
		draw_rounded_rectangle(mc,b,c,l,x,y,w,h);

		tf=#(GFX).create_text_html(mc,depth,x,y,w,h);
		
		return tf;
	}

	static function draw_rounded_rectangle(mc:MovieClip,b:Number,c:Number,l:Number,x:Number,y:Number,w:Number,h:Number)
	{
		if(l!=0) { mc.lineStyle(l,mc.style.out&0xffffff,((mc.style.out>>24)&0xff)*100/255); }
		else     { mc.lineStyle(undefined,undefined); }
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
		if(l!=0) { mc.lineStyle(l,mc.style.out&0xffffff,((mc.style.out>>24)&0xff)*100/255); }
		else     { mc.lineStyle(undefined,undefined); }
		mc.moveTo(x,y);
		mc.beginFill(mc.style.fill&0xffffff,((mc.style.fill>>24)&0xff)*100/255);
		mc.lineTo(x+w,y);
		mc.lineTo(x+w,y+h);
		mc.lineTo(x,y+h);
		mc.lineTo(x,y);
		mc.endFill();
	}

	static function draw_box_xgrad(mc:MovieClip,l:Number,x:Number,y:Number,w:Number,h:Number,c1,c2)
	{
		if(l!=0) { mc.lineStyle(l,mc.style.out&0xffffff,((mc.style.out>>24)&0xff)*100/255); }
		else     { mc.lineStyle(undefined,undefined); }
		mc.moveTo(x,y);
		
		mc.beginGradientFill("linear", [c1&0xffffff, c2&0xffffff], [((c1>>24)&0xff)*100/255, ((c2>>24)&0xff)*100/255], [0, 255], {matrixType:"box", x:x, y:y, w:w, h:h, r:0/180*Math.PI});

		mc.lineTo(x+w,y);
		mc.lineTo(x+w,y+h);
		mc.lineTo(x,y+h);
		mc.lineTo(x,y);
		mc.endFill();
	}
	
	static function draw_box_ygrad(mc:MovieClip,l:Number,x:Number,y:Number,w:Number,h:Number,c1,c2)
	{
		if(l!=0) { mc.lineStyle(l,mc.style.out&0xffffff,((mc.style.out>>24)&0xff)*100/255); }
		else     { mc.lineStyle(undefined,undefined); }
		mc.moveTo(x,y);
		mc.beginGradientFill("linear", [c1&0xffffff, c2&0xffffff], [((c1>>24)&0xff)*100/255, ((c2>>24)&0xff)*100/255], [0, 255], {matrixType:"box", x:x, y:y, w:w, h:h, r:90/180*Math.PI});
		mc.lineTo(x+w,y);
		mc.lineTo(x+w,y+h);
		mc.lineTo(x,y+h);
		mc.lineTo(x,y);
		mc.endFill();
	}
	
	static function draw_fcirc4(mc:MovieClip,l:Number,x1,y1,x2,y2,x3,y3,x4,y4)
	{
		if(l!=0) { mc.lineStyle(l,mc.style.out&0xffffff,((mc.style.out>>24)&0xff)*100/255); }
		else     { mc.lineStyle(undefined,undefined); }
		
		mc.moveTo( (x1+x2)/2 , (y1+y2)/2 );
		mc.beginFill(mc.style.fill&0xffffff,((mc.style.fill>>24)&0xff)*100/255);
		
		mc.curveTo(x2,y2,(x2+x3)/2 , (y2+y3)/2);
		mc.curveTo(x3,y3,(x3+x4)/2 , (y3+y4)/2);
		mc.curveTo(x4,y4,(x4+x1)/2 , (y4+y1)/2);
		mc.curveTo(x1,y1,(x1+x2)/2 , (y1+y2)/2);
		
		mc.endFill();
	}
	
	static function adjust_allmovieclips(base,funk)
	{
	var child;
	
		for(var nam in base)
		{
			child=base[nam];
			
		    if(typeof(child) == "movieclip")
			{
				adjust_allmovieclips(child,funk);
		    }
		}
		funk(base);
	}
	
	static function setscroll(mc,minx,miny,sizx,sizy)
	{
#if SWF_VERSION>=8 then	
		mc.scrollRect=new flash.geom.Rectangle(minx, miny, sizx, sizy);
#end
/*	
		if(!mcm)
		{
//		mcm.removeMovieClip();
			mcm=#(GFX).create_clip(up.mc,null);
//			mcm._visible=false;
			mc.setMask(mcm);
		}
		
		#(GFX).clear(mcm);
		#(GFX).draw_box(mcm,null,x,y,w,h);		
*/

	}
	
	static function dropshadow(mc,a,b,c,d,e,f,g,h)
	{
#if SWF_VERSION>=8 then	
			mc.filters = [ new flash.filters.DropShadowFilter(a, b, c, d, e, f, g, h) ];
#end			
	}
	
	static function glow(mc,a,b,c,d,e,f,g,h)
	{
#if SWF_VERSION>=8 then	
			mc.filters = [ new flash.filters.GlowFilter(a, b, c, d, e, f, g, h) ];
#end			
	}
	
	static function blur(mc,a,b,c)
	{
#if SWF_VERSION>=8 then	
			mc.filters = [ new flash.filters.BlurFilter(a, b, c) ];
#end			
	}
	
	static function blurglow(mc,aa,bb,cc,a,b,c,d,e,f,g,h)
	{
#if SWF_VERSION>=8 then	
			mc.filters = [ new flash.filters.BlurFilter(aa, bb, cc) , new flash.filters.GlowFilter(a, b, c, d, e, f, g, h) ];
#end			
	}
	
	static function clear_filters(mc)
	{
		mc.filters=null;
	}

}
