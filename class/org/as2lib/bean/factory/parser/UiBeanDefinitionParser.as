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

import org.as2lib.bean.AbstractBeanWrapper;
import org.as2lib.bean.factory.BeanDefinitionStoreException;
import org.as2lib.bean.factory.config.BeanDefinition;
import org.as2lib.bean.factory.config.BeanDefinitionHolder;
import org.as2lib.bean.factory.config.DataBindingFactoryBean;
import org.as2lib.bean.factory.config.MethodInvokingFactoryBean;
import org.as2lib.bean.factory.config.PropertyPathFactoryBean;
import org.as2lib.bean.factory.config.RuntimeBeanReference;
import org.as2lib.bean.factory.config.VariableRetrievingFactoryBean;
import org.as2lib.bean.factory.parser.XmlBeanDefinitionParser;
import org.as2lib.bean.factory.support.AbstractBeanDefinition;
import org.as2lib.bean.factory.support.BeanDefinitionRegistry;
import org.as2lib.bean.PropertyValue;
import org.as2lib.bean.PropertyValues;
import org.as2lib.context.support.LoadingApplicationContextFactoryBean;
import org.as2lib.env.reflect.DelegateFactoryBean;
import org.as2lib.util.StringUtil;
import org.as2lib.util.TextUtil;

/**
 * @author Simon Wacker
 */
class org.as2lib.bean.factory.parser.UiBeanDefinitionParser extends XmlBeanDefinitionParser {

	public static var KEY_PREFIX:String = "{";
	public static var KEY_SUFFIX:String = "}";

	public static var PROPERTY_PATH_PREFIX:String = "p";
	public static var VARIABLE_RETRIEVAL_PREFIX:String = "v";
	public static var METHOD_INVOCATION_PREFIX:String = "m";
	public static var DELEGATE_PREFIX:String = "d";
	public static var RUNTIME_BEAN_REFERENCE_PREFIX:String = "r";
	public static var DATA_BINDING_PREFIX:String = "b";

	public static var POPULATE_PREFIX:String = "_";
	public static var INSTANTIATE_WITH_PROPERTY_SUFFIX:String = "_";
	public static var ENFORCE_ACCESS_PREFIX:String = "_";

	public static var PROPERTY_KEY_SEPARATOR:String = "-";

	public static var PROPERTY_PATH_FACTORY_BEAN_CLASS_NAME:String = "org.as2lib.bean.factory.config.PropertyPathFactoryBean";
	public static var VARIABLE_RETRIEVING_FACTORY_BEAN_CLASS_NAME:String = "org.as2lib.bean.factory.config.VariableRetrievingFactoryBean";
	public static var METHOD_INVOKING_FACTORY_BEAN_CLASS_NAME:String = "org.as2lib.bean.factory.config.MethodInvokingFactoryBean";
	public static var DELEGATE_FACTORY_BEAN_CLASS_NAME:String = "org.as2lib.env.reflect.DelegateFactoryBean";
	public static var DATA_BINDING_FACTORY_BEAN_CLASS_NAME = "org.as2lib.bean.factory.config.DataBindingFactoryBean";
	public static var LOADING_APPLICATION_CONTEXT_FACTORY_BEAN_CLASS_NAME = "org.as2lib.context.support.LoadingApplicationContextFactoryBean";

	/**
	 * Constructs a new {@code UiBeanDefinitionParser} instance with a default bean
	 * definition registry.
	 *
	 * @param registry the default registry to register bean definitions to
	 */
	public function UiBeanDefinitionParser(registry:BeanDefinitionRegistry) {
		super(registry);
		// forces classes to be included in the swf
		var p:Function = PropertyPathFactoryBean;
		var v:Function = VariableRetrievingFactoryBean;
		var m:Function = MethodInvokingFactoryBean;
		var d:Function = DelegateFactoryBean;
		var b:Function = DataBindingFactoryBean;
		var l:Function = LoadingApplicationContextFactoryBean;
	}

