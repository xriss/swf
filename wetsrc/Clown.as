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

// clown not mime, which doesn't make much sense :)

#CLASSNAME=CLASSNAME or "Clown"

class #(CLASSNAME)
{
	static var chars:String="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"; // changed from _- but decoding still accepts them as well

	static var nums:Array=[
	
		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,62,
		0,0,0,0,0,0,0,0,0,0,0,62,0,63,0,63,
		52,53,54,55,56,57,58,59,60,61,0,0,0,0,0,0,
		0,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,
		15,16,17,18,19,20,21,22,23,24,25,0,0,0,0,62,
		0,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,
		41,42,43,44,45,46,47,48,49,50,51,0,0,0,0,0,

// the rest is probably not needed
// but it might stop bad things happening later...

		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
		
		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
		
		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
		
		];

	static function tostr(num:Number,len:Number)
	{
		var i:Number;
		var n:Number;
		var nn:Number;
		var str:String;
		
		nn=num;
		str='';
		
		for(i=0;i<len;i++)
		{
			n=nn&63;
			str=str+chars.charAt(n);
			
			nn=nn>>6;
		}
		
		return str;
	}
	
	static function tonum(str:String,base:Number,len:Number)
	{
		var c:Number;
		var i:Number;
		var n:Number;
		var mul:Number;
		
/* check
		for(i=0;i<64;i++)
		{
			trace( "N: " + i + " " + chars.charAt(i) + " " +  nums[chars.charCodeAt(i)] );
		}
*/
		
		mul=1;
		n=0;
	
		for(i=base;i<base+len;i++)
		{
			c=str.charCodeAt(i);
			
			n+=nums[c]*mul;
			
			mul*=64;
		}
		
		return n;
	}
	
// turn an array of numbers (each number is same number of bits in size) to or from a string
	
	static function bits_to_str(arr,bits)
	{
	var str;
	var i;
	
		if((bits%6)!=0) // not suported, yet, lazy coder, cough
		{
			return null;
		}
		
		str="";
		for(i=0;i<arr.length;i++)
		{
			str+=tostr(arr[i],bits/6)
		}
	
		return str;
	}
	
	static function str_to_bits(str,off,bits)
	{
	var i;
	var arr;
	var blen;
	var len;
	
		if((bits%6)!=0) // not suported, yet, lazy coder, cough
		{
			return null;
		}
		blen=bits/6;
		
		arr=[];
		
		len=str.length;
		for(i=off;i<len;i+=blen)
		{
			arr[arr.length]=tonum(str,i,blen);
		}
	
		return arr;
	}

	
// a pak is a mime encoded string, with a 24bit (4 mime chars) length as a header

	static function bytes_to_pak(aa)
	{
		var pak; // a packet string, first 24bits, is length of string, rest is encoded thingy
		var len=aa.length;
		var i,j;
		var c;
		var a=[];
		var n,s;
		
		for(i=0;i<len;i+=3)
		{
			if(i+3<=len) // full segment
			{
				c =aa[i+0]*65536;
				c+=aa[i+1]*256;
				c+=aa[i+2];
			}
			else // end, partial
			{
				            c =aa[i+0]*65536;
				if(i+1<len) c+=aa[i+1]*256;
				if(i+2<len) c+=aa[i+2];
			}
			
			n=(c>>6+6+6)&0x3f;
			s=chars.charAt(n);
			n=(c>>6+6)&0x3f;
			s+=chars.charAt(n);
			n=(c>>6)&0x3f;
			s+=chars.charAt(n);
			n=(c)&0x3f;
			s+=chars.charAt(n);
			
			a[a.length]=s;

		}
		
		return a.join("");
	}
	
// a pak is a mime encoded string, with a 24bit (4 mime chars) length as a header

	static function str_to_pak(str)
	{
		var pak; // a packet string, first 24bits, is length of string, rest is encoded thingy
		var len=str.length;
		var i,j;
		var c;
		
		pak=tostr(len,4); //24bits of header
		
		for(i=0;i<len;i+=3)
		{
			if(i+3<=len) // full segment
			{
				c =str.charCodeAt(i+0);
				c+=str.charCodeAt(i+1)*256;
				c+=str.charCodeAt(i+2)*65536;
				pak+=tostr(c,4);
			}
			else // end
			{
				            c =str.charCodeAt(i+0);
				if(i+1<len) c+=str.charCodeAt(i+1)*256;
				if(i+2<len) c+=str.charCodeAt(i+2)*65536;
				pak+=tostr(c,4);
			}
		}
		return pak;
	}
	
	static function pak_to_str(pak)
	{
		var str;
		var len;
		var i,j;
		var s,c;
		
		str="";
		len=tonum(pak,0,4); // 24bits of length at the start
		j=4;
		for(i=0;i<len;i+=3)
		{
			if(j>pak.length) break;
			if(i+3<=len) // full segment
			{
				c=tonum(pak,j,4);j+=4;
				
				str+= String.fromCharCode( (c)&255 , (c>>8)&255 , (c>>16)&255 );
			}
			else // end
			{
				c=tonum(pak,j,4);j+=4;
				
				            str+= String.fromCharCode( (c    )&255 );
				if(i+1<len) str+= String.fromCharCode( (c>>8 )&255 );
				if(i+2<len) str+= String.fromCharCode( (c>>16)&255 );
			}
		}
		
		return str;
	}
	
	static function clean_str(s)
	{
	var i,c;
	var r="";
	
		for(i=0;i<s.length;i++)
		{
			c=s.charCodeAt(i);
			if( ( nums[c]>0  ) || ( c == 65 ) ) // a valid encoded char only A(65) should be 0
			{
				r+=String.fromCharCode(c);
			}
		}
		return r;
	}
	
}