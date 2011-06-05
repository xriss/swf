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

import main.Mtasc;

/**
 * {@code MtascApplication} is the default access point for applications compiled
 * with Mtasc.
 * 
 * <p>Use this class to initialize your application with the MTASC compiler.
 * 
 * <p>Simply use this class as main entry point class in your mtasc compile settings.
 * <code>
 *   [MTASC directory]\mtasc.exe -cp "[your project path]" -cp "[as2lib project path]" -main org/as2lib/app/conf/MtascApplication.as
 * </code>
 * 
 * <p>The {@link #main} method creates an instance of your MTASC configuration class,
 * {@link main.Mtasc}, and executes the {@code init} method on the instance passing
 * the arguments that were passed to this class's static {@code main} method.
 * 
 * @author Martin Heidegger
 * @author Simon Wacker
 * @version 2.0
 * @see <a href="http://www.mtasc.org">Motion-Twin ActionScript 2.0 Compiler</a>
 */
class org.as2lib.app.conf.MtascApplication extends BasicClass {
	
	/**
	 * Executes the {@code init} method for the mtasc environment in {@link main.Mtasc}.
	 * It therefor creates an instance of the {@code Mtasc} class and invokes the
	 * {@code init} method on it, passing the arguments that were passed to this method.
	 * 
	 * <p>The {@code Mtasc.init} method is passed the {@code movieClip}, that is by
	 * {@code _root} if this class is used as main method for MTASC.
	 * 
	 * @param movieClip the root movie-clip that is passed by MTASC to the main method
	 */
	public static function main(movieClip:MovieClip):Void {
		var mtasc:Mtasc = new Mtasc();
		mtasc.init.apply(mtasc, arguments);
	}
	
}