	private function parseUnknownElement(element:XMLNode):Void {
		convertBeanElement(element);
		var holder:BeanDefinitionHolder = parseBeanDefinitionElement(element);
		registerBeanDefinition(holder);
	}

	private function convertBeanElement(element:XMLNode):Void {
		// Mtasc ships with Flash 7 sources for xml.
		var namespace:String = getElementNamespace(element);
		var name:String = getElementName(element);
		if (name.charAt(0) == POPULATE_PREFIX) {
			name = name.substring(1);
			element.attributes[POPULATE_ATTRIBUTE] = getPopulateValue();
		}
		if (name.charAt(name.length - 1) == INSTANTIATE_WITH_PROPERTY_SUFFIX) {
			name = name.substring(0, name.length - 1);
			element.attributes[INSTANTIATE_WITH_PROPERTY_ATTRIBUTE] = TRUE_VALUE;
		}
		if (name != BEAN_ELEMENT) {
			if (namespace == "" || namespace == null) {
				element.attributes[PARENT_ATTRIBUTE] = name;
			}
			else {
				if (namespace.indexOf("*") != -1) {
					var applicationContextClass:String = element.attributes[CLASS_ATTRIBUTE];
					var contextClassElement:XMLNode = createPropertyElement("applicationContextClass", applicationContextClass);
					contextClassElement.attributes[TYPE_ATTRIBUTE] = CLASS_TYPE_VALUE;
					element.appendChild(contextClassElement);
					element.attributes[CLASS_ATTRIBUTE] = LOADING_APPLICATION_CONTEXT_FACTORY_BEAN_CLASS_NAME;
					element.attributes[POPULATE_ATTRIBUTE] = POPULATE_BEFORE_VALUE;
					var beanDefinitionUri:String = StringUtil.replace(namespace, "*", name);
					element.appendChild(createPropertyElement("beanDefinitionUri", beanDefinitionUri));
					var targetBeanName:String = TextUtil.lcFirst(name);
					element.appendChild(createPropertyElement("targetBeanName", targetBeanName));
				}
				else {
					if (element.attributes[CLASS_ATTRIBUTE] == null) {
						element.attributes[CLASS_ATTRIBUTE] = namespace + "." + name;
					}
				}
			}
		}
	}

	private function getElementName(element:XMLNode):String {
		var namespace:String = getElementNamespace(element);
		if (namespace == "" || namespace == null) {
			return element.nodeName;
		}
		return element["localName"];
	}

	private function getElementNamespace(element:XMLNode):String {
		var namespace:String = element["namespaceURI"];
		if (element.attributes.x != null) {
			if (element.attributes.x === namespace) {
				return null;
			}
		}
		return namespace;
	}

	private function getPopulateValue(Void):String {
		return POPULATE_AFTER_VALUE;
	}

	private function parseBeanDefinitionElementWithoutRegardToNameOrAliases(element:XMLNode, beanName:String):BeanDefinition {
		for (var i:String in element.attributes) {
			if (i != CLASS_ATTRIBUTE && i != PARENT_ATTRIBUTE
					&& i != ID_ATTRIBUTE && i != NAME_ATTRIBUTE
					&& i != DEPENDS_ON_ATTRIBUTE && i != DEPENDS_ON_ATTRIBUTE
					&& i != FACTORY_METHOD_ATTRIBUTE && i != FACTORY_BEAN_ATTRIBUTE
					&& i != DEPENDENCY_CHECK_ATTRIBUTE && i != AUTOWIRE_ATTRIBUTE
					&& i != INIT_METHOD_ATTRIBUTE && i != DESTROY_METHOD_ATTRIBUTE
					&& i != ABSTRACT_ATTRIBUTE && i != SINGLETON_ATTRIBUTE
					&& i != LAZY_INIT_ATTRIBUTE && i != DEFAULT_PROPERTY_ATTRIBUTE
					&& i != STYLE_ATTRIBUTE && i != POPULATE_ATTRIBUTE) {
				convertAttributeToPropertyElement(i, element);
			}
		}
		return super.parseBeanDefinitionElementWithoutRegardToNameOrAliases(element, beanName);
	}

