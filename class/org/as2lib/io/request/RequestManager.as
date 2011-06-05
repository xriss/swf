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
import org.as2lib.io.request.Request;

/**
 * {@code RequestManager} is built to manage sets of {@code Request}s.
 * 
 * <p>A {@code RequestManager} allows to manage (to load, in general) 
 * a set of {@code Request}s and provide event support for this process.
 * 
 * <p>Example to handle the loading of a resource:
 * <code>
 *   import org.as2lib.io.URL;
 *   import org.as2lib.io.request.SwfRequest;    
 *   import org.as2lib.io.request.RequestSetLoadStartListener;
 *   import org.as2lib.io.request.RequestSetLoadCompleteListener;
 *   import org.as2lib.io.request.RequestSetLoadProgressListener;
 *   import org.as2lib.io.request.RequestSetLoadErrorListener;
 *   
 *   class Main implements
 *   	RequestSetFocusListener,   
 *   	RequestSetLoadStartListener,
 *   	RequestSetLoadCompleteListener,
 *   	RequestSetLoadErrorListener,
 *   	RequestSetLoadProgressListener {
 *   
 *     public function main(loader:RequestManager):Void {
 *		 loader.add(new SwfRequest(new URL("test_1.swf"), swfTarget, 554));
 *	     loader.add(new SwfRequest(new URL("test_2.swf"), swfTarget2, 2338681));
 *	     loader.load();
 *     }
 *     
 *     public function onRequestSetLoadComplete(loader: RequestManager):Void {
 *       // Do anything you like....
 *     }
 *     
 *     public function onRequestSetLoadError(loader: RequestManager, errorCode:String, error):Boolean {
 *       if (errorCode == AbstractFileLoader.FILE_NOT_FOUND_ERROR) {
 *       	trace("Resource could not be found"+error);
 *       }
 *       return false
 *     }
 *     
 *     public function onRequestSetLoadProgress(loader:RequestManager):Void {
 *       trace("loaded: "+loader.getPercentage()+"%  ");
 *     }
 *     
 *     public function onRequestSetLoadStart(loader:RequestManager):Void {
 *     	 trace("started loading");
 *     }
 *     
 *     public function onRequestSetFocusChange(loader:RequestManager):Void {
 *     	 trace("proceeding next request");
 *     }     
 *   }
 * </code>
 * 
 * @author Akira Ito
 * @version 1.0
 */

interface org.as2lib.io.request.RequestManager {

	/**
	 * Stub implementation for the amount of bytes already loaded.
	 * 
	 * @return {@code Byte}
	 */	 		
	public function getBytesLoaded(Void):Byte;

	/**
	 * Stub implementation for the amount of bytes to be loaded.
	 * 
	 * @return {@code Byte}
	 */			
	public function getBytesTotal(Void):Byte;
	
	/**
	 * Stub implementation for the number of items already loaded.
	 * 
	 * @return {@code Number}
	 */	
	public function getItemsLoaded(Void):Number;
	

	/**
	 * Stub implementation for the number of items to be loaded.
	 * 
	 * @return {@code Number}
	 */			 
	public function getItemsTotal(Void):Number;
	
	/**
	 * Returns current request under processing
	 * 
	 * @return {@code Request}
	 */			 
	public function getCurrentRequest(Void):Request;	

	/**
	 * Returns the pecentage of the request list that has been loaded.
	 * 
	 * <p>If supposed size of every item is known, evaluates the current 
	 * percentage of the execution by using {@code getBytesTotal} and {@code getBytesLoaded}.
	 * 
	 * <p>If it is not, current percentage will be evaluated by using {@code getItemTotal} and {@code getItemLoaded}.
	 * 
	 * <p>Returns {@code null} if the percentage is not evaluable
	 * 
	 * @return percentage of the total process
	 */
	public function getPercentage(Void):Number;
}