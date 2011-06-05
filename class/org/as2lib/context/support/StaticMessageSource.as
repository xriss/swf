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

import org.as2lib.context.MessageSource;
import org.as2lib.context.support.AbstractMessageSource;
import org.as2lib.data.holder.Properties;
import org.as2lib.lang.Locale;
import org.as2lib.lang.MessageFormat;

/**
 * {@code StaticMessageSource} allows you to add messages for given locales declaratively
 * or programmatically. It is typically used if you wanna declare messages directly in
 * the application context and not in external properties files.
 * 
 * @author Simon Wacker
 */
class org.as2lib.context.support.StaticMessageSource extends AbstractMessageSource {
	
	/** Associative array storing messages in {@link Properties} files by locale string. */
	private var messages:Array;
	
	/**
	 * Constructs a new {@code StaticMessageSource} instance.
	 */
	public function StaticMessageSource(Void) {
		messages = new Array();
	}
	
	/**
	 * Adds the given {@code message} for the given {@code locale}.
	 * 
	 * @param locale the locale indicating the language of the given {@code messages}
	 * @param messages the messages to add for the given locales
	 */
	public function addMessages(locale:String, messages:Properties):Void {
		this.messages[locale] = messages;
	}
	
	/**
	 * Returns the messages for the given {@code locale}.
	 * 
	 * @return the messages for the given {@code locale}
	 */
	public function getMessages(locale:String):Properties {
		return messages[locale];
	}
	
	/**
	 * Resolves the message with the given {@code code} for the given {@code locale}.
	 * If there is no such message, {@code null} will be returned.
	 * 
	 * @param code the code of the message to resolve
	 * @param locale the language of the message to resolve
	 * @return the resolved message wrapped by a message format or {@code null}
	 */
	private function resolveCode(code:String, locale:Locale):MessageFormat {
		var languageCode:String = locale.getLanguageCode();
		var ms:Properties = messages[languageCode + locale.getCountryCode()];
		if (ms == null) {
			ms = messages[languageCode];
		}
		var message:String = ms.getProp(code, null);
		if (message == null) {
			return null;
		}
		return createMessageFormat(message, locale);
	}
	
}