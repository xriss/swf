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
import org.as2lib.bean.factory.FactoryBean;
import org.as2lib.bean.factory.support.AbstractBeanDefinition;
import org.as2lib.bean.factory.support.BeanDefinitionValidationException;
import org.as2lib.bean.factory.support.MethodOverrides;
import org.as2lib.bean.PropertyValues;

/**
 * {@code RootBeanDefinition} is the most common type of bean definition. Root bean
 * definitions do not derive from a parent bean definition, and usually have a class
 * plus optionally constructor argument values and property values.
 * 
 * <p>Note that root bean definitions do not have to specify a bean class: This can be
 * useful for deriving childs from such definitions, each with its own bean class but
 * inheriting common property values and other settings.
 * 
 * @author Simon Wacker
 */
class org.as2lib.bean.factory.support.RootBeanDefinition extends AbstractBeanDefinition {
	
	/**
	 * Constructs a new {@code RootBeanDefinition} with the given constructor argument
	 * and property values.
	 * 
	 * @param constructorArgumentValues the constructor argument values
	 * @param propertyValues the property values
	 */
	public function RootBeanDefinition(constructorArgumentValues:ConstructorArgumentValues, propertyValues:PropertyValues) {
		super(constructorArgumentValues, propertyValues);
	}
	
	public function clone(Void):RootBeanDefinition {
		var cav:ConstructorArgumentValues = new ConstructorArgumentValues(constructorArgumentValues);
		var pv:PropertyValues = new PropertyValues(propertyValues);
		var result:RootBeanDefinition = new RootBeanDefinition(cav, pv);
		result.beanClass = beanClass;
		result.beanClassName = beanClassName;
		result.abstract = abstract;
		result.singleton = singleton;
		result.lazyInit = lazyInit;
		result.autowireMode = autowireMode;
		result.dependencyCheck = dependencyCheck;
		result.populateMode = populateMode;
		result.dependsOn = dependsOn;
		result.methodOverrides = new MethodOverrides(methodOverrides);
		result.factoryBeanName = factoryBeanName;
		result.factoryMethodName = factoryMethodName;
		result.initMethodName = initMethodName;
		result.enforceInitMethod = enforceInitMethod;
		result.destroyMethodName = destroyMethodName;
		result.enforceDestroyMethod = enforceDestroyMethod;
		result.defaultPropertyName = defaultPropertyName;
		result.instantiateWithProperty = instantiateWithProperty;
		result.statik = statik;
		result.styleName = styleName;
		result.source = source;
		return result;
	}
	
	public function validate(Void):Void {
		super.validate();
		if (hasBeanClass()) {
			if (getBeanClass().prototype instanceof FactoryBean && !isSingleton()) {
				throw new BeanDefinitionValidationException("Factory bean must be defined as singleton - " +
						"Factory beans themselves are not allowed to be prototypes.", this, arguments);
			}
		}
	}
	
	public function toString():String {
		return "Root bean: " + super.toString();
	}
	
}