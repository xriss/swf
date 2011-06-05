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

import org.as2lib.context.MessageSource;
import org.as2lib.core.BasicInterface;

/**
 * {@code MessageSourceAware} can be implemented by beans that need to look-up
 * internationalized messages with a given code.
 * 
 * <p>The code may be the error code of an exception.
 * 
 * @author Simon Wacker
 */
interface org.as2lib.context.MessageSourceAware extends BasicInterface {
	
	/**
	 * Sets the message source of the application context this bean runs in.
	 * 
	 * <p>This method is invoked after population of normal bean properties but before
	 * an init callback, and before {@code ApplicationContextAware.setApplicationContext}.
	 * 
	 * @param messageSource the message source that shall be used by this bean
	 */
	public function setMessageSource(messageSource:MessageSource):Void;
	
}