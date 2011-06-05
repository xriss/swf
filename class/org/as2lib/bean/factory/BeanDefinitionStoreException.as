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
 * {@code BeanDefinitionStoreException} is thrown when a bean factory encounters an
 * internal error, and its definitions are invalid: for example, if an XML document
 * containing bean definitions isn't well-formed.
 * 
 * @author Simon Wacker
 */
class org.as2lib.bean.factory.BeanDefinitionStoreException extends FatalBeanException {
	
	/** The name of the bean that could not be stored. */
	private var beanName:String;
	
	/**
	 * Constructs a new {@code BeanDefinitionStoreException} instance.
	 * 
	 * @param beanName the name of the bean that could not be stored
	 * @param message the message describing the problem in detail
	 * @param scope the scope at which the exception occurred
	 * @param args the arguments passed to the method that throws this exception
	 */
	public function BeanDefinitionStoreException(beanName:String, message:String, scope, args:Array) {
		super(buildMessage(beanName, message), scope, args);
		this.beanName = beanName;
	}
	
	/**
	 * Builds the message, depending on whether bean name is {@code null} or not.
	 * 
	 * @param beanName the name of the bean that could not be stored
	 * @param message the supplied message describing the problem
	 */
	private function buildMessage(beanName:String, message:String):String {
		if (beanName == null) return message;
		return "Error registering bean with name '" + beanName + "': " + message;
	}
	
	/**
	 * Returns the name of the bean that could not be stored.
	 * 
	 * @return the name of the bean that could not be stored
	 */
	public function getBeanName(Void):String {
		return beanName;
	}
	
}