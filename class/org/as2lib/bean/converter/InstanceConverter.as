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

import org.as2lib.bean.BeanUtil;
import org.as2lib.bean.PropertyValueConverter;
import org.as2lib.core.BasicClass;
import org.as2lib.env.except.IllegalArgumentException;
import org.as2lib.util.ClassUtil;

/**
 * {@code InstanceConverter} converts string values to instances.
 * 
 * @author Simon Wacker
 */
class org.as2lib.bean.converter.InstanceConverter extends BasicClass implements PropertyValueConverter {
	
	/** The default separator of the constructor arguments value. */
	public static var DEFAULT_SEPARATOR:String = ",";
	
	/** Separator to split the string value. */
	private var separator:String;
	
	/** Class to instantiate. */
	private var clazz:Function;
	
	/**
	 * Constructs a new {@code InstanceConverter} instance.
	 */
	public function InstanceConverter(separator:String) {
		if (separator == null) {
			separator = DEFAULT_SEPARATOR;
		}
		this.separator = separator;
	}
	
	/**
	 * Returns the class to instantiate.
	 */
	public function getClass(Void):Function {
		return clazz;
	}
	
	/**
	 * Sets the class to instantiate.
	 */
	public function setClass(clazz:Function):Void {
		this.clazz = clazz;
	}
	
	/**
	 * Converts the given {@code value} to an instance.
	 * 
	 * <p>If you set a class manually via {@link #setClass}, this class will be
	 * instantiated and its constructor will be passed the arguments extracted from
	 * the given {@code value}. Otherwise the supplied {@code type} will be instantiated
	 * and its constructor passed the arguments.
	 * 
	 * <p>{@code value} must be a (comma) delimited list of arguments to pass to the
	 * constructor.
	 * 
	 * @param value the value to convert to an instance
	 * @param type the type to instantiate, if {@code null} or {@code undefined} the
	 * set class will be used
	 * @return the instance representation of the {@code value}
	 * @throws IllegalArgumentException if neither {@code class} nor {@code type} is
	 * specified
	 */
	public function convertPropertyValue(value:String, type:Function) {
		if (clazz == null && type == null) {
			throw new IllegalArgumentException("Either 'class' or 'type' must be specified.", this, arguments);
		}
		if (clazz != null) {
			type = clazz;
		}
		var args:Array = value.split(separator);
		BeanUtil.trimAndConvertValues(args);
		return ClassUtil.createInstance(type, args);
	}
	
}