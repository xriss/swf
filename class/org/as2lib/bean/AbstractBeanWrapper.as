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

import org.as2lib.core.BasicClass;

/**
 * {@code AbstractBeanWrapper} declares constants needed by {@link BeanWrapper}
 * implementations.
 * 
 * @author Simon Wacker
 */
class org.as2lib.bean.AbstractBeanWrapper extends BasicClass {
	
	/** Separator for nested properties. */
	public static var NESTED_PROPERTY_SEPARATOR:String = ".";
	
	/** Prefix to separate properties from keys. */
	public static var PROPERTY_KEY_PREFIX:String = "[";
	
	/** Suffix of a property keys. */
	public static var PROPERTY_KEY_SUFFIX:String = "]";
	
	/** Prefixes for property getter methods. */
	public static var GET_PROPERTY_PREFIXES:Array = ["get", "is", "__get__"];
	
	/** Prefixes for property setter methods. */
	public static var SET_PROPERTY_PREFIXES:Array = ["set", "add", "put", "init", "initWith", "__set__"];
	
	/** Placeholder to indicate that value shall be converted to a package. */
	public static var PACKAGE_TYPE:Function = new Function(); // 'function() {}' is not Flash compatible
	
	/*public static var METHOD_PREFIX:String = "&";
	public static var VARIABLE_PREFIX:String = "$";
	
	public static var ARRAY_PREFIX:String = "array:";
	public static var MAP_PREFIX:String = "map:";
	public static var LIST_PREFIX:String = "list:";
	public static var QUEUE_PREFIX:String = "queue:";
	public static var STACK_PREFIX:String = "stack:";
	public static var PROPERTIES_PREFIX:String = "properties:";
	
	public static var NUMBER_PREFIX:String = "number:";
	public static var STRING_PREFIX:String = "string:";
	public static var BOOLEAN_PREFIX:String = "boolean:";
	
	public static var CLASS_PREFIX:String = "class:";
	public static var FILE_PREFIX:String = "file:";
	public static var LOCALE_PREFIX:String = "locale:";
	public static var URL_PREFIX:String = "url:";
	public static var DATE_PREFIX:String = "date:";*/
	
	private function AbstractBeanWrapper(Void) {
	}
	
}