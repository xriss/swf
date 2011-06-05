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

import org.as2lib.io.file.PropertiesFile;
import org.as2lib.io.file.PropertiesFileFactory;
import org.as2lib.io.file.TextFileLoader;

/**
 * {@code PropertiesFileLoader} loads properties files.
 *
 * <p>The file returned by the {@link #getFile} method is an instance of type
 * {@link PropertiesFile}; you can safely cast the returned file to this type.
 * You may alternatively use {@link #getPropertiesFile} which returns a properly
 * typed properties file.
 *
 * @author Simon Wacker
 */
class org.as2lib.io.file.PropertiesFileLoader extends TextFileLoader {

	/**
	 * Constructs a new {@code PropertiesFileLoader} instance with a
	 * {@link PropertiesFileFactory} instance.
	 */
	public function PropertiesFileLoader(Void) {
		super(new PropertiesFileFactory());
	}

	/**
	 * Returns the loaded properties file.
	 *
	 * @return the loaded properties file
	 * @throws FileNotLoadedException if the file has not been loaded yet
	 */
	public function getPropertiesFile(Void):PropertiesFile {
		return PropertiesFile(getFile());
	}

}