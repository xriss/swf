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

import org.as2lib.bean.PropertyAccess;
import org.as2lib.core.BasicInterface;

/**
 * {@code BeanFactory} is the root interface for accessing the bean container. This
 * is the basic client view of a bean container; further interfaces such as
 * {@link ListableBeanFactory} and {@link ConfigurableListableBeanFactory} are
 * available for specific purposes.
 * 
 * <p>This interface is implemented by classes that hold a number of bean definitions,
 * each uniquely identified by a name. Depending on the bean definition, the factory
 * will return either an independent instance of a contained object (the prototype
 * design pattern), or a single shared instance (a superior alternative to the singleton
 * design pattern, in which the instance is a singleton in the scope of the factory).
 * Which type of instance will be returned depends on the bean factory configuration:
 * the API is the same. The singleton approach is more useful and more common in practice.
 * 
 * <p>The point of this approach is that the bean factory is a central registry of
 * application components, and centralizes configuration of application components
 * (no more do individual objects need to read properties files, for example).
 * 
 * <p>Note that it is generally better to rely on dependency injection ("push" configuration)
 * to configure application objects through setters or constructors, rather than use any
 * form of "pull" configuration like a bean factory lookup. As2lib's dependency injection
 * functionality is implemented using {@code BeanFactory} and its subinterfaces.
 * 
 * <p>Normally a bean factory will load or be populated with bean definitions stored
 * in a configuration source (such as an XML document), and use the {@code org.as2lib.bean}
 * package to configure the beans. However, an implementation could simply return objects
 * it creates as necessary directly in code. There are no constraints on how the definitions
 * could be stored: DB, XML, properties file etc. Implementations are encouraged to support
 * references amongst beans, to either singletons or prototypes.
 * 
 * <p>In contrast to the methods in {@link ListableBeanFactory}, all of the methods in this
 * interface will also check parent factories if this is a {@link HierarchicalBeanFactory}.
 * If a bean is not found in this factory instance, the immediate parent is asked. Beans in
 * this factory instance are supposed to override beans of the same name in any parent factory.
 * 
 * <p>Bean factory implementations should support the standard bean lifecycle interfaces as
 * far as possible. The maximum set of initialization methods and their standard order is:
 * <ol>
 *   <li>{@link BeanNameAware#setBeanName}</li>
 *   <li>{@link BeanFactoryAware#setBeanFactory}</li>
 *   <li>
 *     {@link ApplicationEventPublisherAware#setApplicationEventPublisher} (only applicable
 *     when running in an application context)
 *   </li>
 *   <li>
 *     {@link MessageSourceAware#setMessageSource} (only applicable when running in an application
 *     context)
 *   </li>
 *   <li>
 *     {@link ApplicationContextAware#setApplicationContext} (only applicable when running in an
 *     application context)</li>
 *   <li>{@link BeanPostProcessor#postProcessBeforeInitialization}</li>
 *   <li>{@link InitializingBean#afterPropertiesSet}</li>
 *   <li>a custom init-method definition</li>
 *   <li>{@link BeanPostProcessor#postProcessAfterInitialization}</li>
 * </ol>
 * 
 * <p>On shutdown of a bean factory, the following lifecycle methods apply:
 * <ol>
 *   <li>{@link DisposableBean#destroy}</li>
 *   <li>a custom destroy-method definition</li>
 * </ol>
 * 
 * @author Simon Wacker
 */
interface org.as2lib.bean.factory.BeanFactory extends BasicInterface {
	
	/**
	 * Checks whether this bean factory contains a bean definition with the given 
	 * {@code beanName}. The parent factory will be asked if the bean cannot be found
	 * in this factory.
	 * 
	 * @param name the name of the bean to query
	 * @return {@code true} if a bean with the given name is defined else {@code false}
	 */
	public function containsBean(name:String):Boolean;
	
	/**
	 * @overload #getBeanByName
	 * @overload #getBeanByNameAndType
	 */
	public function getBean();
	
