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

import org.as2lib.bean.BeanWrapper;
import org.as2lib.bean.factory.BeanFactory;
import org.as2lib.bean.factory.BeanFactoryAware;
import org.as2lib.bean.factory.BeanNameAware;
import org.as2lib.bean.factory.FactoryBean;
import org.as2lib.bean.FatalBeanException;
import org.as2lib.bean.PropertyAccess;
import org.as2lib.bean.SimpleBeanWrapper;
import org.as2lib.core.BasicClass;
import org.as2lib.env.except.IllegalArgumentException;

/**
 * {@code PropertyPathFactoryBean} evaluates a property path on a given target
 * bean. The target bean can be specified directly or via a bean name.
 * 
 * <p>Usage examples:
 * 
 * <pre>
 *   // target bean to reference by name
 *   &lt;bean id="tb" class="org.as2lib.bean.TestBean" singleton="false"&gt;
 *     &lt;property name="age"&gt;&lt;value&gt;10&lt;/value&gt;&lt;/property&gt;
 *     &lt;property name="spouse"&gt;
 *       &lt;bean class="org.as2lib.bean.TestBean"&gt;
 *         &lt;property name="age"&gt;&lt;value&gt;11&lt;/value&gt;&lt;/property&gt;
 *       &lt;/bean&gt;
 *     &lt;/property&gt;
 *   &lt;/bean&gt;
 *  
 *   // will result in 12, which is the value of property 'age' of the inner bean
 *   &lt;bean id="propertyPath1" class="org.as2lib.bean.factory.config.PropertyPathFactoryBean"&gt;
 *     &lt;property name="targetBean"&gt;
 *       &lt;bean class="org.as2lib.bean.TestBean"&gt;
 *         &lt;property name="age"&gt;&lt;value&gt;12&lt;/value&gt;&lt;/property&gt;
 *       &lt;/bean&gt;
 *     &lt;/property&gt;
 *     &lt;property name="propertyPath"&gt;&lt;value&gt;age&lt;/value&gt;&lt;/property&gt;
 *   &lt;/bean&gt;
 *   
 *   // will result in 11, which is the value of property 'spouse.age' of bean 'tb'
 *   &lt;bean id="propertyPath2" class="org.as2lib.bean.factory.config.PropertyPathFactoryBean"&gt;
 *     &lt;property name="targetBeanName"&gt;&lt;value&gt;tb&lt;/value&gt;&lt;/property&gt;
 *     &lt;property name="propertyPath"&gt;&lt;value&gt;spouse.age&lt;/value&gt;&lt;/property&gt;
 *   &lt;/bean&gt;
 *   
 *   // will result in 10, which is the value of property 'age' of bean 'tb'
 *   &lt;bean id="tb.age" class="org.as2lib.bean.factory.config.PropertyPathFactoryBean"/&gt;
 * </pre>
 * 
 * @author Simon Wacker
 */
class org.as2lib.bean.factory.config.PropertyPathFactoryBean extends BasicClass implements
		FactoryBean, BeanNameAware, BeanFactoryAware {
	
	/** The wrapper of the target bean. */
	private var targetBeanWrapper:BeanWrapper;
	
	/** The bean name of the target bean. */
	private var targetBeanName:String;
	
	/** The path to the property to look-up. */
	private var propertyPath:String;
	
	/** The type of the result. */
	private var resultType:Function;
	
	/** This factory bean's bean name. */
	private var beanName:String;
	
	/** The bean factory that contains this factory bean (and the target bean). */
	private var beanFactory:BeanFactory;
	
	/**
	 * Constructs a new {@code PropertyPathFactoryBean} instance.
	 */
	public function PropertyPathFactoryBean(Void) {
	}
	
	/**
	 * Specifies a target bean to apply the property path to. Alternatively, specify
	 * a target bean name.
	 * 
	 * @param targetBean the target bean, for example a bean reference or an inner bean
	 * @see #setTargetBeanName
	 */
	public function setTargetBean(targetBean):Void {
		targetBeanWrapper = new SimpleBeanWrapper(targetBean);
	}
	
	/**
	 * Specifies the name of the target bean to apply the property path to. Alternatively,
	 * specify a target bean directly.
	 * 
	 * @param targetBeanName the bean name to look up in the containing bean factory
	 * @see #setTargetBean
	 */
	public function setTargetBeanName(targetBeanName:String):Void {
		this.targetBeanName = targetBeanName;
	}
	
	/**
	 * Specifies the property path to apply to the target bean.
	 * 
	 * @param propertyPath the property path, potentially nested (e.g. "age" or
	 * "spouse.age")
	 */
	public function setPropertyPath(propertyPath:String):Void {
		this.propertyPath = propertyPath;
	}
	
	/**
	 * Specifies the type of the result from evaluating the property path. The result
	 * type is needed if you need matching by type.
	 * 
	 * @param resultType the result type
	 */
	public function setResultType(resultType:Function):Void {
		this.resultType = resultType;
	}
	
	/**
	 * Sets the bean name of this factory bean. It will be interpreted as
	 * "beanName.property" pattern, if neither a target bean nor a target bean name nor
	 * a property path have been specified.
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
		if (targetBeanWrapper != null && targetBeanName != null) {
			throw new IllegalArgumentException("Specify either 'targetBean' or 'targetBeanName', " +
					"not both.", this, arguments);
		}
		if (targetBeanWrapper == null && targetBeanName == null) {
			if (propertyPath != null) {
				throw new IllegalArgumentException("Specify 'targetBean' or 'targetBeanName' in " +
						"combination with 'propertyPath'.", this, arguments);
			}
			// No other properties specified: check bean name.
			var dotIndex:Number = beanName.indexOf(".");
			if (dotIndex == -1) {
				throw new IllegalArgumentException("Neither 'targetBean' nor 'targetBeanName' " +
						"specified, and bean name '" + beanName + "' does not follow " +
						"'beanName.property' syntax.", this, arguments);
			}
			targetBeanName = beanName.substring(0, dotIndex);
			propertyPath = beanName.substring(dotIndex + 1);
		}
		else if (propertyPath == null) {
			// either targetBean or targetBeanName specified
			throw new IllegalArgumentException("'propertyPath' is required.", this, arguments);
		}
		if (targetBeanWrapper == null && beanFactory.isSingleton(targetBeanName)) {
			// Eagerly fetch singleton target bean, and determine result type.
			targetBeanWrapper = new SimpleBeanWrapper(beanFactory.getBeanByName(targetBeanName));
			//resultType = targetBeanWrapper.getPropertyType(this.propertyPath);
		}
	}
	
	public function getObject(property:PropertyAccess) {
		var target:BeanWrapper = targetBeanWrapper;
		if (target == null) {
			// fetch prototype target bean
			target = new SimpleBeanWrapper(beanFactory.getBeanByName(targetBeanName, property));
		}
		var value = target.getPropertyValue(propertyPath);
		if (value == null) {
			throw new FatalBeanException("This factory bean is not allowed to return 'null', but " +
					"property value for path '" + propertyPath + "' is 'null'.", this, arguments);
		}
		return value;
	}
	
	public function getObjectType(Void):Function {
		return resultType;
	}
	
	/**
	 * While this factory bean will often be used for singleton targets, the invoked
	 * getters for the property path might return a new object for each call, so we
	 * have to assume that we are not returning the same object for each call.
	 * 
	 * @return {@code false} because it is not known whether the object to return is
	 * a singleton or not
	 */
	public function isSingleton(Void):Boolean {
		return false;
	}
	
}