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

/**
 * {@code LookupOverride} represents an override of a method that looks up a bean
 * in the same IoC context.
 *
 * <p>Methods eligible for lookup override should not have arguments.
 *
 * @author Simon Wacker
 */
class org.as2lib.bean.factory.support.LookupOverride extends MethodOverride {

	/** The name of the bean to look up. */
	private var beanName:String;

	/**
	 * Constructs a new {@code LookupOverride} instance.
	 *
	 * @param methodName the name of the method to override
	 * @param beanName the name of the bean in the current bean factory or application
	 * context that the overriden method should return
	 */
	public function LookupOverride(methodName:String, beanName:String) {
		super(methodName);
		this.beanName = beanName;
	}

	/**
	 * Returns the name of the bean that should be returned by this override.
	 *
	 * @return the name of the bean that shall be looked-up
	 */
	public function getBeanName(Void):String {
		return beanName;
	}

	/**
	 * Returns the lookup-override proxy to override the original method with.
	 */
	public function getProxy(beanFactory:BeanFactory):Function {
		var result:Function = function() {
			var bf:BeanFactory = arguments.callee.beanFactory;
			return bf.getBeanByName(arguments.callee.beanName);
		};
		result.beanFactory = beanFactory;
		result.beanName = beanName;
		return result;
	}

}