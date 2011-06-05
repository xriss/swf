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

import org.as2lib.bean.factory.config.ConstructorArgumentValues;
import org.as2lib.bean.factory.support.MethodOverrides;
import org.as2lib.bean.PropertyValues;
import org.as2lib.core.BasicInterface;

/**
 * {@code BeanDefinition} describes a bean instance, which has property values,
 * constructor argument values, and further information.
 * 
 * @author Simon Wacker
 */
interface org.as2lib.bean.factory.config.BeanDefinition extends BasicInterface {
	
	/**
	 * Returns whether this bean has a bean class.
	 * 
	 * @return {@code true} if this bean has a bean class else {@code false}
	 */
	public function hasBeanClass(Void):Boolean;
	
	/**
	 * Returns the bean class of this bean.
	 * 
	 * @return the bean class
	 * @throws IllegalStateException if the bean definition does not carry a resolved
	 * bean class
	 */
	public function getBeanClass(Void):Function;
	
	/**
	 * Returns the name of the bean class.
	 * 
	 * @return the name of the bean class
	 */
	public function getBeanClassName(Void):String;
	
	/**
	 * Returns the name of the factory bean.
	 * 
	 * @return the name of the factory bean
	 */
	public function getFactoryBeanName(Void):String;
	
	/**
	 * Returns the name of the factory method.
	 * 
	 * @return the name of the factory method
	 */
	public function getFactoryMethodName(Void):String;
	
	/**
	 * Returns whether this bean shall be instantiated by means of the property
	 * enclosing or referencing it.
	 * 
	 * <p>If this bean definition is for example an inner bean definition, then the
	 * instance returned by the getter of the enclosing property will be used as bean
	 * instance.
	 * 
	 * @return {@code true} if this bean shall be instantiated using the getter of the
	 * enclosing or referencing property, else {@code false}
	 */
	public function isInstantiateWithProperty(Void):Boolean;
	
	/**
	 * Returns whether this bean is static. This means that this bean is not an
	 * instance of the bean class, but the bean class itself (which is in turn a static
	 * class).
	 * 
	 * @return {@code true} if this bean is static else {@code false}
	 */
	public function isStatic(Void):Boolean;
	
	/**
	 * Returns the names of the beans this bean depends on.
	 * 
	 * @return the names of the beans this bean depends on
	 */
	public function getDependsOn(Void):Array;
	
	/**
	 * Returns the dependency check code.
	 * 
	 * @return the dependency check code
	 */
	public function getDependencyCheck(Void):Number;
	
	/**
	 * Returns the autowire mode as specified in the bean definition.
	 * 
	 * @return the autowire mode
	 */
	public function getAutowireMode(Void):Number;
	
	/**
	 * Returns the populate mode as specified in the bean definition.
	 * 
	 * @return the populate mode
	 */
	public function getPopulateMode(Void):Number;
	
	/**
	 * Returns information about methods to be overridden by the IoC container. This
	 * will be empty if there are no method overrides.
	 * 
	 * @return the methods to override
	 */
	public function getMethodOverrides(Void):MethodOverrides;
	
	/**
	 * Returns the name of the init-method.
	 * 
	 * @return the name of the init-method
	 */
	public function getInitMethodName(Void):String;
	
	/**
	 * Returns whether to enforce the init-method. If the init-method is enforced, the
	 * bean factory will throw an exception if the init-method for example does not
	 * exist.
	 * 
	 * @return {@code true} if the init-method shall be enforced else {@code false}
	 */
	public function isEnforceInitMethod(Void):Boolean;
	
	/**
	 * Returns the name of the destroy-method.
	 * 
	 * @return the name of the destroy-method
	 */
	public function getDestroyMethodName(Void):String;
	
	/**
	 * Returns whether to enforce the destroy-method. If the destroy-method is enforced,
	 * the bean factory will throw an exception if the destroy-method for example does
	 * not exist.
	 * 
	 * @return {@code true} if the destroy-method shall be enforced else {@code false}
	 */
	public function isEnforceDestroyMethod(Void):Boolean;
	
	/**
	 * Returns the constructor argument values for this bean, if any. Can be modified
	 * during bean factory post-processing.
	 * 
	 * @return the constructor argument values or {@code null}
	 */
	public function getConstructorArgumentValues(Void):ConstructorArgumentValues;
	
	/**
	 * Returns the property values to be applied to a new instance of this bean, if any.
	 * Can be modified during bean factory post-processing.
	 * 
	 * @return the property values or {@code null}
	 */
	public function getPropertyValues(Void):PropertyValues;
	
	/**
	 * Returns the name of the default property to use if non has been specified for
	 * a property.
	 * 
	 * @return the default property name
	 */
	public function getDefaultPropertyName(Void):String;
	
	/**
	 * Returns whether this bean is a singleton with a single shared instance returned
	 * on all calls.
	 * 
	 * @return {@code true} if this bean is a singleton else {@code false}
	 */
	public function isSingleton(Void):Boolean;
	
	/**
	 * Returns whether this bean shall be lazily initialized, i.e. not eagerly
	 * instantiated on startup. Only applicable to a singleton bean.
	 * 
	 * @return {@code true} if this bean shall be lazily initialized else {@code false}
	 */
	public function isLazyInit(Void):Boolean;
	
	/**
	 * Returns whether this bean is abstract, i.e. not meant to be instantiated.
	 * 
	 * @return {@code true} if this bean is abstract else {@code false}
	 */
	public function isAbstract(Void):Boolean;
	
	/**
	 * Returns the name of the style. This property is normally used by UI bean
	 * definitions to format beans with a specific style of style sheet.
	 * 
	 * @return the style of this bean definition
	 */
	public function getStyleName(Void):String;
	
	/**
	 * Returns the element that was the source of this bean definition in the
	 * configuration.
	 * 
	 * @return the source element of this bean definition
	 */
	public function getSource(Void):XMLNode;
	
	/**
	 * Validates this bean definition.
	 * 
	 * @throws BeanDefinitionValidationException in case of validation failure
	 */
	public function validate(Void):Void;
	
}