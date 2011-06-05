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

import org.as2lib.bean.PropertyAccessException;

/**
 * {@code MethodInvocationException} gets thrown when a bean property getter or setter
 * method throws an exception.
 * 
 * @author Simon Wacker
 */
class org.as2lib.bean.MethodInvocationException extends PropertyAccessException {
	
	/**
	 * Constructs a new {@code MethodInvocationException} instance.
	 * 
	 * @param bean the bean the property was tried to be accessed on
	 * @param propertyName the name of the property that threw an exception on access
	 * @param message the message describing this exception in further detail
	 * @param scope the {@code this}-scope of the method throwing this exception
	 * @param args the arguments passed to the throwing method
	 */
	public function MethodInvocationException(bean, propertyName:String, message:String, scope, args:Array) {
		super(bean, propertyName, message, scope, args);
	}
	
}