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

import org.as2lib.app.exec.Executable;
import org.as2lib.env.reflect.ClassInfo;
import org.as2lib.test.unit.Assertion;
import org.as2lib.util.StringUtil;

/**
 * {@code NotThrowsAssertion} asserts that an executable does not throw an exception
 * of a specifc type when executed with given arguments. Represents an {@code assertNotThrows}
 * call in a test case.
 *
 * @author Martin Heidegger
 * @author Simon Wacker
 */
class org.as2lib.test.unit.info.NotThrowsAssertion extends Assertion {

	private var type;

	private var toCall:Executable;

	private var args:Array;

	/** The thrown exception. */
	private var exception;

	/** Was an exception thrown? */
	private var exceptionThrown:Boolean;

	/**
	 * Constructs a new {@code NotThrowsAssertion} instance.
	 *
	 * @param message the message describing this assertion
	 * @param type the type of the expected exception
	 * @param toCall the executable whose execution should not result in an exception
	 * of the given type
	 * @param args the arguments to use for executing the executable
	 */
	public function NotThrowsAssertion(message:String, type:Function, toCall:Executable, args:Array) {
		super(message, "assertNotThrows");
		this.type = type;
		this.toCall = toCall;
		this.args = args;
		exceptionThrown = false;
	}

	private function execute(Void):Boolean {
		try {
			toCall.execute.apply(Object(toCall), args);
		}
		catch (e) {
			exception = e;
			exceptionThrown = true;
			if (type != null) {
				return (e instanceof type);
			}
			else {
				return true;
			}
		}
		return false;
	}

	private function getFailureMessage(Void):String {
		var result:String = super.getFailureMessage();
		result += "!\n";
		if (typeof type == "function") {
			result += "  - Expected exception:\n      " +
					ClassInfo.forClass(type).getFullName();
		}
		else if(type == null) {
			result += "  - No exception expected.";
		}
		else {
			result += "  - Expected exception:\n      " + type;
		}
		if(exceptionThrown) {
			result += "\n  - Thrown exception:\n" +
					StringUtil.addSpaceIndent(exception.toString(), 6);
		}
		else {
			result += "\n  - No exception thrown.";
		}
		return result;
	}

	private function getSuccessMessage(Void):String {
		var result:String = super.getSuccessMessage() + " ";
		if (typeof type == "function") {
			result += ClassInfo.forClass(type).getFullName();
		}
		else {
			result += type;
		}
		result += " was not thrown on invocation of " + toCall.toString() + ".";
		return result;
	}

}