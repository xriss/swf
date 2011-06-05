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

import org.as2lib.bean.factory.BeanFactory;
import org.as2lib.bean.factory.config.BeanDefinition;
import org.as2lib.bean.factory.config.BeanPostProcessor;
import org.as2lib.bean.factory.ListableBeanFactory;
import org.as2lib.bean.PropertyValueConverter;

/**
 * {@code ConfigurableListableBeanFactory} shall be implemented by most bean factories.
 * It provides facilities to configure a bean factory, in addition to the bean factory
 * client methods in the {@code ListableBeanFactory} interface.
 * 
 * <p>This interface is not meant to be used in normal application code: Stick to
 * {@code BeanFactory} or {@code ListableBeanFactory} for typical use cases. This
 * interface is just meant to allow for framework-internal plug'n'play even when
 * needing access to bean factory configuration methods.
 * 
 * @author Simon Wacker
 */
interface org.as2lib.bean.factory.config.ConfigurableListableBeanFactory extends ListableBeanFactory {
	
	/**
	 * Sets the parent of this bean factory.
	 * 
	 * <p>Note that the parent shouldn't be changed: It should only be set outside
	 * a constructor if it is not available when an object of this class is created.
	 * 
	 * @param parentBeanFactory the parent bean factory
	 */
	public function setParentBeanFactory(parentBeanFactory:BeanFactory):Void;
	
	/**
	 * Registers the given property value converter for all properties of the given
	 * type. This method is meant to be invoked during factory configuration.
	 * 
	 * @param requiredType the type of the property
	 * @param propertyValueConverter the property value converter for the given type
	 */
	public function registerPropertyValueConverter(requiredType:Function, propertyValueConverter:PropertyValueConverter):Void;
	
	/**
	 * Adds a new bean post processor that will be applied to beans created by this
	 * factory. This method is meant to be invoked during factory configuration.
	 * 
	 * @param beanPostProcessor the bean processor to register
	 */
	public function addBeanPostProcessor(beanPostProcessor:BeanPostProcessor):Void;
	
	/**
	 * Return the current number of registered bean post processors.
	 * 
	 * @return the number of bean post processors
	 */
	public function getBeanPostProcessorCount(Void):Number;
	
	/**
	 * Creates an alias for the given bean name.
	 * 
	 * <p>Typically invoked during factory configuration, but can also be used for
	 * runtime registration of aliases. Therefore, a factory implementation should
	 * synchronize alias access.
	 * 
	 * @param beanName the name of the bean
	 * @param alias the alias that will behave the same as the bean name
	 * @throws NoSuchBeanDefinitionException if there is no bean with the given name
	 * @throws BeanException if the alias is already in use
	 */
	public function registerAlias(beanName:String, alias:String):Void;
	
	/**
	 * Registers the given existing object as singleton in this bean factory, under
	 * the given bean name.
	 * 
	 * <p>The given instance is supposed to be fully initialized; the factory
	 * will not perform any initialization callbacks (in particular, it won't
	 * call the {@link InitializingBean#afterPropertiesSet} method).
	 * The given instance will not receive any destruction callbacks
	 * (like the {@link DisposableBean#destroy} method) either.
	 * 
	 * <p><b>Register a bean definition instead of an existing instance if
	 * your bean is supposed to receive initialization and/or destruction
	 * callbacks.</b>
	 * 
	 * <p>Typically invoked during factory configuration, but can also be
	 * used for runtime registration of singletons. Therefore, a factory
	 * implementation should synchronize singleton access; it will have
	 * to do this anyway if it supports lazy initialization of singletons.
	 * 
	 * @param beanName the name of the bean
	 * @param singleton the existing object
	 * @throws BeanException if the singleton could not be registered
	 */
	public function registerSingleton(beanName:String, singleton):Void;
	
	/**
	 * Checks if this bean factory contains a singleton instance with the given name.
	 * Only checks already instantiated singletons; does not return {@code true} for
	 * singleton bean definitions that have not been instantiated yet.
	 * 
	 * <p>The main purpose of this method is to check manually registered singletons
	 * (see {@link #registerSingleton}). Can also be used to check whether a
	 * singleton defined by a bean definition has already been created.
	 * 
	 * <p>To check whether a bean factory contains a bean definition with a given name,
	 * use {@link ListableBeanFactory#containsBeanDefinition}. Calling both
	 * {@code containsBeanDefinition} and {@code containsSingleton} answers
	 * whether a specific bean factory contains an own bean with the given name.
	 * 
	 * <p>Use {@link BeanFactory#containsBean} for general checks whether the
	 * factory knows about a bean with a given name (whether manually registed singleton
	 * instance or created by bean definition), also checking ancestor factories.
	 * 
	 * @param beanName the name of the bean to look for
	 * @return {@code ture} if this bean factory contains a singleton instance with
	 * the given name else {@code false}
	 */
	public function containsSingleton(beanName:String):Boolean;
	
	/**
	 * Destroys all cached singletons in this factory. To be called on shutdown of
	 * a factory.
	 * 
	 * <p>Should never throw an exception but rather log shutdown failures.
	 */
	public function destroySingletons(Void):Void;
	
	/**
	 * Returns the registered bean definition for the given bean, allowing access
	 * to its property values and constructor argument values (which can be
	 * modified during bean factory post-processing).
	 * 
	 * <p>A returned bean definition object should not be a copy but the original
	 * definition object as registered in the factory. This means that it should
	 * be castable to a more specific implementation type, if necessary.
	 * 
	 * @param beanName the name of the bean
	 * @return the registered bean definition
	 * @throws NoSuchBeanDefinitionException if there is no bean with the given name
	 */
	public function getBeanDefinition(beanName:String, includingAncestors:Boolean):BeanDefinition;
	
	/**
	 * Pre-instantiates all non-lazy-init singletons, also considering {@code FactoryBean}
	 * instances. Typically invoked at the end of factory setup, if desired.
	 * 
	 * <p>Note that if an exception is thrown, this may have left the factory with some
	 * beans already initialized! Call {@link #destroySingletons} for full clean-up in
	 * this case.
	 * 
	 * @throws BeanException if one of the singleton beans could not be created
	 */
	public function preInstantiateSingletons(Void):Void;
	
}