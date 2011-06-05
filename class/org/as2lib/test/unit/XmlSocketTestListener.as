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
import org.as2lib.env.log.Logger;
import org.as2lib.env.log.LogManager;
import org.as2lib.test.unit.TestCaseResult;
import org.as2lib.test.unit.TestMethod;
import org.as2lib.test.unit.TestResult;
import org.as2lib.test.unit.TestRunner;

/**
 * {@code XmlSocketTestListener} writes-out received test execution information with
 * the xml socket.
 *
 * <p>The written-out information is formatted as follows:
 * <ul>
 *   <li>&lt;start&gt;Start message.&lt;/start&gt;</li>
 *   <li>&lt;update&gt;Update message.&lt;/update&gt;</li>
 *   <li>&lt;pause&gt;Pause message.&lt;/pause&gt;</li>
 *   <li>&lt;resume&gt;Resume message.&lt;/resume&gt;
 *   <li>&lt;error&gt;Error message.&lt;/error&gt;</li>
 *   <li>&lt;finish hasErrors="false/true"&gt;Finish message.&lt;/finish&gt;</li>
 * </ul>
 *
 * <p>This format is also expected by the Unit Test Task of As2ant, so you may easily
 * use this test listener and the task in conjunction.
 *
 * @author Christophe Herreman
 * @author Simon Wacker
 */
class org.as2lib.test.unit.XmlSocketTestListener extends BasicClass implements
		ProcessStartListener, ProcessPauseListener, ProcessResumeListener,
		ProcessUpdateListener, ProcessErrorListener, ProcessFinishListener {

	private static var logger:Logger = LogManager.getLogger("org.as2lib.test.unit.XmlSocketTestListener");

	private var socket:XMLSocket;

	/**
	 * Constructs a new {@code XmlSocketTestListener} instance.
	 *
	 * <p>If {@code host} is not specified, {@code "localhost"} is used. If
	 * {@code port} is not specified, {@code 3212} is used.
	 *
	 * @param host the host of the connection to open
	 * @param port the port of the connection to open
	 */
	public function XmlSocketTestListener(host:String, port:Number) {
		if (host == null) {
			host = "localhost";
		}
		if (port == null) {
			port = 3212;
		}
		socket = new XMLSocket();
		socket.connect(host, port);
	}

	public function onProcessStart(process:Process):Void {
		socket.send(new XML("<start>Started execution of tests.</start>"));
	}

	public function onProcessUpdate(process:Process):Void {
		var testRunner:TestRunner = TestRunner(process);
		if (testRunner != null) {
			var methodInfo:TestMethod = testRunner.getCurrentTestMethod();
			if (methodInfo != null) {
				socket.send(new XML("<update>Executing " + methodInfo.getName() + "</update>"));
			}
		}
	}

	public function onProcessPause(process:Process):Void {
		var testRunner:TestRunner = TestRunner(process);
		if (testRunner != null) {
			socket.send(new XML("<pause>Paused execution at " +
					testRunner.getCurrentTestMethod().getName() + "</pause>"));
		}
	}

	public function onProcessResume(process:Process):Void {
		var testRunner:TestRunner = TestRunner(process);
		if (testRunner != null) {
			socket.send(new XML("<resume>Resumed execution at " +
					testRunner.getCurrentTestMethod().getName() + "</resume>"));
		}
	}

	public function onProcessFinish(process:Process):Void {
		if (!(process instanceof TestRunner)) {
			if (logger.isErrorEnabled()) {
				logger.error("The process [" + process + "] this listener was added to " +
						"is not of the expected type 'org.as2lib.test.unit.TestRunner'.");
			}
		}
		var testResult:TestResult = TestRunner(process).getTestResult();
		var testCaseResults:Array = testResult.getTestCaseResults();
		socket.send(new XML("<message>-</message>"));
		socket.send(new XML("<message><![CDATA[*** Test " + testResult.getName() + " (" +
				testCaseResults.length + " Tests) [" + testResult.getOperationTime() +
				"ms] ***]]></message>"));
		for (var i:Number = 0; i < testCaseResults.length; i++) {
			var testCaseResult:TestCaseResult = testCaseResults[i];
			if (testCaseResult.hasErrors()) {
				socket.send(new XML("<error><![CDATA[" + testCaseResult.toString() + "]]></error>"));
			}
			else {
				socket.send(new XML("<message><![CDATA[" + testCaseResult.toString() + "]]></message>"));
			}
		}
		socket.send(new XML("<finish hasErrors='" + testResult.hasErrors() + "'/>"));
	}

	public function onProcessError(process:Process, error):Boolean {
		socket.send(new XML("<error><![CDATA[Error was raised during test execution:\n" + error + "]]></error>"));
		return false;
	}

}