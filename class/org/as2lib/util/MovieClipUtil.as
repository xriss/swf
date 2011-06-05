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

/**
 * {@code MovieClipUtil} contains fundamental methods to efficiently and easily work
 * with movieclips.
 * 
 * @author Akira Ito
 * @author Martin Heidegger
 */
class org.as2lib.util.MovieClipUtil extends BasicClass {
	
	/**
	 * Binds passed-in {@code MovieClip} with {@code clazz} type.
	 * 
	 * <p>This function binds {@code MovieClip} with given type and passing 
	 * passed-in arguments
	 * {@code Object}.
	 *
	 * <p> 
	 * @param movieclip the movieclip to bind {@code clazz} with.
	 * @param clazz class to be binded on the {@code movieclip}
	 * @return {@code MovieClip} binded {@code movieclip}
	 */	
	static public function bind(movieclip:MovieClip, clazz:Function, args:Array):MovieClip {
		movieclip.__proto__ = clazz.prototype;
		movieclip.__constructor__ = clazz;
		if (!args) {
			args = [movieclip];
		}
		clazz.apply(movieclip, args);
		return movieclip;
	}

	/**
	 * Returns {@code MovieClip} for passed-in {@code pathString}.
	 * 
	 * <p>This function will parse given {@code pathString} and will 
	 * create movieclip chain (if needed) to return {@code MovieClip} with path
	 * corresponding to the given {@code pathString}.
	 * Dot syntax should be used.
	 * 
	 * @param pathString path to required movieclip.
	 * @return {@code MovieClip} 
	 */	
	static public function getMovieClip(pathString:String, parentMovie:MovieClip):MovieClip {
		var mc:MovieClip;
		var pathArray:Array = pathString.split(".");
		var pathEntry:String;
		
		if(pathArray[0]=="_root") pathArray.shift(); // purge '_root'
		mc =  (parentMovie) ? parentMovie : _root;
		while(pathArray.length>0) {
			 pathEntry = String(pathArray.shift());
			 if(mc[pathEntry] != undefined) mc = mc[pathEntry]; 
			 else mc = mc.createEmptyMovieClip(pathEntry, mc.getNextHighestDepth()); 
		}
		return mc;
	}	
	
	/**
	 * Private constructor.
	 */
	private function MovieClipUtil(Void) {
	}	
}