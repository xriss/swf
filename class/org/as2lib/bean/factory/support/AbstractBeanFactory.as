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
import org.as2lib.bean.PropertyAccess;
import org.as2lib.core.BasicClass;
import org.as2lib.env.overload.Overload;

/**
 * {@code AbstractBeanFactory} declares constants and implements methods commonly
 * needed by bean factory implementations.
 * 
 * @author Simon Wacker
 */
class org.as2lib.bean.factory.support.AbstractBeanFactory extends BasicClass {
	
	/**
	 * Used to dereference a {@link FactoryBean} and distinguish it from beans
	 * <i>created</i> by the factory bean. For example, if the bean named
	 * {@code myBean} is a factory bean, getting {@code &myBean} will return
	 * the factory, not the instance returned by the factory.
	 */
	public static var FACTORY_BEAN_PREFIX:String = "&";
	
	/** This instance properly typed. */
	private var thiz:BeanFactory;
	
	/**
	 * Constructs a new {@code AbstractBeanFactory} instance.
	 */
	private function AbstractBeanFactory(Void) {
		thiz = BeanFactory(this);
	}
	
	/**
	 * @overload #getBeanByName
	 * @overload #getBeanByNameAndType
	 */
	public function getBean() {
		var o:Overload = new Overload(this);
		o.addHandler([String], thiz.getBeanByName);
		o.addHandler([String, PropertyAccess], thiz.getBeanByName);
		o.addHandler([String, Function], thiz.getBeanByNameAndType);
		o.addHandler([String, Function, PropertyAccess], thiz.getBeanByNameAndType);
		return o.forward(arguments);
	}
	
}