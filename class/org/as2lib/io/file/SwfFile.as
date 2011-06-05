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
import org.as2lib.env.reflect.ReflectUtil;
import org.as2lib.io.file.AbstractFile;
import org.as2lib.io.file.MediaFile;

/**
 * {@code SwfFile} represents a SWF file.
 *
 * <p>Note that this file can also be used to represent images.
 *
 * @author Martin Heidegger
 * @author Simon Wacker
 * @version 1.0
 */
class org.as2lib.io.file.SwfFile extends AbstractFile implements MediaFile {

	/** The container holding the loaded file. */
	private var container:MovieClip;

	/**
	 * Constructs a new {@code SwfFile} instance.
	 *
	 * @param container the movieclip that contains the loaded file
	 * @param location (optional) the location of this file (default is
	 * {@code container._url})
	 * @param size (optional) the size of this file (default is
	 * {@code container.getBytesTotal()})
	 */
	public function SwfFile(container:MovieClip, location:String, size:Byte) {
		super(resolveLocation(location, container), resolveSize(size, container));
		this.container = container;
	}

	/**
	 * Resolves the location of this file. If the given location is not {@code null}
	 * it will be returned, otherwise {@code container._url} will be returned.
	 */
	private function resolveLocation(location:String, container:MovieClip):String {
		if (location == null) {
			return container._url;
		}
		return location;
	}

	/**
	 * Resolves the size of this file. If the given size is not {@code null} it will
	 * be returned, otherwise {@code container.getBytesTotal()} will be returned.
	 */
	private function resolveSize(size:Byte, container:MovieClip):Byte {
		if (size == null) {
			return new Byte(container.getBytesTotal());
		}
		return size;
	}

	/**
	 * Returns the container holding the content of this file.
	 *
	 * @return the container holding the content of this file
	 */
	public function getContainer(Void):MovieClip {
		return container;
	}

}