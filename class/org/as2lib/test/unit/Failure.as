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

import org.as2lib.test.unit.AbstractExecutionInfo;

/**
 * {@code Failure} represents a {@code fail} call in a test method.
 *
 * @author Martin Heidegger
 * @author Simon Wacker
 */
class org.as2lib.test.unit.Failure extends AbstractExecutionInfo {

	/**
	 * Constructs a new {@code Failure} instance.
	 *
	 * @param message the message describing this failure
	 */
	public function Failure(message:String) {
		super("Failed with message: " + message, true);
	}

}