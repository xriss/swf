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

import org.as2lib.bean.factory.support.RootBeanDefinition;
import org.as2lib.bean.PropertyValues;
import org.as2lib.context.ApplicationContext;
import org.as2lib.context.support.GenericApplicationContext;

/**
 * {@code StaticApplicationContext} allows concrete registration of beans and
 * messages in code, rather than from external configuration sources. Mainly useful
 * for testing.
 *
 * @author Simon Wacker
 */
class org.as2lib.context.support.StaticApplicationContext extends GenericApplicationContext {

	/**
	 * Constructs a new {@code StaticApplicationContext} instance.
	 */
	public function StaticApplicationContext(parent:ApplicationContext) {
		super(parent);
	}

	/**
	 * Registers a singleton bean with the underlying bean factory.
	 *
	 * <p>For more advanced needs, register with the underlying bean factory directly.
	 *
	 * @see #getDefaultBeanFactory
	 */
	public function registerSingleton(name:String, clazz:Function, propertyValues:PropertyValues):Void {
		var beanDefinition:RootBeanDefinition = new RootBeanDefinition(null, propertyValues);
		beanDefinition.setBeanClass(clazz);
		getDefaultBeanFactory().registerBeanDefinition(name, beanDefinition);
	}

	/**
	 * Registers a prototype bean with the underlying bean factory.
	 *
	 * <p>For more advanced needs, register with the underlying bean factory directly.
	 *
	 * @see #getDefaultBeanFactory
	 */
	public function registerPrototype(name:String, clazz:Function, propertyValues:PropertyValues):Void {
		var beanDefinition:RootBeanDefinition = new RootBeanDefinition(null, propertyValues);
		beanDefinition.setBeanClass(clazz);
		beanDefinition.setSingleton(false);
		getDefaultBeanFactory().registerBeanDefinition(name, beanDefinition);
	}

}