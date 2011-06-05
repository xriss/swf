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

import org.as2lib.core.BasicInterface;
import org.as2lib.bean.factory.BeanFactory;

/**
 * {@code BeanFactoryAware} can be implemented by beans that wish to be aware of
 * their owning bean factory. Beans can for example look-up collaborating beans
 * via the factory.
 * 
 * <p>Note that most beans will choose to receive references to collaborating
 * beans via respective bean properties.
 * 
 * <p>For a list of all bean lifecycle methods, see the {@link BeanFactory}
 * documentation.
 * 
 * @author Simon Wacker
 */
interface org.as2lib.bean.factory.BeanFactoryAware extends BasicInterface {
	
	/**
	 * Supplies the owning factory to bean instances.
	 * 
	 * <p>Invoked after population of normal bean properties but before an init callback
	 * like {@link InitializingBean#afterPropertiesSet} or a custom init-method.
	 * 
	 * @param beanFactory the owning bean factory (may not be null); the bean can
	 * immediately call methods on the factory
	 * @throws BeanException in case of initialization errors
	 */
	public function setBeanFactory(beanFactory:BeanFactory):Void;
	
}