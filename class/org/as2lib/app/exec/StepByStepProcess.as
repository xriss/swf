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
 * {@code StepByStepProcess} is a process that can be executed in multiple steps.
 *
 * <p>When you want to do a huge computational task in ActionScript, there are two
 * problems:
 *
 * <ol>
 *   <li>
 *     The Flash player crashes because the task exceeds the maximum time limit of
 *     a frame.
 *   </li>
 *   <li>
 *     User interaction is not possible for multiple seconds (during the computation).
 *   </li>
 * </ol>
 *
 * <p>To solve these problems a task can be divided into multiple steps which are
 * executed one after each other and possibly on different frames. This reduces the
 * possibility that the maximum time limit is exceeded and may make user interaction
 * possible during the task execution, depending on the used step-by-step process
 * manager.
 *
 * <p>{@link Processor} is a step-by-step process manager that takes care of executing
 * step-by-step processes and ensures that the maximum time limit of a frame is not
 * exceeded, but it does not enable user interaction.
 *
 * @author Martin Heidegger
 * @author Simon Wacker
 * @version 2.0
 */
interface org.as2lib.app.exec.StepByStepProcess extends Process {

	/**
	 * Executes the next step of this process.
	 */
	public function nextStep(Void):Void;

}