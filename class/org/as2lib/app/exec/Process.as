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

import org.as2lib.env.event.EventListenerSource;
import org.as2lib.data.type.Time;

/**
 * {@code Process} provides a common interface for the execution of synchronous
 * or asynchronous tasks. It is mostly used for asynchronous tasks.
 *
 * <p>Synchronous tasks are directly done in the {@link #start} method and are finished
 * when the {@code start} method returns.
 *
 * <p>Asynchronous tasks are only started in the {@link #start} method and are finished
 * some time after the {@code start} method returns. An asynchronous task is for
 * example loading a file or getting data from a web service (which cannot be done
 * synchronously in ActionScript). You may also use asynchronous processes to do a huge
 * computation step-by-step which would crash the flash player or would prevent user
 * interaction if done synchronously.
 *
 * <p>Processes support the following listeners: {@link ProcessStartListener},
 * {@link ProcessUpdateListener}, {@link ProcessPauseListener}, {@link ProcessResumeListener},
 * {@link ProcessErrorListener} and {@link ProcessFinishListener}.
 *
 * <p>To listen to events create a class which implements one or more of the above
 * listener interfaces and add an instance of that class as listener with the
 * {@link #addListener} method to the process to observe.
 *
 * @author Martin Heidegger
 * @author Simon Wacker
 * @version 2.0
 * @see AbstractProcess
 * @see Batch
 */
interface org.as2lib.app.exec.Process extends EventListenerSource {

	/**
	 * Starts the execution of this process.
	 *
	 * @param * any number of paramters of any type (implementation specific)
	 * @return the result of starting this process (implementation specific)
	 */
    public function start();

	/**
	 * Has this process already started execution and has not finished yet?
	 *
	 * @return {@code true} if this process has already started execution and has
	 * not finished yet, else {@code false}
	 */
    public function hasStarted(Void):Boolean;

    /**
     * Has this process already finished execution?
     *
     * @return {@code true} if this process has already finished execution, else
     * {@code false}
     */
    public function hasFinished(Void):Boolean;

    /**
     * Is this process paused? A process can only be paused if it has already started
     * execution.
     *
     * <p>A paused process is waiting for a subtask to finish.
     *
     * @return {@code true} if this process is paused, else {@code false}
     */
    public function isPaused(Void):Boolean;

    /**
     * Is this process running (not paused)? A process can only be running if it has
     * already started execution.
     *
     * @return {@code true} if this process is running (not paused), else {@code false}
     */
    public function isRunning(Void):Boolean;

    /**
     * Returns the execution progress in percent.
     *
     * <p>If this process has not started execution yet, {@code 0} will be returned.
     *
     * <p>If this process has already started exeuction and the progress is evaluable,
     * a value between {@code 0} and {@code 100} will be returned, depending on the
     * current execution state.
     *
     * <p>If this process has already finished execution, {@code 100} will be returned.
     *
     * @return the current execution progress in percent
     */
    public function getPercentage(Void):Number;

	/**
	 * Did any errors occur during the execution of this process (until now)?
	 *
	 * @return {@code true} if errors occurred, else {@code false}
	 */
	public function hasErrors(Void):Boolean;

    /**
     * Returns errors which did occur during the execution of this process (until now).
     *
     * <p>Errors are mostly exceptions, but may be of any type.
     *
     * @return the errors which occurred during the execution of this process
     */
    public function getErrors(Void):Array;

	/**
	 * Returns the time needed for executing this process (until now).
	 *
	 * <p>If this process has already finished execution, the totally needed execution
	 * time will be returned. Otherwise the time needed from the start of the execution
	 * until this point in the execution will be returned.
	 *
	 * @return the time needed for executing this process (until now)
	 */
	public function getDuration(Void):Time;

	/**
	 * Estimates the total execution time.
	 *
	 * <p>If this process has already finished execution, the exact execution time
	 * will be returned.
	 *
	 * <p>If this process has not started execution yet {@code 0} will be returned.
	 *
	 * @return the estimated total execution time
	 * @see #getDuration
	 */
	public function getEstimatedTotalTime(Void):Time;

	/**
	 * Estimates the rest time needed until the execution finishes.
	 *
	 * <p>If this process has already finished execution {@code 0} will be returned.
	 * If it has not started execution yet {@code null} will be returned.
	 *
	 * @return the estimated rest time needed for the execution of this process
	 */
	public function getEstimatedRestTime(Void):Time;

	/**
	 * Returns the name of this process intended for display to users, but it is also
	 * helpful for debugging.
	 *
	 * <p>Note that batch processes may choose to return not their name but rather the
	 * name of the process currently running.
	 *
	 * @return the name of this process
	 */
	public function getName(Void):String;

	/**
	 * Sets the name of this process.
	 *
	 * @param name the name of this process
	 * @see #getName
	 */
	public function setName(name:String):Void;

    /**
     * Returns the parent of this process. This process may be a child process of a
     * batch or the subprocess of another process. In the former case the returned
     * parent is a batch, in the latter case another process.
     *
     * @return the parent process or {@code null}
     */
    public function getParentProcess(Void):Process;

    /**
     * Sets the parent of this process. The parent process may be a batch of which
     * this process is a child, or another process of which this process is a
     * subprocess.
     *
     * @param parentProcess the parent process that manages this process
     * @throws IllegalArgumentException if the given parent process is itself a child
     * or subprocess of this process or if it is this process itself
     */
    public function setParentProcess(parentProcess:Process):Void;

}