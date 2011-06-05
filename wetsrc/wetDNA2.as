//+-----------------------------------------------------------------------------------------------------------------+--
//
// (C) http://www.WetGenes.com/ 2009
//
//+-----------------------------------------------------------------------------------------------------------------+--
//

// If you are reading this in a .as file please remember that it is auto generated from lua source.
//
// scratch that I'm back in AS :)

//
class wetDNA2
{
	
	function thunk(/*this*/) {
		var t = this;
		if ((!t.thunked)) {
			var j;
			var b;
			var r;
			var x;
			var y;
			var z;
			b = (((2 * 64) * 2) * t.frame);
			j = 0;
			for (var ra = 0; ra <= Math.PI; ra += Math.PI) {
				//			local ra=0
				for (var i = 0; i <= 63; ++i) {
					r = (ra + ((Math.PI * ((i + (t.frame)))) / 32));
					x = (((-256) + 4) + (i * 8));
					y = (Math.sin(-r) * 128);
					z = (1 - ((((((Math.cos(-r) * 128)) + 128)) / 1536)));
					t.xyz[(((b + j) + (i * 2)) + 0)] = (x * z)*0.46;
					t.xyz[(((b + j) + (i * 2)) + 1)] = (y * z)*0.3;
				}
				j = (64 * 2);
			}
			if ((t.frame == 31)) {
				t.thunked = true;
			}
		}
	}
	function draw(/*this*/) {
		var t = this;
		//		local i
		var b;
		b = (((2 * 64) * 2) * t.frame);
		
		t.mc.lineStyle(8, t.color, 50);
		t.mc.moveTo(t.xyz[(b + 0)], t.xyz[(b + 1)]);
		for (var i = 2; i <= (128 - 2); i += 2) {
			t.mc.lineTo(t.xyz[((b + i) + 0)], t.xyz[((b + i) + 1)]);
		}
		t.mc.moveTo(t.xyz[((b + 128) + 0)], t.xyz[((b + 128) + 1)]);
		for (var i = (128 + 2); i <= (256 - 2); i += 2) {
			t.mc.lineTo(t.xyz[((b + i) + 0)], t.xyz[((b + i) + 1)]);
		}
		
		t.mc.lineStyle(4, t.color, 100);
		t.mc.moveTo(t.xyz[(b + 0)], t.xyz[(b + 1)]);
		for (var i = 2; i <= (128 - 2); i += 2) {
			t.mc.lineTo(t.xyz[((b + i) + 0)], t.xyz[((b + i) + 1)]);
		}
		t.mc.moveTo(t.xyz[((b + 128) + 0)], t.xyz[((b + 128) + 1)]);
		for (var i = (128 + 2); i <= (256 - 2); i += 2) {
			t.mc.lineTo(t.xyz[((b + i) + 0)], t.xyz[((b + i) + 1)]);
		}
		
		t.mc.lineStyle( 8, t.color, 50 )
		for(var i=4 ; i<128-4 ; i+=8)
		{
			t.mc.moveTo(t.xyz[b+i+0],t.xyz[b+i+1])
			t.mc.lineTo(t.xyz[b+128+i+0],t.xyz[b+128+i+1])
		}
		
		t.mc.lineStyle(4, t.color, 100);
		for (var i = 4; i <= (128 - 4); i += 8) {
			t.mc.moveTo(t.xyz[((b + i) + 0)], t.xyz[((b + i) + 1)]);
			t.mc.lineTo(t.xyz[(((b + 128) + i) + 0)], t.xyz[(((b + 128) + i) + 1)]);
		}
	}
	function update(/*this*/) {
		var t = this;
		t.frame = (t.frame + 1);
		if ((t.frame == 32)) {
			t.frame = 0;
		}
	}
	function removeMC(/*this*/) {
		var t = this;
		t.mc.removeMovieClip();
	}
	
	var bmps;
	var tinted;
	var tint=0;
	var frame=0;
	
	function do_tint() // apply bitmap filter
	{
//		if(tint>tinted[frame])
		{
			var rec=new flash.geom.Rectangle(tinted[frame],0,tint-tinted[frame],128);
//			var rec=new flash.geom.Rectangle(0,0,256,128);
			var tran=new flash.geom.ColorTransform(0, 0, 0, 1, 0, 128, 255, 0);
			bmps[frame].colorTransform(rec,tran);
			tinted[frame]=tint; //amount so far
		}
	}
	
	function onEnterFrame(/*this*/) {
		var t = this;
		if ((!t._visible)) {
			return;
		}
//		t.clear();
//		t.t.thunk();
//		t.t.draw();
//		t.t.update();
		
		t.t.do_tint();
		
		t.t.mc2.attachBitmap(t.t.bmps[t.t.frame],0,"auto",true);
			
		t.t.frame = (t.t.frame + 1);
		if ((t.t.frame == 32)) {
			t.t.frame = 0;
		}
	}
	
	
	function wetDNA2(/*this*/master, name, level, color ) {
		var i;
		
		var t = this;
		t.mc2 = master.createEmptyMovieClip(name, level);
//		t.mc2._yscale=50;
		t.mc  = t.mc2.createEmptyMovieClip("dna", 0);
		t.mc._x=128;
		t.mc._y=64;
//		t.mc.filters = new Array();
//				t.mc.filters[0]=new flash.filters.GlowFilter(0, 0.5, 10, 10, 2, 3);
		//	    t.mc.filters[0]=new.flash.filters.DropShadowFilter(2, 45, 0, 1, 4, 4, 2, 3)
		
//		gfx.blur(t.mc,4,4,1);
//		gfx.glow(t.mc,0x0000ff, 0.5, 8, 8, 2, 3);
		gfx.blurglow(t.mc,2,2,1,0x0000ff, 0.5, 8, 8, 2, 3);
		
		t.mc2.t = this;
		t.color = 0x0000ff;
		t.thunked = false;
		t.frame = 0;
		t.xyz = new Array((((32 * 2) * 64) * 2));
		t.removeMC = removeMC;
		t.update = update;
		t.draw = draw;
		t.thunk = thunk;
		t.mc2.onEnterFrame = onEnterFrame;
		
		bmps=[];
		tinted=[];
		for(i=0;i<32;i++)
		{
			t.mc.clear();
			t.thunk();
			t.draw();
			t.update();
			
			var b=new flash.display.BitmapData(256,128,true,0x00000000);
			b.draw(t.mc2);
			bmps[i]=b;
			tinted[i]=0;
		}
		
		t.mc.removeMovieClip();
	}
}