/**
* MochiServices
* Class that provides API access to MochiAds Scores Service
* @author Mochi Media
* @version 1.0
*/

import mochi.MochiServices;

class mochi.MochiScores {

	public static var onClose:Object;
	public static var onError:Object;
	private static var boardID:String;
	
	/**
	 * Method: setBoardID
	 * Sets the name of the mode to use for categorizing submitted and displayed scores.  The board ID is assigned in the online interface.
	 * @param 	boardID: The unique string name of the mode
	 */
	public static function setBoardID (boardID:String):Void { MochiScores.boardID = boardID; MochiServices.send("scores_setBoardID", { boardID: boardID } ); };
	

	/**
	 * Method: showLeaderBoard
	 * Displays the leaderboard GUI showing the current top scores.  The callback event is triggered when the leaderboard is closed.
	 * @param	options object containing variables representing the changeable parameters <see: GUI Options>
	 */
	public static function showLeaderboard (options:Object):Void { 

		if (options.clip != null) {
			if (options.clip["__mochiservicesMC"] != MochiServices.clip) {
				MochiServices.disconnect();
				MochiServices.connect(MochiServices.id, options.clip);
			}
			delete options.clip;
		}
		if (options.onDisplay != null) {
			options.onDisplay();
		} else {
			MochiServices.clip.stop();
		}

		if (options.onClose != null) {
			onClose = options.onClose;
		} else {
			onClose = function ():Void { if (MochiServices.clip == _root["__mochiservicesMC"]) { MochiServices.clip._parent.play(); } else { MochiServices.clip.play(); } }
		}
		
		if (options.onError != null) {
			onError = options.onError;
		} else {
			onError = onClose;
		}
		
		if (options.boardID == null) {
			if (MochiScores.boardID != null) {
				options.boardID = MochiScores.boardID;
			}
		}

		MochiServices.send("scores_showLeaderboard", { options: options }, null, doClose ); 
		
	}
	
	
	/**
	 * Method: getPlayerInfo
	 * Retrieves all persistent player data that has been saved in a SharedObject. Will send to the callback an object containing key->value pairs contained in the player cookie.
	 */
	public static function getPlayerInfo (callbackObj:Object, callbackMethod:Object):Void { MochiServices.send("scores_getPlayerInfo", null, callbackObj, callbackMethod); }
	
	
	/**
	 * Method: submit
	 * Submits a score to the server using the current id and mode.
	 * @param	name - the string name of the user as entered or defined by MochiBridge.
	 * @param	score - the number representing a score.  Can be an integer or float.  If the score is time, send it in seconds - can be float
	 * @param 	callbackObj - the object or class instance containing the callback method
	 * @param 	callbackMethod - the string name of the method to call when the score has been sent
	 */
	public static function submit (score:Number, name:String, callbackObj:Object, callbackMethod:Object):Void { MochiServices.send("scores_submit", {score: score, name: name}, callbackObj, callbackMethod); };

	
	/**
	 * Method: requestList
	 * Requests a listing from the server using the current game id and mode. Returns an array of at most 50 score objects. Will send to the callback an array of objects [{name, score, timestamp}, ...]
	 * @param	callbackObj the object or class instance containing the callback method
	 * @param	callbackMethod the string name of the method to call when the score has been sent. default: "onLoad"
	 */
	public static function requestList (callbackObj:Object, callbackMethod:Object):Void { MochiServices.send("scores_requestList", null, callbackObj, callbackMethod); }
	
	
	//
	//
	private static function doClose (args:Object) {
		
		if (args.error == true) {
			onError.apply(null, [args.errorCode, args.httpStatus]);
		} else {
			onClose.apply();
		}
		
	}
}