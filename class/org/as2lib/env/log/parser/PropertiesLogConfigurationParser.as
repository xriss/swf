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

import org.as2lib.data.holder.Properties;
import org.as2lib.data.holder.properties.PropertiesParser;
import org.as2lib.env.except.IllegalArgumentException;
import org.as2lib.env.log.level.AbstractLogLevel;
import org.as2lib.env.log.LogConfigurationParser;
import org.as2lib.env.log.LogManager;
import org.as2lib.env.log.parser.AbstractLogConfigurationParser;
import org.as2lib.env.log.parser.LogConfigurationParseException;

/**
 * {@code PropertiesLogConfigurationParser} parses log configuration files in
 * properties format.
 * 
 * <p>Properties files consist of simple key-value pairs. For more information
 * take a look at the {@link org.as2lib.data.holder.properties.PropertiesParser}
 * class.
 * 
 * <p>This parser is based on the basic properties parser but supports some additional
 * 'key-words'.
 * 
 * <p>The character '+' before a value designates the following string as the name
 * of a class to instantiate. You create an instance with the name 'loggerRepository'
 * as follows.
 * <code>loggerRepository = +org.as2lib.env.log.repository.LoggerHierarchy</code>
 * 
 * <p>If you want to set a property on the 'loggerRepository' instance you can use
 * dot-syntax. The following example expects that the 'loggerRepository' has a method
 * called 'addLogger' or 'setLogger' that expects a parameter of type 'SimpleHierarchicalLogger'.
 * <code>loggerRepository.logger = +org.as2lib.env.log.logger.SimpleHierarchicalLogger</code>
 * 
 * <p>In the previous example we added on logger to the logger repository; but we may
 * want to add more than one logger. Because every key in a properties-file must be
 * distinct we must add an index to the name of the property that we want to set
 * more than once. Note that this index must be a number, but has no special meaning.
 * <code>
 *   loggerRepository.logger#0 = +org.as2lib.env.log.logger.SimpleHierarchicalLogger
 *   loggerRepository.logger#1 = +org.as2lib.env.log.logger.SimpleHierarchicalLogger
 * </code>
 * 
 * <p>The character '-' before a value says that the following string is the name
 * of a level. The appropriate level is then looked up via the {@link AbstractLogLevel#forName}
 * method.
 * <code>loggerRepository.logger#0.level = -INFO</code>
 * 
 * <p>If a value seems to be a primitive type, it will automatically be converted.
 * The strings {@code "true"} and {@code "false"} will be converted to the boolean
 * values {@code true} and {@code false} respectively. The strings {@code "1"},
 * {@code "2"}, ... are converted to numbers. Only if the value is none of the
 * above cases and does not start with '+' will it be handled as a simple string.
 * 
 * <p>You can also pass constructor arguments. You can therefore use {@code "constructor-arg"}
 * as property name. Note that the order of constructor arguments will be preserved.
 * They must be placed directly after the instance declaration.
 * <code>
 *   loggerRepository.logger = +org.as2lib.env.log.logger.SimpleHierarchicalLogger
 *   loggerRepository.logger.constructor-arg = com.simonwacker
 * </code>
 * 
 * <p>A complete configuration may look something like the following. Note that in
 * this case the log manager passed to the parser must have a method named
 * 'setLoggerRepository' or 'addLoggerRepository'.
 * <code>
 *   loggerRepository = +org.as2lib.env.log.repository.LoggerHierarchy
 *   
 *   loggerRepository.logger#0 = +org.as2lib.env.log.logger.SimpleHierarchicalLogger
 *   loggerRepository.logger#0.name = com.simonwacker
 *   loggerRepository.logger#0.level = -INFO
 *   
 *   loggerRepository.logger#1 = +org.as2lib.env.log.logger.SimpleHierarchicalLogger
 *   loggerRepository.logger#1.name = com.simonwacker.myproject
 *   loggerRepository.logger#1.level = -ERROR
 *   
 *   loggerRepository.logger#2 = +org.as2lib.env.log.logger.SimpleHierarchicalLogger
 *   loggerRepository.logger#2.name = com.simonwacker.myproject.domain
 *   loggerRepository.logger#2.level = -DEBUG
 * </code>
 * 
 * @author Simon Wacker
 */
