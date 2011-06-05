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
 * {@code StyleSheetParser} parses different kinds of style sheets to format bean
 * definitions with.
 * 
 * @author Simon Wacker
 */
interface org.as2lib.bean.factory.parser.StyleSheetParser extends BasicInterface {
	
	/**
	 * Parses the given style sheet and formats the bean definitions registered at the
	 * given factory with the parsed styles.
	 * 
	 * @param styleSheet the style sheet to parse
	 * @param factory the factory containing the bean definitions to format
	 */
	public function parse(styleSheet:String, factory:ConfigurableListableBeanFactory):Void;
	
}