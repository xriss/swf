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
 * {@code PropertyValue} holds information and value for an indivudual property.
 * 
 * <p>Note that the value does not need to be the final required type: A bean wrapper
 * should handle any necessary conversion.
 * 
 * @author Simon Wacker
 */
class org.as2lib.bean.PropertyValue extends BasicClass {
	
	private var name:String;
	private var value;
	private var type:Function;
	private var enforceAccess:Boolean;
	
	/**
	 * Constructs a new {@code PropertyValue} instance.
	 * 
	 * @param name the name of the property
	 * @param value the value to set for the property
	 * @param type the type to convert the value to
	 * @param enforceAccess determines whether property access shall be enforced
	 */
	public function PropertyValue(name:String, value, type:Function, enforceAccess:Boolean) {
		this.name = name;
		this.value = value;
		this.type = type;
		this.enforceAccess = enforceAccess ? true : false;
	}
	
	/**
	 * Returns the name of the property.
	 * 
	 * @return the name of the property
	 */
	public function getName(Void):String {
		return name;
	}
	
	/**
	 * Returns the value to set for the property.
	 * 
	 * @return the value to set for the property
	 */
	public function getValue(Void) {
		return value;
	}
	
	/**
	 * Sets the value to set for the property.
	 * 
	 * @param value the value to set for the property
	 */
	public function setValue(value):Void {
		this.value = value;
	}
	
	/**
	 * Returns the type to convert the value to.
	 * 
	 * @return the type to convert the value to
	 */
	public function getType(Void):Function {
		return type;
	}
	
	/**
	 * Returns whether access to this property shall be enforced.
	 * 
	 * <p>If access shall be enforced, this property will be set via field injection
	 * if a setter method could not be found.
	 * 
	 * <p>If access shall not be enforced, this property will only be set via field
	 * injection if a setter method could not be found and the field is pre-initialized,
	 * for example with {@code null}.
	 * 
	 * @return {@code true} if access shall be enforced else {@code false}; by default
	 * {@code false}
	 */
	public function isEnforceAccess(Void):Boolean {
		return enforceAccess;
	}
	
	/**
	 * Returns the string representation of this property value.
	 * 
	 * @return the string representation of this property value
	 */
	public function toString():String {
		return (name + "=" + value);
	}
	
}