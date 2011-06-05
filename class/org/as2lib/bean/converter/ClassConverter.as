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
 * {@code ClassConverter} converts values to classes.
 * 
 * @author Simon Wacker
 */
class org.as2lib.bean.converter.ClassConverter extends BasicClass implements PropertyValueConverter {
	
	/**
	 * Constructs a new {@code ClassConverter} instance.
	 */
	public function ClassConverter(Void) {
	}
	
	/**
	 * Converts the given {@code value} to a class that must exist in {@code _global}.
	 * 
	 * <p>{@code value} is supposed to be the fully qualified name of a class and must
	 * be available in the swf, that is in {@code _global} to be looked-up and returned.
	 * 
	 * @param value the value to convert to a class
	 * @param type the type to convert the value to (ignored by this implementation)
	 * @return the converted value
	 * @throws IllegalArgumentException if there is no class with the given name
	 */
	public function convertPropertyValue(value:String, type:Function) {
		var clazz:Function = eval("_global." + value);
		if (clazz != null) {
			return clazz;
		}
		throw new IllegalArgumentException("Class with name '" + value + "' could not be found.", this, arguments);
	}
	
}