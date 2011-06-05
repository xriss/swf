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

import org.as2lib.core.BasicInterface;
import org.as2lib.env.log.LogMessage;

/**
 * {@code GenericLogger} declares a generic log message to output any
 * {@link LogMessage} implementation.
 *
 * @author Igor Sadovskiy
 */
interface org.as2lib.env.log.GenericLogger extends BasicInterface {

	/**
	 * Logs the passed-in log message.
	 *
	 * <p>Uses the information stored inside {@code message} to determine whether to
	 * log the message or not.
	 *
	 * @param message the message to log
	 */
	public function logMessage(message:LogMessage):Void;

}