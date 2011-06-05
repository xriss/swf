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
import org.as2lib.io.file.TextFile;

/**
 * {@code TextFileFactory} creates instances of {@link TextFile} implementations.
 * Text file factories are used by {@link TextFileLoader} instances. This makes it
 * possible to customize the concrete text file type used by a text file loader.
 * Configured with the correct text file factory a text file loader can be used to
 * load xml files, properties files etc.
 *
 * @author Martin Heidegger
 * @author Simon Wacker
 * @version 1.0
 */
interface org.as2lib.io.file.TextFileFactory extends BasicInterface {

	/**
	 * Creates a new {@code TextFile} instance for the loaded file.
	 *
	 * @param content the content of the loaded file
	 * @param size the size in byte of the loaded file
	 * @param uri the URI of the loaded file
	 * @return the text file which represents the loaded file
	 */
	public function createTextFile(content:String, size:Byte, uri:String):TextFile;

}