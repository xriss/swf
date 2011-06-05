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

import org.as2lib.env.except.AbstractOperationException;
import org.as2lib.test.unit.AbstractExecutionInfo;

/**
 * {@code Assertion} represents an {@code assert*} call in a test method.
 *
 * @author Martin Heidegger
 * @author Simon Wacker
 */
class org.as2lib.test.unit.Assertion extends AbstractExecutionInfo {

	/** Has this assertion already been executed? */
	private var executed:Boolean;

	/** The name of this assertion. */
	private var name:String;

	/**
	 * Constructs a new {@code Assertion} instance.
	 *
	 * @param message the message describing this assertion
	 * @param name the name of this assertion (mostly the name of the corresponding
	 * method on the test case)
	 */
	public function Assertion(message:String, name:String) {
		super(message);
		this.name = name;
	}

	/**
	 * Returns the name of this assertion.
	 */
	public function getName(Void):String {
		return name;
	}

	/**
	 * Returns the message describing this assertion. If this assertion failed the
	 * failure message will be returned, otherwise the success message.
	 *
	 * @return the message describing this assertion
	 * @see #getFailureMessage
	 * @see #getSuccessMessage
	 */
	public function getMessage(Void):String {
		if (isFailed()) {
			return getFailureMessage();
		}
		else {
			return getSuccessMessage();
		}
	}

	public function isFailed(Void):Boolean {
		if (!executed) {
			failed = execute();
			executed = true;
		}
		return failed;
	}

	/**
	 * Executes this assertion.
	 *
	 * <p>Note that this method is normally overridden in subclasses. If not
	 * {@code true} is returned by default.
	 *
	 * @return {@code true} if this assertion failed else {@code false}
	 */
	private function execute(Void):Boolean {
		return true;
	}

	/**
	 * Returns the failure message; the message to use when this assertion failed.
	 *
	 * <p>Note that subclasses can override this method to supply more detailed
	 * information on why this assertion failed.
	 */
	private function getFailureMessage(Void):String {
		var result:String = name + " failed";
		if (hasMessage()) {
			result += " with message: " + message;
		}
		return result;
	}

	/**
	 * Returns the success message; the message to use when this assertion succeeded.
	 *
	 * <p>Note that subclasses can override this method to supply more detailed
	 * information on what was asserted.
	 */
	private function getSuccessMessage(Void):String {
		return (name + " succeeded.");
	}

}