/*
 * Copyright the original author or authors.
 * 
 * Licensed under the MOZILLA PUBLIC LICENSE, Version 1.1 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *      http://www.mozilla.org/MPL/MPL-1.1.html
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import org.as2lib.core.BasicClass;
import org.as2lib.data.holder.Map;
import org.as2lib.data.holder.map.PrimitiveTypeMap;
import org.as2lib.util.Stringifier;
import org.as2lib.io.URLStringifier;
import org.as2lib.io.URLDebugStringifier;
import org.as2lib.env.except.IllegalArgumentException;

/**
 *
 * URI is parsed according to RFC 3986 ({@url http://www.ietf.org/rfc/rfc3986.txt})
 * 
 * <p> This class performs minimal validation, checks for allowed characters won't be performed.  
 * 
 * @author Akira Ito
 * @version 1.1
 *
 */
class org.as2lib.io.URL extends BasicClass {

	public static var PATH_ABEMPTY:Number = 0;
	public static var PATH_ABSOLUTE:Number = 1;
	public static var PATH_NOSCHEME:Number = 2;
	public static var PATH_ROOTLESS:Number = 3;
	public static var PATH_EMPTY:Number = 4;

	/** Stringifiers for URL, default stringifier is {@code debugStringifier}. */
	private static var pathStringifier:Stringifier;
	private static var debugStringifier:Stringifier;

	// Reserved characters, according to RFC 3986. 
	// private static var genDelims:String = ":/?#[]@";
	// private static var subDelims:String = "!$&'()*+,;=";
	// private static var unreserved:String = "-._~";
	// unreserved  = ALPHA / DIGIT / "-" / "." / "_" / "~"

	/** Static array contains methods for checking is char belongs to given construct. */	
	private static var checkChar:Array = [isCharOfScheme, isCharOfAuthority, isCharOfPath, isCharOfQuery, isCharOfFragment, isCharOfRubbish];

	/** Static array contains methods for checking for preceding chars for given construct. */	
	private static var checkPrefix:Array = [isPrefixOfScheme, isPrefixOfAuthority, isPrefixOfPath, isPrefixOfQuery, isPrefixOfFragment, isPrefixOfRubbish];
	
	/**
	 * Returns the stringifier that stringifies {@code URL} for debug output.
	 *
	 * <p>If no stringifier has been set manually the default stringifier will be returned
	 * which is an instance of class {@link URLDebugStringifier}.
	 * 
	 * @return the stringifier that stringifies url
	 */
	public static function getDebugStringifier(Void):Stringifier { 
		if (!debugStringifier) debugStringifier = new URLDebugStringifier();
		return debugStringifier;
	}

	/**
	 * Returns the stringifier that stringifies {@code URL} for accessing it.
	 *
	 * <p>If no stringifier has been set manually the default stringifier will be returned
	 * which is an instance of class {@link URLStringifier}.
	 * 
	 * @return the stringifier that stringifies url as browseable path
	 */
	public static function getPathStringifier(Void):Stringifier { 
		if (!pathStringifier) pathStringifier = new URLStringifier();
		return pathStringifier;
	}
	
	/**
	 * Sets the new debug stringifier that stringifies {@code URL}.
	 *
	 * <p>If the passed-in {@code Stringifier} is {@code null} or {@code undefined}
	 * the static {@link #getDebugStringifier} method will return the default debugging stringifier.
	 * 
	 * @param newDebugStringifier the new stringifier for debugging output
	 */
	public static function setDebugStringifier(newDebugStringifier:Stringifier):Void {
		debugStringifier = newDebugStringifier;
	}

	/**
	 * Sets the new stringifier that stringifies {@code URL} to browsable path.
	 *
	 * <p>If the passed-in {@code Stringifier} is {@code null} or {@code undefined}
	 * the static {@link #getPathStringifier} method will return the default path stringifier.
	 * 
	 * @param newPathStringifier the new stringifier for resource access.
	 */
	public static function setPathStringifier(newPathStringifier:Stringifier):Void {
		pathStringifier = newPathStringifier;
	}

