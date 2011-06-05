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

import org.as2lib.app.exec.AbstractTimeConsumer;
import org.as2lib.app.exec.Executable;
import org.as2lib.app.exec.Process;
import org.as2lib.app.exec.ProcessErrorListener;
import org.as2lib.app.exec.ProcessFinishListener;
import org.as2lib.app.exec.ProcessPauseListener;
import org.as2lib.app.exec.ProcessResumeListener;
import org.as2lib.app.exec.ProcessStartListener;
import org.as2lib.app.exec.ProcessUpdateListener;
import org.as2lib.app.exec.StepByStepProcess;
import org.as2lib.data.holder.Map;
import org.as2lib.data.holder.map.HashMap;
import org.as2lib.env.except.AbstractOperationException;
import org.as2lib.env.except.IllegalArgumentException;
import org.as2lib.util.MethodUtil;

/**
 * {@code AbstractProcess} provides the infrastructure for {@link Process}
 * implementations. It handles all process states, distributes events and provides
 * means for starting subprocesses. Subclasses must implement the {@link #run}
 * template method, which is responsible for doing the actual processing. The
 * {@code run} method can either do its job synchronously or asynchronously.
 *
 * <p>Synchronously means that all computations have been done as soon as the
 * {@code run} method returns; the finish event will be distributed directly
 * after the invocation of the {@code run} method.
 *
 * <code>
 *   class MySynchronousProcess extends AbstractProcess {
 *
 *       private var collaborator:MyCollaborator;
 *
 *       public function MySynchronousProcess(collaborator:MyCollaborator) {
 *           this.collaborator = collaborator;
 *       }
 *
 *       public function run() {
 *           var number:Number = collaborator.getNumber();
 *           collaborator.setNumber(number * 2);
 *       }
 *
 *   }
 * </code>
 *
 * <p>Asynchronously means that the {@code run} method needs more than one frame
 * to do its job (for example when files are loaded) and that processing is thus
 * not finished when the {@code run} method returns. In this case the {@code run}
 * method must designate that it has not finished processing when it returns by
 * setting the {@code working} flag to {@code true} and finish the process as soon
 * as the asynchrnous subprocess finishes.
 *
 * <code>
 *   class MyAsynchronousProcess extends AbstractProcess {
 *
 *       private var xml:XML;
 *
 *       public function MyAsynchronousProcess(xml:XML) {
 *           this.xml = xml;
 *       }
 *
 *       public function run() {
 *           var process:Process = this;
 *           xml.onLoad = function() {
 *               process["finish"]();
 *           }
 *           working = true;
 *           xml.load("test.xml");
 *       }
 *
 *   }
 * </code>
 *
 * @author Martin Heidegger
 * @author Simon Wacker
 * @version 2.0
 */
