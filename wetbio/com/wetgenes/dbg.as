/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) Kriss Daniels 2006 http://www.XIXs.com
//
/*+-----------------------------------------------------------------------------------------------------------------+*/

class com.wetgenes.dbg
{

	static function printfire(s)
	{
		getURL("javascript:printfire('"+s+"');");
	}

	
	static function print(s)
	{
		printfire(s);
	}
}
