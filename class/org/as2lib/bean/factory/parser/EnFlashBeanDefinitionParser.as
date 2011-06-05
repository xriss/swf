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

import org.as2lib.bean.factory.parser.UiBeanDefinitionParser;
import org.as2lib.bean.factory.support.BeanDefinitionRegistry;
import org.as2lib.util.TextUtil;
import org.as2lib.util.TrimUtil;
import org.aswing.geom.Dimension;
import org.aswing.geom.Point;

/**
 * {@code EnFlashBeanDefinitionParser} is a user interface bean definition parser
 * for enFlash.
 * 
 * @author Simon Wacker
 */
class org.as2lib.bean.factory.parser.EnFlashBeanDefinitionParser extends UiBeanDefinitionParser {
	
	public static var DEFAULT_PROPERTY:String = "item";
	
	public static var EVENT_LISTENER_PREFIX:String = "on";
	
	/**
	 * Constructs a new {@code XmlBeanDefinitionParser} instance.
	 * 
	 * @param registry the registry to use if none is passed-to the {@code parse}
	 * method
	 */
	public function EnFlashBeanDefinitionParser(registry:BeanDefinitionRegistry) {
		super(registry);
		setDefaultProperty(DEFAULT_PROPERTY);
		setDefaultPopulate(POPULATE_AFTER_VALUE);
	}
	
	private function getPopulateValue(Void):String {
		return POPULATE_BEFORE_VALUE;
	}
	
	private function parsePropertyName(propertyElement:XMLNode):String {
		var result:String = super.parsePropertyName(propertyElement);
		if (result.indexOf(EVENT_LISTENER_PREFIX) == 0) {
			if (propertyElement.attributes[ENFORCE_ACCESS_ATTRIBUTE] == null) {
				propertyElement.attributes[ENFORCE_ACCESS_ATTRIBUTE] = TRUE_VALUE;
			}
		}
		return result;
	}
	
}