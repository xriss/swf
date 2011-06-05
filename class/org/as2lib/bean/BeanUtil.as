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
import org.as2lib.env.reflect.ClassNotFoundException;
import org.as2lib.util.TrimUtil;

/**
 * {@code BeanUtil} provides utility methods for beans.
 * 
 * @author Simon Wacker
 */
class org.as2lib.bean.BeanUtil extends BasicClass {
	
	/**
	 * Trims and converts the given string values.
	 * 
	 * <p>If the given destination is {@code null} or {@code undefined}, the given
	 * source itself will be used as destination.
	 * 
	 * @param source the values to trim and convert and copy to the destination
	 * @param destination the destination to put the values on
	 * @return the destination
	 * @see #convertValue
	 */
	public static function trimAndConvertValues(source:Array, destination:Array):Array {
		if (destination == null) {
			destination = source;
		}
		for (var i:Number = 0; i < source.length; i++) {
			var arg:String = TrimUtil.trim(source[i]);
			destination[i] = convertValue(arg);
		}
		return destination;
	}
	
	/**
	 * Converts the given value.
	 * 
	 * <p>Values which are converted:
	 * <ul>
	 *   <li>Numbers are converted to primitive numbers.</li>
	 *   <li>"true" values are converted to {@code true}.</li>
	 *   <li>"false" values are converted to {@code false}.</li>
	 *   <li>All other values are not converted.</li>
	 * </ul>
	 * 
	 * @param value the value to convert
	 * @return the result of the conversion
	 */
	public static function convertValue(value:String) {
		if (!isNaN(value)) {
			return Number(value);
		}
		if (value == "true") {
			return true;
		}
		if (value == "false") {
			return false;
		}
		return value;
	}
	
	/**
	 * Finds the class for the given class name.
	 * 
	 * @param className the name of the class to find
	 * @return the found class
	 */
	public static function findClass(className:String):Function {
		var clazz:Function = null;
		if (className != null) {
			clazz = eval("_global." + className);
			if (clazz == null) {
				throw new ClassNotFoundException("Class with name '" + className + "' could not be found.", eval("th" + "is"), arguments);
			}
		}
		return clazz;
	}
	
}