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

import org.as2lib.bean.factory.BeanCreationException;

/**
 * {@code FactoryBeanNotInitializedException} is thrown if a {@link FactoryBean}
 * is not fully initialized, for example because it is involved in a circular
 * reference. Usually indicated by the {@code getObject} method returning {@code null}.
 * 
 * <p>A circular reference with a factory bean cannot be solved by eagerly caching
 * singleton instances as with normal beans. The reason is that every factory bean
 * needs to be fully initialized before it can return the created bean, while only
 * specific normal beans need to be initialized - that is, if a collaborating bean
 * actually invokes them on initialization instead of just storing the reference.
 * 
 * @author Simon Wacker
 */
class org.as2lib.bean.factory.FactoryBeanNotInitializedException extends BeanCreationException {
	
	/**
	 * Constructs a new {@code BeanCreationException} instance.
	 * 
	 * @param beanName the name of the bean that could not be created
	 * @param message the message describing the problem in detail
	 * @param scope the scope at which the exception occurred
	 * @param args the arguments passed to the method that throws this exception
	 */
	public function FactoryBeanNotInitializedException(beanName:String, message:String, scope, args:Array) {
		super(beanName, message, scope, args);
	}
	
}