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
import org.as2lib.env.event.EventSupport;
import org.as2lib.env.overload.Overload;
import org.as2lib.io.file.CompositeTextFileFactory;
import org.as2lib.io.file.FileLoader;
import org.as2lib.io.file.LoadCompleteListener;
import org.as2lib.io.file.LoadErrorListener;
import org.as2lib.io.file.LoadProgressListener;
import org.as2lib.io.file.LoadStartListener;
import org.as2lib.io.file.PropertiesFileFactory;
import org.as2lib.io.file.SwfFileLoader;
import org.as2lib.io.file.TextFileFactory;
import org.as2lib.io.file.TextFileLoader;
import org.as2lib.io.file.XmlFileFactory;

/**
 * {@code Loader} offers an easy to use interface for loading files. It works
 * internally with {@link FileLoader} implementations.
 *
 * <p>Use the overloaded {@link #load} method to load an arbitrary file or the
 * more specific {@link #loadText} and {@link #loadSwf} methods.
 *
 * <p>While loader is not a singleton you may use the shared loader instance
 * returned by the static {@link #getInstance} method. This avoids the creation
 * of unnecessary {@code Loader} instances.
 *
 * <p>You can issue multiple loads after each other without waiting for the
 * previous ones to complete; the files are loaded parallel. But note that this
 * loader triggers events per loading process. This means that if you start
 * multiple loading processes with this loader, there will also be multiple
 * on complete events etc. Take a look at the {@link Batch} of As2lib Process
 * for more convenient ways of loading multiple files parallel and after each
 * other.
 *
 * <p>Example:
 *
 * <code>
 *   import org.as2lib.io.file.Loader;
 *
 *   var loader:Loader = Loader.getInstance();
 *   // Add you file load listener.
 *   loader.addListener(...);
 *   loader.load("content.txt");
 *   loader.load("content.xml");
 *   loader.load("content.swf", this.createEmptyMovieClip("content", this.getNextHighestDepth());
 * </code>
 *
 * @author Martin Heidegger
 * @author Simon Wacker
 * @version 1.0
 */
