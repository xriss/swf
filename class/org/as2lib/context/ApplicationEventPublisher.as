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

import org.as2lib.context.ApplicationEvent;
import org.as2lib.core.BasicInterface;

/**
 * {@code ApplicationEventPublisher} publishes application events. Most oftenly the
 * context itself implements this interface.
 * 
 * @author Simon Wacker
 */
interface org.as2lib.context.ApplicationEventPublisher extends BasicInterface {
	
	/**
	 * Notifies all listeners registered with the application corresponding to this
	 * publisher of an application event.
	 * 
	 * @param event the application event to notify listeners of
	 */
	public function publishEvent(event:ApplicationEvent):Void;
	
}