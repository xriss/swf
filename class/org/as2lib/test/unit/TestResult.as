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
import org.as2lib.data.holder.array.TypedArray;
import org.as2lib.data.type.Time;

/**
 * {@code TestResult} contains information about the execution of a test; this may
 * either be a test case or a test suite.
 *
 * <p>A test result can be in different states, depending on the state of the test
 * runner: not started, currently executing, finished. The methods {@link #hasStarted},
 * {@link #getPercentage}, {@link #hasFinished} and {@link #getName} can be used in
 * either state. {@link #getOperationTime}, {@link #hasErrors}, {@link #getTestResults}
 * and {@link #getTestCaseResults} only return proper information when the test execution
 * has finished. Otherwise {@code hasErrors} regards only the tests which have already
 * been executed when it is called, and {@code getTestResults} and {@code getTestCaseResults}
 * return test results which may not contain any information yet.
 *
 * @author Martin Heidegger
 * @author Simon Wacker
 * @version 2.0
 * @see Test
 * @see TestRunner
 */
interface org.as2lib.test.unit.TestResult extends BasicInterface {

	/**
	 * Returns the percentage of the test execution.
	 *
	 * @return the percentage of the test execution
	 */
	public function getPercentage(Void):Number;

	/**
	 * Returns {@code true} if the corresponding test has finished execution.
	 *
	 * @return {@code true} if the corresponding test has finished execution
	 */
	public function hasFinished(Void):Boolean;

	/**
	 * Returns {@code true} if the corresponding test has started execution.
	 *
	 * @return {@code true} if the corresponding test has started execution
	 */
	public function hasStarted(Void):Boolean;

	/**
	 * Returns the name of this test result.
	 *
	 * @return the name of this test result
	 */
	public function getName(Void):String;

	/**
	 * Returns the total operation time that was needed for the execution of the
	 * corresponding test.
	 *
	 * @return the total operation time of the corresponding test
	 */
	public function getOperationTime(Void):Time;

	/**
	 * Returns {@code true} if at least one error occurred during the execution
	 * of the corresponding test.
	 *
	 * @return {@code true} if at least one error occurred during the execution of the
	 * corresponding test else {@code false}
	 */
	public function hasErrors(Void):Boolean;

	/**
	 * Returns all {@code TestResult} instances of the corresponding test.
	 *
	 * <p>If the corresponding test is a test case, the returned array contains only
	 * one test result, this test result. If it is a test suite, the returned array
	 * contains all test results of the tests that were directly added to the test
	 * suite, including other test suite results.
	 *
	 * @return all {@code TestResult} instances of the corresponding test
	 */
	public function getTestResults(Void):TypedArray;

	/**
	 * Returns all {@link TestCaseResult} instances of the corresponding test.
	 *
	 * <p>If the corresponding test is a test case, the returned array contains only
	 * one test case result, this test case result. If it is a test suite, the returned
	 * array contains all test case results of child test cases and all test case results
	 * of child test suites; all test case results in the whole tree.
	 *
	 * @return all {@code TestCaseResult} instances of the corresponding test
	 */
	public function getTestCaseResults(Void):TypedArray;

}