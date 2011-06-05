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

import org.as2lib.env.reflect.ClassInfo;
import org.as2lib.test.unit.Assertion;
import org.as2lib.util.ObjectUtil;
import org.as2lib.util.StringUtil;

/**
 * {@code InstanceOfAssertion} asserts that a value is of a given type (an instance
 * of a given type). Represents a {@code assertInstanceOf} call in a test case.
 *
 * @author Martin Heidegger
 * @author Simon Wacker
 */
class org.as2lib.test.unit.info.InstanceOfAssertion extends Assertion {

	private var value;

	private var type:Function;

	/**
	 * Constructs a new {@code InstanceOfAssertion} instance.
	 *
	 * @param message the message describing this assertion
	 * @param value the value whose type shall be checked
	 * @param type the type the value should be an instance of
	 */
	public function InstanceOfAssertion(message:String, value, type:Function) {
		super(message, "assertInstanceOf");
		this.value = value;
		this.type = type;
	}

	private function execute(Void):Boolean {
		return !ObjectUtil.typesMatch(value, type);
	}

	private function getFailureMessage(Void):String {
		var result:String = super.getFailureMessage();
		result += "!\n" + StringUtil.addSpaceIndent("'" + value + "' is not an " +
				"instance of '" + ClassInfo.forClass(type).getFullName() + "'", 2);
		return result;
	}

	private function getSuccessMessage(Void):String {
		return (super.getSuccessMessage() + "\n" + StringUtil.addSpaceIndent("'" + value +
				"' is an instance of '" + ClassInfo.forClass(type).getFullName() + "'.", 2));
	}

}