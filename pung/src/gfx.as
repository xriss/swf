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
	
		mc.createTextField( "tf"+depth , depth , x , y , w , h );
		t=mc["tf"+depth];
		t.type="dynamic";
		t.embedFonts=true;
		t.html=true;
		t.multiline=true;
		t.selectable=false;
		t.wordWrap=true;
	
		return t;
	}

	static function create_clip(mc:MovieClip)
	{
		var r	:MovieClip;
	
		if(mc.newdepth==undefined)
		{
			mc.newdepth=0;
		}
		
		mc.newdepth+=1;
		r=mc.createEmptyMovieClip("mc"+mc.newdepth,mc.newdepth);
	
		return r;
	}
	
	static function add_clip(mc:MovieClip,str:String)
	{
		var r	:MovieClip;
	
		if(mc.newdepth==undefined)
		{
			mc.newdepth=0;
		}
		
		mc.newdepth+=1;
		r=mc.attachMovie(str,"mc"+mc.newdepth,mc.newdepth);
	
		return r;
	}
}
