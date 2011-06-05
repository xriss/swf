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
import org.as2lib.io.file.XmlParseException;

/**
 * {@code XmlParser} parses an XML-formatted string to its native object-oriented
 * representation in ActionScript: {@code XML}.
 *
 * @author Simon Wacker
 */
class org.as2lib.io.file.XmlParser extends BasicClass {

	/** Error messages for XML parse errors. */
	public static var ERROR_MESSAGES:Array =
			["A CDATA section was not properly terminated.",
			"The XML declaration was not properly terminated.",
			"The DOCTYPE declaration was not properly terminated.",
			"A comment was not properly terminated.",
			"An XML element was malformed.",
			"Out of memory.",
			"An attribute value was not properly terminated.",
			"A start-tag was not matched with an end-tag.",
			"An end-tag was encountered without a matching start-tag."];

	private var ignoreWhite:Boolean;

	/**
	 * Constructs a new {@code XmlParser} instance.
	 */
	public function XmlParser(Void) {
		ignoreWhite = true;
	}

	/**
	 * Is white space ignored?
	 */
	public function isIgnoreWhite(Void):Boolean {
		return ignoreWhite;
	}

	/**
	 * Sets whether white space shall be ignored.
	 */
	public function setIgnoreWhite(ignoreWhite:Boolean):Void {
		this.ignoreWhite = ignoreWhite;
	}

	/**
	 * Parses the given XML-formatted string to its native object-oriented
	 * representation in ActionScript.
	 *
	 * @param xml the xml string to parse
	 * @return the object-oriented representation of the xml string
	 */
	public function parse(xml:String):XML {
		var result:XML = new XML();
		result.ignoreWhite = ignoreWhite;
		result.parseXML(xml);
		if (result.status != 0) {
			var errorMessage:String = getErrorMessage(result.status);
			throw new XmlParseException("XML-formatted string could not be parsed: " +
					errorMessage, this, arguments);
		}
		return result;
	}

	/**
	 * Returns the error message for the given error code.
	 *
	 * @see ERROR_MESSAGES
	 */
	private function getErrorMessage(errorCode:Number):String {
		return ERROR_MESSAGES[-2 - errorCode];
	}

}