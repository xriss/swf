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
import org.as2lib.data.holder.Map;
import org.as2lib.data.type.Bit;
import org.as2lib.env.except.IllegalArgumentException;
import org.as2lib.io.file.FileLoader;
import org.as2lib.io.file.LoadCompleteListener;
import org.as2lib.io.file.LoadErrorListener;
import org.as2lib.io.file.LoadProgressListener;
import org.as2lib.io.file.LoadStartListener;

/**
 * {@code AbstractFileLoader} implements methods commonly needed by
 * {@link FileLoader} implementations.
 *
 * @author Martin Heidegger
 * @author Simon Wacker
 * @version 2.0
 */
class org.as2lib.io.file.AbstractFileLoader extends AbstractTimeConsumer {

	/** Error code used when a file could not be found (does not exist). */
	public static var FILE_NOT_FOUND_ERROR:String = "fileNotFound";

	/** The URI of the file to load. */
	private var uri:String;

	/** The method to use for passing resource request parameters. */
	private var method:String;

	/** The parameters to use for the resource request. */
	private var parameters:Map;

	/** The callback to execute when loading finishes. */
	private var callback:Executable;

	/** This instance properly typed. */
	private var thiz:FileLoader;

	/**
	 * Constructs a new {@code AbstractFileLoader} instance.
	 */
	public function AbstractFileLoader(Void) {
		thiz = FileLoader(this);
		method = "POST";
		acceptListenerType(LoadStartListener);
		acceptListenerType(LoadCompleteListener);
		acceptListenerType(LoadProgressListener);
		acceptListenerType(LoadErrorListener);
	}

	/**
	 * Prepares the loading process for the given file by storing URI, parameters,
	 * parameter-submit-method, callback and setting {@code started} to {@code true},
	 * {@code finished} to {@code false} and storing the start time.
	 *
	 * <p>This method must be overridden in subclasses to do the actual loading. Do not
	 * forget to call {@code super} in the overriding method.
	 *
	 * @param uri the location of the file to load
	 * @param parameters (optional) parameters to use for loading the file
	 * @param method (optional) method to use for submitting the parameters; must be
	 * either {@code "POST"} or {@code "GET"}; default is {@code "POST"}
	 * @param callback (optional) the callback to execute when the file is loaded
	 * completely; the callback is passed this file loader as argument
	 * @throws IllegalArgumentException if {@code uri} is {@code null}, {@code undefined}
	 * or an empty string
	 */
	public function load(uri:String, method:String, parameters:Map, callBack:Executable):Void {
		if (uri == null || uri == "") {
			throw new IllegalArgumentException("URI is required.", this, arguments);
		}
		this.uri = uri;
		this.method = method.toUpperCase() == "GET" ? "GET" : "POST";
		this.parameters = parameters;
		this.callback = callBack;
		started = true;
		finished = false;
		startTime = getTimer();
	}

	public function getUri(Void):String {
		return uri;
	}

	public function getParameterSubmitMethod(Void):String {
		return method;
	}

	public function getParameters(Void):Map {
		return parameters;
	}

	/**
	 * Returns the loading progress in percent. It is evaluated by using the results of
	 * the {@code getBytesTotal} and {@code getBytesLoaded} methods.
	 *
	 * <p>Returns {@code null} if the loading progress is not evaluable.
	 *
	 * @return the loading progress in percent
	 */
	public function getPercentage(Void):Number {
		if (hasStarted() || hasFinished()) {
			var percentage:Number = (100 / thiz.getBytesTotal().getBytes() *
					thiz.getBytesLoaded().getBytes());
			if (percentage >= 100) {
				percentage = 100;
			}
			return percentage;
		}
		return null;
	}

	/**
	 * Returns the current transfer rate of the loading process. It is evaluated by
	 * using the results of the {@code getBytesLoaded} and {@code getDuration} methods.
	 *
	 * @return the transfer rate of the loading process in bit (per second)
	 */
	public function getTransferRate(Void):Bit {
		return new Bit(thiz.getBytesLoaded().getBit() / getDuration().inSeconds());
	}

	/**
	 * Distributes the start event.
	 */
	private function distributeStartEvent(Void):Void {
		var startDistributor:LoadStartListener =
				distributorControl.getDistributor(LoadStartListener);
		startDistributor.onLoadStart(thiz);
	}

	/**
	 * Distributes an error event.
	 *
	 * @param errorCode the error code of the error
	 * @param error the error (mostly an exception or an error message)
	 */
	private function distributeErrorEvent(errorCode:String, error):Void {
		var errorDistributor:LoadErrorListener =
				distributorControl.getDistributor(LoadErrorListener);
		errorDistributor.onLoadError(thiz, errorCode, error);
	}

	/**
	 * Distributes the complete event.
	 */
	private function distributeCompleteEvent(Void):Void {
		var completeDistributor:LoadCompleteListener =
				distributorControl.getDistributor(LoadCompleteListener);
		completeDistributor.onLoadComplete(thiz);
		callback.execute(this);
	}

	/**
	 * Distributes a progress event.
	 */
	private function distributeProgressEvent(Void):Void {
		var completeDistributor:LoadProgressListener =
				distributorControl.getDistributor(LoadProgressListener);
		completeDistributor.onLoadProgress(thiz);
	}

}