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
import org.as2lib.bean.factory.support.MethodOverride;
import org.as2lib.bean.factory.support.MethodReplacer;

/**
 * {@code ReplaceOverride} is an extension of method override that represents an
 * arbitrary override of a method by the IoC container.
 *
 * <p>Every method can be overridden, irrespective of its parameters and return types.
 *
 * @author Simon Wacker
 */
class org.as2lib.bean.factory.support.ReplaceOverride extends MethodOverride {

	/** The bean name of the method replacer. */
	private var methodReplacerBeanName:String;

	/**
	 * Constructs a new {@code ReplaceOverride} instance.
	 *
	 * @param methodName the name of the method to replace
	 * @param methodReplacerBeanName the bean name of the method replacer
	 */
	public function ReplaceOverride(methodName:String, methodReplacerBeanName:String) {
		super(methodName);
		this.methodReplacerBeanName = methodReplacerBeanName;
	}

	/**
	 * Returns the name of the bean implementing the {@link MethodReplacer} interface
	 * to invoke instead of the replaced method.
	 *
	 * @return the bean name of the method replacer
	 */
	public function getMethodReplacerBeanName(Void):String {
		return methodReplacerBeanName;
	}

	/**
	 * Returns the replace override proxy to override the original method with.
	 */
	public function getProxy(beanFactory:BeanFactory):Function {
		var result:Function = function() {
			var bf:BeanFactory = arguments.callee.beanFactory;
			var mr:MethodReplacer = bf.getBeanByNameAndType(arguments.callee.beanName, MethodReplacer);
			return mr.reimplement(this, arguments.callee.methodName, arguments);
		};
		result.beanFactory = beanFactory;
		result.beanName = methodReplacerBeanName;
		result.methodName = getMethodName();
		return result;
	}

}