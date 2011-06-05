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

import org.as2lib.bean.AbstractBeanWrapper;
import org.as2lib.bean.BeanWrapper;
import org.as2lib.bean.factory.BeanCreationException;
import org.as2lib.bean.factory.BeanCurrentlyInCreationException;
import org.as2lib.bean.factory.BeanDefinitionStoreException;
import org.as2lib.bean.factory.BeanFactory;
import org.as2lib.bean.factory.BeanFactoryAware;
import org.as2lib.bean.factory.BeanIsNotAFactoryException;
import org.as2lib.bean.factory.BeanNameAware;
import org.as2lib.bean.factory.BeanNotOfRequiredTypeException;
import org.as2lib.bean.factory.config.BeanDefinition;
import org.as2lib.bean.factory.config.BeanDefinitionHolder;
import org.as2lib.bean.factory.config.BeanPostProcessor;
import org.as2lib.bean.factory.config.ConfigurableListableBeanFactory;
import org.as2lib.bean.factory.config.ConstructorArgumentValue;
import org.as2lib.bean.factory.config.ConstructorArgumentValues;
import org.as2lib.bean.factory.config.DestructionAwareBeanPostProcessor;
import org.as2lib.bean.factory.config.InstantiationAwareBeanPostProcessor;
import org.as2lib.bean.factory.config.RuntimeBeanReference;
import org.as2lib.bean.factory.DisposableBean;
import org.as2lib.bean.factory.FactoryBean;
import org.as2lib.bean.factory.FactoryBeanNotInitializedException;
import org.as2lib.bean.factory.InitializingBean;
import org.as2lib.bean.factory.ListableBeanFactory;
import org.as2lib.bean.factory.NoSuchBeanDefinitionException;
import org.as2lib.bean.factory.support.AbstractBeanDefinition;
import org.as2lib.bean.factory.support.AbstractBeanFactory;
import org.as2lib.bean.factory.support.BeanDefinitionRegistry;
import org.as2lib.bean.factory.support.ChildBeanDefinition;
import org.as2lib.bean.factory.support.LookupOverride;
import org.as2lib.bean.factory.support.ManagedArray;
import org.as2lib.bean.factory.support.ManagedList;
import org.as2lib.bean.factory.support.ManagedMap;
import org.as2lib.bean.factory.support.MethodOverride;
import org.as2lib.bean.factory.support.MethodReplacer;
import org.as2lib.bean.factory.support.ReplaceOverride;
import org.as2lib.bean.factory.support.RootBeanDefinition;
import org.as2lib.bean.PropertyAccess;
import org.as2lib.bean.PropertyValue;
import org.as2lib.bean.PropertyValueConverter;
import org.as2lib.bean.PropertyValues;
import org.as2lib.bean.SimpleBeanWrapper;
import org.as2lib.data.holder.List;
import org.as2lib.data.holder.Map;
import org.as2lib.data.holder.map.HashMap;
import org.as2lib.data.holder.map.PrimitiveTypeMap;
import org.as2lib.env.reflect.NoSuchMethodException;
import org.as2lib.env.reflect.ReflectUtil;
import org.as2lib.util.ClassUtil;
import org.as2lib.util.MethodUtil;

/**
 * {@code DefaultBeanFactory} is the default implementation of the various bean
 * factory interfaces: a full-fledged bean factory based on bean definitions.
 *
 * <p>Typical usage is registering all bean definitions first (possibly read
 * from a bean definition file), before accessing beans. Bean definition lookup
 * is therefore an inexpensive operation in a local bean definition table.
 *
 * <p>Can be used as a standalone bean factory, or as a superclass for custom
 * bean factories. Note that readers for specific bean definition formats are
 * typically implemented separately rather than as bean factory subclasses.
 *
 * @author Simon Wacker
 */
