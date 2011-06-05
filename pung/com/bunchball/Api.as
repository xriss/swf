//**********************************************************************
// bunchball API class
//
// The API used by an application to communicate with bunchball. 
//
// For AS2
//
// copyright 2005-2006 Bunchball, Inc.
//**********************************************************************
import com.dynamicflash.utils.Delegate;

class com.bunchball.Api
{
	
	static var className:String = "com.bunchball.Api";
	static var classVersion:String = ".3";
	public var instanceName:String = "Api";

	// --------------------------------------------------------------------------------------------------------------------------------
	// Define the variables that we need 
	
	// This array contains all our callback functions.
	private var callback_array:Array;

	// the windowIDs that we use to communicate with the main client.
	public var windowID:String;
	private var mainID:String;

	// The local connections that we use to communicate with the main client. 
	private var main_lc:LocalConnection;
	private var incoming_lc:LocalConnection;
	
	// The result of the last command
	private var res_b:Boolean;
	
	// the name of the last command
	private var lastCommand_str:String;

	// Maximum number of high scores to keep. 
	public var MAX_SCORES:Number = 50;
	
	// Length of time before timing out a function call, in milliseconds.
	private var TIMEOUT:Number = 20000;
	
	// interval to time our function calls. 
	private var timeoutInterval_n:Number;
	
	// For move timeouts. 
	private var moveInterval_n:Number;
	
	// To hold message packets.
	private var packet_array:Array;

	//-----------------------------------------------------------
	// Constructor function.	
	function Api() {
		// create a local connection to the main client
		main_lc = new LocalConnection();
		main_lc.onStatus = Delegate.create(this, onStatus);

		// the Window ID passed to us by the client. 
		windowID = _root.bbWindowID;
		
		// the id of the main client app
		mainID = "_" + _root.bbMainID;
		
		// listen on a new local connection on the window ID with an underscore
		// we're listening for callbacks and newData events. 
		incoming_lc = new LocalConnection();
		incoming_lc.apiCallback = Delegate.create(this, apiCallback);
		incoming_lc.setNewDataPacket = Delegate.create(this, setNewDataPacket);
		incoming_lc.getVersion = Delegate.create(this, getVersion);
		incoming_lc.allowDomain = Delegate.create(this, allowDomain);
		incoming_lc.allowInsecureDomain = Delegate.create(this, allowDomain);
		incoming_lc.connect("_" + windowID);

		// initialize the callback array
		callback_array = new Array();
	}


	//=========================================
	// LOCAL CONNECTION FUNCTIONS
	//=========================================

	//-----------------------------------------------------------
	// Handles the callbacks from the client app. 
	private function apiCallback(command_str:String):Void {
		var moveTime_n:Number;
		
		// pull the command string out of the argument list. 
		arguments.shift();
		
		// special cases for packetized functions.
		switch (command_str) {
			case "newData":
				// if packets have been sent, need to use those in place of what was sent in.
				if( (arguments[1] == undefined) || (typeof(arguments[1])=='function') ){
					// no message objects sent in, which means we sent it in packets.
					// so add it to the beginning of the argument list.
					arguments.unshift(packet_array);
				} 
				break;			
			case "getCachedData":
				// if packets have been sent, need to use those in place of what was sent in.
				if( (arguments[1] == undefined) || (typeof(arguments[1])=='function') ){
					// no message objects sent in, which means we sent it in packets.
					// so add it to the end of the argument list.
					arguments.push(packet_array);
				} 
				break;
			default:
		}

		
		if (setMoveTimeout.seconds_n == undefined) {
			moveTime_n = undefined;
		}
		else {
			moveTime_n = setMoveTimeout.seconds_n * 1000;
		}
		
		// clear the timer
		clearInterval(timeoutInterval_n);

		// for the game timeout, reset the timer if this is a newData command.
		clearInterval(moveInterval_n);
		
		if (moveTime_n != undefined && command_str == "newData") {
			// we need to dig into the newData_array to get a token. 
			var newData_array:Array = arguments[0];
			
			// get the last item in it. 
			var message_obj:Object = newData_array[newData_array.length -1];
			
			// get its message number
			var revision_n = message_obj.revision_n;
			
			// And send it to the timeout function if we timeout. 
			moveInterval_n = setInterval(Delegate.create(this,  moveTimedOut), moveTime_n, revision_n);
		}
		
		callback_array[command_str].apply(_root, arguments);
	}

	// ----------------------------------------------
	// Return the version number of the class file
	private function getVersion() {
		// acknowledge the receipt of the packet
		this.call("setVersion", classVersion, undefined);		
	}

