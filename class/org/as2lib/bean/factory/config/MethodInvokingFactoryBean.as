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
import org.as2lib.env.reflect.ClassNotFoundException;
import org.as2lib.env.reflect.NoSuchMethodException;
import org.as2lib.env.reflect.ReflectUtil;
import org.as2lib.util.MethodUtil;

/**
 * {@code MethodInvokingFactoryBean} returns a value which is the result of a static
 * or instance method invocation. For most use cases it is better to just use the
 * container's built-in factory-method support for the same purpose, since that is
 * smarter at converting arguments. This factory bean is still useful though when you
 * need to call a method which does not return any value (for example, a static class
 * method to force some sort of initialization to happen). This use case is not supported
 * by factory-methods, since a return value is needed to become the bean.
 * 
 * <p>Note that as it is expected to be used mostly for accessing factory methods,
 * this factory by default operates in a <b>singleton</b> fashion. The first request
 * to {@link #getObject} by the owning bean factory will cause a method invocation,
 * whose return value will be cached for subsequent requests. An internal
 * {@link #setSingleton singleton} property may be set to {@code false}, to cause this
 * factory to invoke the target method each time it is asked for an object.
 * 
 * <p>A static target method may be specified by setting the
 * {@link #setTargetMethod targetMethod} property to a String representing the static
 * method name, with {@link #setTargetClass targetClass} specifying the Class that
 * the static method is defined on. Alternatively, a target instance method may be
 * specified, by setting the {@link #setTargetBean targetBean} property as the target
 * bean, and the {@link #setTargetMethod targetMethod} property as the name of the
 * method to call on that target bean. Arguments for the method invocation may be
 * specified by setting the {@link #setArguments arguments} property.
 * 
 * <p>This class depends on {@link #afterPropertiesSet} being called once
 * all properties have been set, as per the {@code InitializingBean} contract.
 * 
 * <p>Note that this factory bean will return the special {@link #VOID} singleton
 * instance when it is used to invoke a method which returns {@code null}, or has a
 * void return type. While the user of the factory bean is presumably calling the
 * method to perform some sort of initialization, and does not care about any return
 * value, all factory beans must return a value, so this special singleton instance
 * is used for this case.
 * 
 * <p>An example (in an XML based bean factory definition) of a bean definition
 * which uses this class to call a static factory method:
 * <code>
 *   &lt;bean id="myObject" class="org.as2lib.bean.factory.config.MethodInvokingFactoryBean">
 *     &lt;property name="staticMethod">&lt;value>com.whatever.MyClassFactory.getInstance&lt;/value>&lt;/property>
 *   &lt;/bean>
 * </code>
 * 
 * @author Simon Wacker
 */
