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
import org.as2lib.core.BasicInterface;

/**
 * {@code ApplicationContextAware} can be implemented by beans that need to know which
 * application context manages them.
 * 
 * @author Simon Wacker
 */
interface org.as2lib.context.ApplicationContextAware extends BasicInterface {
	
	/**
	 * Sets the application context this bean runs in.
	 * 
	 * <p>This method is invoked after the population of normal bean properties but before
	 * an init callback.
	 * 
	 * @param applicationContext the application context this bean runs in
	 */
	public function setApplicationContext(applicationContext:ApplicationContext):Void;
	
}