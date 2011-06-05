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

import org.as2lib.app.exec.BatchProcess;
import org.as2lib.app.exec.Process;
import org.as2lib.data.holder.array.TypedArray;
import org.as2lib.env.except.IllegalArgumentException;
import org.as2lib.test.unit.Test;
import org.as2lib.test.unit.TestCaseResult;
import org.as2lib.test.unit.TestMethod;
import org.as2lib.test.unit.TestResult;
import org.as2lib.test.unit.TestRunner;
import org.as2lib.test.unit.TestSuiteResult;

/**
 * {@code TestSuite} manages the execution of multiple tests, it is a composite of
 * {@link Test} instances. It runs a collection of tests, which may be {@link TestCase}
 * instances or {@code TestSuite} instances themselves.
 *
 * <p>Tests can be added with the {@link #addTest} method.
 *
 * <p>In contrast to {@code TestCase} {@code TestSuite} has no external {@code TestRunner}.
 * It is its own {@code TestRunner} implementation.
 *
 * <p>It is common practice to create a test suite per package and/or module and one
 * for all tests. This makes it easy to run the test case for the class that is being
 * worked on minute-by-minute, the affected package and/or module hourly and all tests
 * at the end of the day.
 *
 * <code>
 *   import org.as2lib.test.unit.TestSuite;
 *   import org.as2lib.sample.SampleTests;
 *   import org.as2lib.lang.LangTests;
 *   import org.as2lib.bean.BeanTests;
 *
 *   class org.as2lib.AllTests extends TestSuite {
 *
 *       public function AllTests(Void) {
 *           super("All Tests");
 *           addTest(new SampleTests());
 *           addTest(new LangTests());
 *           addTest(new BeanTests());
 *       }
 *
 *   }
 * </code>
 *
 * <code>
 *   import org.as2lib.test.unit.TestSuite;
 *   import org.as2lib.sample.chat.ChatTests;
 *   import org.as2lib.sample.pizzaservice.PizzaServiceTests;
 *   import org.as2lib.sample.filebrowser.FileBrowserTests;
 *
 *   class org.as2lib.sample.SampleTests extends TestSuite {
 *
 *       public function SampleTests(Void) {
 *           super("Sample Tests");
 *           addTest(new ChatTests());
 *           addTest(new PizzaServiceTests());
 *           addTest(new FileBrowserTests());
 *       }
 *
 *   }
 * </code>
 *
 * <code>
 *   import com.simonwacker.chat.UserTest;
 *   import com.simonwacker.chat.RoomTest;
 *   import com.simonwacker.chat.LoginTest;
 *
 *   class org.as2lib.sample.chat.ChatTests extends TestSuite {
 *
 *       public function ChatTests(Void) {
 *           super("Chat Tests");
 *           addTest(new UserTest());
 *           addTest(new RoomTest());
 *           addTest(new LoginTest());
 *       }
 *
 *   }
 * </code>
 *
 * <p>To run a test suite create an instance of it, add a test listener which
 * writes-out the test result and invoke the {@link #run} method. The
 * {@link LoggerTestListener} is used in the following example which directs the test
 * result to As2lib Logging; we must thus also configure As2lib Logging, for example
 * with a trace logger, luminic box logger, sos logger, ...
 *
 * <code>
 *   import org.as2lib.AllTests;
 *   import org.as2lib.env.log.LogManager;
 *   import org.as2lib.env.log.logger.TraceLogger;
 *   import org.as2lib.test.unit.TestSuite;
 *   import org.as2lib.test.unit.LoggerTestListener;
 *
 *   LogManager.setLogger(new TraceLogger());
 *
 *   var testSuite:TestSuite = new AllTests();
 *   testSuite.addListener(new LoggerTestListener());
 *   testSuite.run();
 * </code>
 *
 * @author Martin Heidegger
 * @author Simon Wacker
 * @version 2.0
 * @see TestSuiteFactory
 */
