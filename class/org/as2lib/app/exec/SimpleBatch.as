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
import org.as2lib.app.exec.BatchErrorListener;
import org.as2lib.app.exec.BatchFinishListener;
import org.as2lib.app.exec.BatchStartListener;
import org.as2lib.app.exec.BatchUpdateListener;
import org.as2lib.app.exec.NextProcessListener;

/**
 * {@code SimpleBatch} is a simple implementation of the {@link Batch} interface.
 *
 * <p>This batch executes its child-processes after each other. This means that the
 * first child-process will be executed at the beginning, the second after the first
 * finished execution and so on.
 *
 * <p>This batch distributes process events:
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
 * <p>As well as batch events:
 *
 * <ul>
 *   <li>{@link BatchStartListener}</li>
 *   <li>{@link BatchUpdateListener}</li>
 *   <li>{@link NextProcessListener}</li>
 *   <li>{@link BatchErrorListener}</li>
 *   <li>{@link BatchFinishListener}</li>
 * </ul>
 *
 * <p>You can seamlessly add batch processes as child-processes to this batch. If the
 * added child-batch acts like a simple process (as does {@link BatchProcess}} this
 * batch will treat the child-batch like a simple process. If the added child-batch
 * acts like a real batch (as does this batch) it is treated as if it were not there,
 * this means as if the child-processes of the child-batch were directly added to this
 * batch.
 *
 * <p>If you want multiple processes to be treated as one process, use the
 * {@link BatchProcess}. If you want to group multiple processes, but still want them
 * to be independent and you want to be notified when the next process is executed use
 * this batch. If you simply do not care use this batch: it is more convenient to use
 * because of the properly typed batch events.
 *
 * @author Simon Wacker
 */
class org.as2lib.app.exec.SimpleBatch extends AbstractBatch {

	/**
	 * Constructs a new {@code SimpleBatch} instance.
	 */
	public function SimpleBatch(Void) {
		acceptListenerType(BatchStartListener);
		acceptListenerType(BatchUpdateListener);
		acceptListenerType(NextProcessListener);
		acceptListenerType(BatchErrorListener);
		acceptListenerType(BatchFinishListener);
	}

	/**
	 * Distributes process and batch start events, and process and batch error events
	 * if a listener threw an exception.
	 */
	private function distributeStartEvent(Void):Void {
		super.distributeStartEvent();
		try {
			var startDistributor:BatchStartListener = distributorControl.getDistributor(BatchStartListener);
			startDistributor.onBatchStart(this);
		}
		catch (exception:org.as2lib.env.event.EventExecutionException) {
			distributeErrorEvent(exception.getCause());
		}
	}

	/**
	 * Distributes process and batch update events, and process and batch error events
	 * if a listener threw an exception.
	 */
	private function distributeUpdateEvent(Void):Void {
		super.distributeUpdateEvent();
		try {
			var updateDistributor:BatchUpdateListener = distributorControl.getDistributor(BatchUpdateListener);
			updateDistributor.onBatchUpdate(this);
		}
		catch (exception:org.as2lib.env.event.EventExecutionException) {
			distributeErrorEvent(exception.getCause());
		}
	}

	/**
	 * Distributes process and batch update events.
	 *
	 * @see #distributeUpdateEvent
	 */
	private function distributePauseEvent(Void):Void {
		distributeUpdateEvent();
	}

	/**
	 * Distributes process and batch update events.
	 *
	 * @see #distributeUpdateEvent
	 */
	private function distributeResumeEvent(Void):Void {
		distributeUpdateEvent();
	}

	public function distributeNextProcessEvent(Void):Void {
		if (currentProcessIndex > 0 || getParentProcess() == null) {
			try {
				var nextProcessDistributor:NextProcessListener = distributorControl.getDistributor(NextProcessListener);
				nextProcessDistributor.onNextProcess(this);
			}
			catch (exception:org.as2lib.env.event.EventExecutionException) {
				distributeErrorEvent(exception.getCause());
			}
		}
	}

	/**
	 * Distributes a process error event, and a batch error event if none of the
	 * process error listeners consumed the event. If neither a process error listener
	 * nor a batch error listener consumed the event, this batch will be finished.
	 *
	 * @param error the error that occurred
	 * @return {@code true} if the event was consumed else {@code false}
	 */
	private function distributeErrorEvent(error):Boolean {
		var consumed:Boolean = super.distributeErrorEvent(error);
		if (!consumed) {
			var errorDistributor:BatchErrorListener = distributorControl.getDistributor(BatchErrorListener);
			consumed = errorDistributor.onBatchError(this, error);
		}
		if (!consumed) {
			finish();
		}
		return consumed;
	}

	/**
	 * Distributes process and batch finish events, and process and batch error events
	 * if a listener threw an exception.
	 */
	private function distributeFinishEvent(Void):Void {
		super.distributeFinishEvent();
		try {
			var finishDistributor:BatchFinishListener = distributorControl.getDistributor(BatchFinishListener);
			finishDistributor.onBatchFinish(this);
		}
		catch (exception:org.as2lib.env.event.EventExecutionException) {
			distributeErrorEvent(exception.getCause());
		}
	}

}