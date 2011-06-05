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

import org.as2lib.bean.Mergeable;
import org.as2lib.bean.PropertyValue;
import org.as2lib.core.BasicClass;
import org.as2lib.data.holder.Map;
import org.as2lib.env.overload.Overload;
import org.as2lib.util.ArrayUtil;

/**
 * {@code PropertyValues} holds 0 or more property values.
 *
 * @author Simon Wacker
 */
class org.as2lib.bean.PropertyValues extends BasicClass {

	/** Name used for properties without names. */
	public static var UNKNOWN_PROPERTY_NAME:String = "*";

	/** Added property values. */
	private var propertyValues:Array;

	/**
	 * Constructs a new {@code PropertyValues} instance.
	 *
	 * <p>If the given {@code source} is not {@code null} its property values will
	 * be duplicated and the duplicates will be copied to this new instance. Note
	 * that populating on construction is faster than populating via {@link #addPropertyValues}
	 * because it must not be checked whether values are mergeable. Note also that
	 * {@code addPropertyValues} does not duplicate property values.
	 *
	 * @param source the property values to populate this instance with
	 */
	public function PropertyValues(source:PropertyValues) {
		propertyValues = new Array();
		if (source != null) {
			var pvs:Array = source.getPropertyValues();
			for (var i:Number = 0; i < pvs.length; i++) {
				var pv:PropertyValue = pvs[i];
				var pn:String = getPropertyName(pv);
				if (propertyValues[pn] == null) {
					propertyValues[pn] = 1;
				}
				else {
					propertyValues[pn]++;
				}
				propertyValues.push(new PropertyValue(pn, pv.getValue(), pv.getType(), pv.isEnforceAccess()));
			}
		}
	}

	/**
	 * Returns the property name of the given property value. If the given property
	 * value's name is {@code null} or {@code undefined}, {@link #UNKNOWN_PROPERTY_NAME}
	 * will be returned.
	 */
	private function getPropertyName(propertyValue:PropertyValue):String {
		var propertyName:String = propertyValue.getName();
		if (propertyName != null) {
			return propertyName;
		}
		return UNKNOWN_PROPERTY_NAME;
	}

	/**
	 * Populates this instance with the given property values; they are not duplicated.
	 *
	 * <p>If there are multiple property values with the same property name in this
	 * instance or the given property values, overriding and merging will be disabled
	 * for these specific property values.
	 *
	 * <p>If a property value exists only once in this instance and/or in the given
	 * property values, overriding and merging will be enabled.
	 *
	 * @param propertyValues the property values to populate this instance with
	 * @see #addPropertyValueByPropertyValue
	 */
	public function addPropertyValues(propertyValues:PropertyValues):Void {
		var pvs:Array = propertyValues.getPropertyValues();
		for (var i:Number = 0; i < pvs.length; i++) {
			var pv:PropertyValue = pvs[i];
			var pn:String = getPropertyName(pv);
			if (propertyValues.getPropertyCount(pn) > 1 || getPropertyCount(pn) > 1) {
				addPropertyValueByPropertyValue(pv, false);
			}
			else {
				addPropertyValueByPropertyValue(pv, true);
			}
		}
	}

	/**
	 * @overload #addPropertyValueByPropertyValue
	 * @overload #addPropertyValueByIndexAndPropertyValue
	 */
	public function addPropertyValue():Void {
		var o:Overload = new Overload(this);
		o.addHandler([PropertyValue], addPropertyValueByPropertyValue);
		o.addHandler([PropertyValue, Boolean], addPropertyValueByPropertyValue);
		o.addHandler([Number, PropertyValue], addPropertyValueByIndexAndPropertyValue);
		o.addHandler([Number, PropertyValues, Boolean], addPropertyValueByIndexAndPropertyValue);
		o.forward(arguments);
	}

	/**
	 * Adds the given {@code propertyValue}.
	 *
	 * <p>If {@code mergeOrOverride} is {@code true}, the given property value will
	 * either be merged with the first property value with the same name if it implements
	 * the {@link Mergeable} interface or override it if not.
	 *
	 * <p>If {@code mergeOrOverride} is {@code false}, the given property value will
	 * just be added.
	 *
	 * @param propertyValue the property value to add
	 * @param mergeOrOverride enables or disables merging or overriding; default is
	 * {@code false}
	 */
	public function addPropertyValueByPropertyValue(propertyValue:PropertyValue, mergeOrOverride:Boolean):Void {
		addPropertyValueByIndexAndPropertyValue(null, propertyValue, mergeOrOverride);
	}

