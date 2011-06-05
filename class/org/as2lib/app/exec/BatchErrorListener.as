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

import org.as2lib.app.exec.Batch;
import org.as2lib.core.BasicInterface;

/**
 * {@code BatchErrorListener} can be implemented by classes which want to be
 * notified when an error occurred during the execution of a batch. An instance
 * of the implementing class can then be registered as listener at the batch
 * to observe.
 *
 * @author Martin Heidegger
 * @author Simon Wacker
 * @version 2.0
 * @see Batch
 * @see Batch#addListener
 */
interface org.as2lib.app.exec.BatchErrorListener extends BasicInterface {

	/**
	 * Is executed when an error occurred during the execution of the observed batch.
	 *
	 * <p>Consuming the error by returning {@code true} is the same as saying that this
	 * listener resolved the error and that the batch can resume execution; no further
	 * listeners will be notified of the error. Returning {@code false} means that this
	 * listener could not resolve the error and that the next listener will be notified.
	 * If there is no next listener, the batch finishes execution.
	 *
	 * @param batch the observed batch during whose execution the error occurred
	 * @param error the error that occurred during the execution; in most cases an
	 * exception
	 * @return {@code true} to consume the error (mark it as resolved), otherwise
	 * {@code false}
	 */
	public function onBatchError(batch:Batch, error):Boolean;

}