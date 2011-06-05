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
import org.as2lib.io.request.Request;

/**
 * {@code RequestHandler} is built to handle {@code Request}.
 * 
 * <p>A {@code RequestHandler} instantiates loader for {@code Request}, and 
 * allows to return it. {@code RequestHandler} also can distribute events,
 * so {@code addListener} and {@code removeListener} should be implemented.
 * 
 * @author Akira Ito
 * @version 1.0
 */

interface org.as2lib.io.request.RequestHandler {
	
	/**
	 * Handles a certain request.
	 * 
	 * @param {@code Request} to be handled
	 */
	public function handleRequest(request:Request):Void;
	
	/**
	 * Adding listener to this handler to be notified about events.
	 * 
	 * @param {@code listener} to be added
	 */
	public function addListener(listener):Void;
	
	/**
	 * Removes listener from listeners list.
	 * 
	 * @param {@code listener} to be removed
	 */
	public function removeListener(listener):Void;
	
	/**
	 * Returns a {@code FileLoader} that is used for loading this type of requests.
	 * 
	 * @return {@code FileLoader}
	 */
	public function getLoader(Void):FileLoader;
}