	/**
 	 * Performs basic parsing URI string into RFC compliant [scheme], [authority], [path], [query] and [fragment] constructs.  
 	 * 
 	 * <p>Note, now parsing is performed manually, but we can use POSIX-compartible regexp given in comments.
 	 * (Maybe with AS3/haXe?)
 	 * 
 	 * @param uriString string to be parsed
 	 * @return object with "Scheme", "Authority", "Path", "Query", "Fragment" and "Rubbish" fields  
 	 */
	private static function parseBasic(uriString:String):Object{
	/*
	 * Here's the regexp for breaking-down a  well-formed URI reference into its components. 
	 * using "greedy"  disambiguation method used by POSIX regular expressions. 
	 * 
	 * ^(([^:/?#]+):)?(//([^/?#]*))?([^?#]*)(\?([^#]*))?(#(.*))?
	 *  12            3  4          5       6  7        8 9
	 * 
	 *  scheme    = $2
	 *  authority = $4
	 *  path      = $5
	 * 	query     = $7
	 * 	fragment  = $9
	 * 	
	 * 	below is manual parsing applied to reduce code size.
	 */
		var i:Number; 
		var j:Number;
		var result:Object = new Object;
		var fields:Array = ["Scheme", "Authority", "Path", "Query", "Fragment", "Rubbish"];
		var fieldPreSpaces:Array = [0, 2, 0, 1, 1, 0];
		var fieldPostSpaces:Array = [1, 0, 0, 0, 0, 0];
		var fieldIndex:Number = 0;
	
		i = 0;
		while(i<uriString.length){	 
				// finding required construct
				while(!checkPrefix[fieldIndex](uriString.substr(i))) { fieldIndex++; }
				// skip some characters before string processing, if needed
				i += fieldPreSpaces[fieldIndex];
				// setting start point to dig data from
				j = i;
				while ((j < uriString.length) && 
					   (checkChar[fieldIndex](uriString.charAt(j), j-i))
					  ) { j++; }
				if(j>i) { 
					result[fields[fieldIndex]] = uriString.substr(i,j-i);
				} 
				i = j;
				// skipping some characters after string processing, if needed
				i += fieldPostSpaces[fieldIndex];				
				fieldIndex++;
		}
		return result;
	}
	
	/** Here's set of methods to be called thru static array {@code checkChar},
	 *  Every method will be called with two parameters - char and its position.
	 */
	 
	// scheme = ALPHA *( ALPHA / DIGIT / "+" / "-" / "." ) :
	
 	/**
 	 * Parsing utility function, checks if given string contain prefix for scheme data.
 	 * 
 	 * @param str string to be tested
 	 * @return true, if string can be prefix of the scheme
 	 */
	private static function isPrefixOfScheme(str:String):Boolean {
		return isCharAlpha(str.charAt(0)) && str.indexOf(":")>0; 
	}
		
 	/**
 	 * Parsing utility function, checks if given character can belong to scheme data.
 	 * 
 	 * @param char character to be tested
	 * @param charPos position of the character in the string 
 	 * @return true, if character can belong to the scheme 
 	 */
	private static function isCharOfScheme(char:String, charPos:Number):Boolean {
		return ((charPos==0 && isCharAlpha(char)) || 
 				(charPos>0 && (isCharAlpha(char) || ("1234567890".indexOf(char)>-1) || ("+-.".indexOf(char)>-1)))); 
	}
	
	// The authority component is preceded by a double slash ("//") and is terminated by the next slash ("/"), 
	// question mark ("?"), or number sign ("#") character, or by the end of the URI.

	/**
 	 * Parsing utility function, checks if given string contain prefix for authority data.
 	 * 
 	 * @param str string to be tested
 	 * @return true, if character can be prefix of authority 
 	 */
	private static function isPrefixOfAuthority(str:String):Boolean {
		return str.charAt(0)=="/" && str.charAt(1)=="/";
	}
	
