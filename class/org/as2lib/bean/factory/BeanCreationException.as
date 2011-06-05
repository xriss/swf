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

/**
 * {@code BeanCreationException} is thrown when a bean factory encounters an error
 * when attempting to create a bean from a bean definition.
 * 
 * @author Simon Wacker
 */
class org.as2lib.bean.factory.BeanCreationException extends FatalBeanException {
	
	/** The name of the bean that could not be created. */
	private var beanName:String;
	
	/**
	 * Constructs a new {@code BeanCreationException} instance.
	 * 
	 * @param beanName the name of the bean that could not be created
	 * @param message the message describing the problem in detail
	 * @param scope the scope at which the exception occurred
	 * @param args the arguments passed to the method that throws this exception
	 */
	public function BeanCreationException(beanName:String, message:String, scope, args:Array) {
		super("Error creating bean with name '" + beanName + "': " + message, scope, args);
		this.beanName = beanName;
	}
	
	/**
	 * Returns the name of the bean requested, if any.
	 * 
	 * @return the name of the requested bean
	 */
	public function getBeanName(Void):String {
		return beanName;
	}
	
}