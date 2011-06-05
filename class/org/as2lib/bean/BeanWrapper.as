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

import org.as2lib.bean.PropertyValue;
import org.as2lib.bean.PropertyValueConverter;
import org.as2lib.bean.PropertyValues;
import org.as2lib.core.BasicInterface;

/**
 * {@code BeanWrapper} prvides functionalities to set or get properties on or to beans
 * respectively. You may also nest properties, enabling the setting of properties on
 * sub-properties to an unlimited depth.
 * 
 * @author Simon Wacker
 */
interface org.as2lib.bean.BeanWrapper extends BasicInterface {
	
	/**
	 * Returns whether the property with the given name is writable. A property is
	 * writable if a set-access method exists.
	 * 
	 * @param propertyName the name of the property to check whether it is writable
	 * @return {@code true} if the property is writable else {@code false}
	 */
	public function isWritableProperty(propertyName:String):Boolean;
	
	/**
	 * Returns whether the property with the given name is readable. A property is
	 * writable if a get-access method exists.
	 * 
	 * @param propertyName the name of the property to check whether it is readable
	 * @return {@code true} if the property is readable else {@code false}
	 */
	public function isReadableProperty(propertyName:String):Boolean;
	
	/**
	 * Gets the value of the property.
	 * 
	 * @param propertyName the name of the property to get the value for
	 * @return the value of the property
	 * @throws FatalBeanException if there is no such property, if the property isn't readable,
	 * or if the property getter throws an exception
	 */
	public function getPropertyValue(propertyName:String);
	
	/**
	 * Sets the property value.
	 * 
	 * @param propertyValue the object containing the name of the property, its name
	 * and the new value to set
	 * @throws FatalBeanException if there is no such property, if the property isn't writable,
	 * or if the property setter throws an exception
	 */
	public function setPropertyValue(propertyValue:PropertyValue):Void;
	
	/**
	 * Sets all given property values.
	 * 
	 * <p>Note that performing a bulk update differs from performing a single update,
	 * in that an implementation of this class will continue to update properties if a
	 * recoverable error (such as a type mismatch, but not an invalid property name or
	 * the like) is encountered, throwing a {@code PropertyAccessExceptionsException}
	 * containing all the individual errors. This exception can be examined later to
	 * see all binding errors. Properties that were successfully updated stay changed.
	 * 
	 * @param propertyValues the property values to set
	 * @param ignoreUnknown shall unknown values be ignored (not found in the bean)
	 */
	public function setPropertyValues(propertyValues:PropertyValues, ignoreUnknown:Boolean):Void;
	
	/**
	 * Finds a property value converter for the given type and property path.
	 * 
	 * @param requiredType the type of the property
	 * @param propertyPath the path of the property (name or nested path), or {@code null}
	 * if looking for an editor for all properties of the given type
	 * @return the registered converter or {@code null} if none
	 */
	public function findPropertyValueConverter(requiredType:Function, propertyPath:String):PropertyValueConverter;
	
	/**
	 * @overload #registerPropertyValueConverterForType
	 * @overload #registerPropertyValueConverterForProperty
	 */
	public function registerPropertyValueConverter():Void;
	
	/**
	 * Registers the given value converter for all properties of the given type.
	 * 
	 * @param requiredType the type to register the converter for
	 * @param propertyValueConverter the converter to register
	 */
	public function registerPropertyValueConverterForType(requiredType:Function, propertyValueConverter:PropertyValueConverter):Void;
	
	/**
	 * Registers the given property value converter for the given type and property,
	 * or for all properties of the given type.
	 * 
	 * @param requiredType the type of the property (can be {@code null} if a property
	 * is given)
	 * @param propertyPath path of the property (name or nested path), or {@code null}
	 * if registering an editor for all properties of the given type
	 * @param propertyValueConverter the converter to register
	 */
	public function registerPropertyValueConverterForProperty(requiredType:Function, propertyPath:String, propertyValueConverter:PropertyValueConverter):Void;
	
	/**
	 * Returns the bean wrapped by this wrapper.
	 * 
	 * @return the wrapped bean
	 */
	public function getWrappedBean(Void);
	
	/**
	 * Sets the bean to wrap.
	 * 
	 * <p>Note that all bean specific information will be reset.
	 * 
	 * @param wrappedBean the bean to wrap
	 */
	public function setWrappedBean(wrappedBean):Void;
	
}