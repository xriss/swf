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

import org.as2lib.bean.factory.BeanFactory;
import org.as2lib.core.BasicClass;
import org.as2lib.env.except.AbstractOperationException;

/**
 * {@code MethodOverride} represents the override of a method on a managed bean by
 * the IoC container.
 *
 * <p>Note that the override mechanism is not intended as a generic means of inserting
 * crosscutting code: use AOP for that.
 *
 * @author Simon Wacker
 */
class org.as2lib.bean.factory.support.MethodOverride extends BasicClass {

	/** The name of the method to override. */
	private var methodName:String;

	/**
	 * Constructs a new {@code MethodOverride} instance.
	 *
	 * @param methodName the name of the method to override
	 */
	private function MethodOverride(methodName:String) {
		this.methodName = methodName;
	}

	/**
	 * Returns the name of the method to override.
	 *
	 * @return the name of the method to override
	 */
	public function getMethodName(Void):String {
		return methodName;
	}

	/**
	 * Checks whether the given method name matches the name of the method to override.
	 *
	 * @return whether this override matches the given method name
	 */
	public function matches(methodName:String):Boolean {
		return (this.methodName == methodName);
	}

	/**
	 * Returns the proxy to override the original method with.
	 *
	 * <p>Note that this method is abstract and must be overridden in subclasses.
	 *
	 * @param beanFactory the bean factory that manages this method override
	 * @return the proxy method
	 */
	public function getProxy(beanFactory:BeanFactory):Function {
		throw new AbstractOperationException("This method is abstract and must be overridden " +
				"in subclasses.", this, arguments);
		return null;
	}

}