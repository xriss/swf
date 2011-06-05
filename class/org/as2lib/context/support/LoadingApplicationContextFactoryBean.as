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

import org.as2lib.app.exec.Batch;
import org.as2lib.app.exec.BatchFinishListener;
import org.as2lib.app.exec.Process;
import org.as2lib.bean.AbstractBeanWrapper;
import org.as2lib.bean.BeanWrapper;
import org.as2lib.bean.factory.config.BeanPostProcessor;
import org.as2lib.bean.factory.FactoryBean;
import org.as2lib.bean.factory.InitializingBean;
import org.as2lib.bean.factory.parser.BeanDefinitionParser;
import org.as2lib.bean.PropertyAccess;
import org.as2lib.bean.PropertyValue;
import org.as2lib.bean.SimpleBeanWrapper;
import org.as2lib.context.ApplicationContext;
import org.as2lib.context.ApplicationContextAware;
import org.as2lib.context.support.LoadingApplicationContext;
import org.as2lib.core.BasicClass;
import org.as2lib.data.type.Time;
import org.as2lib.env.except.IllegalArgumentException;
import org.as2lib.env.reflect.ReflectUtil;
import org.as2lib.util.ClassUtil;
import org.as2lib.util.TextUtil;

/**
 * {@code LoadingApplicationContextFactoryBean} manages the creation and loading
 * process of a {@link LoadingApplicationContext} bean inside of another bean
 * factory. This factory returns either the managed application context or a bean
 * of the managed application context.
 *
 * <p>This functionality can be used to create composite views composed of different
 * tile views in separated bean definition files.
 *
 * <p>The following example creates a {@link AsWingApplicationContext} instance and
 * uses it to load and parse the "myTileView.xml" bean definition file. This is done
 * during initialization if the application context that manages this bean factory is
 * started in asynchronous mode. When this bean factory is referenced, the bean named
 * "myTargetBeanName" of the loaded application context gets returned.
 * <code>
 *   &ltbean id="myBean" class="org.as2lib.context.support.LoadingApplicationContextFactoryBean"&gt
 *     &ltproperty name="beanDefinitionUri"&gtmyTileView.xml&lt/property&gt
 *     &ltproperty name="targetBeanName"&gtmyTargetBeanName&lt/property&gt
 *     &ltproperty name="applicationContextClass" type="Class"&gt
 *       org.as2lib.context.support.AsWingApplicationContext
 *     &lt/property&gt
 *   &lt/bean&gt
 * </code>
 *
 * @author Simon Wacker
 */
