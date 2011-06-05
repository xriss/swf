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
import org.as2lib.app.exec.SimpleBatch;
import org.as2lib.bean.factory.parser.BeanDefinitionParser;
import org.as2lib.bean.factory.support.DefaultBeanFactory;
import org.as2lib.context.ApplicationContext;
import org.as2lib.context.support.AbstractRefreshableApplicationContext;
import org.as2lib.io.file.FileLoader;
import org.as2lib.io.file.FileLoaderProcess;
import org.as2lib.io.file.TextFileLoader;

/**
 * {@code LoadingApplicationContext} loads a bean definition file and parses it. The
 * parsed bean definition file may not define its own {@code "batch"} bean.
 *
 * <p>Note that after the loaded bean definition file has been parsed, this context
 * will automatically add all {@link Process} beans to the batch and start it.
 *
 * @author Simon Wacker
 */
class org.as2lib.context.support.LoadingApplicationContext extends
		AbstractRefreshableApplicationContext {

	/** The uri to the bean definition file. */
	private var beanDefinitionUri:String;

	/** The bean definition parser to parse the loaded bean definitions with. */
	private var beanDefinitionParser:BeanDefinitionParser;

	/** Content of loaded bean definition file. */
	private var beanDefinitions:String;

	/**
	 * Constructs a new {@code ProcessableApplicationContext} instance.
	 *
	 * @param beanDefinitionUri the uri to the bean definition file to load the
	 * bean definitions to populate this application context with from
	 * @param beanDefitionParser the bean definition parser to use to parse the loaded
	 * bean definition file
	 * @param parent the parent of this application context
	 */
	public function LoadingApplicationContext(beanDefinitionUri:String,
			beanDefitionParser:BeanDefinitionParser, parent:ApplicationContext) {
		super(parent);
		this.beanDefinitionUri = beanDefinitionUri;
		this.beanDefinitionParser = beanDefitionParser;
		setBatch(new SimpleBatch());
	}

	public function start() {
		var batch:Batch = getBatch();
		batch.removeAllProcesses();
		initFileLoaderProcess();
		batch.start();
	}

	/**
	 * Initializes the file loader process; creates and adds it to the batch.
	 */
	private function initFileLoaderProcess(Void):Void {
		var fileLoader:FileLoader = new TextFileLoader();
		var fileLoaderProcess:FileLoaderProcess = new FileLoaderProcess(fileLoader);
		fileLoaderProcess.setUri(beanDefinitionUri);
		// Find a proper solution for the following ugly workaround.
		fileLoaderProcess.onLoadComplete = function(fl:FileLoader):Void {
			try {
				this.applicationContext["onLoadComplete"](fl);
			}
			catch (exception) {
				this.distributeErrorEvent(exception);
			}
			// finish the loading process after possible process beans have been added
			// otherwise the batch distributes a finish event before possible
			// processes in the bean factory have been run
			this.__proto__.onLoadComplete.apply(this, [fl]);
		};
		fileLoaderProcess["applicationContext"] = this;
		getBatch().addProcess(fileLoaderProcess);
	}

	/**
	 * Gets invoked when the bean definition file was successfully loaded.
	 *
	 * @param fileLoader the file laoder that loaded the bean definition file
	 * @see AbstractApplicationContext#start
	 */
	private function onLoadComplete(fileLoader:FileLoader):Void {
		beanDefinitions = TextFileLoader(fileLoader).getTextFile().getContent();
		super.start();
	}

	/**
	 * Parses the content of the loaded bean definition file with the parser specified
	 * on construction.
	 *
	 * @param beanFactory the bean factory to load bean definitions into
	 * @throws BeanException if parsing of the bean definitions failed
	 */
	private function loadBeanDefinitions(beanFactory:DefaultBeanFactory):Void {
		beanDefinitionParser.parse(beanDefinitions, beanFactory);
	}

	/**
	 * Returns the uri to the bean definition file.
	 *
	 * @return the uri to the bean definition file
	 */
	public function getBeanDefinitionUri(Void):String {
		return beanDefinitionUri;
	}

	/**
	 * Sets the uri of the bean definition file to load.
	 *
	 * @param beanDefinitionUri the uri of the bean definition to load
	 */
	public function setBeanDefinitionUri(beanDefinitionUri:String):Void {
		this.beanDefinitionUri = beanDefinitionUri;
	}

	/**
	 * Returns the bean definition parser used to parse the loaded bean definition
	 * file.
	 *
	 * @return the bean definition parser
	 */
	public function getBeanDefinitionParser(Void):BeanDefinitionParser {
		return beanDefinitionParser;
	}

	/**
	 * Sets the bean definition parser used to parse the loaded bean definition file.
	 *
	 * @param beanDefinitionParser the bean definition parser
	 */
	public function setBeanDefinitionParser(beanDefinitionParser:BeanDefinitionParser):Void {
		this.beanDefinitionParser = beanDefinitionParser;
	}

}