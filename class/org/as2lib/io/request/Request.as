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

import org.as2lib.io.URL;
import org.as2lib.data.type.Byte;

/**
 * {@code Request} is built to describe common request methods.
 * 
 * <p>A {@code Request} consists of {@code URL}, container to load URL in, 
 * and addtitional variables.
 * 
 * <p>It is build to handle the loading of one resource into one target. 
 * But it can be executed twice or more often. 
 * 
 * @author Akira Ito
 * @version 1.0
 */

interface org.as2lib.io.request.Request {

	/**
	 * Returns the {@code URL} of the resource that will be requested to load.
	 * 
	 * @return URL of the resource to load
	 */
	public function getUrl(Void):URL;

	/**
	 * Sets the {@code URL} of the resource that will be requested to load. 
	 * 
	 * @param URL of the resource to load
	 */
	public function setUrl(url:URL):Void;

	/**
	 * Returns the container for the resource that will be requested to load.
	 * 
	 * @return container, it's type depends on certain implementation of {@code Request} interface.
	 */
	public function getContainer(Void);

	/**
	 * Sets the container for the resource that will be requested to load.
	 * 
	 * @param container, it's type depends on certain implementation of {@code Request} interface.
	 */
	public function setContainer(p):Void;
	
	/**
	 * Returns bytes loaded for the resource.
	 * 
	 * @return {@code Byte} size in bytes.
	 */
	public function getBytesLoaded(Void):Byte;
	
		/**
	 * Returns bytes total for the resource.
	 * 
	 * @return {@code Byte} size in bytes.
	 */
	public function getBytesTotal(Void):Byte;
}