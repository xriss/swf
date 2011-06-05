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

import org.as2lib.io.file.TextFileLoader;
import org.as2lib.io.file.XmlFile;
import org.as2lib.io.file.XmlFileFactory;

/**
 * {@code XmlFileLoader} manages loading XML-files.
 *
 * <p>The file returned by the {@link #getFile} method is an instance of type
 * {@link XmlFile}; you can safely cast the returned file to this type. You may
 * alternatively use {@link #getXmlFile} which returns a properly typed xml file.
 *
 * @author Simon Wacker
 */
class org.as2lib.io.file.XmlFileLoader extends TextFileLoader {

	/**
	 * Constructs a new {@code XmlFileLoader} instance.
	 */
	public function XmlFileLoader(Void) {
		super(new XmlFileFactory());
	}

	/**
	 * Returns the loaded xml file.
	 *
	 * @return the loaded xml file
	 * @throws FileNotLoadedException if the file has not been loaded yet
	 */
	public function getXmlFile(Void):XmlFile {
		return XmlFile(getFile());
	}

}