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

import org.as2lib.app.exec.Executable;

/**
 * {@code ForEachExecutable} can be implemented by executables which need to be
 * executed for all childs of an object.
 *
 * @author Martin Heidegger
 * @author Simon Wacker
 * @version 1.0
 */
interface org.as2lib.app.exec.ForEachExecutable extends Executable {

	/**
	 * Iterates over the passed-in {@code object} and invokes the {@link #execute}
	 * method for every member passing-in the member itself, the name of the member and
	 * the passed-in {@code object}.
	 *
	 * @param object the object to iterate over
	 * @return the results of all executions
	 */
	public function forEach(object):Array;

}