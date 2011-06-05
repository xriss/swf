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

import org.as2lib.core.BasicInterface;

/**
 * {@code Executable} provides a common interface for the execution of a task. It is
 * similar to the {@link Process} interface but does not support asynchronous tasks.
 *
 * @author Simon Wacker
 * @author Martin Heidegger
 */
interface org.as2lib.app.exec.Executable extends BasicInterface {

	/**
	 * Executes the encapsulated task using the given arguments.
	 *
	 * @param * the arguments to use for executing the task
	 * @return the result of the execution
	 */
	public function execute();


	/**
	 * Executes the encapsulated task using the given arguments {@code args}.
	 *
	 * @param args the arguments to use for executing the task
	 * @return the result of the execution
	 */
	public function executeArguments(args:Array);
}