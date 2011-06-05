/**
* MochiServices
* Connection class for all MochiAds Remote Services
* @author Mochi Media+
* @version 1.1
*/

class mochi.MochiServices {

	private static var _id:String;
	private static var _container:MovieClip;
	private static var _loader:MovieClipLoader;
	private static var _loaderListener:Object;
	private static var _gatewayURL:String = "http://www.mochiads.com/static/lib/services/services.swf";
	private static var _swfVersion:String;
	
	private static var _listenChannel:LocalConnection;
	private static var _listenChannelName:String = "__mochiservices";
	private static var _sendChannel:LocalConnection;
	private static var _sendChannelName:String;
	private static var _rcvChannel:LocalConnection;
	private static var _rcvChannelName:String;
	
	private static var _connecting:Boolean = false;
	private static var _connected:Boolean = false;
	
	public static var onError:Object;
	
	//
	public static function get id ():String {
		return _id;
	}
	
	//
	public static function get clip ():MovieClip {
		return _container;
	}

	//
	//
	static function getVersion():String {
        return "1.1";
    }
	
	//
	//
    private static function allowDomains(server:String):String {
        var hostname = server.split("/")[2].split(":")[0];
        if (System.security) {
            if (System.security.allowDomain) {
                System.security.allowDomain("*");
                System.security.allowDomain(hostname);
            }
            if (System.security.allowInsecureDomain) {
                System.security.allowInsecureDomain("*");
                System.security.allowInsecureDomain(hostname);
            }
        }
        return hostname;
    }
	
	//
	public static function get isNetworkAvailable():Boolean {
        if (System.security) {
            var o:Object = System.security;
            if (o.sandboxType == "localWithFile") {
                return false;
            }
        }
        return true;
    }
	
	//
	public static function set comChannelName(val:String):Void {
		if (val != undefined) {
			if (val.length > 3) {
				_sendChannelName = val + "_fromgame";
				_rcvChannelName = val;
				initComChannels();
			}
		}
	}
	
	//
	public static function get connected ():Boolean {
		return _connected;
	}
	
	/**
	 * Method: connect
	 * Connects your game to the MochiServices API
	 * @param	id the MochiAds ID of your game
	 * @param	clip the MovieClip in which to load the API (optional for all but AS3, defaults to _root)
	 * @param	onError a function to call upon connection or IO error
	 */
	public static function connect (id:String, clip:MovieClip, onError:Object):Void {
		if (!_connected && _container == undefined) {
			trace("MochiServices Connecting...");
			_connecting = true;
			init(id, clip);	
		}
		if (onError != undefined) {
			MochiServices.onError = onError;
		} else if (MochiServices.onError == undefined) {
			MochiServices.onError = function (errorCode:String):Void { trace(errorCode); }
		}
	}
	
	//
	//
	public static function disconnect ():Void {
		if (_connected || _connecting) {
			_connecting = _connected = false;
			if (_sendChannel._queue != undefined) {
				//_sendChannel._queue = [];
				//_rcvChannel._callbacks = { };
			}
			if (_container != undefined) {
				_container.removeMovieClip();
				delete _container;
			}
		}
	}
	
	//
	//
	private static function init (id:String, clip:MovieClip):Void {
		_id = id;
		if (clip != undefined) {
			_container = clip.createEmptyMovieClip("__mochiservicesMC", 16384/*clip.getNextHighestDepth()*/);
		} else {
			_container = _root.createEmptyMovieClip("__mochiservicesMC", _root.getNextHighestDepth());
		}
		loadCommunicator(id, _container);
	}
	
	//
	//
	private static function loadCommunicator (id:String, clip:MovieClip):Void {
        if (!MochiServices.isNetworkAvailable) {
            return;
        }
		MochiServices.allowDomains(_gatewayURL);
		// load com swf into container
		_loader = new MovieClipLoader();
		_loaderListener = {};
		_loaderListener.onLoadError = function (target_mc:MovieClip, errorCode:String, httpStatus:Number):Void { 
			trace("MochiServices could not load.");
			MochiServices.disconnect();
			MochiServices.onError.apply(null, [errorCode]);
		}
		_loader.addListener(_loaderListener);
		_loader.loadClip(_gatewayURL, clip);	
		// init send channel
		_sendChannel = new LocalConnection();
		_sendChannel._queue = [];
		// init rcv channel
		_rcvChannel = new LocalConnection();
		_rcvChannel.allowDomain = function (d:String):Boolean { return true; };
		_rcvChannel.allowInsecureDomain = _rcvChannel.allowDomain;
		_rcvChannel._nextcallbackID = 0;
		_rcvChannel._callbacks = {};
		listen();
	}

	//
	//
	private static function onStatus (infoObject:Object):Void {
        switch (infoObject.level) {	
			case 'error' :
				_connected = false;
				_listenChannel.connect(_listenChannelName);
				break;	
        }
    }
	
	//
	//
	private static function listen ():Void {
		_listenChannel = new LocalConnection();
		_listenChannel.handshake = function (args:Object):Void { MochiServices.comChannelName = args.newChannel; }
		_listenChannel.allowDomain = function (d:String):Boolean { return true; };
		_listenChannel.allowInsecureDomain = _listenChannel.allowDomain;
		_listenChannel.connect(_listenChannelName);
		trace("Waiting for MochiAds services to connect...");
	}
	
	//
	//
	private static function initComChannels ():Void {	
		if (!_connected) {	
			_sendChannel.onStatus = function (infoObject:Object):Void { MochiServices.onStatus(infoObject); }
			_sendChannel.send(_sendChannelName, "onReceive", {methodName: "handshakeDone"});
			_sendChannel.send(_sendChannelName, "onReceive", { methodName: "registerGame", id: _id, clip: _container, version: getVersion() } );
			_rcvChannel.onStatus = function (infoObject:Object):Void { MochiServices.onStatus(infoObject); }
			_rcvChannel.onReceive = function (pkg:Object):Void {
				var cb:String = pkg.callbackID;
				var cblst:Object = this._callbacks[cb];
				if (!cblst) return;
				var method = cblst.callbackMethod;
				var obj = cblst.callbackObject;
				if (obj && typeof(method) == 'string') method = obj[method];
				if (method != undefined) method.apply(obj, pkg.args);
				delete this._callbacks[cb];
			}
			_rcvChannel.onError = function ():Void { MochiServices.onError.apply(null, ["IOError"]); };
			_rcvChannel.connect(_rcvChannelName);
			trace("connected!");
			_connecting = false;
			_connected = true;
			_listenChannel.close();
			while(_sendChannel._queue.length > 0) {
				_sendChannel.send(_sendChannelName, "onReceive", _sendChannel._queue.shift());
			}
		}	
	}
	
	//
	//
	public static function send (methodName:String, args:Object, callbackObject:Object, callbackMethod:Object):Void {
		
		if (_connected) {
			_sendChannel.send(_sendChannelName, "onReceive", {methodName: methodName, args: args, callbackID: _rcvChannel._nextcallbackID});
		} else if (_container == undefined) {
			onError.apply(null, ["NotConnected"]);
		} else {
			_sendChannel._queue.push({methodName: methodName, args: args, callbackID: _rcvChannel._nextcallbackID});
		}
		_rcvChannel._callbacks[_rcvChannel._nextcallbackID] = {callbackObject: callbackObject, callbackMethod: callbackMethod};
		_rcvChannel._nextcallbackID++;
	}
	
}