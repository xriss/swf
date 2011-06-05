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

import org.as2lib.bean.InvalidPropertyException;

/**
 * {@code NullValueInNestedPathException} is thrown when navigation of a valid nested
 * property path encounters a {@code null} value.
 * 
 * @author Simon Wacker
 */
class org.as2lib.bean.NullValueInNestedPathException extends InvalidPropertyException {
	
	/**
	 * Constructs a new {@code NullValueInNestedPathException} instance.
	 * 
	 * @param bean the bean the property was tried to be accessed on
	 * @param propertyName the name of the property tried to be accessed
	 * @param message the message describing the exception in further detail
	 * @param scope the scope on which the method that throws this exception is invoked
	 * @param args the arguments passed-to the method that throws this exception
	 */
	public function NullValueInNestedPathException(bean, propertyName:String, message:String, scope, args:Array) {
		super(bean, propertyName, (message == null ? "Value of nested property '" + propertyName + "' is 'null'." : message), scope, args);
	}
	
}