	/**
 	 * Parsing utility function, checks if given character can belong to authority data.
 	 * 
 	 * @param char character to be tested
 	 * @return true, if character can be part of authority 
 	 */
	private static function isCharOfAuthority(char:String):Boolean {
		return "/#?".indexOf(char)==-1;
	}

	// The path is terminated  by the first question mark ("?") or number sign ("#") character
	
	/**
 	 * Parsing utility function, checks if given string contain prefix for path data.
 	 * 
 	 * @param str string to be tested
 	 * @return true, if character can be prefix of path 
 	 */
	private static function isPrefixOfPath(str:String):Boolean {
		return true;
	}
			
 	/**
 	 * Parsing utility function, checks if given character can belong to path string.
 	 * 
 	 * @param char character to be tested
 	 * @return true, if character can be part of path  
 	 */
	private static function isCharOfPath(char:String):Boolean {
		return "#?".indexOf(char)==-1; 
	}
	
	// The query component is indicated by the first question  mark ("?") character and terminated by a number sign ("#")
	
	/**
 	 * Parsing utility function, checks if given string contain prefix for query data.
 	 * 
 	 * @param str string to be tested
 	 * @return true, if character can be prefix of query 
 	 */
	private static function isPrefixOfQuery(str:String):Boolean {
		return str.charAt(0)=="?";
	}
		
 	/**
 	 * Parsing utility function, checks if given character can belong to query data.
 	 * 
 	 * @param char character to be tested
 	 * @return true, if character can be part of query 
 	 */
	private static function isCharOfQuery(char:String):Boolean {
		return (char != "#"); 
	}

	// Fragment component is indicated by the presence of a  number sign ("#") character and terminated by the end of the URI
	
	/**
 	 * Parsing utility function, checks if given string contain prefix for fragment.
 	 * 
 	 * @param str string to be tested
 	 * @return true, if character can be prefix of query 
 	 */
	private static function isPrefixOfFragment(str:String):Boolean {
		return str.charAt(0)=="#";
	}	
	
 	/**
 	 * Parsing utility function, checks if given character can belong to fragment data.
 	 * 
 	 * @param char character to be tested
 	 * @return true, if character can be part of fragment 
 	 */
	private static function isCharOfFragment(char:String):Boolean {
		return true; 
	}	
	
	// Rubbish is data can't be parsed
	
	/**
 	 * Parsing utility function, checks if given string contain prefix for rubbish.
 	 * 
 	 * @param str string to be tested
 	 * @return true, always
 	 */
	private static function isPrefixOfRubbish(str:String):Boolean {
		return true;
	}	
	
 	/**
 	 * Parsing utility function, checks if given character can belong to rubbish.
 	 * 
 	 * @param char character to be tested
 	 * @return true, always 
 	 */
	private static function isCharOfRubbish(char:String):Boolean {
		return true; 
	}	
	
 	/**
 	 * Parsing utility function, checks if given character is alphabet character.
 	 * 
 	 * @param char character to be tested
 	 * @return true, if character is alphabet character 
 	 */
	private static function isCharAlpha(char:String):Boolean {
		return char.toLowerCase()>="a" && char.toLowerCase()<="z";
	}
						
	/** Identification data */
			
	/** Used protocol. Will be lower-cased, can be undefined for local URLs */	
	private var scheme:String;	
	
	/**  String authority, [ userinfo "@" ] host [ ":" port ]. */	
	private var authority:String;
	
	/** Authority string parsed into Map data holder. */
	private var authorityMap:PrimitiveTypeMap;

	/** Array containing path elements. */
	private var path:Array;

	/** Type of the path: URL.PATH_ABEMPTY / URL.PATH_ABSOLUTE  / URL.PATH_ROOTLESS / URL.PATH_EMPTY  */
	private var pathType:Number;

	/** Full filename, with extension. */
	private var file:String;
	
	/** Filename, can be empty. */
	private var filename:String;
	
	/** Extension of requested resource in '.ext' format. */
	private var extension:String;

	/** Optional, query string.*/
	private var query:String;
	 
