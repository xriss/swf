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
import org.as2lib.bean.BeanWrapper;
import org.as2lib.bean.converter.BooleanConverter;
import org.as2lib.bean.converter.ClassConverter;
import org.as2lib.bean.converter.InstanceConverter;
import org.as2lib.bean.converter.NumberConverter;
import org.as2lib.bean.converter.PackageConverter;
import org.as2lib.bean.converter.StringArrayConverter;
import org.as2lib.bean.factory.support.ManagedArray;
import org.as2lib.bean.factory.support.ManagedList;
import org.as2lib.bean.factory.support.ManagedMap;
import org.as2lib.bean.factory.support.ManagedProperties;
import org.as2lib.bean.InvalidPropertyException;
import org.as2lib.bean.Mergeable;
import org.as2lib.bean.MethodInvocationException;
import org.as2lib.bean.NotReadablePropertyException;
import org.as2lib.bean.NotWritablePropertyException;
import org.as2lib.bean.NullValueInNestedPathException;
import org.as2lib.bean.PropertyAccessException;
import org.as2lib.bean.PropertyAccessExceptionsException;
import org.as2lib.bean.PropertyValue;
import org.as2lib.bean.PropertyValueConverter;
import org.as2lib.bean.PropertyValueConverterHolder;
import org.as2lib.bean.PropertyValues;
import org.as2lib.bean.TypeMismatchException;
import org.as2lib.data.holder.List;
import org.as2lib.data.holder.Map;
import org.as2lib.data.holder.map.HashMap;
import org.as2lib.data.holder.map.PrimitiveTypeMap;
import org.as2lib.data.holder.Properties;
import org.as2lib.env.except.IllegalArgumentException;
import org.as2lib.env.overload.Overload;
import org.as2lib.env.reflect.ReflectUtil;
import org.as2lib.util.ClassUtil;
import org.as2lib.util.StringUtil;
import org.as2lib.util.TextUtil;

/**
 * {@code SimpleBeanWrapper} is the default implementation of the {@code BeanWrapper}
 * interface that should be sufficient for all typical use cases. It caches
 * introspection results for efficiency.
 *
 * <p>Note: Auto-registers default property value converters from the {@code org.as2lib.bean.converter}
 * Applications can invoke the {@link #registerPropertyValueConverter} method to
 * register a converter for a particular instance.
 *
 * @author Simon Wacker
 */
class org.as2lib.bean.SimpleBeanWrapper extends AbstractBeanWrapper implements BeanWrapper {

	/** The default {@link PropertyValueConverter} instances supported by this bean wrapper. */
	private static var defaultPropertyValueConverters:Map;

	/**
	 * Creates the default {@link PropertyValueConverter} instances and stores them in
	 * a map with the type they convert-to as keys.
	 */
	public static function getDefaultPropertyValueConverters(Void):Map {
		if (defaultPropertyValueConverters == null) {
			defaultPropertyValueConverters = new HashMap();
			defaultPropertyValueConverters.put(Number, new NumberConverter());
			defaultPropertyValueConverters.put(Boolean, new BooleanConverter());
			defaultPropertyValueConverters.put(Function, new ClassConverter());
			defaultPropertyValueConverters.put(PACKAGE_TYPE, new PackageConverter());
			defaultPropertyValueConverters.put(Array, new StringArrayConverter());
			defaultPropertyValueConverters.put(Object, new InstanceConverter());
		}
		return defaultPropertyValueConverters;
	}

	/** The wrapped bean. */
	private var wrappedBean;

	/** The nested property path. */
	private var nestedPath:String;

	/** The root bean. */
	private var rootBean;

	/** The default property value converters. */
	private var defaultConverters:Map;

	/** The custom property value converters. */
	private var customConverters:Map;

	/** The cached nested bean wrappers. */
	private var nestedBeanWrappers:Map;

