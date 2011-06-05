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

import org.as2lib.bean.factory.HierarchicalBeanFactory;
import org.as2lib.data.holder.Map;

/**
 * {@code ListableBeanFactory} is an extension of the {@code HierarchicalBeanFactory}
 * interface to be implemented by bean factories that can enumerate all their bean
 * instances, rather than attempting bean lookup by name one by one as requested by
 * clients. Bean factories that preload all their beans (for example, DOM-based XML
 * factories) may implement this interface.
 * 
 * <p>The methods in this interface will just respect bean definitions. They will
 * ignore any singleton beans that have been registered by other means like through
 * the {@link ConfigurableListableBeanFactory#registerSingleton} method, with the exception
 * of {@link #getBeansOfType} which will match such manually registered singletons too.
 * Of course, {@code BeanFactory}'s methods do allow access to such special beans too.
 * In typical scenarios, all beans will be defined by bean definitions anyway.
 * 
 * <p>With the exception of {@link #getBeanDefinitionCoun}t and {@link #containsBeanDefinition},
 * the methods in this interface are not designed for frequent invocation. Implementations
 * may be slow.
 * 
 * @author Simon Wacker
 */
interface org.as2lib.bean.factory.ListableBeanFactory extends HierarchicalBeanFactory {
	
	/**
	 * Checks if this bean factory contains a bean definition with the given name.
	 * 
	 * <p>Note: Ignores any singleton beans that have been registered by other means
	 * than bean definitions.
	 * 
	 * @param beanName the name of the bean to look for
	 * @param includeAncestors whether to ask the parent bean factory if not found in
	 * this instance; by default {@code false}
	 * @return {@code true} if this bean factory contains a bean definition with the
	 * given name else {@code false}
	 */
	public function containsBeanDefinition(beanName:String, includingAncestors:Boolean):Boolean;
	
	/**
	 * Returns the number of beans defined in this factory.
	 * 
	 * <p>Note: Ignores any singleton beans that have been registered by other means
	 * than bean definitions.
	 * 
	 * @param includingAncestors whether to include bean definitions of the parent
	 * factory; by default {@code false}
	 * @return the number of beans defined in this factory
	 */
	public function getBeanDefinitionCount(includingAncestors:Boolean):Number;
	
	/**
	 * Returns the names ({@code String} values) of all beans defined in this factory.
	 * 
	 * <p>Note: Ignores any singleton beans that have been registered by other means
	 * than bean definitions.
	 * 
	 * @param includingAncestors whether to ask the parent factory for further bean
	 * definition names; by default {@code false}
	 * @return the names of all beans defined in this factory, or an empty array if
	 * none defined
	 */
	public function getBeanDefinitionNames(includingAncestors:Boolean):Array;
	
	/**
	 * Returns the names of all beans in this factory.
	 * 
	 * <p>Note: Does not ignore singleton beans that have been registered by other means
	 * than bean definitions.
	 * 
	 * @param includingAncestors whether to ask the parent factory for further bean
	 * names; by default {@code false}
	 * @return the names of all beans in this factory, or an empty array if none
	 */
	public function getBeanNames(includingAncestors:Boolean):Array;
	
	/**
	 * Returns the names of beans matching the given type (including subclasses),
	 * judging from either bean definitions or the value of {@code getObjectType} in the
	 * case of factory beans.
	 * 
	 * <p>Does consider objects created by factory beans if the {@code includeFactoryBeans}
	 * flag is set, which means that factory beans will get initialized. If the object
	 * created by the factory bean does not match, the raw factory bean itself will be
	 * matched against the type. If {@code includeFactoryBeans} is not set, only raw
	 * factory beans will be checked (which doesn't require initialization of each factory
	 * bean).
	 * 
	 * <p>Note: Does not ignore singleton beans that have been registered by other means
	 * than bean definitions.
	 * 
	 * @param type the class or interface to match, or {@code null} for all bean names
	 * @param includePrototypes whether to include prototype beans too or just singletons
	 * (also applies to factory beans); by default {@code true}
	 * @param includeFactoryBeans whether to include objects created by factory beans (or
	 * by factory methods with a "factory-bean" reference) too, or just conventional beans;
	 * note that factory beans need to be initialized to determine their type: so be aware
	 * that passing in {@code true} for this flag will initialize factory beans (and
	 * "factory-bean" references); by default {@code true}
	 * @param includingAncestors whether to ask the parent factory for further beans; by
	 * default {@code false}
	 * @return the names of beans (or objects created by factory beans) matching the given
	 * object type (including subclasses), or an empty array if none
	 * @see FactoryBean
	 */
	public function getBeanNamesForType(type:Function, includePrototypes:Boolean, includeFactoryBeans:Boolean, includingAncestors:Boolean):Array;
	
	/**
	 * Returns the bean instances that match the given object type (including subclasses),
	 * judging from either bean definitions or the value of {@code getObjectType} in the
	 * case of factory beans.
	 * 
	 * <p>Does consider objects created by factory beans if the {@code includeFactoryBeans}
	 * flag is set, which means that factory beans will get initialized. If the object
	 * created by the factory bean does not match, the raw factory bean itself will be
	 * matched against the type. If {@code includeFactoryBeans} is not set, only raw
	 * factory beans will be checked (which doesn't require initialization of each factory
	 * bean).
	 * 
	 * <p>Note: Does not ignore singleton beans that have been registered by other means
	 * than bean definitions.
	 * 
	 * @param type the class or interface to match, or {@code null} for all concrete beans
	 * @param includePrototypes whether to include prototype beans too or just singletons
	 * (also applies to factory beans); by default {@code true}
	 * @param includeFactoryBeans whether to include objects created by factory beans (or
	 * by factory methods with a "factory-bean" reference) too, or just conventional beans;
	 * note that factory beans need to be initialized to determine their type: so be aware
	 * that passing in {@code true} for this flag will initialize factory beans (and
	 * "factory-bean" references); by default {@code true}
	 * @param includingAncestors whether to ask the parent factory for further beans; by
	 * default {@code false}
	 * @return a map with the matching beans, containing the bean names as keys and the
	 * corresponding bean instances as values
	 * @throws BeanException if a bean could not be created
	 * @see FactoryBean
	 */
	public function getBeansOfType(type:Function, includePrototypes:Boolean, includeFactoryBeans:Boolean, includingAncestors:Boolean):Map;
	
}