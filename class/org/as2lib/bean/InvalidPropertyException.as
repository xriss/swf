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

import org.as2lib.bean.FatalBeanException;
import org.as2lib.env.reflect.ReflectUtil;

/**
 * {@ode InvalidPropertyException} is thrown when referring to an invalid bean property.
 * It carries the offending bean class and property name.
 * 
 * @author Simon Wacker
 */
class org.as2lib.bean.InvalidPropertyException extends FatalBeanException {
	
	/** The bean the property was tried to be accessed on. */
	private var bean;
	
	/** The name of the property tried to be accessed. */
	private var propertyName:String;
	
	/**
	 * Constructs a new {@code InvalidPropertyException} instance.
	 * 
	 * @param bean the bean the property was tried to be accessed on
	 * @param propertyName the name of the property tried to be accessed
	 * @param message the message describing the exception in further detail
	 * @param scope the scope on which the method that throws this exception is invoked
	 * @param args the arguments passed-to the method that throws this exception
	 */
	public function InvalidPropertyException(bean, propertyName:String, message:String, scope, args:Array) {
		super("Invalid property '" + propertyName + "' of bean class [" + ReflectUtil.getTypeName(bean) + "]: " + message, scope, args);
		this.bean = bean;
		this.propertyName = propertyName;
	}
	
	/**
	 * Returns the bean the property was tried to be accessed on.
	 * 
	 * @return the bean the property was tried to be accessed on
	 */
	public function getBean(Void) {
		return bean;
	}
	
	/**
	 * Returns the name of the property that was tried to be accessed.
	 * 
	 * @return the name of the property tried to be accessed
	 */
	public function getPropertyName(Void):String {
		return propertyName;
	}

}