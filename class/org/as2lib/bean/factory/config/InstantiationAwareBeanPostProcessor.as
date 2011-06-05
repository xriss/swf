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

/**
 * {@code InstantiationAwareBeanPostProcessor} adds a before- and after-instantiation
 * callbacks to bean post processors.
 * 
 * <p>Typically used to suppress default instantiation for specific target beans, for
 * example to create proxies with special target sources (pooling targets, lazily
 * initializing targets, et cetera).
 * 
 * @author Simon Wacker
 */
interface org.as2lib.bean.factory.config.InstantiationAwareBeanPostProcessor extends BeanPostProcessor {
	
	/**
	 * Applies this post-processor before the target bean gets instantiated. The returned
	 * bean object may be a proxy to use instead of the target bean, effectively
	 * suppressing default instantiation of the target bean.
	 * 
	 * <p>If a non-null object is returned by this method, the bean creation process will
	 * be short-circuited. The returned bean object will not be processed any further;
	 * in particular, no further post-processor callbacks will be applied to it. This
	 * mechanism is mainly intended for exposing a proxy instead of an actual target
	 * bean.
	 * 
	 * <p>This callback will only be applied to bean definitions with a bean class. In
	 * particular, it will not be applied to beans with a "factory-method".
	 * 
	 * @param beanClass the class of the bean to be instantiated
	 * @param beanName the name of the bean
	 * @return the bean object to expose instead of a default instance of the target bean
	 * @throws BeanException in case of errors
	 */
	public function postProcessBeforeInstantiation(beanClass:Function, beanName:String);
	
	/**
	 * Performs operations after the bean has been instantiated, via a constructor or factory
	 * method, but before property population (from explicit properties or autowiring) occurs.
	 * 
	 * @param bean the bean instance created, but whose properties have not yet been set
	 * @param beanName the name of the bean
	 * @return {@code true} if properties shall be set on the bean; {@code false} if property
	 * population shall be skipped. Normal implementations should return {@code true}. Returning
	 * {@code false} will also prevent any subsequent {@code InstantiationAwareBeanPostProcessor}
	 * instances being invoked on this bean instance.
	 * @throws BeanException in case of errors
	 */
	public function postProcessAfterInstantiation(bean, beanName:String):Boolean;
	
}