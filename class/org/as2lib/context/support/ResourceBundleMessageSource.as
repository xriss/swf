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
import org.as2lib.app.exec.BatchProcess;
import org.as2lib.app.exec.Process;
import org.as2lib.app.exec.SimpleBatch;
import org.as2lib.bean.factory.InitializingBean;
import org.as2lib.context.support.AbstractMessageSource;
import org.as2lib.data.holder.Map;
import org.as2lib.data.holder.map.HashMap;
import org.as2lib.data.holder.Properties;
import org.as2lib.data.holder.properties.PropertiesParser;
import org.as2lib.data.type.Time;
import org.as2lib.io.file.FileLoader;
import org.as2lib.io.file.FileLoaderProcess;
import org.as2lib.io.file.LoadCompleteListener;
import org.as2lib.io.file.TextFile;
import org.as2lib.io.file.TextFileLoader;
import org.as2lib.lang.Locale;
import org.as2lib.lang.LocaleManager;
import org.as2lib.lang.MessageFormat;

/**
 * {@code ResourceBundleMessageSource} accesses the resource bundles with the
 * specified basenames.
 *
 * <p>This message source caches both the accessed resource bundles and
 * the generated message formats for each message. It also implements rendering of
 * no-arg messages without message format, as supported by the abstract message source
 * base class.
 *
 * @author Simon Wacker
 */
