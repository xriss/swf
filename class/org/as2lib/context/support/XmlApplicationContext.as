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

import org.as2lib.bean.factory.parser.XmlBeanDefinitionParser;
import org.as2lib.context.ApplicationContext;
import org.as2lib.context.support.LoadingApplicationContext;

/**
 * {@code XmlApplicationContext} loads a xml bean definition file from a given uri
 * and parses it with the {@link XmlBeanDefinitionParser}.
 * 
 * @author Simon Wacker
 */
class org.as2lib.context.support.XmlApplicationContext extends LoadingApplicationContext {
	
	/**
	 * Constructs a new {@code XmlApplicationContext} instance.
	 * 
	 * @param xmlBeanDefinitionUri the uri to the xml bean definition file
	 * @param parent the parent of this application context
	 */
	public function XmlApplicationContext(xmlBeanDefinitionUri:String, parent:ApplicationContext) {
		super(xmlBeanDefinitionUri, new XmlBeanDefinitionParser(), parent);
	}
	
}