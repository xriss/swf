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

import org.as2lib.bean.factory.config.ConstructorArgumentValues;
import org.as2lib.bean.factory.support.AbstractBeanDefinition;
import org.as2lib.bean.factory.support.BeanDefinitionValidationException;
import org.as2lib.bean.PropertyValues;

/**
 * {@code ChildBeanDefinition} is a bean definition for beans which inherit settings
 * from their parent.
 * 
 * <p>Will use the bean class of the parent if none specified, but can also override it.
 * In the latter case, the child bean class must be compatible with the parent, i.e.
 * accept the parent's property values and constructor argument values, if any.
 * 
 * <p>A child bean definition will inherit constructor argument values, property values
 * and method overrides from the parent, with the option to add new values. If init
 * method, destroy method and/or static factory method are specified, they will override
 * the corresponding parent settings.
 * 
 * <p>The remaining settings will always be taken from the child definition: depends on,
 * autowire mode, dependency check, singleton, lazy init.
 * 
 * @author Simon Wacker
 */
class org.as2lib.bean.factory.support.ChildBeanDefinition extends AbstractBeanDefinition {
	
	/** The name of the parent bean definition. */
	private var parentName:String;
	
	/**
	 * Constructs a new {@code ChildBeanDefinition} instance.
	 * 
	 * @param parentName the name of the parent bean definition
	 * @param constructorArgumentValues the values of the constructor arguments
	 * @param propertyValues the values of the properties
	 */
	public function ChildBeanDefinition(parentName:String, constructorArgumentValues:ConstructorArgumentValues, propertyValues:PropertyValues) {
		super(constructorArgumentValues, propertyValues);
		this.parentName = parentName;
	}
	
	/**
	 * Returns the name of the parent bean definition of this bean definition.
	 * 
	 * @return the name of the parent bean definition
	 */
	public function getParentName(Void):String {
		return parentName;
	}
	
	public function validate(Void):Void {
		super.validate();
		if (parentName == null) {
			throw new BeanDefinitionValidationException("The name of the parent must be set in child bean definitions.", this, arguments);
		}
	}
	
	public function toString():String {
		return ("Child bean with parent '" + parentName + "': " + super.toString());
	}
	
}