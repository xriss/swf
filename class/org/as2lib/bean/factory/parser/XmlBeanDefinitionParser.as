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
import org.as2lib.bean.BeanUtil;
import org.as2lib.bean.factory.BeanDefinitionStoreException;
import org.as2lib.bean.factory.config.BeanDefinition;
import org.as2lib.bean.factory.config.BeanDefinitionHolder;
import org.as2lib.bean.factory.config.ConstructorArgumentValue;
import org.as2lib.bean.factory.config.ConstructorArgumentValues;
import org.as2lib.bean.factory.config.RuntimeBeanReference;
import org.as2lib.bean.factory.parser.BeanDefinitionParser;
import org.as2lib.bean.factory.support.AbstractBeanDefinition;
import org.as2lib.bean.factory.support.BeanDefinitionRegistry;
import org.as2lib.bean.factory.support.ChildBeanDefinition;
import org.as2lib.bean.factory.support.LookupOverride;
import org.as2lib.bean.factory.support.ManagedArray;
import org.as2lib.bean.factory.support.ManagedList;
import org.as2lib.bean.factory.support.ManagedMap;
import org.as2lib.bean.factory.support.ManagedProperties;
import org.as2lib.bean.factory.support.MethodOverrides;
import org.as2lib.bean.factory.support.ReplaceOverride;
import org.as2lib.bean.factory.support.RootBeanDefinition;
import org.as2lib.bean.PropertyValue;
import org.as2lib.bean.PropertyValues;
import org.as2lib.core.BasicClass;
import org.as2lib.env.except.IllegalArgumentException;
import org.as2lib.env.reflect.ClassNotFoundException;
import org.as2lib.util.StringUtil;
import org.as2lib.util.TrimUtil;

/**
 * {@code XmlBeanDefinitionParser} parses bean definitions encoded in XML format.
 *
 * <p>Instantiated per bean definitions to parse: State is held in instance variables
 * during the execution of the {@code parse} method, for example global settings that
 * are defined for all bean definitions in the XML document.
 *
 * @author Simon Wacker
 */
class org.as2lib.bean.factory.parser.XmlBeanDefinitionParser extends BasicClass implements BeanDefinitionParser {

	/** The delimiters to delimit multiple bean names. */
	public static var BEAN_NAME_DELIMITERS:String = ",; ";

	/** The separator to separate multiple constructor arguments. */
	public static var CONSTRUCTOR_ARGS_SEPARATOR:String = ",";

	/**
	 * Value of a boolean attribute that represents {@code true}.
	 * Anything else represents {@code false}. Case sensitive.
	 */
	public static var TRUE_VALUE:String = "true";
	public static var DEFAULT_VALUE:String = "default";
	public static var DESCRIPTION_ELEMENT:String = "description";

	public static var AUTOWIRE_BY_NAME_VALUE:String = "byName";

	public static var DEPENDENCY_CHECK_ALL_VALUE:String = "all";
	public static var DEPENDENCY_CHECK_SIMPLE_VALUE:String = "simple";
	public static var DEPENDENCY_CHECK_OBJECTS_VALUE:String = "objects";

	public static var POPULATE_BEFORE_VALUE:String = "before";
	public static var POPULATE_AFTER_VALUE:String = "after";

	public static var DEFAULT_LAZY_INIT_ATTRIBUTE:String = "default-lazy-init";
	public static var DEFAULT_AUTOWIRE_ATTRIBUTE:String = "default-autowire";
	public static var DEFAULT_DEPENDENCY_CHECK_ATTRIBUTE:String = "default-dependency-check";
	public static var DEFAULT_POPULATE_ATTRIBUTE:String = "default-populate";
	public static var DEFAULT_INIT_METHOD_ATTRIBUTE:String = "default-init-method";
	public static var DEFAULT_DESTROY_METHOD_ATTRIBUTE:String = "default-destroy-method";
	public static var DEFAULT_MERGE_ATTRIBUTE:String = "default-merge";
	public static var DEFAULT_PROPERTY_ATTRIBUTE:String = "default-property";

	public static var ALIAS_ELEMENT:String = "alias";
	public static var NAME_ATTRIBUTE:String = "name";
	public static var ALIAS_ATTRIBUTE:String = "alias";

	public static var BEAN_ELEMENT:String = "bean";
	public static var ID_ATTRIBUTE:String = "id";
	public static var PARENT_ATTRIBUTE:String = "parent";

	public static var CLASS_ATTRIBUTE:String = "class";
	public static var ABSTRACT_ATTRIBUTE:String = "abstract";
	public static var SINGLETON_ATTRIBUTE:String = "singleton";
	public static var LAZY_INIT_ATTRIBUTE:String = "lazy-init";
	public static var AUTOWIRE_ATTRIBUTE:String = "autowire";
	public static var DEPENDENCY_CHECK_ATTRIBUTE:String = "dependency-check";
	public static var DEPENDS_ON_ATTRIBUTE:String = "depends-on";
	public static var POPULATE_ATTRIBUTE:String = "populate";
	public static var INIT_METHOD_ATTRIBUTE:String = "init-method";
	public static var DESTROY_METHOD_ATTRIBUTE:String = "destroy-method";
	public static var FACTORY_METHOD_ATTRIBUTE:String = "factory-method";
	public static var FACTORY_BEAN_ATTRIBUTE:String = "factory-bean";
	public static var INSTANTIATE_WITH_PROPERTY_ATTRIBUTE:String = "instantiate-with-property";
	public static var STATIC_ATTRIBUTE:String = "static";
	public static var STYLE_ATTRIBUTE:String = "style";

	public static var CONSTRUCTOR_ARG_ELEMENT:String = "constructor-arg";
	public static var CONSTRUCTOR_ARGS_ELEMENT:String = "constructor-args";
	public static var INDEX_ATTRIBUTE:String = "index";
	public static var TYPE_ATTRIBUTE:String = "type";
	public static var PROPERTY_ELEMENT:String = "property";
	public static var ENFORCE_ACCESS_ATTRIBUTE:String = "enforce-access";
	public static var REF_ATTRIBUTE:String = "ref";
	public static var VALUE_ATTRIBUTE:String = "value";
	public static var LOOKUP_METHOD_ELEMENT:String = "lookup-method";
	public static var REPLACED_METHOD_ELEMENT:String = "replaced-method";
	public static var REPLACER_ATTRIBUTE:String = "replacer";

	public static var PACKAGE_TYPE_VALUE:String = "Package";
	public static var CLASS_TYPE_VALUE:String = "Class";

