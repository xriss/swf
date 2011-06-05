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
import org.as2lib.bean.factory.parser.CascadingStyleSheetParser;
import org.as2lib.bean.factory.parser.StyleSheetParser;
import org.as2lib.core.BasicClass;
import org.as2lib.data.type.Time;
import org.as2lib.io.file.FileLoader;
import org.as2lib.io.file.FileLoaderProcess;
import org.as2lib.io.file.LoadCompleteListener;
import org.as2lib.io.file.TextFile;
import org.as2lib.io.file.TextFileLoader;

/**
 * {@code StyleSheetConfigurer} formats bean definitions in the bean factory with the
 * given and loaded style sheets.
 * 
 * @author Simon Wacker
 */
class org.as2lib.bean.factory.config.StyleSheetConfigurer extends BasicClass implements
		InitializingBean, Process, LoadCompleteListener, BeanFactoryPostProcessor {
	
	private var styleSheets:Array;
	
	private var styleSheetUris:Array;
	
	private var batch:Batch;
	
	private var styleSheetParser:StyleSheetParser;
	
	/**
	 * Constructs a new {@code StyleSheetConfigurer} instance.
	 * 
	 * @param styleSheet the local style sheet to parse
	 * @see #setStyleSheet
	 */
	public function StyleSheetConfigurer(styleSheet:String) {
		styleSheets = new Array();
		styleSheetUris = new Array();
		addStyleSheet(styleSheet);
	}
	
	/**
	 * Returns the batch used internally for loading style sheets.
	 * 
	 * <p>The default batch is an instance of class {@link SimpleBatch}.
	 * 
	 * @return the batch used for loading style sheets
	 */
	public function getBatch(Void):Batch {
		if (batch == null) {
			batch = new SimpleBatch();
		}
		return batch;
	}
	
	/**
	 * Sets the batch to use for loading style sheets.
	 */
	public function setBatch(batch:Batch):Void {
		this.batch = batch;
	}
	
	/**
	 * Returns the style sheet parser used to added and loaded parse style sheets.
	 * 
	 * <p>The default parser is an instance of class {@link CascadingStyleSheetParser}.
	 * 
	 * @return the style sheet parser
	 */
	public function getStyleSheetParser(Void):StyleSheetParser {
		if (styleSheetParser == null) {
			styleSheetParser = new CascadingStyleSheetParser();
		}
		return styleSheetParser;
	}
	
	/**
	 * Sets the style sheet parser to use for parsing added and loaded style sheets.
	 */
	public function setStyleSheetParser(styleSheetParser:StyleSheetParser):Void {
		this.styleSheetParser = styleSheetParser;
	}
	
	/**
	 * Adds a style sheet to parse.
	 * 
	 * <p>Note that the given style sheet has precedence over any loaded style sheet,
	 * that means it overwrites styles of loaded style sheets.
	 * 
	 * <p>Note also that the firstly added style sheet has the highest precedence.
	 * 
	 * @param styleSheet the style sheet to parse
	 */
	public function addStyleSheet(styleSheet:String):Void {
		if (styleSheet != null) {
			styleSheets.push(styleSheet);
		}
	}
	
	/**
	 * Adds a style sheet URI to load and parse.
	 * 
	 * <p>Note that if style sheets declare the same styles, style sheets will
	 * overwrite styles of style sheets added before them.
	 * 
	 * @param styleSheetUri the style sheet URI to load and parse
	 */
	public function addStyleSheetUri(styleSheetUri:String):Void {
		styleSheetUris.push(styleSheetUri);
	}
	
	public function afterPropertiesSet(Void):Void {
		for (var i:Number = 0; i < styleSheetUris.length; i++) {
			var fileLoader:FileLoader = new TextFileLoader();
			fileLoader.addListener(this);
			var fileLoaderProcess:FileLoaderProcess = new FileLoaderProcess(fileLoader);
			fileLoaderProcess.setUri(styleSheetUris[i]);
			getBatch().addProcess(fileLoaderProcess);
		}
	}
	
	public function onLoadComplete(fileLoader:FileLoader):Void {
		var textFile:TextFile = TextFile(fileLoader.getFile());
		addStyleSheet(textFile.getContent());
	}
	
	public function postProcessBeanFactory(beanFactory:ConfigurableListableBeanFactory):Void {
		var styleSheetParser:StyleSheetParser = getStyleSheetParser();
		for (var i:Number = 0; i < styleSheets.length; i++) {
			styleSheetParser.parse(styleSheets[i], beanFactory);
		}
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