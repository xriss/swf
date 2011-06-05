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

/**
 * {@code Batch} manages the execution of multiple processes (most batches start
 * processes after each other).
 *
 * <p>Use the {@link #addProcess} method to add a new child-process to this batch.
 * Most implementations start processes in the order they are added to them.
 *
 * <p>This interface extends the {@code Process} interface. This means that this
 * batch is a composite, so you can add one batch with the {@code addProcess}
 * method as child-process to another batch.
 *
 * <p>Besides the listeners provided by processes batches normally also support the
 * following listeners: {@link BatchStartListener}, {@link BatchUpdateListener},
 * {@link NextProcessListener}, {@link BatchErrorListener} and {@link BatchFinishListener}.
 *
 * <p>Example:
 *
 * <code>
 *   import org.as2lib.app.exec.Batch;
 *   import org.as2lib.app.exec.BatchProcess;
 *
 *   var batch:Batch = new BatchProcess();
 *   batch.addListener(new MyStartUpController());
 *   batch.addProcess(new MyStartUpProcess());
 *   batch.addProcess(new MyXMLParsingProcess());
 *   batch.start();
 * </code>
 *
 * @author Martin Heidegger
 * @author Simon Wacker
 * @version 2.0
 * @see AbstractBatch
 */
interface org.as2lib.app.exec.Batch extends Process {

	/**
	 * Returns the currently running process.
	 *
	 * <p>If {@code includingBatches} is {@code true} the current process of this batch
	 * will be returned, regardless of whether it is a process or a batch. If
	 * {@code includingBatches} is {@code false} the returned process is a real
	 * process. This means that if the current process is itself a batch it will be
	 * asked for its current process and so on. Note that batches which do not
	 * distribute next-process events are regarded as real processes. Such a batch
	 * is for example the {@link BatchProcess}.
	 *
	 * <p>Note that batches are by default not included.
	 *
	 * @param includingBatches determines whether batches shall be regarded as processes
	 * or as process managers
	 * @return the process that is currently running
	 * @see NextProcessListener
	 */
	public function getCurrentProcess(includingBatches:Boolean):Process;

	/**
	 * Returns all added processes.
	 *
	 * @return all added processes
	 */
	public function getAllProcesses(Void):Array;

	/**
	 * Adds the given process to be executed by this batch.
	 *
	 * @param process the process to add
	 */
	public function addProcess(process:Process):Void;

	/**
	 * Adds all given processes.
	 *
	 * @param processes the processes to add
	 */
	public function addAllProcesses(processes:Array):Void;

	/**
	 * Removes the given process.
	 *
	 * @param process the process to remove
	 */
	public function removeProcess(process:Process):Void;

	/**
	 * Removes all processes.
	 */
	public function removeAllProcesses(Void):Void;

	/**
	 * Returns the number of processes added to this batch.
	 *
	 * @return the total number of processes
	 */
	public function getProcessCount(Void):Number;

}