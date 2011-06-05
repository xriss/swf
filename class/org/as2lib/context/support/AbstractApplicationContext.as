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

import org.as2lib.aop.Weaver;
import org.as2lib.app.exec.Batch;
import org.as2lib.app.exec.BatchFinishListener;
import org.as2lib.app.exec.Process;
import org.as2lib.app.exec.ProcessFinishListener;
import org.as2lib.bean.factory.BeanFactory;
import org.as2lib.bean.factory.config.BeanFactoryPostProcessor;
import org.as2lib.bean.factory.config.BeanPostProcessor;
import org.as2lib.bean.factory.config.ConfigurableListableBeanFactory;
import org.as2lib.bean.factory.DisposableBean;
import org.as2lib.bean.factory.ListableBeanFactory;
import org.as2lib.bean.factory.support.AbstractBeanFactory;
import org.as2lib.bean.PropertyAccess;
import org.as2lib.context.ApplicationContext;
import org.as2lib.context.ApplicationEvent;
import org.as2lib.context.ApplicationEventPublisher;
import org.as2lib.context.ApplicationListener;
import org.as2lib.context.ConfigurableApplicationContext;
import org.as2lib.context.event.ContextClosedEvent;
import org.as2lib.context.event.ContextRefreshedEvent;
import org.as2lib.context.HierarchicalMessageSource;
import org.as2lib.context.MessageSource;
import org.as2lib.context.support.ApplicationContextAwareProcessor;
import org.as2lib.context.support.DelegatingMessageSource;
import org.as2lib.data.holder.Map;
import org.as2lib.data.type.Time;
import org.as2lib.env.event.distributor.EventDistributorControl;
import org.as2lib.env.except.AbstractOperationException;
import org.as2lib.env.except.IllegalStateException;
import org.as2lib.env.log.LogConfigurationParser;
import org.as2lib.env.log.Logger;
import org.as2lib.env.log.LoggerRepository;
import org.as2lib.env.log.LogManager;
import org.as2lib.env.reflect.ReflectUtil;
import org.as2lib.util.ClassUtil;

/**
 * {@code AbstractApplicationContext} provides implementations of methods that are
 * mostly the same for application contexts. This abstract implementation does not
 * mandate the type of storage used for configuration.
 *
 * <p>The template method design pattern is used, requiring concrete sub-classes to
 * implement the abstract methods {@link #refreshBeanFactory} and {@link #getBeanFactory}.
 *
 * <p>In contrast to a plain bean factory, an application context is supposed to detect
 * special beans defined in its internal bean factory: Therefore, this class automatically
 * registers {@link BeanFactoryPostProcessor}, {@link BeanPostProcessor} and {@link ApplicationListener}
 * instances that are defined as beans in this context.
 *
 * <p>A {@link MessageSource} implementation may also be supplied as a bean in the context,
 * with the name "messageSource"; else, message resolution is delegated to the parent context.
 *
 * <p>Furthermore, a {@link EventDistributorControl} for application events can be supplied
 * as "eventDistributorControl" bean in the context; else, publishing application events is
 * not possible, and will raise errors if it is nevertheless tried.
 *
 * <p>You may also supply a {@link Weaver} implementation as "weaver" whose {@code weave}
 * method will be invoked automatically when this context gets refreshed.
 *
 * <p>If you want {@link Process} beans to be executed before this context is post-refreshed
 * and all singleton beans are initialized, you may supply a {@link Batch} implementation as
 * "batch".
 *
 * <p>To configure the {@link LogManager}, you may supply either a "loggerRepository" or "logger"
 * bean. Note that the configuration of the log manager has global effect (not only context-wide).
 * As third alternative you may also supply a "logConfiguration" process bean which is executed
 * before general purpose process beans.
 *
 * @author Simon Wacker
 */
