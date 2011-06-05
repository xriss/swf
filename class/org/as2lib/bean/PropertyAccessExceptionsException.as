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

import org.as2lib.bean.BeanException;
import org.as2lib.bean.BeanWrapper;
import org.as2lib.bean.PropertyAccessException;
import org.as2lib.util.StringUtil;

/**
 * {@code PropertyAccessExceptionsException} is a combined exception, composed of
 * individual property access exceptions. An object of this class is created at
 * the beginning of the binding process, and errors added to it as necessary.
 * 
 * <p>The binding process continues when it encounters application-level
 * property access exceptions, applying those changes that can be applied and
 * storing rejected changes in an object of this class.
 * 
 * @author Simon Wacker
 */
class org.as2lib.bean.PropertyAccessExceptionsException extends BeanException {
	
	/** The bean wrapper that wraps the target bean. */
	private var beanWrapper:BeanWrapper;
	
	/** The array of {@link PropertyAccessException} instances. */
	private var propertyAccessExceptions:Array;
	
	/**
	 * Constructs a new {@code PropertyAccessExceptionsException} instance.
	 * 
	 * @param beanWrapper the bean wrapper that wraps the target bean
     * @param propertyAccessExceptions the array of {@link PropertyAccessException} instances
     * @param args the arguments passed to the method throwing this exception
	 */
	public function PropertyAccessExceptionsException(beanWrapper:BeanWrapper, propertyAccessExceptions:Array, args:Array) {
		super(null, beanWrapper, args);
		this.beanWrapper = beanWrapper;
		this.propertyAccessExceptions = propertyAccessExceptions;
	}
	
	/**
	 * Returns the bean wrapper that generated this exception.
	 * 
	 * @return the bean wrapper that generated this exception
	 */
	public function getBeanWrapper(Void):BeanWrapper {
		return beanWrapper;
	}
	
	/**
	 * Returns an array containing the bound {@link PropertyAccessException} instances.
	 * 
	 * @return the bound property access exceptions
	 */
	public function getPropertyAccessExceptions(Void):Array {
		return propertyAccessExceptions;
	}
	
	/**
	 * Returns the bean that caused the exceptions.
	 * 
	 * @return the bean that caused the exceptions
	 */
	public function getBean(Void) {
		return beanWrapper.getWrappedBean();
	}
	
	/**
	 * Returns the number of encountered exceptions.
	 * 
	 * @return the number of exceptions
	 */
	public function getExceptionCount(Void):Number {
		return propertyAccessExceptions.length;
	}
	
	/**
	 * Returns the property access exception for the property with the given name or
	 * {@code null} if there is no exception for the property.
	 * 
	 * @param propertyName the name of the property to return the exception for
	 * @return the exception raised by the property or {@code null} if none
	 */
	public function getPropertyAccessException(propertyName:String):PropertyAccessException {
		for (var i:Number = 0; i < propertyAccessExceptions.length; i++) {
			var pae:PropertyAccessException = propertyAccessExceptions[i];
			if (propertyName == pae.getPropertyName()) {
				return pae;
			}
		}
		return null;
	}
	
	public function getMessage(Void):String {
		var result:String = "PropertyAccessExceptionsException (" + getExceptionCount() + " error(s))";
		result += ": Nested property access exceptions are: \n";
		for (var i:Number = 0; i < propertyAccessExceptions.length; i++) {
			var pae:PropertyAccessException = this.propertyAccessExceptions[i];
			result += StringUtil.addSpaceIndent(pae.toString(), 2);
			if (i < propertyAccessExceptions.length - 1) {
				result += "\n";
			}
			/*result += "[";
			result += ReflectUtil.getTypeNameForInstance(pae);
			result += ": ";
			result += pae.getMessage();
			result += "]";
			if (i < propertyAccessExceptions.length - 1) {
				result += ", ";
			}*/
		}
		return result;
	}
	
}