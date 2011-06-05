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
class wetDNA
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
					y = (Math.sin(r) * 128);
					z = (1 - ((((((Math.cos(r) * 128)) + 128)) / 1536)));
					t.xyz[(((b + j) + (i * 2)) + 0)] = (x * z);
					t.xyz[(((b + j) + (i * 2)) + 1)] = (y * z);
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
		//		t.mc.lineStyle( 24, t.color, 50 )
		//		t.mc.moveTo(t.xyz[b+0],t.xyz[b+1]) for i=2,128-2,2 do t.mc.lineTo(t.xyz[b+i+0],t.xyz[b+i+1]) end
		//		t.mc.moveTo(t.xyz[b+128+0],t.xyz[b+128+1])  for i=128+2,256-2,2 do t.mc.lineTo(t.xyz[b+i+0],t.xyz[b+i+1]) end
		t.mc.lineStyle(12, t.color, 100);
		t.mc.moveTo(t.xyz[(b + 0)], t.xyz[(b + 1)]);
		for (var i = 2; i <= (128 - 2); i += 2) {
			t.mc.lineTo(t.xyz[((b + i) + 0)], t.xyz[((b + i) + 1)]);
		}
		t.mc.moveTo(t.xyz[((b + 128) + 0)], t.xyz[((b + 128) + 1)]);
		for (var i = (128 + 2); i <= (256 - 2); i += 2) {
			t.mc.lineTo(t.xyz[((b + i) + 0)], t.xyz[((b + i) + 1)]);
		}
		//		t.mc.lineStyle( 16, t.color, 50 )
		//		for i=4,128-4,8 do
		//
		//			t.mc.moveTo(t.xyz[b+i+0],t.xyz[b+i+1])
		//			t.mc.lineTo(t.xyz[b+128+i+0],t.xyz[b+128+i+1])
		//			
		//		end
		t.mc.lineStyle(8, t.color, 100);
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
	function onEnterFrame(/*this*/) {
		var t = this;
		if ((!t._visible)) {
			return;
		}
		t.clear();
		t.t.thunk();
		t.t.draw();
		t.t.update();
	}
	function wetDNA(/*this*/master, name, level, color) {
		var t = this;
		t.mc = master.createEmptyMovieClip(name, level);
		t.mc.filters = new Array();
		//		t.mc.filters[0]=new.flash.filters.GlowFilter(0, 0.5, 10, 10, 2, 3)
		//	    t.mc.filters[0]=new.flash.filters.DropShadowFilter(2, 45, 0, 1, 4, 4, 2, 3)
		t.mc.t = this;
		t.color = color;
		t.thunked = false;
		t.frame = 0;
		t.xyz = new Array((((32 * 2) * 64) * 2));
		t.removeMC = removeMC;
		t.update = update;
		t.draw = draw;
		t.thunk = thunk;
		t.mc.onEnterFrame = onEnterFrame;
	}
}