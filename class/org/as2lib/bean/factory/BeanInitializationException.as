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
 * {@code BeanInitializationException} is thrown by a bean implementation if its own
 * factory-aware initialization code fails. Bean exceptions thrown by bean factory
 * methods themselves should simply be propagated as-is.
 *
 * <p>Note that non-factory-aware initialization methods like {@code afterPropertiesSet}
 * or a custom "init-method" can throw any exception.
 *
 * @author Simon Wacker
 */
class org.as2lib.bean.factory.BeanInitializationException extends FatalBeanException {

	/**
	 * Constructs a new {@code BeanInitializationException} instance.
	 *
	 * @param message the message describing the problem in detail
	 * @param scope the scope at which the exception occurred
	 * @param args the arguments passed to the method that throws this exception
	 */
	public function BeanInitializationException(message:String, scope, args:Array) {
		super(message, scope, args);
	}

}