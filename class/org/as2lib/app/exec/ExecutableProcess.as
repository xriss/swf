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
import org.as2lib.app.exec.Executable;
import org.as2lib.util.MethodUtil;

/**
 * {@code ExecutableProcess} wraps a {@link Executable} instance that shall be
 * executed as {@link Process}.
 *
 * <p>This allows easy integration of executables into the process infrastructure,
 * and makes it possible to for example use executables with batches.
 *
 * @author Martin Heidegger
 * @author Simon Wacker
 * @version 1.0
 */
class org.as2lib.app.exec.ExecutableProcess extends AbstractProcess {

	/** The executable to execute. */
	private var executable:Executable;

	/** The arguments to pass to the executable on execution. */
	private var args:Array;

	/**
	 * Creates a new {@code ExecutableProcess} instance.
	 *
	 * @param executable the executeable to execute when this process is started
	 */
	public function ExecutableProcess(executable:Executable, args:Array) {
		this.executable = executable;
		this.args = args;
	}

	/**
	 * Executes the executable.
	 */
	private function run() {
		MethodUtil.invoke("execute", executable, args);
	}

}