	/**
	 * Constructs a new {@code SimpleBeanWrapper} instance.
	 *
	 * @param wrappedBean the bean to wrap
	 * @param nestedPath the nested path of the bean if it is itself the value of
	 * another bean
	 * @param rootBean the root bean from which the path started
	 */
	public function SimpleBeanWrapper(wrappedBean, nestedPath:String, rootBean) {
		this.wrappedBean = wrappedBean;
		this.nestedPath = (nestedPath != null ? nestedPath : "");
		this.rootBean = (nestedPath != null ? rootBean : wrappedBean);
		defaultConverters = getDefaultPropertyValueConverters();
	}

	public function isWritableProperty(propertyName:String):Boolean {
		if (propertyName == null) {
			throw new IllegalArgumentException("Cannot find writability status for 'null' " +
					"property.", this, arguments);
		}
		if (getNestedPropertySeparatorIndex(propertyName) > -1) {
			var nestedBeanWrapper:BeanWrapper;
			try {
				nestedBeanWrapper = getBeanWrapperForPropertyPath(propertyName);
			}
			catch (exception:org.as2lib.bean.InvalidPropertyException) {
				// cannot be evaluated, so can't be writable
				return false;
			}
			return nestedBeanWrapper.isWritableProperty(getFinalPath(propertyName));
		}
		if (mayBeAssociativeArray()) {
			return true;
		}
		var tokens:Array = getPropertyNameTokens(propertyName);
		return isAccessibleProperty(SET_PROPERTY_PREFIXES, tokens.actualName);
	}

	public function isReadableProperty(propertyName:String):Boolean {
		if (propertyName == null) {
			throw new IllegalArgumentException("Cannot find readability status for 'null' " +
					"property.", this, arguments);
		}
		if (getNestedPropertySeparatorIndex(propertyName) > -1) {
			var nestedBeanWrapper:BeanWrapper;
			try {
				nestedBeanWrapper = getBeanWrapperForPropertyPath(propertyName);
			}
			catch (exception:org.as2lib.bean.InvalidPropertyException) {
				// cannot be evaluated, so can't be readable
				return false;
			}
			return nestedBeanWrapper.isReadableProperty(getFinalPath(propertyName));
		}
		if (mayBeAssociativeArray()) {
			return true;
		}
		var tokens:Array = getPropertyNameTokens(propertyName);
		return isAccessibleProperty(GET_PROPERTY_PREFIXES, tokens.actualName);
	}

	/**
	 * Returns whether the wrapped bean may be an associative array.
	 *
	 * @return {@code true} if the wrapped bean may be an associative array else
	 * {@code false}
	 */
	private function mayBeAssociativeArray(Void):Boolean {
		return (wrappedBean.__proto__ == Object.prototype || wrappedBean instanceof Array);
	}

	/**
	 * Returns whether the property with the given name and prefixes is accessible on
	 * the wrapped bean.
	 */
	private function isAccessibleProperty(prefixes:Array, propertyName:String):Boolean {
		var methodName:String = findMethodName(prefixes, propertyName);
		if (methodName != null) {
			return true;
		}
		try {
			if (wrappedBean[propertyName] !== undefined) {
				return true;
			}
		}
		catch (exception) {
			// ignore exception that may be thrown by __resolve or a Flash property
		}
		return false;
	}

	/**
	 * Finds a method name that exists on the wrapped bean.
	 *
	 * @param prefixes the method name prefixes to combine with the property name to
	 * get a possible method name
	 * @param actualPropertyName the property name to combine with the prefixes
	 * @return the first prefix-property-name combination that exists on the wrapped
	 * bean or {@code null} if none
	 */
	private function findMethodName(prefixes:Array, actualPropertyName:String):String {
		var pn:String = TextUtil.ucFirst(actualPropertyName);
		for (var i:Number = 0; i < prefixes.length; i++) {
			var methodName:String = prefixes[i] + pn;
			if (existsMethod(methodName)) {
				return methodName;
			}
		}
		// The last prefix is supposed to be '__get__' or '__set__' (Flash property) which must be combined with the actual property name
		var methodName:String = prefixes[prefixes.length - 1] + actualPropertyName;
		if (existsMethod(methodName)) {
			return methodName;
		}
		try {
			if (typeof(wrappedBean[actualPropertyName]) == "function") {
				return actualPropertyName;
			}
		}
		catch (exception) {
			// ignore exception that may be thrown by __resolve or a Flash property
		}
		return null;
	}