	public static var REF_ELEMENT:String = "ref";
	public static var IDREF_ELEMENT:String = "idref";
	public static var BEAN_REF_ATTRIBUTE:String = "bean";
	public static var LOCAL_REF_ATTRIBUTE:String = "local";
	public static var PARENT_REF_ATTRIBUTE:String = "parent";

	public static var VALUE_ELEMENT:String = "value";
	public static var NULL_ELEMENT:String = "null";
	public static var ARRAY_ELEMENT:String = "array";
	public static var LIST_ELEMENT:String = "list";
	public static var MAP_ELEMENT:String = "map";
	public static var ENTRY_ELEMENT:String = "entry";
	public static var KEY_ELEMENT:String = "key";
	public static var KEY_ATTRIBUTE:String = "key";
	public static var KEY_REF_ATTRIBUTE:String = "key-ref";
	public static var VALUE_REF_ATTRIBUTE:String = "value-ref";
	public static var KEY_TYPE_ATTRIBUTE:String = "key-type";
	public static var VALUE_TYPE_ATTRIBUTE:String = "value-type";
	public static var PROPS_ELEMENT:String = "props";
	public static var PROP_ELEMENT:String = "prop";
	public static var MERGE_ATTRIBUTE:String = "merge";

	/**
	 * Separator for generated bean names. If a class name or parent name is not
	 * unique, "#1", "#2" etc will be appended, until the name becomes unique.
	 */
	public static var GENERATED_BEAN_NAME_SEPARATOR:String = "#";

	private var registry:BeanDefinitionRegistry;

	private var defaultRegistry:BeanDefinitionRegistry;

	private var defaultLazyInit:String;

	private var defaultAutowire:String;

	private var defaultDependencyCheck:String;

	private var defaultPopulate:String;

	private var defaultInitMethod:String;

	private var defaultDestroyMethod:String;

	private var defaultMerge:String;

	private var defaultProperty:String;

	/**
	 * Constructs a new {@code XmlBeanDefinitionParser} instance.
	 *
	 * @param defaultRegistry the default registry to use if none is passed-to the
	 * {@code parse} method
	 */
	public function XmlBeanDefinitionParser(defaultRegistry:BeanDefinitionRegistry) {
		this.defaultRegistry = defaultRegistry;
	}

	/**
	 * Sets the default property.
	 */
	private function setDefaultProperty(defaultProperty:String):Void {
		this.defaultProperty = defaultProperty;
	}

	/**
	 * Sets the default populate value. Must be one of the constants:
	 * {@link #POPULATE_BEFORE_VALUE} or {@link #POPULATE_AFTER_VALUE}.
	 */
	private function setDefaultPopulate(defaultPopulate:String):Void {
		this.defaultPopulate = defaultPopulate;
	}

	/**
	 * Parses the given bean definition(s), and adds them to the given registry if not
	 * {@code null}, otherwise the one given on instantiation is used.
	 *
	 * @param beanDefinitions the bean definition(s) to parse
	 * @param registry the registry to add bean definitions to
	 * @throws IllegalArgumentException if both the given registry and the default
	 * registry given on instantiation is {@code null}
	 */
	public function parse(beanDefinitions:String, registry:BeanDefinitionRegistry):Void {
		if (registry == null) {
			if (defaultRegistry == null) {
				throw new IllegalArgumentException("Argument 'registry' must not be 'null' nor " +
						"'undefined' if you did not specify a default registry on construction " +
						"of this bean definition parser.", this, arguments);
			}
			this.registry = defaultRegistry;
		}
		else {
			this.registry = registry;
		}
		var root:XMLNode = parseXml(beanDefinitions);
		initDefaults(root);
		preProcessXml(root);
		parseBeanDefinitions(root);
		postProcessXml(root);
	}

	/**
	 * Parses the given bean definition(s) and returns the root element.
	 *
	 * @param beanDefinitions the bean definition(s) to parse
	 * @param the root element of the given bean definition(s)
	 * @throws BeanDefinitionStoreException if the given bean definition(s) could not
	 * be parsed
	 */
	private function parseXml(beanDefinitions:String):XMLNode {
		var xml:XML = new XML();
		xml.ignoreWhite = true;
		xml.parseXML(beanDefinitions);
		if (xml.status != 0) {
			throw new BeanDefinitionStoreException(null, "Bean definition [" + beanDefinitions +
					"] is syntactically malformed.", this, arguments);
		}
		return xml.lastChild;
	}

	/**
	 * Initializes the default lazy-init, autowire, dependency check and populate,
	 * init-method, destroy-method, property and merge settings.
	 *
	 * @param root the root element
	 */
	private function initDefaults(root:XMLNode):Void {
		defaultLazyInit = root.attributes[DEFAULT_LAZY_INIT_ATTRIBUTE];
		defaultAutowire = root.attributes[DEFAULT_AUTOWIRE_ATTRIBUTE];
		defaultDependencyCheck = root.attributes[DEFAULT_DEPENDENCY_CHECK_ATTRIBUTE];
		defaultMerge = root.attributes[DEFAULT_MERGE_ATTRIBUTE];
		if (root.attributes[DEFAULT_POPULATE_ATTRIBUTE] != null) {
			defaultPopulate = root.attributes[DEFAULT_POPULATE_ATTRIBUTE];
		}
		if (root.attributes[DEFAULT_INIT_METHOD_ATTRIBUTE] != null) {
			defaultInitMethod = root.attributes[DEFAULT_INIT_METHOD_ATTRIBUTE];
		}
		if (root.attributes[DEFAULT_DESTROY_METHOD_ATTRIBUTE] != null) {
			defaultDestroyMethod = root.attributes[DEFAULT_DESTROY_METHOD_ATTRIBUTE];
		}
		if (root.attributes[DEFAULT_PROPERTY_ATTRIBUTE] != null) {
			defaultProperty = root.attributes[DEFAULT_PROPERTY_ATTRIBUTE];
		}
	}

	/**
	 * Allows the XML to be extensible by processing any custom element types first,
	 * before we start to process the bean definitions. This method is a natural
	 * extension point for any other custom pre-processing of the XML.
	 *
	 * <p>This default implementation is empty. Subclasses can override this method
	 * to convert custom elements into standard bean definitions, for example.
	 *
	 * @param root the root element to pre-process
	 */
	private function preProcessXml(root:XMLNode):Void {
	}