class org.as2lib.context.support.AbstractApplicationContext extends AbstractBeanFactory
		implements ConfigurableApplicationContext, ApplicationEventPublisher, Process,
		ProcessFinishListener, DisposableBean {

	/**
	 * Name of the {@link MessageSource} bean in this factory.
	 * If none is supplied, message resolution is delegated to the parent.
	 */
	public static var MESSAGE_SOURCE_BEAN_NAME:String = "messageSource";

	/**
	 * Name of the {@link EventDistributorControl} bean in this factory.
	 * If none is supplied, publishing application events is not possible and will
	 * raise errors.
	 */
	public static var EVENT_DISTRIBUTOR_CONTROL_BEAN_NAME:String = "eventDistributorControl";

	/**
	 * Name of the {@link Batch} bean in this factory.
	 * If none is supplied, processing processes is not supported and specifying
	 * processes will raise errors.
	 */
	public static var BATCH_BEAN_NAME:String = "batch";

	/**
	 * Name of the {@link Weaver} bean in this factory.
	 */
	public static var WEAVER_BEAN_NAME:String = "weaver";

	/**
	 * Name of the {@link Logger} bean to initialize the {@link LogManager} with.
	 */
	public static var LOGGER_BEAN_NAME:String = "logger";

	/**
	 * Name of the {@link LoggerRepository} bean to initialize the {@link LogManager}
	 * with.
	 */
	public static var LOGGER_REPOSITORY_BEAN_NAME:String = "loggerRepository";

	/**
	 * Name of the {@link LogConfigurationParser} bean to execute.
	 */
	public static var LOG_CONFIGURATION_PARSER_BEAN_NAME:String = "logConfigurationParser";

	/**
	 * Name of the log configuration process bean to run before general purpose
	 * process beans.
	 */
	public static var LOG_CONFIGURATION_BEAN_NAME:String = "logConfiguration";

	/** Parent context. */
	private var parent:ApplicationContext;

	/** Display name. */
	private var displayName:String;

	/** System time in milliseconds when this context started */
	private var startupTime:Number;

	/** Flag that indicates whether this context is currently active. */
	private var active:Boolean;

	/** {@link BeanFactoryPostProcessor} instances to apply on refresh. */
	private var beanFactoryPostProcessors:Array;

	/**
	 * {@link BeanFactoryPostProcessor} instances which also implement the
	 * {@link Process} interface and must thus be processed before they can be applied.
	 */
	private var beanFactoryPostProcessorProcesses:Array;

	/** {@link BeanPostProcessor} instances to apply on refresh. */
	private var beanPostProcessors:Array;

	/** Message source to look-up localized messages. */
	private var messageSource:MessageSource;

	/** Event distributor control to distribute events. */
	private var eventDistributorControl:EventDistributorControl;

	/** The batch used internally to delegate to. */
	private var batch:Batch;

	/**
	 * Constructs a new {@code AbstractApplicationContext} instance.
	 *
	 * @param parent the parent of this application context
	 */
	private function AbstractApplicationContext(parent:ApplicationContext) {
		this.parent = parent;
		active = true;
		beanFactoryPostProcessors = new Array();
		beanPostProcessors = new Array();
	}

	/**
	 * Returns this instance properly typed.
	 *
	 * @return this instance
	 */
	private function getThis(Void):ApplicationContext {
		return ApplicationContext(this);
	}

	//---------------------------------------------------------------------
	// Implementation of ApplicationContext interface
	//---------------------------------------------------------------------

	public function getParent(Void):ApplicationContext {
		return parent;
	}

	public function getDisplayName(Void):String {
		if (displayName == null) displayName = ReflectUtil.getTypeNameForInstance(this);
		return displayName;
	}

	/**
	 * Sets the display name of this context; typically done during initialization of
	 * concrete context implementations.
	 */
	public function setDisplayName(displayName:String):Void {
		this.displayName = displayName;
	}

	/**
	 * Returns the timestamp in milliseconds when this context was first loaded.
	 *
	 * @return the start-up date
	 */
	public function getStartupDate(Void):Number {
		return startupTime;
	}

	public function getEventPublisher(Void):ApplicationEventPublisher {
		return this;
	}

	/**
	 * Returns the internal message source used by this context.
	 *
	 * @return the internal message source
	 * @throws IllegalStateException if this context has not been initialized yet
	 */
	public function getMessageSource(Void):MessageSource {
		if (messageSource == null) {
			throw new IllegalStateException("Message source is not initialized: " +
					"Call 'refresh' before accessing messages via this context [" + this + "].", this, arguments);
		}
		return messageSource;
	}

	//---------------------------------------------------------------------
	// Implementation of ApplicationEventPublisher interface
	//---------------------------------------------------------------------

	/**
	 * Publishes the given {@code event} to all listeners.
	 *
	 * <p>Note that listeners get initialized after the message source, to be able to
	 * access it within listeners. Thus, message sources cannot publish events.
	 *
	 * @param event the event to publish (may be application-specific or a standard
	 * framework event)
	 */
	public function publishEvent(event:ApplicationEvent):Void {
		var eventDistributor:ApplicationListener = getEventDistributorControl().getDistributor();
		eventDistributor.onApplicationEvent(event);
		if (parent != null) {
			parent.getEventPublisher().publishEvent(event);
		}
	}

	/**
	 * Returns the event distributor control to publish events with.
	 *
	 * <p>Note that there is no default event distributor control.
	 *
	 * @return the event distributor control
	 * @throws IllegalStateException if either there is no event distributor control
	 * or it has not been initialized yet
	 */
	public function getEventDistributorControl(Void):EventDistributorControl {
		if (eventDistributorControl == null) {
			throw new IllegalStateException("Event distributor control not initialized: " +
					"Declare an event distributor control or call 'refresh' before publishing " +
					"events via this context [" + this + "].", this, arguments);
		}
		return eventDistributorControl;
	}

	/**
	 * Returns whether this context has an event distributor control.
	 *
	 * @return {@code ture} if there is an event distributor and it has been initialized,
	 * otherwise {@code false}
	 */
	public function hasEventDistributorControl(Void):Boolean {
		return (eventDistributorControl != null);
	}

	//---------------------------------------------------------------------
	// Implementation of ConfigurableApplicationContext interface
	//---------------------------------------------------------------------

	public function setParent(parent:ApplicationContext):Void {
		this.parent = parent;
	}

	public function addBeanFactoryPostProcessor(beanFactoryPostProcessor:BeanFactoryPostProcessor):Void {
		beanFactoryPostProcessors.push(beanFactoryPostProcessor);
	}

	public function addBeanPostProcessor(beanPostProcessor:BeanPostProcessor):Void {
		beanPostProcessors.push(beanPostProcessor);
	}

	/**
	 * Returns the list of {@link BeanFactoryPostProcessor} instances that will be
	 * applied to beans created with this factory.
	 *
	 * @return the list of bean factory post processors
	 */
	public function getBeanFactoryPostProcessors(Void):Array {
		return beanFactoryPostProcessors.concat();
	}

	/**
	 * Returns the list of {@link BeanPostProcessor} instance to apply to beans
	 * created by this factory.
	 *
	 * @return the list of bean post processors
	 */
	public function getBeanPostProcessors(Void):Array {
		return beanPostProcessors.concat();
	}

	public function refresh(Void):Void {
		preRefresh();
		postRefresh();
	}

	private function preRefresh(Void):Void {
		startupTime = (new Date()).getTime();
		// tells subclass to refresh the internal bean factory
		refreshBeanFactory();
		var beanFactory:ConfigurableListableBeanFactory = getBeanFactory();
		// populates the bean factory with context-specific resource editors
		// ClassConverter is a default property value converter of bean wrappers.
		//beanFactory.registerPropertyValueConverter(Function, new ClassConverter());
		// configures the bean factory with context semantics
		beanFactory.addBeanPostProcessor(new ApplicationContextAwareProcessor(getThis()));
		// allows post-processing of the bean factory in context subclasses
		postProcessBeanFactory(beanFactory);
		// invokes factory processors registered with the context instance
		beanFactoryPostProcessorProcesses = new Array();
		for (var i:Number = 0; i < beanFactoryPostProcessors.length; i++) {
			var factoryProcessor:BeanFactoryPostProcessor = beanFactoryPostProcessors[i];
			if (factoryProcessor instanceof Process) {
				beanFactoryPostProcessorProcesses.push(factoryProcessor);
			}
			else {
				factoryProcessor.postProcessBeanFactory(beanFactory);
			}
		}
		try {
			// invokes factory processors registered as beans in the context
			invokeBeanFactoryPostProcessors();
			// registers bean processors that intercept bean creation
			registerBeanPostProcessors();
			// initializes weaver for this context
			initWeaver();
			// initializes the logger
			initLogger();
			// initializes the logger repository
			initLoggerRepository();
			// initializes the log configuration parser
			initLogConfigurationParser();
			// initializes message source for this context
			initMessageSource();
			// initializes event distributor control for this context
			initEventDistributorControl();
			// initializes batch for this context
			initBatch();
			// initializes other special beans in specific context subclasses
			onRefresh();
		}
		catch (exception:org.as2lib.bean.BeanException) {
			// destroys already created singletons to avoid dangling resources
			beanFactory.destroySingletons();
			throw exception;
		}
	}

	private function postRefresh(Void):Void {
		var beanFactory:ConfigurableListableBeanFactory = getBeanFactory();
		try {
			// checks for listener beans and registers them
			registerListeners();
			// instantiates singletons this late to allow them to access the message source
			beanFactory.preInstantiateSingletons();
			// publishes corresponding event
			if (hasEventDistributorControl()) {
				publishEvent(new ContextRefreshedEvent(getThis()));
			}
			active = true;
		}
		catch (exception:org.as2lib.bean.BeanException) {
			// destroys already created singletons to avoid dangling resources
			beanFactory.destroySingletons();
			throw exception;
		}
	}

	/**
	 * Modifies the application context's internal bean factory after its standard
	 * initialization. All bean definitions will have been loaded, but no beans
	 * will have been instantiated yet. This allows for registering special bean post
	 * processors etc. in certain application contexts.
	 *
	 * @param beanFactory the bean factory used by this application context
	 * @throws BeanException in case of errors
	 */
	private function postProcessBeanFactory(beanFactory:ConfigurableListableBeanFactory):Void {
	}

	/**
	 * Instantiates and invokes all registered post-processor beans. Must be called
	 * before singleton instantiation.
	 */
	private function invokeBeanFactoryPostProcessors(Void):Void {
		// Do not initialize FactoryBeans here: We need to leave all regular beans
		// uninitialized to let the bean factory post-processors apply to them!
		var factoryProcessorNames:Array = getBeanNamesForType(BeanFactoryPostProcessor, true, false);
		// Invoke BeanFactoryPostProcessors, one by one.
		for (var i:Number = 0; i < factoryProcessorNames.length; i++) {
			var factoryProcessorName:String = factoryProcessorNames[i];
			var factoryProcessor:BeanFactoryPostProcessor = getBeanByName(factoryProcessorName);
			if (factoryProcessor instanceof Process) {
				beanFactoryPostProcessorProcesses.push(factoryProcessor);
			}
			else {
				factoryProcessor.postProcessBeanFactory(getBeanFactory());
			}
		}
		var parentFactory:ListableBeanFactory = ListableBeanFactory(getInternalParentBeanFactory());
		if (parentFactory != null) {
			var parentFactoryProcessorNames:Array = parentFactory.getBeanNamesForType(
					BeanFactoryPostProcessor, true, false, true);
			for (var i:Number = 0; i < parentFactoryProcessorNames.length; i++) {
				var factoryProcessorName:String = parentFactoryProcessorNames[i];
				var factoryProcessor:BeanFactoryPostProcessor = parentFactory.getBeanByName(factoryProcessorName);
				// Differentiation between BeanFactoryPostProcessors which also implement the
				// Process interface and those that do not, must not be done for post processors
				// from parents, because parents are supposed to be fully initialized.
				factoryProcessor.postProcessBeanFactory(getBeanFactory());
			}
		}
	}

	/**
	 * Instantiates and invokes all registered post-processor beans.
	 *
	 * <p>Must be called before any instantiation of application beans.
	 */
	private function registerBeanPostProcessors(Void):Void {
		var beanFactory:ConfigurableListableBeanFactory = getBeanFactory();
		for (var i:Number = 0; i < beanPostProcessors.length; i++) {
			beanFactory.addBeanPostProcessor(beanPostProcessors[i]);
		}
		// Fetch and register the BeanPostProcessor beans.
		// Do not initialize FactoryBeans here: We need to leave all regular beans
		// uninitialized to let the bean post-processors apply to them!
		var beanProcessors:Array = getBeansOfType(BeanPostProcessor, true, false).getValues();
		for (var i:Number = 0; i < beanProcessors.length; i++) {
			beanFactory.addBeanPostProcessor(beanProcessors[i]);
		}
	}

	/**
	 * Initializes the batch if it exists.
	 */
	private function initBatch(Void):Void {
		if (containsLocalBean(BATCH_BEAN_NAME)) {
			setBatch(getBean(BATCH_BEAN_NAME, Batch));
		}
	}

	/**
	 * Initializes the log manager with the logger if it exists.
	 */
	private function initLogger(Void):Void {
		if (containsLocalBean(LOGGER_BEAN_NAME)) {
			var logger:Logger = getBeanByNameAndType(LOGGER_BEAN_NAME, Logger);
			LogManager.setLogger(logger);
		}
	}

	/**
	 * Initializes the log manager with the logger repository if it exists.
	 */
	private function initLoggerRepository(Void):Void {
		if (containsLocalBean(LOGGER_REPOSITORY_BEAN_NAME)) {
			var loggerRepository:LoggerRepository =
					getBeanByNameAndType(LOGGER_REPOSITORY_BEAN_NAME, LoggerRepository);
			LogManager.setLoggerRepository(loggerRepository);
		}
	}

	/**
	 * Initializes the log configuration parser if it exists (executes it).
	 */
	private function initLogConfigurationParser(Void):Void {
		if (containsLocalBean(LOG_CONFIGURATION_PARSER_BEAN_NAME)) {
			var logConfigurationParser:LogConfigurationParser =
					getBeanByNameAndType(LOG_CONFIGURATION_PARSER_BEAN_NAME, LogConfigurationParser);
			logConfigurationParser.parse();
		}
	}

	/**
	 * Initializes the weaver if it exists (executes the weaving process).
	 */
	private function initWeaver(Void):Void {
		if (containsLocalBean(WEAVER_BEAN_NAME)) {
			var weaver:Weaver = getBeanByNameAndType(WEAVER_BEAN_NAME, Weaver);
			weaver.weave();
		}
	}

	/**
	 * Initializes the message source.
	 */
	private function initMessageSource(Void):Void {
		if (containsLocalBean(MESSAGE_SOURCE_BEAN_NAME)) {
			messageSource = getBeanByNameAndType(MESSAGE_SOURCE_BEAN_NAME, MessageSource);
			// Make MessageSource aware of parent MessageSource.
			if (parent != null && messageSource instanceof HierarchicalMessageSource) {
				var hms:HierarchicalMessageSource = HierarchicalMessageSource(messageSource);
				if (hms.getParentMessageSource() == null) {
					// Only set parent context as parent MessageSource if no parent MessageSource
					// registered already.
					hms.setParentMessageSource(getParent().getMessageSource());
				}
			}
		}
		else {
			// Use empty MessageSource to be able to accept getMessage calls.
			messageSource = new DelegatingMessageSource(getParent().getMessageSource());
		}
	}

	/**
	 * Initializes the event distributor control.
	 *
	 * <p>Note that there is no default distributor.
	 */
	private function initEventDistributorControl(Void):Void {
		if (containsBean(EVENT_DISTRIBUTOR_CONTROL_BEAN_NAME)) {
			eventDistributorControl = getBeanByNameAndType(
					EVENT_DISTRIBUTOR_CONTROL_BEAN_NAME, EventDistributorControl);
		}
	}

	/**
	 * Refreshes this context.
	 *
	 * <p>This method is a template method which can be overridden to add
	 * context-specific refresh work. Called on initialization of special beans, before
	 * instantiation of singletons.
	 *
	 * @throws BeanException in case of errors during refresh
	 * @see #refresh
	 */
	private function onRefresh(Void):Void {
		// For subclasses: do nothing by default.
	}

	/**
	 * Adds beans that implement the {@link ApplicationListener} interface as listeners.
	 * This does not affect other listeners, which can be added without being beans.
	 */
	private function registerListeners(Void):Void {
		// Do not initialize FactoryBeans here: We need to leave all regular beans
		// uninitialized to let post-processors apply to them!
		var listeners:Array = getBeansOfType(ApplicationListener, true, false).getValues();
		for (var i:Number = 0; i < listeners.length; i++) {
			getEventDistributorControl().addListener(listeners[i]);
			//addListener(listeners[i]);
		}
	}

	/**
	 * Registers an application listener. Any beans in this context that are listeners
	 * are automatically added.
	 *
	 * @param listener the listener to register
	 */
	/*private function addListener(listener:ApplicationListener):Void {
		getEventDistributorControl().addListener(listener);
	}*/

	/**
	 * Destroys this instance by invoking the {@link close} method.
	 *
	 * <p>This method corresponds to the {@link DisposableBean} callback for
	 * destruction of this context. Only called when this context itself is
	 * running as a bean in another bean factory or application context, which is
	 * rather unusual.
	 */
	public function destroy(Void):Void {
		close();
	}

	/**
	 * Closes this application context, destroying all beans in its bean factory.
	 */
	public function close(Void):Void {
		if (active) {
			try {
				if (hasEventDistributorControl()) {
					publishEvent(new ContextClosedEvent(getThis()));
				}
			}
			finally {
				// Destroy all cached singletons in this context, invoking
				// DisposableBean.destroy and/or the specified "destroy-method".
				var beanFactory:ConfigurableListableBeanFactory = getBeanFactory();
				if (beanFactory != null) {
					beanFactory.destroySingletons();
				}
			}
			active = false;
		}
	}

	//---------------------------------------------------------------------
	// Implementation of BeanFactory interface
	//---------------------------------------------------------------------

	public function getBeanByName(name:String, property:PropertyAccess) {
		return getBeanFactory().getBeanByName(name, property);
	}

	public function getBeanByNameAndType(name:String, requiredType:Function, property:PropertyAccess) {
		return getBeanFactory().getBeanByNameAndType(name, requiredType, property);
	}

	public function containsBean(name:String):Boolean {
		return getBeanFactory().containsBean(name);
	}

	public function isSingleton(name:String):Boolean {
		return getBeanFactory().isSingleton(name);
	}

	public function getType(name:String):Function {
		return getBeanFactory().getType(name);
	}

	public function getAliases(name:String):Array {
		return getBeanFactory().getAliases(name);
	}

	//---------------------------------------------------------------------
	// Implementation of ListableBeanFactory interface
	//---------------------------------------------------------------------

	public function containsBeanDefinition(name:String, includingAncestors:Boolean):Boolean {
		return getBeanFactory().containsBeanDefinition(name, includingAncestors);
	}

	public function getBeanDefinitionCount(includingAncestors:Boolean):Number {
		return getBeanFactory().getBeanDefinitionCount(includingAncestors);
	}

	public function getBeanDefinitionNames(includingAncestors:Boolean):Array {
		return getBeanFactory().getBeanDefinitionNames(includingAncestors);
	}

	public function getBeanNames(includingAncestors:Boolean):Array {
		return getBeanFactory().getBeanNames(includingAncestors);
	}

	public function getBeanNamesForType(type:Function, includePrototypes:Boolean, includeFactoryBeans:Boolean, includingAncestors:Boolean):Array {
		return getBeanFactory().getBeanNamesForType(type, includePrototypes, includeFactoryBeans, includingAncestors);
	}

	public function getBeansOfType(type:Function, includePrototypes:Boolean, includeFactoryBeans:Boolean, includingAncestors:Boolean):Map {
		return getBeanFactory().getBeansOfType(type, includePrototypes, includeFactoryBeans, includingAncestors);
	}

	//---------------------------------------------------------------------
	// Implementation of HierarchicalBeanFactory interface
	//---------------------------------------------------------------------

	public function getParentBeanFactory(Void):BeanFactory {
		return getParent();
	}

	public function containsLocalBean(name:String):Boolean {
		return getBeanFactory().containsLocalBean(name);
	}

	/**
	 * Returns the internal bean factory of the parent context if it implements the
	 * {@link ConfigurableApplicationContext} class; else, returns the parent context
	 * itself.
	 */
	private function getInternalParentBeanFactory(Void):BeanFactory {
		return (getParent() instanceof ConfigurableApplicationContext) ?
				ConfigurableApplicationContext(getParent()).getBeanFactory() : getParent();
	}

	//---------------------------------------------------------------------
	// Implementation of Process interface
	//---------------------------------------------------------------------

	/**
	 * Starts this application context asynchronously.
	 *
	 * <p>Pre-refreshes this application context, then processes all beans implementing
	 * the {@link Process} interface and post-refreshes this context after processing
	 * the bean processes has finished.
	 *
	 * <p>Note that the bean processes are processed asynchronously. That means in
	 * order to know when this application is fully refreshed you need to add a batch
	 * listener.
	 *
	 * @see #refresh
	 * @see BatchStartListener
	 * @see BatchErrorListener
	 * @see BatchFinishListener
	 */
	public function start() {
		preRefresh();
		var batch:Batch = getBatch();
		registerProcessBeans();
		if (!batch.hasStarted()) {
			batch.start();
		}
	}

	/**
	 * Registers all singleton beans that implement the {@code Process} interface at
	 * the batch of this context.
	 */
	private function registerProcessBeans(Void):Void {
		var processes:Map = getProcessBeans();
		addSpecialFunctionProcesses(processes);
		addBeanFactoryPostProcessorProcesses(beanFactoryPostProcessorProcesses);
		addCustomProcesses(processes.getValues());
	}

	private function addSpecialFunctionProcesses(processes:Map):Void {
		var batch:Batch = getBatch();
		processes.remove(BATCH_BEAN_NAME);
		var logConfigurationProcess:Process = processes.get(LOG_CONFIGURATION_BEAN_NAME);
		if (logConfigurationProcess != null) {
			batch.addProcess(logConfigurationProcess);
			processes.remove(LOG_CONFIGURATION_BEAN_NAME);
		}
		var messageSourceProcess:Process = processes.get(MESSAGE_SOURCE_BEAN_NAME);
		if (messageSourceProcess != null) {
			batch.addProcess(messageSourceProcess);
			processes.remove(MESSAGE_SOURCE_BEAN_NAME);
		}
		var eventDistributorControlProcess:Process = processes.get(EVENT_DISTRIBUTOR_CONTROL_BEAN_NAME);
		if (eventDistributorControlProcess != null) {
			batch.addProcess(eventDistributorControlProcess);
			processes.remove(EVENT_DISTRIBUTOR_CONTROL_BEAN_NAME);
		}
	}

	private function addBeanFactoryPostProcessorProcesses(processes:Array):Void {
		var batch:Batch = getBatch();
		for (var i:Number = 0; i < processes.length; i++) {
			var process:Process = processes[i];
			var listener:ProcessFinishListener = ClassUtil.createCleanInstance(ProcessFinishListener);
			listener.onProcessFinish = function(p:Process):Void {
				var factoryProcessor:BeanFactoryPostProcessor = this.postProcessor;
				factoryProcessor.postProcessBeanFactory(this.beanFactory);
			};
			listener["postProcessor"] = process;
			listener["beanFactory"] = getBeanFactory();
			process.addListener(listener);
			batch.addProcess(process);
		}
	}

	private function addCustomProcesses(processes:Array):Void {
		var batch:Batch = getBatch();
		for (var i:Number = 0; i < processes.length; i++) {
			var process:Process = processes[i];
			if (!(process instanceof BeanFactoryPostProcessor)) {
				batch.addProcess(process);
			}
		}
	}

	/**
	 * Returns a map of all singleton beans that implement the {@link Process}
	 * interface in this context with the bean names as keys and the bean instances
	 * as values.
	 *
	 * @return all singleton process beans
	 */
	private function getProcessBeans(Void):Map {
		return getBeanFactory().getBeansOfType(Process, false, false);
	}

	/**
	 * Post-refreshes this application context after the internal batch has finished
	 * its execution.
	 *
	 * @param process the internal batch that finished its execution
	 */
	public function onProcessFinish(process:Process):Void {
		postRefresh();
	}

	public function hasStarted(Void):Boolean {
		return getBatch().hasStarted();
	}

	public function hasFinished(Void):Boolean {
		return getBatch().hasFinished();
	}

	public function isPaused(Void):Boolean {
		return getBatch().isPaused();
	}

	public function isRunning(Void):Boolean {
		return getBatch().isPaused();
	}

	public function getPercentage(Void):Number {
		return getBatch().getPercentage();
	}

	public function setParentProcess(process:Process):Void {
		getBatch().setParentProcess(process);
	}

	public function getParentProcess(Void):Process {
		return getBatch().getParentProcess();
	}

	public function getErrors(Void):Array {
		return getBatch().getErrors();
	}

	public function hasErrors(Void):Boolean {
		return getBatch().hasErrors();
	}

	public function getDuration(Void):Time {
		return getBatch().getDuration();
	}

	public function getEstimatedTotalTime(Void):Time {
		return getBatch().getEstimatedTotalTime();
	}

	public function getEstimatedRestTime(Void):Time {
		return getBatch().getEstimatedRestTime();
	}

	public function addListener(listener):Void {
		getBatch().addListener(listener);
	}

	public function addAllListeners(listeners:Array):Void {
		getBatch().addAllListeners(listeners);
	}

	public function removeListener(listener):Void {
		getBatch().removeListener(listener);
	}

	public function removeAllListeners(Void):Void {
		getBatch().removeAllListeners();
	}

	public function getAllListeners(Void):Array {
		return getBatch().getAllListeners();
	}

	public function hasListener(listener):Boolean {
		return getBatch().hasListener(listener);
	}

	public function getName(Void):String {
		return getBatch().getName();
	}

	public function setName(name:String):Void {
		getBatch().setName(name);
	}

	/**
	 * Returns the batch to add asynchronous processes to.
	 *
	 * <p>Note that there is no default batch.
	 *
	 * @return the batch
	 * @throws IllegalStateException if either there is no batch or it has not been
	 * initialized yet
	 */
	public function getBatch(Void):Batch {
		if (batch == null) {
			throw new IllegalStateException("Batch not initialized: Declare a batch or " +
					"call 'refresh' before starting processes with this context [" + this + "].",
					this, arguments);
		}
		return batch;
	}

	/**
	 * Sets the batch to add asynchronous processes to.
	 *
	 * <p>Do not set the batch instance variable directly, but use this method
	 * to set it, because this context must be registered as listener at the batch;
	 * this method takes care of this.
	 *
	 * @param batch the new batch
	 */
	public function setBatch(batch:Batch):Void {
		this.batch = batch;
		batch.addListener(this);
	}

	//---------------------------------------------------------------------
	// Abstract methods that must be implemented by subclasses
	//---------------------------------------------------------------------

	/**
	 * Refreshes the bean factory.
	 *
	 * <p>Subclasses must implement this method to perform the actual configuration load.
	 * The method is invoked by {@code refresh} before any other initialization work.
	 *
	 * <p>A subclass will either create a new bean factory and hold a reference to it,
	 * or return a single bean factory instance that it holds. In the latter case, it
	 * will usually throw an illegal state exception if refreshing the context more than
	 * once.
	 *
	 * @throws BeanException if initialization of the bean factory failed
	 * @throws IllegalStateException if already initialized and multiple refresh attempts
	 * are not supported
	 * @see #refresh
	 */
	private function refreshBeanFactory(Void):Void {
		throw new AbstractOperationException("This method is marked as abstract and must be " +
				"overridden by sub-classes.", this, arguments);
	}

	/**
	 * Returns the internal bean factory.
	 *
	 * <p>Subclasses must return their internal bean factory here. They should implement
	 * the lookup efficiently, so that it can be called repeatedly without a performance
	 * penalty.
	 *
	 * @return this application context's internal bean factory
	 * @throws IllegalStateException if this context does not hold an internal bean factory
	 * yet (usually if {@code refresh} has never been called)
	 * @see #refresh
	 */
	public function getBeanFactory(Void):ConfigurableListableBeanFactory {
		throw new AbstractOperationException("This method is marked as abstract and must be " +
				"overridden by sub-classes.", this, arguments);
		return null;
	}

}