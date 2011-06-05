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
import org.as2lib.data.type.Byte;
import org.as2lib.io.file.AbstractFileLoader;
import org.as2lib.io.file.File;
import org.as2lib.io.file.FileLoader;
import org.as2lib.io.file.FileNotLoadedException;
import org.as2lib.io.file.SimpleTextFileFactory;
import org.as2lib.io.file.TextFile;
import org.as2lib.io.file.TextFileFactory;

/**
 * {@code TextFileLoader} loads any kind of text files. This may be simple text
 * files, xml files, properties files etc. Text files are human readable files
 * in ASCII or Unicode.
 *
 * <p>A text file loader can be configured with a {@link TextFileFactory} of your
 * choice. If you load for example an XML file you can configure it with a
 * {@link XmlFileFactory} to get an {@link XmlFile} instance from the {@link #getFile}
 * method (or you may use the {@link XmlFileLoader}).
 *
 * <p>A text file loader loads files asynchronously. It is therefore necessary to
 * register listeners at a text file loader to be notified when loading starts,
 * progresses, completes or when an error occurred:
 *
 * <ul>
 *   <li>{@link LoadStartListener}</li>
 *   <li>{@link LoadProgressListener}</li>
 *   <li>{@link LoadErrorListener}</li>
 *   <li>{@link LoadCompleteListener}</li>
 * </ul>
 *
 * <p>The listener interfaces can be implemented by listener classes whose instances
 * can be added through the {@link #addListener} method to a text file loader. The
 * listener is notified when an event corresponding to an implemented listener interface
 * occurs.
 *
 * <p>Listener example:
 *
 * <code>
 *   import org.as2lib.io.file.AbstractFileLoader;
 *   import org.as2lib.io.file.LoadProgressListener;
 *   import org.as2lib.io.file.LoadStartListener;
 *   import org.as2lib.io.file.LoadCompleteListener;
 *   import org.as2lib.io.file.LoadErrorListener;
 *   import org.as2lib.io.file.FileLoader;
 *   import org.as2lib.io.file.TextFile;
 *
 *   class MyFileListener implements LoadProgressListener, LoadStartListener,
 *           LoadCompleteListener, LoadErrorListener {
 *
 *       public function onLoadStart(fileLoader:FileLoader) {
 *           trace("Started loading '" + fileLoader.getFile().getLocation() + "'.");
 *       }
 *
 *       public function onLoadProgress(fileLoader:FileLoader) {
 *           trace("Loading progress: " + fileLoader.getPercentage());
 *       }
 *
 *       public function onLoadComplete(fileLoader:FileLoader):Void {
 *           trace("Completed loading '" + fileLoader.getFile().getLocation() + "'.");
 *           var textFile:TextFile = TextFile(fileLoader.getFile());
 *           if (textFile != null) {
 *               // Correct file type.
 *           }
 *           else {
 *               // Illegal file type.
 *           }
 *       }
 *
 *       public function onLoadError(fileLoader:FileLoader, errorCode:String, error):Void {
 *           if (errorCode == AbstractFileLoader.FILE_NOT_FOUND) {
 *               trace("File '" + fileLoader.getFile().getLocation() + "' does not exist.");
 *           }
 *           // Handle further error codes.
 *           return false;
 *       }
 *
 *   }
 * </code>
 *
 * <p>Usage example:
 *
 * <code>
 *   import org.as2lib.io.file.TextFileLoader;
 *
 *   var fileLoader:TextFileLoader = new TextFileLoader();
 *   fileLoader.addListener(new MyFileListener());
 *   fileLoader.load("test.txt");
 * </code>
 *
 * @author Martin Heidegger
 * @author Simon Wacker
 * @version 2.0
 */
