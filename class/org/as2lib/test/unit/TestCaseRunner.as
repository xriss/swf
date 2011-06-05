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

import org.as2lib.app.exec.AbstractProcess;
import org.as2lib.app.exec.Processor;
import org.as2lib.app.exec.StepByStepProcess;
import org.as2lib.data.holder.Queue;
import org.as2lib.data.holder.queue.LinearQueue;
import org.as2lib.env.reflect.ClassInfo;
import org.as2lib.test.unit.ExecutionInfo;
import org.as2lib.test.unit.info.InstantiationError;
import org.as2lib.test.unit.info.SetUpError;
import org.as2lib.test.unit.info.TearDownError;
import org.as2lib.test.unit.info.TestMethodError;
import org.as2lib.test.unit.TestCase;
import org.as2lib.test.unit.TestCaseResult;
import org.as2lib.test.unit.TestMethod;
import org.as2lib.test.unit.TestResult;
import org.as2lib.test.unit.TestRunner;
import org.as2lib.util.StopWatch;
import org.as2lib.util.StringUtil;

/**
 * {@code TestCaseRunner} runs a test case. It invokes all {@code test*} methods
 * of the test case and handles exceptions and pauses and resumes.
 *
 * <p>You usually do not have to work with this class directly because every test
 * case handles its runner automatically.
 *
 * <p>Take a look at the {@link TestRunner} documentation for details on how to
 * use test runners and code samples.
 *
 * @author Martin Heidegger
 * @author Simon Wacker
 * @version 2.0
 */
