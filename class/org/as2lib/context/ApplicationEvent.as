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
import org.as2lib.context.ApplicationContext;

/**
 * {@code ApplicationEvent} holds basic information needed by application events.
 * Specific events must sub-class this abstract class.
 * 
 * @author Simon Wacker
 */
class org.as2lib.context.ApplicationEvent extends BasicClass {
	
	/** The source application context. */
	private var applicationContext:ApplicationContext;
	
	/** The system time in milliseconds when the event happened. */
	private var timeStamp:Number;
	
	/**
	 * Constructs a new {@code ApplicationEvent} instance.
	 * 
	 * @param applicationContext the source application context
	 */
	private function ApplicationEvent(applicationContext:ApplicationContext) {
		this.applicationContext = applicationContext;
		timeStamp = (new Date()).getTime();
	}
	
	/**
	 * Returns the source application context.
	 * 
	 * @return the source application context
	 */
	public function getApplicationContext(Void):ApplicationContext {
		return applicationContext;
	}
	
	/**
	 * Returns the system time in milliseconds when the event happened.
	 * 
	 * @return the system time in milliseconds when the event happened
	 */
	public function getTimeStamp(Void):Number {
		return timeStamp;
	}
	
}