class org.as2lib.bean.factory.support.DefaultBeanFactory extends AbstractBeanFactory implements
		ConfigurableListableBeanFactory, BeanDefinitionRegistry {

	//---------------------------------------------------------------------
	// Instance data
	//---------------------------------------------------------------------

	/** The parent of this bean factory. */
	private var parentBeanFactory:BeanFactory;

	/** The added bean definitions. */
	private var beanDefinitionMap:Map;

	/** The cached singletons. */
	private var singletonCache:Map;

	/** The alias of beans. */
	private var aliasMap:Map;

	/** All added bean post processors. */
	private var beanPostProcessors:Array;

	/** Whether there are any destruction aware bean post processors. */
	private var hasDestructionAwareBeanPostProcessors:Boolean;

	/** Whether to allow bean definition overriding. */
	private var allowBeanDefinitionOverriding:Boolean;

	/** Disposable bean instances: bean name --> disposable instance */
	private var disposableBeans:Map;

	/** Map between dependent bean names: bean name --> dependent bean name */
	private var dependentBeanMap:Map;

	/** Whether to automatically try to resolve circular references between beans */
	private var allowCircularReferences:Boolean;

	/** Property value converters to add to bean wrappers before setting property values. */
	private var propertyValueConverters:Map;

	/** Names of beans that are currently in creation */
	private var currentlyInCreation:Array;

	/** The bean wrapper used by this factory to resolve constructor arguments. */
	private var beanWrapper:SimpleBeanWrapper;

	//---------------------------------------------------------------------
	// Constructors
	//---------------------------------------------------------------------

	/**
	 * Constructs a new {@code DefaultBeanFactory} instance.
	 *
	 * @param parentBeanFactory the parent of this bean factory
	 */
	public function DefaultBeanFactory(parentBeanFactory:BeanFactory) {
		this.parentBeanFactory = parentBeanFactory;
		beanDefinitionMap = new PrimitiveTypeMap();
		singletonCache = new PrimitiveTypeMap();
		aliasMap = new PrimitiveTypeMap();
		allowBeanDefinitionOverriding = true;
		disposableBeans = new PrimitiveTypeMap();
		dependentBeanMap = new PrimitiveTypeMap();
		propertyValueConverters = new HashMap();
		beanPostProcessors = new Array();
		currentlyInCreation = new Array();
		allowCircularReferences = true;
		beanWrapper = new SimpleBeanWrapper();
	}

	//---------------------------------------------------------------------
	// Implementation of AutowireCapableBeanFactory interface
	//---------------------------------------------------------------------

	/*public function autowire(beanClass, autowireMode:Number, dependencyCheck:Boolean) {
		// Use non-singleton bean definition, to avoid registering bean as dependent bean.
		var bd:RootBeanDefinition = new RootBeanDefinition(beanClass, autowireMode, dependencyCheck);
		bd.setSingleton(false);
		var beanName:String = ReflectUtil.getTypeNameForType(beanClass);
		var bean = instantiateBean(beanName, bd);
		populateBean(beanName, bean, bd);
		return bean;
	}

	public function autowireBeanProperties(existingBean, autowireMode:Number, dependencyCheck:Boolean) {
		// Use non-singleton bean definition, to avoid registering bean as dependent bean.
		var beanClassName:String = ReflectUtil.getTypeNameForInstance(existingBean);
		var bd:RootBeanDefinition = new RootBeanDefinition(eval("_global." + beanClassName), autowireMode, dependencyCheck);
		bd.setSingleton(false);
		populateBean(beanClassName, existingBean, bd);
	}*/

	//---------------------------------------------------------------------
	// Implementation methods
	//---------------------------------------------------------------------

	/**
	 * Sets whether it should be allowed to override bean definitions by registering
	 * a different definition with the same name, automatically replacing the former.
	 * If not, an exception will be thrown. Default is {@code true}.
	 *
	 * @param allowBeanDefinitionOverriding whether to allow bean definition overriding
	 */
	public function setAllowBeanDefinitionOverriding(allowBeanDefinitionOverriding:Boolean):Void {
		this.allowBeanDefinitionOverriding = allowBeanDefinitionOverriding;
	}

	/**
	 * Returns whether it should be allowed to override bean definitions by registering
	 * a different definition with the same name, automatically replacing the former.
	 *
	 * @return whether bean definition overriding is allowed
	 */
	public function isAllowBeanDefinitionOverriding(Void):Boolean {
		return allowBeanDefinitionOverriding;
	}

	/**
	 * Sets whether to allow circular references between beans - and automatically
	 * try to resolve them.
	 *
	 * <p>Note that circular reference resolution means that one of the involved beans
	 * will receive a reference to another bean that is not fully initialized yet.
	 * This can lead to subtle and not-so-subtle side effects on initialization;
	 * it does work fine for many scenarios, though.
	 *
	 * <p>Default is {@code true}. Turn this off to throw an exception when encountering
	 * a circular reference, disallowing them completely.
	 *
	 * @param allowCircularReferences whether to allow circular references
	 */
	public function setAllowCircularReferences(allowCircularReferences:Boolean):Void {
		this.allowCircularReferences = allowCircularReferences;
	}

	/**
	 * Returns whether to allow circular references between beans - and automatically
	 * try to resolve them.
	 *
	 * @param returns whether circular references are allowed
	 */
	public function isAllowCircularReferences(Void):Boolean {
		return allowCircularReferences;
	}

	public function applyBeanPropertyValues(existingBean, beanName:String):Void {
		var bd:RootBeanDefinition = getMergedBeanDefinition(beanName, true);
		applyPropertyValues(beanName, existingBean, bd, bd.getPropertyValues());
	}

	/**
	 * Initializes the given bean wrapper with the property value converters registered
	 * with this factory.
	 *
	 * @param beanWrapper the BeanWrapper to initialize
	 */
	private function initBeanWrapper(beanWrapper:BeanWrapper):Void {
		var classes:Array = propertyValueConverters.getKeys();
		var converters:Array = propertyValueConverters.getValues();
		for (var i:Number = 0; i < classes.length; i++) {
			beanWrapper.registerPropertyValueConverterForType(classes[i], converters[i]);
		}
	}

	/**
	 * Gets the object for the given shared bean, either the bean instance itself or
	 * its created object in case of a factory bean.
	 *
	 * @param name the name that may include factory dereference prefix
	 * @param bean the shared bean instance
	 * @param property the property to pass-to the factory bean's {@code getObject}
	 * method if the given name corresponds to a factory bean and is not a dereference
	 * @return the singleton instance of the bean
	 * @see FactoryBean#getObject
	 */
	private function getBeanForSingleton(name:String, bean, property:PropertyAccess) {
		var beanName:String = transformBeanName(name);
		var factoryBean:FactoryBean = FactoryBean(bean);
		var isFactoryDereference:Boolean = isFactoryDereference(name);
		if (isFactoryDereference && factoryBean == null) {
			throw new BeanIsNotAFactoryException(beanName, bean.__constructor__, this, arguments);
		}
		if (factoryBean != null) {
			if (!isFactoryDereference) {
				try {
					bean = factoryBean.getObject(property);
				}
				catch (exception) {
					throw (new BeanCreationException(beanName, "Factory bean threw exception on " +
							"object creation.", this, arguments)).initCause(exception);
				}
				if (bean == null) {
					throw new FactoryBeanNotInitializedException(beanName, "Factory bean " +
							"returned 'null' object: probably not fully initialized (maybe due " +
							"to circular bean reference).", this, arguments);
				}
			}
		}
		return bean;
	}

	/**
	 * Returns whether the given name is a factory dereference (beginning with the
	 * factory dereference prefix).
	 *
	 * @param name the name to check whether it is a factory dereference
	 * @return {@code true} if the given name is a factory dereference else {@code false}
	 * @see AbstractBeanFactory#FACTORY_BEAN_PREFIX
	 */
	private function isFactoryDereference(name:String):Boolean {
		return (name.indexOf(FACTORY_BEAN_PREFIX) == 0);
	}

	/**
	 * Returns the bean name, stripping out the factory dereference prefix if necessary,
	 * and resolving aliases to canonical names.
	 *
	 * @param name the name to transform
	 * @return the bean name
	 */
	private function transformBeanName(name:String):String {
		var beanName:String = name;
		if (name.indexOf(FACTORY_BEAN_PREFIX) == 0) {
			beanName = name.substring(FACTORY_BEAN_PREFIX.length);
		}
		if (aliasMap.containsKey(beanName)) {
			beanName = aliasMap.get(beanName);
		}
		return beanName;
	}

	private function createBean(beanName:String, mergedBeanDefinition:RootBeanDefinition, property:PropertyAccess) {
		var result;
		if (mergedBeanDefinition.hasBeanClass()) {
			result = applyBeanPostProcessorsBeforeInstantiation(mergedBeanDefinition.getBeanClass(), beanName);
			if (result != null) {
				return result;
			}
		}
		if (mergedBeanDefinition.getDependsOn() != null) {
			var dependsOn:Array = mergedBeanDefinition.getDependsOn();
			for (var i:Number = 0; i < dependsOn.length; i++) {
				getBeanByName(dependsOn[i]);
			}
		}
		var originalBean;
		var errorMessage:String;
		try {
			errorMessage = "Instantiation of bean failed.";
			if (mergedBeanDefinition.isInstantiateWithProperty()) {
				result = instantiateBeanUsingProperty(beanName, property, mergedBeanDefinition);
			}
			else if (mergedBeanDefinition.getFactoryMethodName() != null) {
				result = instantiateBeanUsingFactoryMethod(beanName, mergedBeanDefinition);
			}
			else if (mergedBeanDefinition.isStatic()) {
				result = instantiateStaticBean(beanName, mergedBeanDefinition);
			}
			else {
				result = instantiateBean(beanName, mergedBeanDefinition);
			}
			// Eagerly cache singletons to be able to resolve circular references
			// even when triggered by lifecycle interfaces like BeanFactoryAware.
			if (allowCircularReferences) {
				if (isSingletonCurrentlyInCreation(beanName)) {
					addSingleton(beanName, result);
				}
			}
			errorMessage = "Initialization of bean failed.";
			// Set the bean as property value now if it shall be populated after it was set.
			if (property != null) {
				if (mergedBeanDefinition.getPopulateMode() == AbstractBeanDefinition.POPULATE_AFTER) {
					property.setValue(result);
				}
			}
			// Give any InstantiationAwareBeanPostProcessors the opportunity to modify the state
			// of the bean before properties are set. This can be used, for example,
			// to support styles of field injection.
			var continueWithPropertyPopulation:Boolean = true;
			for (var i:Number = 0; i < beanPostProcessors.length; i++) {
				var beanProcessor:InstantiationAwareBeanPostProcessor =
						InstantiationAwareBeanPostProcessor(beanPostProcessors[i]);
				if (beanProcessor != null) {
					if (!beanProcessor.postProcessAfterInstantiation(result, beanName)) {
						continueWithPropertyPopulation = false;
						break;
					}
				}
			}
			if (continueWithPropertyPopulation) {
				populateBean(beanName, result, mergedBeanDefinition);
			}
			originalBean = result;
			result = initializeBean(beanName, result, mergedBeanDefinition);
		}
		catch (exception:org.as2lib.bean.factory.BeanCreationException) {
			throw exception;
		}
		catch (exception) {
			throw (new BeanCreationException(beanName, errorMessage, this, arguments)).initCause(exception);
		}
		registerDisposableBeanIfNecessary(beanName, originalBean, mergedBeanDefinition);
		return result;
	}

	/**
	 * Applies {@link InstantiationAwareBeanPostProcessor} instances to the given
	 * existing bean instance, invoking their {@code postProcessBeforeInstantiation}
	 * methods. The returned bean instance may be a wrapper around the original.
	 *
	 * <p>Any returned object will be used as the bean instead of actually instantiating
	 * the target bean. A {@code null} return value from the post-processor will result
	 * in the target bean being instantiated.
	 *
	 * @param beanClass the class of the bean to instantiate
	 * @param beanName the name of the bean
	 * @return the bean instance to use instead of a default instance of the target bean
	 * @throws BeanException if any post-processing failed
	 * @see InstantiationAwareBeanPostProcessor#postProcessBeforeInstantiation
	 */
	private function applyBeanPostProcessorsBeforeInstantiation(beanClass:Function, beanName:String) {
		for (var i:Number = 0; i < beanPostProcessors.length; i++) {
			var beanProcessor:InstantiationAwareBeanPostProcessor =
					InstantiationAwareBeanPostProcessor(beanPostProcessors[i]);
			if (beanProcessor != null) {
				var result = beanProcessor.postProcessBeforeInstantiation(beanClass, beanName);
				if (result != null) {
					return result;
				}
			}
		}
		return null;
	}

	/**
	 * Instantiates the bean defined by the given bean definition.
	 *
	 * @param beanName the name of the bean to instantiate
	 * @param mergedBeanDefinition the merged bean definition of the bean to instantiate
	 * @return the instantiated bean
	 */
	private function instantiateBean(beanName:String, mergedBeanDefinition:RootBeanDefinition) {
		var bean = new Object();
		var beanClass:Function = mergedBeanDefinition.getBeanClass();
		bean.__proto__ = beanClass.prototype;
		bean.__constructor__ = beanClass;
		var constructorArguments:Array = resolveConstructorArguments(mergedBeanDefinition.getConstructorArgumentValues());
		try {
			beanClass.apply(bean, constructorArguments);
		}
		catch (exception) {
			throw (new BeanDefinitionStoreException(beanName, "Could not instantiate class [" +
					ReflectUtil.getTypeNameForType(beanClass) + "]: Constructor threw an exception.",
					this, arguments)).initCause(exception);
		}
		applyMethodOverrides(beanName, bean, mergedBeanDefinition);
		return bean;
	}

	/**
	 * Instantiates the static bean defined by the given bean definition (simply returns
	 * the bean class).
	 *
	 * @param beanName the name of the bean to instantiate
	 * @param mergedBeanDefinition the merged bean definition of the bean to instantiate
	 * @return the bean class
	 */
	private function instantiateStaticBean(beanName:String, mergedBeanDefinition:RootBeanDefinition) {
		return mergedBeanDefinition.getBeanClass();
	}

	/**
	 * Instantiates the bean defined by the given bean definition with a factory
	 * method.
	 *
	 * @param beanName the name of the bean to instantiate
	 * @param mergedBeanDefinition the merged bean definition of the bean to instantiate
	 * @return the instantiated bean
	 */
	private function instantiateBeanUsingFactoryMethod(beanName:String, mergedBeanDefinition:RootBeanDefinition) {
		var factory;
		var isStatic:Boolean;
		if (mergedBeanDefinition.getFactoryBeanName() != null) {
			factory = getBeanByName(mergedBeanDefinition.getFactoryBeanName());
			isStatic = false;
		}
		else {
			factory = mergedBeanDefinition.getBeanClass();
			isStatic = true;
		}
		var factoryMethodName:String = mergedBeanDefinition.getFactoryMethodName();
		if (factory[factoryMethodName] == null) {
			throw new BeanDefinitionStoreException(beanName, "Factory method with name '" +
					factoryMethodName + "' does not exist on factory " + isStatic ? "class [" +
					ReflectUtil.getTypeNameForType(factory) : "bean named '" +
					mergedBeanDefinition.getFactoryBeanName(), this, arguments);
		}
		var bean;
		var args:Array = resolveConstructorArguments(mergedBeanDefinition.getConstructorArgumentValues());
		try {
			if (isStatic) {
				bean = factory[factoryMethodName].apply(factory, args);
			}
			else {
				bean = MethodUtil.invoke(factoryMethodName, factory, args);
			}
		}
		catch (exception) {
			throw (new BeanDefinitionStoreException(beanName, "Factory method [" +
					factoryMethodName + "] threw an exception",
					this, arguments)).initCause(exception);
		}
		if (bean == null) {
			throw new BeanCreationException(beanName, "Factory method '" +
					mergedBeanDefinition.getFactoryMethodName() + "' on class [" +
					ReflectUtil.getTypeName(factory) + "] returned 'null'.", this, arguments);
		}
		applyMethodOverrides(beanName, bean, mergedBeanDefinition);
		return bean;
	}

	/**
	 * Resolves the given constructor argument values.
	 *
	 * @param constructorArgumentValues the constructor argument values to resolve
	 */
	private function resolveConstructorArguments(constructorArgumentValues:ConstructorArgumentValues):Array {
		var result:Array = new Array();
		var avs:Array = constructorArgumentValues.getArgumentValues();
		for (var i:Number = 0; i < avs.length; i++) {
			var argument:ConstructorArgumentValue = avs[i];
			var value = resolveValue("constructor argument with index " + i, argument.getValue());
			value = beanWrapper.convertPropertyValue("constructor-arg", value, argument.getType());
			result.push(value);
		}
		return result;
	}

	/**
	 * Instantiates the bean with the given 'factory' property.
	 *
	 * @param beanName the name of the bean to instantiate
	 * @param property the 'factory' property whose get-method instantiates the bean
	 * @param mergedBeanDefinition the merged bean definition of the bean to instantiate
	 * @return the instantiated bean
	 */
	private function instantiateBeanUsingProperty(beanName:String, property:PropertyAccess, mergedBeanDefinition:RootBeanDefinition) {
		var bean;
		try {
			bean = property.getValue();
		}
		catch (exception) {
			throw (new BeanDefinitionStoreException(beanName, "Get access to property '" +
					property.getName() + "' on bean of type [" +
					ReflectUtil.getTypeNameForInstance(property.getBean()) +
					"] threw an exception", this, arguments)).initCause(exception);
		}
		if (bean == null) {
			throw new BeanCreationException(beanName, "Get access to property '" +
					property.getName() + "' on bean of type [" +
					ReflectUtil.getTypeNameForInstance(property.getBean()) + "] returned 'null'.",
					this, arguments);
		}
		applyMethodOverrides(beanName, bean, mergedBeanDefinition);
		return bean;
	}

	/**
	 * Applies the method overrides of the given bean definition to the given bean.
	 *
	 * @param beanName the name of the bean
	 * @param bean the bean to apply method overrides to
	 * @param mergedBeanDefinition the bean definition of the bean
	 */
	private function applyMethodOverrides(beanName:String, bean, mergedBeanDefinition:RootBeanDefinition):Void {
		var overrides:Array = mergedBeanDefinition.getMethodOverrides().getOverrides();
		for (var i:Number = 0; i < overrides.length; i++) {
			var override:MethodOverride = overrides[i];
			var methodName:String = override.getMethodName();
			if (bean[methodName] === undefined) {
				throw new BeanDefinitionStoreException(beanName, "Invalid method override: no " +
						"method with name '" + methodName + "' exists on bean [" + bean + "] " +
						"with bean definition [" + mergedBeanDefinition + "].", this, arguments);
			}
			bean[methodName] = override.getProxy(this);
		}
	}

	/**
	 * Populates the given bean instance with the property values from the bean
	 * definition.
	 *
	 * @param beanName the name of the bean
	 * @param bean the bean instance to populate
	 * @param mergedBeanDefinition the bean definition for the bean
	 */
	private function populateBean(beanName:String, bean, mergedBeanDefinition:RootBeanDefinition):Void {
		var propertyValues:PropertyValues = mergedBeanDefinition.getPropertyValues();
		/*if (mergedBeanDefinition.getAutowireMode() == RootBeanDefinition.AUTOWIRE_BY_NAME) {
			var pvs:PropertyValues = new PropertyValues(propertyValues);
			// Add property values based on autowire by name if applicable.
			autowireByName(beanName, bean, mergedBeanDefinition, pvs);
			propertyValues = pvs;
		}*/
		//checkDependencies(beanName, mergedBeanDefinition, bw, pvs);
		applyPropertyValues(beanName, bean, mergedBeanDefinition, propertyValues);
	}

	/**
	 * Fills in any missing property values with references to other beans in this
	 * factory if autowire is set to "byName".
	 *
	 * @param beanName the name of the bean we are wiring up
	 * @param bean the bean to wire up
	 * @param mergedBeanDefinition the bean definition to update through autowiring
	 * @param propertyValues the property values to register wired objects with
	 */
	/*private function autowireByName(beanName:String, bean, mergedBeanDefinition:RootBeanDefinition, propertyValues:PropertyValues):Void {
		var propertyNames:Array = getBeanNames(true);
		var beanWrapper:BeanWrapper = new SimpleBeanWrapper(bean);
		initBeanWrapper(beanWrapper);
		for (var i:Number = 0; i < propertyNames.length; i++) {
			var propertyName:String = propertyNames[i];
			if (!propertyValues.contains(propertyName)) {
				if (beanWrapper.isWritableProperty(propertyName)) {
					var propertyValue = getBean(propertyName);
					propertyValues.addPropertyValueByNameAndValueAndType(propertyName, propertyValue);
					if (mergedBeanDefinition.isSingleton()) {
						registerDependentBean(propertyName, beanName);
					}
				}
			}
		}
	}*/

	/**
	 * Applies the given property values, resolving any runtime references to other
	 * beans in this bean factory. Must use deep copy, so we do not permanently
	 * modify this property.
	 *
	 * @param beanName the bean name passed for better exception information
	 * @param bean the bean to apply property values to
	 * @param mergedBeanDefinition the merged bean definition of the bean
	 * @param propertyValues the new property values to apply
	 */
	private function applyPropertyValues(beanName:String, bean, mergedBeanDefinition:RootBeanDefinition, propertyValues:PropertyValues):Void {
		if (propertyValues == null || propertyValues.isEmpty()) {
			return;
		}
		var beanWrapper:BeanWrapper = new SimpleBeanWrapper(bean);
		initBeanWrapper(beanWrapper);
		var pvArray:Array = propertyValues.getPropertyValues();
		var defaultName:String = mergedBeanDefinition.getDefaultPropertyName();
		try {
			for (var i:Number = 0; i < pvArray.length; i++) {
				var pv:PropertyValue = pvArray[i];
				var name:String = pv.getName();
				if (name == null) {
					if (defaultName == null) {
						throw new BeanDefinitionStoreException(beanName, "Property value [" + pv +
								"] has no name although bean [" + mergedBeanDefinition +
								"] has no default property name: at least one of these must be " +
								"supplied.", this, arguments);
					}
					name = defaultName;
				}
				var value = pv.getValue();
				var pvc:PropertyValue = new PropertyValue(name, value, pv.getType(), pv.isEnforceAccess());
				var property:PropertyAccess = new PropertyAccess(beanWrapper, pvc);
				var resolvedValue = resolveValue(name, value, beanName, mergedBeanDefinition, property);
				// If 'value' is a bean definition or bean reference and the bean's populate mode
				// is 'populate after setting property', the property access has already been made
				// and must not be done here a second time.
				if (!property.wasSetAccessed()) {
					pvc.setValue(resolvedValue);
					beanWrapper.setPropertyValue(pvc);
				}
			}
		}
		catch (exception:org.as2lib.bean.BeanException) {
			// Improve the message by showing the context.
			throw (new BeanCreationException(beanName, "Error setting property value.",
					this, arguments)).initCause(exception);
		}
	}

	/**
	 * Resolves the given value. Bean definition holders, bean definitions, runtime
	 * bean references, managed arrays, managed lists and managed maps are resolved.
	 *
	 * @param valueName the name of the value to resolve
	 * @param value the value to resolve
	 * @param beanName the name of the bean the value is resolved for
	 * @param beanDefinition the bean definition of the bean
	 * @param property the property to set the value of if the given value is a
	 * bean definition of or a bean reference to a bean that needs to be set to a
	 * property before its property values are applied
	 * @see BeanDefinitionHolder
	 * @see BeanDefinition
	 * @see RuntimeBeanReference
	 * @see ManagedArray
	 * @see ManagedList
	 * @see ManagedMap
	 * @see BeanDefinition#getPopulateMode
	 * @see #getBean
	 * @see #createBean
	 */
	private function resolveValue(valueName:String, value, beanName:String,
			beanDefinition:BeanDefinition, property:PropertyAccess) {
		// We must check each value to see whether it requires a runtime reference
		// to another bean to be resolved.
		if (value instanceof BeanDefinitionHolder) {
			// Resolve BeanDefinitionHolder: contains BeanDefinition with name and aliases.
			var bdHolder:BeanDefinitionHolder = value;
			return resolveInnerBeanDefinition(bdHolder.getBeanName(), bdHolder.getBeanDefinition(),
					beanName, beanDefinition, property);
		}
		if (value instanceof BeanDefinition) {
			// Resolve plain BeanDefinition, without contained name: use dummy name.
			var bd:BeanDefinition = value;
			return resolveInnerBeanDefinition("(inner bean)", bd, beanName, beanDefinition, property);
		}
		if (value instanceof RuntimeBeanReference) {
			var ref:RuntimeBeanReference = value;
			return resolveReference(valueName, ref, beanName, beanDefinition, property);
		}
		if (value instanceof ManagedArray) {
			return resolveManagedArray(valueName, value);
		}
		if (value instanceof ManagedList) {
			// May need to resolve contained runtime references.
			return resolveManagedList(valueName, value);
		}
		if (value instanceof ManagedMap) {
			// May need to resolve contained runtime references.
			return resolveManagedMap(valueName, value);
		}
		// no need to resolve value
		return value;
	}

	/**
	 * Resolves an inner bean definition.
	 *
	 * @param innerBeanName the name of the inner bean
	 * @param innerBeanDefinition the inner bean definition to resolve
	 * @param beanName the name of the bean holding the inner bean definition
	 * @param beanDefinition the bean definition of the bean holding the inner bean
	 * definition
	 * @param property the property to set the value of if the given bean
	 * definition defines a bean that needs to be set to a property before its property
	 * values are applied
	 * @see #createBean
	 * @see BeanDefinition#getPopulateMode
	 */
	private function resolveInnerBeanDefinition(innerBeanName:String, innerBeanDefinition:BeanDefinition,
			beanName:String, beanDefinition:BeanDefinition, property:PropertyAccess) {
		var mergedInnerBeanDefinition:RootBeanDefinition = getMergedBeanDefinition(innerBeanName, false, innerBeanDefinition);
		var innerBean = createBean(innerBeanName, mergedInnerBeanDefinition, property);
		if (mergedInnerBeanDefinition.isSingleton()) {
			registerDependentBean(innerBeanName, beanName);
		}
		return getBeanForSingleton(innerBeanName, innerBean, property);
	}

	/**
	 * Resolves a reference to another bean in this factory.
	 *
	 * @param valueName the name of the value
	 * @param reference the reference to resolve
	 * @param beanName the name of the bean the reference is resolved for
	 * @param beanDefinition the bean definition of the bean
	 * @param property the property to set the value of if the given bean
	 * reference references a bean that needs to be set to a property before its
	 * property values are applied
	 * @see #getBeanByName
	 * @see BeanDefinition#getPopulateMode
	 */
	private function resolveReference(valueName:String, reference:RuntimeBeanReference,
			beanName:String, beanDefinition:BeanDefinition, property:PropertyAccess) {
		try {
			if (reference.isToParent()) {
				if (parentBeanFactory == null) {
					throw new BeanCreationException(
							beanName, "Can't resolve reference to bean '" + reference.getBeanName() +
							"' in parent factory: no parent factory available", this, arguments);
				}
				return parentBeanFactory.getBeanByName(reference.getBeanName(), property);
			}
			else {
				if (beanDefinition.isSingleton()) {
					registerDependentBean(reference.getBeanName(), beanName);
				}
				return getBeanByName(reference.getBeanName(), property);
			}
		}
		catch (exception:org.as2lib.bean.BeanException) {
			throw (new BeanCreationException(
					beanName, "Can't resolve reference to bean '" + reference.getBeanName() +
					"' while setting property '" + valueName + "'", this, arguments)).initCause(exception);
		}
	}

	/**
	 * Resolves values for each element in the managed array if necessary.
	 *
	 * @param valueName the name of the value
	 * @param managedList the managed array to resolve values for
	 */
	private function resolveManagedArray(valueName:String, managedArray:ManagedArray):Array {
		for (var i:Number = 0; i < managedArray.length; i++) {
			managedArray[i] = resolveValue(valueName + AbstractBeanWrapper.PROPERTY_KEY_PREFIX +
					i + AbstractBeanWrapper.PROPERTY_KEY_SUFFIX, managedArray[i]);
		}
		return managedArray;
	}

	/**
	 * Resolves values for each element in the managed list if necessary.
	 *
	 * @param valueName the name of the value
	 * @param managedList the managed list to resolve values for
	 */
	private function resolveManagedList(valueName:String, managedList:ManagedList):List {
		var values:Array = managedList.toArray();
		for (var i:Number = 0; i < values.length; i++) {
			values[i] = resolveValue(valueName + AbstractBeanWrapper.PROPERTY_KEY_PREFIX +
					i + AbstractBeanWrapper.PROPERTY_KEY_SUFFIX, values[i]);
		}
		return managedList;
	}

	/**
	 * Resolves values for each entry in the managed map if necessary.
	 *
	 * @param valueName the name of the value
	 * @param managedMap the managed map to resolve keys and values for
	 */
	private function resolveManagedMap(valueName:String, managedMap:ManagedMap):Map {
		var keys:Array = managedMap.getKeys();
		var values:Array = managedMap.getValues();
		for (var i:Number = 0; i < keys.length; i++) {
			keys[i] = resolveValue(valueName, keys[i]);
			values[i] = resolveValue(valueName + AbstractBeanWrapper.PROPERTY_KEY_PREFIX +
					keys[i] + AbstractBeanWrapper.PROPERTY_KEY_SUFFIX, values[i]);
		}
		return managedMap;
	}

	/**
	 * Initializes the given bean instance, applying factory callbacks as well as init
	 * methods and bean post processors.
	 *
	 * <p>Called from {@code createBean} for traditionally defined beans, and from
	 * {@code initializeBean} for existing bean instances.
	 *
	 * @param beanName the name of the bean in this factory
	 * @param bean the new bean instance we may need to initialize
	 * @param mergedBeanDefinition the bean definition that the bean was created with
	 * (can also be {@code null}, if given an existing bean instance)
	 * @see BeanNameAware
	 * @see BeanFactoryAware
	 * @see #applyBeanPostProcessorsBeforeInitialization
	 * @see #invokeInitMethods
	 * @see #applyBeanPostProcessorsAfterInitialization
	 * @see #createBean
	 * @see #initializeBean
	 */
	private function initializeBean(beanName:String, bean, mergedBeanDefinition:RootBeanDefinition) {
		var nameAwareBean:BeanNameAware = BeanNameAware(bean);
		if (nameAwareBean != null) {
			nameAwareBean.setBeanName(beanName);
		}
		var factoryAwareBean:BeanFactoryAware = BeanFactoryAware(bean);
		if (factoryAwareBean != null) {
			factoryAwareBean.setBeanFactory(this);
		}
		bean = applyBeanPostProcessorsBeforeInitialization(bean, beanName);
		try {
			invokeInitMethods(beanName, bean, mergedBeanDefinition);
		}
		catch (exception) {
			throw (new BeanCreationException(beanName, "Invocation of init method failed.",
					this, arguments)).initCause(exception);
		}
		bean = applyBeanPostProcessorsAfterInitialization(bean, beanName);
		return bean;
	}

	public function applyBeanPostProcessorsBeforeInitialization(existingBean, beanName:String) {
		var result = existingBean;
		for (var i:Number = 0; i < beanPostProcessors.length; i++) {
			var beanProcessor:BeanPostProcessor = beanPostProcessors[i];
			result = beanProcessor.postProcessBeforeInitialization(result, beanName);
			if (result == null) {
				throw new BeanCreationException(beanName,
						"postProcessBeforeInitialization method of BeanPostProcessor [" +
						beanProcessor + "] returned 'null' for bean [" + result + "] with name [" +
						beanName + "]", this, arguments);
			}
		}
		return result;
	}

	/**
	 * Gives a bean a chance to react now all its properties are set, and a chance to
	 * know about its owning bean factory (this object). This means checking whether
	 * the bean implements {@link InitializingBean} or defines a custom init method,
	 * and invoking the necessary callback(s) if it does.
	 *
	 * @param beanName the name of the bean in this factory
	 * @param bean the new bean instance we may need to initialize
	 * @param mergedBeanDefinition the bean definition that the bean was created with
	 * (can also be {@code null}, if given an existing bean instance)
	 * @throws Throwable if thrown by init methods or by the invocation process
	 * @see #invokeCustomInitMethod
	 */
	private function invokeInitMethods(beanName:String, bean, mergedBeanDefinition:RootBeanDefinition):Void {
		var initializingBean:InitializingBean = InitializingBean(bean);
		if (initializingBean != null) {
			initializingBean.afterPropertiesSet();
		}
		if (mergedBeanDefinition.getInitMethodName() != null) {
			invokeCustomInitMethod(beanName, bean, mergedBeanDefinition.getInitMethodName(), mergedBeanDefinition.isEnforceInitMethod());
		}
	}

	/**
	 * Invokes the specified custom init method on the given bean.
	 *
	 * <p>Can be overridden in subclasses for custom resolution of init methods with
	 * arguments.
	 *
	 * @param beanName the name of the bean in this factory
	 * @param bean the new bean instance we may need to initialize
	 * @param initMethodName the name of the custom init method
	 * @param enforceInitMethod indicates whether the defined init method needs to exist
	 */
	private function invokeCustomInitMethod(beanName:String, bean, initMethodName:String, enforceInitMethod:Boolean):Void {
		if (bean[initMethodName] == null) {
			if (enforceInitMethod) {
				throw new NoSuchMethodException("Couldn't find an init method named '" + initMethodName +
						"' on bean with name '" + beanName + "'", this, arguments);
			}
			else {
				// Ignore non-existent default lifecycle methods.
				return;
			}
		}
		bean[initMethodName]();
	}

	public function applyBeanPostProcessorsAfterInitialization(existingBean, beanName:String) {
		var result = existingBean;
		for (var i:Number = 0; i < beanPostProcessors.length; i++) {
			var beanProcessor:BeanPostProcessor = beanPostProcessors[i];
			result = beanProcessor.postProcessAfterInitialization(result, beanName);
			if (result == null) {
				throw new BeanCreationException(beanName,
						"postProcessAfterInitialization method of BeanPostProcessor [" +
						beanProcessor + "] returned 'null' for bean [" + result + "] with name [" +
						beanName + "]", this, arguments);
			}
		}
		return result;
	}

	/**
	 * Destroys the given bean. Delegates to {@link #destroyBean} if a corresponding
	 * disposable bean instance is found.
	 *
	 * @param beanName the name of the bean
	 */
	private function destroyDisposableBean(beanName:String):Void {
		singletonCache.remove(beanName);
		var disposableBean = disposableBeans.remove(beanName);
		destroyBean(beanName, disposableBean);
	}

	/**
	 * Destroys the given bean. Must destroy beans that depend on the given bean
	 * before the bean itself. Should not throw any exceptions.
	 *
	 * @param beanName the name of the bean
	 * @param bean the bean instance to destroy
	 */
	private function destroyBean(beanName:String, bean) {
		var dependencies:Array = dependentBeanMap.remove(beanName);
		if (dependencies != null) {
			for (var i:Number = 0; i < dependencies.length; i++) {
				var dependentBeanName:String = dependencies[i];
				destroyDisposableBean(dependentBeanName);
			}
		}
		var disposableBean:DisposableBean = DisposableBean(bean);
		if (disposableBean != null) {
			try {
				disposableBean.destroy();
			}
			catch (exception) {
				// logger.error("Destroy method on bean with name '" + beanName + "' threw an exception", ex);
			}
		}
	}

	/**
	 * Returns a root bean definition, even by traversing parent if the parameter is a
	 * child definition. Can ask the parent bean factory if not found in this instance.
	 *
	 * @param beanName the name of the bean definition
	 * @param includingAncestors whether to ask the parent bean factory if not found
	 * in this instance
	 * @return a (potentially merged) root bean definition for the given bean
	 * @throws NoSuchBeanDefinitionException if there is no bean with the given name
	 * @throws BeanDefinitionStoreException in case of an invalid bean definition
	 */
	private function getMergedBeanDefinition(beanName:String, includingAncestors:Boolean, beanDefinition:BeanDefinition):RootBeanDefinition {
		if (beanDefinition == null) {
			beanName = transformBeanName(beanName);
			if (includingAncestors) {
				if (!containsBeanDefinition(beanName)) {
					var pbf:DefaultBeanFactory = DefaultBeanFactory(parentBeanFactory);
					if (pbf != null) {
						return pbf.getMergedBeanDefinition(beanName, true);
					}
				}
			}
			beanDefinition = getBeanDefinition(beanName);
		}
		var rbd:RootBeanDefinition = RootBeanDefinition(beanDefinition);
		if (rbd != null) {
			return rbd;
		}
		var cbd:ChildBeanDefinition = ChildBeanDefinition(beanDefinition);
		if (cbd != null) {
			var pbd:RootBeanDefinition = null;
			try {
				if (beanName != cbd.getParentName()) {
					pbd = getMergedBeanDefinition(cbd.getParentName(), true);
				}
				else {
					var pbf:DefaultBeanFactory = DefaultBeanFactory(parentBeanFactory);
					if (pbf != null) {
						pbd = pbf.getMergedBeanDefinition(cbd.getParentName(), true);
					}
					else {
						throw new NoSuchBeanDefinitionException(cbd.getParentName(),
								"Parent name '" + cbd.getParentName() + "' is equal to bean name '" +
								beanName + "': cannot be resolved without a default bean factory parent.",
								this, arguments);
					}
				}
			}
			catch (exception:org.as2lib.bean.factory.NoSuchBeanDefinitionException) {
				throw (new BeanDefinitionStoreException(beanName, "Could not resolve parent bean " +
						"definition '" + cbd.getParentName() + "'.", this, arguments)).initCause(exception);
			}
			rbd = pbd.clone();
			rbd.override(cbd);
			try {
				rbd.validate();
			}
			catch (exception:org.as2lib.bean.factory.support.BeanDefinitionValidationException) {
				throw (new BeanDefinitionStoreException(beanName, "Validation of bean definition failed.",
						this, arguments)).initCause(exception);
			}
			return rbd;
		}
		throw new BeanDefinitionStoreException(beanName, "Definition is neither a root bean " +
				"definition nor a child bean definition.", this, arguments);
	}

	/**
	 * Adds the given bean to the list of disposable beans in this factory, registering
	 * its disposable bean and/or the given destroy method to be called on factory
	 * shutdown (if applicable). Only applies to singletons.
	 *
	 * <p>Also registers bean as dependent on other beans, according to the "depends-on"
	 * configuration in the bean definition.
	 *
	 * @param beanName the name of the bean
	 * @param bean the bean instance
	 * @param mergedBeanDefinition the bean definition for the bean
	 * @see RootBeanDefinition#isSingleton
	 * @see RootBeanDefinition#getDependsOn
	 * @see #registerDisposableBean
	 * @see #registerDependentBean
	 */
	private function registerDisposableBeanIfNecessary(beanName:String, bean, mergedBeanDefinition:RootBeanDefinition):Void {
		if (mergedBeanDefinition.isSingleton()) {
			var isDisposableBean:Boolean = (bean instanceof DisposableBean);
			var hasDestroyMethod:Boolean = (mergedBeanDefinition.getDestroyMethodName() != null);
			if (isDisposableBean || hasDestroyMethod || hasDestructionAwareBeanPostProcessors) {
				// Determine unique key for registration of disposable bean
				var counter:Number = 1;
				var id:String = beanName;
				while (disposableBeans.containsKey(id)) {
					counter++;
					id = beanName + "#" + counter;
				}
				// Register a DisposableBean implementation that performs all destruction
				// work for the given bean: DestructionAwareBeanPostProcessors,
				// DisposableBean interface, custom destroy method.
				var db:DisposableBean = ClassUtil.createCleanInstance(DisposableBean);
				db.destroy = function(Void):Void {
					if (this.hasDestructionAwareBeanPostProcessors) {
						for (var i:Number = this.beanPostProcessors.length - 1; i >= 0; i--) {
							var beanProcessor:DestructionAwareBeanPostProcessor =
									DestructionAwareBeanPostProcessor(this.beanPostProcessors[i]);
							if (beanProcessor != null) {
								beanProcessor.postProcessBeforeDestruction(this.bean, this.beanName);
							}
						}
					}
					if (this.isDisposableBean) {
						DisposableBean(this.bean).destroy();
					}
					if (this.hasDestroyMethod) {
						var bd:RootBeanDefinition = this.mergedBeanDefinition;
						var destroyMethodName = bd.getDestroyMethodName();
						if (this.bean[destroyMethodName] == null) {
							if (bd.isEnforceDestroyMethod()) {
								/*logger.error("Couldn't find a destroy method named '" + destroyMethodName +
										"' on bean with name '" + beanName + "'");*/
							}
						}
						else {
							try {
								this.bean[destroyMethodName]();
							}
							catch (exception) {
								/*logger.error("Couldn't invoke destroy method '" + destroyMethodName +
										"' of bean with name '" + beanName + "'", ex);*/
							}
						}
					}
				};
				db["bean"] = bean;
				db["beanName"] = beanName;
				db["isDisposableBean"] = isDisposableBean;
				db["hasDestroyMethod"] = hasDestroyMethod;
				db["mergedBeanDefinition"] = mergedBeanDefinition;
				db["hasDestructionAwareBeanPostProcessors"] = hasDestructionAwareBeanPostProcessors;
				db["beanPostProcessors"] = beanPostProcessors;
				disposableBeans.put(id, db);
			}
			// Register bean as dependent on other beans, if necessary,
			// for correct shutdown order.
			var dependsOn:Array = mergedBeanDefinition.getDependsOn();
			if (dependsOn != null) {
				for (var i:Number = 0; i < dependsOn.length; i++) {
					registerDependentBean(dependsOn[i], beanName);
				}
			}
		}
	}

	/**
	 * Registers a dependent bean for the given bean, to be destroyed before the
	 * given bean is destroyed.
	 *
	 * @param beanName the name of the bean
	 * @param dependentBeanName the name of the dependent bean
	 */
	private function registerDependentBean(beanName:String, dependentBeanName:String):Void {
		var dependencies:Array = dependentBeanMap.get(beanName);
		if (dependencies == null) {
			dependencies = new Array();
			dependentBeanMap.put(beanName, dependencies);
		}
		dependencies.push(dependentBeanName);
	}

	//---------------------------------------------------------------------
	// Implementation of BeanFactory interface
	//---------------------------------------------------------------------

	public function containsBean(name:String):Boolean {
		var beanName:String = transformBeanName(name);
		if (singletonCache.containsKey(beanName)) {
			return true;
		}
		if (beanDefinitionMap.containsKey(beanName)) {
			return true;
		}
		if (parentBeanFactory != null) {
			return parentBeanFactory.containsBean(name);
		}
		return false;
	}

	public function getBeanByName(name:String, property:PropertyAccess) {
		var beanName:String = transformBeanName(name);
		if (singletonCache.containsKey(beanName)) {
			var singleton = singletonCache.get(beanName);
			if (isSingletonCurrentlyInCreation(beanName)) {
				/*if (logger.isDebugEnabled()) {
					logger.debug("Returning eagerly cached instance of singleton bean '" + beanName +
							"' that is not fully initialized yet - a consequence of a circular reference");
				}*/
			}
			else {
				/*if (logger.isDebugEnabled()) {
					logger.debug("Returning cached instance of singleton bean '" + beanName + "'");
				}*/
			}
			return getBeanForSingleton(name, singleton, property);
		}
		// Fail if we're already creating this singleton instance:
		// We're assumably within a circular reference.
		if (isSingletonCurrentlyInCreation(beanName)) {
			throw new BeanCurrentlyInCreationException(beanName, null, this, arguments);
		}
		// Check if bean definition exists in this factory.
		if (parentBeanFactory != null && !containsBeanDefinition(beanName)) {
			// Not found -> check parent.
			return parentBeanFactory.getBeanByName(name);
		}
		var beanDefinition:RootBeanDefinition = getMergedBeanDefinition(beanName, false);
		if (beanDefinition.isSingleton()) {
			currentlyInCreation[beanName] = true;
			var bean;
			try {
				bean = createBean(beanName, beanDefinition, property);
				singletonCache.put(beanName, bean);
			}
			catch (exception:org.as2lib.bean.BeanException) {
				// Explicitly remove instance from singleton cache:
				// It might have been put there eagerly by the creation process,
				// to allow for circular reference resolution.
				destroyDisposableBean(beanName);
				throw exception;
			}
			finally {
				delete currentlyInCreation[beanName];
			}
			return getBeanForSingleton(name, bean, property);
		}
		return createBean(beanName, beanDefinition, property);
	}

	public function getBeanByNameAndType(name:String, requiredType:Function, property:PropertyAccess) {
		var bean = getBeanByName(name, property);
		if (requiredType != null) {
			if (!(bean instanceof requiredType)) {
				throw new BeanNotOfRequiredTypeException(name, requiredType, bean.__constructor__, this, arguments);
			}
		}
		return bean;
	}

	public function getAliases(name:String):Array {
		var beanName:String = transformBeanName(name);
		if (containsSingleton(beanName) || containsBeanDefinition(beanName)) {
			var aliases:Array = new Array();
			var keys:Array = aliasMap.getKeys();
			var values:Array = aliasMap.getValues();
			for (var i:Number = 0; i < keys.length; i++) {
				if (values[i] == beanName) {
					aliases.push(keys[i]);
				}
			}
			return aliases;
		}
		if (parentBeanFactory != null) {
			return parentBeanFactory.getAliases(name);
		}
		throw new NoSuchBeanDefinitionException(beanName, toString(), this, arguments);
	}

	public function isSingleton(name:String):Boolean {
		var beanName:String = transformBeanName(name);
		var singleton:Boolean = true;
		var bean = singletonCache.get(beanName);
		if (bean != null) {
			if (bean instanceof FactoryBean && !isFactoryDereference(name)) {
				var factoryBean:FactoryBean = getBeanByName(FACTORY_BEAN_PREFIX + beanName);
				return factoryBean.isSingleton();
			}
			singleton = true;
		}
		else {
			// No singleton instance found -> check bean definition.
			if (parentBeanFactory != null && !containsBeanDefinition(beanName)) {
				// No bean definition found in this factory -> delegate to parent.
				return parentBeanFactory.isSingleton(name);
			}
			var bd:RootBeanDefinition = getMergedBeanDefinition(beanName, false);
			if (bd.hasBeanClass()) {
				if (ClassUtil.isImplementationOf(bd.getBeanClass(), FactoryBean) && !isFactoryDereference(name)) {
					var factoryBean:FactoryBean = FactoryBean(getBeanByName(FACTORY_BEAN_PREFIX + beanName));
					return factoryBean.isSingleton();
				}
			}
			singleton = bd.isSingleton();
		}
		return singleton;
	}

	public function getType(name:String):Function {
		var beanName:String = transformBeanName(name);
		try {
			var beanClass:Function = null;
			var bean = null;
			bean = singletonCache.get(beanName);
			if (bean != null) {
				beanClass = eval("_global." + ReflectUtil.getTypeName(bean));
			}
			else {
				// No singleton instance found -> check bean definition.
				if (parentBeanFactory != null && !containsBeanDefinition(beanName)) {
					// No bean definition found in this factory -> delegate to parent.
					return parentBeanFactory.getType(name);
				}
				var mergedBeanDefinition:RootBeanDefinition = getMergedBeanDefinition(beanName, false);
				if (mergedBeanDefinition.getFactoryMethodName() != null) {
					return getTypeForFactoryMethod(name, mergedBeanDefinition);
				}
				if (!mergedBeanDefinition.hasBeanClass()) {
					return null;
				}
				beanClass = mergedBeanDefinition.getBeanClass();
			}
			if (ClassUtil.isImplementationOf(beanClass, FactoryBean) && !isFactoryDereference(name)) {
				var factoryBean:FactoryBean = FactoryBean(getBeanByName(FACTORY_BEAN_PREFIX + beanName));
				return factoryBean.getObjectType();
			}
			return beanClass;
		}
		catch (exception:org.as2lib.bean.factory.BeanCreationException) {
			if (exception.contains(BeanCurrentlyInCreationException) ||
					exception.contains(FactoryBeanNotInitializedException)) {
				//logger.debug("Ignoring BeanCreationException on FactoryBean type check", ex);
				return null;
			}
			throw exception;
		}
	}

	/**
	 * Determines the bean type for the given bean definition, if possible.
	 *
	 * @param beanName the name of the bean
	 * @param mergedBeanDefinition the bean definition for the bean
	 * @return the type for the bean if determinable, else {@code null}
	 * @see #createBean
	 */
	private function getTypeForFactoryMethod(beanName:String, mergedBeanDefinition:RootBeanDefinition):Function {
		if (mergedBeanDefinition.getFactoryBeanName() != null &&
				mergedBeanDefinition.isSingleton() && !mergedBeanDefinition.isLazyInit()) {
			return eval("_global." + ReflectUtil.getTypeName(getBeanByName(beanName)));
		}
		return null;
	}

	//---------------------------------------------------------------------
	// Implementation of ConfigurableBeanFactory interface
	//---------------------------------------------------------------------

	/**
	 * Returns whether the specified singleton is currently in creation.
	 *
	 * @param beanName the name of the bean
	 * @return {@code true} if the specified singleton is currently in creation else
	 * {@code false}
	 */
	private function isSingletonCurrentlyInCreation(beanName:String):Boolean {
		return (currentlyInCreation[beanName] == true);
	}

	public function registerSingleton(beanName:String, singleton):Void {
		if (singletonCache.containsKey(beanName)) {
			throw new BeanDefinitionStoreException(null, "Could not register singleton [" +
					singleton + "] under bean name '" + beanName + "': there is already singleton [" +
					singletonCache.get(beanName) + " bound.", this, arguments);
		}
		singletonCache.put(beanName, singleton);
	}

	public function addSingleton(beanName:String, singleton):Void {
		singletonCache.put(beanName, singleton);
	}

	public function containsSingleton(beanName : String) : Boolean {
		return singletonCache.containsKey(beanName);
	}

	public function destroySingletons(Void):Void {
		var dbs:Array = disposableBeans.getKeys();
		for (var i:Number = 0; i < dbs.length; i++) {
			destroyDisposableBean(dbs[i]);
		}
		singletonCache.clear();
	}

	public function getSingletonNames(Void):Array {
		return singletonCache.getKeys();
	}

	public function registerAlias(beanName:String, alias:String):Void {
		if (aliasMap.containsKey(alias)) {
			throw new BeanDefinitionStoreException(null, "Cannot register alias '" + alias +
					"' for bean name '" + beanName + "': it is already registered for bean name '" +
					aliasMap.get(alias) + "'.", this, arguments);
		}
		aliasMap.put(alias, beanName);
	}

	public function addBeanPostProcessor(beanPostProcessor:BeanPostProcessor):Void {
		beanPostProcessors.push(beanPostProcessor);
		if (beanPostProcessor instanceof DestructionAwareBeanPostProcessor) {
			hasDestructionAwareBeanPostProcessors = true;
		}
	}

	public function getBeanPostProcessorCount(Void):Number {
		return beanPostProcessors.length;
	}

	public function getBeanPostProcessors(Void):Array {
		return beanPostProcessors;
	}

	public function registerPropertyValueConverter(requiredType:Function, propertyValueConverter:PropertyValueConverter):Void {
		propertyValueConverters.put(requiredType, propertyValueConverter);
		beanWrapper.registerPropertyValueConverterForType(requiredType, propertyValueConverter);
	}

	public function setParentBeanFactory(parentBeanFactory:BeanFactory):Void {
		this.parentBeanFactory = parentBeanFactory;
	}

	//---------------------------------------------------------------------
	// Implementation of HierarchicalBeanFactory interface
	//---------------------------------------------------------------------

	public function getParentBeanFactory(Void):BeanFactory {
		return parentBeanFactory;
	}

	public function containsLocalBean(name:String):Boolean {
		var beanName:String = transformBeanName(name);
		return (containsSingleton(beanName) || containsBeanDefinition(beanName));
	}

	//---------------------------------------------------------------------
	// Implementation of ListableBeanFactory interface
	//---------------------------------------------------------------------

	public function containsBeanDefinition(beanName:String, includingAncestors:Boolean):Boolean {
		var result:Boolean = beanDefinitionMap.containsKey(beanName);
		if (result) {
			return true;
		}
		if (includingAncestors) {
			var pbf:ListableBeanFactory = ListableBeanFactory(parentBeanFactory);
			if (pbf != null) {
				return pbf.containsBeanDefinition(beanName, true);
			}
		}
		return false;
	}

	public function getBeanDefinitionCount(includingAncestors:Boolean):Number {
		var result:Number = beanDefinitionMap.size();
		if (includingAncestors) {
			var pbf:ListableBeanFactory = ListableBeanFactory(parentBeanFactory);
			if (pbf != null) {
				result += pbf.getBeanDefinitionCount(true);
			}
		}
		return result;
	}

	public function getBeanDefinitionNames(includingAncestors:Boolean):Array {
		var result:Array = beanDefinitionMap.getKeys();
		if (includingAncestors) {
			var pbf:ListableBeanFactory = ListableBeanFactory(parentBeanFactory);
			if (pbf != null) {
				result = result.concat(pbf.getBeanDefinitionNames(true));
			}
		}
		return result;
	}

	public function getBeanNames(includingAncestors:Boolean):Array {
		var result:Array = new Array();
		var beanDefinitionNames:Array = beanDefinitionMap.getKeys();
		for (var i:Number = 0; i < beanDefinitionNames.length; i++) {
			var beanName:String = beanDefinitionNames[i];
			var rootBeanDefinition:RootBeanDefinition = getMergedBeanDefinition(beanName, false);
			if (!rootBeanDefinition.isAbstract()) {
				result.push(beanName);
			}
		}
		var singletonNames:Array = getSingletonNames();
		for (var i:Number = 0; i < singletonNames.length; i++) {
			var beanName:String = singletonNames[i];
			// Only check if manually registered.
			if (!containsBeanDefinition(beanName)) {
				result.push(beanName);
			}
		}
		if (includingAncestors) {
			var pbf:ListableBeanFactory = ListableBeanFactory(parentBeanFactory);
			if (pbf) {
				result = result.concat(pbf.getBeanNames(true));
			}
		}
		return result;
	}

	public function getBeanNamesForType(type:Function, includePrototypes:Boolean, includeFactoryBeans:Boolean, includingAncestors:Boolean):Array {
		var result:Array = new Array();
		if (includePrototypes == null) includePrototypes = true;
		if (includeFactoryBeans == null) includeFactoryBeans = true;
		var beanDefinitionNames:Array = beanDefinitionMap.getKeys();
		for (var i:Number = 0; i < beanDefinitionNames.length; i++) {
			var beanName:String = beanDefinitionNames[i];
			var rootBeanDefinition:RootBeanDefinition = getMergedBeanDefinition(beanName, false);
			if (!rootBeanDefinition.isAbstract()) {
				var isFactoryBean:Boolean = rootBeanDefinition.hasBeanClass() &&
						ClassUtil.isImplementationOf(rootBeanDefinition.getBeanClass(), FactoryBean);
				if (isFactoryBean || rootBeanDefinition.getFactoryBeanName() != null) {
					if (includeFactoryBeans && (includePrototypes || isSingleton(beanName))
							&& isBeanTypeMatch(beanName, type)) {
						result.push(beanName);
						// Match found for this bean: do not match FactoryBean itself anymore.
						continue;
					}
					// We're done for anything but a full FactoryBean.
					if (!isFactoryBean) {
						continue;
					}
					// In case of FactoryBean, try to match FactoryBean itself next.
					beanName = FACTORY_BEAN_PREFIX + beanName;
				}
				// Match raw bean instance (might be raw FactoryBean).
				if ((includePrototypes || rootBeanDefinition.isSingleton()) && isBeanTypeMatch(beanName, type)) {
					result.push(beanName);
				}
			}
		}
		var singletonNames:Array = getSingletonNames();
		for (var i:Number = 0; i < singletonNames.length; i++) {
			var beanName:String = singletonNames[i];
			// Only check if manually registered.
			if (!containsBeanDefinition(beanName)) {
				// In case of FactoryBean, match object created by FactoryBean.
				if (isFactoryBean(beanName)) {
					if (includeFactoryBeans && (includePrototypes || isSingleton(beanName)) &&
							isBeanTypeMatch(beanName, type)) {
						result.push(beanName);
						// Match found for this bean: do not match FactoryBean itself anymore.
						continue;
					}
					// In case of FactoryBean, try to match FactoryBean itself next.
					beanName = FACTORY_BEAN_PREFIX + beanName;
				}
				// Match raw bean instance (might be raw FactoryBean).
				if (isBeanTypeMatch(beanName, type)) {
					result.push(beanName);
				}
			}
		}
		if (includingAncestors) {
			var pbf:ListableBeanFactory = ListableBeanFactory(parentBeanFactory);
			if (pbf != null) {
				result = result.concat(pbf.getBeanNamesForType(type, includePrototypes, includeFactoryBeans, true));
			}
		}
		return result;
	}

	/**
	 * Determines whether the bean with the given name is a factory bean.
	 *
	 * @param name the name of the bean to check
	 * @throws NoSuchBeanDefinitionException if there is no bean with the given name
	 */
	public function isFactoryBean(name:String):Boolean {
		var beanName:String = transformBeanName(name);
		var bean = singletonCache.get(beanName);
		if (bean != null) {
			return (bean instanceof FactoryBean);
		}
		else {
			if (!containsBeanDefinition(beanName)) {
				var pbf:DefaultBeanFactory = DefaultBeanFactory(parentBeanFactory);
				if (pbf != null) {
					return pbf.isFactoryBean(name);
				}
			}
			var bd:RootBeanDefinition = getMergedBeanDefinition(beanName, false);
			return (bd.hasBeanClass() && ClassUtil.isImplementationOf(bd.getBeanClass(), FactoryBean));
		}
	}

	/**
	 * Checks whether the specified bean matches the given type.
	 *
	 * @param beanName the name of the bean to check
	 * @param type the type to check for
	 * @return {@code true} if the bean matches the given type else {@code false}
	 * @see #getType
	 */
	public function isBeanTypeMatch(beanName:String, type:Function):Boolean {
		if (type == null) {
			return true;
		}
		var beanType:Function = getType(beanName);
		return (ClassUtil.isAssignable(beanType, type));
	}

	public function getBeansOfType(type:Function, includePrototypes:Boolean, includeFactoryBeans:Boolean, includingAncestors:Boolean):Map {
		var result:Map = new PrimitiveTypeMap();
		var beanNames:Array = getBeanNamesForType(type, includePrototypes, includeFactoryBeans);
		for (var i:Number = 0; i < beanNames.length; i++) {
			var beanName:String = beanNames[i];
			try {
				result.put(beanName, getBeanByName(beanName));
			}
			catch (exception:org.as2lib.bean.factory.BeanCreationException) {
				if (exception.contains(BeanCurrentlyInCreationException)) {
					// Ignore: indicates a circular reference when autowiring constructors.
					// We want to find matches other than the currently created bean itself.
				}
				else {
					throw exception;
				}
			}
		}
		return result;
	}

	//---------------------------------------------------------------------
	// Implementation of ConfigurableListableBeanFactory interface
	//---------------------------------------------------------------------

	public function getBeanDefinition(beanName:String, includingAncestors:Boolean):BeanDefinition {
		if (beanDefinitionMap.containsKey(beanName)) {
			return beanDefinitionMap.get(beanName);
		}
		if (includingAncestors) {
			var pbf:ConfigurableListableBeanFactory = ConfigurableListableBeanFactory(parentBeanFactory);
			if (pbf != null) {
				return pbf.getBeanDefinition(beanName, true);
			}
		}
		throw new NoSuchBeanDefinitionException(beanName, null, this, arguments);
	}

	public function preInstantiateSingletons(Void):Void {
		var beanDefinitionNames:Array = beanDefinitionMap.getKeys();
		for (var i:Number = 0; i < beanDefinitionNames.length; i++) {
			var beanName:String = beanDefinitionNames[i];
			if (!containsSingleton(beanName) && containsBeanDefinition(beanName)) {
				var beanDefinition:RootBeanDefinition = getMergedBeanDefinition(beanName, false);
				if (!beanDefinition.isAbstract() && beanDefinition.isSingleton() && !beanDefinition.isLazyInit()) {
					if (beanDefinition.hasBeanClass() &&
							ClassUtil.isImplementationOf(beanDefinition.getBeanClass(), FactoryBean)) {
						var factory:FactoryBean = getBeanByName(FACTORY_BEAN_PREFIX + beanName);
						if (factory.isSingleton()) {
							getBeanByName(beanName);
						}
						return;
					}
					getBeanByName(beanName);
				}
			}
		}
	}

	//---------------------------------------------------------------------
	// Implementation of BeanDefinitionRegistry interface
	//---------------------------------------------------------------------

	public function registerBeanDefinition(beanName:String, beanDefinition:BeanDefinition):Void {
		if (!allowBeanDefinitionOverriding && beanDefinitionMap.containsKey(beanName)) {
			throw new BeanDefinitionStoreException(
					beanName, "Cannot register bean definition [" + beanDefinition + "] for bean '" + beanName +
					"': there is already [" + beanDefinitionMap.get(beanName) + "] bound.", this, arguments);
		}
		beanDefinitionMap.put(beanName, beanDefinition);
	}

}