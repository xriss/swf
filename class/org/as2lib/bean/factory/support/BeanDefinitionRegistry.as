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

import org.as2lib.bean.factory.config.BeanDefinition;
import org.as2lib.core.BasicInterface;

/**
 * {@code BeanDefinitionRegistry} is the interface for registries that hold bean
 * definitions, for example {@link RootBeanDefinition} and {@link ChildBeanDefinition}
 * instances. Typically implemented by bean factories that internally work with the
 * {@link AbstractBeanDefinition} hierarchy.
 * 
 * <p>This is the only interface in the bean factory packages that encapsulates
 * registration of bean definitions. The standard bean factory interfaces only cover
 * access to a fully configured factory instance.
 * 
 * @author Simon Wacker
 */
interface org.as2lib.bean.factory.support.BeanDefinitionRegistry extends BasicInterface {
	
	/**
	 * Checks if this registry contains a bean definition with the given name.
	 * 
	 * @param beanName the name of the bean definition to look for
	 * @param includingAncestors whether to include ancestors for the check
	 * @return {@code true} if this registry contains a bean definition with the given
	 * name else {@code false}
	 */
	public function containsBeanDefinition(beanName:String, includingAncestors:Boolean):Boolean;
	
	/**
	 * Returns the bean definition for the given bean name.
	 * 
	 * @param beanName the bean name to return the bean definition for
	 * @param includingAncestors whether to look in the parent if there is no bean with
	 * the given name in this registry
	 * @throws NoSuchBeanDefinitionException if there is no such bean definition
	 */
	public function getBeanDefinition(beanName:String, includingAncestors:Boolean):BeanDefinition;
	
	/**
	 * Returns the number of bean defined in this registry.
	 * 
	 * @param includingAncestors whether to include the beans defined in ancestors
	 * @return the number of beans defined in this registry
	 */
	public function getBeanDefinitionCount(includingAncestors:Boolean):Number;
	
	/**
	 * Returns the names of all beans defined in this registry.
	 * 
	 * @param includingAncestors whether to return the names of the bean definitions
	 * in the parent registry too
	 * @return the names of all defined beans
	 */
	public function getBeanDefinitionNames(includingAncestors:Boolean):Array;
	
	/**
	 * Returns the aliases for the given bean name, if defined.
	 * 
	 * <p>Will ask the parent factory if the bean cannot be found in this factory
	 * instance.
	 * 
	 * @param beanName the name of the bean to return aliases for
	 * @return the aliases for the given bean
	 * @throws NoSuchBeanDefinitionException if there is no such bean definition
	 */
	public function getAliases(beanName:String):Array;
	
	/**
	 * Creates an alias for the given bean name.
	 * 
	 * @param beanName the name of the bean to create an alias for
	 * @param alias the alias for the bean name
	 * @throws NoSuchBeanDefinitionException if there is no bean definition with the
	 * given name
	 * @throws BeanException if the alias is already in use
	 */
	public function registerAlias(beanName:String, alias:String):Void;
	
	/**
	 * Registers a new bean definition with this registry.
	 * 
	 * @param beanName the name of the bean to register
	 * @param beanDefinition the definition of the bean to register
	 * @throws BeanException if the bean definition is invalid
	 */
	public function registerBeanDefinition(beanName:String, beanDefinition:BeanDefinition):Void;	
	
}