	private function existsMethod(methodName:String):Boolean {
		try {
			if (wrappedBean[methodName] != null) {
				return true;
			}
		}
		catch (exception) {
			// ignore exception that may be thrown by __resolve or a Flash property
		}
		return false;
	}

	/**
	 * Gets the last component of the path.
	 *
	 * @param nestedPath the property path we know is nested
	 * @return the last component of the path (the property on the target bean)
	 */
	private function getFinalPath(nestedPath:String):String {
		return nestedPath.substring(getNestedPropertySeparatorIndex(nestedPath, true) + 1);
	}

	/**
	 * Gets the bean wrapper for the given property path. This bean wrapper is returned
	 * if the given property path is not a nested path.
	 *
	 * @param propertyPath the property path to get a bean wrapper for
	 * @return the bean wrapper for the property path
	 */
	private function getBeanWrapperForPropertyPath(propertyPath:String):BeanWrapper {
		var position:Number = getNestedPropertySeparatorIndex(propertyPath);
		// handle nested properties recursively
		if (position > -1) {
			var nestedProperty:String = propertyPath.substring(0, position);
			var nestedPath:String = propertyPath.substring(position + 1);
			var nestedBeanWrapper:SimpleBeanWrapper = getNestedBeanWrapper(nestedProperty);
			return nestedBeanWrapper.getBeanWrapperForPropertyPath(nestedPath);
		}
		return this;
	}

	/**
	 * Retrieves a bean wrapper for the given nested property. Creates a new one
	 * if not found in the cache.
	 *
	 * <p>Note: Caching nested bean wrappers is necessary now, to keep registered
	 * property value converters for nested properties.
	 *
	 * @param nestedProperty the property to create the bewn wrapper for
	 * @return the bean wrapper, either cached or newly created
	 */
	private function getNestedBeanWrapper(nestedProperty:String):SimpleBeanWrapper {
		if (nestedBeanWrappers == null) {
			nestedBeanWrappers = new PrimitiveTypeMap();
		}
		var tokens:Array = getPropertyNameTokens(nestedProperty);
		var canonicalName:String = tokens.canonicalName;
		var propertyValue = getPropertyValue(nestedProperty);
		if (propertyValue == null) {
			throw new NullValueInNestedPathException(wrappedBean, nestedPath + canonicalName);
		}
		// Lookup cached sub-BeanWrapper, create new one if not found.
		var nestedBeanWrapper:SimpleBeanWrapper = nestedBeanWrappers.get(canonicalName);
		if (nestedBeanWrapper == null || nestedBeanWrapper.getWrappedBean() != propertyValue) {
			nestedBeanWrapper = new SimpleBeanWrapper(propertyValue,
					nestedPath + canonicalName + NESTED_PROPERTY_SEPARATOR, this);
			// Inherit all type-specific PropertyEditors.
			//copyDefaultPropertyValueConverters(nestedBeanWrapper);
			copyCustomPropertyValueConverters(nestedBeanWrapper, canonicalName);
			nestedBeanWrappers.put(canonicalName, nestedBeanWrapper);
		}
		return nestedBeanWrapper;
	}

