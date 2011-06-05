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
import org.as2lib.env.log.LogMessage;
import org.as2lib.util.Stringifier;

/**
 * {@code AbstractLogHandler} provides methods that are commonly needed by
 * {@link LogHandler} implementations.
 *
 * @author Simon Wacker
 */
class org.as2lib.env.log.handler.AbstractLogHandler extends BasicClass {

	/** The log message stringifier. */
	private var messageStringifier:Stringifier;

	/**
	 * Constructs a new {@code AbstractLogHandler} instance.
	 *
	 * @param messageStringifier (optional) the log message stringifier to use
	 */
	public function AbstractLogHandler(messageStringifier:Stringifier) {
		this.messageStringifier = messageStringifier;
	}

	/**
	 * Returns the log message stringifier supplied on construction.
	 */
	public function getMessageStringifier(Void):Stringifier {
		return messageStringifier;
	}

	/**
	 * Converts the passed-in {@code message} into a string.
	 *
	 * <p>If the message stringifier set on construction is not {@code null} nor
	 * {@code undefined}, it will be used for conversion. Otherwise the
	 * {@code toString} method of the passed-in {@code message} will be used.
	 *
	 * @param message the log message to convert
	 * @return the string representation of the passed-in {@code message}	 */
	private function convertMessage(message:LogMessage):String {
		if (messageStringifier) {
			return messageStringifier.execute(message);
		}
		return message.toString();
	}

}