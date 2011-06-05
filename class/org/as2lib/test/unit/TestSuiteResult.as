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

import org.as2lib.core.BasicClass;
import org.as2lib.data.holder.array.TypedArray;
import org.as2lib.data.type.Time;
import org.as2lib.test.unit.TestCaseResult;
import org.as2lib.test.unit.TestResult;
import org.as2lib.test.unit.TestRunner;
import org.as2lib.test.unit.TestSuite;
import org.as2lib.util.StringUtil;

/**
 * {@code TestSuiteResult} contains information about the execution of a test suite.
 *
 * @author Martin Heidegger
 * @author Simon Wacker
 * @version 2.0
 * @see TestSuite
 */
class org.as2lib.test.unit.TestSuiteResult extends BasicClass implements TestResult {

	/** The corresponding test suite. */
	private var testSuite:TestSuite;

	/** All {@code TestResult} instances of the corresponding test suite. */
	private var testResults:TypedArray;

	/**
	 * Constructs a new {@code TestSuiteResult} instance.
	 *
	 * @param testSuite the test suite this result corresponds to
	 */
	public function TestSuiteResult(testSuite:TestSuite) {
		this.testSuite = testSuite;
		testResults = new TypedArray(TestResult);
		addTestResults(testSuite.getTestRunners());
	}

	/**
	 * Adds the given test results.
	 *
	 * @see #addTestResult
	 */
	private function addTestResults(testRunners:Array):Void {
		for (var i:Number = 0; i < testRunners.length; i++) {
			var testRunner:TestRunner = testRunners[i];
			addTestResult(testRunner.getTestResult());
		}
	}

	/**
	 * Returns the test suite corresponding to this test suite result.
	 *
	 * @return the corresponding test suite
	 */
	public function getTestSuite(Void):TestSuite {
		return testSuite;
	}

	/**
	 * Adds the given test result to this test suite result.
	 *
	 * @param testResult the test result to add
	 */
	public function addTestResult(testResult:TestResult):Void {
		testResults.unshift(testResult);
	}

	/**
	 * Retuns the name of the corresponding test suite.
	 *
	 * @return the name of the corresponding test suite
	 */
	public function getName(Void):String {
		return getTestSuite().getName();
	}

	public function hasStarted(Void):Boolean {
		for (var i:Number = testResults.length - 1; i >= 0; i--) {
			var testResult:TestResult = testResults[i];
			if (testResult.hasStarted()) {
				return true;
			}
		}
		return false;
	}

	public function hasFinished(Void):Boolean {
		for (var i:Number = testResults.length - 1; i >= 0; i--) {
			var testResult:TestResult = testResults[i];
			if (!testResult.hasFinished()) {
				return false;
			}
		}
		return true;
	}

	public function hasErrors(Void):Boolean {
		for (var i:Number = testResults.length - 1; i >= 0; i--) {
			var testResult:TestResult = testResults[i];
			if (testResult.hasErrors()) {
				return true;
			}
		}
		return false;
	}

	public function getOperationTime(Void):Time {
		var result:Number = 0;
		for (var i:Number = testResults.length - 1; i >= 0; i--) {
			var testResult:TestResult = testResults[i];
			result += testResult.getOperationTime().getMilliSeconds();
		}
		return new Time(result);
	}

	public function getPercentage(Void):Number {
		var result:Number = 0;
		var unit:Number = 100 / testResults.length;
		for (var i:Number = testResults.length - 1; i >= 0; i--) {
			var testResult:TestResult = testResults[i];
			result += (unit / 100 * testResult.getPercentage());
		}
		return result;
	}

	/**
	 * Returns all {@code TestResult} instances of the corresponding test suite. These
	 * are all test results of the tests that were directly added to the test suite,
	 * including test suite results.
	 *
	 * @return all {@code TestResult} instances of the corresponding test suite
	 */
	public function getTestResults(Void):TypedArray {
		return testResults.concat();
	}

	/**
	 * Returns all {@link TestCaseResult} instances of the corresponding test suite.
	 * These are all test case results of child test cases plus all test case results
	 * of child test suites; all test case results in the whole tree.
	 *
	 * @return all {@code TestCaseResult} instances of the corresponding test suite
	 */
	public function getTestCaseResults(Void):TypedArray {
		var result:TypedArray = new TypedArray(TestCaseResult);
		for (var i:Number = testResults.length - 1; i >= 0; i--) {
			var testResult:TestResult = testResults[i];
			var testCaseResults:Array = testResult.getTestCaseResults();
			result.push.apply(result, testCaseResults);
		}
		return result;
	}

	/**
	 * Returns the string representation of this test suite result. It is properly
	 * formatted and may be used to show the test result in text based consoles.
	 *
	 * @return the string representation of this test suite result
	 */
	public function toString():String {
		var result:String = "*** Test Suite " + getName() + " (" +
				testResults.length + " Tests) [" + getOperationTime() + "ms] ***";
		var titleLength:Number = result.length;
		for (var i:Number = 0; i < testResults.length; i++){
			result += "\n" + StringUtil.addSpaceIndent(testResults[i].toString(), 2);
		}
		result += "\n" + StringUtil.multiply("*", titleLength);
		return result;
	}

}