	// ----------------------------------------------
	// Receive a single message packet from a list of messages. 	
	private function setNewDataPacket(message_obj:Object, index_n:Number) {
		if (index_n == 0) {
			// this is the first packet. Clear out the array
			packet_array = new Array();
		}
		
		// add this new object to the array. 
		packet_array.push(message_obj);
		
		// acknowledge the receipt of the packet
		this.call("ackDataPacket", index_n, undefined);		
	}

	//-----------------------------------------------------------
	// Allows local connection communication to this app from bunchball.com
	private function allowDomain(domain_str:String):Boolean {
		domain_str = domain_str.toLowerCase();
		return domain_str == "www.bunchball.com" || domain_str == "localhost" || domain_str == incoming_lc.domain();
	}

	//-----------------------------------------------------------
	// If we can't find a connection to the client app, then callback with an error
	private function onStatus(info_obj:Object):Void {
		// If it's an error, then callback indicating failure.
		if (info_obj.level == "error") {
			// clear the timer
			clearInterval(timeoutInterval_n);
			callback_array[lastCommand_str].apply(_root, [false]);
		}
	}

	//=========================================
	// API FUNCTIONS
	//=========================================
	
	//-----------------------------------------------------------
	// "macro" function to do all the startup tasks (setNewDataCallback, getDetails, getNewData)  in one call. 
	public function startup(newData_func:Function, callback_func:Function):Boolean {
		// set the new data callback function
		setNewDataCallback(newData_func);
		
		// get the details
		callback_array["startup"] = callback_func;
		return this.call("getDetails", Delegate.create(this,  startup2));
	}

	//-----------------------------------------------------------
	// "macro" function - part 2
	public function startup2(success_b:Boolean, details_obj:Object):Void {
		// save the details object
		startup.details_obj = details_obj;
		startup.success_b = success_b;
		// get the new data array
		this.call("getCachedData", Delegate.create(this,  startup3));
	}
	
	//-----------------------------------------------------------
	// "macro" function - part 3, return all the data to the application's callback function.
	public function startup3(success_b:Boolean, newData_array:Array):Void {
		// call the callback. 
		callback_array["startup"](success_b && startup.success_b, startup.details_obj, newData_array);
		delete startup.details_obj;
		delete startup.success_b;
	}
	
	
	//-----------------------------------------------------------
	// Application calls this to set a callback for receiving new data.
	public function setNewDataCallback(callback_func:Function):Boolean {
		callback_array["newData"] = callback_func;
		// call the main application and let it know that we're ready to receive new data
		this.call("readyForData", undefined);
		
		return true;
	}
	
	//-----------------------------------------------------------
	// Resolve function calls made with api.funcName syntax into commands to 
	// the "call" function. 
	public function __resolve(functionName:String):Function {
		var f:Function = function() {
			// Add the function name to the beginning of the arguments list. 
			arguments.unshift(functionName);
			var f:Function = this.call;		// ?????
			f.apply(this, arguments);		
		};
		
		return f;
	}
	
	//-----------------------------------------------------------
	// first argument is the name of the command
	// last argument is the callback
	// all the ones in between are data arguments
	public function call(functionName:String):Boolean {
		// save the function name so we know the last command we tried to send.
		lastCommand_str = functionName;
		
		// save the callback function & remove it from the arguments list
		var callback_func = arguments.pop();
		callback_array[functionName] = callback_func;
		
		// remove the function name from the arguments list
		arguments.shift();
		
		// add the windowID to the beginning of the arguments list. 
		arguments.unshift(windowID);
		
		// add the version number of the class file to the end of the arguments list
		arguments.push(classVersion);

		// call the function with an array of arguments. 
		res_b  = main_lc.send(mainID, functionName, arguments);
		
		// start the timer. If we don't have a result in the time specified, indicate failure.
		// by calling the Local Connection's failure function.
		clearInterval(timeoutInterval_n);
		timeoutInterval_n = setInterval(Delegate.create(this,  onStatus), TIMEOUT, {level:"error"});
		
		return res_b;
	}	
	
	//=========================================
	// LOCK/UNLOCK
	//=========================================
	
	//-----------------------------------------------------------
	// The "Lock" functions can be used to control which active instance of a game can take an action when multiple
	// instances are trying to. 
	public function lock(token_str:String, callback_func:Function):Boolean {
		callback_array["lock"] = callback_func;
		if (token_str == undefined || token_str == "") {
			return false;
		}
		lock.token_str = token_str;
		// check out the static object. 
		return this.call("loadStatic", true, false, Delegate.create(this, lock2));	
	}
	
