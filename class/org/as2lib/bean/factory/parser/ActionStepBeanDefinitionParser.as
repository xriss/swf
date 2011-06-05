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

import org.actionstep.NSRect;
import org.as2lib.bean.factory.parser.UiBeanDefinitionParser;
import org.as2lib.bean.factory.support.BeanDefinitionRegistry;
import org.as2lib.bean.PropertyValues;
import org.as2lib.util.StringUtil;
import org.as2lib.util.TrimUtil;

/**
 * {@code ActionStepBeanDefinitionParser} is a user interface bean definition parser
 * for ActionStep.
 *
 * @author Simon Wacker
 */
class org.as2lib.bean.factory.parser.ActionStepBeanDefinitionParser extends UiBeanDefinitionParser {

	public static var DEFAULT_PROPERTY:String = "subview";

	public static var X_ATTRIBUTE:String = "x";

	public static var Y_ATTRIBUTE:String = "y";

	public static var WIDTH_ATTRIBUTE:String = "width";

	public static var HEIGHT_ATTRIBUTE:String = "height";

	public static var FRAME_PROPERTY_NAME:String = "withFrame";

	public static var RECTANGLE_CLASS_NAME:String = "org.actionstep.NSRect";

	/**
	 * Constructs a new {@code XmlBeanDefinitionParser} instance.
	 *
	 * @param registry the registry to use if none is passed-to in the {@code parse}
	 * method
	 */
	public function ActionStepBeanDefinitionParser(registry:BeanDefinitionRegistry) {
		super(registry);
		setDefaultProperty(DEFAULT_PROPERTY);
		var rectangleClass:Function = NSRect;
	}

	private function convertAttributeToPropertyElement(attribute:String, element:XMLNode):Void {
		if (attribute == X_ATTRIBUTE || attribute == Y_ATTRIBUTE ||
				attribute == WIDTH_ATTRIBUTE || attribute == HEIGHT_ATTRIBUTE) {
			// Why is this case still occurring although attributes x, y, width and height get deleted?
			if (element.attributes[attribute] != null) {
				var property:XMLNode = createPropertyElement(FRAME_PROPERTY_NAME);
				property.attributes[INDEX_ATTRIBUTE] = 0;
				var x:String = element.attributes[X_ATTRIBUTE];
				var y:String = element.attributes[Y_ATTRIBUTE];
				var width:String = element.attributes[WIDTH_ATTRIBUTE];
				var height:String = element.attributes[HEIGHT_ATTRIBUTE];
				var bean:XMLNode = createRectangleElement(x, y, width, height);
				delete element.attributes[X_ATTRIBUTE];
				delete element.attributes[Y_ATTRIBUTE];
				delete element.attributes[WIDTH_ATTRIBUTE];
				delete element.attributes[HEIGHT_ATTRIBUTE];
				property.appendChild(bean);
				element.appendChild(property);
			}
		}
		else {
			super.convertAttributeToPropertyElement(attribute, element);
		}
	}

	private function createRectangleElement(x:String, y:String, width:String, height:String):XMLNode {
		var result:XMLNode = new XMLNode(1, BEAN_ELEMENT);
		result.attributes[CLASS_ATTRIBUTE] = RECTANGLE_CLASS_NAME;
		appendConstructorArgumentElement(result, x);
		appendConstructorArgumentElement(result, y);
		appendConstructorArgumentElement(result, width);
		appendConstructorArgumentElement(result, height);
		return result;
	}

	private function appendConstructorArgumentElement(element:XMLNode, attribute:String):Void {
		if (attribute == null) {
			attribute = "0";
		}
		var argument:XMLNode = createConstructorArgumentElement(attribute);
		element.appendChild(argument);
	}

	private function createConstructorArgumentElement(value:String):XMLNode {
		var result:XMLNode = new XMLNode(1, CONSTRUCTOR_ARG_ELEMENT);
		result.appendChild(new XMLNode(3, value));
		return result;
	}

}