class org.as2lib.env.log.parser.PropertiesLogConfigurationParser extends AbstractLogConfigurationParser implements LogConfigurationParser {
	
	/** The manager to configure. */
	private var manager;
	
	/** Properties saved by index and by name. */
	private var properties:Array;
	
	/**
	 * Constructs a new {@code PropertiesLogConfigurationParser} instance.
	 * 
	 * <p>If {@code logManager} is {@code null} or {@code undefined}, {@link LogManager}
	 * will be used.
	 * 
	 * @param logManager (optional) the manager to configure with the beans specified
	 * in the log configuration properties-file
	 */
	public function PropertiesLogConfigurationParser(logManager) {
		if (logManager) {
			manager = logManager;
		} else {
			manager = LogManager;
		}
		properties = new Array();
	}
	
	/**
	 * Parses the log configuration. If argument {@code propertiesLogConfiguration} is
	 * {@code null} or {@code undefined} the one returned by {@link #getLogConfiguration}
	 * will be used.
	 * 
	 * @param propertiesLogConfiguration log configuration in properties format
	 * @throws IllegalArgumentException if argument {@code xmlLogConfiguration} is
	 * {@code null} or {@code undefined} and no log configuration was set via
	 * {@link #setLogConfiguration} previously
	 * @throws LogConfigurationParseException in case of parse errors
	 */
	public function parse(propertiesLogConfiguration:String):Void {
		if (propertiesLogConfiguration == null) {
			propertiesLogConfiguration = getLogConfiguration();
			if (propertiesLogConfiguration == null) {
				throw new IllegalArgumentException("Either argument 'propertiesLogConfiguration' " +
						"must be supplied or the log configuration must be set via " +
						"'setLogConfiguration' before invoking this method.", this, arguments);
			}
		}
		var parser:PropertiesParser = new PropertiesParser();
		var props:Properties = parser.parseProperties(propertiesLogConfiguration);
		var keys:Array = props.getKeys();
		var values:Array = props.getValues();
		var classes:Array = new Array();
		for (var i:Number = 0; i < keys.length; i++) {
			var key:String = keys[i];
			var value:String = values[i];
			if (isConstructorArgument(key)) {
				var propertyPath:String = extractPropertyPath(key);
				if (properties[propertyPath] == null) {
					throw new LogConfigurationParseException("There is no property with key [" + propertyPath + "] to add a constructor argument to.", this, arguments);
				}
				if (properties[propertyPath].a === undefined) {
					throw new LogConfigurationParseException("Property with key [" + propertyPath + "] is no class to instantiate, so you cannot declare a constructor argument for it.", this, arguments);
				}
				if (properties[propertyPath].a == null) {
					throw new LogConfigurationParseException("Property with key [" + propertyPath + "] has already been instantiated, you must declare the constructor argument for it directly after its declaration.", this, arguments);
				}
				properties[extractPropertyPath(key)].a.push(key);
			}
			if (classes.length > 0) {
				if (extractPropertyName(key) != "constructor-arg") {
					createInstance(classes.pop().toString());
				}
			}
			for (var j:Number = properties.length - 1; j >= 0; j--) {
				if (isConstructorArgument(properties[j])) {
					properties.pop();
					continue;
				}
				if (key.indexOf(properties[j]) == -1) {
					addOrSetProperty(properties.pop().toString());
				}
			}
			if (value.indexOf("+") == 0) {
				var className:String = value.substr(1);
				var clazz:Function = findClass(className);
				if (clazz == null) {
					throw new LogConfigurationParseException("A class corresponding to the class name [" + className + "] of key [" + key + "] could not be found. You either misspelled the class name or forgot to import the class in your swf.", this, arguments);
				}
				properties[key] = {v: clazz, a: new Array()};
				properties.push(key);
				classes.push(key);
			} else {
				var convertedValue = convertValue(value);
				properties[key] = {v: convertedValue};
				properties.push(key);
			}
		}
		if (classes.length > 0) {
			createInstance(classes.pop().toString());
		}
		for (var j:Number = properties.length - 1; j >= 0; j--) {
			if (isConstructorArgument(properties[j])) {
				properties.pop();
				continue;
			}
			addOrSetProperty(properties.pop().toString());
		}
	}
	
