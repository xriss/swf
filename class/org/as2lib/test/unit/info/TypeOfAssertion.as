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

import org.as2lib.test.unit.Assertion;

/**
 * {@code TypeOfAssertion} asserts that a value is of a given string type. Represents
 * a {@code assertTypeOf} call in a test case.
 *
 * @author Martin Heidegger
 * @author Simon Wacker
 */
class org.as2lib.test.unit.info.TypeOfAssertion extends Assertion {

	private var value;

	private var type:String;

	/**
	 * Constructs a new {@code TypeOfAssertion} instance.
	 *
	 * @param message the message describing this assertion
	 * @param the variable value
	 * @param type the type the value should be of
	 */
	public function TypeOfAssertion(message:String, value, type:String) {
		super(message, "assertTypeOf");
		this.value = value;
		this.type = type;
	}

	private function execute(Void):Boolean {
		return (typeof(value) != type);
	}

	private function getFailureMessage(Void):String {
		var result:String = super.getFailureMessage();
		result += "!\n  " + typeof(value) + "(typeof '" + value.toString()
				+ "') != " + type;
		return result;
	}

	private function getSuccessMessage(Void):String {
		return (super.getSuccessMessage() + " (typeof '" +
				value.toString() + "') == " + type + ".");
	}

}