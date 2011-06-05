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
/*+-----------------------------------------------------------------------------------------------------------------+*/

#include "src/opts.as"


class WetPlayGFX
{

	var up; // WetPlay

	function WetPlayMP3(_up)
	{
		up=_up;
	}
	
//
// typing this junk in was the quick and "simple" solution :)
//

	function draw_play( mc , x,y , w,h )
	{
	var sw,sh,ss;

		sw=w/16;
		sh=h/16;
		ss=sw; if(ss>sh) { ss=sh; }
		
		mc.lineStyle(undefined);
		mc.beginFill(mc.style.fill&0xffffff,((mc.style.fill>>24)&0xff)*100/255);

		mc.moveTo(x+ss,y+ss);
		mc.lineTo(x+w-ss,y+ss);
		mc.lineTo(x+w-ss,y+h-ss);
		mc.lineTo(x+ss,y+h-ss);
		mc.lineTo(x+ss,y+ss);
		
		mc.moveTo(x+ss*2,y+ss*2);
		mc.lineTo(x+w-ss*2,y+ss*2);
		mc.lineTo(x+w-ss*2,y+h-ss*2);
		mc.lineTo(x+ss*2,y+h-ss*2);
		mc.lineTo(x+ss*2,y+ss*2);
		
		mc.moveTo(x+sw*5,y+ss*3);
		mc.lineTo(x+sw*5,y+h-ss*3);
		mc.lineTo(x+sw*11,y+sh*8);
		
		mc.endFill();
	}
	
	function draw_back( mc , x,y , w,h )
	{
	var sw,sh,ss;

		sw=w/16;
		sh=h/16;
		ss=sw; if(ss>sh) { ss=sh; }
		
		mc.lineStyle(undefined);
		mc.beginFill(mc.style.fill&0xffffff,((mc.style.fill>>24)&0xff)*100/255);

		mc.moveTo(x+ss,y+ss);
		mc.lineTo(x+w-ss,y+ss);
		mc.lineTo(x+w-ss,y+h-ss);
		mc.lineTo(x+ss,y+h-ss);
		mc.lineTo(x+ss,y+ss);
		
		mc.moveTo(x+ss*2,y+ss*2);
		mc.lineTo(x+w-ss*2,y+ss*2);
		mc.lineTo(x+w-ss*2,y+h-ss*2);
		mc.lineTo(x+ss*2,y+h-ss*2);
		mc.lineTo(x+ss*2,y+ss*2);
		
		mc.moveTo(x+sw*11,y+ss*3);
		mc.lineTo(x+sw*11,y+h-ss*3);
		mc.lineTo(x+sw*5,y+sh*8);
		
		mc.endFill();
	}
	
	function draw_stop( mc , x,y , w,h )
	{
	var sw,sh,ss;

		sw=w/16;
		sh=h/16;
		ss=sw; if(ss>sh) { ss=sh; }
		
		mc.lineStyle(undefined);
		mc.beginFill(mc.style.fill&0xffffff,((mc.style.fill>>24)&0xff)*100/255);

		mc.moveTo(x+ss,y+ss);
		mc.lineTo(x+w-ss,y+ss);
		mc.lineTo(x+w-ss,y+h-ss);
		mc.lineTo(x+ss,y+h-ss);
		mc.lineTo(x+ss,y+ss);
		
		mc.moveTo(x+ss*2,y+ss*2);
		mc.lineTo(x+w-ss*2,y+ss*2);
		mc.lineTo(x+w-ss*2,y+h-ss*2);
		mc.lineTo(x+ss*2,y+h-ss*2);
		mc.lineTo(x+ss*2,y+ss*2);
		
		mc.moveTo(x+sw*12,y+sh*4);
		mc.lineTo(x+sw*12,y+sh*12);
		mc.lineTo(x+sw*4,y+sh*12);
		mc.lineTo(x+sw*4,y+sh*4);
		
		mc.endFill();
	}
	
	function draw_pause( mc , x,y , w,h )
	{
	var sw,sh,ss;

		sw=w/16;
		sh=h/16;
		ss=sw; if(ss>sh) { ss=sh; }
		
		mc.lineStyle(undefined);
		mc.beginFill(mc.style.fill&0xffffff,((mc.style.fill>>24)&0xff)*100/255);

		mc.moveTo(x+ss,y+ss);
		mc.lineTo(x+w-ss,y+ss);
		mc.lineTo(x+w-ss,y+h-ss);
		mc.lineTo(x+ss,y+h-ss);
		mc.lineTo(x+ss,y+ss);
		
		mc.moveTo(x+ss*2,y+ss*2);
		mc.lineTo(x+w-ss*2,y+ss*2);
		mc.lineTo(x+w-ss*2,y+h-ss*2);
		mc.lineTo(x+ss*2,y+h-ss*2);
		mc.lineTo(x+ss*2,y+ss*2);
		
		mc.moveTo(x+sw*4,y+ss*3);
		mc.lineTo(x+sw*4,y+ss*13);
		mc.lineTo(x+sw*7,y+ss*13);
		mc.lineTo(x+sw*7,y+ss*3);
		
		mc.moveTo(x+sw*9,y+ss*3);
		mc.lineTo(x+sw*9,y+ss*13);
		mc.lineTo(x+sw*12,y+ss*13);
		mc.lineTo(x+sw*12,y+ss*3);
		
		mc.endFill();
	}
	
