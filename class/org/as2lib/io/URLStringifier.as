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

import org.as2lib.util.Stringifier;
import org.as2lib.io.URL;
 
/**
 * {@code URLStringifier} is the stringifier used to stringify {@link URL} instances into the valid path strings.
 *
 * @author Akira Ito
 */
 
class org.as2lib.io.URLStringifier implements Stringifier {
	/**
	 * Returns the string representation of the passed-in {@code target} {@code org.as2lib.io.URL}.
	 * 
	 * <p>The string representation of instances of the class {@code org.as2lib.io.URL} 
	 * in following format:
	 * <pre>
	 *   [protocol]://[user]:[password]@[domain]:[port][path][file].[extension]?[parameter]#[fragment] 
	 * </pre>
	 *
	 * @param target the {@code org.as2lib.io.URL} object to stringify
	 * @return the string representation of the passed-in {@code org.as2lib.io.URL} object
	 * 
	 * @author Akira Ito
	 * @version 1.0
	 */
	 	
/* Recomposition algorythm based on pseudocode from RFC:

      result = ""

      if defined(scheme) then
         append scheme to result;
         append ":" to result;
      endif;

      if defined(authority) then
         append "//" to result;
         append authority to result;
      endif;

      append path to result;

      if defined(query) then
         append "?" to result;
         append query to result;
      endif;

      if defined(fragment) then
         append "#" to result;
         append fragment to result;
      endif;

*/
	public function execute(target):String {
		var uri:URL = target; 
		var result:String = "";
		var delimiter:String = "/"; 
		
		var scheme:String = uri.getScheme();
		if(scheme) result += scheme + ":";
		
		var authority:String = uri.getAuthority();
		if(authority) {
			result += "//";
			var userinfo:String = uri.getUserinfo();
			if(userinfo) result += userinfo+"@";
			var host:String = uri.getHost();
			if(host) result += host;
			var port:String = uri.getPort();
			if(port) result += ":" + port; 
		}
		var path:Array = uri.getPath();
		if(path) {
			var pathType:Number = uri.getPathType();
 			if(pathType == URL.PATH_ABEMPTY) result += "/";
 			else if(pathType == URL.PATH_ABSOLUTE) result += "//";
			result += path.join(delimiter) + "/";
		}
		var file:String = uri.getFile();
		if(file) result += file;
		var query:String = uri.getQuery(); 
		if(query) result += "?" + query;
		var fragment:String = uri.getFragment();
		if(fragment) result += "#"+fragment;
		
		return result;
	}	
}