	/**
	 * Adds the given {@code propertyValue} at the given index.
	 *
	 * <p>If the given index is negative or {@code null} the property value will be
	 * added at the last position. Otherwise it will be added at the given position
	 * and the property values directly on the index and right of the index will be
	 * moved by one position to the right.
	 *
	 * <p>Note that the index will be ignored if the property value is merged with or
	 * overrides another property value.
	 *
	 * <p>If {@code mergeOrOverride} is {@code true}, the given property value will
	 * either be merged with the first property value with the same name if it implements
	 * the {@link Mergeable} interface or override it if not.
	 *
	 * <p>If {@code mergeOrOverride} is {@code false}, the given property value will
	 * just be added.
	 *
	 * @param propertyValue the property value to add
	 * @param mergeOrOverride enables or disables merging or overriding; default is
	 * {@code false}
	 */
	public function addPropertyValueByIndexAndPropertyValue(index:Number, propertyValue:PropertyValue, mergeOrOverride:Boolean):Void {
		if (mergeOrOverride == null) {
			mergeOrOverride = false;
		}
		var propertyName:String = getPropertyName(propertyValue);
		if (propertyValues[propertyName] != null) {
			if (mergeOrOverride) {
				for (var i:Number = 0; i < propertyValues.length; i++) {
					var currentPropertyValue:PropertyValue = propertyValues[i];
					if (getPropertyName(currentPropertyValue) == propertyName) {
						propertyValue = mergeIfRequired(propertyValue, currentPropertyValue);
						propertyValues[i] = propertyValue;
						return;
					}
				}
			}
		}
		else {
			propertyValues[propertyName] = 0;
		}
		propertyValues[propertyName]++;
		if (index == null || index < 0) {
			propertyValues.push(propertyValue);
		}
		else {
			propertyValues.splice(index, 0, propertyValue);
		}
	}

	/**
	 * Merges the value of the supplied {@code newPropertyValue} with that of the
	 * {@code currentPropertyValue} if merging is supported and enabled.
	 *
	 * @param newPropertyValue the new property value to merge if required
	 * @param currentPropertyValue the current property value
	 * @return the merged property value or the given {@code newPropertyValue} if
	 * merging was not required
	 * @see Mergeable
	 */
	private function mergeIfRequired(newPropertyValue:PropertyValue, currentPropertyValue:PropertyValue):PropertyValue {
		var value = newPropertyValue.getValue();
		if (value instanceof Mergeable) {
			var mergeable:Mergeable = value;
			if (mergeable.isMergeEnabled()) {
				var merged = mergeable.merge(currentPropertyValue.getValue());
				return new PropertyValue(newPropertyValue.getName(), merged,
						newPropertyValue.getType(), newPropertyValue.isEnforceAccess());
			}
		}
		return newPropertyValue;
	}

	/**
	 * @overload #removePropertyValueByPropertyValue
	 * @overload #removePropertyValueByName
	 */
	public function removePropertyValue():Void {
		var o:Overload = new Overload(this);
		o.addHandler([PropertyValue], removePropertyValueByPropertyValue);
		o.addHandler([String], removePropertyValueByName);
		o.forward(arguments);
	}

	/**
	 * Removes the given property value. The given property value must be an instance
	 * added to this list.
	 *
	 * @param propertyValue the property value to remove
	 */
	public function removePropertyValueByPropertyValue(propertyValue:PropertyValue):Void {
		ArrayUtil.removeElement(propertyValues, propertyValue);
	}

	/**
	 * Removes the first occurrence of a property value with the given name.
	 *
	 * <p>If the given property name is {@code null},
	 * {@link #UNKNOWN_PROPERTY_NAME} will be used instead.
	 *
	 * @param propertyName the name of the property to remove
	 */
	public function removePropertyValueByName(propertyName:String):Void {
		if (propertyName == null) {
			propertyName = UNKNOWN_PROPERTY_NAME;
		}
		removePropertyValueByPropertyValue(getPropertyValue(propertyName));
	}

	/**
	 * Checks whether this list contains a property with the given name.
	 *
	 * <p>If the given property name is {@code null},
	 * {@link #UNKNOWN_PROPERTY_NAME} will be used instead.
	 *
	 * @param propertyName the name of the property to check for existence
	 * @return {@code true} if there is a property value with the given name, else
	 * {@code false}
	 */
	public function contains(propertyName:String):Boolean {
		if (propertyName == null) {
			propertyName = UNKNOWN_PROPERTY_NAME;
		}
		return (propertyValues[propertyName] != null);
	}

	/**
	 * Returns how much property values have the given property name.
	 *
	 * <p>If the given property name is {@code null},
	 * {@link #UNKNOWN_PROPERTY_NAME} will be used instead.
	 *
	 * @param propertyName the name of the property to return the count for
	 * @return the number of property values with the given name
	 */
	public function getPropertyCount(propertyName:String):Number {
		if (propertyName == null) {
			propertyName = UNKNOWN_PROPERTY_NAME;
		}
		var propertyCount:Number = propertyValues[propertyName];
		if (propertyCount == null) {
			return 0;
		}
		return propertyCount;
	}

	/**
	 * Returns the first property value with the given name.
	 *
	 * <p>If the given property name is {@code null},
	 * {@link #UNKNOWN_PROPERTY_NAME} will be used instead.
	 *
	 * @param propertyName the name of the property value to return
	 * @return the property value for the given name or {@code null} if none
	 */
	public function getPropertyValue(propertyName:String):PropertyValue {
		if (propertyName == null) {
			propertyName = UNKNOWN_PROPERTY_NAME;
		}
		for (var i:Number = 0; i < propertyValues.length; i++) {
			var propertyValue:PropertyValue = propertyValues[i];
			if (propertyValue.getName() == propertyName) {
				return propertyValue;
			}
		}
		return null;
	}

	/**
	 * Returns all {@code PropertyValue} instances added to this list.
	 *
	 * @return all added property values
	 */
	public function getPropertyValues(Void):Array {
		return propertyValues;
	}

	/**
	 * Checks whether this list contains any property values.
	 *
	 * @return {@code true} if no properties are added else {@code false}
	 */
	public function isEmpty(Void):Boolean {
		return (propertyValues.length == 0);
	}

}