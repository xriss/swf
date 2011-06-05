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

import org.as2lib.bean.BeanWrapper;
import org.as2lib.bean.PropertyValue;
import org.as2lib.core.BasicClass;

/**
 * {@code PropertyAccess} provides easy access to a property on a given bean and gives
 * information about whether set and/or get access was made.
 *
 * @author Simon Wacker
 */
class org.as2lib.bean.PropertyAccess extends BasicClass {
	
	private var beanWrapper:BeanWrapper;
	
	private var propertyValue:PropertyValue;
	
	private var setAccessed:Boolean;
	
	private var getAccessed:Boolean;
	
	/**
	 * Constructs a new {@code PropertyAccess} instance.
	 * 
	 * @param beanWrapper the wrapper around the bean to access a property on
	 * @param propertyValue the property to access
	 */
	public function PropertyAccess(beanWrapper:BeanWrapper, propertyValue:PropertyValue) {
		this.beanWrapper = beanWrapper;
		this.propertyValue = propertyValue;
		setAccessed = false;
		getAccessed = false;
	}
	
	/**
	 * Returns the name of the property to access.
	 */
	public function getName(Void):String {
		return propertyValue.getName();
	}
	
	/**
	 * Returns the bean the property is accessed on.
	 */
	public function getBean(Void) {
		return beanWrapper.getWrappedBean();
	}
	
	/**
	 * Sets the property to the given value.
	 */
	public function setValue(value):Void {
		setAccessed = true;
		propertyValue.setValue(value);
		beanWrapper.setPropertyValue(propertyValue);
	}
	
	/**
	 * Returns whether the property was set-accessed at least once.
	 */
	public function wasSetAccessed(Void):Boolean {
		return setAccessed;
	}
	
	/**
	 * Returns the current value of the property.
	 */
	public function getValue(Void) {
		getAccessed = true;
		return beanWrapper.getPropertyValue(propertyValue.getName());
	}
	
	/**
	 * Returns whether the property was get-accessed at least once.
	 */
	public function wasGetAccessed(Void):Boolean {
		return getAccessed;
	}
	
}