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
import org.as2lib.env.except.IllegalArgumentException;
import org.as2lib.env.except.IllegalStateException;
import org.as2lib.env.reflect.ReflectUtil;

/**
 * {@code ManagedArray} represents an array which may include run-time bean references
 * and whose elements are converted to a specific type if given.
 * 
 * @author Simon Wacker
 */
class org.as2lib.bean.factory.support.ManagedArray extends Array implements Mergeable {
	
	/** The required element type. */
	private var elementType:Function;
	
	/** Is merging enabled? */
	private var mergeEnabled:Boolean;
	
	/**
	 * Constructs a new {@code ManagedArray} instance.
	 */
	public function ManagedArray(elementType:Function, mergeEnabled:Boolean) {
		this.elementType = elementType;
		this.mergeEnabled = mergeEnabled;
	}
	
	/**
	 * Returns the required type of this array's elements.
	 * 
	 * @return the required element type
	 */
	public function getElementType(Void):Function {
		return elementType;
	}
	
	/**
	 * Sets the required type of this array's elements.
	 * 
	 * @param elementType the required element type
	 */
	public function setElementType(elementType:Function):Void {
		this.elementType = elementType;
	}
	
	public function isMergeEnabled(Void):Boolean {
		return mergeEnabled;
	}
	
	public function setMergeEnabled(mergeEnabled:Boolean):Void {
		this.mergeEnabled = mergeEnabled;
	}
	
	public function merge(parent) {
		if (!mergeEnabled) {
			throw new IllegalStateException("Merging is not enabled for this managed array.",
					this, arguments);
		}
		if (!(parent instanceof Array)) {
			throw new IllegalArgumentException("Cannot merge with instance of type [" +
					ReflectUtil.getTypeNameForInstance(parent) + "].", this, arguments);
		}
		var result:ManagedArray = new ManagedArray(elementType, mergeEnabled);
		result.push.apply(result, parent);
		result.push.apply(result, this);
		return result;
	}
	
}