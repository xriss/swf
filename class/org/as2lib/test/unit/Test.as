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
import org.as2lib.test.unit.TestRunner;

/**
 * {@code Test} is the base interface of any test in the unit testing context.
 *
 * <p>A test can be ran by invoking the {@link #run} method. For more information
 * take a look at the two main {@code Test} implementations {@link TestCase} and
 * {@link TestSuite}.
 *
 * @author Martin Heidegger
 * @author Simon Wacker
 * @version 2.0
 */
interface org.as2lib.test.unit.Test extends BasicInterface {

	/**
	 * Runs this test.
	 *
	 * @return the test runner which executes this test
	 */
	public function run(Void):TestRunner;

	/**
	 * Returns the test runner which executes this test.
	 *
	 * <p>Every test must have a test runner which knows how to execute the test and
	 * evaluate the result.
	 *
	 * @return the test runner which executes this test
	 */
	public function getTestRunner(Void):TestRunner;

}