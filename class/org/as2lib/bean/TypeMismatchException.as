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
import org.as2lib.env.reflect.ReflectUtil;

/**
 * {@code TypeMismatchException} is thrown on a type mismatch when trying to set a
 * bean property.
 * 
 * @author Simon Wacker
 */
class org.as2lib.bean.TypeMismatchException extends PropertyAccessException {
	
	/**
	 * Constructs a new {@code TypeMismatchException} instance.
	 * 
	 * @param bean the bean the property was tried to be accessed on
	 * @param propertyName the name of the property that was about to be set
	 * @param propertyValue the value to set for the property
	 * @param requiredType the type the value was expected to have or be converted to
	 * @param message the message describing this exception in further detail
	 * @param scope the {@code this}-scope of the method that throws this exception
	 * @param args the arguments that were passed-to the throwing method
	 */
	public function TypeMismatchException(bean, propertyName:String, propertyValue, requiredType:Function, message:String, scope, args:Array) {
		super(bean, propertyName, "Failed to convert property value of type [" +
				(propertyValue != null ? ReflectUtil.getTypeName(propertyValue) : null) + "]" +
				(requiredType != null ? " to required type [" + ReflectUtil.getTypeNameForType(requiredType) + "]" : "") +
				(propertyName != null ? " for property '" + propertyName + "'" : "") +
				(message != null ? ": " + message : ""), scope, args);
	}
	
}