	function draw_forward( mc , x,y , w,h )
	{
	var sw,sh,ss;

		sw=w/16;
		sh=h/16;
		ss=sw; if(ss>sh) { ss=sh; }
		
		mc.lineStyle(undefined);
		mc.beginFill(mc.style.fill&0xffffff,((mc.style.fill>>24)&0xff)*100/255);

		mc.moveTo(x+ss,y+ss);
		mc.lineTo(x+w-ss,y+ss);
		mc.lineTo(x+w-ss,y+h-ss);
		mc.lineTo(x+ss,y+h-ss);
		mc.lineTo(x+ss,y+ss);
		
		mc.moveTo(x+ss*2,y+ss*2);
		mc.lineTo(x+w-ss*2,y+ss*2);
		mc.lineTo(x+w-ss*2,y+h-ss*2);
		mc.lineTo(x+ss*2,y+h-ss*2);
		mc.lineTo(x+ss*2,y+ss*2);
		
		mc.moveTo(x+sw*3,y+ss*3);
		mc.lineTo(x+sw*3,y+h-ss*3);
		mc.lineTo(x+sw*8,y+sh*8);
		
		mc.moveTo(x+sw*8,y+ss*3);
		mc.lineTo(x+sw*8,y+h-ss*3);
		mc.lineTo(x+sw*13,y+sh*8);
		
		mc.endFill();
	}
	
	function draw_backward( mc , x,y , w,h )
	{
	var sw,sh,ss;

		sw=w/16;
		sh=h/16;
		ss=sw; if(ss>sh) { ss=sh; }
		
		mc.lineStyle(undefined);
		mc.beginFill(mc.style.fill&0xffffff,((mc.style.fill>>24)&0xff)*100/255);

		mc.moveTo(x+ss,y+ss);
		mc.lineTo(x+w-ss,y+ss);
		mc.lineTo(x+w-ss,y+h-ss);
		mc.lineTo(x+ss,y+h-ss);
		mc.lineTo(x+ss,y+ss);
		
		mc.moveTo(x+ss*2,y+ss*2);
		mc.lineTo(x+w-ss*2,y+ss*2);
		mc.lineTo(x+w-ss*2,y+h-ss*2);
		mc.lineTo(x+ss*2,y+h-ss*2);
		mc.lineTo(x+ss*2,y+ss*2);
		
		mc.moveTo(x+sw*8,y+ss*3);
		mc.lineTo(x+sw*8,y+h-ss*3);
		mc.lineTo(x+sw*3,y+sh*8);
		
		mc.moveTo(x+sw*13,y+ss*3);
		mc.lineTo(x+sw*13,y+h-ss*3);
		mc.lineTo(x+sw*8,y+sh*8);
		
		mc.endFill();
	}

	function draw_boxen( mc , x,y , w,h )
	{
	var sw,sh,ss;

		sw=w/16;
		sh=h/16;
		ss=sw; if(ss>sh) { ss=sh; }
		
		mc.lineStyle(undefined);
		mc.beginFill(mc.style.fill&0xffffff,((mc.style.fill>>24)&0xff)*100/255);

		mc.moveTo(x+ss,y+ss);
		mc.lineTo(x+w-ss,y+ss);
		mc.lineTo(x+w-ss,y+h-ss);
		mc.lineTo(x+ss,y+h-ss);
		mc.lineTo(x+ss,y+ss);
		
		mc.moveTo(x+ss*2,y+ss*2);
		mc.lineTo(x+w-ss*2,y+ss*2);
		mc.lineTo(x+w-ss*2,y+h-ss*2);
		mc.lineTo(x+ss*2,y+h-ss*2);
		mc.lineTo(x+ss*2,y+ss*2);
		
		mc.endFill();
	}
	
	function draw_puck( mc , x,y , w,h )
	{
	var sw,sh,ss;

		sw=w/16;
		sh=h/16;
		ss=sw; if(ss>sh) { ss=sh; }
		
		mc.lineStyle(undefined);
		mc.beginFill(mc.style.fill&0xffffff,((mc.style.fill>>24)&0xff)*100/255);

		mc.moveTo(x+ss*3,y+ss*3);
		mc.lineTo(x+w-ss*3,y+ss*3);
		mc.lineTo(x+w-ss*3,y+h-ss*3);
		mc.lineTo(x+ss*3,y+h-ss*3);
		mc.lineTo(x+ss*3,y+ss*3);
		
		mc.endFill();
	}
}