class org.as2lib.io.file.Loader extends EventSupport implements LoadStartListener,
		LoadCompleteListener, LoadErrorListener, LoadProgressListener {

	/** Shared {@code Loader} instance. */
	private static var instance:Loader;

	/**
	 * Returns the shared {@code Loader} instance.
	 *
	 * @return the shared {@code Loader} instance
	 */
	public static function getInstance(Void):Loader {
		if (instance == null) {
			instance = new Loader();
		}
		return instance;
	}

	/** Factory to create {@code TextFile} instances. */
	private var textFileFactory:TextFileFactory;

	/**
	 * Constructs a new {@code Loader} instance.
	 */
	public function Loader(Void) {
		textFileFactory = createTextFileFactory();
		acceptListenerType(LoadStartListener);
		acceptListenerType(LoadCompleteListener);
		acceptListenerType(LoadProgressListener);
		acceptListenerType(LoadErrorListener);
	}

	/**
	 * Creates the text file factory to use for creating text file instances.
	 */
	private function createTextFileFactory(Void):TextFileFactory {
		var result:CompositeTextFileFactory = new CompositeTextFileFactory();
		result.putTextFileFactoryByExtension("xml", new XmlFileFactory());
		result.putTextFileFactoryByExtension("properties", new PropertiesFileFactory());
		return result;
	}

	/**
	 * @overload #loadSwf
	 * @overload #loadText
	 */
	public function load() {
		var overload:Overload = new Overload(this);
		overload.addHandler([String, MovieClip, String, Map, Executable], loadSwf);
		overload.addHandler([String, MovieClip, String, Map], loadSwf);
		overload.addHandler([String, MovieClip, String], loadSwf);
		overload.addHandler([String, MovieClip], loadSwf);
		overload.addHandler([String, String, Map, Executable], loadText);
		overload.addHandler([String, String, Map], loadText);
		overload.addHandler([String, Map], loadText);
		overload.addHandler([String], loadText);
		return overload.forward(arguments);
	}

	/**
	 * Loads the SWF file with the given URI into the movieclip.
	 *
	 * @param uri the location of the file to load
	 * @param movieClip the movie clip to load the SWF into
	 * @param method (optional) method to use for submitting the parameters; must be
	 * either {@code "POST"} or {@code "GET"}; default is {@code "POST"}
	 * @param parameters (optional) parameters to use for loading the file
	 * @param callback (optional) the callback to execute when the file is loaded
	 * completely; the callback is passed the returned file loader as argument
	 * @return that swf file loader that loads the file
	 */
	public function loadSwf(uri:String, movieClip:MovieClip, method:String,
			parameters:Map, callback:Executable):SwfFileLoader {
		var fileLoader:SwfFileLoader = new SwfFileLoader(movieClip);
		fileLoader.addListener(this);
		fileLoader.load(uri, method, parameters, callback);
		return fileLoader;
	}

	/**
	 * Loads the text file with the given URI.
	 *
	 * @param uri the location of the file to load
	 * @param method (optional) method to use for submitting the parameters; must be
	 * either {@code "POST"} or {@code "GET"}; default is {@code "POST"}
	 * @param parameters (optional) parameters to use for loading the file
	 * @param callback (optional) the callback to execute when the file is loaded
	 * completely; the callback is passed the returned file loader as argument
	 * @return the text file loader that loads the file
	 */
	public function loadText(uri:String, method:String, parameters:Map,
			callback:Executable):TextFileLoader {
		var fileLoader:TextFileLoader = new TextFileLoader(textFileFactory);
		fileLoader.addListener(this);
		fileLoader.load(uri, method, parameters, callback);
		return fileLoader;
	}

	/**
	 * Sets the text file factory that shall be used by the {@link #loadText} method.
	 *
	 * <p>{@code loadText} requires a {@code TextFileFactory} to create the concrete
	 * {@code TextFile} instance that represents the file. A text file factory may
	 * either always return an instance of the same {@code TextFile} implementation
	 * or determine the implementation to use by analyzing the file extension of the
	 * URI.
	 *
	 * <p>The default text file factory is a {@link CompositeTextFileFactory} instance
	 * with the {@link SimpleTextFileFactory} as default factory if the file extension
	 * is unknown, the {@link XmlFileFactory} for the extension "xml" and the
	 * {@link PropertiesFileFactory} for the extension "properties".
	 *
	 * @param textFileFactory the text file factory to use
	 */
	public function setTextFileFactory(textFileFactory:TextFileFactory):Void {
		this.textFileFactory = textFileFactory;
	}

	/**
	 * Distributes a load complete event.
	 */
	public function onLoadComplete(fileLoader:FileLoader):Void {
		var completeDistributor:LoadCompleteListener =
				distributorControl.getDistributor(LoadCompleteListener);
		completeDistributor.onLoadComplete(fileLoader);
	}

	/**
	 * Distributes a load start event.
	 */
	public function onLoadStart(fileLoader:FileLoader):Void {
		var errorDistributor:LoadStartListener =
				distributorControl.getDistributor(LoadStartListener);
		errorDistributor.onLoadStart(fileLoader);
	}

	/**
	 * Distributes a load error event.
	 */
	public function onLoadError(fileLoader:FileLoader, errorCode:String, error):Boolean {
		var errorDistributor:LoadErrorListener =
				distributorControl.getDistributor(LoadErrorListener);
		return errorDistributor.onLoadError(fileLoader, errorCode, error);
	}

	/**
	 * Distributes a load progress event.
	 */
	public function onLoadProgress(fileLoader:FileLoader):Void {
		var progressDistributor:LoadProgressListener =
				distributorControl.getDistributor(LoadProgressListener);
		progressDistributor.onLoadProgress(fileLoader);
	}

}