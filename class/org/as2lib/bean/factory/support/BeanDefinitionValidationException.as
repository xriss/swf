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
 * {@code BeanDefinitionValidationException} is thrown when the validation of a bean
 * definition failed.
 * 
 * @author Simon Wacker
 */
class org.as2lib.bean.factory.support.BeanDefinitionValidationException extends FatalBeanException {
	
	/**
	 * Constructs a new {@code BeanDefinitionValidationException} instance.
	 * 
	 * @param message the message describing this exception in detail
	 * @param scope the {@code this}-scope of the method that throws this exception
	 * @param args the arguments passed-to the method that throws this exception
	 */
	public function BeanDefinitionValidationException(message:String, scope, args:Array) {
		super(message, scope, args);
	}
	
}