	/**
	 * Returns an instance, which may be shared or independent, of the given bean name.
	 * This method allows a bean factory to be used as a replacement for the singleton
	 * or prototype design patterns.
	 * 
	 * <p>Callers may retain references to returned objects in the case of singleton
	 * beans.
	 * 
	 * <p>This method delegates to the parent factory if the bean cannot be found in
	 * this factory.
	 * 
	 * <p>If the populate mode of the bean with the given name is set to 'populate
	 * afterwards' and a property is given, the bean will be instantiated, then the
	 * given property will be intialized with the bean instance and after that the
	 * bean instance will be populated, which means that its properties will be applied
	 * to it.
	 * 
	 * <p>If the bean with the given name shall be instantiated by means of a property,
	 * then the given property will be used to instantiate the bean. This means that
	 * the object returned by get-access to the given property will be used as bean
	 * instance.
	 * 
	 * @param name the name of the bean to return
	 * @param property the property to initialize with the returned bean instance
	 * if the bean's populate mode is set to 'populate afterwards' or the property
	 * to use for instantiating the bean when it shall be instantiated by means of
	 * a property
	 * @return the bean instance
	 * @throws NoSuchBeanDefinitionException if there is no bean definition with the
	 * specified name 
     * @throws BeanException if the bean could not be obtained
     * @see BeanDefinition#getPopulateMode
     * @see BeanDefinition#isInstantiateWithProperty
	 */
	public function getBeanByName(name:String, property:PropertyAccess);
	
	/**
	 * Returns an instance (possibly shared or independent) of the given bean name.
	 * 
	 * <p>Behaves the same as {@link #getBeanByName}, but provides a measure of type
	 * safety by throwing an exception if the bean is not of the required type. This
	 * means that class cast errors will not happen when casting the result.
	 * 
	 * <p>If the populate mode of the bean with the given name is set to 'populate
	 * afterwards' and a property is given, the bean will be instantiated, then the
	 * given property will be intialized with the bean instance and after that the
	 * bean instance will be populated, which means that its properties will be applied
	 * to it.
	 * 
	 * <p>If the bean with the given name shall be instantiated by means of a property,
	 * then the given property will be used to instantiate the bean. This means that
	 * the object returned by get-access to the given property will be used as bean
	 * instance.
	 * 
	 * @param name the name of the bean to return
	 * @param requiredType the type the bean must match or {@code null} for any match
	 * @param property the property to initialize with the returned bean instance
	 * if the bean's populate mode is set to 'populate afterwards' or the property
	 * to use for instantiating the bean when it shall be instantiated by means of
	 * a property
	 * @return an instance of the bean
	 * @throws BeanNotOfRequiredTypeException if the bean is not of the required type
	 * @throws NoSuchBeanDefinitionException if there is no bean definition for the
	 * given name
	 * @throws BeanException if the bean could not be created
	 * @see BeanDefinition#setPopulateMode
	 */
	public function getBeanByNameAndType(name:String, requiredType:Function, property:PropertyAccess);
	
	/**
	 * Determines the type of the bean with the given name. More specifically, checks
	 * the type of object that {@link #getBean} would return. For a {@link FactoryBean},
	 * returns the type of object that the factory bean creates.
	 * 
	 * @param name the name of the bean to query
	 * @return the type of the bean, or {@code null} if not determinable
	 * @throws NoSuchBeanDefinitionException if there is no bean with the given name
	 */
	public function getType(name:String):Function;
	
	/**
	 * Returns the aliases ({@code String} values) for the given bean name, if defined.
	 * 
	 * <p>Will ask the parent factory if the bean cannot be found in this factory.
	 * 
	 * @param name the bean name to check for aliases
	 * @return the aliases, or an empty array if none
	 * @throws NoSuchBeanDefinitionException if there is no such bean definition
	 */
	public function getAliases(name:String):Array;
	
	/**
	 * Checks whether the bean corresponding to the given name is a singleton. If it is
	 * a singleton {@link #getBean} always returns the same object.
	 * 
	 * <p>Will ask the parent factory if the bean cannot be found in this factory.
	 * 
	 * @param name the name of the bean to query
	 * @return {@code true} if the bean is a singleton else {@code false}
	 * @throws NoSuchBeanDefinitionException if there is no bean with the given name
	 */
	public function isSingleton(name:String):Boolean;
	
}