    /** Optional, query, URLDecoded and putted into {@code PrimitiveTypeMap} data holder.*/	 
	private var queryMap: PrimitiveTypeMap;
	
	/** Data after # anchor, optional. */
	private var fragment:String;
	
	/** end of Identification data, here goes Interaction data	 */
	
	  
	/** Method for request. Made private for validating, use .method instead. 
  	   "POST", "GET" and {@code undefined} are valid values for "http" protocol.
 	   Attribute will be uppercased, empty string will be transformed into {@code undefined} */
	private var method:String;

	/** Data to be sent to URL when making HTTPRequest. */
	private var data:Map;

	/**
	 * Constructs a new {@code URL} instance.
	 *
	 * <p>If the passed-in {@code params} does already contain values, these values do not
	 * get type-checked.
	 * 
	 * @param uri the path to the resource
	 * @param method (optional) method to be used ("GET" or "POST")
	 * @param params (optional) Map to be sent for accessing method
	 */
	public function URL(uri:String, method, params) {
		var result:Object = parseBasic(uri);
		
		scheme = result["Scheme"].toLowerCase();
		parseAndSetAuthority(result["Authority"]);
		parseAndSetPath(result["Path"]);
		parseAndSetQuery(result["Query"]);
		fragment = result["Fragment"];
		if(method) setMethod(method);
		if(params) data = params;
	}
 
  	/**
	 * Returns the method used for this URI.
	 * Value will be uppercased ("POST", "GET")
	 * 
	 * @return method for this URI
	 */
    public function getMethod():String {
        return this.method;
    }
    
    /**
	 * Sets the method used for this URI.
	 * Check is performed for "http" and "https" schemes, valid values is "POST", "GET" and undefied.
	 */
    public function setMethod(value:String):Void {
    	var val:String;
    	
    	val = value.toUpperCase();
    	if(val=="") delete val; 
		if( (scheme=="http" || scheme=="https")
		 	&& val!="POST" && val!="GET" && val!=undefined
		  ) 
			throw new IllegalArgumentException("The passed-in method '" + val + "' for '" + scheme + "' protocol is not allowed.", this, arguments);
        this.method = val;
    }

    /**
	 * Returns the scheme (protocol) used for this URI.
	 * 
	 * @return scheme string
	 */
    public function getScheme():String {
    	return scheme;
    } 

    /**
	 * Returns authority string (RFC 3986 compliant) for this URI.
	 * 
	 * <p>Use {@code getUser}, {@code getPassword}, {@code getHost} and  {@code getPort} for more detailed information. 
	 *  
	 * @return authority string 
	 */
    public function getAuthority():String {
    	return authority;
    } 

    /**
	 * Returns userinfo string (RFC 3986 compliant) for this URI.
	 * 
	 * <p>Note that this string may have another format than [login]:[password].
	 * If it's not, use {@code getUser} and {@code getPassword} for details. 
	 *  
	 * @return userinfo string 
	 */    
    public function getUserinfo():String {
    	return authorityMap.get("userinfo");
    } 

    /**
	 * Returns user login for userinfo of this URI.
	 * 
	 * <p>Note that it's not RFC compliant and may be undefined even if userinfo exists.
	 *  
	 * @return user login 
	 */    
    public function getUser():String {
    	return authorityMap.get("_user");
    } 

    /**
	 * Returns user password for userinfo of this URI.
	 * 
	 * <p>Note that it's not RFC compliant and may be undefined even if userinfo exists.
	 *  
	 * @return user password 
	 */    
    public function getPassword():String {
    	return authorityMap.get("_password");
    } 
     
    /**
	 * Returns host (domain address) of this URI.
	 * 
	 * <p>Pay attention to the tricky URLs like trickyURL = "http://cnn.example.com&story=breaking_news@10.0.0.1/top_story.htm"
	 *  
	 * new {@Code URL(trickyURL).getHost()} will return correct "10.0.0.1", not faked "cnn.example.com". 
	 * 
	 * @return host string 
	 */    
    public function getHost():String {
    	return authorityMap.get("host");
    }

