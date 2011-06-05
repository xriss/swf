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

import org.as2lib.bean.factory.BeanInitializationException;
import org.as2lib.bean.factory.config.BeanDefinition;
import org.as2lib.bean.factory.config.ConfigurableListableBeanFactory;
import org.as2lib.bean.factory.config.PropertyResourceConfigurer;
import org.as2lib.bean.PropertyValue;
import org.as2lib.data.holder.Properties;

/**
 * {@code PropertyOverrideConfigurer} overrides bean property values in an application
 * context definition. It <i>pushes</i> values from a properties file into bean
 * definitions.
 *
 * <p>Configuration lines are expected to be of the following form:
 *
 * <pre>beanName.property=value</pre>
 *
 * <p>Example properties file:
 *
 * <pre>
 *   login.username=simonwacker
 *   login.password=H3dLA9n1
 * </pre>
 *
 * <p>In contrast to {@link PropertyPlaceholderConfigurer}, the original definition can
 * have default values or no values at all for such bean properties. If an overriding
 * properties file does not have an entry for a certain bean property, the default
 * context definition is used.
 *
 * <p>Note that the context definition <i>is not</i> aware of being overridden; so this
 * is not immediately obvious when looking at the XML definition file.
 *
 * <p>In case of multiple property override configurers that define different values for
 * the same bean property, the <i>last</i> one will win (due to the overriding mechanism).
 *
 * <p>Property values can be converted after reading them in, through overriding
 * the {@link #convertPropertyValue} method. For example, encrypted values can be
 * detected and decrypted accordingly before processing them.
 *
 * @author Simon Wacker
 */
class org.as2lib.bean.factory.config.PropertyOverrideConfigurer extends PropertyResourceConfigurer {

	public static var DEFAULT_BEAN_NAME_SEPARATOR:String = ".";

	private var beanNameSeparator:String;

	private var ignoreInvalidKeys:Boolean;

	/** Contains names of beans that have overrides */
	private var beanNames:Array;

	/**
	 * Constructs a new {@code PropertyOverrideConfigurer} instance.
	 */
	public function PropertyOverrideConfigurer(Void) {
		beanNameSeparator = DEFAULT_BEAN_NAME_SEPARATOR;
		ignoreInvalidKeys = false;
		beanNames = new Array();
	}

	/**
	 * Sets the separator to expect between bean name and property path. Default is a
	 * dot (".").
	 *
	 * @see #DEFAULT_BEAN_NAME_SEPARATOR
	 */
	public function setBeanNameSeparator(beanNameSeparator:String):Void {
		this.beanNameSeparator = beanNameSeparator;
	}

	/**
	 * Sets whether to ignore invalid keys. Default is {@code false}.
	 *
	 * <p>If you ignore invalid keys, keys that do not follow the 'beanName.property'
	 * format will be ignored. This allows to have arbitrary other keys in a properties
	 * file.
	 */
	public function setIgnoreInvalidKeys(ignoreInvalidKeys:Boolean):Void {
		this.ignoreInvalidKeys = ignoreInvalidKeys;
	}

	private function processProperties(beanFactory:ConfigurableListableBeanFactory, properties:Properties):Void {
		var keys:Array = properties.getKeys();
		for (var i:Number = 0; i < keys.length; i++) {
			var key:String = keys[i];
			try {
				processKey(beanFactory, key, properties.getProp(key));
			}
			catch (exception:org.as2lib.bean.BeanException) {
				if (!ignoreInvalidKeys) {
					throw (new BeanInitializationException("Could not process key '" + key +
							"' in property override configurer.", this, arguments)).initCause(exception);
				}
				/*if (logger.isDebugEnabled()) {
					logger.debug(msg, ex);
				}*/
			}
		}
	}

	/**
	 * Processes the given key as 'beanName.property' entry.
	 */
	private function processKey(factory:ConfigurableListableBeanFactory, key:String, value:String):Void {
		var separatorIndex:Number = key.indexOf(beanNameSeparator);
		if (separatorIndex == -1) {
			throw new BeanInitializationException("Invalid key '" + key +
					"': expected 'beanName" + beanNameSeparator + "property'");
		}
		var beanName:String = key.substring(0, separatorIndex);
		var beanProperty:String = key.substring(separatorIndex + 1);
		beanNames[beanName] = true;
		applyPropertyValue(factory, beanName, beanProperty, value);
		/*if (logger.isDebugEnabled()) {
			logger.debug("Property '" + key + "' set to value [" + value + "]");
		}*/
	}

	/**
	 * Applies the given property value to the corresponding bean.
	 */
	private function applyPropertyValue(factory:ConfigurableListableBeanFactory,
			beanName:String, property:String, value:String) {
		var bd:BeanDefinition = factory.getBeanDefinition(beanName);
		bd.getPropertyValues().addPropertyValueByPropertyValue(new PropertyValue(property, value), true);
	}

	/**
	 * Were there overrides for this bean? Only valid after processing has occurred
	 * at least once.
	 *
	 * @param beanName name of the bean to query status for
	 * @return whether there were property overrides for the named bean
	 */
	public function hasPropertyOverrides(beanName:String):Boolean {
		return (beanNames[beanName] == true);
	}

}