	/**
	 * Parses the elements at the root level in the document: "import", "alias", "bean".
	 *
	 * @param root the root node of the xml document
	 */
	private function parseBeanDefinitions(root:XMLNode):Void {
		var nodes:Array = root.childNodes;
		for (var i:Number = 0; i < nodes.length; i++) {
			parseElement(nodes[i]);
		}
	}

	private function parseElement(element:XMLNode):Void {
		if (element.nodeName == ALIAS_ELEMENT) {
			var name:String = element.attributes[NAME_ATTRIBUTE];
			var alias:String = element.attributes[ALIAS_ATTRIBUTE];
			registry.registerAlias(name, alias);
			return;
		}
		if (element.nodeName == BEAN_ELEMENT) {
			var holder:BeanDefinitionHolder = parseBeanDefinitionElement(element);
			registerBeanDefinition(holder);
			return;
		}
		parseUnknownElement(element);
	}

	/**
	 * Throws a {@link BeanDefinitionStoreException}.
	 *
	 * <p>This method may be overridden by subclasses that support other elements than
	 * alias- and bean-elements.
	 *
	 * @param element the element with the unknown node name
	 */
	private function parseUnknownElement(element:XMLNode):Void {
		throw new BeanDefinitionStoreException(null, "Element [" + element + "] has an unknown " +
				"name.", this, arguments);
	}

	/**
	 * Registers the bean definition associated with the given bean definition holder
	 * and its aliases at the bean definition registry.
	 *
	 * @param holder the holder containing the bean definition and its aliases to
	 * register
	 */
	private function registerBeanDefinition(holder:BeanDefinitionHolder):Void {
		var beanName:String = holder.getBeanName();
		registry.registerBeanDefinition(beanName, holder.getBeanDefinition());
		var aliases:Array = holder.getAliases();
		for (var i:Number = 0; i < aliases.length; i++) {
			registry.registerAlias(beanName, aliases[i]);
		}
	}

	/**
	 * Parses a standard bean definition into a bean definition holder, including bean
	 * name and aliases.
	 *
	 * <p>Bean elements specify their canonical name as "id" attribute and their aliases
	 * as a delimited "name" attribute.
	 *
	 * <p>If no "id" is specified, the first name in the "name" attribute is used as
	 * canonical name, registering all others as aliases.
	 *
	 * @param element the bean definition element to parse
	 */
	private function parseBeanDefinitionElement(element:XMLNode):BeanDefinitionHolder {
		var id:String = element.attributes[ID_ATTRIBUTE];
		var name:String = element.attributes[NAME_ATTRIBUTE];
		var aliases:Array;
		if (name != null && name != "") {
			aliases = tokenizeToStringArray(name, BEAN_NAME_DELIMITERS);
		}
		var beanName:String = id;
		if ((beanName == "" || beanName == null) && aliases.length > 0) {
			beanName = aliases.shift().toString();
		}
		var beanDefinition:BeanDefinition = parseBeanDefinitionElementWithoutRegardToNameOrAliases(element, beanName);
		if (beanName == "" || beanName == null) {
			beanName = generateBeanName(beanDefinition);
		}
		return new BeanDefinitionHolder(beanDefinition, beanName, aliases);
	}

	private function parseBeanDefinitionElementWithoutRegardToNameOrAliases(element:XMLNode,
			beanName:String):BeanDefinition {
		var className:String = element.attributes[CLASS_ATTRIBUTE];
		var parent:String = element.attributes[PARENT_ATTRIBUTE];
		try {
			var bd:AbstractBeanDefinition = createBeanDefinition(className, parent);
			parseBeanDefinitionSubElements(element, beanName, bd);
			var dependsOn:String = element.attributes[DEPENDS_ON_ATTRIBUTE];
			if (dependsOn != null) {
				bd.setDependsOn(tokenizeToStringArray(dependsOn, BEAN_NAME_DELIMITERS));
			}
			var factoryMethod:String = element.attributes[FACTORY_METHOD_ATTRIBUTE];
			if (factoryMethod != null) {
				bd.setFactoryMethodName(factoryMethod);
			}
			var factoryBean:String = element.attributes[FACTORY_BEAN_ATTRIBUTE];
			if (factoryBean != null) {
				bd.setFactoryBeanName(factoryBean);
			}
			var instantiateWithProperty:String = element.attributes[INSTANTIATE_WITH_PROPERTY_ATTRIBUTE];
			if (instantiateWithProperty != null) {
				bd.setInstantiateWithProperty(instantiateWithProperty == TRUE_VALUE);
			}
			var statik:String = element.attributes[STATIC_ATTRIBUTE];
			if (statik != null) {
				bd.setStatic(statik == TRUE_VALUE);
			}
			var dependencyCheck:String = element.attributes[DEPENDENCY_CHECK_ATTRIBUTE];
			if (dependencyCheck == DEFAULT_VALUE || dependencyCheck == null) {
				dependencyCheck = defaultDependencyCheck;
			}
			bd.setDependencyCheck(getDependencyCheck(dependencyCheck));
			var autowire:String = element.attributes[AUTOWIRE_ATTRIBUTE];
			if (autowire == DEFAULT_VALUE || autowire == null) {
				autowire = defaultAutowire;
			}
			bd.setAutowireMode(getAutowireMode(autowire));
			var populate:String = element.attributes[POPULATE_ATTRIBUTE];
			if (populate == DEFAULT_VALUE || populate == null) {
				populate = defaultPopulate;
			}
			bd.setPopulateMode(getPopulateMode(populate));
			var initMethodName:String = element.attributes[INIT_METHOD_ATTRIBUTE];
			if (initMethodName != null) {
				if (initMethodName != "") {
					bd.setInitMethodName(initMethodName);
				}
			}
			else {
				if (defaultInitMethod != null) {
					bd.setInitMethodName(defaultInitMethod);
					bd.setEnforceInitMethod(false);
				}
			}
			var destroyMethodName:String = element.attributes[DESTROY_METHOD_ATTRIBUTE];
			if (destroyMethodName != null) {
				if (destroyMethodName != "") {
					bd.setDestroyMethodName(destroyMethodName);
				}
			}
			else {
				if (defaultDestroyMethod != null) {
					bd.setDestroyMethodName(defaultDestroyMethod);
					bd.setEnforceDestroyMethod(false);
				}
			}
			var abstract:String = element.attributes[ABSTRACT_ATTRIBUTE];
			if (abstract != null) {
				bd.setAbstract(abstract == TRUE_VALUE);
			}
			var singleton:String = element.attributes[SINGLETON_ATTRIBUTE];
			if (singleton != null) {
				bd.setSingleton(singleton == TRUE_VALUE);
			}
			var lazyInit:String = element.attributes[LAZY_INIT_ATTRIBUTE];
			if (bd.isSingleton()) {
				// lazy-init has no meaning for prototype beans.
				if (lazyInit == null && beanName != null &&
						bd.getPopulateMode() == AbstractBeanDefinition.POPULATE_AFTER) {
					// Set lazy-init to true if populate mode is 'populate afterwards' and bean name
					// is not null. This prevents that singleton beans which need to be initialized
					// with the correct property are pre-instantiated.
					// Beans without bean name are either inner beans or beans that are not referenced.
					// They thus can be pre-instantiated as normal.
					lazyInit = TRUE_VALUE;
				}
				else if (lazyInit == DEFAULT_VALUE) {
					// Just apply default to singletons, as lazy-init has no meaning for prototypes.
					lazyInit = defaultLazyInit;
				}
			}
			bd.setLazyInit(lazyInit == TRUE_VALUE);
			var defaultProperty:String = element.attributes[DEFAULT_PROPERTY_ATTRIBUTE];
			if (defaultProperty != null) {
				if (defaultProperty != "") {
					bd.setDefaultPropertyName(defaultProperty);
				}
			}
			else {
				if (this.defaultProperty != null) {
					if (parent == null || parent == "") {
						bd.setDefaultPropertyName(this.defaultProperty);
					}
				}
			}
			var style:String = element.attributes[STYLE_ATTRIBUTE];
			if (style != null) {
				bd.setStyleName(style);
			}
			bd.setSource(element);
			return BeanDefinition(bd);
		}
		catch (exception:org.as2lib.bean.factory.BeanDefinitionStoreException) {
			throw exception;
		}
		catch (exception:org.as2lib.env.reflect.ClassNotFoundException) {
			throw (new BeanDefinitionStoreException(beanName, "Bean class [" + className +
					"] not found.", this, arguments)).initCause(exception);
		}
		catch (exception) {
			throw (new BeanDefinitionStoreException(beanName, "Unexpected failure during bean " +
					"definition parsing.", this, arguments)).initCause(exception);
		}
	}