    /**
	 * Returns port of this URI.
	 * 
	 * <p>According to RFC standard, empty port values like "my.example.com:/data.xml" 
	 * will be transformed into undefined and will be omitted during stringifying.
	 *  
	 * @return port string 
	 */    
	public function getPort():String {
    	return authorityMap.get("port");
	}
    
    /**
	 * Returns path array for this URI.
	 * @return path array 
	 */   
    public function getPath():Array {
    	return path;
    } 
    
    /**
	 * Returns RFC compliant path type as number. 
	 * 
	 * <p>Static constants for path types are following:
	 * PATH_ABEMPTY = 0
	 * PATH_ABSOLUTE = 1
	 * PATH_NOSCHEME = 2
	 * PATH_ROOTLESS = 3
	 * PATH_EMPTY = 4
	 *				   
	 * @return pathtype number 
	 */   
    public function getPathType():Number {
    	return pathType;
    } 
    
    /**
	 * Returns full file name, if it's present. 
	 * 
	 * <p>Use {@code getFileName} and {@code getFileExtension} for details
	 * 
	 * @return filename string 
	 */   
    public function getFile():String {
    	return file;
    } 

    /**
	 * Returns file name, if it's present, without extension. 
	 * 
	 * <p>Use {@code getFile} to get full name, and {@code getFileExtension} to get extension
	 * 
	 * @return file name without extension
	 */       
    public function getFileName():String {
    	return filename;
    } 

    /**
	 * Returns file extension without leading dot, if it's present. 
	 * 
	 * <p>Use {@code getFile} to get full name. 
	 * 
	 * @return file extension
	 */ 
    public function getFileExtension():String {
    	return extension;
    }  
  
    /**
	 * Returns query as a string, if it's present. 
	 * 
	 * <p>String is non decoded and not parsed, use {@code getQueryMap} to get parsed parameters. 
	 * 
	 * @return query string
	 */ 
    public function getQuery():String {
    	return query;
    }  

    /**
	 * Returns query as a {@code org.as2lib.holder.map.PrimitiveTypeMap}, parsed and url-decoded. 
	 * 
	 * <p>Use {@code getQuery} to get query string as it passed in URI. 
	 * 
	 * @return query parsed into {@code PrimitiveTypeMap}
	 */     
    public function getQueryMap():Map {
    	return queryMap;
    }  

    /**
	 * Returns query as a {@code org.as2lib.holder.map.PrimitiveTypeMap}, parsed and url-decoded. 
	 * 
	 * <p>Use {@code getQuery} to get query string as it passed in URI. 
	 * 
	 * @return fragment string
	 */         
    public function getFragment():String {
    	return fragment;
    }  
    
    /**
	 * Returns stringified data to be passed to the URL. 
	 * 
	 * @return data as stringified map
	 */         
    public function getData():String {
    	return data ? data.toString() : undefined;
    }      
    	    	
    /**
	 * Returns data map to be passed to the URL. 
	 * 
	 * @return data as stringified map
	 */         
    public function getDataMap():Map {
    	return data ? data : undefined;
    }     
        	    	
	/**
	 * Returns the string representation of this URL.
	 * 
	 * <b>By default it's representation for debug output, use getPath for {@code loadMovie}-like constructs
	 * 
	 * <p>The string representation is obtained using the stringifier returned by the
	 * static {@link #getStringifier} method.
	 *
	 * @return the string representation of this stack
	 */
	public function toString():String {
		return getDebugStringifier().execute(this);
	}
	
	/**
	 * Returns the string representation of this URL.
	 * 
	 * <b>By default it's representation for debug output, use toPath for {@code loadMovie}-like constructs
	 * 
	 * <p>The string representation is obtained using the stringifier returned by the
	 * static {@link #getStringifier} method.
	 *
	 * @return the string representation of this stack
	 */
	public function toPath():String {
		return getPathStringifier().execute(this);
	}
	
