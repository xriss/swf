//#initclip

/******************************************************************
This class communicates with the PostNuke pnFlashTrack module to store
and (possibly) retrieve high scores for registered PostNuke users.

Version: 1.0
Requires: pnFlashGames PostNuke module version 0.8 or higher.
Author: Lee Eason (lee@pnflashgames.com)
Demo Site: http://pnflashgames.com
******************************************************************/

// Kriss...
// atempt to turn this into a simple class for mtasc use
// looks like it should work...

class com.pnFlashGames 
{

	var gid;
	var uname;
	var _modvalue;
	var _modvar;
	var _script;
	var _autoupdate;
	var _extravars;
	
	var busy;
	var gameSaved;
	var gameLoaded;
	var gameScoresLoaded;
	var gameScores;
	var scoreStored;
	var gameData;
	var debugMode;

// fake vars to hush mtasc, i think it works ok though

	var parent;
	var opSuccess;

//This is the constructor function
function pnFlashGames(){
	this.gid = _root.pn_gid;
	this.uname = _root.pn_uname;
	
	// Figure out where/how to send scores. Default is for PostNuke
	this._modvalue = "pnFlashGames";
	this._modvar = "module";
	this._script = "index.php";
	if(_root.pn_modvalue != null){
		this._modvalue = _root.pn_modvalue;
	}
	if(_root.pn_modvar != null){
		this._modvar = _root.pn_modvar;
	}
	if(_root.pn_script != null){
		this._script = _root.pn_script;
	}
	
	// Should we attempt to auto update scores? Default is false (no)
	this._autoupdate = false;
	if(_root.pn_autoupdate == "true"){
		this._autoupdate = true;
	}
	
	// Load and parse any extra variables that we are to send to the script
	if(_root.pn_extravars != null){
		this._extravars = new Array();
		var temppairs = _root.pn_extravars.split("|");
		for(var x=0; x < temppairs.length; x++){
			var tempset = temppairs[x].split("~");
			this._extravars.push(tempset);
		}
	}else{
		this._extravars = null;
	}
	
	this.busy = false;
	this.gameSaved = null;
	this.gameLoaded = null;
	this.gameScoresLoaded = null;
	this.gameScores = null;
	this.scoreStored = null;
	this.gameData = "";
}

//Save the game data to the DB
function saveGame(gameData){
	this.busy = true;
	
	var varsObj = new LoadVars();
	varsObj.func = "saveGame";
	varsObj.gid = this.gid;
	varsObj.gameData = gameData;
	varsObj.type = "user";
	varsObj[this._modvar] = this._modvalue;
	varsObj.parent = this;
	varsObj.onLoad = this.saveGame_Result;
	// Append the extra vars to the varsObj if any were given
	if(this._extravars != null){
		for(var x=0; x < this._extravars.length; x++){
			varsObj[this._extravars[x][0]] = this._extravars[x][1];
		}
	}
	if(this.debugMode){
		this.debugOutput(varsObj);
	}else{
		varsObj.sendAndLoad(this._script, varsObj, "POST");
	}
}

//Result of the save game instruction
function saveGame_Result(success){
	this.parent._parent.incoming = this.opSuccess;
	
	if(this.opSuccess == "true"){
		//Success
		this.parent.gameSaved = true;
	}else{
		//Failure
		this.parent.gameSaved = false;
	}
	
	this.parent.busy = false;
}

//Load a game from the db
function loadGame(){
	this.busy = true;
	
	var varsObj = new LoadVars();
	varsObj.func = "loadGame";
	varsObj.gid = this.gid;
	varsObj.type = "user";
	varsObj[this._modvar] = this._modvalue;
	varsObj.parent = this;
	varsObj.onLoad = this.loadGame_Result;
	// Append the extra vars to the varsObj if any were given
	if(this._extravars != null){
		for(var x=0; x < this._extravars.length; x++){
			varsObj[this._extravars[x][0]] = this._extravars[x][1];
		}
	}
	if(this.debugMode){
		this.debugOutput(varsObj);
	}else{
		varsObj.sendAndLoad(this._script, varsObj, "POST");
	}
}

//Reply on user info request
function loadGame_Result(success){
	if(this.opSuccess == "true"){
		//Success
		this.parent.gameLoaded = true;
		this.parent.gameData = gameData;
	}else{
		//Failure
		this.parent.gameLoaded = false;
	}
	
	if(this.parent.onLoadGame != null){
		this.parent.onLoadGame(this.gameData);
	}
	
	this.parent.busy = false;
}

//Send a request to store the score in the correct table
function storeScore(score){
	this.busy = true;
	
	var varsObj = new LoadVars();
	varsObj.score = score;
	varsObj.func = "storeScore";
	varsObj.gid = this.gid;
	varsObj.type = "user";
	varsObj[this._modvar] = this._modvalue;
	varsObj.parent = this;
	varsObj.onLoad = this.storeScore_Result;
	// Append the extra vars to the varsObj if any were given
	if(this._extravars != null){
		for(var x=0; x < this._extravars.length; x++){
			varsObj[this._extravars[x][0]] = this._extravars[x][1];
		}
	}
	if(this.debugMode){
		this.debugOutput(varsObj);
	}else{
		varsObj.sendAndLoad(this._script, varsObj, "POST");
	}
}

//Reply from the PostNuke environment
function storeScore_Result(success){
	if(this.opSuccess == "true"){
		//Success
		this.parent.scoreStored = true;
		if(this.parent._autoupdate){
			_root.getURL("javascript:refreshScores();");
		}
	}else{
		//Failure
		this.parent.scoreStored = false;
	}
	
	this.parent.busy = false;
}

//Load a game from the db
function loadGameScores(){
	this.busy = true;
	
	var varsObj = new LoadVars();
	varsObj.func = "loadGameScores";
	varsObj.gid = this.gid;
	varsObj.type = "user";
	varsObj[this._modvar] = this._modvalue;
	varsObj.parent = this;
	varsObj.onLoad = this.loadGameScores_Result;
	// Append the extra vars to the varsObj if any were given
	if(this._extravars != null){
		for(var x=0; x < this._extravars.length; x++){
			varsObj[this._extravars[x][0]] = this._extravars[x][1];
		}
	}
	if(this.debugMode){
		this.debugOutput(varsObj);
	}else{
		varsObj.sendAndLoad(this._script, varsObj, "POST");
	}
}

//Reply on user info request
function loadGameScores_Result(success){
	if(this.opSuccess == "true"){
		//Success
		this.parent.gameScoresLoaded = true;
		this.parent.gameScores = new XML(this.gameScores);
	}else{
		//Failure
		this.parent.gameScoresLoaded = false;
	}
	
	if(this.parent.onLoadGameScores != null){
		this.parent.onLoadGameScores(this.gameScores);
	}
	
	this.parent.busy = false;
}

//Debug output
function debugOutput(vars){
	var debug = "";
	//debug += "Sending vars to " + this._script + "\n";
	//debug += this._modvar + "=" + this._modvalue + "\n";
	debug += "Function: " + vars.func + "\n";
	switch(vars.func){
		case "storeScore":
			debug += "Score: " + vars.score;
			break;
		case "saveGame":
			debug += "Saving: " + vars.gameData;
			break;
		case "loadGame":
			debug += "Loading data....";
			break;
		case "getGameScores":
			debug += "Getting scores for this game....";
			break;
	}
	trace(debug);
}


}
