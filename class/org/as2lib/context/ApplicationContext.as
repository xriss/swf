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

import org.as2lib.context.ApplicationEventPublisher;
import org.as2lib.context.MessageSource;
import org.as2lib.bean.factory.ListableBeanFactory;

/**
 * {@code ApplicationContext} provides configuration options for applications. These
 * options are read-only while the application is running, but may be reloaded if the
 * implementation supports this.
 * 
 * <p>An application context provides:
 * <ul>
 *   <li>
 *     Bean factory methods, inherited from {@code ListableBeanFactory}. This avoids the
 *     need for applications to use singletons and provides a convenient way to wire
 *     objects.
 *   </li>
 *   <li>The ability to resolve messages, supporting internationalization.</li>
 *   <li>The ability to publish application events.</li>
 *   <li>
 *     Inheritance from a parent context. Definitions in a descendant context will always
 *     take priority. This means, for example, that a single parent context can be used
 *     by an entire application, while each part has its own child context that is
 *     independent of that of any other part.
 *   </li>
 * </ul>
 * 
 * <p>In addition to standard bean factory lifecycle capabilities, application contexts
 * need to detect {@link ApplicationContextAware} beans and invoke the {@code setApplicationContext}
 * method accordingly. The same must be done for {@link ApplicationEventPublisherAware}
 * and {@link MessageSourceAware} beans.
 * 
 * @author Simon Wacker
 */
interface org.as2lib.context.ApplicationContext extends ListableBeanFactory {
	
	/**
	 * Returns a display name for this context.
	 * 
	 * @return this context's display name
	 */
	public function getDisplayName(Void):String;
	
	/**
	 * Returns the parent context, or {@code null} if there is no parent context and
	 * this is the root of the context hierarchy.
	 * 
	 * @return the parent of this context
	 */
	public function getParent(Void):ApplicationContext;
	
	/**
	 * Returns the event publisher to notify application listeners of events.
	 * 
	 * @return the event publisher
	 */
	public function getEventPublisher(Void):ApplicationEventPublisher;
	
	/**
	 * Returns the message source to resolve messages. This enables parameterization
	 * and internationalization of messages.
	 * 
	 * @return the message source to resolve messages
	 */
	public function getMessageSource(Void):MessageSource;
	
}