	/**
	 * Parses constructor-arg, property, lookup-override and replaced-method
	 * sub-elements of the given bean element.
	 *
	 * @param beanElement the bean element to parse the sub-elements of
	 * @param beanName the name of the bean
	 * @param beanDefinition the bean definition of the bean
	 */
	private function parseBeanDefinitionSubElements(beanElement:XMLNode, beanName:String,
			beanDefinition:AbstractBeanDefinition):Void {
		var cargs:ConstructorArgumentValues = beanDefinition.getConstructorArgumentValues();
		var pvs:PropertyValues = beanDefinition.getPropertyValues();
		var ors:MethodOverrides = beanDefinition.getMethodOverrides();
		var nodes:Array = beanElement.childNodes;
		for (var i:Number = 0; i < nodes.length; i++) {
			var node:XMLNode = nodes[i];
			if (node.nodeName == PROPERTY_ELEMENT) {
				parsePropertyElement(node, beanName, pvs);
			}
			else if (node.nodeName == CONSTRUCTOR_ARG_ELEMENT) {
				parseConstructorArgElement(node, beanName, cargs);
			}
			else if (node.nodeName == CONSTRUCTOR_ARGS_ELEMENT) {
				parseConstructorArgsElement(node, beanName, cargs);
			}
			else if (node.nodeName == LOOKUP_METHOD_ELEMENT) {
				parseLookupOverrideElement(node, beanName, ors);
			}
			else if (node.nodeName == REPLACED_METHOD_ELEMENT) {
				parseReplacedMethodElement(node, beanName, ors);
			}
			else {
				parseUnknownBeanDefinitionSubElement(node, beanName, beanDefinition);
			}
		}
	}

	/**
	 * May be overridden by sub-classes which support further bean definition
	 * sub-elements.
	 *
	 * @param element the unknown bean definition sub-element
	 * @param beanName the name of the bean declaring the sub-element
	 * @param beanDefinition the bean definition of the bean
	 */
	private function parseUnknownBeanDefinitionSubElement(element:XMLNode, beanName:String,
			beanDefinition:AbstractBeanDefinition):Void {
	}

	/**
	 * Parses a lookup-override element.
	 *
	 * @param element the lookup-override element to parse
	 * @param beanName the name of the bean declaring the lookup-override element
	 * @param overrides the list of overrides to add the parsed lookup-override to
	 */
	private function parseLookupOverrideElement(element:XMLNode, beanName:String, overrides:MethodOverrides):Void {
		var methodName:String = element.attributes[NAME_ATTRIBUTE];
		var beanReference:String = element.attributes[BEAN_ELEMENT];
		var lookupOverride:LookupOverride = new LookupOverride(methodName, beanReference);
		overrides.addOverride(lookupOverride);
	}

	/**
	 * Parses a replaced-method element.
	 *
	 * @param element the replaced-method element to parse
	 * @param beanName the name of the bean declaring the replaced-method element
	 * @param overrides the list of overrides to add the parsed replace-override to
	 */
	private function parseReplacedMethodElement(element:XMLNode, beanName:String, overrides:MethodOverrides):Void {
		var name:String = element.attributes[NAME_ATTRIBUTE];
		var callback:String = element.attributes[REPLACER_ATTRIBUTE];
		var replaceOverride:ReplaceOverride = new ReplaceOverride(name, callback);
		overrides.addOverride(replaceOverride);
	}

	/**
	 * Parses a constructor-arg element.
	 *
	 * @param element the constructor-arg element to parse
	 * @param beanName the name of the bean declaring the constructor-arg element
	 * @param argumentValues the constructor argument values to add the parsed value to
	 */
	private function parseConstructorArgElement(element:XMLNode, beanName:String,
			argumentValues:ConstructorArgumentValues):Void {
		var index:Number = parseIndexAttribute(beanName, element, "constructor-arg");
		var typeName:String = element.attributes[TYPE_ATTRIBUTE];
		var type:Function;
		if (typeName != null && typeName != "") {
			type = resolveType(typeName);
			if (type == null) {
				throw new BeanDefinitionStoreException(beanName, "Type '" + typeName +
						"' for constructor argument '" + index + "' not found.", this, arguments);
			}
		}
		var value = parsePropertyValue(element, beanName, "<constructor-arg> element");
		if (index == null) {
			argumentValues.addArgumentValueByValue(new ConstructorArgumentValue(value, type));
		}
		else {
			argumentValues.addArgumentValueByIndexAndValue(index, new ConstructorArgumentValue(value, type));
		}
	}

