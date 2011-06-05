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

import org.as2lib.bean.BeanUtil;
import org.as2lib.bean.factory.BeanDefinitionStoreException;
import org.as2lib.bean.factory.config.BeanDefinition;
import org.as2lib.bean.factory.config.BeanDefinitionHolder;
import org.as2lib.bean.factory.config.ConfigurableListableBeanFactory;
import org.as2lib.bean.factory.config.ConstructorArgumentValue;
import org.as2lib.bean.factory.config.ConstructorArgumentValues;
import org.as2lib.bean.factory.config.RuntimeBeanReference;
import org.as2lib.bean.factory.parser.StyleSheetParser;
import org.as2lib.bean.factory.support.RootBeanDefinition;
import org.as2lib.bean.PropertyValue;
import org.as2lib.bean.PropertyValues;
import org.as2lib.core.BasicClass;
import org.as2lib.env.except.IllegalArgumentException;
import org.as2lib.util.StringUtil;
import org.as2lib.util.TrimUtil;

import TextField.StyleSheet;

/**
 * {@code CascadingStyleSheetParser} parses cascading style sheets and formats bean
 * definitions with the read styles.
 *
 * @author Simon Wacker
 */
class org.as2lib.bean.factory.parser.CascadingStyleSheetParser extends BasicClass implements
		StyleSheetParser {

	/** The delimiter to delimit multiple values. */
	public static var VALUE_DELIMITER:String = ",";

	/** Separates the namespace from the class name. */
	public static var NAMESPACE_SEPARATOR:String = "|";

	/** Separates the property name from the property value. */
	public static var NAME_VALUE_SEPARATOR:String = "=";

	public static var NAMESPACE_SELECTOR:String = "@namespace";

	public static var CLASS_SELECTOR_PREFIX:String = ".";
	public static var ID_SELECTOR_PREFIX:String = "#";

	public static var STATIC_VARIABLE_RETRIEVAL_PREFIX:String = "v[";
	public static var STATIC_VARIABLE_RETRIEVAL_SUFFIX:String = "]";

	/**
	 * Separator for generated bean names. If a class name is not unique, "#1", "#2"
	 * etc. will be appended, until the name becomes unique.
	 */
	public static var GENERATED_BEAN_NAME_SEPARATOR:String = "#";

	private var factory:ConfigurableListableBeanFactory;

	private var defaultFactory:ConfigurableListableBeanFactory;

	private var styles:Array;

	private var namespaces;

	/**
	 * Constructs a new {@code CascadingStyleSheetParser} instance.
	 *
	 * @param defaultFactory the default factory to use if none is passed-to the
	 * {@code parse} method
	 */
	public function CascadingStyleSheetParser(defaultFactory:ConfigurableListableBeanFactory) {
		this.defaultFactory = defaultFactory;
	}

	/**
	 * Parses the given cascading style sheet and formats the bean definitions
	 * registered at the given or the default factory with the parsed styles.
	 *
	 * @param cascadingStyleSheet the cascading style sheet to parse
	 * @param factory the factory containing the bean definitions to format
	 * @throws IllegalArgumentException if neither {@code factory} has been specified
	 * nor the default factory on instantiation
	 */
	public function parse(cascadingStyleSheet:String, factory:ConfigurableListableBeanFactory):Void {
		if (factory == null) {
			if (defaultFactory == null) {
				throw new IllegalArgumentException("Argument 'factory' must not be 'null' nor " +
						"'undefined' if you did not specify a default factory on construction " +
						"of this bean definition parser.", this, arguments);
			}
			this.factory = defaultFactory;
		}
		else {
			this.factory = factory;
		}
		parseStyleSheet(cascadingStyleSheet);
		var beanNames:Array = factory.getBeanDefinitionNames();
		for (var i:Number = beanNames.length - 1; i >= 0; i--) {
			var beanName:String = beanNames[i];
			var beanDefinition:BeanDefinition = factory.getBeanDefinition(beanName);
			applyStyleSheet(beanDefinition, beanName, new Array());
		}
	}

	private function parseStyleSheet(styleSheet:String):Void {
		var sheet:StyleSheet = new StyleSheet();
		var preparedStyleSheet:String = prepareStyleSheet(styleSheet);
		if (!sheet.parseCSS(preparedStyleSheet)) {
			throw new BeanDefinitionStoreException(null, "Cascading style sheet [" + styleSheet +
					"] is syntactically malformed.", this, arguments);
		}
		styles = new Array();
		var styleNames:Array = sheet.getStyleNames();
		for (var i:Number = 0; i < styleNames.length; i++) {
			var styleName:String = styleNames[i];
			if (styleName == NAMESPACE_SELECTOR) {
				namespaces = sheet.getStyle(NAMESPACE_SELECTOR);
			}
			else {
				var selectors:Array = styleName.split("+");
				var specificity:Number = computeSpecificity(selectors);
				var style:Object = {selectors: selectors, style: sheet.getStyle(styleName), specificity: specificity};
				addStyle(String(selectors.pop()), style, specificity);
			}
		}
	}

	private function prepareStyleSheet(styleSheet:String):String {
		var result:String = "";
		var openIndex:Number = styleSheet.indexOf("{");
		var closeIndex:Number = -1;
		while (openIndex != -1) {
			var selectors:Array = styleSheet.substring(closeIndex + 1, openIndex).split(",");
			for (var i:Number = 0; i < selectors.length; i++) {
				if (i != 0) {
					result += ",";
				}
				result += StringUtil.replace(TrimUtil.trim(selectors[i]), " ", "+");
			}
			closeIndex = styleSheet.indexOf("}", openIndex);
			result += styleSheet.substring(openIndex, closeIndex + 1);
			openIndex = styleSheet.indexOf("{", closeIndex);
		}
		return result;
	}

	private function computeSpecificity(selectors:Array):Number {
		var result:Number = 0;
		for (var i:Number = 0; i < selectors.length; i++) {
			var selector:String = selectors[i];
			var firstChar:String = selector.charAt(0);
			if (firstChar == ID_SELECTOR_PREFIX) {
				result += 100;
			}
			else if (firstChar == CLASS_SELECTOR_PREFIX) {
				result += 10;
			}
			else {
				result += 1;
			}
		}
		return result;
	}

	private function addStyle(selector:String, style:Object, specificity:Number):Void {
		if (styles[selector] == null) {
			styles[selector] = new Array();
		}
		var styles:Array = styles[selector];
		var addedStyle:Boolean = false;
		for (var i:Number = 0; i < styles.length; i++) {
			if (styles[i].specificity < specificity) {
				styles.splice(i, 0, style);
				addedStyle = true;
				break;
			}
		}
		if (!addedStyle) {
			styles.push(style);
		}
	}

	private function applyStyleSheet(beanDefinition:BeanDefinition, beanName:String, parentBeanDefinitions:Array):Void {
		if (beanName != null) {
			applyIdStyles(beanDefinition, beanName, parentBeanDefinitions);
		}
		applyClassStyles(beanDefinition, parentBeanDefinitions);
		applyTypeStyles(beanDefinition, parentBeanDefinitions);
		var values:Array = beanDefinition.getPropertyValues().getPropertyValues();
		for (var i:Number = 0; i < values.length; i++) {
			var propertyValue:PropertyValue = values[i];
			var holder:BeanDefinitionHolder = BeanDefinitionHolder(propertyValue.getValue());
			if (holder != null) {
				var pbd:Array = addParentBeanDefinition(parentBeanDefinitions, beanName, beanDefinition);
				applyStyleSheet(holder.getBeanDefinition(), null, pbd);
				continue;
			}
			var reference:RuntimeBeanReference = RuntimeBeanReference(propertyValue.getValue());
			if (reference != null) {
				var pbd:Array = addParentBeanDefinition(parentBeanDefinitions, beanName, beanDefinition);
				var rn:String = reference.getBeanName();
				var rb:BeanDefinition;
				if (reference.isToParent()) {
					var parent:ConfigurableListableBeanFactory =
							ConfigurableListableBeanFactory(factory.getParentBeanFactory());
					if (parent != null) {
						rb = parent.getBeanDefinition(rn, true);
					}
					else {
						continue;
					}
				}
				else {
					// This loop is expensive! Store parent bean definitions also by name to improve performance.
					var backReference:Boolean = false;
					for (var j:Number = 0; j < parentBeanDefinitions.length; j++) {
						if (parentBeanDefinitions[j] == rn) {
							backReference = true;
							break;
						}
					}
					if (!backReference) {
						rb = factory.getBeanDefinition(rn, true);
					}
					else {
						continue;
					}
				}
				applyStyleSheet(rb, rn, pbd);
			}
		}
	}

	private function addParentBeanDefinition(parentBeanDefinitions:Array, beanName:String, beanDefinition:BeanDefinition):Array {
		var result:Array = parentBeanDefinitions.concat();
		if (beanName == null) {
			result.push(beanDefinition);
		}
		else {
			result.push(beanName);
		}
		return result;
	}

	private function applyTypeStyles(beanDefinition:BeanDefinition, parentBeanDefinitions:Array):Void {
		var styleName:String = getTypeStyleName(beanDefinition);
		applyStyles(beanDefinition, resolveStyles(styleName, parentBeanDefinitions));
		/*
		var className:String = beanDefinition.getBeanClassName();
		if (className == null) {
			var cbd:ChildBeanDefinition = ChildBeanDefinition(beanDefinition);
			var pbd:BeanDefinition = beanFactory.getBeanDefinition(cbd.getParentName());
			while (pbd != null) {
				var parentName:String = childBeanDefinition.getParentName();
				var className:String =
			}
		}
		*/
	}

	private function getTypeStyleName(beanDefinition:BeanDefinition):String {
		var source:XMLNode = beanDefinition.getSource();
		if (source != null) {
			var namespace:String = source["namespaceURI"];
			if (namespace == "" || namespace == null) {
				return source.nodeName;
			}
			else {
				return source["localName"];
			}
		}
		return null;
	}

	private function applyClassStyles(beanDefinition:BeanDefinition, parentBeanDefinitions:Array):Void {
		var styleName:String = getClassStyleName(beanDefinition);
		applyStyles(beanDefinition, resolveStyles(styleName, parentBeanDefinitions));
	}

	private function getClassStyleName(beanDefinition:BeanDefinition):String {
		var styleName:String = beanDefinition.getStyleName();
		if (styleName != null) {
			return (CLASS_SELECTOR_PREFIX + styleName);
		}
		return null;
	}

	private function applyIdStyles(beanDefinition:BeanDefinition, beanName:String, parentBeanDefinitions:Array):Void {
		applyStyles(beanDefinition, resolveStyles(ID_SELECTOR_PREFIX + beanName, parentBeanDefinitions));
		var aliases:Array = factory.getAliases(beanName);
		for (var i:Number = 0; i < aliases.length; i++) {
			applyStyles(beanDefinition, resolveStyles(ID_SELECTOR_PREFIX + aliases[i], parentBeanDefinitions));
		}
	}

	private function resolveStyles(styleName:String, parentBeanDefinitions:Array):Array {
		var result:Array = new Array();
		var styles:Array = styles[styleName];
		if (styles != null) {
			for (var i:Number = 0; i < styles.length; i++) {
				if (matchesBeanDefinitions(styles[i].selectors, parentBeanDefinitions)) {
					result.push(styles[i].style);
				}
			}
		}
		return result;
	}

	private function matchesBeanDefinitions(selectors:Array, parentBeanDefinitions:Array):Boolean {
		if (selectors.length == 0) {
			return true;
		}
		if (selectors.length > parentBeanDefinitions.length) {
			return false;
		}
		var i:Number;
		var j:Number;
		for (i = selectors.length - 1, j = parentBeanDefinitions.length - 1;
				i >= 0, j >= 0; i--, j--) {
			var selector:String = selectors[i];
			var foundMatch:Boolean = false;
			do {
				var parent = parentBeanDefinitions[j];
				var parentBeanName:String;
				var parentBeanDefinition:BeanDefinition;
				if (typeof(parent) == "string") {
					parentBeanName = parent;
					parentBeanDefinition = factory.getBeanDefinition(parent, true);
				}
				else {
					parentBeanDefinition = parent;
				}
				if (matchesBeanDefinition(selector, parentBeanDefinition, parentBeanName)) {
					foundMatch = true;
					break;
				}
				j--;
			}
			while (j >= 0);
			if (!foundMatch) {
				return false;
			}
		}
		if (i > 0) {
			return false;
		}
		return true;
	}

	private function matchesBeanDefinition(styleName:String, beanDefinition:BeanDefinition, beanName:String):Boolean {
		var firstChar:String = styleName.charAt(0);
		if (firstChar == ID_SELECTOR_PREFIX) {
			if (beanName == null) {
				return false;
			}
			if (ID_SELECTOR_PREFIX + beanName != styleName) {
				var foundMatch:Boolean = false;
				var aliases:Array = factory.getAliases(beanName);
				if (aliases != null) {
					for (var i:Number = 0; i < aliases.length; i++) {
						if (ID_SELECTOR_PREFIX + aliases[i] == beanName) {
							foundMatch = true;
							break;
						}
					}
				}
				if (!foundMatch) {
					return false;
				}
			}
		}
		else if (firstChar == CLASS_SELECTOR_PREFIX) {
			var classStyleName:String = getClassStyleName(beanDefinition);
			if (classStyleName != styleName) {
				return false;
			}
		}
		else {
			var typeStyleName:String = getTypeStyleName(beanDefinition);
			if (typeStyleName != styleName) {
				return false;
			}
		}
		return true;
	}

	private function applyStyles(beanDefinition, styles:Array):Void {
		for (var i:Number = 0; i < styles.length; i++) {
			applyStyle(beanDefinition, styles[i]);
		}
	}

	private function applyStyle(beanDefinition:BeanDefinition, style:Object):Void {
		if (style != null) {
			var pv:PropertyValues = beanDefinition.getPropertyValues();
			for (var i:String in style) {
				if (!pv.contains(i)) {
					var value:String = parsePropertyValue(style[i]);
					pv.addPropertyValueByIndexAndPropertyValue(0, new PropertyValue(i, value));
				}
			}
		}
	}

	private function parsePropertyValue(value:String) {
		var variablePrefix:Number = value.indexOf(STATIC_VARIABLE_RETRIEVAL_PREFIX);
		if (variablePrefix == 0) {
			var variableSuffix:Number = value.lastIndexOf(STATIC_VARIABLE_RETRIEVAL_SUFFIX);
			if (variableSuffix == value.length - 1) {
				return parseStaticVariableValue(value, variablePrefix, variableSuffix);
			}
		}
		var beanPrefix:Number = value.indexOf("(");
		if (beanPrefix != -1) {
			var beanSuffix:Number = value.lastIndexOf(")");
			if (beanSuffix == value.length - 1) {
				return parseBeanDefinitionValue(value, beanPrefix, beanSuffix);
			}
		}
		return BeanUtil.convertValue(value);
	}

	private function parseStaticVariableValue(value:String, prefixIndex:Number, suffixIndex:Number) {
		var name:String = TrimUtil.trim(value.substring(prefixIndex + 2, suffixIndex));
		var result = eval("_global." + name);
		if (result === undefined) {
			throw new BeanDefinitionStoreException(null, "Static variable [" + name + "] does " +
					"not exist or is not yet initialized.", this, arguments);
		}
		return result;
	}

	private function parseBeanDefinitionValue(value:String, prefixIndex:Number, suffixIndex:Number):BeanDefinitionHolder {
		var className:String = parseClassName(value.substring(0, prefixIndex));
		var clazz:Function = findClass(className);
		var cav:ConstructorArgumentValues = new ConstructorArgumentValues();
		var pv:PropertyValues = new PropertyValues();
		var values:String = value.substring(prefixIndex + 1, suffixIndex);
		var delimiterIndex:Number = -1;
		var separatorIndex:Number = -1;
		var braceCount:Number = 0;
		for (var i:Number = 0; i < values.length; i++) {
			var char:String = values.charAt(i);
			if (char == "(") {
				braceCount++;
			}
			else if (char == ")") {
				braceCount--;
			}
			else if (char == NAME_VALUE_SEPARATOR && braceCount == 0) {
				separatorIndex = i - delimiterIndex - 1;
			}
			else if (char == VALUE_DELIMITER && braceCount == 0) {
				parseUnknownValue(values.substring(delimiterIndex + 1, i), separatorIndex, cav, pv);
				delimiterIndex = i;
				separatorIndex = -1;
			}
		}
		if (braceCount < 0) {
			throw new BeanDefinitionStoreException(null, "There are more left parentheses ')' than " +
					"right parentheses '(' in bean definition value '" + value + "'.", this, arguments);
		}
		else if (braceCount > 0) {
			throw new BeanDefinitionStoreException(null, "There are more right parentheses ')' than " +
					"left parentheses '(' in bean definition value '" + value + "'.", this, arguments);
		}
		parseUnknownValue(values.substring(delimiterIndex + 1), separatorIndex, cav, pv);
		var beanDefinition:RootBeanDefinition = new RootBeanDefinition(cav, pv);
		beanDefinition.setBeanClass(clazz);
		beanDefinition.setBeanClassName(className);
		return new BeanDefinitionHolder(beanDefinition, generateBeanName(beanDefinition));
	}

	private function parseClassName(className:String):String {
		var result:String = TrimUtil.trim(className);
		var separatorIndex:Number = result.indexOf(NAMESPACE_SEPARATOR);
		if (separatorIndex != -1) {
			var ns:String = result.substring(0, separatorIndex);
			var cn:String = result.substring(separatorIndex + 1);
			var namespaceUri:String = namespaces[ns];
			if (namespaceUri == null) {
				throw new BeanDefinitionStoreException(null, "Namespace [" + ns + "] does not " +
						"exist.", this, arguments);
			}
			result = namespaceUri + "." + cn;
		}
		return result;
	}

	private function findClass(className:String):Function {
		try {
			return BeanUtil.findClass(className);
		}
		catch (exception:org.as2lib.env.reflect.ClassNotFoundException) {
			throw (new BeanDefinitionStoreException(null, "Bean class [" + className + "] not " +
					"found.", this, arguments)).initCause(exception);
		}
	}

	private function parseUnknownValue(value:String, separatorIndex:Number,
			argumentValues:ConstructorArgumentValues, propertyValues:PropertyValues):Void {
		if (separatorIndex == -1) {
			parseConstructorArg(value, argumentValues);
		}
		else {
			parseProperty(value, separatorIndex, propertyValues);
		}
	}

	private function parseConstructorArg(value:String, argumentValues:ConstructorArgumentValues):Void {
		var trimmedValue:String = TrimUtil.trim(value);
		var av:ConstructorArgumentValue = new ConstructorArgumentValue(parsePropertyValue(trimmedValue));
		argumentValues.addArgumentValueByValue(av);
	}

	private function parseProperty(property:String, separatorIndex:Number, propertyValues:PropertyValues):Void {
		var name:String = TrimUtil.trim(property.substring(0, separatorIndex));
		var value:String = TrimUtil.trim(property.substring(separatorIndex + 1));
		propertyValues.addPropertyValueByPropertyValue(new PropertyValue(name, parsePropertyValue(value)));
	}

	/**
	 * Generates a bean name for the given bean definition, unique within the bean
	 * factory.
	 *
	 * @param beanDefinition the bean definition to generate a bean name for
	 * @return the bean name to use
	 */
	private function generateBeanName(beanDefinition:BeanDefinition):String {
		var generatedId:String = beanDefinition.getBeanClassName();
		var counter:Number = 0;
		var id:String = generatedId;
		while (factory.containsBeanDefinition(id)) {
			counter++;
			id = generatedId + GENERATED_BEAN_NAME_SEPARATOR + counter;
		}
		return id;
	}

}