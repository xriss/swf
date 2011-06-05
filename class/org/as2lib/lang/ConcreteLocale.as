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
import org.as2lib.data.holder.Properties;
import org.as2lib.lang.Locale;
import org.as2lib.lang.MessageFormat;

/**
 * {@code ConcreteLocale} is a parameterizable implementation of the {@code Locale}
 * interface that meets most needs and is meant to be sub-classed by locales for
 * specific languages and countries.
 * 
 * <p>Sub-classes can either pass the symbols in on construction or override the
 * {@link #createSymbols} method to create the symbols only when needed.
 * 
 * @author Martin Heidegger
 * @author Simon Wacker
 */
class org.as2lib.lang.ConcreteLocale extends BasicClass implements Locale {
	
	private var languageCode:String;
	
	private var countryCode:String;
	
	/**
	 * The symbols of this locale. Note that this variable may be {@code null}, if
	 * the symbols are initialized lazily. Thus do not use this variable directly
	 * but rather the {@link #getSymbols} method.
	 */
	private var symbols:Properties;
	
	/**
	 * The internal message format for this locale used to format messages by the
	 * {@link #getMessage} method.
	 */
	private var messageFormat:MessageFormat;
	
	/**
	 * Constructs a new {@code ConcreteLocale} instance.
	 * 
	 * <p>The written-out form of the language and country is looked-up in the symbols
	 * when needed, passing the language or country code respectively as key.
	 * 
	 * @param languageCode the language code of this locale
	 * @param countryCode the country code of this locale
	 * @param symbols the symbols of this locale
	 * @see #createSymbols
	 */
	public function ConcreteLocale(languageCode:String, countryCode:String, symbols:Properties) {
		this.languageCode = languageCode;
		this.countryCode = countryCode;
		this.symbols = symbols;
		this.messageFormat = new MessageFormat(null, this);
	}
	
	public function getCode(Void):String {
		return (languageCode + "_" + countryCode);
	}
	
	public function getLanguage(Void):String {
		return getSymbols().getProp(languageCode);
	}
	
	public function getLanguageCode(Void):String {
		return languageCode;
	}
	
	public function getCountry(Void):String {
		return getSymbols().getProp(countryCode);
	}
	
	public function getCountryCode(Void):String {
		return countryCode;
	}
	
	public function getSymbols(Void):Properties {
		if (symbols == null) {
			symbols = createSymbols();
		}
		return symbols;
	}
	
	/**
	 * Creates the symbols for this locale. This method returns by default {@code null},
	 * but may be overwritten by sub-classes that wanna initialize symbols lazily (only
	 * when needed).
	 * 
	 * <p>This method is invoked by the {@link #getSymbols} method if no symbols were
	 * passed-in on construction of this locale.
	 * 
	 * @return the symbols for this locale
	 */
	private function createSymbols(Void):Properties {
		return null;
	}
	
	public function getMessage(key:String, defaultKey:String, args:Array):String {
		// do not use symbols instance variable directly to let sub-classes initialize symbols lazily
		var symbols:Properties = getSymbols();
		var message:String = symbols.getProp(key, null);
		if (message === null) {
			message = symbols.getProp(defaultKey, null);
			if (message === null) {
				if (defaultKey === null) {
					return null;
				}
				return key;
			}
			return messageFormat.format(args, message);
		}
		return messageFormat.format(args, message);
	}
	
}