class org.as2lib.bean.factory.config.MethodInvokingFactoryBean extends BasicClass implements
		FactoryBean, BeanNameAware, BeanFactoryAware {
	
	/** Marks the return value as being {@code null} or {@code undefined}. */
	public static var VOID:Object = new Object();
	
	private var singleton:Boolean;
	
	/** Method invocation result in singleton case. */
	private var singletonObject;
	
	private var resultType:Function;
	
	private var targetClass:Function;
	
	private var targetBean;
	
	private var targetBeanName:String;
	
	private var targetMethod:String;
	
	private var staticMethod:String;
	
	private var args:Array;
	
	private var beanName:String;
	
	private var beanFactory:BeanFactory;
	
	/**
	 * Constructs a new {@code MethodInvokingFactoryBean} instance.
	 */
	public function MethodInvokingFactoryBean(Void) {
		singleton = true;
	}
	
	/**
	 * Sets if a singleton should be created once, or a new object on each request.
	 * Default is {@code true}, that means that singleton is created once and stored.
	 * 
	 * @param singleton whether to 
	 */
	public function setSingleton(singleton:Boolean) {
		this.singleton = singleton;
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
	 * Sets the target class on which to invoke the target method. Only necessary when
	 * the target method is static; else, a target bean needs to be specified anyway.
	 * 
	 * @param targetClass the target class to invke the target method on
	 * @see #setTargetBean
	 * @see #setTargetBeanName
	 * @see #setTargetMethod
	 */
	public function setTargetClass(targetClass:Function):Void {
		this.targetClass = targetClass;
	}
	
	/**
	 * Returns the target class on which to invoke the target method.
	 * 
	 * @return the target class
	 */
	public function getTargetClass(Void):Function {
		return targetClass;
	}
	
	/**
	 * Sets the target bean on which to invoke the target method. Only necessary when
	 * the target method is not static; else, a target class is sufficient.
	 * 
	 * @param targetBean the target bean to invoke the method on
	 * @see #setTargetClass
	 * @see #setTargetMethod
	 */
	public function setTargetBean(targetBean):Void {
		this.targetBean = targetBean;
	}
	
	/**
	 * Returns the target bean on which to invoke the target method.
	 * 
	 * @return the target bean
	 */
	public function getTargetBean(Void) {
		return targetBean;
	}
	
	/**
	 * Sets the name of the method to invoke. Refers to either a static method or a
	 * non-static method, depending on whether a target bean is set.
	 * 
	 * @param targetMethod the name of the method to invoke
	 * @see #setTargetClass
	 * @see #setTargetBean
	 * @see #setTargetBeanName
	 */
	public function setTargetMethod(targetMethod:String):Void {
		this.targetMethod = targetMethod;
	}
	
	/**
	 * Returns the name of the method to invoke.
	 * 
	 * @return the name of the target method
	 */
	public function getTargetMethod(Void):String {
		return targetMethod;
	}
	
	/**
	 * Sets a fully qualified static method name to invoke, e.g.
	 * "example.MyExampleClass.myExampleMethod". Convenient alternative to specifying
	 * 'targetClass' and 'targetMethod'.
	 * 
	 * @param staticMethod the fully qualified static method
	 * @see #setTargetClass
	 * @see #setTargetMethod
	 */
	public function setStaticMethod(staticMethod:String):Void {
		this.staticMethod = staticMethod;
	}
	
	/**
	 * Adds the argument at the given index for the method invocation.
	 * 
	 * @param index the index of the argument to add
	 * @param argument the argument to add
	 */
	public function addArgument(index:Number, argument):Void {
		if (args == null) {
			args = new Array();
		}
		args[index] = argument;
	}
	
	/**
	 * Sets arguments for the method invocation. If this property is not set,
	 * or the given array is of length 0, a method with no arguments is assumed.
	 * 
	 * @param args the arguments to use for the invocation
	 */
	public function setArguments(args:Array):Void {
		this.args = args;
	}
	
	/**
	 * Returns the arguments for the method invocation.
	 * 
	 * @return the arguments for the method invocation
	 */
	public function getArguments(Void):Array {
		return args;
	}
	
	/**
	 * Sets the bean name of this bean. It will be interpreted as "className.staticMethod"
	 * pattern, if neither "targetClass" nor "targetBean" nor "targetBeanName" nor
	 * "targetVariable" have been specified. This allows for concise bean definitions
	 * with just an id/name.
	 * 
	 * @param beanName the name of this bean
	 */
	public function setBeanName(beanName:String):Void {
		this.beanName = beanName;
	}
	
	public function setBeanFactory(beanFactory:BeanFactory):Void {
		this.beanFactory = beanFactory;
		if (targetClass != null && (targetBean != null || targetBeanName != null) ||
				targetBean != null && targetBeanName != null) {
			throw new IllegalArgumentException("Specify either 'targetClass' or 'targetBean' or " +
					"'targetBeanName', not all of them.", this, arguments);
		}
		if (targetClass == null && targetBean == null && targetBeanName == null) {
			if (targetMethod != null) {
				throw new IllegalArgumentException("Specify 'targetClass' or 'targetBean' or " +
						"'targetBeanName' in combination with 'targetMethod'.", this, arguments);
			}
			// If no other property specified, consider bean name as static variable expression.
			if (staticMethod == null) {
				staticMethod = beanName;
			}
			var lastDotIndex:Number = staticMethod.lastIndexOf(".");
			if (lastDotIndex == -1 || lastDotIndex == staticMethod.length) {
				throw new IllegalArgumentException("'staticMethod' must be a fully qualified " +
						"class plus method name: e.g. 'example.MyExampleClass.myExampleMethod'.",
						this, arguments);
			}
			var className:String = staticMethod.substring(0, lastDotIndex);
			var methodName:String = staticMethod.substring(lastDotIndex + 1);
			targetClass = eval("_global." + className);
			if (targetClass == null) {
				throw new ClassNotFoundException("Class with name '" + className + "' could not " +
						"be found.", this, arguments);
			}
			targetMethod = methodName;
		}
		if (targetMethod == null) {
			throw new IllegalArgumentException("'targetMethod' is required.", this, arguments);
		}
		if (targetBeanName != null) {
			if (beanFactory.isSingleton(targetBeanName)) {
				targetBean = beanFactory.getBeanByName(targetBeanName);
			}
		}
		// Try to get the exact method first.
		if (targetBean != null) {
			if (targetBean[targetMethod] == null) {
				throw new NoSuchMethodException("Target bean [" + targetBean.toString() + "] has " +
						"no static method named '" + targetMethod + "'.", this, arguments);
			}
		}
		else if (targetClass != null) {
			if (targetClass[targetMethod] == null) {
				throw new NoSuchMethodException("Target class '" +
						ReflectUtil.getTypeNameForType(targetClass) + "' has no static method " +
						"named '" + targetMethod + "'.", this, arguments);
			}
		}
		if (singleton) {
			if (targetBean == null && targetClass == null) {
				throw new IllegalArgumentException("Prototype bean '" + targetBeanName + "cannot " +
						"be combined with singleton result.", this, arguments);
			}
			var returnValue = invoke();
			singletonObject = (returnValue != null ? returnValue : VOID);
		}
	}
	
	/**
	 * Performs the method invocation.
	 */
	private function invoke(Void) {
		var targetObject;
		if (targetBean != null) {
			targetObject = targetBean;
		}
		else if (targetClass != null) {
			targetObject = targetClass;
		}
		else {
			targetObject = beanFactory.getBeanByName(targetBeanName);
		}
		return MethodUtil.invoke(targetMethod, targetObject, args);
	}
	
	/**
	 * Returns the same value each time if the singleton property is set to {@code true},
	 * otherwise returns the value returned from invoking the specified method. However,
	 * returns {@link #VOID} if the method returns {@code null} or has a void return type,
	 * since factory beans must return a result.
	 * 
	 * @param property not used by this factory bean
	 * @return the result of the method invocation
	 */
	public function getObject(property:PropertyAccess) {
		if (singleton) {
			// Singleton: return shared object.
			return singletonObject;
		}
		else {
			// Prototype: new object on each call.
			var returnValue = invoke();
			return (returnValue != null ? returnValue : VOID);
		}
	}
	
	public function getObjectType(Void):Function {
		return resultType;
	}
	
	public function isSingleton(Void):Boolean {
		return singleton;
	}
	
}