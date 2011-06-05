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
import org.as2lib.app.exec.Process;
import org.as2lib.app.exec.SimpleBatch;
import org.as2lib.bean.factory.config.BeanFactoryPostProcessor;
import org.as2lib.bean.factory.config.ConfigurableListableBeanFactory;
import org.as2lib.bean.factory.InitializingBean;
import org.as2lib.core.BasicClass;
import org.as2lib.data.holder.Properties;
import org.as2lib.data.holder.properties.PropertiesParser;
import org.as2lib.data.holder.properties.SimpleProperties;
import org.as2lib.data.type.Time;
import org.as2lib.env.except.AbstractOperationException;
import org.as2lib.io.file.FileLoader;
import org.as2lib.io.file.FileLoaderProcess;
import org.as2lib.io.file.LoadCompleteListener;
import org.as2lib.io.file.TextFile;
import org.as2lib.io.file.TextFileLoader;

/**
 * {@code PropertyResourceConfigurer} allows for configuration of individual bean
 * property values from a property resource, for example a properties file. Useful for
 * custom config files targetted at system administrators that override bean
 * properties configured in the application context.
 *
 * <p>Two concrete implementations are provided in the distribution:
 * <ul>
 *   <li>
 *     {@link PropertyOverrideConfigurer} for "beanName.property=value" style
 *     overriding (<i>pushing</i> values from a properties file into bean definitions)
 *   </li>
 *   <li>
 *     {@link PropertyPlaceholderConfigurer} for replacing "${...}" placeholders
 *     (<i>pulling</i> values from a properties file into bean definitions)
 *   </li>
 * </ul>
 *
 * <p>Property values can be converted after reading them in, through overriding
 * the {@link #convertPropertyValue} method. For example, encrypted values can be
 * detected and decrypted accordingly before processing them.
 *
 * @author Simon Wacker
 */
class org.as2lib.bean.factory.config.PropertyResourceConfigurer extends BasicClass implements
		BeanFactoryPostProcessor, InitializingBean, Process, LoadCompleteListener {

	/** Batch used to load properties files. */
	private var batch:Batch;

	/** Shall resources which cannot be found be ignored? */
	private var ignoreResourceNotFound:Boolean;

	/** Locations of properties files. */
	private var locations:Array;

	/** Loaded properties files merged into one instance. */
	private var properties:Properties;

	/** The properties parser to use. */
	private var propertiesParser:PropertiesParser;

	/**
	 * Constructs a new {@code PropertyResourceConfigurer} instance.
	 */
	private function PropertyResourceConfigurer(Void) {
		ignoreResourceNotFound = false;
		locations = new Array();
		properties = new SimpleProperties();
		propertiesParser = new PropertiesParser();
	}

	/**
	 * Returns the batch used internally for loading properties files.
	 *
	 * <p>The default batch is an instance of class {@link SimpleBatch}.
	 *
	 * @return the batch used for loading properties files
	 */
	public function getBatch(Void):Batch {
		if (batch == null) {
			batch = new SimpleBatch();
		}
		return batch;
	}

	/**
	 * Sets the batch to use for loading properties files.
	 */
	public function setBatch(batch:Batch):Void {
		this.batch = batch;
	}

	/**
	 * Shall resources which cannot be found be ignored? {@code true} is appropriate
	 * if the properties file is completely optional. Default is {@code false}.
	 */
	public function setIgnoreResourceNotFound(ignoreResourceNotFound:Boolean):Void {
		this.ignoreResourceNotFound = ignoreResourceNotFound;
	}

	/**
	 * Returns whether resources which cannot be found are ignored.
	 */
	public function isIgnoreResourceNotFound(Void):Boolean {
		return ignoreResourceNotFound;
	}

	/**
	 * Adds the location of a properties file to load.
	 */
	public function addLocation(location:String):Void {
		locations.push(location);
	}

	/**
	 * Adds the locations of properties files to load.
	 */
	public function addLocations(locations:Array):Void {
		for (var i:Number = 0; i < locations.length; i++) {
			this.locations.push(locations[i]);
		}
	}

	/**
	 * Returns all added locations of properties files.
	 */
	public function getLocations(Void):Array {
		return locations.concat();
	}

	/**
	 * Adds local properties, for example via the "props" tag in XML bean definitions.
	 * Local properties can be considered defaults, to be overridden by properties
	 * loaded from files.
	 */
	public function addProperties(properties:Properties):Void {
		var keys:Array = properties.getKeys();
		for (var i:Number = 0; i < keys.length; i++) {
			var key:String = keys[i];
			this.properties.setProp(key, properties.getProp(key));
		}
	}

	public function afterPropertiesSet(Void):Void {
		for (var i:Number = 0; i < locations.length; i++) {
			var fileLoader:FileLoader = new TextFileLoader();
			fileLoader.addListener(this);
			var fileLoaderProcess:FileLoaderProcess = new FileLoaderProcess(fileLoader, ignoreResourceNotFound);
			fileLoaderProcess.setUri(locations[i]);
			getBatch().addProcess(fileLoaderProcess);
		}
	}

	public function onLoadComplete(fileLoader:FileLoader):Void {
		var textFile:TextFile = TextFile(fileLoader.getFile());
		propertiesParser.parseProperties(textFile.getContent(), properties);
	}

	public function postProcessBeanFactory(beanFactory:ConfigurableListableBeanFactory):Void {
		convertProperties(properties);
		processProperties(beanFactory, properties);
	}

	/**
	 * Converts the given merged properties, converting property values if necessary.
	 * The result will then be processed.
	 *
	 * <p>Default implementation invokes {@code convertPropertyValue} for each property
	 * value, replacing the original with the converted value.
	 *
	 * @param properties the properties to convert
	 * @see #convertPropertyValue
	 * @see #processProperties
	 */
	private function convertProperties(properties:Properties):Void {
		var propertyNames:Array = properties.getKeys();
		for (var i:Number = 0; i < propertyNames.length; i++) {
			var propertyName:String = propertyNames[i];
			var propertyValue:String = properties.getProp(propertyName);
			var convertedValue:String = convertPropertyValue(propertyValue);
			if (convertedValue != propertyValue) {
				properties.setProp(propertyName, convertedValue);
			}
		}
	}

	/**
	 * Converts the given property value from the properties source to the value that
	 * should be applied.
	 *
	 * <p>Default implementation simply returns the original value. Can be overridden
	 * in subclasses, for example to detect encrypted values and decrypt them
	 * accordingly.
	 *
	 * @param originalValue the original value from the properties source
	 * @return the converted value, to be used for processing
	 */
	private function convertPropertyValue(originalValue:String):String {
		return originalValue;
	}

	/**
	 * Applies the given properties to the bean factory.
	 *
	 * <p>Note that this method is abstract and must be overridden by sub-classes.
	 *
	 * @param beanFactory the bean factory used by the application context
	 * @param properties the properties to apply
	 * @throws BeanException in case of errors
	 */
	private function processProperties(beanFactory:ConfigurableListableBeanFactory, properties:Properties):Void {
		throw new AbstractOperationException("This method is marked as abstract and must be " +
				"overridden by sub-classes.", this, arguments);
	}

	public function start() {
		getBatch().start();
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
		return getBatch().isRunning();
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

	public function getName(Void):String {
		return getBatch().getName();
	}

	public function setName(name:String):Void {
		getBatch().setName(name);
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

}