	/**
	 * Parses a constructor-args element.
	 *
	 * @param element the constructor-args element to parse
	 * @param beanName the name of the bean declaring the constructor-args element
	 * @param argumentValues the constructor argument values to add the parsed values to
	 */
	private function parseConstructorArgsElement(element:XMLNode, beanName:String,
			argumentValues:ConstructorArgumentValues):Void {
		var value:String = element.firstChild.nodeValue;
		if (value != null && value != "") {
			var typeName:String = element.attributes[TYPE_ATTRIBUTE];
			var type:Function;
			if (typeName != null && typeName != "") {
				type = resolveType(typeName);
				if (type == null) {
					throw new BeanDefinitionStoreException(beanName, "Type '" + typeName +
							"' for constructor arguments not found.", this, arguments);
				}
			}
			var args:Array = value.split(CONSTRUCTOR_ARGS_SEPARATOR);
			BeanUtil.trimAndConvertValues(args);
			for (var i:Number = 0; i < args.length; i++) {
				var arg = args[i];
				if (typeof(arg) == "string") {
					arg = parseLiteralValue(arg, beanName);
				}
				var argument:ConstructorArgumentValue = new ConstructorArgumentValue(arg, type);
				argumentValues.addArgumentValueByValue(argument);
			}
		}
	}

	/**
	 * Parses a property element.
	 *
	 * @param element the property element to parse
	 * @param beanName the name of the bean declaring the property element
	 * @param propertyValues the property values to add parsed values to
	 */
	private function parsePropertyElement(element:XMLNode, beanName:String, propertyValues:PropertyValues):Void {
		var propertyName:String = element.attributes[NAME_ATTRIBUTE];
		// Property names must not be specified because there may be a default a default property name!
		/*if (propertyName == null || propertyName == "") {
			throw new BeanDefinitionStoreException(beanName, "Tag 'property' must have a 'name' attribute.", this, arguments);
		}*/
		// We allow multiple property definitions!
		/*if (propertyValues.contains(propertyName)) {
			throw new BeanDefinitionStoreException(beanName, "Multiple 'property' definitions for property '" + propertyName + "'.", this, arguments);
		}*/
		var index:Number = parseIndexAttribute(beanName, element, "property");
		var typeName:String = element.attributes[TYPE_ATTRIBUTE];
		var type:Function;
		if (typeName != null && typeName != "") {
			type = resolveType(typeName);
			if (type == null) {
				throw new BeanDefinitionStoreException(beanName, "Type for type name '" + typeName +
						"' of property '" + propertyName + "' could not be found.",
						this, arguments);
			}
		}
		var value = parsePropertyValue(element, beanName, "<property> element for property '" + propertyName + "'");
		var enforceAccess:Boolean;
		if (element.attributes[ENFORCE_ACCESS_ATTRIBUTE] != null) {
			enforceAccess = (element.attributes[ENFORCE_ACCESS_ATTRIBUTE] == TRUE_VALUE);
		}
		var property:PropertyValue = new PropertyValue(propertyName, value, type, enforceAccess);
		if (index == null) {
			propertyValues.addPropertyValueByPropertyValue(property);
		}
		else {
			propertyValues.addPropertyValueByIndexAndPropertyValue(index, property);
		}
	}

	/**
	 * Resolves the type for the given {@code typeName}.
	 *
	 * @param typeName the name of the type to resolve
	 */
	private function resolveType(typeName:String):Function {
		if (typeName == CLASS_TYPE_VALUE) {
			return Function;
		}
		if (typeName == PACKAGE_TYPE_VALUE) {
			return AbstractBeanWrapper.PACKAGE_TYPE;
		}
		return eval("_global." + typeName);
	}

	/**
	 * Parses the index-attribute of the given element.
	 *
	 * @param beanName the name of the bean declaring the given element
	 * @param element the element with the index-attribute
	 * @param elementName the name of the element (for example 'property' or
	 * 'constructor-arg')
	 * @return the parsed index or {@code null}
	 * @throws BeanDefinitionStoreException if the index-attribute's value is not a
	 * number
	 * @throws BeanDefinitionStoreException if the index-attribute's value is less
	 * than 0
	 */
	private function parseIndexAttribute(beanName:String, element:XMLNode, elementName:String):Number {
		var result:Number = null;
		var indexAttribute:String = element.attributes[INDEX_ATTRIBUTE];
		if (indexAttribute != null && indexAttribute != "") {
			if (isNaN(indexAttribute)) {
				throw new BeanDefinitionStoreException(beanName, "Attribute 'index' of tag '" +
						elementName + "' must be a number.", this, arguments);
			}
			result = Number(indexAttribute);
			if (result < 0) {
				throw new BeanDefinitionStoreException(beanName, "'index' cannot be less than 0.",
						this, arguments);
			}
		}
		return result;
	}

	/**
	 * Gets the value of a property element. May be a list etc. This method is slso
	 * used for constructor arguments.
	 *
	 * @param element the property element to parse
	 * @param beanName the bean name
	 * @param propertyName the name of the property
	 */
	private function parsePropertyValue(element:XMLNode, beanName:String, propertyName:String) {
		// Should only have one child element: ref, value, list, etc.
		var nodes = element.childNodes;
		var subElement:XMLNode;
		for (var i:Number = 0; i < nodes.length; i++) {
			var candidateElement:XMLNode = nodes[i];
			if (candidateElement.nodeName != DESCRIPTION_ELEMENT) {
				if (subElement != null) {
					throw new BeanDefinitionStoreException(beanName, propertyName + " must not " +
							"contain more than one sub-element.", this, arguments);
				}
				subElement = candidateElement;
			}
		}
		var refAttribute:String = element.attributes[REF_ATTRIBUTE];
		var valueAttribute:String = element.attributes[VALUE_ATTRIBUTE];
		if ((refAttribute != null && valueAttribute != null) ||
				((refAttribute != null || valueAttribute != null)) && subElement != null) {
			throw new BeanDefinitionStoreException(beanName, propertyName + " is only allowed to " +
					"contain either a 'ref' attribute or a 'value' attribute or a sub-element.",
					this, arguments);
		}
		if (refAttribute != null) {
			if (refAttribute == "") {
				throw new BeanDefinitionStoreException(beanName, propertyName + " contains empty " +
						"'ref' attribute.", this, arguments);
			}
			return new RuntimeBeanReference(refAttribute);
		}
		if (valueAttribute != null) {
			return parseLiteralValue(valueAttribute);
		}
		if (subElement == null) {
			// Neither child element nor "ref" or "value" attribute found.
			throw new BeanDefinitionStoreException(beanName, propertyName + " must specify a ref " +
					"or value.", this, arguments);
		}
		return parsePropertySubElement(subElement, beanName);
	}

