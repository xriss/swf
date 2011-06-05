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

import org.as2lib.app.exec.AbstractBatch;

/**
 * {@code BatchProcess} is a batch that acts to the outside like a process. Use this
 * batch if you want to treat multiple process executions like one execution, otherwise
 * use {@link SimpleBatch}.
 *
 * <p>This batch executes its child-processes after each other. This means that the
 * first child-process will be executed at the beginning, the second after the first
 * finished execution and so on.
 *
 * <p>You can seamlessly add this batch to other {@code BatchProcess} instances or
 * to {@code SimpleBatch} instances to build process trees.
 *
 * <p>Because this batch acts like a process it does not distribute batch events but
 * only process events:
 *
 * <ul>
 *   <li>{@link ProcessStartListener}</li>
 *   <li>{@link ProcessUpdateListener}</li>
 *   <li>{@link ProcessPauseListener}</li>
 *   <li>{@link ProcessResumeListener}</li>
 *   <li>{@link ProcessErrorListener}</li>
 *   <li>{@link ProcessFinishListener}</li>
 * </ul>
 *
 * @author Martin Heidegger
 * @author Simon Wacker
 * @version 2.0
 */
class org.as2lib.app.exec.BatchProcess extends AbstractBatch {

	/**
	 * Constructs a new {@code BatchProcess} instance.
	 */
	public function BatchProcess(Void) {
	}

	/**
	 * Distributes a process error event with the given error and finishes this batch
	 * if none of the process error listeners consumed the event.
	 *
	 * @param error the error to distribute
	 * @return {@code true} if the event was consumed else {@code false}
	 */
	private function distributeErrorEvent(error):Boolean {
		var consumed:Boolean = super.distributeErrorEvent(error);
		if (!consumed) {
			finish();
		}
		return consumed;
	}

}