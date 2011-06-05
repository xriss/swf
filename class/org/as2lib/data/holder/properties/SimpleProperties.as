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
import org.as2lib.data.holder.Properties;
import org.as2lib.util.StringUtil;

/**
 * {@code SimpleProperties} represents a persistent set of properties; simply key-value
 * pairs.
 *
 * @author Martin Heidegger
 * @author Simon Wacker
 * @version 1.0
 */
class org.as2lib.data.holder.properties.SimpleProperties extends BasicClass implements Properties {

	/** Indeces of all keys and values by key. */
	private var i:Object;

	/** All keys by index. */
	private var k:Array;

	/** All values by index. */
	private var v:Array;

	/** The characters that have to be escaped. */
	private static var escapeMap:Array = ["\\t", "\t", "\\n", "\n", "\\r", "\r",
			"\\\"", "\"", "\\\\", "\\", "\\'", "\'", "\\f", "\f"];

	/**
	 * Constructs a new {@code SimpleProperties} instance.
	 */
	public function SimpleProperties(Void) {
		i = new Object();
		k = new Array();
		v = new Array();
	}

	/**
	 * Returns the value associated with the given {@code key} if there is one, and the
	 * given {@code defaultValue} otherwise. If both these values are not specified, the
	 * {@code key} itself is returned.
	 *
	 * @param key the key to return the value for
	 * @param defaultValue the default value to return if there is no value mapped to the
	 * given {@code key}, {@code null} is accepted, {@code undefined} not
	 * @return the value mapped to the given {@code key} or the given {@code defaultValue}
	 */
	public function getProp(key:String, defaultValue:String):String {
		var value:String = v[i[key]];
		if (value == null) {
			if (defaultValue !== undefined) {
				return StringUtil.escape(defaultValue, escapeMap, false);
			}
			return key;
		}
		return value;
	}

	/**
	 * Sets the given {@code value} for the given {@code key}; the {@code value} is mapped
	 * to the {@code key}.
	 *
	 * @param key the key to map the {@code value} to
	 * @param value the value to map to the {@code key}
	 */
	public function setProp(key:String, value:String):Void {
		key = StringUtil.escape(key);
		value = StringUtil.escape(value, escapeMap, false);
		i[key] = k.length;
		k.push(key);
		v.push(value);
	}

	/**
	 * Returns the keys of all set properties. These keys are of type {@code String}.
	 *
	 * <p>The order of the returned keys is the same in which the properties were set.
	 * At position 0 is the key of the first property and so on.
	 *
	 * @return the keys of all set properties
	 */
	public function getKeys(Void):Array {
		return k.concat();
	}

	/**
	 * Returns the values of all set properties. These values are of type {@code String}.
	 *
	 * <p>The order of the returned values is the same in which the properties were set.
	 * At position 0 is the value of the first property and so on.
	 *
	 * @return the values of all set properties
	 */
	public function getValues(Void):Array {
		return v.concat();
	}

	/**
	 * Copies all properties from the given {@code source} to this instance.
	 *
	 * @param source the properties to copy to this instance
	 */
	public function putAll(source:Properties):Void {
		var values:Array = source.getValues();
		var keys:Array = source.getKeys();
		var l:Number = keys.length;
		for (var i:Number = 0; i < l; i = i-(-1)) {
			setProp(keys[i], values[i]);
		}
	}

	public function remove(key:String):String {
		var index:Number = i[key];
		var value:String = v[index];
		delete i[key];
		k.splice(index, 1);
		v.splice(index, 1);
		return value;
	}

	/**
	 * Removes all properties (key-value pairs).
	 */
	public function clear(Void):Void {
		i = new Object();
		k = new Array();
		v = new Array();
	}

}