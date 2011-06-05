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
 * {@code NotReadablePropertyException} is thrown on an attempt to get the value of a
 * property that is not readable, because there is no getter method.
 * 
 * @author Simon Wacker
 */
class org.as2lib.bean.NotReadablePropertyException extends InvalidPropertyException {
	
	/**
	 * Constructs a new {@code NotReadablePropertyException} instance.
	 * 
	 * @param bean the offending bean
	 * @param propertyName the name of the property that threw an exception on get-access
	 * @param scope the {@code this}-scope of the method throwing this exception
	 * @param args the arguments passed to the throwing method
	 */
	public function NotReadablePropertyException(bean, propertyName:String, scope, args:Array) {
		super(bean, propertyName, "Bean property '" + propertyName + "' is not readable.", scope, args);
	}
	
}