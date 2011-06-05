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

import org.as2lib.bean.factory.BeanFactory;
import org.as2lib.bean.factory.BeanFactoryAware;
import org.as2lib.bean.factory.BeanNameAware;
import org.as2lib.bean.factory.FactoryBean;
import org.as2lib.bean.PropertyAccess;
import org.as2lib.core.BasicClass;
import org.as2lib.env.except.IllegalArgumentException;
import org.as2lib.env.reflect.DelegateManager;

/**
 * {@code DelegateFactoryBean} creates delegates, functions with fixed scopes, given
 * a target bean and a method name.
 * 
 * @author Simon Wacker
 */
class org.as2lib.env.reflect.DelegateFactoryBean extends BasicClass implements FactoryBean,
		BeanNameAware, BeanFactoryAware {
	
	/** The target bean. */
	private var targetBean;
	
	/** The bean name of the target bean. */
	private var targetBeanName:String;
	
	/** The name of the method to create a delegate of. */
	private var methodName:String;
	
	/** This factory bean's bean name. */
	private var beanName:String;
	
	/** The bean factory that contains this factory bean (and the target bean). */
	private var beanFactory:BeanFactory;
	
	/**
	 * Constructs a new {@code DelegateFactoryBean} instance.
	 */
	public function DelegateFactoryBean(Void) {
	}
	
	/**
	 * Specifies the target name that defines the method to create a delegate of.
	 * Alternatively, specify a target bean name.
	 * 
	 * @param targetBean the target bean, for example a bean reference or an inner bean
	 * @see #setTargetBeanName
	 */
	public function setTargetBean(targetBean):Void {
		this.targetBean = targetBean;
	}
	
	/**
	 * Specifies the name of the target bean that defines the method to create a delegate
	 * of. Alternatively, specify a target bean directly.
	 * 
	 * @param targetBeanName the bean name to look up in the containing bean factory
	 * @see #setTargetBean
	 */
	public function setTargetBeanName(targetBeanName:String):Void {
		this.targetBeanName = targetBeanName;
	}
	
	/**
	 * Sets the name of the method, defined on the target bean, to create a delegate
	 * of.
	 * 
	 * @param methodName the name of the method to create a delegate of
	 */
	public function setMethodName(methodName:String):Void {
		this.methodName = methodName;
	}
	
	/**
	 * Sets the bean name of this factory bean. It will be interpreted as
	 * "beanName.method" pattern, if neither a target bean nor a target bean name nor
	 * a method name have been specified.
	 * 
	 * <p>This allows for concise bean definitions with just an id/name.
	 * 
	 * @param beanName the name of this bean
	 */
	public function setBeanName(beanName:String):Void {
		this.beanName = beanName;
	}
	
	public function setBeanFactory(beanFactory:BeanFactory):Void {
		this.beanFactory = beanFactory;
		if (targetBean != null && targetBeanName != null) {
			throw new IllegalArgumentException("Specify either 'targetBean' or 'targetBeanName', " +
					"not both.", this, arguments);
		}
		if (targetBean == null && targetBeanName == null) {
			if (methodName != null) {
				throw new IllegalArgumentException("Specify 'targetBean' or 'targetBeanName' in " +
						"combination with 'methodName'.", this, arguments);
			}
			// No other properties specified: check bean name.
			var dotIndex:Number = beanName.indexOf(".");
			if (dotIndex == -1) {
				throw new IllegalArgumentException(
					"Neither 'targetBean' nor 'targetBeanName' specified, and bean name '" +
					beanName + "' does not follow 'beanName.method' syntax.", this, arguments);
			}
			targetBeanName = beanName.substring(0, dotIndex);
			methodName = beanName.substring(dotIndex + 1);
		}
		else if (methodName == null) {
			// either targetBean or targetBeanName specified
			throw new IllegalArgumentException("'methodName' is required.", this, arguments);
		}
		if (targetBean != null) {
			if (targetBean[methodName] == null) {
				throw new IllegalArgumentException("Target bean [" + targetBean + "] has no " +
						"method named '" + methodName + "'.", this, arguments);
			}
		}
	}
	
	public function getObject(property:PropertyAccess) {
		var target = targetBean;
		if (target == null) {
			target = beanFactory.getBean(targetBeanName);
			if (target[methodName] == null) {
				throw new IllegalArgumentException("Target bean [" + target + "] has no method " +
						"named '" + methodName + "'.", this, arguments);
			}
		}
		return DelegateManager.create(target, methodName);
	}
	
	public function getObjectType(Void):Function {
		return Function;
	}
	
	public function isSingleton(Void):Boolean {
		return false;
	}
	
}