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

import main.Flash;

/**
 * {@code FlashApplication} is the default access point for an application in Flash.
 * This means that the only method to execute to get the whole application running
 * is the {@link #init} method of this class.
 * 
 * <p>You simply have to add the following code in the first frame; note that the this
 * is mandatory, but it is good practice to pass it in, as the root movie clip.
 * <code>
 *   org.as2lib.app.conf.FlashApplication.init(this);
 * </code>
 * 
 * <p>The {@link #init} method creates an instance of your Flash configuration class,
 * {@link main.Flash}, and executes the {@code init} method on the instance passing
 * the arguments that were passed to this class's static {@code init} method.
 * 
 * @author Martin Heidegger
 * @author Simon Wacker
 * @version 2.0
 */
class org.as2lib.app.conf.FlashApplication extends BasicClass {
	
	/**
	 * Executes the {@code init} method for the flash environment in {@link main.Flash}.
	 * It therefor creates an instance of the {@code Flash} class and invokes the
	 * {@code init} method on it, passing the arguments that were passed-to this
	 * method.
	 * 
	 * @param .. any number of arguments of any type
	 */
	public static function init():Void {
		var flash:Flash = new Flash();
		flash.init.apply(flash, arguments);
	}
	
}