	/**
	 * Creates the instance of the given {@code key}.
	 * 
	 * @param key the key that specifies the instance to create
	 */
	private function createInstance(key:String):Void {
		var object = properties[key];
		var clazz:Function = object.v;
		var instance = new Object();
		instance.__proto__ = clazz.prototype;
		instance.__constructor__ = clazz;
		var args:Array = new Array();
		for (var i:Number = 0; i < object.a.length; i++) {
			args.push(properties[object.a[i]].v);
		}
		clazz.apply(instance, args);
		object.v = instance;
		object.a = null;
	}
	
	/**
	 * Adds or sets the property represented by the given {@code key} on the
	 * corresponding bean.
	 * 
	 * @param key the key that specifies the property to add or set and the instance to
	 * set or add it on
	 */
	private function addOrSetProperty(key:String):Void {
		var value = properties[key].v;
		var propertyPath:String = extractPropertyPath(key);
		var bean = propertyPath == null ? manager : properties[propertyPath].v;
		var propertyName:String = extractPropertyName(key);
		if (bean == null) {
			throw new LogConfigurationParseException("There is no property with key [" + propertyPath + "] to add or set the property [" + propertyName + "] on.", this, arguments);
		}
		var methodName = generateMethodName("add", propertyName);
		if (!existsMethod(bean, methodName)) {
			methodName = generateMethodName("set", propertyName);
			if (!existsMethod(bean, methodName)) {
				throw new LogConfigurationParseException("Neither a method with name [" + generateMethodName("add", propertyName) + "] nor [" + methodName + "] exists on bean [" + propertyPath + "].", this, arguments);
			}
		}
		bean[methodName](value);
	}
	
	/**
	 * Extracts the name of the property from the given {@code key}.
	 * 
	 * @param key the key to extract the property name from
	 * @return the name of the property
	 */
	private function extractPropertyName(key:String):String {
		var dotIndex:Number = key.lastIndexOf(".");
		var result:String = key.substr(dotIndex + 1);
		var poundIndex:Number = result.indexOf("#");
		if (poundIndex > -1) {
			result = result.substr(0, poundIndex);
		}
		return result;
	}
	
	/**
	 * Extracts the path of the property from the given {@code key}.
	 * 
	 * @param key the key to extract the property path from
	 * @return the path of the property
	 */
	private function extractPropertyPath(key:String):String {
		var dotIndex:Number = key.lastIndexOf(".");
		if (dotIndex == -1) return null;
		return key.substr(0, dotIndex);
	}
	
	/**
	 * Checks whether the given {@code key} is a constructor argument.
	 * 
	 * @param key the key to check whether it is a constructor argument
	 * @return {@code true} if {@code key} is a constructor argument else {@code false}
	 */
	private function isConstructorArgument(key:String):Boolean {
		return (extractPropertyName(key) == "constructor-arg");
	}
	
	/**
	 * Converts the given {@code value} into its corresponding primitive type.
	 * 
	 * <p>The strings {@code "true"} and {@code "false"} are converted to the booleans
	 * {@code true} and {@code false} respectively. The strings {@code "1"}, {@code "2"},
	 * ... are converted to the appropriate number value. If none of the above holds
	 * true, the passed-in value will be returned unchanged.
	 * 
	 * <p>If {@code value} starts with the character {@code "-"}, it is supposed to be
	 * a level name. The corresponding level will be looked up via the {@link AbstractLogLevel#forName}
	 * method and returned.
	 * 
	 * @param value the value to convert
	 * @return the converted value
	 */
	private function convertValue(value:String) {
		if (value.indexOf("-") == 0) {
			return AbstractLogLevel.forName(value.substr(1));
		}
		return super.convertValue(value);
	}
	
}