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

import org.as2lib.bean.factory.config.BeanDefinition;
import org.as2lib.bean.factory.config.ConstructorArgumentValues;
import org.as2lib.bean.factory.support.BeanDefinitionValidationException;
import org.as2lib.bean.factory.support.MethodOverride;
import org.as2lib.bean.factory.support.MethodOverrides;
import org.as2lib.bean.PropertyValues;
import org.as2lib.core.BasicClass;
import org.as2lib.env.except.IllegalStateException;
import org.as2lib.env.reflect.ReflectUtil;

/**
 * {@code AbstractBeanDefinition} is the base class for bean definition objects,
 * factoring out common properties of {@link RootBeanDefinition} and
 * {@link ChildBeanDefinition}.
 *
 * @author Simon Wacker
 */
class org.as2lib.bean.factory.support.AbstractBeanDefinition extends BasicClass
		implements BeanDefinition {

	/**
	 * Constant that indicates no autowiring at all.
	 *
	 * @see #setAutowireMode
	 */
	public static var AUTOWIRE_NO:Number = 0;

	/**
	 * Constant that indicates autowiring bean properties by name.
	 *
	 * @see #setAutowireMode
	 */
	public static var AUTOWIRE_BY_NAME:Number = 1;

	/**
	 * Constant that indicates no dependency check at all.
	 *
	 * @see #setDependencyCheck
	 */
	public static var DEPENDENCY_CHECK_NONE:Number = 0;

	/**
	 * Constant that indicates dependency checking for object references.
	 *
	 * @see #setDependencyCheck
	 */
	public static var DEPENDENCY_CHECK_OBJECTS:Number = 1;

	/**
	 * Constant that indicates dependency checking for "simple" properties.
	 *
	 * @see #setDependencyCheck
	 */
	public static var DEPENDENCY_CHECK_SIMPLE:Number = 2;

	/**
	 * Constant that indicates dependency checking for all properties (object
	 * references as well as "simple" properties).
	 *
	 * @see #setDependencyCheck
	 */
	public static var DEPENDENCY_CHECK_ALL:Number = 3;

	/**
	 * Constant that indicates that the bean shall be populated before it is set as
	 * property value. This means that if the bean is used as property value it will
	 * be instantiated, populated and then set as property value.
	 *
	 * @see #setPopulateMode
	 */
	public static var POPULATE_BEFORE:Number = 0;

	/**
	 * Constant that indicates that the bean shall be populated after it is was set as
	 * property value. This means that if the bean is used as property value it will be
	 * instantiated, then set as property value and after that populated.
	 *
	 * @see #setPopulateMode
	 */
	public static var POPULATE_AFTER:Number = 1;

	/** The class of the bean. */
	private var beanClass:Function;

	/** The name of the bean class. */
	private var beanClassName:String;

	/** Is this bean abstract? */
	private var abstract:Boolean;

	/** Is this bean a singleton? */
	private var singleton:Boolean;

	/** Is this bean lazily initialized? */
	private var lazyInit:Boolean;

	/** The autowire mode. */
	private var autowireMode:Number;

	/** The dependency check code. */
	private var dependencyCheck:Number;

	/** The populate mode. */
	private var populateMode:Number;

	/** The names of the beans this bean depends on. */
	private var dependsOn:Array;

	/** The argument values of the constructor used when instantiating this bean. */
	private var constructorArgumentValues:ConstructorArgumentValues;

	/** The property values of this bean. */
	private var propertyValues:PropertyValues;

	/** The default property name. */
	private var defaultPropertyName:String;

	/** The method overrides of this bean. */
	private var methodOverrides:MethodOverrides;

	/** The name of the factory bean. */
	private var factoryBeanName:String;

	/** The name of the factory method. */
	private var factoryMethodName:String;

	/** Shall this bean be instantiated by means of the enclosing or referencing property? */
	private var instantiateWithProperty:Boolean;

	/** Is this bean a static bean? */
	private var statik:Boolean;

	/** The name of the init method. */
	private var initMethodName:String;

	/** The name of the destroy method. */
	private var destroyMethodName:String;

	/** Is the execution of the init method enforced? */
	private var enforceInitMethod:Boolean;

	/** Is the execution of the destroy method enforced? */
	private var enforceDestroyMethod:Boolean;

	/** The name of the style to format this bean with. */
	private var styleName:String;

	/** The element that was the source of this definition in the configuration. */
	private var source:XMLNode;

	/**
	 * Constructs a new {@code AbstractBeanDefinition} instance.
	 *
	 * <p>This bean definition is by default a singleton, but it is not abstract,
	 * it is not lazily initialized, it enforces init and destroy methods, it does
	 * not check dependencies and it does no autowiring.
	 *
	 * @param constructorArgumentValues the constructor argument values
	 * @param propertyValues the property values
	 */
	public function AbstractBeanDefinition(constructorArgumentValues:ConstructorArgumentValues, propertyValues:PropertyValues) {
		setConstructorArgumentValues(constructorArgumentValues);
		setPropertyValues(propertyValues);
		abstract = false;
		singleton = true;
		lazyInit = false;
		dependencyCheck = DEPENDENCY_CHECK_NONE;
		autowireMode = AUTOWIRE_NO;
		methodOverrides = new MethodOverrides();
		enforceInitMethod = true;
		enforceDestroyMethod = true;
	}

	/**
	 * Overrides settings in this bean definition from the given bean definition.
	 *
	 * <ul>
	 *   <li>Will override beanClass and beanClassName if specified in the given bean
	 *       definition.
	 *   <li>Will always take abstract, singleton, lazyInit from the given bean definition.
	 *   <li>Will add argumentValues, propertyValues, methodOverrides to
	 *       existing ones.
	 *   <li>Will override initMethodName, destroyMethodName, factoryBeanName,
	 *       factoryMethodName, instantiateWithProperty, static, populateMode and
	 *       defaultPropertyName if specified.
	 *   <li>Will always take dependsOn, autowireMode and dependencyCheck from the
	 *       given bean definition.
	 *   <li>Will always take styleName and source from the given bean definition.
	 * </ul>
	 *
	 * @param beanDefinition the bean definition holding settings to override in this
	 * bean definition
	 */
	public function override(beanDefinition:AbstractBeanDefinition):Void {
		if (beanDefinition.hasBeanClass()) {
			beanClass = beanDefinition.beanClass;
			beanClassName = beanDefinition.beanClassName;
		}
		abstract = beanDefinition.abstract;
		singleton = beanDefinition.singleton;
		lazyInit = beanDefinition.lazyInit;
		autowireMode = beanDefinition.autowireMode;
		dependencyCheck = beanDefinition.dependencyCheck;
		dependsOn = beanDefinition.dependsOn;
		styleName = beanDefinition.styleName;
		source = beanDefinition.source;
		constructorArgumentValues.addArgumentValues(beanDefinition.constructorArgumentValues);
		propertyValues.addPropertyValues(beanDefinition.propertyValues);
		methodOverrides.addOverrides(beanDefinition.methodOverrides);
		if (beanDefinition.factoryBeanName != null) {
			factoryBeanName = beanDefinition.factoryBeanName;
		}
		if (beanDefinition.factoryMethodName != null) {
			factoryMethodName = beanDefinition.factoryMethodName;
		}
		if (beanDefinition.initMethodName != null) {
			initMethodName = beanDefinition.initMethodName;
			enforceInitMethod = beanDefinition.enforceInitMethod;
		}
		if (beanDefinition.destroyMethodName != null) {
			destroyMethodName = beanDefinition.destroyMethodName;
			enforceDestroyMethod = beanDefinition.enforceDestroyMethod;
		}
		if (beanDefinition.instantiateWithProperty != null) {
			instantiateWithProperty = beanDefinition.instantiateWithProperty;
		}
		if (beanDefinition.statik != null) {
			statik = beanDefinition.statik;
		}
		if (beanDefinition.populateMode != null) {
			populateMode = beanDefinition.populateMode;
		}
		if (beanDefinition.defaultPropertyName != null) {
			defaultPropertyName = beanDefinition.defaultPropertyName;
		}
	}

	public function hasBeanClass(Void):Boolean {
		return (beanClass != null);
	}

	/**
	 * Specifies the class for this bean.
	 *
	 * @param beanClass the class of this bean
	 */
	public function setBeanClass(beanClass:Function):Void {
		this.beanClass = beanClass;
	}

	public function getBeanClass(Void):Function {
		if (!hasBeanClass()) {
			throw new IllegalStateException("Bean definition [" + toString() + "] does not " +
					"carry a bean class.", this, arguments);
		}
		if (beanClassName != null) {
			// Updates the bean class if it has changed. This may happen when AOP is used.
			// Because bean definitions are in most cases parsed before the weaving process is done.
			var newBeanClass:Function = eval("_global." + beanClassName);
			if (beanClass != newBeanClass) {
				beanClass = newBeanClass;
			}
		}
		return beanClass;
	}

	/**
	 * Sets the class name for the defined bean.
	 *
	 * @param beanClassName the class name for the defined bean
	 */
	public function setBeanClassName(beanClassName:String):Void {
		this.beanClassName = beanClassName;
	}

	public function getBeanClassName(Void):String {
		if (beanClassName == null && beanClass != null) {
			beanClassName = ReflectUtil.getTypeNameForType(beanClass);
		}
		return beanClassName;
	}

	/**
	 * Sets if this bean is "abstract", i.e. not meant to be instantiated itself but
	 * rather just serving as parent for concrete child bean definitions.
	 *
	 * <p>Default is {@code false}. Specify {@code true} to tell the bean factory
	 * to not try to instantiate this particular bean in any case.
	 *
	 * @param abstract whether this bean definition is abstract
	 */
	public function setAbstract(abstract:Boolean):Void {
		this.abstract = abstract;
	}

	public function isAbstract(Void):Boolean {
		return abstract;
	}

	/**
	 * Sets if this is a <b>singleton</b>, with a single, shared instance returned
	 * on all calls. If {@code false}, the bean factory will apply the <b>prototype</b>
	 * design pattern, with each caller requesting an instance getting an
	 * independent instance. How this is defined will depend on the bean factory.
	 * <p>"Singletons" are the more common type, so the default is {@code true}.
	 *
	 * @param sngleton whether the defined bean is a singleton
	 */
	public function setSingleton(singleton:Boolean):Void {
		this.singleton = singleton;
	}

	public function isSingleton(Void):Boolean {
		return singleton;
	}

	/**
	 * Sets whether this bean shall be lazily initialized. Only applicable to a
	 * singleton bean. If {@code false}, it will get instantiated on startup by
	 * bean factories that perform eager initialization of singletons.
	 *
	 * @param lazyInit whether to init singletons lazily
	 */
	public function setLazyInit(lazyInit:Boolean):Void {
		this.lazyInit = lazyInit;
	}

	public function isLazyInit(Void):Boolean {
		return lazyInit;
	}

	/**
	 * Sets the autowire mode. This determines whether any automatical detection
	 * and setting of bean references will happen. Default is {@code AUTOWIRE_NO},
	 * which means there is no autowiring.
	 *
	 * @param autowireMode the autowire mode to set; must be one of the constants
	 * defined in this class
	 * @see #AUTOWIRE_NO
	 * @see #AUTOWIRE_BY_NAME
	 */
	public function setAutowireMode(autowireMode:Number):Void {
		this.autowireMode = autowireMode;
	}

	public function getAutowireMode(Void):Number {
		return autowireMode;
	}

	/**
	 * Sets the dependency check code.
	 *
	 * @param dependencyCheck the code to set. Must be one of the constants defined
	 * in this class.
	 * @see #DEPENDENCY_CHECK_NONE
	 * @see #DEPENDENCY_CHECK_OBJECTS
	 * @see #DEPENDENCY_CHECK_SIMPLE
	 * @see #DEPENDENCY_CHECK_ALL
	 */
	public function setDependencyCheck(dependencyCheck:Number):Void {
		this.dependencyCheck = dependencyCheck;
	}

	public function getDependencyCheck(Void):Number {
		return dependencyCheck;
	}

	/**
	 * Sets the populate mode. This determines when this bean shall be populated, this
	 * means when the property values shall be applied. Default is {@code POPULATE_BEFORE},
	 * which means that the bean is populated before it is itself used as property value.
	 *
	 * @param populateMode the populate mode to set; must be one of the constants defined
	 * in this class
	 * @see #POPULATE_BEFORE
	 * @see #POPULATE_AFTER
	 */
	public function setPopulateMode(populateMode:Number):Void {
		this.populateMode = populateMode;
	}

	public function getPopulateMode(Void):Number {
		if (populateMode == null) {
			return POPULATE_BEFORE;
		}
		return populateMode;
	}

	/**
	 * Sets the names of the beans that this bean depends on being initialized.
	 * The bean factory will guarantee that these beans get initialized before.
	 *
	 * <p>Note that dependencies are normally expressed through bean properties or
	 * constructor arguments. This property should just be necessary for other kinds
	 * of dependencies like statics (*ugh*).
	 *
	 * @param dependsOn the names of the beans this bean depends on
	 */
	public function setDependsOn(dependsOn:Array):Void {
		this.dependsOn = dependsOn;
	}

	public function getDependsOn(Void):Array {
		return dependsOn;
	}

	/**
	 * Specifies constructor argument values for this bean.
	 *
	 * @param constructorArgumentValues the constructor argument values for this bean
	 */
	public function setConstructorArgumentValues(constructorArgumentValues:ConstructorArgumentValues):Void {
		this.constructorArgumentValues = (constructorArgumentValues != null) ? constructorArgumentValues : new ConstructorArgumentValues();
	}

	public function getConstructorArgumentValues(Void):ConstructorArgumentValues {
		return constructorArgumentValues;
	}

	/**
	 * Specifies property values for this bean, if any.
	 *
	 * @param propertyValues the property values to specify
	 */
	public function setPropertyValues(propertyValues:PropertyValues):Void {
		this.propertyValues = (propertyValues != null) ? propertyValues : new PropertyValues();
	}

	public function getPropertyValues(Void):PropertyValues {
		return propertyValues;
	}

	/**
	 * Specified the default property name to use if non has been specified for a
	 * property.
	 *
	 * @param defaultPropertyName the name of the default property
	 */
	public function setDefaultPropertyName(defaultPropertyName:String):Void {
		this.defaultPropertyName = defaultPropertyName;
	}

	public function getDefaultPropertyName(Void):String {
		return defaultPropertyName;
	}

	/**
	 * Specifies method overrides for this bean, if any.
	 *
	 * @param methodOverrides the method overrides
	 */
	public function setMethodOverrides(methodOverrides:MethodOverrides):Void {
		this.methodOverrides = (methodOverrides != null) ? methodOverrides : new MethodOverrides();
	}

	public function getMethodOverrides(Void):MethodOverrides {
		return methodOverrides;
	}

	/**
	 * Specifies the factory bean to use, if any.
	 *
	 * @param factoryBeanName the factory bean to use
	 */
	public function setFactoryBeanName(factoryBeanName:String):Void {
		this.factoryBeanName = factoryBeanName;
	}

	public function getFactoryBeanName(Void):String {
		return factoryBeanName;
	}

	/**
	 * Specifies a factory method, if any. This method will be invoked with
	 * constructor arguments, or with no arguments if none are specified.
	 * The static method will be invoked on the specifed factory bean,
	 * if any, or on the local bean class else.
	 *
	 * @param factoryMethodName static factory method name, or {@code null} if
	 * normal constructor creation should be used
	 * @see #getBeanClass
	 * @see getFactoryBeanName
	 */
	public function setFactoryMethodName(factoryMethodName:String):Void {
		this.factoryMethodName = factoryMethodName;
	}

	public function getFactoryMethodName(Void):String {
		return factoryMethodName;
	}

	/**
	 * Sets whether this bean definition shall be instantiated by means of the property
	 * enclosing or referencing it.
	 *
	 * @param instantiateWithProperty whether this bean definition shall be instantiated
	 * by means of the property enclosing or referencing it
	 * @see #isInstantiateWithProperty
	 */
	public function setInstantiateWithProperty(instantiateWithProperty:Boolean):Void {
		this.instantiateWithProperty = instantiateWithProperty;
	}

	public function isInstantiateWithProperty(Void):Boolean {
		if (instantiateWithProperty == null) {
			return false;
		}
		return instantiateWithProperty;
	}

	/**
	 * Sets whether this bean is a static bean; which means that this bean is not an
	 * instance of the bean class, but the bean class itself (in turn a static class).
	 *
	 * @param statik is this bean a static bean?
	 * @see #isStatic
	 */
	public function setStatic(statik:Boolean):Void {
		this.statik = statik;
	}

	public function isStatic(Void):Boolean {
		if (statik == null) {
			return false;
		}
		return statik;
	}

	/**
	 * Sets the name of the initializer method. The default is {@code null}
	 * in which case there is no initializer method.
	 *
	 * @param initMethodName the name of the init method
	 */
	public function setInitMethodName(initMethodName:String):Void {
		this.initMethodName = initMethodName;
	}

	public function getInitMethodName(Void):String {
		return initMethodName;
	}

	/**
	 * Specifies whether or not the configured init method is the default.
	 * Default value is {@code true}.
	 *
	 * @param enforceInitMethod whether to enforce init method execution
	 * @see #setInitMethodName
	 */
	public function setEnforceInitMethod(enforceInitMethod:Boolean):Void {
		this.enforceInitMethod = enforceInitMethod;
	}

	public function isEnforceInitMethod(Void):Boolean {
		return enforceInitMethod;
	}

	/**
	 * Set the name of the destroy method. The default is {@code null}
	 * in which case there is no destroy method.
	 *
	 * @param destroyMethodName the name of the destroy method
	 */
	public function setDestroyMethodName(destroyMethodName:String):Void {
		this.destroyMethodName = destroyMethodName;
	}

	public function getDestroyMethodName(Void):String {
		return destroyMethodName;
	}

	/**
	 * Specifies whether or not the configured destroy method is the default.
	 * Default value is {@code true}.
	 *
	 * @param enforceDestroyMethod whether to enforce destroy method execution
	 * @see #setDestroyMethodName
	 */
	public function setEnforceDestroyMethod(enforceDestroyMethod:Boolean):Void {
		this.enforceDestroyMethod = enforceDestroyMethod;
	}

	public function isEnforceDestroyMethod(Void):Boolean {
		return enforceDestroyMethod;
	}

	/**
	 * Sets the name of the style. This property is normally used by UI bean
	 * definitions to format beans with a specific style of style sheet.
	 *
	 * @param styleName the name of the style
	 */
	public function setStyleName(styleName:String):Void {
		this.styleName = styleName;
	}

	public function getStyleName(Void):String {
		return styleName;
	}

	/**
	 * Sets the element that was the source of this bean definition in the
	 * configuration.
	 */
	public function setSource(source:XMLNode):Void {
		this.source = source;
	}

	public function getSource(Void):XMLNode {
		return source;
	}

	public function validate(Void):Void {
		if (lazyInit && !singleton) {
			throw new BeanDefinitionValidationException("Lazy initialization is only applicable " +
					"to singleton beans.", this, arguments);
		}
		if (statik && !constructorArgumentValues.isEmpty()) {
			throw new BeanDefinitionValidationException("Constructor arguments values are only " +
					"applicable to non-static beans.", this, arguments);
		}
		if (statik && !methodOverrides.isEmpty()) {
			throw new BeanDefinitionValidationException("Method overrides are only applicable " +
					"to non-static beans.", this, arguments);
		}
	}

	/**
	 * Returns the string representation of this instance.
	 *
	 * @return this instance's string representation
	 */
	public function toString():String {
		var result:String = "class [";
		result += getBeanClassName() + "]";
		result += "; abstract=" + abstract;
		result += "; singleton=" + singleton;
		result += "; lazyInit=" + lazyInit;
		result += "; autowire=" + autowireMode;
		result += "; dependencyCheck=" + dependencyCheck;
		result += "; populate=" + populateMode;
		result += "; instantiateWithProperty=" + instantiateWithProperty;
		result += "; factoryBeanName=" + factoryBeanName;
		result += "; factoryMethodName=" + factoryMethodName;
		result += "; initMethodName=" + initMethodName;
		result += "; destroyMethodName=" + destroyMethodName;
		result += "; static=" + statik;
		result += "; styleName=" + styleName;
		result += "; defaultPropertyName=" + defaultPropertyName;
		return result;
	}

}