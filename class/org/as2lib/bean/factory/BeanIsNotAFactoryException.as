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

import org.as2lib.bean.factory.BeanNotOfRequiredTypeException;
import org.as2lib.bean.factory.FactoryBean;

/**
 * {@code BeanIsNotAFactoryException} is thrown when a bean is not a factory, but a
 * user tries to get at the factory for the given bean name. Whether a bean is a
 * factory is determined by whether it implements the {@link FactoryBean} interface.
 * 
 * @author Simon Wacker
 */
class org.as2lib.bean.factory.BeanIsNotAFactoryException extends BeanNotOfRequiredTypeException {
	
	/**
	 * Constructs a new {@code BeanIsNotAFactoryException} instance.
	 * 
	 * @param beanName the name of the bean that is not a factory
	 * @param actualType the actual type of the bean
	 * @param scope the {@code this}-scope of the method throwing this excepiton
	 * @param args the arguments passed to the method throwing this exception
	 */
	public function BeanIsNotAFactoryException(beanName:String, actualType:Function, scope, args:Array) {
		super(beanName, FactoryBean, actualType, scope, args);
	}

}