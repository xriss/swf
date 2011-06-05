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
import org.as2lib.data.type.Time;
import org.as2lib.env.event.impulse.FrameImpulse;
import org.as2lib.env.event.impulse.FrameImpulseListener;
import org.as2lib.io.file.AbstractFileLoader;
import org.as2lib.io.file.File;
import org.as2lib.io.file.FileLoader;
import org.as2lib.io.file.FileNotLoadedException;
import org.as2lib.io.file.SwfFile;

/**
 * {@code SwfFileLoader} loads SWF, JPEG, GIF or PNG files with {@code loadMovie}.
 * Support for unanimated GIF files, PNG files, and progressive JPEG files is added
 * in Flash Player 8. If you load an animated GIF, only the first frame is displayed.
 *
 * <p>The SWF or image files are loaded to a target movieclip which gets replaced by
 * the loaded file.
 *
 * <p>A swf file loader loads files asynchronously. It is therefore necessary to
 * register listeners at a swf file loader to be notified when loading starts,
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
 * can be added through the {@link #addListener} method to a swf file loader. The
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
 *   import org.as2lib.io.file.SwfFile;
 *
 *   class MySwfListener implements LoadProgressListener, LoadStartListener,
 *           LoadCompleteListener, LoadErrorListener {
 *
 *       public function onLoadStart(fileLoader:FileLoader):Void {
 *           trace("Started loading '" + fileLoader.getFile().getLocation() + "'.");
 *       }
 *
 *       public function onLoadProgress(fileLoader:FileLoader):Void {
 *           trace("Loading progress: " + fileLoader.getPercentage());
 *       }
 *
 *       public function onLoadComplete(fileLoader:FileLoader):Void {
 *           trace("Completed loading '" + fileLoader.getFile().getLocation() + "'.");
 *           var swfFile:SwfFile = SwfFile(fileLoader.getFile());
 *           if (swfFile != null) {
 *               // Correct file type.
 *           }
 *           else {
 *               // Illegal file type.
 *           }
 *       }
 *
 *       public function onLoadError(fileLoader:FileLoader, errorCode:String, error):Boolean {
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
 *   import org.as2lib.io.file.SwfFileLoader;
 *
 *   var container:MovieClip = this.createEmptyMovieClip("container", 1);
 *   var swfLoader:SwfFileLoader = new SwfFileLoader(container);
 *   swfLoader.addListener(new MySwfListener());
 *   swfLoader.load("test.swf");
 * </code>
 *
 * @author Martin Heidegger
 * @author Simon Wacker
 * @version 2.0
 */
class org.as2lib.io.file.SwfFileLoader extends AbstractFileLoader implements
		FileLoader, FrameImpulseListener {

	/** Time until the loading process fails with "file not found" error. */
	public static var TIMEOUT:Time = new Time(3000);

	/** Movie clip to load the file into. */
	private var movieClip:MovieClip;

	/** The loaded swf file. */
	private var swfFile:SwfFile;

    /** The previous loaded bytes. Updated on every frame impulse. */
    private var previousLoadedBytes:Number;

	/**
	 * Constructs a new {@code SwfFileLoader} instance.
	 *
	 * @param movieClip the movie clip to load the file into
	 */
	public function SwfFileLoader(movieClip:MovieClip) {
		this.movieClip = movieClip;
	}

	/**
	 * Sets the movie clip to load the file into.
	 *
	 * @param movieClip the movie clip to load the file into
	 */
	public function setMovieClip(movieClip:MovieClip):Void {
		this.movieClip = movieClip;
	}

	public function load(uri:String, method:String, parameters:Map, callback:Executable):Void {
		super.load(uri, method, parameters, callback);
		swfFile = null;
		endTime = null;
		if (parameters != null) {
			var keys:Array = parameters.getKeys();
			for (var i:Number = 0; i < keys.length; i++) {
				var key = keys[i];
				movieClip[key.toString()] = parameters.get(key);
			}
		}
		movieClip.loadMovie(uri, this.method);
		distributeStartEvent();
		FrameImpulse.getInstance().addFrameImpulseListener(this);
	}

	/**
	 * Returns the loaded file.
	 *
	 * <p>The returned file can be safely casted to {@link SwfFile}.
	 *
	 * @return the loaded file
	 * @throws FileNotLoadedException if the file has not been loaded yet
	 * @see #getSwfFile
	 */
	public function getFile(Void):File {
		return getSwfFile();
	}

	/**
	 * Returns the loaded swf file.
	 *
	 * @return the loaded swf file
	 * @throws FileNotLoadedException if the swf file has not been loaded yet
	 */
	public function getSwfFile(Void):SwfFile {
		if (!swfFile) {
			throw new FileNotLoadedException("Swf file has not been loaded yet.", this, arguments);
		}
		return swfFile;
	}

	public function getBytesLoaded(Void):Byte {
		var result:Number = movieClip.getBytesLoaded();
		if (result >= 0) {
			return new Byte(result);
		}
		return null;
	}

	public function getBytesTotal(Void):Byte {
		var total:Number = movieClip.getBytesTotal();
		if (total >= 0) {
			return new Byte(total);
		}
		return null;
	}

	/**
	 * Handles the next frame impulse by checking whether the SWF finished loading
	 * or whether loading timed-out.
	 */
	public function onFrameImpulse(impulse:FrameImpulse):Void {
		if (hasFinished()) {
			onLoadSuccess();
		}
		else if (hasTimedOut()) {
			onLoadFailure();
		}
	}

	/**
	 * Has the SWF file finished loading?
	 *
	 * @return {@code true} if the SWF file finished loading else {@code false}
	 */
    private function hasFinished(Void):Boolean {
    	var mc = eval(movieClip._target);
    	// workaround for a bug of the flash compiler
		movieClip = mc;
		var totalBytes:Number = movieClip.getBytesTotal();
		var loadedBytes:Number = movieClip.getBytesLoaded();
		if (totalBytes > 10 && totalBytes - loadedBytes < 10) {
			previousLoadedBytes = loadedBytes;
			return true;
		}
		if (loadedBytes != previousLoadedBytes) {
			if (loadedBytes > 0 && totalBytes > 10) {
				distributeProgressEvent();
			}
			previousLoadedBytes = loadedBytes;
		}
		return false;
	}

	/**
	 * Has the loading process timed-out?
	 *
	 * @return {@code true} if the duration exceeded the {@link TIMEOUT} and no bytes
	 * have been loaded yet, else {@code false}
	 */
	private function hasTimedOut():Boolean {
		if (movieClip.getBytesTotal() > 10) {
			return false;
		}
		return (getDuration().inMilliSeconds() > TIMEOUT);
	}

	/**
	 * Tears this loader down, creates the swf file and distributes the complete event.
	 *
	 * @see #tearDown
	 */
	private function onLoadSuccess(Void):Void {
		tearDown();
		swfFile = new SwfFile(movieClip, uri, getBytesTotal());
		distributeCompleteEvent();
	}

	/**
	 * Tears this loader down and distributes a "file not found" error event.
	 *
	 * @see #tearDown
	 * @see #FILE_NOT_FOUND_ERROR
	 */
	private function onLoadFailure(Void):Void {
		tearDown();
		distributeErrorEvent(FILE_NOT_FOUND_ERROR, uri);
	}

	/**
	 * Sets {@code finished} to {@code true}, {@code started} to {@code false},
	 * initializes the end time and removes this loader as frame impulse listener.
	 *
	 * @see #onFrameImpulse
	 */
	private function tearDown(Void):Void {
		finished = true;
		started = false;
		endTime = getTimer();
		FrameImpulse.getInstance().removeListener(this);
	}

}