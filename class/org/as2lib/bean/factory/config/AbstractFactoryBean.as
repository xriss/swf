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

import org.as2lib.bean.factory.DisposableBean;
import org.as2lib.bean.factory.InitializingBean;
import org.as2lib.bean.PropertyAccess;
import org.as2lib.core.BasicClass;
import org.as2lib.env.except.AbstractOperationException;

/**
 * {@code AbstractFactoryBean} is a simple template superclass for {@link FactoryBean}
 * implementations thats allows for creating a singleton or a prototype, depending on
 * the {@code singleton} flag.
 * 
 * <p>If the {@code singleton} flag is {@code true} (the default), this class will
 * create the singleton instance once on initialization and subsequently return the
 * same instance. Else, this class will create a new instance each time. Subclasses
 * are responsible for implementing the abstract {@link #createInstance} template
 * method to actually create the objects to expose.
 * 
 * @author Simon Wacker
 */
class org.as2lib.bean.factory.config.AbstractFactoryBean extends BasicClass implements
		InitializingBean, DisposableBean {
	
	/** Is the wrapped object a singleton? */
	private var singleton:Boolean;
	
	/** The singleton instance, if wrapped object is a singleton. */
	private var singletonInstance;
	
	/**
	 * Constructs a new {@code AbstractFactoryBean} instance.
	 */
	private function AbstractFactoryBean(Void) {
		singleton = true;
	}
	
	public function isSingleton(Void):Boolean {
		return singleton;
	}
	
	/**
	 * Sets if a singleton shall be created once, or a new object on each request.
	 * 
	 * <p>Default is {@code true}, a singleton.
	 * 
	 * @param singleton whether this factory returns a singleton or a prototype object
	 */
	public function setSingleton(singleton:Boolean):Void {
		this.singleton = singleton;
	}
	
	public function afterPropertiesSet(Void):Void {
		if (singleton) {
			singletonInstance = createInstance();
		}
	}
	
	public function getObject(property:PropertyAccess) {
		if (singleton) {
			return singletonInstance;
		}
		else {
			return createInstance();
		}
	}
	
	public function destroy(Void):Void {
		if (singleton) {
			destroyInstance(singletonInstance);
		}
	}
	
	/**
	 * Template method that subclasses must override to construct the object returned
	 * by this factory.
	 * 
	 * <p>Invoked on initialization of this factory bean in case of a singleton; else,
	 * on each {@link #getObject} call.
	 * 
	 * @return the object returned by this factory
	 * @throws Error if an exception occured during object creation
	 */
	private function createInstance(Void) {
		throw new AbstractOperationException("This method is marked as abstract and must be " +
				"overridden by sub-classes.", this, arguments);
		return null;
	}
	
	/**
	 * Callback for destroying a singleton instance. Subclasses may override this to
	 * destroy the previously created instance.
	 * 
	 * <p>The default implementation is empty.
	 * 
	 * @param instance the singleton instance, as returned by {@link #createInstance}
	 * @throws Error in case of shutdown errors
	 */
	private function destroyInstance(instance:Object):Void {
	}
	
}