class org.as2lib.test.unit.TestCaseRunner extends AbstractProcess implements
		TestRunner, StepByStepProcess {

	/** State that indicates that the next method must be started. */
	private static var NOT_STARTED_STATE:Number = 1;

	/** State that indicates that the test case instance was created. */
	private static var TEST_CREATED_STATE:Number = 2;

	/** State that indicates that the {@code setUp} method was invoked. */
	private static var SET_UP_FINISHED_STATE:Number = 3;

	/** State that indicates that the {@code test*} method was invoked. */
	private static var EXECUTION_FINISHED_STATE:Number = 4;

	/** State that indicates that the {@code tearDown} method was invoked. */
	private static var TEAR_DOWN_FINISHED_STATE:Number = 5;

	/** The result of the test execution. */
	private var testResult:TestCaseResult;

	/** The test case to execute the current test method on. */
	private var testCase:TestCase;

	/** The {@code test*} methods that still have to be executed. */
	private var leftTestMethods:Queue;

	/**
	 * The currently executing test method. Since it is possible to pause/resume the
	 * test execution it is necessary to store the current test method.
	 */
	private var currentTestMethod:TestMethod;

	/** The stop watch of the current test method. */
	private var currentStopWatch:StopWatch;

	/**
	 * The current state of the execution of the current test method. Since it is
	 * possible to pause/resume the test execution it is necessary to safe at what
	 * point in the execution it was paused.
	 */
	private var currentMethodState:Number;

	/**
	 * Constructs a new {@code TestCaseRunner} instance.
	 *
	 * @param testCase the test case to run
	 */
	public function TestCaseRunner(testCase:TestCase) {
		testResult = new TestCaseResult(testCase);
		currentMethodState = NOT_STARTED_STATE;
		leftTestMethods = new LinearQueue(testResult.getTestMethods());
	}

	public function getTestResult(Void):TestResult {
		return testResult;
	}

	public function getCurrentTestCaseResult(Void):TestCaseResult {
		return testResult;
	}

	public function getCurrentTestMethod(Void):TestMethod {
		return currentTestMethod;
	}

	/**
	 * Adds test execution information for the currently executing method.
	 *
	 * @param executionInfo the execution information to add
	 */
	public function addExecutionInfo(executionInfo:ExecutionInfo):Void {
		currentTestMethod.addExecutionInfo(executionInfo);
	}

	/**
	 * Returns the progress in percent of this test run.
	 */
	public function getPercentage(Void):Number {
		return (100 - (100 / testResult.getTestMethods().length * leftTestMethods.size()));
	}

	/**
	 * Adds this step-by-step process to the processor which executes one step after
	 * each other on every new frame. This makes it possible to pause and resume this
	 * test runner and prevents flash player crashes.
	 *
	 * @see Processor
	 */
	private function run() {
		working = true;
		// Processor to manage the concrete processing of the TestCase
		Processor.getInstance().addStepByStepProcess(this);
	}

	/**
	 * Executes the next step of this test run.
	 */
	public function nextStep(Void):Void {
		if (leftTestMethods.isEmpty()) {
			finish();
		}
		else {
			if (currentMethodState == NOT_STARTED_STATE) {
				currentTestMethod = leftTestMethods.dequeue();
				currentStopWatch = currentTestMethod.getStopWatch();
				distributeUpdateEvent();
			}
			while (processMethod());
		}
	}

	/**
	 * Executes the next state of the current test method.
	 *
	 * @return {@code true} if the execution of the test method is finished and
	 * {@code false} if not
	 */
	private function processMethod(Void):Boolean {
		// Execution depending to the current state.
		switch (currentMethodState) {
			case NOT_STARTED_STATE:
				// create instance and set state for next loop.
				currentMethodState = TEST_CREATED_STATE;
				createTestCase();
				break;

			case TEST_CREATED_STATE:
				// set up the instance and set state for next loop.
				currentMethodState = SET_UP_FINISHED_STATE;
				setUpTestCase();
				break;

			case SET_UP_FINISHED_STATE:
				// execute the method and set the state for the next loop
				currentMethodState = EXECUTION_FINISHED_STATE;
				invokeTestMethod();
				break;

			case EXECUTION_FINISHED_STATE:
				// tear down the instance and set the state for the next loop
				currentMethodState = TEAR_DOWN_FINISHED_STATE;
				tearDownTestCase();
				break;

			case TEAR_DOWN_FINISHED_STATE:
				currentMethodState = NOT_STARTED_STATE;
				currentTestMethod.setExecuted(true);
				return false; // next method

		}
		// next state execution
		return true;
	}

	private function createTestCase(Void):Void {
		try {
			testCase = ClassInfo.forInstance(testResult.getTestCase()).newInstance();
		}
		catch (exception) {
			fatal(new InstantiationError("IMPORTANT: Test case threw an exception " +
					"on instantiation:\n" + StringUtil.addSpaceIndent(
					exception.toString(), 2), this, arguments));
		}
	}

	private function setUpTestCase(Void):Void {
		testCase.getTestRunner();
		// Prepare the execution of the method by setUp
		if (!currentTestMethod.hasErrors()) {
			try {
				testCase.setUp();
			}
			catch (exception) {
				fatal(new SetUpError("IMPORTANT: Error occurred during set up:\n" +
						StringUtil.addSpaceIndent(exception.toString(), 2), this, arguments));
			}
		}
	}

	private function invokeTestMethod(Void):Void {
		if (!currentTestMethod.hasErrors()) {
			// Execute the method
			currentStopWatch.start();
			try {
				currentTestMethod.getMethodInfo().invoke(testCase, null);
			}
			catch (exception) {
				fatal(new TestMethodError("Test method threw an unexpected exception:\n" +
						StringUtil.addSpaceIndent(exception.toString(), 2), this, arguments));
			}
		}
	}

	private function tearDownTestCase(Void):Void {
		if (currentStopWatch.hasStarted()) {
			currentStopWatch.stop();
		}
		if (!currentTestMethod.hasErrors()) {
			try {
				testCase.tearDown();
			}
			catch (exception) {
				fatal(new TearDownError("IMPORTANT: Error occurred during tear down:\n" +
						StringUtil.addSpaceIndent(exception.toString(), 2), this, arguments));
			}
		}
	}

	/**
	 * Adds the given fatal execution info to the currently executing method and stops
	 * its execution.
	 *
	 * @param error the fatal error that occurred
	 * @see #addInfo
	 * @see #STATE_TEAR_DOWN_FINISHED
	 */
	private function fatal(error:ExecutionInfo):Void {
		addExecutionInfo(error);
		currentMethodState = TEAR_DOWN_FINISHED_STATE;
	}

}