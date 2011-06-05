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

import org.as2lib.bean.factory.support.BeanDefinitionRegistry;
import org.as2lib.core.BasicInterface;

/**
 * {@code BeanDefinitionParser} parses bean definitions encoded in different formats,
 * like XML, Properties Files, etc.
 * 
 * @author Simon Wacker
 */
interface org.as2lib.bean.factory.parser.BeanDefinitionParser extends BasicInterface {
	
	/**
	 * Parses the given bean definition(s) and adds the bean definition(s) to the given
	 * bean definition registry.
	 * 
	 * @param beanDefinition the bean definition(s) to parse
	 * @param registry the registry to add the parsed bean definition(s) to
	 */
	public function parse(beanDefinitions:String, registry:BeanDefinitionRegistry):Void;
	
}