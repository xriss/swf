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

import org.as2lib.app.exec.Process;
import org.as2lib.app.exec.ProcessErrorListener;
import org.as2lib.app.exec.ProcessFinishListener;
import org.as2lib.app.exec.ProcessPauseListener;
import org.as2lib.app.exec.ProcessResumeListener;
import org.as2lib.app.exec.ProcessStartListener;
import org.as2lib.app.exec.ProcessUpdateListener;
import org.as2lib.env.log.LogSupport;
import org.as2lib.test.unit.TestMethod;
import org.as2lib.test.unit.TestRunner;
import org.as2lib.util.StringUtil;

/**
 * {@code LoggerTestListener} directs test results to As2lib Logging. This means that
 * As2lib Logging must be configured to do the actual output to a console of your
 * choice.
 *
 * <p>If you are working in the Flash IDE you can use the {@link TraceLogger} to do the
 * output. If you are working with MTASC you may use the {@link LuminicBoxLogger} or
 * {@link AlconLogger}. There are of course lots of other output consoles supported.
 * Just take a look at the {@code org.as2lib.env.log.logger} package.
 *
 * <code>
 *   import org.as2lib.env.log.LogManager;
 *   import org.as2lib.env.log.logger.TraceLogger;
 *
 *   LogManager.setLogger(new TraceLogger());
 * </code>
 *
 * @author Martin Heidegger
 * @author Simon Wacker
 * @see Logger
 * @see LogManager#setLogger
 * @see LogManager#setLoggerRepository
 */
class org.as2lib.test.unit.LoggerTestListener extends LogSupport implements
		ProcessStartListener, ProcessErrorListener, ProcessFinishListener,
		ProcessPauseListener, ProcessResumeListener, ProcessUpdateListener {

	/** Shared instance. */
	private static var instance:LoggerTestListener;

	/**
	 * Returns a shared logger test listener. While there may exist multiple logger
	 * test listeners, it is not necessary. The same instance can be used for multiple
	 * test cases.
	 *
	 * @return a shared logger test listener
	 */
	public static function getInstance(Void):LoggerTestListener {
		if (instance == null) {
			instance = new LoggerTestListener();
		}
		return instance;
	}

	/**
	 * Constructs a new {@code LoggerTestListener} instance.
	 */
	public function LoggerTestListener(Void) {
	}

	/**
	 * Logs that test execution has been started.
	 *
	 * @param process the test runner that started the test execution
	 */
	public function onProcessStart(process:Process):Void {
		logger.info("Started execution of tests.");
	}

	/**
	 * Logs the execution of the next test.
	 *
	 * @param process the test runner that started executing the next test
	 */
	public function onProcessUpdate(process:Process):Void {
		var testRunner:TestRunner = TestRunner(process);
		if (testRunner != null) {
			var methodInfo:TestMethod = testRunner.getCurrentTestMethod();
			if (methodInfo != null) {
				logger.info("Executing " + methodInfo.getName());
			}
		}
	}

	/**
	 * Logs that the test execution has been paused.
	 *
	 * @param process the test runner that has been paused
	 */
	public function onProcessPause(process:Process):Void {
		var testRunner:TestRunner = TestRunner(process);
		if (testRunner != null) {
			logger.info("Paused execution at " + testRunner.getCurrentTestMethod().getName());
		}
	}

	/**
	 * Logs that the test execution has been resumed.
	 *
	 * @param process the test runner that has been resumed
	 */
	public function onProcessResume(process:Process):Void {
		var testRunner:TestRunner = TestRunner(process);
		if (testRunner != null) {
			logger.info("Resumed execution at " + testRunner.getCurrentTestMethod().getName());
		}
	}

	/**
	 * Logs the result of the test execution; the string result is obtained with
	 * the {@code toString} method of the given test runner.
	 *
	 * @param process the test runner that finished the test execution
	 */
	public function onProcessFinish(process:Process):Void {
		var testRunner:TestRunner = TestRunner(process);
		if (testRunner != null) {
			logger.info(testRunner.getTestResult().toString());
		}
	}

	/**
	 * Logs that an exception was thrown during the test execution.
	 *
	 * @param process the test runner which catched the raised exception
	 * @param error the error that occurred
	 */
	public function onProcessError(process:Process, error):Boolean {
		logger.error("Error was raised during test execution:\n" +
				StringUtil.addSpaceIndent(error.toString(), 2));
		return true;
	}

}