class org.as2lib.context.support.LoadingApplicationContextFactoryBean extends BasicClass implements
		FactoryBean, ApplicationContextAware, InitializingBean, BeanPostProcessor, Process, BatchFinishListener {

	private var applicationContext:LoadingApplicationContext = null;

	private var applicationContextClass:Function = null;

	private var beanDefinitionUri:String = null;

	private var beanDefinitionParser:BeanDefinitionParser = null;

	private var parentApplicationContext:ApplicationContext = null;

	private var targetBeanName:String = null;

	private var propertyValues:Array = null;

	private var proxies:Array = null;

	/**
	 * Constructs a new {@code LoadingApplicationContextFactoryBean} instance.
	 */
	public function LoadingApplicationContextFactoryBean(Void) {
		propertyValues = new Array();
		proxies = new Array();
	}

	/**
	 * Sets the name of the target bean. If you set a target bean name, not the
	 * created application context will be returned, but the bean with the given name
	 * managed by the created context.
	 */
	public function setTargetBeanName(targetBeanName:String):Void {
		this.targetBeanName = targetBeanName;
	}

	/**
	 * Sets the bean definition URI to load.
	 */
	public function setBeanDefinitionUri(beanDefinitionUri:String):Void {
		this.beanDefinitionUri = beanDefinitionUri;
	}

	/**
	 * Sets the application context class to use for loading, parsing and populating.
	 */
	public function setApplicationContextClass(applicationContextClass:Function):Void {
		this.applicationContextClass = applicationContextClass;
	}

	/**
	 * Sets the bean definitino parser to use for parsing the loaded bean definition
	 * file.
	 */
	public function setBeanDefinitionParser(beanDefinitionParser:BeanDefinitionParser):Void {
		this.beanDefinitionParser = beanDefinitionParser;
	}

	public function setApplicationContext(applicationContext:ApplicationContext):Void {
		this.parentApplicationContext = applicationContext;
	}

	public function afterPropertiesSet(Void):Void {
		if (beanDefinitionUri == null) {
			throw new IllegalArgumentException("Bean definition URI is required.", this, arguments);
		}
		if (applicationContextClass == null) {
			applicationContextClass = LoadingApplicationContext;
		}
		else if (!ClassUtil.isAssignable(applicationContextClass, LoadingApplicationContext)) {
			throw new IllegalArgumentException("Given application context class [" +
					ReflectUtil.getTypeNameForType(applicationContextClass) +
					"] is not assignable from class 'LoadingApplicationContext'.", this, arguments);
		}
		applicationContext = new applicationContextClass();
		applicationContext.addListener(this);
		applicationContext.setBeanDefinitionUri(beanDefinitionUri);
		if (beanDefinitionParser != null) {
			applicationContext.setBeanDefinitionParser(beanDefinitionParser);
		}
		applicationContext.setParent(parentApplicationContext);
		applicationContext.addBeanPostProcessor(this);
	}

	public function getObject(property:PropertyAccess) {
		var result;
		if (targetBeanName == null) {
			result = applicationContext;
		}
		else {
			if (hasFinished()) {
				result = applicationContext.getBeanByName(targetBeanName, property);
			}
			else {
				var proxy:Object = new Object();
				proxies.push(proxy);
				result = proxy;
			}
		}
		return result;
	}

	public function getObjectType(Void):Function {
		return null;
	}

	public function isSingleton(Void):Boolean {
		return false;
	}

	public function postProcessBeforeInitialization(bean, beanName:String) {
		if (beanName == targetBeanName) {
			if (propertyValues.length > 0) {
				var beanWrapper:BeanWrapper = new SimpleBeanWrapper(bean);
				for (var i:Number = 0; i < propertyValues.length; i++) {
					beanWrapper.setPropertyValue(propertyValues[i]);
				}
			}
		}
		return bean;
	}

	public function postProcessAfterInitialization(bean, beanName:String) {
		return bean;
	}

	public function onBatchFinish(batch:Batch):Void {
		for (var i:Number = 0; i < proxies.length; i++) {
			var proxy:Object = proxies[i];
			proxy.__proto__ = getObject();
		}
	}

	public function start() {
		applicationContext.start();
	}

	public function hasStarted(Void):Boolean {
		return applicationContext.hasStarted();
	}

	public function hasFinished(Void):Boolean {
		return applicationContext.hasFinished();
	}

	public function isPaused(Void):Boolean {
		return applicationContext.isPaused();
	}

	public function isRunning(Void):Boolean {
		return applicationContext.isRunning();
	}

	public function getPercentage(Void):Number {
		return applicationContext.getPercentage();
	}

	public function setParentProcess(process:Process):Void {
		applicationContext.setParentProcess(process);
	}

	public function getParentProcess(Void):Process {
		return applicationContext.getParentProcess();
	}

	public function getErrors(Void):Array {
		return applicationContext.getErrors();
	}

	public function hasErrors(Void):Boolean {
		return applicationContext.hasErrors();
	}

	public function getDuration(Void):Time {
		return applicationContext.getDuration();
	}

	public function getEstimatedTotalTime(Void):Time {
		return applicationContext.getEstimatedTotalTime();
	}

	public function getEstimatedRestTime(Void):Time {
		return applicationContext.getEstimatedRestTime();
	}

	public function getName(Void):String {
		return applicationContext.getName();
	}

	public function setName(name:String):Void {
		applicationContext.setName(name);
	}

	public function addListener(listener):Void {
		applicationContext.addListener(listener);
	}

	public function addAllListeners(listeners:Array):Void {
		applicationContext.addAllListeners(listeners);
	}

	public function removeListener(listener):Void {
		applicationContext.removeListener(listener);
	}

	public function removeAllListeners(Void):Void {
		applicationContext.removeAllListeners();
	}

	public function getAllListeners(Void):Array {
		return applicationContext.getAllListeners();
	}

	public function hasListener(listener):Boolean {
		return applicationContext.hasListener(listener);
	}

	private function addProperty(methodName:String, methodArguments:Array):Void {
		var prefixLength:Number = AbstractBeanWrapper.SET_PROPERTY_PREFIXES[0].length;
		var name:String = methodName.substr(prefixLength);
		name = TextUtil.lcFirst(name);
		for (var i:Number = 0; i < methodArguments.length - 1; i++) {
			name += AbstractBeanWrapper.PROPERTY_KEY_PREFIX;
			name += methodArguments[i];
			name += AbstractBeanWrapper.PROPERTY_KEY_SUFFIX;
		}
		var value = methodArguments[methodArguments.length - 1];
		var propertyValue:PropertyValue = new PropertyValue(name, value);
		propertyValues.push(propertyValue);
	}

	private function __resolve(methodName:String):Function {
		if (methodName.indexOf("__as2lib__") != 0) {
			var result:Function = function() {
				arguments.callee.owner["addProperty"](arguments.callee.methodName, arguments);
			};
			result.owner = this;
			result.methodName = methodName;
			return result;
		}
	}

}