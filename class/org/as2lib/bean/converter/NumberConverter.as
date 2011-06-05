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
 * {@code NumberConverter} converts values to numbers.
 * 
 * @author Simon Wacker
 */
class org.as2lib.bean.converter.NumberConverter extends BasicClass implements PropertyValueConverter {
	
	/** Will be converted to {@code 1}. */
	public static var VALUE_TRUE:String = "true";
	
	/** Will be converted to {@code 0}. */
	public static var VALUE_FALSE:String = "false";
	
	/**
	 * Constructs a new {@code NumberConverter} instance.
	 */
	public function NumberConverter(Void) {
	}
	
	/**
	 * Converts the given {@code value} to a primitive number or the given {@code type}.
	 * 
	 * <p>If {@code type} is not {@code Number}, an instance of type will be created,
	 * by passing the given {@code value} as argument to the constructor, and returned.
	 * 
	 * <p>If {@coe value} equals one of the constants declared by this class it will
	 * be converted to the appropriate number.
	 * 
	 * <p>If the above do not hold true, it will be checked whether value is a number,
	 * and will be converted to a number if it is one.
	 * 
	 * @param value the value to convert to a number
	 * @param type the specific type to convert the value to
	 * @return the number
	 * @throws IllegalArgumentException if {@code value} is not convertable to a number
	 */
	public function convertPropertyValue(value:String, type:Function) {
		if (type != null && type != Number) {
			return new type(value);
		}
		if (value == VALUE_TRUE) {
			return 1;
		}
		if (value == VALUE_FALSE) {
			return 0;
		}
		if (!isNaN(value)) {
			return Number(value);
		}
		throw new IllegalArgumentException("Invalid number value '" + value + "'.", this, arguments);
	}
	
}