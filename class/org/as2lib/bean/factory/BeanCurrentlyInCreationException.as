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
 * {@code BeanCurrentlyInCreationException} get thrown in case of a reference to a bean
 * that is currently in creation.
 * 
 * @author Simon Wacker
 */
class org.as2lib.bean.factory.BeanCurrentlyInCreationException extends BeanCreationException {
	
	/**
	 * Constructs a new {@code BeanCurrentlyInCreationException} instance.
	 * 
	 * @param beanName the name of the bean that is currently in creation
	 * @param message the message describing the problem in detail, if {@code null}
	 * default message is used
	 * @param scope the scope at which the exception occurred
	 * @param args the arguments passed to the method that throws this exception
	 */
	public function BeanCurrentlyInCreationException(beanName:String, message:String, scope, args:Array) {
		super(null, beanName, (message == null ? "Requested bean is currently in creation: Is there an unresolvable circular reference?" : message), scope, args);
	}
	
}