class org.as2lib.app.exec.AbstractProcess extends AbstractTimeConsumer implements
		Process, ProcessErrorListener, ProcessFinishListener {

	/** Is the execution currently paused? */
	private var paused:Boolean;

	/** Is this process currently working? */
	private var working:Boolean;

	/** All errors that occurred during this process's execution. */
	private var errors:Array;

	/** All subprocesses as keys and their callbacks as values. */
	private var subProcesses:Map;

	/** The parent of this process. */
	private var parent:Process;

	/** The name of this process. */
	private var name:String;

	/**
	 * Constructs a new {@code AbstractProcess} instance.
	 */
	private function AbstractProcess(Void) {
		errors = new Array();
		subProcesses = new HashMap();
		paused = false;
		working = false;
		acceptListenerType(ProcessStartListener);
		acceptListenerType(ProcessErrorListener);
		acceptListenerType(ProcessUpdateListener);
		acceptListenerType(ProcessPauseListener);
		acceptListenerType(ProcessResumeListener);
		acceptListenerType(ProcessFinishListener);
	}

	public function setParentProcess(parentProcess:Process):Void {
		parent = parentProcess;
		do {
			if (parentProcess == this) {
				throw new IllegalArgumentException("You cannot start a process " +
						"with itself as super process.", this, arguments);
			}
		} while (parentProcess = parentProcess.getParentProcess());
	}

	public function getParentProcess(Void):Process {
		return parent;
	}

	public function getName(Void):String {
		return name;
	}

	public function setName(name:String):Void {
		this.name = name;
	}

	/**
	 * Starts the given subprocess.
	 *
	 * <p>Registers this process as parent of the given subprocess and starts the
	 * subprocess immediately if necessary. This means that if you start multiple
	 * subprocesses they will be executed synchronously and not one after the other.
	 *
	 * <p>This process does not finish execution until all subprocesses have finished.
	 *
	 * <p>If the given subprocess finishes its corresponding callback will be invoked.
	 *
     * @param process the subprocess to start
     * @param args the arguments to start the subprocess with
     * @param callback the callback to execute if the subprocess finishes
	 */
	public function startSubProcess(process:Process, args:Array, callback:Executable):Void {
		// Don't do anything if the the process is already registered as sub-process.
		if (!subProcesses.containsKey(process)) {
			process.addListener(this);
			process.setParentProcess(this);
			subProcesses.put(process, callback);
			if (!isPaused()) {
				pause();
			}
			// Start if not started.
			// Re-start if finished.
			// Do nothing if started but not finished.
			if (!process.hasStarted() || process.hasFinished()) {
				MethodUtil.invoke("start", process, args);
			}
		}
	}

	/**
	 * Pauses this process and distributes a pause event.
	 *
	 * @see #distributePauseEvent
	 */
	public function pause(Void):Void {
		paused = true;
		distributePauseEvent();
	}

	/**
	 * Resumes this process and distributes a resume event.
	 *
	 * @see #distributeResumeEvent
	 */
	public function resume(Void):Void {
		paused = false;
		distributeResumeEvent();
		if (subProcesses.isEmpty() && !(this instanceof StepByStepProcess)) {
			finish();
		}
	}

	/**
	 * Prepares the start of this process by setting all flags and distributing a
	 * start event.
	 *
	 * @see #distributeStartEvent
	 */
	private function prepare(Void):Void {
		started = false;
		paused = false;
		finished = false;
		working = false;
		totalTime.setValue(0);
		restTime.setValue(0);
		distributeStartEvent();
		started = true;
	}

	/**
	 * Starts the execution of this process.
	 *
	 * <p>Any given parameters are passed to the {@code run} method.
	 *
	 * @param * any number of paramters of any type to pass to the {@code run} method
	 * @return the return value of the {@code run} method
	 * @see #run
	 */
    public function start() {
    	prepare();
    	var result;
    	try {
    		delete endTime;
    		startTime = getTimer();
			result = MethodUtil.invoke("run", this, arguments);
    	}
    	catch (exception) {
    		distributeErrorEvent(exception);
    	}
		if (!isPaused() && !isWorking()) {
			finish();
		}
		return result;
	}

	/**
	 * Returns whether this process is currently working.
	 *
	 * <p>This flag can be used to indicate that this process is asynchronous and has
	 * not finished execution when the {@link #run} method returns. Alternatively,
	 * {@link #pause} and {@link #resume} may be used.
	 *
	 * @return {@code true} if this process is currently working else {@code false}
	 */
	private function isWorking(Void):Boolean {
		return working;
	}

	/**
	 * Does the actual computations.
	 *
	 * <p>This method is abstract and must be implemented by subclasses.
	 *
	 * @throws AbstractOperationException if this method was not implemented by
	 * subclasses
	 */
	private function run() {
		throw new AbstractOperationException("This method is abstract and must be " +
				"implemented by subclasses.", this, arguments);
	}

	public function isPaused(Void):Boolean {
		return paused;
	}

	public function isRunning(Void):Boolean {
		return (!isPaused() && hasStarted());
	}

	/**
	 * Invoked when a subprocess finishes; removes itself as listener from the
	 * subprocess, executes the callback corresponding of the subprocess and resumes
	 * the execution of this process.
	 *
	 * @param process the subprocess that finished execution
	 * @see #resume
	 */
	public function onProcessFinish(process:Process):Void {
		if (subProcesses.containsKey(process)) {
			// removes current as listener
			process.removeListener(this);
			// Remove the process and executes the registered callback.
			subProcesses.remove(process).execute(process);
			// Resume exeuction
			resume();
		}
	}

    /**
     * Invoked when a subprocess has an error; distributes an error event with the
     * given error.
     *
     * @param process the subprocess where the error occurred
     * @param error the error that occurred
     * @return {@code true} if the error was consumed else {@code false}
     * @see #distributeErrorEvent
     */
	public function onProcessError(process:Process, error):Boolean {
		return distributeErrorEvent(error);
	}

	/**
	 * Finishes this process if it is currently running and has no more subprocesses
	 * to wait for. It sets all flags, stores the end time and distributes a finish
	 * event.
	 */
	private function finish(Void):Void {
		if (subProcesses.isEmpty() && isRunning()) {
			finished = true;
			started = false;
			working = false;
			endTime = getTimer();
			distributeFinishEvent();
		}
	}

	/**
	 * Returns {@code true} if at least one error occurred.
	 *
	 * @return {@code true} if at least one error occurred else {@code false}
	 */
	public function hasErrors(Void):Boolean {
		return (getErrors().length != 0);
	}

	/**
	 * Returns all occurred errors.
	 *
	 * @return all occurred errors
	 */
	public function getErrors(Void):Array {
		return errors;
	}

	/**
	 * Adds the given error.
	 *
	 * <p>If the given error is {@code null} or {@code undefined}, {@code -1} will
	 * be used instead.
	 *
	 * @param error the error to add
	 */
	private function addError(error):Void {
		if (error == null) error = -1;
		errors.push(error);
	}

	/**
	 * Interrupts the execution of this process with the given error.
	 *
	 * <p>Stores the given error, distributes an error event and finishes this process.
	 *
	 * <p>If no error is specified is will be set to {@code -1}.
	 *
	 * @param error the error that caused this interrupt
	 * @see #addError
	 * @see #distributeErrorEvent
	 * @see #finish
	 */
	private function interrupt(error):Void {
		distributeErrorEvent(error);
		finish();
	}

	/**
	 * Distributes process start events to registered {@link ProcessStartListener}
	 * instances.
	 */
	private function distributeStartEvent(Void):Void {
		try {
			var startDistributor:ProcessStartListener = distributorControl.getDistributor(ProcessStartListener);
			startDistributor.onProcessStart(this);
		}
		catch (exception:org.as2lib.env.event.EventExecutionException) {
			distributeErrorEvent(exception.getCause());
		}
	}

	/**
	 * Distributes process update events to registered {@link ProcessUpdateListener}
	 * instances.
	 */
	private function distributeUpdateEvent(Void):Void {
		try {
			var updateDistributor:ProcessUpdateListener = distributorControl.getDistributor(ProcessUpdateListener);
			updateDistributor.onProcessUpdate(this);
		}
		catch (exception:org.as2lib.env.event.EventExecutionException) {
			distributeErrorEvent(exception.getCause());
		}
	}

	/**
	 * Distributes process pause events to registered {@link ProcessPauseListener}
	 * instances.
	 */
	private function distributePauseEvent(Void):Void {
		try {
			var pauseDistributor:ProcessPauseListener = distributorControl.getDistributor(ProcessPauseListener);
			pauseDistributor.onProcessPause(this);
		}
		catch (exception:org.as2lib.env.event.EventExecutionException) {
			distributeErrorEvent(exception.getCause());
		}
	}

	/**
	 * Distributes process resume events to registered {@link ProcessResumeListener}
	 * instances.
	 */
	private function distributeResumeEvent(Void):Void {
		try {
			var resumeDistributor:ProcessResumeListener = distributorControl.getDistributor(ProcessResumeListener);
			resumeDistributor.onProcessResume(this);
		}
		catch (exception:org.as2lib.env.event.EventExecutionException) {
			distributeErrorEvent(exception.getCause());
		}
	}

	/**
	 * Distributes process error events to registered {@link ProcessErrorListener}
	 * instances after storing the given error.
	 *
	 * @see #addError
	 */
	private function distributeErrorEvent(error):Boolean {
		addError(error);
		var errorDistributor:ProcessErrorListener = distributorControl.getDistributor(ProcessErrorListener);
		return errorDistributor.onProcessError(this, error);
	}

	/**
	 * Distributes process finish events to registered {@link ProcessFinishListener}
	 * instances.
	 */
	private function distributeFinishEvent(Void):Void {
		try {
			var finishDistributor:ProcessFinishListener = distributorControl.getDistributor(ProcessFinishListener);
			finishDistributor.onProcessFinish(this);
		}
		catch (exception:org.as2lib.env.event.EventExecutionException) {
			distributeErrorEvent(exception.getCause());
		}
	}

}