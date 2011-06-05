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

import org.as2lib.io.file.File;

/**
 * {@code TextFile} represents a human readable file. The content of the file can
 * be obtained via {@link #getContent}.
 *
 * <p>A text file shall <i>not</i> be used for binary files.
 *
 * @author Martin Heidegger
 * @author Simon Wacker
 * @version 2.0
 */
interface org.as2lib.io.file.TextFile extends File {

	/**
	 * Returns the content of this file.
	 *
	 * @return the content of this file
	 */
	public function getContent(Void):String;

}