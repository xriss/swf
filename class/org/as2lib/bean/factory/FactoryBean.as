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
 * {@code FactoryBean} can be implemented by objects used within a bean factory
 * that are themselves factories. If a bean implements this interface, it is used
 * as a factory, not directly as a bean.
 * 
 * <p>Note: A bean that implements this interface cannot be used as a normal bean.
 * A factory bean is defined in a bean style, but the object exposed for bean
 * references is always the object that it creates.
 * 
 * <p>Factory beans can support singletons and prototypes, and can either create
 * objects lazily on demand or eagerly on startup.
 * 
 * @author Simon Wacker
 */
interface org.as2lib.bean.factory.FactoryBean extends BasicInterface {
	
	/**
	 * Returns an instance (possibly shared or independent) of the object managed by this
	 * factory. As with a bean factory, this allows support for both the singleton and
	 * prototype design patterns.
	 * 
	 * <p>If this method returns {@code null}, the factory will consider this factory bean
	 * as not fully initialized and throw a corresponding {@link FactoryBeanNotInitializedException}.
	 * 
	 * @param property the property to initialize with the returned object if it is a bean
	 * whose populate mode is set to 'populate afterwards'
	 * @return an instance of the bean
	 * @throws Error in case of creation errors
	 * @see BeanFactory#getBean
	 */
	public function getObject(property:PropertyAccess);
	
	/**
	 * Returns the type of the object that this factory bean creates, or {@code null}
	 * if no known in advance. This allows to check for specific types of beans without
	 * instantiating objects.
	 * 
	 * <p>For a singleton, this should try to avoid singleton creation as far as possible;
	 * it should rather estimate the type in advance. For prototypes, returning a meaningful
	 * type here is advisable too.
	 * 
	 * <p>This method can be called before this factory bean has been fully initialized.
	 * It must not rely on state created during initialization; of course, it can still
	 * use such state if available.
	 * 
	 * @return the type of object that this factory bean creates, or {@code null} if not
	 * known at the time of the call
	 */
	public function getObjectType(Void):Function;
	
	/**
	 * Is the bean managed by this factory a singleton or a prototype? That is, will
	 * {@link #getObject} always return the same object?
	 * 
	 * <p>The singleton status of this factory bean will generally be provided by the
	 * owning bean factory; usually, it has to be defined as singleton there.
	 * 
	 * @return {@code true} if this bean is a singleton else {@code false}
	 */
	public function isSingleton(Void):Boolean;
	
}