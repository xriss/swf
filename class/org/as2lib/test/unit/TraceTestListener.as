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
import org.as2lib.core.BasicClass;
import org.as2lib.test.unit.TestMethod;
import org.as2lib.test.unit.TestRunner;
import org.as2lib.util.StringUtil;

/**
 * {@code TraceTestListener} uses {@code trace} to write-out test execution information.
 * You may either use this test listener in the Flash IDE or in conjunction with the
 * MTASC trace support.
 *
 * @author Simon Wacker
 */
class org.as2lib.test.unit.TraceTestListener extends BasicClass implements
		ProcessStartListener, ProcessErrorListener, ProcessFinishListener,
		ProcessPauseListener, ProcessResumeListener, ProcessUpdateListener {

	/**
	 * Constructs a new {@code TraceTestListener} instance.
	 */
	public function TraceTestListener(Void) {
	}

	public function onProcessStart(process:Process):Void {
		trace("Started execution of tests.");
	}

	public function onProcessUpdate(process:Process):Void {
		var testRunner:TestRunner = TestRunner(process);
		if (testRunner != null) {
			var methodInfo:TestMethod = testRunner.getCurrentTestMethod();
			if (methodInfo != null) {
				trace("Executing " + methodInfo.getName());
			}
		}
	}

	public function onProcessPause(process:Process):Void {
		var testRunner:TestRunner = TestRunner(process);
		if (testRunner != null) {
			trace("Paused execution at " + testRunner.getCurrentTestMethod().getName());
		}
	}

	public function onProcessResume(process:Process):Void {
		var testRunner:TestRunner = TestRunner(process);
		if (testRunner != null) {
			trace("Resumed execution at " + testRunner.getCurrentTestMethod().getName());
		}
	}

	public function onProcessFinish(process:Process):Void {
		var testRunner:TestRunner = TestRunner(process);
		if (testRunner != null) {
			trace(testRunner.getTestResult());
		}
	}

	public function onProcessError(process:Process, error):Boolean {
		trace("Error was raised during test execution:\n" +
				StringUtil.addSpaceIndent(error.toString(), 2));
		return false;
	}

}