	/**
	 * Parses a value, ref or collection sub-element of a property or constructor-arg
	 * element.
	 *
	 * @param element the subelement of property element; we don't know which yet
	 * @param beanName the name of the bean
	 * @return the parsed property sub-element
	 */
	private function parsePropertySubElement(element:XMLNode, beanName:String) {
		if (element.nodeName == BEAN_ELEMENT) {
			return parseBeanDefinitionElement(element);
		}
		if (element.nodeName == REF_ELEMENT) {
			return parseBeanReferenceElement(element, beanName);
		}
		if (element.nodeName == IDREF_ELEMENT) {
			return parseIdReferenceElement(element, beanName);
		}
		if (element.nodeName == VALUE_ELEMENT) {
			return parseLiteralValue(element.firstChild.nodeValue, beanName);
		}
		if (element.nodeType == 3) {
			return parseLiteralValue(element.nodeValue, beanName);
		}
		if (element.nodeName == NULL_ELEMENT) {
			// It's a distinguished null value.
			return null;
		}
		if (element.nodeName == ARRAY_ELEMENT) {
			return parseArrayElement(element, beanName);
		}
		if (element.nodeName == LIST_ELEMENT) {
			return parseListElement(element, beanName);
		}
		if (element.nodeName == MAP_ELEMENT) {
			return parseMapElement(element, beanName);
		}
		if (element.nodeName == PROPS_ELEMENT) {
			return parsePropsElement(element, beanName);
		}
		return parseUnknownPropertySubElement(element, beanName);
	}

	/**
	 * Throws a {@link BeanDefinitionStoreException}.
	 *
	 * <p>This method may be overridden by subclasses that support further property
	 * sub-elements.
	 *
	 * @param element the element with the unknown node name
	 * @param beanName the name of the bean with the unknown property sub-element
	 */
	private function parseUnknownPropertySubElement(element:XMLNode, beanName:String) {
		throw new BeanDefinitionStoreException(beanName, "Unknown property sub-element: <" +
				element.nodeName + ">.", this, arguments);
	}

	private function parseLiteralValue(value:String, beanName:String) {
		if (value == null) {
			return "";
		}
		return value;
	}

	private function parseBeanReferenceElement(element:XMLNode, beanName:String):RuntimeBeanReference {
		// A generic reference to any name of any bean.
		var refName:String = element.attributes[BEAN_REF_ATTRIBUTE];
		var toParent:Boolean = false;
		if (refName == null || refName == "") {
			// A reference to the id of another bean in the same XML file.
			refName = element.attributes[LOCAL_REF_ATTRIBUTE];
			if (refName == null || refName == "") {
				// A reference to the id of another bean in a parent context.
				refName = element.attributes[PARENT_REF_ATTRIBUTE];
				toParent = true;
				if (refName == null || refName == "") {
					throw new BeanDefinitionStoreException(beanName, "'bean', 'local' or " +
							"'parent' is required for a reference.", this, arguments);
				}
			}
		}
		if (refName == null || refName == "") {
			throw new BeanDefinitionStoreException(beanName, "<ref> element contains empty " +
					"target attribute", this, arguments);
		}
		return new RuntimeBeanReference(refName, toParent);
	}

	private function parseIdReferenceElement(element:XMLNode, beanName:String):String {
		// A generic reference to any name of any bean.
		var beanRef:String = element.attributes[BEAN_REF_ATTRIBUTE];
		if (beanRef == null || beanRef == "") {
			// A reference to the id of another bean in the same XML file.
			beanRef = element.attributes[LOCAL_REF_ATTRIBUTE];
			if (beanRef == null || beanRef == "") {
				throw new BeanDefinitionStoreException(beanName, "Either 'bean' or 'local' " +
						"is required for <idref> element.", this, arguments);
			}
		}
		return beanRef;
	}

	/**
	 * Parses an array element.
	 *
	 * @param arrayElement the array element to parse
	 * @param beanName the name of the bean
	 * @return the managed array to be converted to a real array
	 */
	private function parseArrayElement(arrayElement:XMLNode, beanName:String):ManagedArray {
		var nodes:Array = arrayElement.childNodes;
		var elementTypeName:String = arrayElement.attributes[TYPE_ATTRIBUTE];
		var elementType:Function;
		if (elementTypeName != null && elementTypeName != "") {
			elementType = resolveType(elementTypeName);
			if (elementType == null) {
				throw new BeanDefinitionStoreException(beanName, "Type for type name '" +
						elementTypeName + "' of <array> element could not be found.",
						this, arguments);
			}
		}
		var array:ManagedArray = new ManagedArray();
		array.setElementType(elementType);
		array.setMergeEnabled(parseMergeAttribute(arrayElement));
		for (var i:Number = 0; i < nodes.length; i++) {
			var value = parsePropertySubElement(nodes[i], beanName);
			array.push(value);
		}
		return array;
	}

	/**
	 * Parses a list element.
	 *
	 * @param listElement the list element to parse
	 * @param beanName the name of the bean
	 * @return the managed list to be converted to a real list
	 */
	private function parseListElement(listElement:XMLNode, beanName:String):ManagedList {
		var nodes:Array = listElement.childNodes;
		var elementTypeName:String = listElement.attributes[TYPE_ATTRIBUTE];
		var elementType:Function;
		if (elementTypeName != null && elementTypeName != "") {
			elementType = resolveType(elementTypeName);
			if (elementType == null) {
				throw new BeanDefinitionStoreException(beanName, "Type for type name '" +
						elementTypeName + "' of <list> element could not be found.",
						this, arguments);
			}
		}
		var list:ManagedList = new ManagedList();
		list.setElementType(elementType);
		list.setMergeEnabled(parseMergeAttribute(listElement));
		for (var i:Number = 0; i < nodes.length; i++) {
			var node:XMLNode = nodes[i];
			list.insertByValue(parsePropertySubElement(node, beanName));
		}
		return list;
	}

