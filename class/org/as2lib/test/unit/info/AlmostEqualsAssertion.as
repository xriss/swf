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
 * {@code AlmostEqualsAssertion} asserts that two number values are either equal
 * or differ only by a specified value. Represents an {@code assertAlmostEquals}
 * call in a test case.
 *
 * @author Martin Heidegger
 * @author Simon Wacker
 */
class org.as2lib.test.unit.info.AlmostEqualsAssertion extends Assertion {

	/** The variable value. */
	private var value:Number;

	/** The value to compare. */
	private var compareTo:Number;

	/** The maximal difference between the two values. */
	private var maxDifference:Number;

	/**
	 * Constructs a new {@code AlmostEqualsAssertion} instance.
	 *
	 * @param message the message describing this assertion
	 * @param value the variable value
	 * @param compareTo the value to compare the variable value to
	 * @param maxDifference the maximal difference between the two values
	 */
	public function AlmostEqualsAssertion(message:String, value:Number, compareTo:Number, maxDifference:Number) {
		super(message, "assertAlmostEquals");
		this.value = value;
		this.compareTo = compareTo;
		this.maxDifference = maxDifference;
	}

	private function execute(Void):Boolean {
		return ((value > compareTo && value - maxDifference > compareTo) ||
				(value < compareTo && value + maxDifference < compareTo));
	}

	private function getFailureMessage(Void):String {
		var result:String = super.getFailureMessage();
		if (value > compareTo) {
			result += "!\n" + StringUtil.addSpaceIndent(value + " > " + compareTo +
					" and even " + value + " - " + maxDifference + " > " + compareTo, 2);
		}
		else {
			result += "!\n" + StringUtil.addSpaceIndent(value + " < " + compareTo +
					" and even " + value + " + " + maxDifference + " < " + compareTo, 2);
		}
		return result;
	}

	private function getSuccessMessage(Void):String {
		return (super.getSuccessMessage() + "\n" + StringUtil.addSpaceIndent(
				value + " ~(+/-" + maxDifference + ") " + compareTo, 2));
	}

}