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

import org.as2lib.core.BasicInterface;

/**
 * {@code BeanPostProcessor} allows for custom modification of new bean instances,
 * for example checking for marker interfaces or wrapping them with proxies.
 * 
 * <p>Application contexts usually auto-detect bean-post-processor beans in their
 * bean definitions and apply them before any other beans are created. Plain bean
 * factories allow for programmatic registration of post-processors.
 * 
 * <p>Typically, post-processors that populate beans via marker interfaces or the
 * like implement {@link #postProcessBeforeInitialization}, and post-processors
 * that wrap beans with proxies normally implement {@link #postProcessAfterInitialization}.
 * 
 * @author Simon Wacker
 */
interface org.as2lib.bean.factory.config.BeanPostProcessor extends BasicInterface {
	
	/**
	 * Applies this post-processor to the given {@code bean} <i>before</i> any bean
	 * initialization callbacks (like {@link InitializingBean#afterPropertiesSet} or
	 * a custom init-method). The bean will already be populated with property values.
	 * The returned bean instance may be a wrapper around the original.
	 * 
	 * @param bean the bean to post-process
	 * @param beanName the name of the bean
	 * @return the bean instance to use, either the original or a wrapped one
	 * @throws BeanException in case of errors
	 */
	public function postProcessBeforeInitialization(bean, beanName:String);
	
	/**
	 * Applies this post-processor to the given {@code bean} instance after any bean
	 * initialization callbacks (like {@link InitializingBean#afterPropertiesSet} or
	 * a custom init-method). The bean will already be populated with property values.
	 * The returned bean instance may be a wrapper around the original.
	 * 
	 * @param bean the bean to post-process
	 * @param beanName the name of the bean
	 * @return he bean instance to use, either the original or a wrapped one
	 * @throws BeanException in case of errors
	 */
	public function postProcessAfterInitialization(bean, beanName:String);
	
}