	//-----------------------------------------------------------
	// Part 2: We have the static object. Now check to see if this token has been used.
	private  function lock2(success_b:Boolean, loaded_obj:Object):Void {
		var static_obj:Object;
	
		if (success_b) {
			// create it if there's nothing there. 
			if (loaded_obj == undefined) {
				static_obj = new Object();
				static_obj.lock_array = [];
			}
			else {
				static_obj = loaded_obj.static_obj;
				// if the static object isn't a generic object, then we'll overwrite it and make a generic object.
				if (static_obj == undefined || static_obj.__proto__ != Object.prototype) {
					static_obj = new Object();
				}
				if (static_obj.lock_array == undefined) {
					static_obj.lock_array = [];
				}
			}
			
			// check to see if this token has been used. 
			for (var i=0; i < static_obj.lock_array.length; i++) {
				if (static_obj.lock_array[i] == lock.token_str) {
					// this has been used before. 
					// check the static object back in and return false. 
					this.call("saveStatic", static_obj, false, loaded_obj.key_str, Delegate.create(this, lockFail));
					return;
				}
			}
			
			// if we're here, then we haven't used this token before.
			// save the token so we can add it to the static object when we're done. 
			lock.newtoken_str = lock.token_str;
			// save the key so we can unlock
			lock.key_str = loaded_obj.key_str;
			// save the static object
			lock.static_obj = static_obj;
			
			// callback with a true. Application can now take an action and then call unlock. 
			callback_array["lock"](true);
			
		}
		else {
			// couldn't check out the static object, so return false for the lock.
			callback_array["lock"](false);
			return;
		}
	}

	//-----------------------------------------------------------
	// Part 3: We saved the static object back, but the lock failed because the token had been used before. 
	private  function lockFail(success_b:Boolean):Void {
		callback_array["lock"](false);
		delete lock.token_str;
		delete lock.newtoken_str;
		delete lock.key_str;
		delete lock.static_obj;
	}
	
	//-----------------------------------------------------------
	// The application is done holding the baton and is releasing the lock. 
	public function unlock(callback_func:Function):Boolean {
		callback_array["unlock"] = callback_func;

		// add the token to the front of the lock_array;
		lock.static_obj.lock_array.unshift(lock.newtoken_str);
		
		// keep only the last 25
		lock.static_obj.lock_array.length = 25;

		// check the static object back in 
		return this.call("saveStatic", lock.static_obj, false, lock.key_str, Delegate.create(this, unlock2));
	}
	
	//-----------------------------------------------------------
	// Part 2: Send back the results of the save, and clean up.
	private function unlock2(success_b:Boolean):Void {
		if (success_b) {
			// Success and the results. 
			callback_array["unlock"](true);
		}
		else {
			// Indicate failure, but we have results to look at anyway. 
			callback_array["unlock"](false);
		}
		
		delete lock.token_str;
		delete lock.newtoken_str;
		delete lock.key_str;
		delete lock.static_obj;
	}
	
	
	
	//=========================================
	// HIGH SCORES
	//=========================================
	
	//-----------------------------------------------------------
	// The "Score" functions add another layer on the static functions to make it easy to implement shared high scores. 
	// This one checks out the shared data object, compares the score to the existing ones, adds it if necessary, and then
	// checks the object back in. The data object can be anything. 
	public function saveScore(score_n:Number, data_obj:Object, global_b:Boolean, callback_func:Function):Boolean {
		callback_array["saveScore"] = callback_func;		
		// have to give good data. 
		if (data_obj == undefined) {
			return false;
		}
		
		if (score_n == undefined) {
			return false;
		}
		
		saveScore.score_n = score_n;
		saveScore.data_obj = data_obj;
		saveScore.global_b = global_b;
		return this.call("loadStatic", true, global_b, Delegate.create(this, saveScore2));	
	}
	