	/**
	 * Copies the property value converters registered in this instance to the given
	 * target registry.
	 *
	 * @param target the target registry to copy to
	 * @param nestedProperty the nested property path of the target registry, if any.
	 * If this is non-{@code null}, only converters registered for a path below this
	 * nested property will be copied
	 */
	private function copyCustomPropertyValueConverters(target:BeanWrapper, nestedProperty:String):Void {
		var actualPropertyName:String = (nestedProperty != null ? getPropertyName(nestedProperty) : null);
		if (customConverters != null) {
			var values:Array = customConverters.getValues();
			var keys:Array = customConverters.getKeys();
			for (var i:Number = 0; i < keys.length; i++) {
				if (keys[i] instanceof Function) {
					var requiredType:Function = keys[i];
					var converter:PropertyValueConverter = values[i];
					target.registerPropertyValueConverterForType(requiredType, converter);
					return;
				}
				if (nestedProperty != null) {
					if (keys[i] instanceof String || typeof(keys[i]) == "string") {
						var converterPath:String = keys[i];
						var position:Number = getNestedPropertySeparatorIndex(converterPath);
						if (position != -1) {
							var converterNestedProperty = converterPath.substring(0, position);
							var converterNestedPath:String = converterPath.substring(position + 1);
							if (converterNestedProperty == nestedProperty ||
									converterNestedProperty == actualPropertyName) {
								var converterHolder:PropertyValueConverterHolder = values[i];
								target.registerPropertyValueConverterForProperty(converterHolder.getRegisteredType(),
										converterNestedPath, converterHolder.getPropertyValueConverter());
							}
						}
					}
				}
			}
		}
	}

	/**
	 * Returns the actual property name for the given property path.
	 *
	 * @param propertyPath the property path to determine the property name
	 * for (can include property keys, for example for specifying a map entry)
	 * @return the actual property name, without any key elements
	 */
	private function getPropertyName(propertyPath:String):String {
		var separatorIndex:Number = propertyPath.indexOf(PROPERTY_KEY_PREFIX);
		return (separatorIndex != -1 ? propertyPath.substring(0, separatorIndex) : propertyPath);
	}

	/**
	 * Parses the given property name into the corresponding property name tokens. The
	 * returned array is an associative array with the variables {@code actualName},
	 * {@code canonicalName} and {@code keys}.
	 *
	 * @param propertyName the property name to parse
	 * @return representation of the parsed property tokens
	 */
	private function getPropertyNameTokens(propertyName:String):Array {
		var tokens:Array = new Array();
		var actualName:String;
		var keys:Array = new Array();
		var searchIndex:Number = 0;
		while (searchIndex != -1) {
			var keyStart:Number = propertyName.indexOf(PROPERTY_KEY_PREFIX, searchIndex);
			searchIndex = -1;
			if (keyStart != -1) {
				var keyEnd:Number = propertyName.indexOf(PROPERTY_KEY_SUFFIX, keyStart + PROPERTY_KEY_PREFIX.length);
				if (keyEnd != -1) {
					if (actualName == null) {
						actualName = propertyName.substring(0, keyStart);
					}
					var key:String = propertyName.substring(keyStart + PROPERTY_KEY_PREFIX.length, keyEnd);
					if ((StringUtil.startsWith(key, "'") && StringUtil.endsWith(key, "'"))
							|| (StringUtil.startsWith(key, "\"") && StringUtil.endsWith(key, "\""))) {
						key = key.substring(1, key.length - 1);
					}
					keys.push(key);
					searchIndex = keyEnd + PROPERTY_KEY_SUFFIX.length;
				}
			}
		}
		tokens.actualName = (actualName != null ? actualName : propertyName);
		tokens.canonicalName = tokens.actualName;
		if (keys.length > 0) {
			tokens.canonicalName +=
					PROPERTY_KEY_PREFIX +
					arrayToDelimitedString(keys, PROPERTY_KEY_SUFFIX + PROPERTY_KEY_PREFIX) +
					PROPERTY_KEY_SUFFIX;
			tokens.keys = keys;
		}
		return tokens;
	}

