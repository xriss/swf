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
import org.as2lib.core.BasicInterface;

/**
 * {@code ProcessUpdateListener} can be implemented by classes which want to be
 * notified when a process updates. An instance of the implementing class can then
 * be registered as listener at the process to observe.
 *
 * <p>An update event is for example distributed when the next few bytes of a file
 * have been loaded or some other progress is made. Refer to the documentation of
 * the observed process for details on when it distributes update events.
 *
 * <p>Note that {@code start}, {@code pause}, {@code resume}, {@code error} and
 * {@code finish} are not considered updates.
 *
 * @author Martin Heidegger
 * @author Simon Wacker
 * @version 2.0
 * @see Process
 * @see Process#addListener
 */
interface org.as2lib.app.exec.ProcessUpdateListener extends BasicInterface {

	/**
	 * Is executed when the observed process updates.
	 *
	 * @param process the process that updated
	 */
	public function onProcessUpdate(process:Process):Void;

}