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
import org.as2lib.io.URL; 
import org.as2lib.io.file.SwfFileLoader;
import org.as2lib.io.request.Request;
import org.as2lib.data.type.Byte;

/**
 * {@code SwfRequest} is a implementation of {@link Request} for {@code .swf} files.
 * 
 * <p>Any content to be loaded with {@code MovieClip#loadMovie} can be accessed with
 * {@code SwfRequest} to a concrete {@code MovieClip} instance that has to be
 * passed-in with the constructor.
 * 
 * @author Akira Ito
 * @version 1.0
 */
class org.as2lib.io.request.SwfRequest extends BasicClass implements Request {
	
	/** {@code URL} to be loaded into {@code container}. */		
	private var url:URL;

	/** {@code MovieClip} to loaded {@code URL} into. */	
	private var container:MovieClip;

	/** Path to the {@code MovieClip} to loaded {@code URL} into. */	
	private var containerTarget:String;
	
	/** {@code Byte} supposed size for this request. */	
	private var supposedSize:Byte;	

	/**
	 * Constructs a new {@code RequestListManager} instance.
	 * 
	 * @param {@code URL} to be loaded 
	 * @param {@code MovieClip} to be loaded into
	 * @param {@code Number} size as Number (optional)
	 */		
	public function SwfRequest(url:URL, container, size:Number) {
		this.url = url;
		setContainer(container);
		supposedSize = new Byte(size);		
	}

	/**
	 * Returns the {@code URL} of the resource that will be requested to load.
	 * 
	 * @return URL of the resource to load
	 */	
	public function getUrl(Void):URL {
		return url;
	}

	/**
	 * Sets the {@code URL} of the resource that will be requested to load. 
	 * 
	 * @param URL of the resource to load
	 */
	public function setUrl(url:URL):Void{
		this.url = url;
	}
	
		
	/**
	 * Returns the container for the resource that will be requested to load.
	 * 
	 * @return {@code MovieClip} container for request to load into.
	 */
	public function getContainer(Void) {
		if(container) { 

			return container;
		}
		else {
			return containerTarget;
		}
	}
	
	/**
	 * Sets the container for the resource that will be requested to load.
	 * 
	 * @param container, it's type depends on certain implementation of {@code Request} interface.
	 */
	public function setContainer(p):Void {
		if((typeof p) == "string"){
			this.containerTarget = p;
		} else if((typeof p) == "movieclip"){
			this.container = p;
		}

	}	
	
	/**
	 * Returns the supposed size (if set) for the resource.
	 * 
	 * @return {@code Byte} size in bytes.
	 */
	public function getSupposedSize(Void):Byte {
		return supposedSize;
	}
	
	/**
	 * Returns bytes loaded for the resource.
	 * 
	 * @return {@code Byte} size in bytes.
	 */
	public function getBytesLoaded(Void):Byte {
		return new Byte(container.getBytesLoaded());
	}
	
		/**
	 * Returns bytes total for the resource.
	 * 
	 * @return {@code Byte} size in bytes.
	 */
	public function getBytesTotal(Void):Byte{
		return new Byte(container.getBytesTotal());
	}	
}