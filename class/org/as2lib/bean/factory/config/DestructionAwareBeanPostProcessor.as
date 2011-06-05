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
 * {@code DestructionAwareBeanPostProcessor} adds a before-destruction callback
 * to bean post processors.
 * 
 * <p>The typical usage is to invoke custom destruction callbacks on specific bean
 * types, matching corresponding initialization callbacks.
 * 
 * @author Simon Wacker
 */
interface org.as2lib.bean.factory.config.DestructionAwareBeanPostProcessor extends BeanPostProcessor {
	
	/**
	 * Applis this post-processor to the given bean instance before its destruction.
	 * Can invoke custom destruction callbacks.
	 * 
	 * <p>Like {@link DisposableBean}'s destroy and a custom destroy method, this
	 * callback just applies to singleton beans in the factory (including inner beans).
	 * 
	 * @param bean the bean instance to be destroyed
	 * @param beanName the name of the bean
	 * @throws BeanException in case of errors
	 */
	public function postProcessBeforeDestruction(bean, beanName:String);
	
}