/**
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

/**
 * {@code ExecutionInfo} holds information about the execution of a test.
 *
 * @author Martin Heidegger
 * @author Simon Wacker
 */
interface org.as2lib.test.unit.ExecutionInfo extends BasicInterface {

	/**
	 * Returns whether this is a test failure information.
	 *
	 * @return {@code true} if this is a test failure information else {@code false}
	 */
	public function isFailed(Void):Boolean;

	/**
	 * Returns the message giving details about this test information.
	 *
	 * @return the message of the assertion giving details about this test information
	 */
	public function getMessage(Void):String;

}