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
import org.as2lib.io.file.SwfFileLoader;
import org.as2lib.io.request.Request;
import org.as2lib.io.request.RequestHandler;
import org.as2lib.data.type.Byte;
import org.as2lib.env.event.EventSupport;
import org.as2lib.io.URL;
import org.as2lib.io.file.FileLoader;
import org.as2lib.io.file.LoadCompleteListener;
import org.as2lib.io.file.LoadErrorListener;
import org.as2lib.io.file.LoadProgressListener;
import org.as2lib.io.file.LoadStartListener;
import org.as2lib.util.MovieClipUtil;

/**
 * {@code SwfRequestHandler} is built to handle {@code SwfRequest}s, implements {@code RequestHandler}.
 * 
 * <p>A {@code RequestHandler} instantiates loader for {@code Request}, and 
 * allows to return it. {@code RequestHandler} also can distribute events,
 * so {@code addListener} and {@code removeListener} should be implemented.
 * 
 * @author Akira Ito
 * @version 1.0
 */
class org.as2lib.io.request.SwfRequestHandler extends EventSupport implements RequestHandler, 
		LoadStartListener,
		LoadCompleteListener,
		LoadErrorListener,
		LoadProgressListener {

	/** {@code SwfFileLoader} file loader */ 			
	private var fileLoader:SwfFileLoader;
	
	/**
	 * Constructs a new {@code SwfRequestHandler} instance.
	 */		
	public function SwfRequestHandler() {
		acceptListenerType(LoadStartListener);
		acceptListenerType(LoadCompleteListener);
		acceptListenerType(LoadProgressListener);
		acceptListenerType(LoadErrorListener);
	}

	/**
	 * Returns a {@code FileLoader} that is used for loading this type of requests.
	 * 
	 * @return {@code FileLoader}
	 */	
	public function getLoader(Void):FileLoader {
		return fileLoader;
	}	
	
	/**
	 * Handles a request.
	 * 
	 * @param {@code SwfRequest} to be handled
	 */	
	public function handleRequest(request:Request):Void {
		var url:URL = request.getUrl();
		var container = request.getContainer();
		
		if(fileLoader) delete fileLoader;
		if((typeof container) == "string"){
			request.setContainer(MovieClipUtil.getMovieClip(container));
			container = request.getContainer();
		}
		fileLoader = new SwfFileLoader(request.getContainer());
		fileLoader.addListener(this);
		fileLoader.load(url.toPath(), url.getMethod(), url.getDataMap());   		
	}
	
	/**
	 * (implementation detail) Handles the response of a finished {@code FileLoader}.
	 * 
	 * @param fileLoader {@code FileLoader} that loaded the certain resource
	 */
	public function onLoadComplete(fileLoader:FileLoader):Void {
		var completeDistributor:LoadCompleteListener =
			distributorControl.getDistributor(LoadCompleteListener);
		completeDistributor.onLoadComplete(fileLoader);
	}

	/**
	 * (implementation detail) Handles the response if a {@code FileLoader}
	 * started working.
	 * 
	 * @param resourceLoader {@code FileLoader} that loaded the certain resource
	 */
	public function onLoadStart(resourceLoader:FileLoader):Void {
		var errorDistributor:LoadStartListener =
			distributorControl.getDistributor(LoadStartListener);
		errorDistributor.onLoadStart(resourceLoader);
	}

	/**
	 * (implementation detail) Handles the response if a {@code FileLoader}
	 * could not find a resource.
	 * 
	 * @param resourceLoader {@code FileLoader} that loaded the certain resource
	 */
	public function onLoadError(resourceLoader:FileLoader, errorCode:String, error):Boolean {
		var errorDistributor:LoadErrorListener =
			distributorControl.getDistributor(LoadErrorListener);
		return errorDistributor.onLoadError(resourceLoader, errorCode, error);
	}

	/**
	 * (implementation detail) Handles the response if a {@code FileLoader}
	 * progressed loading.
	 * 
	 * @param resourceLoader {@code FileLoader} that loaded the certain resource
	 */
	public function onLoadProgress(resourceLoader:FileLoader):Void {
		var progressDistributor:LoadProgressListener =
			distributorControl.getDistributor(LoadProgressListener);
		progressDistributor.onLoadProgress(resourceLoader);
	}

}