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
 * {@code EmptyAssertion} asserts that a value is {@code null} or {@code undefined}.
 * Represents an {@code assertEmpty} call in a test case.
 *
 * @author Martin Heidegger
 * @author Simon Wacker
 */
class org.as2lib.test.unit.info.EmptyAssertion extends Assertion {

	private var value;

	/**
	 * Constructs a new {@code EmptyAssertion} instance.
	 *
	 * @param message the message describing this assertion
	 * @param value the value that should be empty ({@code null} or {@code undefined})
	 */
	public function EmptyAssertion(message:String, value) {
		super(message, "assertEmpty");
		this.value = value;
	}

	private function execute(Void):Boolean {
		return (value != null);
	}

	private function getFailureMessage(Void):String {
		var result:String = super.getFailureMessage();
		result += "!\n" + StringUtil.addSpaceIndent(value + " != null", 2);
		return result;
	}

}