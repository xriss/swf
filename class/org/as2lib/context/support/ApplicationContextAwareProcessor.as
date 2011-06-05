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

import org.as2lib.bean.factory.config.BeanPostProcessor;
import org.as2lib.context.ApplicationContext;
import org.as2lib.context.ApplicationContextAware;
import org.as2lib.context.ApplicationEventPublisherAware;
import org.as2lib.context.MessageSourceAware;
import org.as2lib.core.BasicClass;

/**
 * {@code ApplicationContextAwareProcessor} passes the {@link ApplicationEventPublisher},
 * {@link MessageSource} and {@link ApplicationContext} to beans that implement the
 * {@link ApplicationEventPublisherAware}, {@link MessageSourceAware} and/or {@link ApplicationContextAware}
 * interfaces, respectively. If all of them are implemented, they are satisfied in the
 * given order.
 * 
 * <p>Application contexts will automatically register this processor with their underlying
 * bean factory. Applications do not use this class directly.
 * 
 * @author Simon Wacker
 */
class org.as2lib.context.support.ApplicationContextAwareProcessor extends BasicClass implements BeanPostProcessor {
	
	/** The application context to make beans aware of. */
	private var applicationContext:ApplicationContext;
	
	/**
	 * Constructs a new {@code ApplicationContextAwareProcessor} instance.
	 * 
	 * @param applicationContext the application context to make beans aware of
	 */
	public function ApplicationContextAwareProcessor(applicationContext:ApplicationContext) {
		this.applicationContext = applicationContext;
	}
	
	public function postProcessBeforeInitialization(bean, beanName:String) {
		if (bean instanceof ApplicationEventPublisherAware) {
			ApplicationEventPublisherAware(bean).setApplicationEventPublisher(applicationContext.getEventPublisher());
		}
		if (bean instanceof MessageSourceAware) {
			MessageSourceAware(bean).setMessageSource(applicationContext.getMessageSource());
		}
		if (bean instanceof ApplicationContextAware) {
			ApplicationContextAware(bean).setApplicationContext(applicationContext);
		}
		return bean;
	}
	
	public function postProcessAfterInitialization(bean, name:String) {
		return bean;
	}
	
}