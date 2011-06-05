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

import org.as2lib.core.BasicClass;
import org.as2lib.data.holder.Map;
import org.as2lib.data.holder.map.HashMap;
import org.as2lib.data.type.Byte;
import org.as2lib.env.overload.Overload;
import org.as2lib.io.file.SimpleTextFileFactory;
import org.as2lib.io.file.TextFile;
import org.as2lib.io.file.TextFileFactory;

/**
 * {@code CompositeTextFileFactory} uses different {@code TextFileFactory}
 * implementations depending on the file extension of the given URI to create
 * {@code TextFile} instances.
 *
 * <p>You can map file extensions to text file factories with the
 * {@link #putTextFileFactory} method and set a default text file factory on
 * construction or with the {@link #setDefaultTextFileFactory} method. The default
 * factory is used when there is no specific factory for a file extension.
 *
 * <p>It is a common case that different file extensions are used for different
 * kinds of files like "xml" for XML files, "properties" for properties files and
 * "txt" for text files. A composite file factory offers a convenient way to use
 * one loader to load different kinds of files depending on the file extension.
 *
 * @author Martin Heidegger
 * @author Simon Wacker
 * @version 2.0
 */
class org.as2lib.io.file.CompositeTextFileFactory extends BasicClass implements
		TextFileFactory {

	/**
	 * The text file factory to use if a file extension is not mapped to a specific
	 * factory.
	 */
	private var defaultTextFileFactory:TextFileFactory;

	/** Maps {@link TextFileFactory} instances to file extensions. */
	private var textFileFactories:Map;

	/**
	 * Constructs a new {@code CompositeTextFileFactory} instance.
	 *
	 * <p>If no default text file factory is given, a {@link SimpleTextFileFactory}
	 * instance is used as default text file factory.
	 *
	 * @param defaultTextFileFactory the text file factory to use if a file extension
	 * is unknown (not mapped to a specific factory)
	 */
	public function CompositeTextFileFactory(defaultTextFileFactory:TextFileFactory) {
		if (defaultTextFileFactory == null) {
			defaultTextFileFactory = new SimpleTextFileFactory();
		}
		this.defaultTextFileFactory = defaultTextFileFactory;
		textFileFactories = new HashMap();
	}

	/**
	 * Creates a new {@code TextFile} instance for the loaded file by extracting the
	 * file extension from the given URI and using the text file factory mapped to the
	 * extracted extension to create the {@code TextFile} instance. If there is not
	 * text file factory mapped to the extension the default text file factory will
	 * be used.
	 *
	 * @param content the content of the loaded file
	 * @param size the size in byte of the loaded file
	 * @param uri the URI of the loaded file
	 * @return the text file which represents the loaded file
	 */
	public function createTextFile(content:String, size:Byte, uri:String):TextFile {
		var factory:TextFileFactory = textFileFactories.get(uri.substr(uri.lastIndexOf(".")));
		if (factory == null) {
			factory = defaultTextFileFactory;
		}
		return factory.createTextFile(content, size, uri);
	}

	/**
	 * Sets the default text file factory to use for files with unknown extensions
	 * (extensions which are not mapped to a specific text file factory).
	 *
	 * @param defaultTextFileFactory the default text file factory
	 */
	public function setDefaultTextFileFactory(defaultTextFileFactory:TextFileFactory):Void {
		this.defaultTextFileFactory = defaultTextFileFactory;
	}

	/**
	 * @overload #putTextFileFactoryByExtension
	 * @overload #putTextFileFactoryByExtensions
	 */
	public function putTextFileFactory() {
		var o:Overload = new Overload(this);
		o.addHandler(String, putTextFileFactoryByExtension);
		o.addHandler(Array, putTextFileFactoryByExtensions);
		return o.forward(arguments);
	}

	/**
	 * Maps the given text file factory to the given file extension. The file extension
	 * should not have a leading ".".
	 *
	 * <p>Example:
	 *
	 * <code>
	 *   var textFileFactory:CompositeTextFileFactory = new CompositeTextFileFactory();
	 *   textFileFactory.putTextFileFactoryByExtension("xml", new XmlFileFactory());
	 * </code>
	 *
	 * @param fileExtension the extension of files which shall be created by the given
	 * factory
	 * @param textFileFactory the factory to use for creating files for URIs with the
	 * given extension
	 */
	public function putTextFileFactoryByExtension(fileExtension:String,
			textFileFactory:TextFileFactory):Void {
		textFileFactories.put(fileExtension, textFileFactory);
	}

	/**
	 * Maps the given text file factory to the given file extensions. The file
	 * extensions are strings that should not have a leading ".".
	 *
	 * <p>Example:
	 * <code>
	 *   var textFileFactory:CompositeTextFileFactory = new CompositeTextFileFactory();
	 *   textFileFactory.putTextFileFactoryByExtensions(["xml", "xhtml"], new XmlFileFactory());
	 * </code>
	 *
	 * @param fileExtensions the extensions of files which shall be created by the
	 * given factory
	 * @param textFileFactory the factory to use for creating files for URIs with the
	 * given extension
	 */
	public function putTextFileFactoryByExtensions(fileExtensions:Array,
			textFileFactory:TextFileFactory):Void {
		for (var i:Number = 0; i < fileExtensions.length; i++) {
			putTextFileFactoryByExtension(fileExtensions[i], textFileFactory);
		}
	}

}