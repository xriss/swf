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
import org.as2lib.env.reflect.ReflectUtil;

/**
 * {@code BeanNotOfRequiredTypeException} is thrown when a bean does not match the
 * required type.
 * 
 * @author Simon Wacker
 */
class org.as2lib.bean.factory.BeanNotOfRequiredTypeException extends BeanException {
	
	/** The name of the bean. */
	private var beanName:String;
	
	/** The type the bean was expected to have. */
	private var requiredType:Function;
	
	/** The actual type of the bean. */
	private var actualType:Function;
	
	/**
	 * Constructs a new {@code BeanNotOfRequiredTypeException} instance.
	 * 
	 * @param beanName the name of the bean that is not of the required type
	 * @param requiredType the type the bean should have had
	 * @param actualType the actual type of the bean
	 * @param scope the {@code this}-scope of the method throwing this excepiton
	 * @param args the arguments passed to the method throwing this exception
	 */
	public function BeanNotOfRequiredTypeException(beanName:String, requiredType:Function, actualType:Function, scope, args:Array) {
		super(null, scope, args);
		this.beanName = beanName;
		this.requiredType = requiredType;
		this.actualType = actualType;
	}
	
	public function getMessage(Void):String {
		if (message == null) {
			message = "Bean named '" + beanName + "' must be of type [" + ReflectUtil.getTypeNameForType(requiredType) +
					"], but was actually of type [" + ReflectUtil.getTypeNameForType(actualType) + "]";
		}
		return message;
	}
	
	/**
	 * Returns the name of the bean that is not of the required type.
	 * 
	 * @return the name of the bean
	 */
	public function getBeanName(Void):String {
		return beanName;
	}
	
	/**
	 * Returns the type the bean is required to have.
	 * 
	 * @return the required type of the bean
	 */
	public function getRequiredType(Void):Function {
		return requiredType;
	}
	
	/**
	 * Returns the actual type of the bean.
	 * 
	 * @return the actual type of the bean
	 */
	public function getActualType(Void):Function {
		return actualType;
	}
	
}