	private function convertAttributeToPropertyElement(attribute:String, element:XMLNode):Void {
		element.appendChild(createPropertyElement(attribute, element.attributes[attribute]));
		delete element.attributes[attribute];
	}

	private function parseUnknownBeanDefinitionSubElement(element:XMLNode, beanName:String,
			beanDefinition:AbstractBeanDefinition):Void {
		if (element.nodeType == 3) {
			if (element.nodeValue != "") {
				var constructorArgsElement:XMLNode = new XMLNode(1, CONSTRUCTOR_ARGS_ELEMENT);
				constructorArgsElement.appendChild(element);
				parseConstructorArgsElement(constructorArgsElement, beanName, beanDefinition.getConstructorArgumentValues());
			}
		}
		else {
			var elementName:String = getElementName(element);
			if (isUpperCaseLetter(elementName.charAt(0)) || element.nodeName == BEAN_ELEMENT) {
				var pvs:PropertyValues = beanDefinition.getPropertyValues();
				var value = parsePropertySubElement(element, beanName);
				pvs.addPropertyValueByPropertyValue(new PropertyValue(null, value));
			}
			else {
				if (element.attributes[NAME_ATTRIBUTE] == null) {
					element.attributes[NAME_ATTRIBUTE] = elementName;
				}
				parsePropertyElement(element, beanName, beanDefinition.getPropertyValues());
			}
		}
	}

	private function parsePropertyElement(element:XMLNode, beanName:String, propertyValues:PropertyValues):Void {
		if (element.attributes[NAME_ATTRIBUTE] != null) {
			element.attributes[NAME_ATTRIBUTE] = parsePropertyName(element);
		}
		super.parsePropertyElement(element, beanName, propertyValues);
	}

	private function parsePropertyName(propertyElement:XMLNode):String {
		var result:String = propertyElement.attributes[NAME_ATTRIBUTE];
		if (result.charAt(0) == ENFORCE_ACCESS_PREFIX) {
			if (propertyElement.attributes[ENFORCE_ACCESS_ATTRIBUTE] == null) {
				propertyElement.attributes[ENFORCE_ACCESS_ATTRIBUTE] = TRUE_VALUE;
			}
			result = result.substring(1);
		}
		if (result.indexOf(PROPERTY_KEY_SEPARATOR) != -1) {
			var tokens:Array = result.split(PROPERTY_KEY_SEPARATOR);
			result = tokens[0];
			for (var j:Number = 1; j < tokens.length; j++) {
				result += AbstractBeanWrapper.PROPERTY_KEY_PREFIX;
				result += tokens[j];
				result += AbstractBeanWrapper.PROPERTY_KEY_SUFFIX;
			}
		}
		return result;
	}

	private function parsePropertySubElement(element:XMLNode, beanName:String) {
		var propertyValue = super.parsePropertySubElement(element, beanName);
		if (element.attributes[ID_ATTRIBUTE] != null || element.attributes[NAME_ATTRIBUTE] != null ||
				element.attributes[CLASS_ATTRIBUTE] == LOADING_APPLICATION_CONTEXT_FACTORY_BEAN_CLASS_NAME) {
			if (propertyValue instanceof BeanDefinitionHolder) {
				var holder:BeanDefinitionHolder = propertyValue;
				registerBeanDefinition(holder);
				return new RuntimeBeanReference(holder.getBeanName());
			}
		}
		return propertyValue;
	}

	private function parseUnknownPropertySubElement(element:XMLNode, beanName:String) {
		convertBeanElement(element);
		return parseBeanDefinitionElement(element);
	}

	private function parseLiteralValue(value:String, beanName:String) {
		if (isKeyValue(value)) {
			return parseKeyValue(value, beanName);
		}
		return super.parseLiteralValue(value, beanName);
	}

