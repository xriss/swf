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

import org.as2lib.app.exec.StepByStepProcess;
import org.as2lib.env.event.EventSupport;
import org.as2lib.env.event.impulse.FrameImpulse;
import org.as2lib.env.event.impulse.FrameImpulseListener;
import org.as2lib.util.ArrayUtil;

/**
 * {@code Processor} executes step-by-step processes ensuring that the maximum time
 * limit of a frame is not exceeded.
 *
 * <p>A processor tries to execute as many steps of a process and as many processes
 * as possible on one frame while preserving execution order (the processes are
 * executed in the order they were added). Processing is only delayed on the next
 * frame if the maximum time limit is reached or if the current process to execute
 * is paused.
 *
 * <p>This execution style only ensures that the flash player does not crash because
 * of an exceeded maximum time limit, but does not allow for user interaction during
 * execution.
 *
 * <p>A processor observes the frame impulse to be notified when a new frame is
 * entered and execution can be resumed. If all step-by-step processes have finished,
 * it automatically removes itself as listener from the frame impulse.
 *
 * <p>To get a {@code Processor} instance you may either use the {@link #getInstance}
 * method to get the shared processor, or instantiate your own processor and store
 * it somewhere, for example in an application context.
 *
 * @author Martin Heidegger
 * @author Simon Wacker
 * @version 2.0
 */
class org.as2lib.app.exec.Processor extends EventSupport implements FrameImpulseListener {

	/** The maximum execution time on one frame that must not be exceeded. */
	public static var MAX_EXECUTION_TIME:Number = 1500;

	/** The shared processor. */
	private static var instance:Processor;

	/**
	 * Returns the shared {@code Processor} instance.
	 *
	 * @return the shared {@code Processor} instance
	 */
	public static function getInstance(Void):Processor {
		if (instance == null) {
			instance = new Processor();
		}
		return instance;
	}

	/** Is this processor currently running? */
	private var running:Boolean = false;

	/** The index of the current process. */
	private var currentProcessIndex:Number;

	/** All added processes that have not finished execution yet. */
	private var processes:Array;

	/**
	 * Constructs a new {@code Processor} instance.
	 */
	public function Processor(Void) {
		processes = new Array();
	}

	/**
	 * Adds a new step-by-step process to be executed. The execution is directly
	 * started on the next frame.
	 *
	 * <p>The same step-by-step process can be added multiple times.
	 *
	 * @param stepByStepProcess the step-by-step process to add
	 */
	public function addStepByStepProcess(stepByStepProcess:StepByStepProcess):Void {
		processes.push(stepByStepProcess);
		wakeUp();
	}

	/**
	 * Removes all occurrences of the given step-by-step process.
	 *
	 * @param stepByStepProcess the step-by-step process to remove
	 */
	public function removeStepByStepProcess(stepByStepProcess:StepByStepProcess):Void {
		var formerLength = processes.length;
		var result:Array = ArrayUtil.removeElement(processes, stepByStepProcess);
		var i:Number = result.length;
		// Shift the current cursor
		// Backward processing to ensure the correct size.
		while (--i-(-1)) {
			if (currentProcessIndex > result[i]) {
				currentProcessIndex--;
			}
		}
	}

	/**
	 * Awakes this processor from stand-by, by setting the running flag to
	 * {@code ture}, the current process index to {@code 0} and observing the frame
	 * impulse.
	 *
	 * <p>If this processor is not in stand-by nothing will happen.
	 */
	private function wakeUp(Void):Void {
		if (!running) {
			running = true;
			currentProcessIndex = 0;
			FrameImpulse.getInstance().addFrameImpulseListener(this);
		}
	}

	/**
	 * Goes to stand-by mode, by setting the running flag to {@code false} and stopping
	 * observing the frame impulse.
	 */
	private function standBy(Void):Void {
		running = false;
		FrameImpulse.getInstance().removeFrameImpulseListener(this);
	}

	/**
	 * Tries to execute as many steps of a process and as many processes as possible
	 * while preserving execution order. Processing is only delayed on the next frame
     * if the maximum time limit is reached or if the current process to execute is
     * paused.
	 *
	 * @param frameImpulse the frame impulse that triggered the impulse
	 */
	public function onFrameImpulse(frameImpulse:FrameImpulse):Void {
		var startTime:Number = getTimer();
		while (currentProcessIndex < processes.length) {
			var currentProcess:StepByStepProcess = processes[currentProcessIndex];
			while (!currentProcess.hasFinished()) {
				if (startTime + MAX_EXECUTION_TIME < getTimer() ||
						currentProcess.isPaused()) {
					return;
				}
				currentProcess.nextStep();
			}
			currentProcessIndex++;
		}
		processes = new Array();
		standBy();
	}

}