	/**
	 * Parses a map element.
	 *
	 * @param mapElement the map element to parse
	 * @param beanName the bean name
	 * @return the managed map to be converted to a real map
	 */
	private function parseMapElement(mapElement:XMLNode, beanName:String):ManagedMap {
		var entryElements:Array = getChildElementsByTagName(mapElement, ENTRY_ELEMENT);
		var keyTypeName:String = mapElement.attributes[KEY_TYPE_ATTRIBUTE];
		var keyType:Function;
		if (keyTypeName != null && keyTypeName != "") {
			keyType = resolveType(keyTypeName);
			if (keyType == null) {
				throw new BeanDefinitionStoreException(beanName, "Key type for type name '" +
						keyTypeName + "' of <map> element could not be found.", this, arguments);
			}
		}
		var valueTypeName:String = mapElement.attributes[VALUE_TYPE_ATTRIBUTE];
		var valueType:Function;
		if (valueTypeName != null && valueTypeName != "") {
			valueType = resolveType(valueTypeName);
			if (valueType == null) {
				throw new BeanDefinitionStoreException(beanName, "Value type for type name '" +
						valueTypeName + "' of <map> element could not be found.", this, arguments);
			}
		}
		var map:ManagedMap = new ManagedMap();
		map.setKeyType(keyType);
		map.setValueType(valueType);
		map.setMergeEnabled(parseMergeAttribute(mapElement));
		for (var i:Number = 0; i < entryElements.length; i++) {
			var entryElement:XMLNode = entryElements[i];
			// Should only have one value child element: ref, value, list, etc.
			// Optionally, there might be a key child element.
			var entrySubNodes:Array = entryElement.childNodes;
			var keyElement:XMLNode;
			var valueElement:XMLNode;
			for (var j:Number = 0; j < entrySubNodes.length; j++) {
				var candidateElement:XMLNode = entrySubNodes[j];
				if (candidateElement.nodeName == KEY_ELEMENT) {
					if (keyElement != null) {
						throw new BeanDefinitionStoreException(beanName, "<entry> is only " +
								"allowed to contain one <key> sub-element.", this, arguments);
					}
					keyElement = candidateElement;
				}
				else {
					// Child element is what we're looking for.
					if (valueElement != null) {
						throw new BeanDefinitionStoreException(beanName, "<entry> must not " +
								"contain more than one value sub-element.", this, arguments);
					}
					valueElement = candidateElement;
				}
			}
			// Extract key from attribute or sub-element.
			var key;
			var keyAttribute:String = entryElement.attributes[KEY_ATTRIBUTE];
			var keyRefAttribute:String = entryElement.attributes[KEY_REF_ATTRIBUTE];
			if ((keyAttribute != null && keyRefAttribute != null) ||
					((keyAttribute != null || keyRefAttribute != null)) && keyElement != null) {
				throw new BeanDefinitionStoreException(beanName, "<entry> is only allowed to " +
						"contain either a 'key' attribute OR a 'key-ref' attribute OR a <key> " +
						"sub-element.", this, arguments);
			}
			if (keyAttribute != null) {
				key = keyAttribute;
			}
			else if (keyRefAttribute != null) {
				if (keyRefAttribute == "") {
					throw new BeanDefinitionStoreException(beanName, "<entry> element contains " +
							"empty 'key-ref' attribute.", this, arguments);
				}
				key = new RuntimeBeanReference(keyRefAttribute);
			}
			else if (keyElement != null) {
				key = parseKeyElement(keyElement, beanName);
			}
			else {
				throw new BeanDefinitionStoreException(beanName, "<entry> must specify a key.",
						this, arguments);
			}
			// Extract value from attribute or sub-element.
			var value = null;
			var valueAttribute:String = entryElement.attributes[VALUE_ATTRIBUTE];
			var valueRefAttribute:String = entryElement.attributes[VALUE_REF_ATTRIBUTE];
			if ((valueAttribute != null && valueRefAttribute != null) ||
					(valueAttribute != null || valueRefAttribute != null) && valueElement != null) {
				throw new BeanDefinitionStoreException(beanName, "<entry> is only allowed to " +
						"contain either 'value' attribute OR 'value-ref' attribute OR <value> " +
						"sub-element.", this, arguments);
			}
			if (valueAttribute != null) {
				value = valueAttribute;
			}
			else if (valueRefAttribute != null) {
				if (valueRefAttribute == "") {
					throw new BeanDefinitionStoreException(beanName, "<entry> element contains " +
							"empty 'value-ref' attribute.", this, arguments);
				}
				value = new RuntimeBeanReference(valueRefAttribute);
			}
			else if (valueElement != null) {
				value = parsePropertySubElement(valueElement, beanName);
			}
			else {
				throw new BeanDefinitionStoreException(beanName, "<entry> must specify a value.",
						this, arguments);
			}
			// Add final key and value to the Map.
			map.put(key, value);
		}
		return map;
	}

	/**
	 * Parses a key sub-element of a map element.
	 *
	 * @param keyElement the key sub-element of a map
	 * @param beanName the name of the bean
	 * @return the parsed key-element
	 */
	private function parseKeyElement(keyElement:XMLNode, beanName:String) {
		var nodes:Array = keyElement.childNodes;
		var subElement:XMLNode;
		for (var i:Number = 0; i < nodes.length; i++) {
			var candidateElement:XMLNode = nodes[i];
			// Child element is what we're looking for.
			if (subElement != null) {
				throw new BeanDefinitionStoreException(beanName, "<key> must not contain more " +
						"than one value sub-element.", this, arguments);
			}
			subElement = candidateElement;
		}
		return parsePropertySubElement(subElement, beanName);
	}

	/**
	 * Parses a props element.
	 *
	 * @param propsElement the properties element to parse
	 * @param beanName the name of the bean
	 * @return the managed properties to be converted to a real properties
	 */
	private function parsePropsElement(propsElement:XMLNode, beanName:String):ManagedProperties {
		var properties:ManagedProperties = new ManagedProperties();
		properties.setMergeEnabled(parseMergeAttribute(propsElement));
		var propElements:Array = getChildElementsByTagName(propsElement, PROP_ELEMENT);
		for (var i:Number = 0; i < propElements.length; i++) {
			var propElement:XMLNode = propElements[i];
			var key:String = propElement.attributes[KEY_ATTRIBUTE];
			// Trim the text value to avoid unwanted whitespace
			// caused by typical XML formatting.
			var value:String = TrimUtil.trim(propElement.firstChild.nodeValue);
			properties.setProp(key, value);
		}
		return properties;
	}

