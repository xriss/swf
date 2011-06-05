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

import org.as2lib.bean.factory.config.BeanDefinition;
import org.as2lib.bean.factory.config.BeanDefinitionHolder;
import org.as2lib.bean.factory.config.ConstructorArgumentValue;
import org.as2lib.bean.factory.config.ConstructorArgumentValues;
import org.as2lib.bean.factory.config.RuntimeBeanReference;
import org.as2lib.bean.factory.support.AbstractBeanDefinition;
import org.as2lib.bean.factory.support.ManagedList;
import org.as2lib.bean.factory.support.ManagedMap;
import org.as2lib.bean.factory.support.ManagedProperties;
import org.as2lib.bean.PropertyValue;
import org.as2lib.bean.PropertyValues;
import org.as2lib.core.BasicClass;
import org.as2lib.data.holder.List;
import org.as2lib.data.holder.Map;
import org.as2lib.data.holder.Properties;
import org.as2lib.env.except.AbstractOperationException;

/**
 * {@code BeanDefinitionVisitor} is the visitor base class for traversing
 * {@link BeanDefinition} instances and the {@link PropertyValues} and
 * {@link ConstructorArgumentValues} contained in them.
 *
 * <p>The abstract {@link #resolveStringValue} method has to be implemented in
 * subclasses, following arbitrary resolution strategies.
 *
 * @author Simon Wacker
 * @see BeanDefinition#getPropertyValues
 * @see BeanDefinition#getConstructorArgumentValues
 */
class org.as2lib.bean.factory.config.BeanDefinitionVisitor extends BasicClass {

	/**
	 * Constructs a new {@code BeanDefinitionVisitor} instance.
	 */
	private function BeanDefinitionVisitor(Void) {
	}

	/**
	 * Traverses the given bean definition and the property values and constructor
	 * argument values contained in them.
	 *
	 * @param beanDefinition the bean definition to traverse
	 * @see #resolveStringValue
	 */
	public function visitBeanDefinition(beanDefinition:BeanDefinition):Void {
		visitBeanClassName(AbstractBeanDefinition(beanDefinition));
		var pvs:PropertyValues = beanDefinition.getPropertyValues();
		visitPropertyValues(pvs);
		var cas:ConstructorArgumentValues = beanDefinition.getConstructorArgumentValues();
		visitArgumentValues(cas.getArgumentValues());
	}

	private function visitBeanClassName(beanDefinition:AbstractBeanDefinition):Void {
		var beanClassName:String = beanDefinition.getBeanClassName();
		if (beanClassName != null) {
			var resolvedName:String = resolveStringValue(beanClassName);
			if (beanClassName != resolvedName) {
				beanDefinition.setBeanClassName(resolvedName);
			}
		}
	}

	private function visitPropertyValues(propertyValues:PropertyValues):Void {
		var pvs = propertyValues.getPropertyValues();
		for (var i:Number = 0; i < pvs.length; i++) {
			var pv:PropertyValue = pvs[i];
			var newValue = resolveValue(pv.getValue());
			if (newValue != pv.getValue()) {
				pv.setValue(newValue);
				/*propertyValues.addPropertyValueByPropertyValue(new PropertyValue(
						pv.getName(), newValue, pv.getType(), pv.isEnforceAccess()));*/
			}
		}
	}

	private function visitArgumentValues(argumentValues:Array):Void {
		for (var i:Number = 0; i < argumentValues.length; i++) {
			var argumentValue:ConstructorArgumentValue = argumentValues[i];
			var newValue = resolveValue(argumentValue.getValue());
			if (newValue != argumentValue.getValue()) {
				argumentValue.setValue(newValue);
			}
		}
	}

	private function resolveValue(value) {
		if (value instanceof BeanDefinition) {
			visitBeanDefinition(value);
		}
		else if (value instanceof BeanDefinitionHolder) {
			var holder:BeanDefinitionHolder = value;
			visitBeanDefinition(holder.getBeanDefinition());
		}
		else if (value instanceof RuntimeBeanReference) {
			var ref:RuntimeBeanReference = value;
			var newBeanName:String = resolveStringValue(ref.getBeanName());
			if (newBeanName != ref.getBeanName()) {
				return new RuntimeBeanReference(newBeanName, ref.isToParent());
			}
		}
		else if (value instanceof Array) {
			visitArray(value);
		}
		else if (value instanceof Properties) {
			visitProperties(value);
		}
		else if (value instanceof List) {
			visitList(value);
		}
		else if (value instanceof Map) {
			visitMap(value);
		}
		else if (value instanceof String || typeof(value) == "string") {
			return resolveStringValue(value);
		}
		return value;
	}

	private function visitArray(arrayValue:Array):Void {
		for (var i:Number = 0; i < arrayValue.length; i++) {
			var element = arrayValue[i];
			var newValue = resolveValue(element);
			if (newValue != element) {
				arrayValue[i] = newValue;
			}
		}
	}

	private function visitProperties(propertiesValue:Properties):Void {
		var keys:Array = propertiesValue.getKeys();
		var values:Array = propertiesValue.getValues();
		var isManagedProperties:Boolean = propertiesValue instanceof ManagedProperties;
		for (var i:Number = 0; i < keys.length; i++) {
			var key = keys[i];
			var newKey = resolveValue(key);
			var value = values[i];
			var newValue = resolveValue(value);
			if (isManagedProperties) {
				keys[i] = newKey;
				values[i] = newValue;
			}
			else {
				var isNewKey:Boolean = newKey != key;
				if (isNewKey) {
					propertiesValue.remove(key);
				}
				if (isNewKey || newValue != value) {
					propertiesValue.setProp(newKey, newValue);
				}
			}
		}
	}

	private function visitList(listValue:List):Void {
		var elements:Array = listValue.toArray();
		var isManagedList:Boolean = listValue instanceof ManagedList;
		for (var i:Number = 0; i < elements.length; i++) {
			var element = elements[i];
			var newValue = resolveValue(element);
			if (newValue != element) {
				if (isManagedList) {
					elements[i] = newValue;
				}
				else {
					listValue.set(i, newValue);
				}
			}
		}
	}

	private function visitMap(mapValue:Map):Void {
		var keys:Array = mapValue.getKeys();
		var values:Array = mapValue.getValues();
		var isManagedMap:Boolean = mapValue instanceof ManagedMap;
		for (var i:Number = 0; i < keys.length; i++) {
			var key = keys[i];
			var newKey = resolveValue(key);
			var value = values[i];
			var newValue = resolveValue(value);
			if (isManagedMap) {
				keys[i] = newKey;
				values[i] = newValue;
			}
			else {
				var isNewKey:Boolean = newKey != key;
				if (isNewKey) {
					mapValue.remove(key);
				}
				if (isNewKey || newValue != value) {
					mapValue.put(newKey, newValue);
				}
			}
		}
	}

	/**
	 * Resolves the given string value, for example parsing placeholders.
	 *
	 * <p>Note that this method is abstract and must be overridden in sub-classes.
	 *
	 * @param stringValue the original string value
	 * @return the resolved string value
	 */
	private function resolveStringValue(stringValue:String):String {
		throw new AbstractOperationException("This method is abstract and must be overridden " +
				"in sub-classes.", this, arguments);
		return null;
	}

}