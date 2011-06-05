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

import org.as2lib.core.BasicClass;

/**
 * {@code RuntimeBeanReference} is an immutable placeholder class used for the
 * value of a {@link PropertyValue} instance when it is a reference to another
 * bean in this factory that shall be resolved at runtime.
 * 
 * @author Simon Wacker
 */
class org.as2lib.bean.factory.config.RuntimeBeanReference extends BasicClass {
	
	/** The name of the target bean. */
	private var beanName:String;
	
	/** Is this an explicit reference to a bean in the parent factory? */
	private var toParent:Boolean;
	
	/**
	 * Constructs a new {@code RuntimeBeanReference} instance.
	 * 
	 * @param beanName the name of the target bean
	 * @param toParent whether this is an explicit reference to a bean in the parent
	 * factory
	 */
	public function RuntimeBeanReference(beanName:String, toParent:Boolean) {
		this.beanName = beanName;
		this.toParent = toParent == null ? false : toParent;
	}
	
	/**
	 * Returns the name of the target bean.
	 * 
	 * @return the target bean name
	 */
	public function getBeanName(Void):String {
		return beanName;
	}
	
	/**
	 * Returns whether this is an explicit reference to a bean in the parent factory.
	 * 
	 * @return whether this is an explicit reference to a bean in the parent factory
	 */
	public function isToParent(Void):Boolean {
		return toParent;
	}
	
}