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
 * {@code ErrorEvent} represents a generic error that can be identified by an error
 * code. The error code is mostly used to look-up internationalized error messages
 * to display to the user.
 * 
 * @author Simon Wacker
 */
class org.as2lib.context.event.ErrorEvent extends ApplicationEvent {
	
	/**
	 * This is a commonly used prefix for error codes. Separate it from the more
	 * specific code part with a '.'.
	 */
	public static var ERROR_CODE_PREFIX:String = "error";
	
	private var errorCode;
	
	/**
	 * Constructs a new {@code ErrorEvent} instance.
	 * 
	 * @param errorCode the code of the error that occurred
	 * @param applicationContext the application context in which the error occurred
	 */
	public function ErrorEvent(errorCode:String, applicationContext:ApplicationContext) {
		super(applicationContext);
		this.errorCode = errorCode;
	}
	
	/**
	 * Returns the code of the error that occurred. The returned code is normally used
	 * to look-up a localized error message to display to the user.
	 * 
	 * @return the error code
	 */
	public function getErrorCode(Void):String {
		return errorCode;
	}
	
}