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
import org.as2lib.util.TextUtil;

/**
 * {@code AbstractLogConfigurationParser} provides methods needed by most
 * {@link LogConfigurationParser} implementations.
 * 
 * @author Simon Wacker
 */
class org.as2lib.env.log.parser.AbstractLogConfigurationParser extends BasicClass {
	
	private var logConfiguration:String;
	
	/**
	 * Constructs a new {@code AbstractLogConfigurationParser} instance.
	 */
	private function AbstractLogConfigurationParser(Void) {
	}
	
	/**
	 * Returns the log configuration to parse.
	 */
	public function getLogConfiguration(Void):String {
		return logConfiguration;
	}
	
	/**
	 * Sets the log configuration to parse.
	 */
	public function setLogConfiguration(logConfiguration:String):Void {
		this.logConfiguration = logConfiguration;
	}
	
	/**
	 * Finds the class for the given {@code className}.
	 * 
	 * @param className the name of the class to find
	 * @return the concrete class corresponding to the given {@code className}
	 */
	private function findClass(className:String):Function {
		return eval("_global." + className);
	}
	
	/**
	 * Generates a method name given a {@code prefix} and a {@code body}.
	 * 
	 * @param prefix the prefix of the method name
	 * @param body the body of the method name
	 * @return the generated method name
	 */
	private function generateMethodName(prefix:String, body:String):String {
		return (prefix + TextUtil.ucFirst(body));
	}
	
	/**
	 * Checks whether a method with the given {@code methodName} exists on the given
	 * {@code object}.
	 * 
	 * @param object the object that may have a method with the given name
	 * @param methodName the name of the method
	 * @return {@code true} if the method exists on the object else {@code false}
	 */
	private function existsMethod(object, methodName:String):Boolean {
		try {
			if (object[methodName]) {
				return true;
			}
		} catch (e) {
		}
		return false;
	}
	
	/**
	 * Converts the given {@code value} into its corresponding primitive type.
	 * 
	 * <p>The strings {@code "true"} and {@code "false"} are converted to the booleans
	 * {@code true} and {@code false} respectively. The strings {@code "1"}, {@code "2"},
	 * ... are converted to the appropriate number value. If none of the above holds
	 * true, the passed-in value will be returned unchanged.
	 * 
	 * @param value the value to convert
	 * @return the converted value
	 */
	private function convertValue(value:String) {
		if (value == null) return value;
		if (value == "true") return true;
		if (value == "false") return false;
		if (!isNaN(Number(value))) return Number(value);
		return value;
	}
	
}