	/**
	 * Returns a string array as a delimited string.
	 *
	 * @param array array to display. Elements may be of any type (toString will
	 * be called on each element).
	 * @param delimiter the delimiter to use (probably a ",")
	 */
	public function arrayToDelimitedString(array:Array, delimiter:String):String {
		if (array == null) {
			return "";
		}
		var result:String;
		for (var i:Number = 0; i < array.length; i++) {
			if (i > 0) {
				result += delimiter;
			}
			result += array[i];
		}
		return result;
	}

	/**
	 * Determines the first (or last) nested property separator in the given property
	 * path, ignoring dots in keys (like "map[my.key]").
	 *
	 * @param propertyPath the property path to check
	 * @param last whether to return the last separator rather than the first
	 * @return the index of the nested property separator, or {@code -1} if none
	 */
	private function getNestedPropertySeparatorIndex(propertyPath:String, last:Boolean):Number {
		if (propertyPath.indexOf(".") != -1) {
			if (last == null) last = false;
			var inKey:Boolean = false;
			var length:Number = propertyPath.length;
			var i:Number = (last ? length - 1 : 0);
			while (last ? i >= 0 : i < length) {
				switch (propertyPath.charAt(i)) {
					case PROPERTY_KEY_PREFIX:
					case PROPERTY_KEY_SUFFIX:
						inKey = !inKey;
						break;
					case NESTED_PROPERTY_SEPARATOR:
						if (!inKey) {
							return i;
						}
				}
				if (last) {
					i--;
				}
				else {
					i++;
				}
			}
		}
		return -1;
	}

	public function getPropertyValue(propertyName:String) {
		if (getNestedPropertySeparatorIndex(propertyName) > -1) {
			var nestedBeanWrapper:BeanWrapper = getBeanWrapperForPropertyPath(propertyName);
			return nestedBeanWrapper.getPropertyValue(getFinalPath(propertyName));
		}
		var tokens:Array = getPropertyNameTokens(propertyName);
		var methodName:String = findMethodName(GET_PROPERTY_PREFIXES, tokens.actualName);
		var value;
		var keys:Array = tokens.keys;
		if (methodName != null) {
			try {
				if (keys.length == 1) {
					var key:String = keys[0];
					if (isNaN(key)) {
						value = wrappedBean[methodName](key);
					}
					else {
						value = wrappedBean[methodName](Number(key));
					}
				}
				else {
					value = wrappedBean[methodName]();
				}
			}
			catch (exception) {
				throw (new MethodInvocationException(wrappedBean, propertyName, "Method " +
						"invocation of method '" + methodName + "' failed.",
						this, arguments)).initCause(exception);
			}
		}
		else {
			try {
				if (wrappedBean[tokens.actualName] !== undefined) {
					value = wrappedBean[tokens.actualName];
				}
				else if (mayBeAssociativeArray()) {
					value = wrappedBean[tokens.actualName];
				}
				else {
					throw new NotReadablePropertyException(rootBean, nestedPath + propertyName,
							this, arguments);
				}
			}
			catch (exception) {
				throw (new PropertyAccessException(wrappedBean, propertyName, "Variable access " +
						"to variable '" + tokens.actualName + "' failed.",
						this, arguments)).initCause(exception);
			}
		}
		if (keys != null) {
			for (var i:Number = 0; i < keys.length; i++) {
				var key:String = keys[i];
				if (value == null) {
					if (keys.length == 1) {
						break;
					}
					throw new NullValueInNestedPathException(rootBean, nestedPath + propertyName,
							"Cannot access indexed value of property referenced in indexed " +
							"property path '" + propertyName + "': returned 'null'.",
							this, arguments);
				}
				// Array or Object may be associative arrays
				if (value instanceof Array || value.__proto__ == Object.prototype) {
					if (isNaN(key)) {
						value = value[key];
					} else {
						value = value[Number(key)];
					}
				}
				else if (value instanceof List) {
					var list:List = value;
					if (isNaN(key)) {
						throw new InvalidPropertyException(rootBean, nestedPath + propertyName,
								"Invalid index in property path '" + propertyName + "'",
								this, arguments);
					}
					value = list.get(Number(key));
				}
				else if (value instanceof Map) {
					var map:Map = value;
					if (isNaN(key)) {
						value = map.get(key);
					} else {
						value = map.get(Number(key));
					}
				}
				else {
					if (keys.length == 1) {
						break;
					}
					throw new InvalidPropertyException(rootBean, nestedPath + propertyName,
							"Property referenced in indexed property path '" + propertyName +
							"' is neither an Array nor a List nor a Map; returned value was [" +
									value + "].", this, arguments);
				}
			}
		}
		return value;
	}

