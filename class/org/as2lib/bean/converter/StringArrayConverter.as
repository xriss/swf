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

import org.as2lib.bean.BeanUtil;
import org.as2lib.bean.PropertyValueConverter;
import org.as2lib.core.BasicClass;

/**
 * {@code StringArrayConverter} converts a value string to an array.
 * 
 * @author Simon Wacker
 */
class org.as2lib.bean.converter.StringArrayConverter extends BasicClass implements PropertyValueConverter {
	
	/** The default separator of the string array. */
	public static var DEFAULT_SEPARATOR:String = ",";
	
	/** The used separator. */
	private var separator:String;
	
	/**
	 * Constructs a new {@code StringArrayConverter} instance.
	 * 
	 * @param separator the separator the string-array is supposed to be separated with,
	 * the default is {@link #DEFAULT_SEPARATOR}
	 */
	public function StringArrayConverter(separator:String) {
		if (separator == null) {
			separator = DEFAULT_SEPARATOR;
		}
		this.separator = separator;
	}
	
	/**
	 * Converts the given {@code value} to an array or the given {@code type}.
	 * 
	 * <p>If {@code type} is not {@code null} it is instantiated and the appropriate
	 * array fill methods are invoked on it to fill it with contents of the provided
	 * string-array.
	 * 
	 * <p>Otherwise an instance of type {@code Array} is created and filled with
	 * the contents of the given string-array. The individual elements of the
	 * string-array are supposed to be separated by the separator given on construction
	 * of this converter.
	 * 
	 * <p>If {@code value} is {@code null} or an empty string, an empty array will
	 * be returned.
	 * 
	 * @param value the string-array to convert to an {@code Array}
	 * @param type the type to convert the string-array to
	 * @return the array
	 */
	public function convertPropertyValue(value:String, type:Function) {
		if (type != null && type != Array) {
			var array:Array = new type();
			if (value != "") {
				var values:Array = value.split(separator);
				BeanUtil.trimAndConvertValues(values, array);
			}
			return array;
		}
		if (value != "") {
			var values:Array = value.split(separator);
			return BeanUtil.trimAndConvertValues(values);
		}
		return new Array();
	}
	
}