	private function isKeyValue(value:String):Boolean {
		return ((value.charAt(0) == KEY_PREFIX || value.charAt(1) == KEY_PREFIX)
				&& value.charAt(value.length - 1) == KEY_SUFFIX);
	}

	private function parseKeyValue(value:String, beanName:String) {
		var prefixIndex:Number = value.indexOf(KEY_PREFIX);
		var strippedValue:String = value.substring(prefixIndex + 1, value.length - 1);
		var firstChar:String = value.charAt(0);
		if (firstChar == RUNTIME_BEAN_REFERENCE_PREFIX) {
			return parseRuntimeBeanReferenceValue(strippedValue, beanName);
		}
		if (firstChar == DATA_BINDING_PREFIX) {
			return parseDataBindingValue(strippedValue, beanName);
		}
		var tokens:Array = getValueTokens(strippedValue, beanName);
		if (firstChar == PROPERTY_PATH_PREFIX || firstChar == KEY_PREFIX) {
			return parsePropertyPathValue(tokens[1], tokens[2], tokens[0], beanName);
		}
		if (firstChar == VARIABLE_RETRIEVAL_PREFIX) {
			return parseVariableRetrievalValue(tokens[1], tokens[2], tokens[0], beanName);
		}
		if (firstChar == DELEGATE_PREFIX) {
			return parseDelegateValue(tokens[1], tokens[2], tokens[0], beanName);
		}
		if (firstChar == METHOD_INVOCATION_PREFIX) {
			return parseMethodInvocationValue(tokens[1], tokens[2], tokens[0], beanName);
		}
		throw new BeanDefinitionStoreException(beanName, "Unknown key value '" + value + "'.",
				this, arguments);
	}

	private function getValueTokens(strippedValue:String, beanName:String):Array {
		var result:Array = new Array();
		var isStatic:Boolean = false;
		var targetObject:String;
		var targetMember:String;
		var dotIndex:Number;
		var endIndex:Number = strippedValue.indexOf("[");
		if (endIndex == -1) {
			dotIndex = strippedValue.lastIndexOf(".");
		}
		else {
			dotIndex = strippedValue.lastIndexOf(".", endIndex);
		}
		if (dotIndex == -1) {
			targetObject = beanName;
			targetMember = strippedValue;
		}
		else {
			targetObject = strippedValue.substring(0, dotIndex);
			targetMember = strippedValue.substring(dotIndex + 1);
			var lc:String = targetObject.charAt(targetObject.lastIndexOf(".") + 1);
			if (isUpperCaseLetter(lc)) {
				isStatic = true;
			}
			else {
				dotIndex = targetObject.indexOf(".");
				if (dotIndex != -1) {
					targetMember = targetObject.substring(dotIndex + 1) + "." + targetMember;
					targetObject = targetObject.substring(0, dotIndex);
				}
			}
		}
		result.push(isStatic);
		result.push(targetObject);
		result.push(targetMember);
		return result;
	}

	private function isUpperCaseLetter(letter:String):Boolean {
		if (letter == null) {
			return false;
		}
		return (letter.toUpperCase() == letter);
	}

	private function parsePropertyPathValue(targetObject:String, targetMember:String, isStatic:Boolean, beanName:String):BeanDefinitionHolder {
		var result:XMLNode = new XMLNode(1, BEAN_ELEMENT);
		if (isStatic) {
			throw new BeanDefinitionStoreException(beanName, "Property path data binding cannot be used for static properties.", this, arguments);
		}
		result.attributes[CLASS_ATTRIBUTE] = PROPERTY_PATH_FACTORY_BEAN_CLASS_NAME;
		result.attributes[POPULATE_ATTRIBUTE] = POPULATE_BEFORE_VALUE;
		result.appendChild(createPropertyElement("targetBeanName", targetObject));
		result.appendChild(createPropertyElement("propertyPath", targetMember));
		return parseBeanDefinitionElement(result);
	}

