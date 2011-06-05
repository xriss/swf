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

import org.as2lib.test.unit.TestCase;
import org.as2lib.test.unit.TestCaseRunner;

/**
 * {@code TestCaseHelper} allows you to break apart tests.
 *
 * <p>When you have two implementations of the same interface, these implementations
 * probably have some common functionalities which are enforced by the interface. If
 * this is the case there are two ways for writing tests for these implementations
 * without duplicating test code.
 *
 * <p>The first way is to create a common base test case that implements the common
 * tests. A problem with this approach is that a class may share common functionalities
 * with more than one class based on different interfaces. Our class in question
 * {@code ClassOne} may for example implement {@code InterfaceOne} and {@code InterfaceTwo}.
 * {@code ClassTwo} implements {@code InterfaceOne} and {@code ClassThree} implements
 * {@code InterfaceTwo}. If we went with the first way, the test case for {@code ClassOne}
 * had to extend two base test cases, which is not possible in ActionScript because
 * multiple inheritance is not supported.
 *
 * <p>The second approach is to create helper test cases for the common functionalities.
 * This means that you create a helper test case per interface which can be used by
 * other test cases which test implementations of the interfaces.
 *
 * <p>Interface:
 *
 * <code>
 *   interface MyInterface {
 *
 *       public function addObject(object):Void;
 *       public function containsObject(object):Void;
 *       public function removeObject(object):Void;
 *
 *   }
 * </code>
 *
 * <p>Implementation 1:
 *
 * <code>
 *   import org.as2lib.util.ArrayUtil;
 *
 *   class MyImplementationA implements MyInterface {
 *
 *       private var array:Array;
 *
 *       public fucntion MyImplementationA() {
 *           array = new Array();
 *       }
 *
 *       public function addObject(object):Void {
 *           removeObject(object);
 *           array.push(object);
 *       }
 *
 *       public function removeObject(object):Void {
 *           ArrayUtil.removeElement(array, object);
 *       }
 *
 *       public function containsObject(object):Boolean {
 *           for (var i:Number = 0; i < array.length; i++) {
 *               if (array[i] === object) {
 *                   return true;
 *               }
 *           }
 *           return false;
 *       }
 *
 *   }
 * </code>
 *
 * <p>Implementation 2:
 *
 * <code>
 *   class MyImplementationB extends MyImplementationA {
 *
 *       public function containsObject(object):Boolean {
 *           for (var i:Number = array.length-1; i > 0; i++) {
 *               if (array[i] === object) {
 *                   return true;
 *               }
 *           }
 *           return false;
 *       }
 *
 *   }
 * </code>
 *
 * <p>Test case for interface:
 *
 * <code>
 *   import org.as2lib.test.unit.TestCaseHelper;
 *   import org.as2lib.test.mock.MockControl;
 *
 *   class MyInterfaceTest extends TestCaseHelper {
 *
 *       public function test(instance:MyInterface) {
 *           var mockControl:MockControl = new MockControl(Object);
 *           mockControl.replay();
 *           var mock:Object = mockControl.getMock();
 *           assertfalse("Object should not be contained directly after creation.",
 *                   instance.containsObject(mock));
 *           instance.addObject(mock);
 *           assertTrue("Object should be contained after it has been added.",
 *                   instance.containsObject(mock));
 *           instance.removeObject(mock);
 *           assertfalse("Object should not be contained after removal.",
 *                   instance.containsObject(mock));
 *           instance.addObject(mock);
 *           instance.addObject(mock);
 *           instance.removeObject(mock);
 *           assertfalse("Object should not be contained after being added twice " +
 *                   "and removed once.", instance.containsObject(mock));
 *           mockControl.verify();
 *       }
 *
 *   }
 * </code>
 *
 * <p>Test case for implementation A:
 *
 * <code>
 *      import org.as2lib.test.unit.TestCase;
 *
 *      class MyImplementationATest extends TestCase {
 *
 *          public function testMyInterface() {
 *              var myInterface:MyInterfaceTest = new MyInterfaceTest(this);
 *              myInterface.test(new MyImplementationA());
 *          }
 *
 *      }
 * </code>
 *
 * <p>Test case for implementation B:
 *
 * <code>
 *      import org.as2lib.test.unit.TestCase;
 *
 *      class MyImplementationBTest extends TestCase {
 *
 *          public function testMyInterface() {
 *              var myInterface:MyInterfaceTest = new MyInterfaceTest(this);
 *              myInterface.test(new MyImplementationB());
 *          }
 *
 *      }
 * </code>
 *
 * @author Martin Heidegger
 * @author Simon Wacker
 * @version 2.0
 */
class org.as2lib.test.unit.TestCaseHelper extends TestCase {

	/** The test case to do assertions on. */
	private var testCase:TestCase;

	/**
	 * Blocks the collection of this class by the
	 * {@code TestSuiteFactory#collectAllTestCases} method.
	 *
	 * @return {@code true} to block collection
	 */
	public static function blockCollecting(Void):Boolean {
		return true;
	}

	/**
	 * Constructs a new {@code TestCaseHelper} instance.
	 *
	 * @param testCase the test case to do assertions on
	 */
	public function TestCaseHelper(testCase:TestCase) {
		this.testCase = testCase;
		testRunner = TestCaseRunner(testCase.getTestRunner());
	}

}