	public function setPropertyValue(propertyValue:PropertyValue):Void {
		var propertyName:String = propertyValue.getName();
		var value = convertPropertyValue(propertyValue.getName(), propertyValue.getValue(),
				propertyValue.getType());
		if (getNestedPropertySeparatorIndex(propertyName) > -1) {
			var nestedBeanWrapper:BeanWrapper;
			try {
				nestedBeanWrapper = getBeanWrapperForPropertyPath(propertyName);
			}
			catch (exception:org.as2lib.bean.NotReadablePropertyException) {
				throw (new NotWritablePropertyException(rootBean, nestedPath + propertyName,
						"Nested property in path '" + propertyName + "' does not exist.",
						this, arguments)).initCause(exception);
			}
			nestedBeanWrapper.setPropertyValue(new PropertyValue(getFinalPath(propertyName),
					value, propertyValue.getType(), propertyValue.isEnforceAccess()));
			return;
		}
		var tokens:Array = getPropertyNameTokens(propertyName);
		var methodName:String = findMethodName(SET_PROPERTY_PREFIXES, tokens.actualName);
		if (methodName != null) {
			var keys:Array = tokens.keys;
			try {
				if (keys != null) {
					if (keys.length == 1) {
						var key:String = keys[0];
						if (isNaN(key)) {
							wrappedBean[methodName](key, value);
						} else {
							wrappedBean[methodName](Number(key), value);
						}
					} else {
						// get property for all keys except last one and set property of returned property to value
					}
				} else {
					wrappedBean[methodName](value);
				}
			}
			catch (exception) {
				throw (new MethodInvocationException(wrappedBean, propertyName, "Method " +
						"invocation of method '" + methodName + "' failed.",
						this, arguments)).initCause(exception);
			}
		}
		else {
			try {
				if (propertyValue.isEnforceAccess()) {
					wrappedBean[tokens.actualName] = value;
				}
				else if (wrappedBean[tokens.actualName] !== undefined) {
					wrappedBean[tokens.actualName] = value;
				}
				else if (mayBeAssociativeArray()) {
					wrappedBean[tokens.actualName] = value;
				}
				else {
					throw new NotWritablePropertyException(rootBean, nestedPath + propertyName,
							"Bean property '" + propertyName + "' is not writable.",
							this, arguments);
				}
			}
			catch (exception) {
				throw (new PropertyAccessException(wrappedBean, propertyName, "Variable access " +
						"to variable '" + tokens.actualName + "' failed.",
						this, arguments)).initCause(exception);
			}
		}
	}

