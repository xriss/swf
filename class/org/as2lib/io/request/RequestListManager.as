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

import org.as2lib.env.event.EventSupport;
import org.as2lib.io.file.FileLoader;
import org.as2lib.io.file.LoadProgressListener;
import org.as2lib.io.file.LoadCompleteListener;
import org.as2lib.io.file.LoadErrorListener;
import org.as2lib.io.request.Request;
import org.as2lib.io.request.RequestManager;
import org.as2lib.io.request.RequestHandler;
import org.as2lib.io.request.RequestSetLoadStartListener;
import org.as2lib.io.request.RequestSetLoadProgressListener;
import org.as2lib.io.request.RequestSetLoadCompleteListener;
import org.as2lib.io.request.RequestSetLoadErrorListener;
import org.as2lib.io.request.RequestSetFocusListener;
import org.as2lib.io.request.NoRequestHandlerFoundException;
import org.as2lib.io.request.RequestManagerBusyException;
import org.as2lib.app.exec.Executable; 
import org.as2lib.app.exec.AbstractTimeConsumer;
import org.as2lib.data.type.Byte;
import org.as2lib.data.holder.Map;
import org.as2lib.data.holder.map.HashMap;
import org.as2lib.data.holder.List;
import org.as2lib.data.holder.list.ArrayList;
import org.as2lib.data.holder.list.ListIterator;
import org.as2lib.data.holder.Iterator;
import org.as2lib.env.event.distributor.SimpleConsumableCompositeEventDistributorControl;

/**
 * {@code RequestListManager} is a central distributor for processing list of {@code Request}s.
 * 
 * <p>Before loading any type of request, you should instantiate a {@code RequestHadler} and set 
 * this handler. 
 * 
 * <p>You may change order of requests loading by writing of custom {@code Iterator}.
 * Iterator is {@code ListIterator} by default.
 * 
 * <p>{@code RequestListManager} uses one-after-one loading, this means next item will be taken 
 * from the list after previous is fully loaded.
 * 
 * <p>Each {@code Request} have{@code supposedSize} variable, it instantiates at constructor.
 * If this variable is omitted for any request in the list, {@code RequestListManager}
 * will count progress by items loaded / items total ratio, not by real byte sizes.
 * 
 * <p>{@code RequestListManager} publishes {@code RequestSet} event line.
 * 
 * <p>Example for using {@code RequestListManager}:
 * <code>
 *   import org.as2lib.io.request.RequestListManager;
 *   import org.as2lib.io.request.SwfRequestHandler;
 *   import org.as2lib.io.request.SwfRequest;
 *   import org.as2lib.io.URL;   
 *  
 *	 loader = new RequestListManager();
 *	 swfHandler = new SwfRequestHandler();
 *	 loader.setRequestHandler(SwfRequest, swfHandler);
 *		
 *	 loader.add(new SwfRequest(new URL("test_1.swf"), swfTarget, 554));
 *	 loader.add(new SwfRequest(new URL("test_2.swf"), swfTarget2, 2338681));
 *	 loader.load();
 * </code>
 * 
 * @author Akira Ito
 * @version 1.0
 */

