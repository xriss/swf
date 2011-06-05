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

import org.as2lib.bean.factory.config.ConfigurableListableBeanFactory;
import org.as2lib.bean.factory.support.DefaultBeanFactory;
import org.as2lib.context.ApplicationContext;
import org.as2lib.context.support.AbstractApplicationContext;
import org.as2lib.env.except.AbstractOperationException;
import org.as2lib.env.except.IllegalStateException;

/**
 * {@code AbstractRefreshableApplicationContext} the base class for application
 * contexts that support multiple refreshes, creating a new internal bean factory
 * every time.
 * 
 * @author Simon Wacker
 */
class org.as2lib.context.support.AbstractRefreshableApplicationContext extends
		AbstractApplicationContext {
	
	/** Internal bean factory of this context. */
	private var beanFactory:DefaultBeanFactory;
	
	/**
	 * Constructs a new {@code RefreshableApplicationContext} instance.
	 * 
	 * @param parent the parent of this application context
	 */
	public function AbstractRefreshableApplicationContext(parent:ApplicationContext) {
		super(parent);
	}
	
	/**
	 * Creates the bean factory for this context.
	 * 
	 * <p>Default implementation creates a {@link DefaultBeanFactory} with the
	 * internal bean factory of this context's parent as parent bean factory.
	 * 
	 * <p>Can be overridden in subclasses.
	 * 
	 * @return the bean factory for this context
	 * @see #getInternalParentBeanFactory
	 */
	private function createBeanFactory(Void):DefaultBeanFactory {
		return new DefaultBeanFactory(getInternalParentBeanFactory());
	}
	
	//---------------------------------------------------------------------
	// Implementations of AbstractApplicationContext's template methods
	//---------------------------------------------------------------------
	
	/**
	 * Destroys all singletons registered at the current internal bean factory and
	 * creates a new internal bean factory.
	 * 
	 * @see #createBeanFactory
	 * @see #loadBeanDefinitions
	 */
	private function refreshBeanFactory(Void):Void {
		if (beanFactory != null) {
			beanFactory.destroySingletons();
			beanFactory = null;
		}
		var beanFactory = createBeanFactory();
		beanFactory.setParentBeanFactory(getInternalParentBeanFactory());
		loadBeanDefinitions(beanFactory);
		this.beanFactory = beanFactory;
	}
	
	/**
	 * Returns the single internal bean factory held by this context.
	 * 
	 * @return the single internal bean factory of this context
	 * @throws IllegalStateException if this context does not hold an internal bean factory
	 * yet (usually if {@code refresh} has never been called)
	 */
	public function getBeanFactory(Void):ConfigurableListableBeanFactory {
		if (beanFactory == null) {
			throw new IllegalStateException("Bean factory not initialized: Call 'refresh' before " +
					"attempting to get the internal bean factory.", this, arguments);
		}
		return beanFactory;
	}
	
	//---------------------------------------------------------------------
	// Abstract methods that must be implemented by subclasses
	//---------------------------------------------------------------------
	
	/**
	 * Loads bean definitions into the given bean factory.
	 * 
	 * <p>Subclasses must implement this method to load the bean definitions into the
	 * given bean factory. This method is invoked by {@link #refreshBeanFactory} directly
	 * after the bean factory has been created.
	 * 
	 * @param beanFactory the bean factory to load bean definitions into
	 * @throws BeanException if parsing of the bean definitions failed
	 */
	private function loadBeanDefinitions(beanFactory:DefaultBeanFactory):Void {
		throw new AbstractOperationException("This method is marked as abstract and must be " +
				"overridden by sub-classes.", this, arguments);
	}
	
}