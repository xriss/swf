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

import org.as2lib.data.type.Byte;
import org.as2lib.io.file.AbstractFile;
import org.as2lib.io.file.TextFile;

/**
 * {@code SimpleTextFile} represents a simple text file with location, size and
 * human readable content that is not formatted in any special way (it is neither
 * a properties file, nor an XML file, ...).
 *
 * @author Martin Heidegger
 * @author Simon Wacker
 * @version 2.0
 */
class org.as2lib.io.file.SimpleTextFile extends AbstractFile implements TextFile {

	/** Content of the file. */
	private var content:String;

	/**
	 * Constructs a new {@code SimpleTextFile} instance.
	 *
	 * @param content the content of this text file
	 * @param size the size in byte of this text file
	 * @param location the location of this text file
	 */
	public function SimpleTextFile(content:String, size:Byte, location:String) {
		super(location, size);
		this.content = content;
	}

	public function getContent(Void):String {
		return content;
	}

}