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
import org.as2lib.app.exec.Executable;
import org.as2lib.data.holder.Map;
import org.as2lib.io.file.FileLoader;
import org.as2lib.io.file.LoadCompleteListener;
import org.as2lib.io.file.LoadErrorListener;
import org.as2lib.io.file.LoadProgressListener;
import org.as2lib.io.file.LoadStartListener;

/**
 * {@code FileLoaderProcess} wraps a file loader to make the integration of file
 * loaders with As2lib Process possible. The file loader process mediates between
 * As2lib File and As2lib Process.
 *
 * <p>A wrapped file loader can be used as follows:
 *
 * <code>
 *   import org.as2lib.io.file.TextFileLoader;
 *   import org.as2lib.io.file.FileLoaderProcess;
 *
 *   var fileLoader:TextFileLoader = new TextFileLoader();
 *   var fileLoaderProcess:FileLoaderProcess = new FileLoaderProcess(fileLoader);
 *   fileLoaderProcess.setUri("test.txt");
 *   fileLoaderProcess.start();
 * </code>
 *
 * <p>If used as above, As2lib Process does not add much value. But you may also
 * use a batch that manages the loading process of multiple files or integrate file
 * loading with an application context.
 *
 * @author Martin Heidegger
 * @author Simon Wacker
 * @version 1.0
 * @see Process
 * @see Batch
 */
class org.as2lib.io.file.FileLoaderProcess extends AbstractProcess implements
		LoadCompleteListener, LoadProgressListener, LoadErrorListener {

	/** The file loader the actually loads the file. */
	private var fileLoader:FileLoader;

	/** The URI of the file to load. */
	private var uri:String;

	/** The parameter submit method for the request. */
	private var method:String;

	/** The parameters to use for the request. */
	private var parameters:Map;

	/** The callback to invoke when the file was loaded. */
	private var callback:Executable;

	/** Are errors ignored? */
	private var ignoreErrors:Boolean;

	/**
	 * Constructs a new {@code FileLoaderProcess} instance.
	 *
	 * <p>If errors are ignored, this process will just finish when an error occurs
	 * without distributing it to registered error listeners.
	 *
	 * @param fileLoader the file loader to delegate to
	 * @param ignoreErrors shall errors be ignored?
	 */
	public function FileLoaderProcess(fileLoader:FileLoader, ignoreErrors:Boolean) {
		this.fileLoader = fileLoader;
		this.ignoreErrors = ignoreErrors ? true : false;
		fileLoader.addListener(this);
	}

	/**
	 * Sets the data to use for loading the file.
	 *
	 * @param uri the location of the file to load
	 * @param parameters (optional) parameters to use for loading the file
	 * @param method (optional) method to use for submitting the parameters; must be
	 * either {@code "POST"} or {@code "GET"}; default is {@code "POST"}
	 * @param callback (optional) the callback to execute when the file is loaded
	 * completely; the callback is passed this file loader as argument
	 * @return the current process
	 */
	public function setUri(uri:String, method:String, parameters:Map, callback:Executable):FileLoaderProcess {
		this.uri = uri;
		this.method = method;
		this.parameters = parameters;
		this.callback = callback;
		if (getName() == null) {
			setName(uri);
		}
		return this;
	}

	/**
	 * Returns the wrapped file loader.
	 *
	 * @return the wrapped file loader
	 */
	public function getFileLoader(Void):FileLoader {
		return fileLoader;
	}

	/**
	 * Starts loading the file.
	 *
	 * <p>Note: Arguments supplied with this method have higher priority than the ones
	 * set via the {@link #setUri} method.
	 *
	 * @param uri the location of the file to load
	 * @param parameters (optional) parameters to use for loading the file
	 * @param method (optional) method to use for submitting the parameters; must be
	 * either {@code "POST"} or {@code "GET"}; default is {@code "POST"}
	 * @param callback (optional) the callback to execute when the file is loaded
	 * completely; the callback is passed this file loader as argument
	 */
	public function run() {
		var uri:String = (arguments[0] instanceof String) ? arguments[0] : this.uri;
		var method:String = (arguments[1] instanceof String) ? arguments[1] : this.method;
		var parameter:Map = (arguments[2] instanceof Map) ? arguments[2] : this.parameters;
		var callBack:Executable = (arguments[3] instanceof Executable) ? arguments[3] : this.callback;
		fileLoader.load(uri, method, parameter, callBack);
		working = !hasFinished();
	}

	public function getPercentage(Void):Number {
		return fileLoader.getPercentage();
	}

	/**
	 * Finishes this process.
	 */
	public function onLoadComplete(fileLoader:FileLoader):Void {
		finish();
	}

	/**
	 * Distributes an update event.
	 */
	public function onLoadProgress(fileLoader:FileLoader):Void {
		distributeUpdateEvent();
	}

	/**
	 * Interrupts this process if errors are <i>not</i> ignored (distributes error
	 * event, adds the error and finishes this process), or finishes this process
	 * silently otherwise.
	 *
	 * @return {@code true} to consume the event when errors are ignored, otherwise
	 * {@code false}
	 */
	public function onLoadError(fileLoader:FileLoader, errorCode:String, error):Boolean {
		if (!ignoreErrors) {
			var message:String = errorCode;
			if (error != null) {
				message += ": " + error.toString();
			}
			interrupt(message);
			return false;
		}
		finish();
		return true;
	}

}