	private function parseVariableRetrievalValue(targetObject:String, targetMember:String, isStatic:Boolean, beanName:String):BeanDefinitionHolder {
		var result:XMLNode = new XMLNode(1, BEAN_ELEMENT);
		result.attributes[CLASS_ATTRIBUTE] = VARIABLE_RETRIEVING_FACTORY_BEAN_CLASS_NAME;
		result.attributes[POPULATE_ATTRIBUTE] = POPULATE_BEFORE_VALUE;
		if (isStatic) {
			result.appendChild(createPropertyElement("staticVariable", targetObject + "." + targetMember));
		}
		else {
			result.appendChild(createBeanReferencePropertyElement("targetBeanName", targetObject));
			result.appendChild(createPropertyElement("targetVariable", targetMember));
		}
		return parseBeanDefinitionElement(result);
	}

	private function parseDelegateValue(targetObject:String, targetMember:String, isStatic:Boolean, beanName:String):BeanDefinitionHolder {
		var result:XMLNode = new XMLNode(1, BEAN_ELEMENT);
		if (isStatic) {
			throw new BeanDefinitionStoreException(beanName, "Delegate data binding cannot be used for static methods.", this, arguments);
		}
		result.attributes[CLASS_ATTRIBUTE] = DELEGATE_FACTORY_BEAN_CLASS_NAME;
		result.attributes[POPULATE_ATTRIBUTE] = POPULATE_BEFORE_VALUE;
		result.appendChild(createPropertyElement("targetBeanName", targetObject));
		result.appendChild(createPropertyElement("methodName", targetMember));
		return parseBeanDefinitionElement(result);
	}

	private function parseMethodInvocationValue(targetObject:String, targetMember:String, isStatic:Boolean, beanName:String):BeanDefinitionHolder {
		var result:XMLNode = new XMLNode(1, BEAN_ELEMENT);
		result.attributes[CLASS_ATTRIBUTE] = METHOD_INVOKING_FACTORY_BEAN_CLASS_NAME;
		result.attributes[POPULATE_ATTRIBUTE] = POPULATE_BEFORE_VALUE;
		if (isStatic) {
			result.appendChild(createPropertyElement("staticMethod", targetObject + "." + targetMember));
		}
		else {
			result.appendChild(createBeanReferencePropertyElement("targetBeanName", targetObject));
			result.appendChild(createPropertyElement("targetVariable", targetMember));
		}
		return parseBeanDefinitionElement(result);
	}

	private function parseDataBindingValue(dataBinding:String, beanName:String):BeanDefinitionHolder {
		var result:XMLNode = new XMLNode(1, BEAN_ELEMENT);
		result.attributes[CLASS_ATTRIBUTE] = DATA_BINDING_FACTORY_BEAN_CLASS_NAME;
		result.attributes[POPULATE_ATTRIBUTE] = POPULATE_BEFORE_VALUE;
		result.appendChild(createPropertyElement("dataBinding", dataBinding));
		result.appendChild(createPropertyElement("targetBeanName", beanName));
		return parseBeanDefinitionElement(result);
	}

	private function parseRuntimeBeanReferenceValue(referenceBeanName:String, beanName:String):RuntimeBeanReference {
		return new RuntimeBeanReference(referenceBeanName);
	}

	private function createPropertyElement(name:String, value:String):XMLNode {
		var result:XMLNode = new XMLNode(1, PROPERTY_ELEMENT);
		result.attributes[NAME_ATTRIBUTE] = name;
		if (value != null) {
			result.attributes[VALUE_ATTRIBUTE] = value;
		}
		return result;
	}

	private function createBeanReferencePropertyElement(name:String, referenceBeanName:String):XMLNode {
		var result:XMLNode = createPropertyElement(name);
		var beanReference:XMLNode = new XMLNode(1, REF_ELEMENT);
		beanReference.attributes[BEAN_REF_ATTRIBUTE] = referenceBeanName;
		result.appendChild(beanReference);
		return result;
	}

}