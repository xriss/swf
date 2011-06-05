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

import org.as2lib.core.BasicInterface;

/**
 * {@code PropertyValueConverter} converts a value to a given type.
 * 
 * @author Simon Wacker
 */
interface org.as2lib.bean.PropertyValueConverter extends BasicInterface {
	
	/**
	 * Converts the given {@code value} to the given {@code type} if possible.
	 * 
	 * @param value the value to convert
	 * @param type the type to convert the value to
	 * @throws IllegalArgumentException if the given value cannot be converted to
	 * the given type
	 */
	public function convertPropertyValue(value:String, type:Function);
	
}