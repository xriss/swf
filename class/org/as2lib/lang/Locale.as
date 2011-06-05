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

import org.as2lib.core.BasicInterface;
import org.as2lib.data.holder.Properties;

/**
 * {@code Locale} represents a specific geographical, political, or cultural region.
 * An operation that requires a locale to perform its task is called locale-sensitive
 * and uses the locale  to tailor information for the user. For example, displaying a
 * number is a locale-sensitive operation - the number should be formatted according
 * to the customs/conventions of the user's native country, region, or culture. These
 * formatting can be done with a {@link NumberFormat}, {@link MessageFormat} or
 * {@link DateFormat} instance for a given locale.
 * 
 * @author Martin Heidegger
 * @author Simon Wacker
 */
interface org.as2lib.lang.Locale extends BasicInterface {
	
	/**
	 * Returns the code for this locale. This code is composed as follows:
	 * "languageCode_countryCode" if the language code as well as the country code
	 * are set. Otherwise either the language or country code is returned.
	 * 
	 * <p>This code is mostly used for getting localized messages from a message
	 * source or loading localized messages from resource bundles with names like
	 * "messages_en_US".
	 * 
	 * @return this locale's code
	 */
	public function getCode(Void):String;
	
	/**
	 * Returns the language of this locale, for example "English", "Deutsch", "français".
	 * This language may be used for display to the user.
	 * 
	 * @return the language of this locale
	 */
	public function getLanguage(Void):String;
	
	/**
	 * Returns the language code of this locale, for example "en", "de", "fr". This
	 * is mainly used for getting localized messages from a message source or loading
	 * localized messages from resource bundles with names like "messages_de".
	 * 
	 * @return this locale's language code
	 */
	public function getLanguageCode(Void):String;
	
	/**
	 * Returns the country of this locale, for example "United States", "United Kingdom",
	 * "Deutschland", "France". This country may be used for display to the user.
	 * 
	 * @return the country of this locale
	 */
	public function getCountry(Void):String;
	
	/**
	 * Returns the country code of this locale, for example "US", "GB", "DE", "FR".
	 * 
	 * @return this locale's country code
	 */
	public function getCountryCode(Void):String;
	
	/**
	 * Returns the symbols of this locale. These are the symbols needed to format
	 * dates and numbers for this locale plus the names of countries in this locale's
	 * language (mapped to their country code).
	 * 
	 * @return this locale's symbols
	 */
	public function getSymbols(Void):Properties;
	
	/**
	 * Looks a localized message for the given key or default key up in this locale's
	 * symbols and formats the looked-up message with the given arguments before
	 * returning it.
	 * 
	 * @param key the key to get a message for
	 * @param defaultKey the default key to use if there is no message for the given
	 * key
	 * @param args the arguments to use to format the looked-up message (in case it
	 * has any wildcard characters to fill with real values
	 * @return the formatted and localized message
	 */
	public function getMessage(key:String, defaultKey:String, args:Array):String;
	
}