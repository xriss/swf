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

import org.as2lib.io.file.FileLoader;

/**
 * {@code LoadErrorListener} can be implemented by classes which want to be notified
 * when an error occurred during loading of a file.
 *
 * @author Martin Heidegger
 * @author Simon Wacker
 * @version 1.0
 */
interface org.as2lib.io.file.LoadErrorListener {

	/**
	 * Is invoked when an error occurred during loading of a file.
	 *
	 * @param fileLoader the file loader that tried to load a file
	 * @param errorCode the error code to identify the error (may be used to look-up
	 * a localized error message from a message source)
	 * @param error further information about the error (possibly an exception)
	 * @return {@code true} to consume the event otherwise {@code false}
	 */
	public function onLoadError(fileLoader:FileLoader, errorCode:String, error):Boolean;

}