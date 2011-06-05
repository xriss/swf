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
 * {@code UndefinedAssertion} asserts that a given value is {@code undefined}.
 * Represents an {@code assertUndefined} call in a test case.
 *
 * @author Martin Heidegger
 * @author Simon Wacker
 */
class org.as2lib.test.unit.info.UndefinedAssertion extends Assertion {

	private var value;

	/**
	 * Constructs a new {@code UndefinedAssertion} instance.
	 *
	 * @param message the message describing this assertion
	 * @param value the value that should be undefined
	 */
	public function UndefinedAssertion(message:String, value) {
		super(message, "assertUndefined");
		this.value = value;
	}

	private function execute(Void):Boolean {
		return (value !== undefined);
	}

	private function getFailureMessage(Void):String {
		var result:String = super.getFailureMessage();
		result += "!\n  " + value + " !== undefined";
		return result;
	}

}