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
import org.as2lib.app.exec.Batch;
import org.as2lib.app.exec.NextProcessListener;
import org.as2lib.app.exec.Process;
import org.as2lib.app.exec.ProcessErrorListener;
import org.as2lib.app.exec.ProcessFinishListener;
import org.as2lib.app.exec.ProcessPauseListener;
import org.as2lib.app.exec.ProcessResumeListener;
import org.as2lib.app.exec.ProcessStartListener;
import org.as2lib.app.exec.ProcessUpdateListener;
import org.as2lib.env.except.IllegalArgumentException;
import org.as2lib.env.except.IllegalStateException;

/**
 * {@code AbstractBatch} implements methods commonly needed by {@code Batch}
 * implementations.
 *
 * @author Simon Wacker
 */
class org.as2lib.app.exec.AbstractBatch extends AbstractProcess implements Batch,
		ProcessStartListener, ProcessUpdateListener, ProcessPauseListener,
		ProcessResumeListener, NextProcessListener, ProcessErrorListener,
		ProcessFinishListener {

	/** All added processes. */
	private var processes:Array;

	/** The index of the process that is currently running. */
	private var currentProcessIndex:Number;

	/** The currently running process. */
	private var currentProcess:Process;

	/** Loading progress in percent. */
	private var percentage:Number;

	/**
	 * Constructs a new {@code AbstractBatch} instance.
	 */
	private function AbstractBatch(Void) {
		processes = new Array();
		percentage = 0;
		started = false;
		finished = false;
	}

	/**
	 * Starts the execution of this batch.
	 */
    public function start() {
    	if (!started) {
			currentProcessIndex = -1;
			finished = false;
			working = true;
			percentage = 0;
			delete endTime;
			startTime = getTimer();
			started = true;
			if (processes.length == 0) {
				distributeStartEvent();
			}
			nextProcess();
    	}
	}

	/**
	 * Starts the next process or finishes this batch if there is no next process.
	 *
	 * @see #onProcessStart
	 * @see #finish
	 */
	private function nextProcess(Void):Void {
		getCurrentProcess(true).setParentProcess(null);
		getCurrentProcess(true).removeListener(this);
		if (currentProcessIndex < processes.length - 1) {
			updatePercentage(100);
			currentProcess = null;
			currentProcessIndex++;
			var process:Process = processes[currentProcessIndex];
			process.setParentProcess(this);
			process.addListener(this);
			process.start();
		}
		else {
			finish();
		}
	}

	/**
	 * Returns the name of this batch. If this batch has no name, the name of the
	 * currently running process will be returned.
	 *
	 * @return this batch's name
	 */
	public function getName(Void):String {
		var result:String = super.getName();
		if (result == null) {
			result = getCurrentProcess(true).getName();
		}
		return result;
	}

	public function getPercentage(Void):Number {
		return percentage;
	}

	/**
	 * Updates the loading progress percentage.
	 *
	 * @param percentage the progress percentage of the current process
	 */
	private function updatePercentage(percentage:Number):Void {
		this.percentage = 100 / getProcessCount() * (currentProcessIndex + (1 / 100 * percentage));
	}

	public function getParentProcess(Void):Process {
		return parent;
	}

	/**
	 * Sets the parent of this process.
	 *
	 * @throws IllegalArgumentException if this process is itself a parent of the
	 * given process (to prevent infinite recursion)
	 * @param parentProcess the new parent process of this process
	 */
	public function setParentProcess(parentProcess:Process):Void {
		this.parent = parentProcess;
		do {
			if (parentProcess == this) {
				throw new IllegalArgumentException("A process may not be the parent of its " +
						"parent process.", this, arguments);
			}
			parentProcess = parentProcess.getParentProcess();
		}
		while (parentProcess != null);
	}

	public function getCurrentProcess(includingBatches:Boolean):Process {
		if (includingBatches || currentProcess == null) {
			return processes[currentProcessIndex];
		}
		return currentProcess;
	}

	public function getAllProcesses(Void):Array {
		return processes.concat();
	}

	/**
	 * Adds the given process to execute to this batch.
	 *
	 * <p>It is possible to add the same process more than once. It will be executed
	 * as often as you add it.
	 *
	 * <p>Note that the given process will not be added if it is this batch itself or
	 * if it is {@code null}
	 *
	 * @param process the process to add
	 */
	public function addProcess(process:Process):Void {
		if (process != null && process != this) {
			processes.push(process);
			updatePercentage(100);
		}
	}

	/**
	 * Adds all given processes which implement the {@link Process} interface.
	 *
	 * @param processes the processes to add
	 * @see #addProcess
	 */
	public function addAllProcesses(processes:Array):Void {
		for (var i:Number = 0; i < processes.length; i++) {
			addProcess(Process(processes[i]));
		}
	}

	/**
	 * Removes all occurrences of the given process.
	 *
	 * @param process the process to remove
	 */
	public function removeProcess(process:Process):Void {
		if (process != null) {
			var i:Number = processes.length;
			while (--i-(-1)) {
				if (processes[i] == process) {
					if (i == currentProcessIndex) {
						throw new IllegalArgumentException("Process [" + process + "] is " +
								"currently running and can thus not be removed.", this, arguments);
					}
					if (i < currentProcessIndex) {
						currentProcessIndex--;
					}
					processes.slice(i, i);
				}
			}
		}
	}

	public function removeAllProcesses(Void):Void {
		if (started) {
			throw new IllegalStateException("All processes cannot be removed when batch is " +
					"running.", this, arguments);
		}
		processes = new Array();
	}

	/**
	 * Gives the given process highest priority: the given process will be started
	 * as soon as the currently running process finishes.
	 *
	 * @param process the process to run next
	 */
	public function moveProcess(process:Process):Void {
		if (process != null) {
			var i:Number = processes.length;
			while(--i-(-1)) {
				if (processes[i] == process) {
					if (i != currentProcessIndex) {
						if (i < currentProcessIndex) {
							currentProcessIndex--;
						}
						processes.slice(i, i);
						processes.splice(currentProcessIndex + 1, 0, process);
					}
				}
			}
		}
	}

	public function getProcessCount(Void):Number {
		return processes.length;
	}

	/**
	 * Distributes a start event if the started process is the first process; also
	 * distributes a next process and an update event.
	 *
	 * @param process the process that was started
	 */
	public function onProcessStart(process:Process):Void {
		if (currentProcessIndex == 0) {
			distributeStartEvent();
		}
		distributeNextProcessEvent();
		distributeUpdateEvent();
	}

	/**
	 * Updates the percentage and distributes an update event.
	 *
	 * @param process the process that was updated
	 */
	public function onProcessUpdate(process:Process):Void {
		var percentage:Number = process.getPercentage();
		if (percentage != null) {
			updatePercentage(percentage);
		}
		distributeUpdateEvent();
	}

	/**
	 * Distributes a process pause event for the given process.
	 *
	 * @param process the process that has paused its execution
	 */
	public function onProcessPause(process:Process):Void {
		distributePauseEvent();
	}

	/**
	 * Distributes a process resume event for the given process.
	 *
	 * @param process the process that has resumed its execution
	 */
	public function onProcessResume(process:Process):Void {
		distributeResumeEvent();
	}

	/**
	 * Updates the current process and distributes a next-process event.
	 *
	 * @param batch the batch that started the next process
	 */
	public function onNextProcess(batch:Batch):Void {
		currentProcess = batch.getCurrentProcess();
		distributeNextProcessEvent();
	}

	/**
	 * Distributes an error event with the given error.
	 *
	 * @param process the process that raised the error
	 * @param error the raised error
	 */
	public function onProcessError(process:Process, error):Boolean {
		return distributeErrorEvent(error);
	}

	/**
	 * Executes the next process if the current process has finished.
	 *
	 * @param process the finished process
	 * @see #nextProcess
	 */
	public function onProcessFinish(process:Process):Void {
		if (getCurrentProcess(true).hasFinished()) {
			nextProcess();
		}
	}

	/**
	 * Distributes a next-process event.
	 *
	 * <p>Note that this implementation is empty. But you may override it in subclasses
	 * to distribute a next-process event.
	 */
	public function distributeNextProcessEvent(Void):Void {
	}

}