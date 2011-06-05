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
 * {@code ProcessErrorListener} can be implemented by classes which want to be
 * notified when an error occurred during the execution of a process. An instance
 * of the implementing class can then be registered as listener at the process
 * to observe.
 *
 * @author Martin Heidegger
 * @author Simon Wacker
 * @version 2.0
 * @see Process
 * @see Process#addListener
 */
interface org.as2lib.app.exec.ProcessErrorListener extends BasicInterface {

    /**
     * Is executed when an error occurred during the execution of the observed
     * process.
     *
     * <p>Consuming the error by returning {@code true} is the same as saying that this
     * listener resolved the error and that the process can resume execution; no further
     * listeners will be notified of the error. Returning {@code false} means that this
     * listener could not resolve the error and that the next listener will be notified.
     * If there is no next listener, the process finishes execution.
     *
     * @param process the observed process during whose execution the error occurred
     * @param error the error that occurred during the execution; in most cases an
     * exception
     * @return {@code true} to consume the error (mark it as resolved), otherwise
     * {@code false}
     */
    public function onProcessError(process:Process, error):Boolean;

}