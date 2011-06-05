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

import org.as2lib.app.exec.AbstractProcess;
import org.as2lib.app.exec.Process;
import org.as2lib.test.unit.LoggerTestListener;
import org.as2lib.test.unit.TestSuite;
import org.as2lib.test.unit.TestSuiteFactory;

/**
 * {@code UnitTestExecution} is a process that executes all test cases that are
 * available at run-time.
 * 
 * <p>Use this class to simplify your test case execution. You can use this
 * class within your application initialization to start and configure the unit
 * testing system.
 * 
 * <p>Example:
 * <code>
 *   import org.as2lib.app.conf.AbstractConfiguration;
 *   import com.domain.test.*
 *   
 *   class main.Configuration extends AbstractConfiguration {
 *     public function init(Void):Void {
 *       super.init(UnitTestExecution);
 *     }
 *     private function setReferences(Void):Void {
 *       use(MyTestCase);
 *       use(MyTestCase2);
 *       use(MyTestCase3);
 *     }
 *   }
 * </code>
 * 
 * @author Martin Heidegger
 * @author Simon Wacker
 * @version 2.0
 */
class org.as2lib.app.conf.UnitTestExecution extends AbstractProcess implements Process {
	
	/** The supplied test listeners to use. */
	private var testListeners:Array;
	
	/**
	 * Constructs a new {@code UnitTestExecution} instance.
	 * 
	 * <p>If no test listener was given, a {@link LoggerTestListener} instance will be
	 * used.
	 * 
	 * @param * any number of test listeners to add to the test suite
	 */
	public function UnitTestExecution() {
		if (arguments.length == 0) {
			testListeners = [LoggerTestListener.getInstance()];
		}
		else {
			testListeners = arguments.concat();
		}
	}
	
	/**
	 * Runs all available test cases.
	 */
	public function run() {
		var factory:TestSuiteFactory = new TestSuiteFactory();
		var testSuite:TestSuite = factory.collectAllTestCases();
		for (var i:Number = 0; i < testListeners.length; i++) {
			testSuite.addListener(testListeners[i]);
		}
		startSubProcess(testSuite);
	}
	
}