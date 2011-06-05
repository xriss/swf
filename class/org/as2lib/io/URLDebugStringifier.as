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

import org.as2lib.io.URL; 
import org.as2lib.io.URLStringifier;

/**
 * {@code URLDebugStringifier} is the default stringifier used to stringify {@link URL}
 * instances.
 *
 * @author Akira Ito
 */

class org.as2lib.io.URLDebugStringifier extends URLStringifier {
	/**
	 * Returns the string representation of the passed-in {@code target} {@code org.as2lib.io.URL}.
	 * 
	 * <p>The string representation of instances of the class {@code org.as2lib.io.URL} 
	 * looks like this:
	 * <pre>
	 *   [URL 'http://www.as2lib.org/data.swf', "POST", [{@code org.as2lib.core.BasicClass}.toString()]]
	 * </pre>
	 *
	 * @param target the {@code org.as2lib.io.URL} object to stringify
	 * @return the string representation of the passed-in {@code org.as2lib.io.URL} object
	 * 
	 * @author Akira Ito
	 * @version 1.0 
	 */
	public function execute(target:URL):String {
		var uri:URL = target;
		var result:String = "[URL ";
		
		result += "'"+uri.toPath()+"'";
		if(uri.getMethod()) result += ", \""+uri.getMethod()+"\"";
		if(uri.getData())  result += ", ["+uri.getData()+"]";
		result += "]";
		return result;
	}
	
}