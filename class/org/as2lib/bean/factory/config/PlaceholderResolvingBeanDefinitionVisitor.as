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

import org.as2lib.bean.factory.config.BeanDefinitionVisitor;
import org.as2lib.data.holder.Properties;
import org.as2lib.bean.factory.config.PropertyPlaceholderConfigurer;
import org.as2lib.bean.factory.BeanDefinitionStoreException;
import org.as2lib.util.StringUtil;

/**
 * {@code PlaceholderResolvingBeanDefinitionVisitor} resolves placeholders in string
 * values of bean definitions.
 *
 * @author Simon Wacker
 */
class org.as2lib.bean.factory.config.PlaceholderResolvingBeanDefinitionVisitor extends BeanDefinitionVisitor {

	private var properties:Properties;

	private var placeholderPrefix:String;

	private var placeholderSuffix:String;

	private var ignoreUnresolvablePlaceholders:Boolean;

	/**
	 * Constructs a new {@code PlaceholderResolvingBeanDefinitionVisitor} instance.
	 *
	 * @param properties the properties to resolve placeholders against
	 */
	public function PlaceholderResolvingBeanDefinitionVisitor(properties:Properties) {
		this.properties = properties;
		placeholderPrefix = PropertyPlaceholderConfigurer.DEFAULT_PLACEHOLDER_PREFIX;
		placeholderSuffix = PropertyPlaceholderConfigurer.DEFAULT_PLACEHOLDER_SUFFIX;
		ignoreUnresolvablePlaceholders = false;
	}

	/**
	 * Sets the properties to resolve placeholders against.
	 */
	public function setProperties(properties:Properties):Void {
		this.properties = properties;
	}

	/**
	 * Sets the prefix that a placeholder string starts with. The default is "${".
	 *
	 * @see PropertyPlaceholderConfigurer#DEFAULT_PLACEHOLDER_PREFIX
	 */
	public function setPlaceholderPrefix(placeholderPrefix:String):Void {
		this.placeholderPrefix = placeholderPrefix;
	}

	/**
	 * Sets the suffix that a placeholder string ends with. The default is "}".
	 *
	 * @see PropertyPlaceholderConfigurer#DEFAULT_PLACEHOLDER_SUFFIX
	 */
	public function setPlaceholderSuffix(placeholderSuffix:String):Void {
		this.placeholderSuffix = placeholderSuffix;
	}

	/**
	 * Sets whether to ignore unresolvable placeholders. Default is {@code false}:
	 * An exception will be thrown if a placeholder cannot be resolved.
	 */
	public function setIgnoreUnresolvablePlaceholders(ignoreUnresolvablePlaceholders:Boolean):Void {
		this.ignoreUnresolvablePlaceholders = ignoreUnresolvablePlaceholders;
	}

	private function resolveStringValue(stringValue:String):String {
		return parseStringValue(stringValue, null);
	}

	/**
	 * Parses the given string value recursively, to be able to resolve nested
	 * placeholders (when resolved property values in turn contain placeholders).
	 *
	 * @param stringValue the String value to parse
	 * @param originalPlaceholder the original placeholder, used to detect circular
	 * references between placeholders. Only non-null if a nested placeholder is parsed.
	 * @throws BeanDefinitionStoreException if invalid values are encountered
	 * @see #resolvePlaceholder
	 */
	private function parseStringValue(stringValue:String, originalPlaceholder:String):String {
		var result:String = stringValue;
		var startIndex:Number = stringValue.indexOf(placeholderPrefix);
		while (startIndex != -1) {
			var endIndex:Number = result.indexOf(placeholderSuffix, startIndex + placeholderPrefix.length);
			if (endIndex != -1) {
				var placeholder:String = result.substring(startIndex + placeholderPrefix.length, endIndex);
				var originalPlaceholderToUse:String;
				if (originalPlaceholder != null) {
					originalPlaceholderToUse = originalPlaceholder;
					if (placeholder == originalPlaceholder) {
						throw new BeanDefinitionStoreException(null, "Circular placeholder " +
								"reference '" + placeholder + "' in property definitions.",
								this, arguments);
					}
				}
				else {
					originalPlaceholderToUse = placeholder;
				}
				var propertyValue:String = resolvePlaceholder(placeholder);
				if (propertyValue != null) {
					// Recursive invocation, parsing placeholders contained in the
					// previously resolved placeholder value.
					propertyValue = parseStringValue(propertyValue, originalPlaceholderToUse);
					result = StringUtil.replace(result,
							result.substring(startIndex, endIndex + placeholderSuffix.length),
							propertyValue);
					/*if (logger.isDebugEnabled()) {
						logger.debug("Resolved placeholder '" + placeholder + "' to value [" + propVal + "]");
					}*/
					startIndex = result.indexOf(placeholderPrefix, startIndex + propertyValue.length);
				}
				else if (ignoreUnresolvablePlaceholders) {
					// Proceed with unprocessed value.
					startIndex = result.indexOf(placeholderPrefix, endIndex + placeholderSuffix.length);
				}
				else {
					throw new BeanDefinitionStoreException(null, "Could not resolve placeholder '" +
							placeholder + "'.", this, arguments);
				}
			}
			else {
				startIndex = -1;
			}
		}
		return result;
	}

	/**
	 * Resolves the given placeholder using the given properties. Default implementation
	 * simply checks for a corresponding property key.
	 *
	 * <p>Subclasses can override this for customized placeholder-to-key mappings
	 * or custom resolution strategies, possibly just using the given properties
	 * as fallback.
	 *
	 * @param placeholder the placeholder to resolve
	 * @return the resolved value, or {@code null} if none
	 */
	private function resolvePlaceholder(placeholder:String):String {
		return properties.getProp(placeholder, null);
	}

}