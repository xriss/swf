/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) Kriss Daniels 2006 http://www.XIXs.com
//
/*+-----------------------------------------------------------------------------------------------------------------+*/

// clown not mime, which doesn't make much sense :)

class Clown
{
	static var chars:String="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_-";

	static var nums:Array=[
	
		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,0,0,0,0,0,63,0,0,
		52,53,54,55,56,57,58,59,60,61,0,0,0,0,0,0,
		0,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,
		15,16,17,18,19,20,21,22,23,24,25,0,0,0,0,62,
		0,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,
		41,42,43,44,45,46,47,48,49,50,51,0,0,0,0,0
		
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
	
}
