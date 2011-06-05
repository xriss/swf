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
import org.as2lib.test.unit.Test;
import org.as2lib.test.unit.TestCaseHelper;
import org.as2lib.test.unit.TestSuite;
import org.as2lib.util.ClassUtil;
import org.as2lib.util.AccessPermission;
import org.as2lib.env.reflect.PackageInfo;
import org.as2lib.env.reflect.TypeInfo;

/**
 * {@code TestSuiteFactory} collects test cases and puts them in a test suite. You
 * may either {@link #collectAllTestCases collect all test cases} or
 * {@link #collectTestCases all in a specific package and sub-packages}.
 *
 * <p>Note that only test cases which are compiled into the swf can be collected. There
 * are two ways to compile test cases into the swf.
 *
 * <ul>
 *   <li>
 *     Reference test cases before compilation. For example in the first frame of the
 *     fla or in the static main method.
 *   </li>
 *   <li>
 *     Use MTASC to inject test cases into the swf; either by declaring them manually
 *     or by using the Mtasc Ant Task of As2ant.
 *   </li>
 * </ul>
 *
 * <p>If you are using Apache Ant you may use the Mtasc Ant Task of As2ant to compile
 * test cases of a specific package with a specific suffix into the swf. In the
 * following example all ActionScript classes in the test directory with the suffix
 * "Test" are compiled into the swf.
 *
 * <pre>
 *   &lt;target name="tests" description="run tests"&gt;
 *     &lt;mtasc src="${src.dir}/org/as2lib/app/conf/MtascApplication.as" swf="${test.swf}"
 *         classpath="${src.dir};${test.dir}" main="yes" version="8"&gt;
 *       &lt;srcset dir="${test.dir}"&gt;
 *         &lt;include name="**\/*Test.as"/&gt;
 *       &lt;/srcset&gt;
 *     &lt;/mtasc&gt;
 *     &lt;unittest swf="${test.swf}" flashplayer="${player.exe}"/&gt;
 *   &lt;/target&gt;
 * </pre>
 *
 * <p>The Mtasc entry point may then use this factory to collect all test cases and
 * run them.
 *
 * <code>
 *   import org.as2lib.test.unit.TestSuite;
 *   import org.as2lib.test.unit.TestSuiteFactory;
 *   import org.as2lib.test.unit.XmlSocketTestListener;
 *
 *   class main.Mtasc {
 *
 *       public function Mtasc(Void) {
 *       }
 *
 *       public function init(container:MovieClip):Void {
 *           var factory:TestSuiteFactory = new TestSuiteFactory();
 *           var tests:TestSuite = factory.collectAllTestCases();
 *           tests.addListener(new XmlSocketTestListener());
 *           tests.start();
 *       }
 *
 *   }
 * </code>
 *
 * <p>If you are using as As2lib Configuration as in the above case running all test
 * cases can be even simpler.
 *
 * <code>
 *   import org.as2lib.app.conf.AbstractConfiguration;
 *   import org.as2lib.app.conf.UnitTestExecution;
 *   import org.as2lib.test.unit.XmlSocketTestListener;
 *
 *   class main.Mtasc extends AbstractConfiguration {
 *
 *       public function Mtasc(Void) {
 *       }
 *
 *       public function init(container:MovieClip):Void {
 *           initProcess(new UnitTestExecution(new XmlSocketTestListener()));
 *       }
 *
 *   }
 * </code>
 *
 * <p>If you want to block the collection of a test case you can add a static
 * {@code blockCollecting} method to it that returns {@code true}. This is useful
 * when you move common test code of multiple test cases into an abstract base test
 * case. In such a case the abstract base test case shall not be instantiated and
 * run, but just its concreate sub test cases.
 *
 * <code>
 *   import org.as2lib.test.unit.TestCase;
 *
 *   class MyAbstractTest extends TestCase {
 *
 *       public static function blockCollecting(Void):Boolean {
 *	         return true;
 *       }
 *
 *   }
 * </code>
 *
 * @author Martin Heidegger
 * @author Simon Wacker
 */
class org.as2lib.test.unit.TestSuiteFactory extends BasicClass {

	/**
	 * Constructs a new {@code TestSuiteFactory} instance.
	 */
	public function TestSuiteFactory(Void) {
	}

	/**
	 * Collects all available test cases. Test cases are available if they were
	 * compiled into the swf. They must be referenced to force compilation (importing
	 * them is not sufficient).
	 *
	 * @return a test suite that contains all available test cases
	 */
	public function collectAllTestCases(Void):TestSuite {
		return collectTestCases(PackageInfo.getRootPackage(), true);
	}

	/**
	 * Collects all available test cases contained in the given package and possibly
	 * subpackages. Test cases are available if they were compiled into the swf. They
	 * must be referenced to force compilation (importing them is not sufficient).
	 *
	 * <p>If {@code recursive} is {@code true} or not specified subpackages will be
	 * searched through. If it is {@code false} test cases of subpackages will not be
	 * included.
	 *
	 * @param package the base package to search for test cases
	 * @param recursive shall subpackages also be searched through?
	 * @return a test suite that contains all available test cases
	 */
	public function collectTestCases(package:PackageInfo, recursive:Boolean):TestSuite {
		if (recursive == null) {
			recursive = true;
		}
		var result:TestSuite = new TestSuite("<Generated Test Suite>");
		collectAgent(package, result, recursive);
		return result;
	}

	/**
	 * Collects contained in the given package and possibly subpackages.
	 *
	 * <p>Note: If you want to block the collection of a test case add a static
	 * {@code blockCollecting} method that returns {@code true}.
	 *
	 * <code>
	 *   import org.as2lib.test.unit.TestCase;
	 *
	 *   class MyAbstractTest extends TestCase {
	 *
	 *       public static function blockCollecting(Void):Boolean {
	 *	         return true;
	 *       }
	 *
	 *   }
	 * </code>
	 *
	 * @param package the base package to search for test cases
	 * @param testSuite the test suite to add found test cases to
	 * @param recursive shall subpackages also be searched through?
	 */
	private function collectAgent(package:PackageInfo, testSuite:TestSuite, recursive:Boolean):Void {
		var members:Array = package.getMemberClasses();
		for (var i:Number = 0; i < members.length; i++) {
			var childType:TypeInfo = members[i];
			var child:Function = childType.getType();
			if (ClassUtil.isImplementationOf(child, Test) &&
					child != Test &&
					!child.blockCollecting() &&
					!ClassUtil.isSubClassOf(child, TestCaseHelper) &&
					!ClassUtil.isSubClassOf(child, TestSuite)) {
				testSuite.addTest(ClassUtil.createCleanInstance(child));
			}
		}
		var subPackages:Array = package.getMemberPackages();
		for (var j:Number = 0; j < subPackages.length && recursive; j++) {
			var subPackage:PackageInfo = subPackages[j];
			collectAgent(subPackage, testSuite, true);
		}
	}

}