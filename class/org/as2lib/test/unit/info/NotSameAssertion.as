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
import org.as2lib.util.StringUtil;

/**
 * {@code NotSameAssertion} asserts that two values are not the same (strict
 * equality). Represents an {@code assertNotSame} call in a test case.
 *
 * @author Martin Heidegger
 * @author Simon Wacker
 */
class org.as2lib.test.unit.info.NotSameAssertion extends Assertion {

	private var value;

	private var compareTo;

	/**
	 * Constructs a new {@code NotSameAssertion} instance.
	 *
	 * @param message the message describing this assertion
	 * @param value the variable value
	 * @param compareTo the value to compare with the variable value
	 */
	public function NotSameAssertion(message:String, value, compareTo) {
		super(message, "assertNotSame");
		this.value = value;
		this.compareTo = compareTo;
	}

	private function execute(Void):Boolean {
		return (value === compareTo);
	}

	private function getFailureMessage(Void):String {
		var result:String = super.getFailureMessage();
		var valueString:String;
		try {
			valueString = value.toString();
		}
		catch (exception) {
			valueString = "[object Object]";
		}
		var compareToString:String;
		try {
			compareToString = compareTo.toString();
		}
		catch (exception) {
			compareToString = "[object Object]";
		}
		result += "!\n" + StringUtil.addSpaceIndent(valueString + " === " + compareToString, 2);
		return result;
	}

	private function getSuccessMessage(Void):String {
		return (super.getSuccessMessage() + " " + value + " !== " + compareTo + ".");
	}

}