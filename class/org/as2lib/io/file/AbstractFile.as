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

import org.as2lib.core.BasicClass;
import org.as2lib.data.type.Byte;
import org.as2lib.env.reflect.ReflectUtil;
import org.as2lib.io.file.File;

/**
 * {@code AbstractFile} contains code that is mostly the same for all {@link File}
 * implementations.
 *
 * @author Simon Wacker
 */
class org.as2lib.io.file.AbstractFile extends BasicClass implements File {

	/** The location of this file. */
	private var location:String;

	/** The size of this file. */
	private var size:Byte;

	/**
	 * Constructs a new {@code AbstractFile} instance.
	 *
	 * @param location the location of this file
	 * @param size the size of this file
	 */
	private function AbstractFile(location:String, size:Byte) {
		this.location = location;
		this.size = size;
	}

	public function getLocation(Void):String {
		return location;
	}

	public function getSize(Void):Byte {
		return size;
	}

	/**
	 * Returns the string representation of this file.
	 *
	 * <p>Example:
	 * <pre>[type org.as2lib.io.file.SimpleTextFile(location: MyTextFile.txt; size: 12KB)]</pre>
	 *
	 * @return the {@code TextFile} as string
	 */
	public function toString():String {
		return ("[type " + ReflectUtil.getTypeNameForInstance(this) +
				"(location: " + getLocation() +
				"; size: " + getSize().toString(false, 2) +
				")]");
	}

}