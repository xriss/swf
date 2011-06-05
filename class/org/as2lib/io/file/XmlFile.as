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

import org.as2lib.data.type.Byte;
import org.as2lib.io.file.SimpleTextFile;
import org.as2lib.io.file.XmlParser;

/**
 * {@code XmlFile} represents an XML file.
 *
 * @author Martin Heidegger
 * @author Simon Wacker
 * @version 1.0
 */
class org.as2lib.io.file.XmlFile extends SimpleTextFile {

	/** The data structure representation of this xml file. */
	private var xml:XML;

	/** Parses the XML-formatted content of this file. */
	private var xmlParser:XmlParser;

	/**
	 * Constructs a new {@code XmlFile} instance.
	 *
	 * @param content the content of this XML file
	 * @param size the size in bytes of this XML file
	 * @param location the location of this XML file
	 */
	public function XmlFile(content:String, size:Byte, location:String) {
		super(content, size, location);
	}

	/**
	 * Returns the xml parser used to parse this file's XML-formatted string content.
	 * If no xml parser was set manually a {@link XmlParser} instance will be returned.
	 */
	public function getXmlParser(Void):XmlParser {
		if (xmlParser == null) {
			xmlParser = new XmlParser();
		}
		return xmlParser;
	}

	/**
	 * Sets the xml parser to use for parsing this file's XML-formatted string content.
	 */
	public function setXmlParser(xmlParser:XmlParser):Void {
		this.xmlParser = xmlParser;
	}

	/**
	 * Returns the object-oriented representation of this XML file's content. It is
	 * generated with the set xml parser.
	 *
	 * @return the object-oriented representation of this XML file's content
	 * @see #setXmlParser
	 */
	public function getXml(Void):XML {
		if (xml == null) {
			xml = getXmlParser().parse(getContent());
		}
		return xml;
	}

}