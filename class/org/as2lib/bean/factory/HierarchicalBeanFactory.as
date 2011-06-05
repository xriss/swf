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

/**
 * {@code HierarchicalBeanFactory} is implemented by bean factories that can be
 * part of a hierarchy.
 * 
 * @author Simon Wacker
 */
interface org.as2lib.bean.factory.HierarchicalBeanFactory extends BeanFactory {
	
	/**
	 * Returns the parent bean factory or {@code null} if there is none.
	 * 
	 * @return the parent bean factory
	 */
	public function getParentBeanFactory(Void):BeanFactory;
	
	/**
	 * Returns whether the local bean factory contains a bean of the given name,
	 * ignoring beans defined in ancestor contexts.
	 * 
	 * @param name the name of the bean to query
	 * @return whether a bean with the given name is defined in the local factory
	 */
	public function containsLocalBean(name:String):Boolean;
	
}