	/**
	 * Parses the merge attribute of a collection element, if any.
	 *
	 * @param collectionElement the collection element to parse
	 * @return {@code true} if the collection shall be merged if necessary else
	 * {@code false}
	 */
	private function parseMergeAttribute(collectionElement:XMLNode):Boolean {
		var value:String = collectionElement.attributes[MERGE_ATTRIBUTE];
		if (DEFAULT_VALUE == value) {
			value = defaultMerge;
		}
		return TRUE_VALUE == value;
	}

	/**
	 * Returns all child elements with the given node name of the given element.
	 *
	 * @param element the element to return child elements of
	 * @param nodeName the node name of the child elements to return
	 * @return all child elements with the given node name
	 */
	private function getChildElementsByTagName(element:XMLNode, nodeName:String):Array {
		var result:Array = new Array();
		var nodes:Array = element.childNodes;
		for (var i:Number = 0; i < nodes.length; i++) {
			var node:XMLNode = nodes[i];
			if (node.nodeName == nodeName) {
				result.push(node);
			}
		}
		return result;
	}

	/**
	 * Returns the dependency check constant indicated by the given attribute.
	 *
	 * @param attribute the attribute to convert to a dependency check constant
	 * @return the dependency check constant of the given attribute
	 */
	private function getDependencyCheck(attribute:String):Number {
		if (attribute == DEPENDENCY_CHECK_ALL_VALUE) {
			return AbstractBeanDefinition.DEPENDENCY_CHECK_ALL;
		}
		if (attribute == DEPENDENCY_CHECK_SIMPLE_VALUE) {
			return AbstractBeanDefinition.DEPENDENCY_CHECK_SIMPLE;
		}
		if (attribute == DEPENDENCY_CHECK_OBJECTS_VALUE) {
			return AbstractBeanDefinition.DEPENDENCY_CHECK_OBJECTS;
		}
		return AbstractBeanDefinition.DEPENDENCY_CHECK_NONE;
	}

	/**
	 * Returns the autowire mode indicated by the given attribute.
	 *
	 * @param attribute the attribute to convert to an autowire mode
	 * @return the autowire mode corresponding to the given attribute
	 */
	private function getAutowireMode(attribute:String):Number {
		if (attribute == AUTOWIRE_BY_NAME_VALUE) {
			return AbstractBeanDefinition.AUTOWIRE_BY_NAME;
		}
		return AbstractBeanDefinition.AUTOWIRE_NO;
	}

	/**
	 * Returns the populate mode indicated by the given attribute.
	 *
	 * @param attribute the attribute to convert to a populate mode
	 * @return the populate mode corresponding to the given attribute
	 */
	private function getPopulateMode(attribute:String):Number {
		if (attribute == POPULATE_AFTER_VALUE) {
			return AbstractBeanDefinition.POPULATE_AFTER;
		}
		return AbstractBeanDefinition.POPULATE_BEFORE;
	}

	/**
	 * Creates a new {@link RootBeanDefinition} or {@link ChildBeanDefinition} for the
	 * given class name, parent, constructor arguments, and property values.
	 *
	 * @param className the name of the bean class, if any
	 * @param parent the name of the parent bean, if any
	 * @return the bean definition
	 * @throws ClassNotFoundException if the bean class could not be resolved
	 */
	public function createBeanDefinition(className:String, parent:String):AbstractBeanDefinition {
		var beanClass:Function;
		if (className != null) {
			beanClass = eval("_global." + className);
			if (beanClass == null) {
				throw new ClassNotFoundException("Class with name '" + className + "' could not " +
						"be found.", this, arguments);
			}
		}
		var result:AbstractBeanDefinition;
		if (parent == null) {
			result = new RootBeanDefinition();
		}
		else {
			result = new ChildBeanDefinition(parent);
		}
		result.setBeanClass(beanClass);
		result.setBeanClassName(className);
		return result;
	}

	/**
	 * Generates a bean name for the given bean definition, unique within the bean
	 * definition registry.
	 *
	 * @param beanDefinition the bean definition to generate a bean name for
	 * @return the bean name to use
	 * @throws BeanDefinitionStoreException if no unique name can be generated
	 * for the given bean definition
	 */
	private function generateBeanName(beanDefinition:BeanDefinition):String {
		var generatedId:String = beanDefinition.getBeanClassName();
		if (generatedId == null) {
			var childBeanDefinition:ChildBeanDefinition = ChildBeanDefinition(beanDefinition);
			if (childBeanDefinition != null) {
				generatedId = childBeanDefinition.getParentName() + "$child";
			}
			else if (beanDefinition.getFactoryBeanName() != null) {
				generatedId = beanDefinition.getFactoryBeanName() + "$created";
			}
		}
		if (generatedId == null || generatedId == "") {
			throw new BeanDefinitionStoreException(null, "Unnamed bean definition specifies " +
					"neither 'class' nor 'parent' nor 'factory-bean' - can't generate bean name.",
					this, arguments);
		}
		// Top-level bean: use plain class name. If not already unique,
		// add counter - increasing the counter until the name is unique.
		var counter:Number = 0;
		var id:String = generatedId;
		while (registry.containsBeanDefinition(id)) {
			counter++;
			id = generatedId + GENERATED_BEAN_NAME_SEPARATOR + counter;
		}
		return id;
	}

	/**
	 * Converts the given string to a string array, by splitting it at the given
	 * delimiters.
	 *
	 * @param string the string to tokenize
	 * @param delimiters the delimiters to split the string at
	 * @return the converted string
	 */
	private function tokenizeToStringArray(string:String, delimiters:String):Array {
		var length:Number = BEAN_NAME_DELIMITERS.length - 1;
		var character:String = BEAN_NAME_DELIMITERS.charAt(length);
		for (var i:Number = 0; i < length; i++) {
			string = StringUtil.replace(string, BEAN_NAME_DELIMITERS.charAt(i), character);
		}
		return string.split(character);
	}

	/**
	 * Allows the XML to be extensible by processing any custom element types last,
	 * after we finished processing the bean definitions. This method is a natural
	 * extension point for any other custom post-processing of the XML.
	 *
	 * <p>This default implementation is empty. Subclasses can override this method
	 * to convert custom elements into standard bean definitions, for example.
	 *
	 * @param root the root element to post-process
	 */
	private function postProcessXml(root:XMLNode):Void {
	}

}