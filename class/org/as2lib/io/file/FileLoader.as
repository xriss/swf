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

import org.as2lib.app.exec.Executable;
import org.as2lib.data.holder.Map;
import org.as2lib.data.type.Bit;
import org.as2lib.data.type.Byte;
import org.as2lib.data.type.Time;
import org.as2lib.env.event.EventListenerSource;
import org.as2lib.io.file.File;

/**
 * {@code FileLoader} loads files. One file loader can only manage one loading
 * process at a time. But a file loader can be used to load the same or different
 * files multiple times after each other.
 *
 * <code>
 *   import org.as2lib.io.file.AbstractFileLoader;
 *   import org.as2lib.io.file.File;
 *   import org.as2lib.io.file.FileLoader;
 *   import org.as2lib.io.file.LoadStartListener;
 *   import org.as2lib.io.file.LoadCompleteListener;
 *   import org.as2lib.io.file.LoadProgressListener;
 *   import org.as2lib.io.file.LoadErrorListener;
 *
 *   class Main implements LoadStartListener, LoadCompleteListener, LoadErrorListener,
 *           LoadProgressListener {
 *
 *       public function main(fileLoader:FileLoader):Void {
 *           fileLoader.addListener(this);
 *           fileLoader.load("test.txt");
 *       }
 *
 *       public function onLoadComplete(fileLoader:FileLoader):Void {
 *           var file:File = fileLoader.getFile();
 *           // Use the loaded file.
 *       }
 *
 *       public function onLoadError(fileLoader:FileLoader, errorCode:String, error):Boolean {
 *           if (errorCode == AbstractFileLoader.FILE_NOT_FOUND_ERROR) {
 *       	     trace("File could not be found: " + error);
 *           }
 *           return false
 *       }
 *
 *       public function onLoadProgress(fileLoader:FileLoader):Void {
 *           trace("Loaded " + fileLoader.getPercentage() + "% of '" + fileLoader.getUri() + "'.");
 *       }
 *
 *       public function onLoadStart(fileLoader:FileLoader):Void {
 *     	     trace("Started loading '" + fileLoader.getUri() + "'.");
 *       }
 *
 *   }
 * </code>
 *
 * @author Martin Heidegger
 * @author Simon Wacker
 * @version 2.0
 */
interface org.as2lib.io.file.FileLoader extends EventListenerSource {

	/**
	 * Loads the file with the given URI.
	 *
	 * <p>Sends an http request using the passed-in {@code uri}, {@code method} and
	 * {@code parameters}.
	 *
	 * <p>You can pass-in a callback to get informed when the file is loaded
	 * completely. If you also want to be notified on other events like the loading
	 * progress you must register a listener.
	 *
	 * <p>Example that uses a callback:
	 *
	 * <code>
	 *   import org.as2lib.io.file.FileLoader;
	 *   import org.as2lib.app.exec.Call;
	 *
	 *   class Main {
	 *
	 *       public function main(fileLoader:FileLoader) {
	 *           fileLoader.load("test.txt", null, null, new Call(this, finish);
	 *       }
	 *
	 *       public function finish(fileLoader:FileLoader):Void {
	 *           // Use the loaded file.
	 *       }
	 *
	 *   }
	 *
	 * </code>
	 *
	 * @param uri the location of the file to load
	 * @param parameters (optional) parameters to use for loading the file
	 * @param method (optional) method to use for submitting the parameters; must be
	 * either {@code "POST"} or {@code "GET"}; default is {@code "POST"}
	 * @param callback (optional) the callback to execute when the file is loaded
	 * completely; the callback is passed this file loader as argument
	 */
	public function load(uri:String, method:String, parameters:Map, callback:Executable):Void;

	/**
	 * Returns the URI of the file that was loaded or that is currently being loaded.
	 *
	 * @return the URI of the file
	 */
	public function getUri(Void):String;

	/**
	 * Returns the method to use to pass request parameters.
	 *
	 * @return the method to use to pass request parameters
	 */
	public function getParameterSubmitMethod(Void):String;

	/**
	 * Returns the parameters to use for the file request.
	 *
	 * <p>Returns {@code null} if no parameters were supplied.
	 *
	 * @return the parameters to use for the file request
	 */
	public function getParameters(Void):Map;

	/**
	 * Returns the loaded file.
	 *
	 * @return the loaded file
	 * @throws org.as2lib.io.file.FileNotLoadedException if the file has not been
	 * loaded yet
	 */
	public function getFile(Void):File;

	/**
	 * Returns the loading progress in percent.
	 *
	 * <p>Returns {@code null} if the loading progress is not evaluable.
	 *
	 * @return the loading progress in percent
	 */
	public function getPercentage(Void):Number;

	/**
	 * Returns the amount of bytes that have already been loaded.
	 *
	 * <p>Returns {@code null} if it is not possible to resolve the loaded bytes.
	 *
	 * @return the amount of bytes that have already been loaded
	 */
	public function getBytesLoaded(Void):Byte;

	/**
	 * Returns the total amount of bytes to load.
	 *
	 * <p>Returns {@code null} if it is not possible to resolve the total amount of
	 * bytes.
	 *
	 * @return the total amount of bytes to load
	 */
	public function getBytesTotal(Void):Byte;

	/**
	 * Returns the current transfer rate of the loading process.
	 *
	 * @return the transfer rate of the loading process in bit (per second)
	 */
	public function getTransferRate(Void):Bit;

	/**
	 * Estimates the time that is still needed for loading the file.
	 *
	 * @return the estimated time that is still needed for loading the file
	 */
	public function getEstimatedRestTime(Void):Time;

	/**
	 * Estimates the time the complete loading process will take.
	 *
	 * @return the estimated time needed for the complete loading process
	 */
	public function getEstimatedTotalTime(Void):Time;

	/**
	 * Returns the duration. That is the time that has already been needed for loading
	 * the file.
	 *
	 * @return the time difference between the start time and the end time (or the
	 * current time if the file is still being loaded)
	 */
	public function getDuration(Void):Time;

}