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
 * {@code LoadCompleteListener} can be implemented by classes which want to be
 * notified when a {@link FileLoader} completed loading a file.
 *
 * @author Martin Heidegger
 * @author Simon Wacker
 * @version 1.0
 */
interface org.as2lib.io.file.LoadCompleteListener {

	/**
	 * Is invoked when the file loader finished loading.
	 *
	 * <p>Note that this event will not be invoked when the file to load does not
	 * exist.
	 *
	 * @param fileLoader the file loader that finished loading and that contains the
	 * loaded file
	 */
	public function onLoadComplete(fileLoader:FileLoader):Void;

}