	//-----------------------------------------------------------
	// Part 2: We have the static object. Now make any changes that we need to. 
	private  function saveScore2(success_b:Boolean, loaded_obj:Object):Void {
		var static_obj:Object;
	
		if (success_b) {
			// create it if there's nothing there. 
			if (loaded_obj == undefined) {
				static_obj = new Object();
				static_obj.scores_array = [];
			}
			else {
				static_obj = loaded_obj.static_obj;
				// if the static object isn't a generic object, then we'll overwrite it and make a generic object.
				if (static_obj == undefined || static_obj.__proto__ != Object.prototype) {
					static_obj = new Object();
				}
				if (static_obj.scores_array == undefined) {
					static_obj.scores_array = [];
				}
			}
			
			// Add our new score to the array as an object. 
			static_obj.scores_array.push({score_n:saveScore.score_n, data_obj: saveScore.data_obj});
			
			// sort the array
			static_obj.scores_array.sort(compareScores);
			
			// weed out any garbage
			for (var i = static_obj.scores_array.length - 1; i > -1 ; i--) {
				if (static_obj.scores_array[i] == undefined || static_obj.scores_array[i].score_n == undefined || static_obj.scores_array[i].data_obj == undefined) {
					static_obj.scores_array.splice(i,1);
				}
			}
			
			// truncate it to MAX_SCORES. 
			if (static_obj.scores_array.length > MAX_SCORES) {
				static_obj.scores_array.length = MAX_SCORES;
			}
			
			// save a copy of the scores so we don't need to retrieve it again. 
			saveScore.scores_array = static_obj.scores_array;
			
			// save it back.
			this.call("saveStatic", static_obj, saveScore.global_b, loaded_obj.key_str, Delegate.create(this, saveScore3));
		}
		else {
			callback_array["saveScore"](false, undefined);
			return;
		}
	}
	
	//-----------------------------------------------------------
	// Part 3: We have saved the static object. Send the results back to the original callback specified. 
	private  function saveScore3(success_b:Boolean):Void {
		if (success_b) {
			// Success and the results. 
			callback_array["saveScore"](true, saveScore.scores_array);
		}
		else {
			// Indicate failure, but we have results to look at anyway. 
			callback_array["saveScore"](false, saveScore.scores_array);
		}
		
		delete saveScore.scores_array;
		delete saveScore.data_obj;
		delete saveScore.score_n;
		delete saveScore.global_b;
	}
	
	
	//-----------------------------------------------------------
	// INTERNAL
	// Compare two scores. Sort in descending order. 
	private  function compareScores(arg1, arg2) {
		return arg2.score_n - arg1.score_n;
	}
	
	
	//-----------------------------------------------------------
	// Load scores for viewing only. 
	public function loadScores(global_b:Boolean, callback_func:Function):Boolean {
		callback_array["loadScores"] = callback_func;
		return this.call("loadStatic", false, global_b, Delegate.create(this, loadScores2));
	}
	
	//-----------------------------------------------------------
	// Part 2: We have the static object. 
	private  function loadScores2(success_b:Boolean, loaded_obj:Object):Void {
		if (success_b) {
			if (loaded_obj == undefined) {
				// if there's nothing there, return that we succeeded but that it's empty. 
				callback_array["loadScores"](true, undefined);
			}
			else {
				// return the scores array. 
				callback_array["loadScores"](true, loaded_obj.static_obj.scores_array);
			}
		}
		else {
			// return function failure
			callback_array["loadScores"](false, undefined);
		}
		
	}
	
	//=========================================
	// TIMEOUT
	//=========================================
	
	// ----------------------------------------------
	// If we want our moves to be made in certain period of time. 
	public function setMoveTimeout(seconds_n:Number, callback_func:Function):Boolean {
		callback_array["setMoveTimeout"] = callback_func;

		// Given latencies and connection speeds, the seconds should be in the 45+ range. 
		// Setting it to undefined turns it off. 

		// store the move time. 
		setMoveTimeout.seconds_n = seconds_n;	
		return true;
	}
	
	// ----------------------------------------------
	// It has been the set number of seconds since the last new message arrived for this game. 
	// We can assume that other instances have realized the same thing. 
	// We'll try to grab the lock, and whoever does will have their callback called. 
	// And then we'll unlock. 
	private function moveTimedOut(token_str:String):Void {
		// clear the interval
		clearInterval(moveInterval_n);
		// try to get the lock.  
		lock (token_str, Delegate.create(this, moveTimedOut2));
	}
	
	// ----------------------------------------------
	// Were we able to get the lock?
	private function moveTimedOut2(success_b:Boolean):Void {
		if (success_b) {
			// call the callback function. This function should make an automated move on behalf
			// of the instance/user that has flaked out. 
			callback_array["setMoveTimeout"]();
			// and then unlock
			unlock(Delegate.create(this, moveTimedOut3));
		}
		else {
			// do nothing, assume that someone else has taken care of it. Don't callback into the app. 
		}
		
		// the interval will get reset when we receive new data again, hopefully due to the action
		// taken in the callback. 
				
	}
	
	// ----------------------------------------------
	// Unlocked. Do nothing.  
	private function moveTimedOut3(success_b:Boolean):Void {
		return;
	}
	
}