class org.as2lib.io.file.TextFileLoader extends AbstractFileLoader implements
		FileLoader {

	/** Load vars for loading the text file. */
	private var loadVars:LoadVars;

	/** The loaded text file. */
	private var textFile:TextFile;

	/** The factory to create {@code TextFile} instances. */
	private var textFileFactory:TextFileFactory;

	/**
	 * Constructs a new {@code TextFileLoader} instance.
	 *
	 * @param textFileFactory (optional) the text file factory to create text file
	 * instances; {@link SimpleTextFileFactory} is used if no custom text file factory
	 * is supplied
	 */
	public function TextFileLoader(textFileFactory:TextFileFactory) {
		if (textFileFactory == null) {
			textFileFactory = new SimpleTextFileFactory();
		}
		this.textFileFactory = textFileFactory;
	}

	public function load(uri:String, method:String, parameters:Map, callback:Executable):Void {
		super.load(uri, method, parameters, callback);
		initLoadVars();
		if (parameters != null && parameters.size() > 0) {
			if (this.method == "POST") {
				var keys:Array = parameters.getKeys();
				for (var i:Number = 0; i < keys.length; i++) {
					var key = keys[i];
					loadVars[key.toString()] = parameters.get(key);
				}
				loadVars["sendAndLoad"](uri, this, this.method);
			}
			else {
				var result:String = uri;
				if (uri.indexOf("?") == -1) {
					result += "?";
				}
				var keys:Array = parameters.getKeys();
				for (var i:Number = 0; i < keys.length; i++) {
					var key = keys[i];
					uri += _global.encode(key.toString()) + "=" +
							_global.encode(parameters.get(key).toString());
				}
				loadVars.load(uri);
			}
		}
		else {
			loadVars.load(uri);
		}
		distributeStartEvent();
	}

	/**
	 * Returns the loaded file.
	 *
	 * <p>The returned file can be safely casted to {@link TextFile}.
	 *
	 * @return the loaded file
	 * @throws org.as2lib.io.file.FileNotLoadedException if the file has not been
	 * loaded yet
	 * @see #getTextFile
	 */
	public function getFile(Void):File {
		return getTextFile();
	}

	/**
	 * Returns the loaded text file.
	 *
	 * @return the loaded text file
	 * @throws FileNotLoadedException if the resource has not been loaded yet
	 */
	public function getTextFile(Void):TextFile {
		if (textFile == null) {
			throw new FileNotLoadedException("Text file has not been loaded yet.",
					this, arguments);
		}
		return textFile;
	}

	/**
	 * Initializes the load vars helper.
	 */
	private function initLoadVars(Void):Void {
		var owner:TextFileLoader = this;
		loadVars = new LoadVars();
		// Watching _bytesLoaded allows realtime events
		loadVars.watch("_bytesLoaded",
			function(prop, oldValue, newValue) {
				// Prevent useless events.
				if (newValue != oldValue && newValue > 0) {
					owner["onUpdate"]();
				}
				return newValue;
			}
		);
		// Using LoadVars Template to get the onData Event.
		loadVars.onData = function(data) {
			owner["onData"](data);
		};
	}

	public function getBytesLoaded(Void):Byte {
		var result:Number = loadVars.getBytesLoaded();
		if (result >= 0) {
			return new Byte(result);
		}
		return null;
	}

	public function getBytesTotal(Void):Byte {
		var total:Number = loadVars.getBytesTotal();
		if (total >= 0) {
			return new Byte(total);
		}
		return null;
	}

	/**
	 * Distributes a progress event.
	 */
	private function onUpdate(Void):Void {
		distributeProgressEvent();
	}

	/**
	 * Finishes loading by setting {@code finished} to {@code true}, {@code started}
	 * to {@code false}, storing the end time, resetting the load vars helper,
	 * distributing an error event if {@code data} is {@code null} or {@code undefined},
	 * and creating a text file and distributing a complete event otherwise.
	 *
	 * @param data the loaded data
	 */
	private function onData(data:String):Void {
		finished = true;
		started = false;
		endTime = getTimer();
		loadVars.onLoad = null;
		loadVars.unwatch("_bytesLoaded");
		if (typeof(data) == "undefined") {
			distributeErrorEvent(FILE_NOT_FOUND_ERROR, uri);
		}
		else {
			textFile = textFileFactory.createTextFile(data, getBytesTotal(), uri);
			distributeCompleteEvent();
		}
	}

}