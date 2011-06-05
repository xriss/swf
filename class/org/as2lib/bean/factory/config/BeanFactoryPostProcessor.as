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

import org.as2lib.bean.factory.config.ConfigurableListableBeanFactory;
import org.as2lib.core.BasicInterface;

/**
 * {@code BeanFactoryPostProcessor} allows for custom modification of an application
 * context's bean definitions, adapting the bean property values of the context's
 * underlying bean factory.
 * 
 * <p>Application contexts usually auto-detect bean-factory-post-processor beans in
 * their bean definitions and apply them before any other beans get created.
 * 
 * <p>Useful for custom config files targeted at system administrators that override
 * bean properties configured in the application context.
 * 
 * @author Simon Wacker
 */
interface org.as2lib.bean.factory.config.BeanFactoryPostProcessor extends BasicInterface {
	
	/**
	 * Modifies the application context's internal bean factory after its standard
	 * initialization. All bean definitions will have been loaded, but no beans will
	 * have been instantiated yet. This allows for overriding or adding properties
	 * even to eager-initializing beans.
	 * 
	 * @param beanFactory the bean factory used by the application context
	 * @throws BeanException in case of errors
	 */
	public function postProcessBeanFactory(beanFactory:ConfigurableListableBeanFactory):Void;
	
}