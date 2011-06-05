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
import org.as2lib.core.BasicClass;
import org.as2lib.data.holder.Properties;
import org.as2lib.env.except.IllegalArgumentException;
import org.as2lib.env.except.IllegalStateException;
import org.as2lib.env.reflect.ReflectUtil;

/**
 * {@code ManagedProperties} represents a properties that may be merged with a parent
 * properties.
 *
 * <p>Note that this {@code Properties} implementation implements only the {@code setProp},
 * {@code getKeys} and {@code getValues} methods.
 *
 * @author Simon Wacker
 */
class org.as2lib.bean.factory.support.ManagedProperties extends BasicClass implements Properties, Mergeable {

	/** All set keys. */
	private var keys:Array;

	/** All set values. */
	private var values:Array;

	/** Is mergin enabled? */
	private var mergeEnabled:Boolean;

	/**
	 * Constructs a new {@code ManagedProperties} instance.
	 */
	public function ManagedProperties(keys:Array, values:Array, mergeEnabled:Boolean) {
		if (keys == null) {
			keys = new Array();
		}
		this.keys = keys;
		if (values == null) {
			values = new Array();
		}
		this.values = values;
		this.mergeEnabled = mergeEnabled;
	}

	public function isMergeEnabled(Void):Boolean {
		return mergeEnabled;
	}

	public function setMergeEnabled(mergeEnabled:Boolean):Void {
		this.mergeEnabled = mergeEnabled;
	}

	public function merge(parent) {
		if (!mergeEnabled) {
			throw new IllegalStateException("Merging is not enabled for this managed properties.",
					this, arguments);
		}
		var parentProperties:Properties = Properties(parent);
		if (parentProperties == null) {
			throw new IllegalArgumentException("Cannot merge with instance of type [" +
					ReflectUtil.getTypeNameForInstance(parent) + "].", this, arguments);
		}
		var keys = parentProperties.getKeys().concat(keys);
		var values = parentProperties.getValues().concat(values);
		return new ManagedProperties(keys, values, mergeEnabled);
	}

	public function setProp(key:String, value:String):Void {
		keys.push(key);
		values.push(value);
	}

	public function getKeys(Void):Array {
		return keys;
	}

	public function getValues(Void):Array {
		return values;
	}

	public function getProp(key:String, defaultValue:String):String {
		return null;
	}

	public function putAll(source:Properties):Void {
	}

	public function remove(key:String):String {
		return null;
	}

	public function clear(Void):Void {
	}

}