	/**
 	 * Setting up authority info and parsing it into structure.
 	 * 
 	 * <p>According to RFC, authority = [ userinfo "@" ] host [ ":" port ].
 	 * The user information, if present, is followed by a  commercial at-sign ("@") that delimits it from the host.
     * userinfo    = *( unreserved / pct-encoded / sub-delims / ":" )
     * 
     * @param authorityString string containing authority information
 	 */
 	private function parseAndSetAuthority(authorityString:String):Void{
 		var j:Number, i:Number = 0;
 		
		if(authorityString.length>0) {
			authority = authorityString;
			authorityMap = new PrimitiveTypeMap();
	 		j = authorityString.indexOf("@", i);
	 		if(j>=0) { parseAndSetUserinfo(authorityString.substring(0, j)); i=j+1; }
	 		
	 		j = authorityString.indexOf(":", i); 
	 		if(j>=0) { 
	 			if(j+1<authorityString.length) 
	 				authorityMap.put("port", authorityString.substring(j+1)); 
	 		} else { 
	 			j = authorityString.length; 
	 		}
	 		authorityMap.put("host", authorityString.substring(i,j).toLowerCase());
		}
 	}

 	/**  
 	 * Parsing userinfo according to [user]:[password] format.
 	 * 
 	 * <p>Note that passing password in the URI is deprecated by RFC (but we still want be able to do this).
 	 * 
 	 * @param userinfoString string containing userinfo information
 	 */ 	
 	private function parseAndSetUserinfo(userinfoString:String):Void{
 		var j = userinfoString.indexOf(":");
 		authorityMap.put("userinfo", userinfoString);
 		if(j>=0) { 
 			authorityMap.put("_user", userinfoString.substring(0, j)); 
 			authorityMap.put("_password", userinfoString.substring(j));
 		}
 	}
 	
	/**
	 * Parsing path into array and defining its type.
	 *   
	 * <p>Path types, according to RFC:
	 *  path-abempty    ; begins with "/" or is empty
     *  path-absolute   ; begins with "/" but not "//"
     *  path-noscheme   ; begins with a non-colon segment
     *  path-rootless   ; begins with a segment
     *  path-empty      ; zero characters
     *  
     * @param pathString string containing path 
     */	
 	private function parseAndSetPath(pathString:String):Void{
		var i:Number;
		var pString:String;
		
 		if(pathString.indexOf("/") == 0) { pathType = (pathString.indexOf("//") ? PATH_ABEMPTY : PATH_ABSOLUTE); } 
 		else if (pathString.indexOf(":") != 0) { pathType = PATH_NOSCHEME; } 
 		else if (pathString.length = 0) { pathType = PATH_EMPTY; } 
 		else { pathType = PATH_ROOTLESS; }
 		
 		// getting rid of prefixes defining path type
 		if(pathType == PATH_ABEMPTY) pString = pathString.substring(1);
 		else if(pathType == PATH_ABSOLUTE) pString = pathString.substring(2);
 		else pString = pathString;  
 		
 		path = pString.split("/");
 		file = String(path.pop());
 		if(path.length == 0) delete path;
 		if(file.length>0) {
 			i = file.lastIndexOf(".");
 			if (i!=-1) extension = file.substring(i+1); else i = pathString.length;
 			filename = file.substring(0, i);
 		} else delete file;
  	}

	/**
	 * Parsing query into {@code PrimitiveTypeMap}, keys and values will be unescaped (url-decoded).
	 * 
	 * @param queryString string containing query information 
     */	
 	private function parseAndSetQuery(queryString:String):Void{
 		var querySplitted:Array;
 		var pairsSplitted:Array;
 		
 		query = queryString;
 		queryMap = new PrimitiveTypeMap();
 		querySplitted = queryString.split("&");
 		for(var i=0;i<querySplitted.length;i++) {
			pairsSplitted = querySplitted[i].split("=");
			queryMap.put(unescape(pairsSplitted[0]), unescape(pairsSplitted[1]));
 		}
 	}

}