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

import org.as2lib.bean.factory.parser.ActionStepBeanDefinitionParser;
import org.as2lib.context.ApplicationContext;
import org.as2lib.context.support.LoadingApplicationContext;

/**
 * {@code ActionStepApplicationContext} loads a xml actionstep bean definition file from
 * a given uri and parses it with the {@link ActionStepBeanDefinitionParser}.
 * 
 * @author Simon Wacker
 */
class org.as2lib.context.support.ActionStepApplicationContext extends LoadingApplicationContext {
	
	/**
	 * Constructs a new {@code ActionStepApplicationContext} instance.
	 * 
	 * @param xmlActionStepBeanDefinitionUri the uri to the xml actionstep bean definition
	 * file
	 * @param parent the parent of this application context
	 */
	public function ActionStepApplicationContext(xmlActionStepBeanDefinitionUri:String, parent:ApplicationContext) {
		super(xmlActionStepBeanDefinitionUri, new ActionStepBeanDefinitionParser(), parent);
	}
	
}