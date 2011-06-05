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

import org.as2lib.app.exec.AbstractProcess;
import org.as2lib.app.exec.Call;
import org.as2lib.app.exec.Process;
import org.as2lib.env.log.LogConfigurationParser;
import org.as2lib.io.file.FileLoader;
import org.as2lib.io.file.FileLoaderProcess;
import org.as2lib.io.file.TextFile;
import org.as2lib.io.file.TextFileLoader;

/**
 * {@code LogConfigurationProcess} loads a log configuration and parses it.
 * 
 * @author Simon Wacker
 */
class org.as2lib.env.log.parser.LogConfigurationProcess extends AbstractProcess implements Process {
	
	/** The uri to the log configuration to load and parse. */
	private var logConfigurationUri:String;
	
	/** The log configuration parser to use. */
	private var logConfigurationParser:LogConfigurationParser;
	
	/**
	 * Constructs a new {@code LogConfigurationProcess} instance.
	 * 
	 * @param logConfigurationUri the uri of the log configuration to load and parse
	 * @param logConfigurationParser the log configuration parser to use
	 */
	public function LogConfigurationProcess(logConfigurationUri:String, logConfigurationParser:LogConfigurationParser) {
		setLogConfigurationUri(logConfigurationUri);
		setLogConfigurationParser(logConfigurationParser);
	}
	
	/**
	 * Sets the URI of the log configuration to load and parse.
	 */
	public function setLogConfigurationUri(logConfigurationUri:String):Void {
		this.logConfigurationUri = logConfigurationUri;
		if (getName() == null) {
			setName(logConfigurationUri);
		}
	}
	
	/**
	 * Sets the log configuration parser to parse the loaded log configuration file
	 * with.
	 */
	public function setLogConfigurationParser(logConfigurationParser:LogConfigurationParser):Void {
		this.logConfigurationParser = logConfigurationParser;
	}
	
	/**
	 * Loads the log configuration and parses it.
	 */
	public function run(Void):Void {
		var fileLoader:FileLoader = new TextFileLoader();
		var fileLoaderProcess:FileLoaderProcess = new FileLoaderProcess(fileLoader);
		fileLoaderProcess.setUri(logConfigurationUri);
		startSubProcess(fileLoaderProcess, null, new Call(this, onLoadComplete));
	}
	
	/**
	 * Parses the loaded log configuration file.
	 * 
	 * @param fileLoaderProcess the file loader process
	 */
	public function onLoadComplete(fileLoaderProcess:FileLoaderProcess):Void {
		var fileLoader:FileLoader = fileLoaderProcess.getFileLoader();
		var textFile:TextFile = TextFile(fileLoader.getFile());
		logConfigurationParser.parse(textFile.getContent());
	}
	
}