	public function convertPropertyValue(name:String, value, type:Function) {
		if (typeof(value) == "string" || value instanceof String) {
			if (type == null) {
				if (!isNaN(value)) {
					//type = Number;
					return Number(value);
				}
				else if (value == "true") {
					//type = Boolean;
					return true;
				}
				else if (value == "false") {
					//type = Boolean;
					return false;
				}
			}
			var propertyValueConverter:PropertyValueConverter = findPropertyValueConverter(type, name);
			if (propertyValueConverter != null) {
				return propertyValueConverter.convertPropertyValue(value, type);
			}
		}
		else {
			// Convert not only managed arrays, lists, ... but also normal arrays, lists, ... (type conversion of sub-elements is not possible there)
			if (value instanceof Mergeable) {
				if (value instanceof ManagedArray) {
					var result:Array;
					if (type == null) {
						result = new Array();
					}
					else {
						if (!ClassUtil.isAssignable(type, Array)) {
							throw new TypeMismatchException(wrappedBean, name, value, type,
									"Required type is not assignable from [" +
									ReflectUtil.getTypeNameForType(Array) + "].", this, arguments);
						}
						result = new type();
					}
					var array:ManagedArray = value;
					var elementType:Function = array.getElementType();
					for (var i:Number = 0; i < array.length; i++) {
						var element = convertPropertyValue(name + PROPERTY_KEY_PREFIX + i +
								PROPERTY_KEY_SUFFIX, array[i], elementType);
						result.push(element);
					}
					return result;
				}
				if (value instanceof ManagedList) {
					if (type == null) {
						throw new TypeMismatchException(wrappedBean, name, value, List,
								"Supplied list implementation is 'null'. Note that the type of " +
								"a managed list (the list implementation to instantiate) must " +
								"be declared.", this, arguments);
					}
					if (!ClassUtil.isAssignable(type, List)) {
						throw new TypeMismatchException(wrappedBean, name, value, type,
								"Required type is not assignable from [" +
								ReflectUtil.getTypeNameForType(List) + "].", this, arguments);
					}
					var result:List = new type();
					var list:ManagedList = value;
					var array:Array = list.toArray();
					var elementType:Function = list.getElementType();
					for (var i:Number = 0; i < array.length; i++) {
						var element = convertPropertyValue(name + PROPERTY_KEY_PREFIX + i +
								PROPERTY_KEY_SUFFIX, array[i], elementType);
						result.insert(element);
					}
					return result;
				}
				if (value instanceof ManagedMap) {
					if (type == null) {
						throw new TypeMismatchException(wrappedBean, name, value, Map, "Supplied " +
								"map implementation is 'null'. Note that the type of a managed " +
								"map (the map implementation to instantiate) must be declared.",
								this, arguments);
					}
					if (!ClassUtil.isAssignable(type, Map)) {
						throw new TypeMismatchException(wrappedBean, name, value, type,
								"Required type is not assignable from [" +
								ReflectUtil.getTypeNameForType(Map) + "].", this, arguments);
					}
					var result:Map = new type();
					var map:ManagedMap = value;
					var keys:Array = map.getKeys();
					var values:Array = map.getValues();
					var keyType:Function = map.getKeyType();
					var valueType:Function = map.getValueType();
					for (var i:Number = 0; i < keys.length; i++) {
						var k = convertPropertyValue(name, keys[i], keyType);
						var v = convertPropertyValue(name + PROPERTY_KEY_PREFIX + keys[i] +
								PROPERTY_KEY_SUFFIX, values[i], valueType);
						result.put(k, v);
					}
					return result;
				}
				if (value instanceof ManagedProperties) {
					if (type == null) {
						throw new TypeMismatchException(wrappedBean, name, value, Properties,
								"Supplied properties implementation is 'null'. Note that the " +
								"type of a managed properties (the properties implementation to " +
								"instantiate) must be declared.", this, arguments);
					}
					if (!ClassUtil.isAssignable(type, Properties)) {
						throw new TypeMismatchException(wrappedBean, name, value, type,
								"Required type is not assignable from [" +
								ReflectUtil.getTypeNameForType(Properties) + "].", this, arguments);
					}
					var result:Properties = new type();
					var properties:ManagedProperties = value;
					var keys:Array = properties.getKeys();
					var values:Array = properties.getValues();
					for (var i:Number = 0; i < keys.length; i++) {
						result.setProp(keys[i], values[i]);
					}
					return result;
				}
			}
		}
		return value;
	}

