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

/**
 * {@code NoSuchBeanDefinitionException} is thrown when a bean factory is asked for
 * a bean instance name for which it cannot find a definition.
 * 
 * @author Simon Wacker
 */
class org.as2lib.bean.factory.NoSuchBeanDefinitionException extends BeanException {
	
	/** The name of the asked for bean. */
	private var beanName:String;
	
	/**
	 * Constructs a new {@code NoSuchBeanDefinitionException} instance.
	 * 
	 * @param beanName the name of the bean that has no definition in the bean
	 * factory
	 * @param message the message containing more details
	 * @param scope the {@code this}-scope of the throwing method
	 * @param args the arguments passed to the throwing method
	 */
	public function NoSuchBeanDefinitionException(beanName:String, message:String, scope, args:Array) {
		super("No bean named '" + beanName + "' is defined" + (message == null ? "." : ": " + message), scope, args);
		this.beanName = beanName;
	}
	
	/**
	 * Returns the name of the bean asked for whose definition cannot be found in the
	 * bean factory.
	 * 
	 * @return the name of the asked for bean
	 */
	public function getBeanName(Void):String {
		return beanName;
	}
	
}