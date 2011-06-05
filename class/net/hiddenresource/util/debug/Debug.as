/**
 * Alcon Debug class
 * Sends trace actions to the Alcon output panel through a local connection.
 * @version 1.0.7 (09.02.2006)
 * @author Sascha Balkau <sascha@hiddenresource.corewatch.net>
 */
class net.hiddenresource.util.debug.Debug
{

	// If using MTASC trace facility, set this to true:
	private static var mtf:Boolean = true;
	// Determines if data blocks > 40Kb are split into chunks:
	private static var sp:Boolean = true;
	// Default depth of recursion for object tracing:
	private static var rec:Number = 4;
	
	
	// The sending local connection object:
	private static var dlc:LocalConnection;
	// Determines if a connection is already established:
	private static var con:Boolean = false;
	// Filter level. By default filter none (0):
	private static var fl:Number = 0;
	// The chunk size used for data splitting (def. 40600, leaves some additional headroom):
	private static var cs:Number = 40600;
	// Used internally to mark chunk splitting when using MTASC trace:
	private static var spp:Boolean = false;
	
	
	/**
	 * Private constructor
	 */
	private function Debug()
	{
	}
	
	
	/**
	 * Prepares an object for recursive tracing.
	 * @param <code>obj</code> the traced object.
	 * @return A <code>string</code> that contains the object structure.
	 */
	private static function traceObj(obj:Object):String
	{
		// Set the max. recursive depth:
		var rcdInit:Number = rec;
		// If object is a movieclip, get the size of it:
		var otp:String = typeof(obj);
		var obt:String = (otp == "movieclip") ? ", " + obj.getBytesTotal().toString() + " bytes" : "";
		// tmp holds the string with the whole object structure:
		var tmp:String = "" + arguments.toString() + " (" + otp + obt + "):\n";
		
		// Nested recursive function:
		var prObj:Function;
		prObj = function(o:Object, rcd:Number, idt:Number, br:Boolean):Void
		{
			if (br)
			{
				br = false;
				tmp += ">>";
			}
			for (var p in o)
			{
				// Preparing indention:
				var tb:String = "";
				for (var i:Number = 0; i < idt; i++) tb += "    ";
				tmp += tb + p + ": " + o[p] + "\n";
				if (rcd > 0) prObj(o[p], (rcd - 1), (idt + 1), true);
			}
		};
		prObj(obj, rcdInit, 1, true);
		return tmp;
	}
	
	
	/**
	 * Splits data blocks that are larger than 40Kb into 40Kb chunks.
	 * Note that level 6 is used internally to mark the data as
	 * a chunk for the console. User-given levels are ignored when
	 * data is processed by this method.
	 * @param <code>dta</code> a string which is split into chunks.
	 */
	private static function splitDt(dta:String):Void
	{
		var sze:Number = cs;
		var c:Number = Math.ceil(dta.length / sze);
		var s:Number = 0;
		var e:Number = sze;
		
		for (var i:Number = 0; i < c; i++)
		{
			if (i < c)
			{
				Debug.trace(dta.slice(s, e), false, 6);
				//trace("\nChunk Nr: " + i + " / len: " + dta.slice(s, e).length, false, 6);
				s += sze;
				e += sze;
			}
		}
		Debug.trace("", false, 1);
		spp = false;
	}
	
	
	/**
	 * The trace method accepts three arguments, the first contains the data which
	 * is going to be traced, the second if of type <code>Boolean</code> is used
	 * to indicate recursive object tracing mode, if of type <code>Number</code>
	 * desribes the filtering level for the output.
	 * @param <code>arg0:Object<code> the object to be traced.
	 * @param <code>arg1:Boolean<code> true if recursive object tracing (optional).
	 * @param <code>arg2:Number	<code> filter level (optional).
	 */
	public static function trace():Void
	{
		// Only connect if not already connected:
		if (!con)
		{
			dlc = new LocalConnection();
			con = true;
		}
		
		// Use arguments offset if no mtasc trace facility:
		var ao:Number = (!spp && mtf) ? 0 : 3;
		
		// Set vars:
		var al:Number = arguments.length;
		var ag:Number = -1;
		var c:String = "";
		var o:String = "";
		var s:String = "";
		var m:Object = (al > (3 - ao)) ? arguments[0] : undefined;
		var t:Boolean = false;
		var l:Number = 1;
		
		// Get MTASC parameters:
		if (!spp && mtf)
		{
			var cn:String = arguments[al - 3].split("::").join(".");
			var ca:Array = cn.split(".");
			cn = ca[ca.length - 2];
			c = "[" + cn + ", line " + arguments[al - 1] + "] ";
		}
		
		// Check if more than one argument was given:
		if (al > (4 - ao))
		{
			if (typeof(arguments[1]) == "boolean") t = arguments[1];
			else if (typeof(arguments[1]) == "number") l = arguments[1];
			
			if (al > (5 - ao))
			{
				if (typeof(arguments[2]) == "boolean") t = arguments[2];
				else if (typeof(arguments[2]) == "number") l = arguments[2];
			}
		}
		
		// Extract signal tag if any is given:
		if (typeof(m) == "string")
		{
			if (m.substring(0, 2) == "[%")
			{
				if (m.substring(5, 7) == "%]")
				{
					s = m.substr(0, 7);
					m = m.substr(7, m.length);
					if (m == "") l = 5;
				}
			}
		}
		
		// Only show messages equal or higher than current filter level:
		if (l >= fl && l < 7)
		{
			// Check if recursive object tracing:
			if (t) o += traceObj(m);
			else o += String(m);
			
			// Check if data stream size is too large for LocalConnection:
			if (sp && o.length > cs)
			{
				spp = true;
				splitDt(o);
			}
			else
			{
				// Send output, signal tag, mtasc string and level to Alcon console:
				var snt:Boolean = dlc.send("_alcon_lc", "onMessage", o, s, c, l);
				
				// Check if data could be sent, otherwise send error signal:
				if (!snt) Debug.trace("[%ERR%]");
				
				// If you want to trace to the Flash IDE as well, uncomment this line.
				// (Leave commented if using MTASC's trace feature!):
				// trace(out);
			}
		}
	}
	
	
	/**
	 * Sends a clear buffer signal to the output console.
	 * Level 5 is used internally for signals, so that in any case
	 * no level keywords are placed before the signal string.
	 */
	public static function clear():Void
	{
		Debug.trace("[%CLR%]", 5);
	}
	
	
	/**
	 * Sends a delimiter signal to the output console.
	 */
	public static function delimiter():Void
	{
		Debug.trace("[%DLT%]", 5);
	}
	
	
	/**
	 * Sends a pause signal to the output console.
	 */
	public static function pause():Void
	{
		Debug.trace("[%PSE%]", 5);
	}
	
	
	/**
	 * Toggles data splitting on/off.
	 * @param <code>_sp</code> A boolean if set to true turns on the option to
	 * split data streams larger than 40Kb into 40Kb chunks, if set to false turns it off.
	 */
	public static function splitData(_sp:Boolean):Void
	{
		sp = _sp;
	}
	
	
	/**
	 * Sets the logging filter level.
	 * @param <code>_fl</code> a number for the filter level to be set.
	 */
	public static function setFilterLevel(_fl:Number):Void
	{
		if (_fl != undefined && _fl >= 0 && _fl < 5) fl = _fl;
	}
	
	
	/**
	 * Returns the logging filter level.
	 * @return	the number of the filter level.
	 */
	public static function getFilterLevel():Number
	{
		return fl;
	}
	
	
	/**
	 * Sets the recursion depth for recursive object tracing.
	 * @param <code>_rec</code> A number with the depth for object recursive tracing.
	 */
	public static function setRecursionDepth(_rec:Number):Void
	{
		rec = _rec;
	}
}
