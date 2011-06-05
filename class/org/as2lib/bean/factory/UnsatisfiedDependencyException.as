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
 * {@code UnsatisfiedDependencyException} is thrown when a bean depends on other
 * beans or simple properties that were not specified in the bean factory definition,
 * although dependency checking was enabled.
 * 
 * @author Simon Wacker
 */
class org.as2lib.bean.factory.UnsatisfiedDependencyException extends BeanCreationException {
	
	/**
	 * Constructs a new {@code UnsatisfiedDependencyException} instance.
	 * 
	 * @param beanName the name of the bean that could not be created because of an
	 * unsatisfied dependency
	 * @param propertyName the name of the property that is unsatisfied
	 * @param message the message describing this exception in more detail
	 * @param scope the {@code this}-scope of the throwing method
	 * @param args the arguments passed to the throwing method
	 */
	public function UnsatisfiedDependencyException(beanName:String, propertyName:String, message:String, scope, args:Array) {
		super(beanName, "Unsatisfied dependency expressed through bean property '" + propertyName + "'" + (message != null ? ": " + message : "."), scope, args);
	}

}