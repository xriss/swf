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

import org.as2lib.context.ApplicationContext;
import org.as2lib.context.ApplicationEvent;

/**
 * {@code SuccessEvent} represents a generic success that can be identified by a success
 * code. The success code is mostly used to look-up internationalized success messages
 * to display to the user.
 * 
 * @author Simon Wacker
 */
class org.as2lib.context.event.SuccessEvent extends ApplicationEvent {
	
	/**
	 * This is a commonly used prefix for success codes. Separate it from the more
	 * specific code part with a '.'.
	 */
	public static var SUCCESS_CODE_PREFIX:String = "success";
	
	private var successCode;
	
	/**
	 * Constructs a new {@code SuccessEvent} instance.
	 * 
	 * @param successCode the code of the success that was achieved
	 * @param applicationContext the application context in which the success was
	 * achieved
	 */
	public function SuccessEvent(successCode:String, applicationContext:ApplicationContext) {
		super(applicationContext);
		this.successCode = successCode;
	}
	
	/**
	 * Returns the code of the success that was achieved. The returned code is normally
	 * used to look-up a localized success message to display to the user.
	 * 
	 * @return the success code
	 */
	public function getSuccessCode(Void):String {
		return successCode;
	}
	
}