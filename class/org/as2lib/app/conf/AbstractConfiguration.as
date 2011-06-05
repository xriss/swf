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
import org.as2lib.util.ClassUtil;

/**
 * {@code AbstractConfiguration} provides helper methods to make your configuration
 * simpler. It provides helper methods to start processes, that are useful in many
 * situations, like when you need to run a {@code TestRunner} or an arbitrary
 * action template.
 * 
 * @author Martin Heidegger
 * @author Simon Wacker
 * @version 2.0
 */
class org.as2lib.app.conf.AbstractConfiguration extends AbstractProcess {
	
	/**
	 * @overload #initClass
	 * @overload #initConfig
	 */
	public function init():Void {
		if (typeof(arguments[0]) == "function") {
			initClass(arguments[0]);
			return;
		}
		if (arguments[0] instanceof Process) {
			initProcess(arguments[0]);
			return;
		}
	}
	
	/**
	 * Instantiates the given {@code clazz} with noe constructor arguments if it is an
	 * implementation of the {@link Process} interface and starts the process.
	 * 
	 * @param clazz the process class to instantiate and start
	 */
	public function initClass(clazz:Function):Void {
		if (ClassUtil.isImplementationOf(clazz, Process)) {
			initProcess(new clazz());
		}
	}
	
	/**
	 * Starts the given {@code process}.
	 * 
	 * @param process the process to start
	 */
	public function initProcess(process:Process):Void {
		process.start();
	}
	
	/**
	 * References the given {@code clazz}, so that it is included in the swf.
	 * 
	 * <p>Mtasc does not allow references without useage like: {@code MyTest;};
	 * so use this method to reference classes you want to be included in the swf:
	 * {@code use(MyTest);}. This referencing method is for example needed when you are
	 * working with test cases and want them to be included, so that they get executed.
	 *
	 * @param clazz the class that shall be included in the swf
	 */
	public function use(clazz:Function):Void {
	}
	
}