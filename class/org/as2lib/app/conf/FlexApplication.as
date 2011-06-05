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

import main.Flex;

/**
 * {@code FlexApplication} is the default access point for Flex applications.
 * 
 * <p>Use this class to configure your application in Macromedia Flex. It initializes
 * your flex configuration in {@link main.Flex}.
 * 
 * <p>You must simply init your application something like this:
 * <code>
 *   <mx:Application xmlns:mx="http://www.macromedia.com/2003/mxml" initialize="initApplication();">
 *     <mx:Script>
 *       <![CDATA[
 *         import org.as2lib.app.conf.FlexApplication;
 *         public function initApplication(Void):Void {
 *           FlexApplication.init();
 *         }
 *       ]]>
 *     </mx:Script>
 *   </mx:Application>
 * </code>
 * 
 * <p>The {@link #init} method creates an instance of your Flex configuration class,
 * {@link main.Flex}, and executes the {@code init} method on the instance passing
 * the arguments that were passed to this class's static {@code init} method.
 * 
 * @author Simon Wacker
 * @version 2.0 */
class org.as2lib.app.conf.FlexApplication extends BasicClass {
	
	/**
	 * Executes the {@code init} method for the Flex environment in {@link main.Flex}.
	 * It therefor creates an instance of the {@code Flex} class and invokes the
	 * {@code init} method on it, passing the arguments that were passed-to this
	 * method.
	 * 
	 * @param .. any number of arguments of any type	 */
	public static function init():Void {
		var flex:Flex = new Flex();
		flex.init.apply(flex, arguments);
	}
	
}