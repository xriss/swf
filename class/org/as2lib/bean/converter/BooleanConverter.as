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

import org.as2lib.bean.PropertyValueConverter;
import org.as2lib.core.BasicClass;
import org.as2lib.env.except.IllegalArgumentException;

/**
 * {@code BooleanConverter} converts values to booleans.
 * 
 * @author Simon Wacker
 */
class org.as2lib.bean.converter.BooleanConverter extends BasicClass implements PropertyValueConverter {
	
	/** String value for {@code true}. */
	public static var VALUE_TRUE:String = "true";
	
	/** String value for {@code false}. */
	public static var VALUE_FALSE:String = "false";
	
	/** String value for {@code true}. */
	public static var VALUE_ON:String = "on";
	
	/** String value for {@code false}. */
	public static var VALUE_OFF:String = "off";
	
	/** String value for {@code true}. */
	public static var VALUE_YES:String = "yes";
	
	/** String value for {@code false}. */
	public static var VALUE_NO:String = "no";
	
	/** String value for {@code true}. */
	public static var VALUE_1:String = "1";
	
	/** String value for {@code false}. */
	public static var VALUE_0:String = "0";
	
	/**
	 * Constructs a new {@code BooleanConverter} instance.
	 */
	public function BooleanConverter(Void) {
	}
	
	/**
	 * Converts the given {@code value} to a primitive boolean or the given
	 * {@code type}.
	 * 
	 * <p>If the given {@code type} is not {@code Boolean}, an instance of the type
	 * is created and returned; the value is passed-to the constructor.
	 * 
	 * <p>If value equals one of the constants declared by this class, the appropriate
	 * boolean is returned.
	 * 
	 * @param value the value to convert
	 * @param type the type to convert the value to
	 * @return the converted value
	 * @throws IllegalArgumentException if {@code value} is not convertable to a
	 * boolean
	 */
	public function convertPropertyValue(value:String, type:Function) {
		if (type != null && type != Boolean) {
			return new type(value);
		}
		if (value == VALUE_TRUE || value == VALUE_ON || value == VALUE_YES || value == VALUE_1) {
			return true;
		}
		if (value == VALUE_FALSE || value == VALUE_OFF || value == VALUE_NO || value == VALUE_0) {
			return false;
		}
		throw new IllegalArgumentException("Invalid boolean value '" + value + "'.", this, arguments);
	}
	
}