class org.as2lib.io.request.RequestListManager extends AbstractTimeConsumer
	implements RequestManager, 
		LoadCompleteListener,
		LoadErrorListener,
		LoadProgressListener,
		RequestSetFocusListener {
	
	/** Distributor control for event distribution. */		
	private var distributorControl:SimpleConsumableCompositeEventDistributorControl;		

	/** Distributors required for event distribution. */		
	private var focusDistributor:RequestSetFocusListener;
	private var startDistributor:RequestSetLoadStartListener;
	private var progressDistributor:RequestSetLoadProgressListener;
	private var completeDistributor:RequestSetLoadCompleteListener;
	private var errorDistributor:RequestSetLoadErrorListener;
			
	/** Map contains handlers available to this instance of {@code RequestListManager}. */	
	private var handlers:Map;
	
	/** ArrayList contains requests for this instance of {@code RequestListManager}. */	
	private var requests:ArrayList;

	/** Current {@code Request} under processing. */		
	private var request:Request;
	
	/** Current {@code RequestHadnler} for current {@link request}. */
	private var handler:RequestHandler;
	
	/** Iterator for iterating {@link requests}, can be overriden by {@code setIterator}, {@code ListIterator} by default. */
	private var iterator:Iterator;		
	
	/** Bytes total for all requests, {@code undefined}, if any of requests have its {@code supposedSize} missing. */
	private var bytesTotal:Byte;
	
	/** Bytes loaded before current request was started. */
	private var bytesLoadedBefore:Byte;
	
	/** Number of requests already loaded. */
	private var itemsLoaded:Number;
	/**
	 * Constructs a new {@code RequestListManager} instance.
	 */			
	public function RequestListManager() {
		super();

		// initiate events
		distributorControl = new SimpleConsumableCompositeEventDistributorControl();
		
		distributorControl.acceptListenerType(RequestSetLoadCompleteListener);
		distributorControl.acceptListenerType(RequestSetLoadProgressListener);
		distributorControl.acceptListenerType(RequestSetLoadErrorListener);
		distributorControl.acceptListenerType(RequestSetFocusListener);

		completeDistributor = distributorControl.getDistributor(RequestSetLoadCompleteListener);
		progressDistributor = distributorControl.getDistributor(RequestSetLoadProgressListener);
		startDistributor = distributorControl.getDistributor(RequestSetLoadErrorListener);
		focusDistributor = distributorControl.getDistributor(RequestSetFocusListener);
				
		requests = new ArrayList();
		handlers = new HashMap();
	}
	
    /**
	 * Sets {@code RequestHandler} for processing different types of requests.
	 * 
	 * @param handler type
	 * @param instance of {@code RequestHandler}
	 */
	public function setRequestHandler(type:Function, handler:RequestHandler):Void {
		handlers.put(type, handler);
	}	
	
	/**
	 * Adds the passed-in {@code listener}.
	 * 
	 * @param listener the listener to add
	 */
	public function addListener(obj) {
		distributorControl.addListener(obj);
	}


	/**
	 * Removes the passed-in {@code listener}.
	 * 
	 * @param listener the listener to remove
	 */
	public function removeListener(obj) {
		distributorControl.removeListener(obj);	
	}
	
    /**
	 * Adds {@code Request} into list of requests to be proceeded.
	 * 
	 * @param instance of {@code Request}
	 */
	public function add(request:Request):Void {
		requests.insert(request);
	}

    /**
	 * Sets custom iterator for processing {@code requests}.
	 * 
	 * @param {@code Iterator}
	 */
	public function setIterator(itr:Iterator):Void {
		 iterator = itr;
	}
	
    /**
	 * Loads list of {@code Request}s.
	 * 
	 * @param {@code Executable} callback to be executed after loading is finished. 
	 */	
	public function load(callBack:Executable):Void {
		// defining total size of all elements
		var sizeIterator:Iterator = new ListIterator(requests);
		var elementSize:Number;
		var bTotal:Number = 0;
		var startDistributor:RequestSetLoadStartListener;
		
		while (sizeIterator.hasNext()) {
    		elementSize = sizeIterator.next().getSupposedSize().valueOf();
    		if (elementSize) {  
    			bTotal += elementSize; 
    		} else { 
    			delete bytesTotal; 
    			break; 
    		}
		}
		if(bTotal>0) bytesTotal = new Byte(bTotal);
		bytesLoadedBefore = new Byte(0); 
		itemsLoaded = 0;
		started = true;
		finished = false;
		startTime = getTimer();
		if(iterator == undefined) iterator = new ListIterator(requests);
		// launch RequestSetLoadStart event
		startDistributor.onRequestSetLoadStart(this);
		handleNext();
	}
	
    /**
	 * Handles one {@code Request}.
	 * 
	 * @param {@code Request} to be handled. 
	 */		
	public function handleRequest(request:Request):Void {
		var keys:Array = handlers.getKeys();
		var values:Array = handlers.getValues();
		var i:Number;
		
		removeHandler();
		for(i=0;i<keys.length;i++) {
			if (request instanceof keys[i]) {	handler = values[i];  break; }
		}
		if(handler) {
			handler.addListener(this);
			handler.handleRequest(request);
		} else {
			throw new NoRequestHandlerFoundException("No appropriate handler found for request [" + request + "].", this, arguments);
		}
	}

    /**
	 * Removes current handler.
	 */		
	public function removeHandler():Void {
		if(handler) { 
			handler.removeListener(this);
			delete handler; 
		}		
	}
			
    /**
	 * Handles next {@code Request} in the list.
	 */		
	public function handleNext():Void {
		if(request) {		
			// remove current request just was loaded			
			delete request;
		}			
		removeHandler(); 
		request = iterator.next();
		handleRequest(request);
	}

    /**
	 * Returns list of {@code Request}s for this instance of {@code RequestListManager}.
	 * 
	 * @return {@code List}
	 */			
	// NOTE: with AS3 we have no longer need to load every time same uri to different targets,
	// thus, we may want to change queue type to Map, keyed by uri
	function getList(Void):List {
		return requests;
	}
	
    /**
	 * Returns current {@code Request} being processed.
	 * 
	 * @return {@code Request}
	 */			
	function getCurrentRequest(Void):Request {
		return request;
	}
	
	/**
	 * Stub implementation for the amount of bytes already loaded.
	 * 
	 * @return {@code Byte}
	 */
	public function getBytesLoaded(Void):Byte {
		var result:Number = Number(bytesLoadedBefore.valueOf());
		var loadedBytes  = handler.getLoader().getBytesLoaded();
		if(request) {
			result += (loadedBytes>=0 && loadedBytes) ? loadedBytes : 0;
		}
		return new Byte(result);
	}	

	/**
	 * Stub implementation for the amount of bytes to be loaded.
	 * 
	 * @return {@code Byte}
	 */	
	public function getBytesTotal(Void):Byte {
		return bytesTotal;
	}

	/**
	 * Stub implementation for the number of items to be loaded.
	 * 
	 * @return {@code Number}
	 */		
	public function getItemsLoaded(Void):Number {
		return itemsLoaded;
	}

	/**
	 * Stub implementation for the number of items already loaded.
	 * 
	 * @return {@code Number}
	 */		
	public function getItemsTotal(Void):Number {
		return requests.size();
	}

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
	public function getPercentage(Void):Number {
		if (hasStarted() || hasFinished()) {
			var percentage:Number;
			if(getBytesTotal()) {
				percentage = ( 100 / getBytesTotal().getBytes() * getBytesLoaded().getBytes() );
			} else {
				percentage = ( 100 / getItemsTotal() * getItemsLoaded() );
			}
			if (percentage >= 100) {
				percentage = 100;
			}
			return percentage;
		} else {
			return null;
		}
	}
	
	/**
	 * (implementation detail) Handles the change of current request.
	 *
  	 * <p>Invokes {@code onRequestSetFocusChange} event for all listeners.	  
	 * 
	 * @param requestManager {@code RequestManager} where change of focus has occured (this).
	 */
	public function onRequestSetFocusChange(requestManager:RequestManager):Void {
		focusDistributor.onRequestSetFocusChange(this);
	}
	
	/**
	 * (implementation detail) Handles the response of a finished {@code Request}.
	 * 
	 * <p>Invokes {@code onRequestSetLoadComplete} event for all listeners, if called by last request in the list.
	 * 
	 * @param fileLoader {@code FileLoader} that loaded the certain resource
	 */
	public function onLoadComplete(resourceLoader:FileLoader):Void {
		// adding bytes loaded to RequestListManager' bytesLoaded
		bytesLoadedBefore = new Byte(Number(bytesLoadedBefore.valueOf() + resourceLoader.getBytesTotal().valueOf()));
		// increasing number of loaded items
		itemsLoaded++;

		onRequestSetFocusChange(this);
		
		// if we have anothrt request to load...		
		if(iterator.hasNext()) {
			// load it...
			handleNext();
			// ..and notify all listeners that we're making progress here.
			onLoadProgress(resourceLoader);
		} else {
			finished = false;
			// 	if no more requests, notify all listeners that we're finished			
			completeDistributor.onRequestSetLoadComplete(this);
			_root.log("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
		}
	}


	/**
	 * (implementation detail) Handles the response if a {@code FileLoader} could not find a resource.
	 * 
	 * <p>Invokes {@code onRequestSetLoadError} event for all listeners.
	 *  
	 * @param resourceLoader {@code FileLoader} that loaded the certain resource
	 */
	public function onLoadError(resourceLoader:FileLoader, errorCode:String, error):Boolean {
		return errorDistributor.onRequestSetLoadError(this, errorCode, error);
	}

	/**
	 * (implementation detail) Handles the response if a {@code FileLoader} progressed loading.
	 * 
	 * <p>Invokes {@code onRequestSetLoadProgress} event for all listeners.
	 *  
	 * @param resourceLoader {@code FileLoader} that loaded the certain resource
	 */
	public function onLoadProgress(resourceLoader:FileLoader):Void {
			progressDistributor.onRequestSetLoadProgress(this);
	}	
}