	public function setPropertyValues(propertyValues:PropertyValues, ignoreUnknown:Boolean):Void {
		var propertyAccessExceptions:Array = new Array();
		var values:Array = propertyValues.getPropertyValues();
		var length:Number = values.length;
		for (var i:Number = 0; i < length; i++) {
			try {
				setPropertyValue(values[i]);
			}
			catch (exception:org.as2lib.bean.NotWritablePropertyException) {
				if (!ignoreUnknown) {
					throw exception;
				}
			}
			catch (exception:org.as2lib.bean.PropertyAccessException) {
				propertyAccessExceptions.push(exception);
			}
		}
		if (propertyAccessExceptions.length > 0) {
			throw new PropertyAccessExceptionsException(this, propertyAccessExceptions, arguments);
		}
	}

	public function findPropertyValueConverter(requiredType:Function, propertyName:String):PropertyValueConverter {
		var result:PropertyValueConverter = null;
		if (requiredType != null || propertyName != null) {
			result = findPropertyValueConverterInMap(requiredType, propertyName, customConverters);
			if (result == null) {
				result = findPropertyValueConverterInMap(requiredType, propertyName, defaultConverters);
			}
		}
		return result;
	}

	/**
	 * Finds the property value converter for the given required type and property name
	 * in the given converter map.
	 *
	 * @param requiredType the required type to find a converter for
	 * @param propertyName the specific property name to find a converter for
	 * @param converters the map of property value converters to search in
	 */
	private function findPropertyValueConverterInMap(requiredType:Function, propertyName:String,
			converters:Map):PropertyValueConverter {
		if (converters != null) {
			if (propertyName != null) {
				var holder:PropertyValueConverterHolder = converters.get(propertyName);
				var converter:PropertyValueConverter = holder.getPropertyValueConverter(requiredType);
				if (converter != null) {
					return converter;
				}
			}
			if (requiredType != null) {
				var converter:PropertyValueConverter = converters.get(requiredType);
				if (converter == null) {
					var keys:Array = converters.getKeys();
					for (var i:Number = 0; i < keys.length; i++) {
						var key = keys[i];
						if (typeof(key) == "function") {
							if (ClassUtil.isSubClassOf(requiredType, key) ||
									ClassUtil.isImplementationOf(requiredType, key)) {
								converter = converters.get(key);
								break;
							}
						}
					}
				}
				return converter;
			}
		}
		return null;
	}

	public function registerPropertyValueConverter():Void {
		var o:Overload = new Overload(this);
		o.addHandler([Function, PropertyValueConverter], registerPropertyValueConverterForType);
		o.addHandler([Function, String, PropertyValueConverter], registerPropertyValueConverterForProperty);
		o.forward(arguments);
	}

	public function registerPropertyValueConverterForType(requiredType:Function,
			propertyValueConverter:PropertyValueConverter):Void {
		registerPropertyValueConverterForProperty(requiredType, null, propertyValueConverter);
	}

	public function registerPropertyValueConverterForProperty(requiredType:Function,
			propertyName:String, propertyValueConverter:PropertyValueConverter):Void {
		if (requiredType == null && propertyName == null) {
			throw new IllegalArgumentException("Either argument 'requiredType' or 'propertyName' " +
					"is required.", this, arguments);
		}
		if (customConverters == null) {
			customConverters = new HashMap();
		}
		if (propertyName != null) {
			customConverters.put(propertyName, new PropertyValueConverterHolder(
					propertyValueConverter, requiredType));
		} else {
			customConverters.put(requiredType, propertyValueConverter);
		}
	}

	public function getWrappedBean(Void) {
		return wrappedBean;
	}

	public function setWrappedBean(wrappedBean):Void {
		this.wrappedBean = wrappedBean;
		nestedPath = "";
		rootBean = wrappedBean;
		nestedBeanWrappers.clear();
	}

}