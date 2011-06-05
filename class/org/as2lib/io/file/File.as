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

import org.as2lib.core.BasicInterface;
import org.as2lib.data.type.Byte;

/**
 * {@code File} represents a loaded file with a location and a size.
 *
 * <p>{@link FileLoader} instances are responsible for loading files.
 *
 * @author Martin Heidegger
 * @author Simon Wacker
 * @version 1.0
 */
interface org.as2lib.io.file.File extends BasicInterface {

	/**
	 * Returns the location of this file that was used to load this file's content.
	 *
	 * <p>Note: Might be the URI of this file or {@code null} if it is not requestable
	 * or the internal location that is the instance path (if this file is not
	 * connected to a real file in a file system). Refer to the documentation of the
	 * implementing class for detailed information on which kind of location is
	 * returned.
	 *
	 * @return the location of this file
	 */
	public function getLocation(Void):String;

	/**
	 * Returns the size of this file in bytes.
	 *
	 * @return the size of this file in bytes
	 */
	public function getSize(Void):Byte;

}