class org.as2lib.context.support.ResourceBundleMessageSource extends AbstractMessageSource implements
		Process, InitializingBean, LoadCompleteListener {

	/** The file extension for properties files. */
	public static var PROPERTIES_FILE_EXTENSION:String = "properties";

	/** The base-names of the resource bundles to load. */
	private var baseNames:Array;

	/** The batch used for loading resource bundles. */
	private var batch:Batch;

	/** Shall the resource bundles of all locales be loaded? */
	private var loadAllLocales:Boolean;

	/** The loaded resource bundles. */
	private var resourceBundles:Array;

	/** The cached message formats. */
	private var cachedMessageFormats:Map;

	public function ResourceBundleMessageSource(Void) {
		baseNames = new Array();
		loadAllLocales = false;
		resourceBundles = new Array();
		cachedMessageFormats = new HashMap();
	}

	/**
	 * Returns the batch used internally for loading resource bundles.
	 */
	public function getBatch(Void):Batch {
		if (batch == null) {
			batch = new SimpleBatch();
		}
		return batch;
	}

	/**
	 * Sets the batch to use for loading resource bundles.
	 */
	public function setBatch(batch:Batch):Void {
		this.batch = batch;
	}

	public function afterPropertiesSet(Void):Void {
		if (loadAllLocales) {
			var locales:Array = LocaleManager.getInstance().getLocales();
			for (var i:Number = 0; i < locales.length; i++) {
				addResourceBundleLoaderProcesses(locales[i]);
			}
		}
		else {
			var locale:Locale = LocaleManager.getInstance().getTargetLocale();
			addResourceBundleLoaderProcesses(locale);
		}
	}

	/**
	 * Adds the processes to load the resource bundles for the given locale.
	 *
	 * @param locale the locale to load resource bundles for
	 */
	private function addResourceBundleLoaderProcesses(locale:Locale):Void {
		for (var k:Number = 0; k < baseNames.length; k++) {
			var baseName:String = baseNames[k];
			var code:String = locale.getLanguageCode();
			var languageProcess:FileLoaderProcess = createFileLoaderProcess(baseName, locale.getLanguageCode());
			getBatch().addProcess(languageProcess);
			var countryProcess:FileLoaderProcess = createFileLoaderProcess(baseName, locale.getCode());
			getBatch().addProcess(countryProcess);
		}
	}

	/**
	 * Creates a file loader process for the given base-name and code.
	 *
	 * @param baseName the base-name of the file to load
	 * @param code the code to append to the file to load
	 */
	private function createFileLoaderProcess(baseName:String, code:String):FileLoaderProcess {
		var fileLoader:FileLoader = new TextFileLoader();
		fileLoader.addListener(this);
		var fileLoaderProcess:FileLoaderProcess = new FileLoaderProcess(fileLoader, true);
		var uri:String = baseName + "_" + code + "." + PROPERTIES_FILE_EXTENSION;
		fileLoaderProcess.setUri(uri);
		// Do not associate uri with code and basename in resource bundle cache, but rather create a ResourceBundle class that holds code and basename.
		resourceBundles[uri] = [baseName, code];
		return fileLoaderProcess;
	}

	public function onLoadComplete(fileLoader:FileLoader):Void {
		var textFile:TextFile = TextFile(fileLoader.getFile());
		var propertiesParser:PropertiesParser = new PropertiesParser();
		var properties:Properties = propertiesParser.parseProperties(textFile.getContent());
		var baseNameAndCode:Array = resourceBundles[textFile.getLocation()];
		var baseName:String = baseNameAndCode[0];
		var code:String = baseNameAndCode[1];
		if (resourceBundles[baseName] == null) {
			resourceBundles[baseName] = new Array();
		}
		resourceBundles[baseName][code] = properties;
	}

	/**
	 * Returns whther the resource bundles of all available locales are loaded or just
	 * the the ones of the target locale.
	 *
	 * <p>Note that only the messages from the resource bundles that get loaded can be
	 * accessed, because synchronous loading is not possible in Flash.
	 *
	 * <p>Default is {@code false}.
	 *
	 * @return whether all locales are loaded
	 */
	public function isLoadAllLocales(Void):Boolean {
		return loadAllLocales;
	}

	/**
	 * Sets whether to load the resource bundles of all available locales or just the
	 * ones of the target locale.
	 *
	 * <p>Note that only the messages from the resource bundles that get loaded can be
	 * accessed, because synchronous loading is not possible in Flash.
	 *
	 * @param whether to load all locales
	 */
	public function setLoadAllLocales(loadAllLocales:Boolean):Void {
		this.loadAllLocales = loadAllLocales;
	}

	/**
	 * Sets a single basename. The base-name is a relative or absolute path to a
	 * properties file to load.
	 *
	 * @param baseName the single base-name
	 * @see #setBasenames
	 */
	public function setBaseName(baseName:String):Void {
		setBaseNames([baseName]);
	}

	/**
	 * Sets an array of base-names. The base-names will be checked sequentially when
	 * resolving a message code.
	 *
	 * <p>Note that message definitions in a <i>previous</i> resource bundle
	 * will override ones in a later bundle, due to the sequential lookup.
	 *
	 * @param baseNames an array of base-names
	 * @see #setBasename
	 */
	public function setBaseNames(baseNames:Array):Void  {
		if (baseNames == null) {
			this.baseNames = new Array();
		}
		else {
			this.baseNames = baseNames;
		}
	}

	/**
	 * Resolves the given message code as key in the registered resource bundles,
	 * returning the value found in the bundle as-is (without message format parsing).
	 *
	 * @param code the message code to resolve
	 * @param locale the locale to get a message for
	 * @return the resolved message or {@code null} if none
	 */
	private function resolveCodeWithoutArguments(code:String, locale:Locale):String {
		var result:String = null;
		for (var i:Number = 0; result == null && i < baseNames.length; i++) {
			var bundle:Properties = getResourceBundle(baseNames[i], locale);
			if (bundle != null) {
				result = bundle.getProp(code, null);
			}
		}
		return result;
	}

	/**
	 * Resolves the given message code as key in the registered resource bundles,
	 * using a cached message format per message code.
	 *
	 * @param code the message code to resolve
	 * @param locale the locale to get a message for
	 * @return the message format with the resolved message or {@code null} if none
	 */
	private function resolveCode(code:String, locale:Locale):MessageFormat {
		var result:MessageFormat = null;
		for (var i:Number = 0; result == null && i < baseNames.length; i++) {
			var bundle:Properties = getResourceBundle(baseNames[i], locale);
			if (bundle != null) {
				result = getMessageFormat(bundle, code, locale);
			}
		}
		return result;
	}

	/**
	 * Gets the resource bundle for the given base-name and locale.
	 *
	 * @param baseName the base-name
	 * @param locale the locale
	 * @return the resource bundle for the given base-name and locale
	 */
	private function getResourceBundle(baseName:String, locale:Locale):Properties {
		var result:Properties = null;
		var rbs:Array = resourceBundles[baseName];
		result = rbs[locale.getCode()];
		if (result == null) {
			result = rbs[locale.getLanguageCode()];
		}
		return result;
	}

	/**
	 * Returns the message format for the given bundle, code and locale. If it has
	 * already been created the cached message format will be returned, otherwise a
	 * new will be created.
	 *
	 * @param bundle the bundle to return a message from
	 * @param code the code of the message
	 * @param locale the locale of the message
	 * @return the message format for the message in the bundle
	 */
	private function getMessageFormat(bundle:Properties, code:String, locale:Locale):MessageFormat {
		var codes:Array = cachedMessageFormats.get(bundle);
		var locales:Array;
		if (codes != null) {
			locales = codes[code];
			if (locales != null) {
				var result:MessageFormat = locales[locale.getCode()];
				if (result == null) {
					result = locales[locale.getLanguageCode()];
				}
				if (result != null) {
					return result;
				}
			}
		}
		var message:String = bundle.getProp(code, null);
		if (message != null) {
			if (codes == null) {
				codes = new Array();
				cachedMessageFormats.put(bundle, codes);
			}
			if (locales == null) {
				locales = new Array();
				codes[code] = locales;
			}
			var result:MessageFormat = createMessageFormat(message, locale);
			locales[locale.getCode()] = result;
			return result;
		}
		return null;
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
		if (batch == null) {
			batch = new BatchProcess();
		}
		getBatch().setName(name);
	}

}