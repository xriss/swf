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

import org.as2lib.bean.factory.config.BeanFactoryPostProcessor;
import org.as2lib.bean.factory.config.BeanPostProcessor;
import org.as2lib.bean.factory.config.ConfigurableListableBeanFactory;
import org.as2lib.context.ApplicationContext;

/**
 * {@code ConfigurableApplicationContext} provides means to configure an application
 * context in addition to the application context client methods in the {@code ApplicationContext}
 * interface.
 * 
 * <p>Configuration and lifecycle methods are encapsulated here to avoid making them
 * obvious to application context client code.
 * 
 * @author Simon Wacker
 */
interface org.as2lib.context.ConfigurableApplicationContext extends ApplicationContext {
	
	/**
	 * Sets the parent of this application context.
	 * 
	 * @param parent the parent context
	 */
	public function setParent(parent:ApplicationContext):Void;
	
	/**
	 * Adds a new bean factory post processor that will be applied to the internal bean
	 * factory of this application context on refresh, before any of the bean definitions
	 * get evaluated. This method shall be invoked during context configuration.
	 * 
	 * @param beanFactoryPostProcessor the factory post-processor to register
	 */
	public function addBeanFactoryPostProcessor(beanFactoryPostProcessor:BeanFactoryPostProcessor):Void;
	
	/**
	 * Adds a new bean post processor that will be added to the internal bean factory
	 * of this application context on refresh, before any of the bean definitions get
	 * evaluated. This method shall be invoked during context configuration.
	 * 
	 * @param beanPostProcessor the bean post-processor to register
	 */
	public function addBeanPostProcessor(beanPostProcessor:BeanPostProcessor):Void;
	
	/**
	 * Loads or refreshes the persistent representation of the configuration, which might
	 * be an XML file, properties file, or relational database schema.
	 * 
	 * <p>As this is a startup method, it should destroy already created singletons if
	 * it fails, to avoid dangling resources. In other words, after invocation of that
	 * method, either all or no singletons at all should be instantiated.
	 * 
	 * @throws BeanException if the bean factory could not be initialized
	 * @throws IllegalStateException if already initialized and multiple refresh
	 * attempts are not supported
	 */
	public function refresh(Void):Void;
	
	/**
	 * Returns the internal bean factory of this application context. The returned
	 * factory can be used to access specific functionality of the factory.
	 * 
	 * <p>Note that you should not use this to post-process the bean factory; singletons
	 * will already have been instantiated before. Use a {@link BeanFactoryPostProcessor}
	 * to intercept the bean factory setup process before beans get touched.
	 * 
	 * @throws IllegalStateException if the context does not hold an internal bean factory
	 * yet (usually if {@code refresh} has never been called)
	 * @see #refresh
	 * @see #addBeanFactoryPostProcessor
	 */
	public function getBeanFactory(Void):ConfigurableListableBeanFactory;
	
	/**
	 * Closes this application context, releasing all resources and locks that the
	 * implementation might hold. This includes destroying all cached singleton beans.
	 * 
	 * <p>Note that this method does <i>not</i> invoke {@code close} on a parent context;
	 * parent contexts have their own, independent life-cycle.
	 */
	public function close(Void):Void;
	
}