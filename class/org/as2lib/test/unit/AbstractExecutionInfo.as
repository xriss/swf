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
import org.as2lib.test.unit.ExecutionInfo;

/**
 * {@AbstractExecutionInfo} provides common functionalities needed by
 * {@link ExecutionInfo} implementations.
 *
 * @author Martin Heidegger
 * @author Simon Wacker
 */
class org.as2lib.test.unit.AbstractExecutionInfo extends BasicClass implements
		ExecutionInfo {

	/** The message describing this execution info. */
	private var message:String;

	/** Did this execution fail? */
	private var failed:Boolean;

	/**
	 * Constructs a new {@code AbstractExecutionInfo} instance.
	 *
	 * @param message the message describing the execution info
	 */
	private function AbstractExecutionInfo(message:String, failed:Boolean) {
		this.message = message;
		this.failed = failed == null ? true : failed;
	}

	/**
	 * Returns whether a message describing this execution info was supplied.
	 */
	private function hasMessage(Void):Boolean {
		return (message != null && message.length > 0);
	}

	public function getMessage(Void):String {
		return message;
	}

	public function isFailed(Void):Boolean {
		return failed;
	}

}