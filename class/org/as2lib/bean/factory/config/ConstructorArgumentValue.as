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
 * {@code ConstructorArgumentValue} represents a constructor argument value.
 *
 * @author Simon Wacker
 */
class org.as2lib.bean.factory.config.ConstructorArgumentValue extends BasicClass {

	/** The value of the constructor argument. */
	private var value;

	/** The type to convert the value to. */
	private var type:Function;

	/**
	 * Constructs a new {@code ConstructorArgumentValue} instance.
	 *
	 * @param value the value of this constructor argument
	 * @param type the type to convert the value to
	 */
	public function ConstructorArgumentValue(value, type:Function) {
		this.value = value;
		this.type = type;
	}

	/**
	 * Returns the value of this constructor argument.
	 *
	 * @return the value of this constructor argument
	 */
	public function getValue(Void) {
		return value;
	}

	/**
	 * Sets the value of this constructor argument.
	 *
	 * @param value the value of this constructor argument
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

}