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

import org.as2lib.app.exec.Process;
import org.as2lib.test.unit.TestCaseResult;
import org.as2lib.test.unit.TestMethod;
import org.as2lib.test.unit.TestResult;

/**
 * {@code TestRunner} runs a test. This may be a test case or a test suite, depending
 * on the used implementation. To run a test a test runner must know the internal
 * mechanism of the test. Every type of test thus needs its own test runner.
 *
 * <p>A test runner is at its heart a process (it implements the {@link Process}
 * interface). To receive test execution information like start, progress and/or
 * finish you can add process listeners. For a complete list of process listeners
 * take a look at the {@code Process} documentation.
 *
 * <p>Implementations for some commonly needed listeners have already been created:
 * {@link LoggerTestListener}, {@link TraceTestListener} and {@link XmlScoketTestListener}.
 *
 * <code>
 *   import org.as2lib.test.unit.TestCase;
 *   import org.as2lib.test.unit.TestRunner;
 *   import org.as2lib.test.unit.LoggerTestListener;
 *   import org.as2lib.env.log.LogManager;
 *   import org.as2lib.env.log.logger.TraceLogger;
 *   import com.simonwacker.chat.RoomTest;
 *
 *   LogManager.setLogger(new TraceLogger());
 *
 *   var testCase:TestCase = new RoomTest();
 *   var testRunner:TestRunner = testCase.getTestRunner();
 *   testRunner.addListener(new LoggerTestListener());
 *   testRunner.start();
 * </code>
 *
 * <p>Note that you cannot directly write-out the test result after you received
 * it from the {@link #getTestResult} method and after you invoked the {@link #start}
 * method, because the tests are executed asynchronously. You must use test listeners!
 * Tests are executed asynchronously to support pausing and resuming asynchronous
 * tests and to prevent the flash player from crashing when there are a lot of tests.
 *
 * @author Martin Heidegger
 * @author Simon Wacker
 * @version 2.0
 * @see Test
 * @see TestResult
 */
interface org.as2lib.test.unit.TestRunner extends Process {

	/**
	 * Returns the test result of this test run.
	 *
	 * <p>The returned test result may not be complete. This is the case if this test
	 * runner has not been executed yet or is currently being executed.
	 *
	 * @return the test result of this test run
	 */
	public function getTestResult(Void):TestResult;

	/**
	 * Returns the result of the currently executing test case.
	 *
	 * @return the result of the currently executing test case
	 * @see #getCurrentTestMethod
	 */
	public function getCurrentTestCaseResult(Void):TestCaseResult;

	/**
	 * Returns the currently executing test method.
	 *
	 * @return information about the currently executing test method
	 * @see #getCurrentTestCaseResult
	 */
	public function getCurrentTestMethod(Void):TestMethod;

}