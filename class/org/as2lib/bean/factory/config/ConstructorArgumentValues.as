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

import org.as2lib.bean.factory.config.ConstructorArgumentValue;
import org.as2lib.core.BasicClass;
import org.as2lib.env.overload.Overload;
import org.as2lib.util.ArrayUtil;

/**
 * {@code ConstructorArgumentValues} holds constructor argument values, as part of
 * a bean definition.
 * 
 * @author Simon Wacker
 */
class org.as2lib.bean.factory.config.ConstructorArgumentValues extends BasicClass {
	
	/** All added constructor argument values. */
	private var argumentValues:Array;
	
	/**
	 * Constructs a new {@code ConstructorArgumentValues} instance.
	 * 
	 * <p>Note that the constructor argument values of the {@code source} are copied,
	 * and the copies are added to this instance.
	 * 
	 * @param source the constructor argument values to populate this list with
	 */
	public function ConstructorArgumentValues(source:ConstructorArgumentValues) {
		argumentValues = new Array();
		if (source != null) {
			var avs:Array = source.getArgumentValues();
			for (var i:Number = 0; i < avs.length; i++) {
				var av:ConstructorArgumentValue = avs[i];
				argumentValues.push(new ConstructorArgumentValue(av.getValue(), av.getType()));
			}
		}
	}
	
	/**
	 * Adds all constructor argument values of the given ones.
	 * 
	 * @param argumentValues the argument values to add
	 */
	public function addArgumentValues(argumentValues:ConstructorArgumentValues):Void {
		var avs:Array = argumentValues.getArgumentValues();
		for (var i:Number = 0; i < avs.length; i++) {
			addArgumentValueByValue(avs[i]);
		}
	}
	
	/**
	 * @overload #addArgumentValueByValue
	 * @overload #addArgumentValueByIndexAndValue
	 */
	public function addArgumentValue():Void {
		var o:Overload = new Overload(this);
		o.addHandler([ConstructorArgumentValue], addArgumentValueByValue);
		o.addHandler([Number, ConstructorArgumentValue], addArgumentValueByIndexAndValue);
		o.forward(arguments);
	}
	
	/**
	 * Adds the given constructor argument value to the end of these values.
	 * 
	 * @param value the constructor argument value to add
	 */
	public function addArgumentValueByValue(value:ConstructorArgumentValue):Void {
		argumentValues.push(value);
	}
	
	/**
	 * Adds the given constructor argument value for the given index.
	 * 
	 * @param index the index of the given constructor argument value
	 * @param value the constructor argument value of the given index
	 */
	public function addArgumentValueByIndexAndValue(index:Number, value:ConstructorArgumentValue):Void {
		argumentValues[index] = value;
	}
	
	/**
	 * @overload #removeArgumentValueByValue
	 * @overload #removeArgumentValueByIndex
	 */
	public function removeArgumentValue():Void {
		var o:Overload = new Overload(this);
		o.addHandler([ConstructorArgumentValue], removeArgumentValueByValue);
		o.addHandler([Number], removeArgumentValueByIndex);
		o.forward(arguments);
	}
	
	/**
	 * Removes the given constructor argument value from this instance.
	 * 
	 * @param value the constructor argument value to remove
	 */
	public function removeArgumentValueByValue(value:ConstructorArgumentValue):Void {
		ArrayUtil.removeElement(argumentValues, value);
	}
	
	/**
	 * Removes the constructor argument value at the given index.
	 * 
	 * @param index the index specifying the constructor argument value to remove
	 */
	public function removeArgumentValueByIndex(index:Number):Void {
		argumentValues.splice(index, 1);
	}
	
	/**
	 * Returns the number of constructor argument values.
	 * 
	 * @return the number of constructor argument values
	 */
	public function getArgumentCount(Void):Number {
		return argumentValues.length;
	}
	
	/**
	 * Returns the constructor argument value add the given index.
	 * 
	 * @param index the index specifying the constructor argument value to return
	 * @return the constructor argument value at the given index
	 */
	public function getArgumentValue(index:Number):ConstructorArgumentValue {
		return argumentValues[index];
	}
	
	/**
	 * Returns all added {@link ConstructorArgumentValue} instances.
	 * 
	 * @return all added constructor argument values
	 */
	public function getArgumentValues(Void):Array {
		return argumentValues;
	}
	
	/**
	 * Returns whether this instance contains any constructor argument values.
	 * 
	 * @return {@code true} if there are any constructor argument values, else
	 * {@code false}
	 */
	public function isEmpty(Void):Boolean {
		return (argumentValues.length < 1);
	}
	
}