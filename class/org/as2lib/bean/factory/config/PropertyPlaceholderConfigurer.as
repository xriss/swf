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

import org.as2lib.bean.factory.BeanDefinitionStoreException;
import org.as2lib.bean.factory.BeanFactory;
import org.as2lib.bean.factory.BeanFactoryAware;
import org.as2lib.bean.factory.BeanNameAware;
import org.as2lib.bean.factory.config.BeanDefinition;
import org.as2lib.bean.factory.config.BeanDefinitionVisitor;
import org.as2lib.bean.factory.config.ConfigurableListableBeanFactory;
import org.as2lib.bean.factory.config.PlaceholderResolvingBeanDefinitionVisitor;
import org.as2lib.bean.factory.config.PropertyResourceConfigurer;
import org.as2lib.data.holder.Properties;

/**
 * {@code PropertyPlaceholderConfigurer} is a property resource configurer that
 * resolves placeholders in bean property values of context definitions. It
 * <i>pulls</i> values from a properties file into bean definitions.
 *
 * <p>The default placeholder syntax follows the Ant / Log4J / JSP EL style:
 *
 * <pre>${...}</pre>
 *
 * <p>Example XML context definition:
 *
 * <pre>
 *   &lt;bean id="dataSource" class="MyDataSource"&gt;
 *     &lt;property name="username"&gt;${username}&lt;/property&gt;
 *     &lt;property name="password"&gt;${password}&lt;/property&gt;
 *     &lt;property name="url"&gt;${url}&lt;/property&gt;
 *   &lt;/bean&gt;
 * </pre>
 *
 * <p>Example properties file:
 *
 * <pre>
 *   username=simonwacker
 *   password=H3dLA9n1
 *   url=urltodatabase
 * </pre>
 *
 * <p>Property placeholder configurer checks simple property values, lists, maps,
 * props, and bean names in bean references. Furthermore, placeholder values can
 * also cross-reference other placeholders, like:
 *
 * <pre>
 *   rootPath=myrootdir
 *   subPath=${rootPath}/subdir
 * </pre>
 *
 * <p>In contrast to {@link PropertyOverrideConfigurer}, this configurer allows to
 * fill in explicit placeholders in context definitions. Therefore, the original
 * definition cannot specify any default values for such bean properties, and the
 * placeholder properties file is supposed to contain an entry for each defined
 * placeholder.
 *
 * <p>If a configurer cannot resolve a placeholder, a {@link BeanDefinitionStoreException}
 * will be thrown. If you want to check against multiple properties files, specify
 * multiple resources via the "location" setting. You can also define multiple
 * property placeholder configurers, each with its <i>own</i> placeholder syntax.
 *
 * <p>Default property values can be defined via "properties", to make overriding
 * definitions in properties files optional.
 *
 * <p>Note that the context definition <i>is</i> aware of being incomplete;
 * this is immediately obvious to users when looking at the XML definition file.
 * Hence, placeholders have to be resolved; any desired defaults have to be
 * defined as placeholder values as well (for example in a default properties file).
 *
 * <p>Property values can be converted after reading them in, through overriding
 * the {@link #convertPropertyValue} method. For example, encrypted values can be
 * detected and decrypted accordingly before processing them.
 *
 * @author Simon Wacker
 */
class org.as2lib.bean.factory.config.PropertyPlaceholderConfigurer extends
		PropertyResourceConfigurer implements BeanNameAware, BeanFactoryAware {

	/** Default placeholder prefix. */
	public static var DEFAULT_PLACEHOLDER_PREFIX:String = "${";

	/** Default placeholder suffix. */
	public static var DEFAULT_PLACEHOLDER_SUFFIX:String = "}";

	private var visitor:PlaceholderResolvingBeanDefinitionVisitor;

	private var beanName:String;

	private var beanFactory:BeanFactory;

	/**
	 * Constructs a new {@code PropertyPlaceholderConfigurer} instance.
	 */
	public function PropertyPlaceholderConfigurer(Void) {
		visitor = new PlaceholderResolvingBeanDefinitionVisitor();
	}

	/**
	 * Sets the prefix that a placeholder string starts with. The default is "${".
	 *
	 * @see #DEFAULT_PLACEHOLDER_PREFIX
	 */
	public function setPlaceholderPrefix(placeholderPrefix:String):Void {
		visitor.setPlaceholderPrefix(placeholderPrefix);
	}

	/**
	 * Sets the suffix that a placeholder string ends with. The default is "}".
	 *
	 * @see #DEFAULT_PLACEHOLDER_SUFFIX
	 */
	public function setPlaceholderSuffix(placeholderSuffix:String):Void {
		visitor.setPlaceholderSuffix(placeholderSuffix);
	}

	/**
	 * Sets whether to ignore unresolvable placeholders. Default is {@code false}:
	 * An exception will be thrown if a placeholder cannot be resolved.
	 */
	public function setIgnoreUnresolvablePlaceholders(ignoreUnresolvablePlaceholders:Boolean):Void {
		visitor.setIgnoreUnresolvablePlaceholders(ignoreUnresolvablePlaceholders);
	}

	/**
	 * Sets this bean's name. Only necessary to check that we are not parsing our own
	 * bean definition, to avoid failing on unresolvable placeholders in properties
	 * file locations.
	 */
	public function setBeanName(beanName:String):Void {
		this.beanName = beanName;
	}

	/**
	 * Sets the bean factory managing this bean. Only necessary to check that we are
	 * not parsing our own bean definition, to avoid failing on unresolvable
	 * placeholders in properties file locations.
	 */
	public function setBeanFactory(beanFactory:BeanFactory):Void {
		this.beanFactory = beanFactory;
	}

	private function processProperties(beanFactory:ConfigurableListableBeanFactory, properties:Properties):Void {
		visitor.setProperties(properties);
		var beanNames:Array = beanFactory.getBeanDefinitionNames();
		for (var i:Number = 0; i < beanNames.length; i++) {
			var beanName:String = beanNames[i];
			// Check that we're not parsing our own bean definition,
			// to avoid failing on unresolvable placeholders in properties file locations.
			if (!(beanName == this.beanName && beanFactory == this.beanFactory)) {
				var beanDefinition:BeanDefinition = beanFactory.getBeanDefinition(beanName);
				try {
					visitor.visitBeanDefinition(beanDefinition);
				}
				catch (exception:org.as2lib.bean.factory.BeanDefinitionStoreException) {
					throw (new BeanDefinitionStoreException(beanName, exception.getMessage(),
							this, arguments)).initCause(exception);
				}
			}
		}
	}

}