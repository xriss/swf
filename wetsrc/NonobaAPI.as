	/****
	Hi guys, I am an API wrapper class!
	Copyright (C)2008 Odpy ApS
	
	Please do not change this file.
****/
import com.dynamicflash.utils.Delegate;
class NonobaAPI{
	public static var SUCCESS:String = "SUCCESS";
	public static var NOT_LOGGED_IN:String = "user not logged in";
	public static var ERROR:String = "error";

	private static var isInited:Boolean = false;
	private static var loading:Boolean = false;
	private static var cachedRequests:Array = [];
	private static var api;
	private static var failed:Boolean = false
	
	function NonobaAPI(){
		throw new Error("ERROR!: You cannot create an instance of the NonobaAPI class!");
	}

	public static function GetShopItemKeys(callback:Function):Void{	
	
		if(!isInited)Init()
		
		//Return error if API has entered ERROR state
		if(failed){
			if(callback)callback(ERROR, null)
			return
		}
		
		//Depending on state submit score or cache call
		if(api && api.ShowShop){
			api.GetShopItemKeys(callback);
		}else{
			cachedRequests.push(function(){ this.GetShopItemKeys(callback) } );
		}

	}



	public static function HasShopItem(item:String, callback:Function):Void{	
	
		if(!isInited)Init()
		
		//Return error if API has entered ERROR state
		if(failed){
			if(callback)callback(ERROR, false,  null)
			return
		}
		
		//Depending on state submit score or cache call
		if(api && api.ShowShop){
			api.HasShopItem(item, callback);
		}else{
			cachedRequests.push(function(){ this.HasShopItem(item, callback) } );
		}

	}

	public static function ShowShop(item:String, callback:Function):Void{	
	
		if(!isInited)Init()
		
		//Return error if API has entered ERROR state
		if(failed){
			if(callback)callback(ERROR)
			return
		}
		
		//Depending on state submit score or cache call
		if(api && api.ShowShop){
			api.ShowShop(item, callback);
		}else{
			cachedRequests.push(function(){ this.ShowShop(item, callback) } );
		}

	}
	
	public static function Login(callback:Function):Void{	
	
		if(!isInited)Init()
		
		//Return error if API has entered ERROR state
		if(failed){
			if(callback)callback(ERROR)
			return
		}
		
		//Depending on state submit score or cache call
		if(api && api.Login){
			api.Login(callback);
		}else{
			cachedRequests.push(function(){ this.Login(callback) } );
		}

	}
	
	
	public static function SubmitScore(key:String, score:Number, callback:Function):Void{	
		if(!isInited)Init()
		
		//Return error if API has entered ERROR state
		if(failed){
			if(callback)callback(ERROR)
			return
		}
		
		//Depending on state submit score or cache call
		if(api && api.SubmitScore){
			api.SubmitScore(key, score, callback);
		}else{
			cachedRequests.push(function(){ this.SubmitScore(key, score, callback) } );
		}

	}
	public static function AwardAchievement(key:String, callback:Function ):Void{
		if(!isInited)Init()

		//Return error if API has entered ERROR state
		if(failed){
			if(callback)callback(ERROR,0)
			return
		}
		
		//Depending on state award achievement or cache call
		if(api && api.AwardAchievement){
			api.AwardAchievement(key,callback);
		}else{
			cachedRequests.push(function(){ this.AwardAchievement(key,callback) } );
		}

	}
	public static function SetUserData(key:String,value:String, callback:Function):Void{
		if(!isInited)Init()

		//Return error if API has entered ERROR state
		if(failed){
			if(callback)callback(ERROR)
			return
		}
		
		//Depending on state parse argument or cache call
		if(api && api.SetUserData){
			api.SetUserData(key,value,callback);
		}else{
			cachedRequests.push(function(){ this.SetUserData(key,value,callback) } );
		}
	}
	public static function GetUserData(key:String, callback:Function):Void{
		if(!isInited)Init()

		//Return error if API has entered ERROR state
		if(failed){
			if(callback)callback(ERROR,"")
			return
		}
		
		//Depending on state parse argument or cache call
		if(api && api.GetUserData){
			api.GetUserData(key,callback);
		}else{
			cachedRequests.push(function(){ this.GetUserData(key,callback) } );
		}
	}
	public static function GetUsername(callback:Function):Void{
		if(!isInited)Init()

		//Return error if API has entered ERROR state
		if(failed){
			if(callback)callback(ERROR,"")
			return
		}
		
		//Depending on state parse argument or cache call
		if(api && api.GetUsername){
			api.GetUsername(callback);
		}else{
			cachedRequests.push(function(){ this.GetUsername(callback) } );
		}
	}
	public static function Init(container:MovieClip):Void{
		var emptyCache;
		if(isInited)throw new Error("NonobaAPI can not be re-initialized!");
		isInited = true;
		
		//Load path from flashvars
		var path:String = _root.nonoba$apicodeas2
		if(!path){
			//Fail if path is null
			failed = true;
			//Run and empty cache:
			emptyCache();
		}
		
		//Important to get callbacks to work
		System.security.allowDomain("*");
		

		//Make sure we got something to attach to
		container = container || _root;
		
		//That's gotta be unique!
		api = container.createEmptyMovieClip("___NonobaAPI__loader", container.getNextHighestDepth());
		var loader:MovieClipLoader = new MovieClipLoader();
		
		loader.addListener({
			onLoadComplete:function(){
				//Look away, we are doing nasty hacks.
				var loadTimer;
				loadTimer= setInterval(Delegate.create(NonobaAPI, function(){
					//If everything is done loading;
					if(this.api.SubmitScore !== undefined){
						clearInterval(loadTimer)
						//Run and empty cache:
						emptyCache()
					} 
				}), 500)
			},
			onLoadError:function(){
				//Set error state
				this.failed = true
				//Run and empty cache:
				emptyCache()
			}
		});
		
		//Local scope helper method
		emptyCache=function (){
			//Execute process queue.
			for( var i:Number=0;i<this.cachedRequests.length;i++){
				this.cachedRequests[i]();
			}
			//Reset cache
			this.cachedRequests = [];
		}
		
		loader.loadClip(path, api)
	}
}