class org.as2lib.test.unit.TestSuite extends BatchProcess implements Test, TestRunner {

	/**
	 * Blocks the collection of this test suite by the
	 * {@code TestSuiteFactory#collectAllTestCases} method.
	 *
	 * @return {@code true} to block collection
	 */
	public static function blockCollecting(Void):Boolean {
		return true;
	}

	/** Name of this test suite. */
	private var name:String;

	/** Result of this test suite's execution. */
	private var testResult:TestSuiteResult;

	/** All test runners managed by this test suite. */
	private var testRunners:TypedArray;

	/**
	 * Constructs a new {@code TestSuite} instance.
	 *
	 * @param name the name of this test suite
	 */
	public function TestSuite(name:String) {
		this.name = name;
		testResult = new TestSuiteResult(this);
		testRunners = new TypedArray(TestRunner);
	}

	/**
	 * Returns the name of this test suite.
	 *
	 * @return the name of this test suite
	 */
	public function getName(Void):String {
		if (name == null) {
			name = "";
		}
		return name;
	}

	/**
	 * Returns all {@link TestRunner} instances of this test suite.
	 *
	 * @return all test runners of this test suite
	 */
	public function getTestRunners(Void):TypedArray {
		return testRunners;
	}

	/**
	 * Adds a test to this test suite.
	 *
	 * @param test the test to add
	 * @throws IllegalArgumentException if the passed-in test has this test suite
	 * as child.
	 */
	public function addTest(test:Test):Void {
		addProcess(test.getTestRunner());
	}

	/**
	 * Adds a process to this test suite.
	 *
	 * <p>This test suite does only allow {@link TestRunner} instances as subprocesses.
	 *
	 * @param process the process to add to this test suite
	 * @throws IllegalArgumentException if the passed-in process has this test suite
	 * as child or is not an instance of type {@code TestRunner}
	 */
	public function addProcess(process:Process):Void {
		var testRunner:TestRunner = TestRunner(process);
		if (testRunner == null) {
			throw new IllegalArgumentException("Only test runners are allowed " +
					"as subprocesses.", this, arguments);
		}
		checkRecursion(testRunner.getTestResult());
		testResult.addTestResult(testRunner.getTestResult());
		testRunners.push(testRunner);
		super.addProcess(testRunner);
	}

	/**
	 * Checks whether the given test is a parent of this test suite.
	 *
	 * <p>Since it is possible to add any test to this suite it could be this test
	 * suite itself, which would result in an infinite recursion. The given test may
	 * also be a parent of this test suite which would have the same effect.
	 *
	 * @param test the test that may be the parent of this test suite
	 * @throws IllegalArgumentException if the passed-in test is the parent of this
	 * test suite (or is this test suite itself)
	 */
	private function checkRecursion(test:TestResult):Void {
		if (test === testResult) {
			throw new IllegalArgumentException("Test [" + test + "] is a parent of " +
					"this test suite.", this, arguments);
		}
		var testResults:Array = test.getTestResults();
		for (var i = 0; i < testResults.length; i++) {
			if (testResults[i] != test) {
				checkRecursion(testResults[i]);
			}
		}
	}

	/**
	 * Handles the error of a process.
	 *
	 * @param process the process that raised the error
	 * @return {@code false} to stop further execution
	 */
	public function onProcessError(process:Process, error):Boolean {
		return false;
	}

	public function run(Void):TestRunner {
		start();
		return this;
	}

	public function getTestRunner(Void):TestRunner {
		return this;
	}

	public function getTestResult(Void):TestResult {
		return testResult;
	}

	public function getCurrentTestCaseResult(Void):TestCaseResult {
		return TestRunner(getCurrentProcess(true)).getCurrentTestCaseResult();
	}

	public function getCurrentTestMethod(Void):TestMethod {
		return TestRunner(getCurrentProcess(true)).getCurrentTestMethod();
	}

}