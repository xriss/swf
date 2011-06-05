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

import org.as2lib.io.request.RequestManager;

/**
 * {@code RequestSetLoadProgressListener} can be implemented if its necessary to listen
 * to {@code onRequestSetLoadProgress} events of {@link RequestManager}s.
 * 
 * @author Akira Ito
 * @version 1.0
 */
interface org.as2lib.io.request.RequestSetLoadProgressListener {
	
	/**
	 * Event to be published if the {@code RequestManager} makes a progress during loading set of {@code Request}s.
	 * 
	 * @param {@code RequestManager} 
	 */
	public function onRequestSetLoadProgress(requestManager:RequestManager):Void;
}