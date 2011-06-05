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

import org.as2lib.data.holder.Properties;
import org.as2lib.env.event.EventSupport;
import org.as2lib.lang.Locale;
import org.as2lib.lang.LocaleListener;
import org.as2lib.lang.UnitedStatesLocale;

/**
 * {@code LocaleManager} manages multiple locales.
 *
 * <p>It provides an access method {@link #getInstance} that returns always the
 * same shared instance.
 *
 * <p>A locale manager allows you to add supported locales and to specify a default
 * locale that will be used if the locale for the operating system (the target locale)
 * the player is running on does not exist (is not supported). You may also add
 * a {@link LocaleListener} that notifies you of target locale changes, to update
 * for example the texts in your application.
 *
 * <p>The locale manager is itself a locale, that delegates all locale specific method
 * invocations to the target locale. That means that you can store a locale manager
 * instance as locale. You then always get messages etc. for the current target locale
 * without having to look whether is has changed.
 *
 * @author Martin Heidegger
 * @author Simon Wacker
 */
class org.as2lib.lang.LocaleManager extends EventSupport implements Locale {

	/** The locale manager singleton. */
	private static var instance:LocaleManager;

	/**
	 * Returns the singleton instance of this locale manager. This means that the
	 * returned instance is always the same.
	 *
	 * @return the locale manager singleton
	 */
	public static function getInstance(Void):LocaleManager {
		if (instance == null) {
			instance = new LocaleManager();
		}
		return instance;
	}

	/** All added locales. */
	private var locales:Array;

	/** The language code of the default locale. */
	private var defaultLanguageCode:String;

	/** The country code of the default locale. */
	private var defaultCountryCode:String;

	/** The language code of the target locale. */
	private var targetLanguageCode:String;

	/** The country code of the target locale. */
	private var targetCountryCode:String;

	/**
	 * Constructs a new {@code LocaleManager} instance.
	 *
	 * @param defaultLanguageCode the language code of the default locale
	 * @param defaultCountryCode the country code of the default locale
	 */
	public function LocaleManager(defaultLanguageCode:String, defaultCountryCode:String) {
		locales = new Array();
		setDefaultLocale(defaultLanguageCode, defaultCountryCode);
		setTargetLocale(System.capabilities.language);
	}

	public function getCode(Void):String {
		return getTargetLocale().getCode();
	}

	public function getLanguage(Void):String {
		return getTargetLocale().getLanguage();
	}

	public function getLanguageCode(Void):String {
		return getTargetLocale().getLanguageCode();
	}

	public function getCountry(Void):String {
		return getTargetLocale().getCountry();
	}

	public function getCountryCode(Void):String {
		return getTargetLocale().getCountryCode();
	}

	public function getSymbols(Void):Properties {
		return getTargetLocale().getSymbols();
	}

	/**
	 * Looks a localized message for the given key or default key up by invoking
	 * the {@code getMessage} method on the target locale. If the target locale has
	 * no message for the given key or default key, the default locale is asked
	 * for the message.
	 *
	 * @param key the key to get a message for
	 * @param defaultKey the default key to use if there is no message for the given
	 * key
	 * @param args the arguments to use to format the looked-up message (in case it
	 * has any wildcard characters to fill with real values
	 * @return the formatted and localized message
	 */
	public function getMessage(key:String, defaultKey:String, args:Array):String {
		var targetLocale:Locale = getTargetLocale();
		var result:String = targetLocale.getMessage(key, null, args);
		if (result === null) {
			result = targetLocale.getMessage(defaultKey, null, args);
			if (result === null) {
				result = getDefaultLocale().getMessage(key, defaultKey, args);
			}
		}
		return result;
	}

	/**
	 * Returns the target locale of this locale manager.
	 *
	 * <p>If no target language and country have been set, the target language will
	 * be the language of the operating system the player is running on and the country
	 * will not be specified.
	 *
	 * <p>If there is no locale for the target language (and country), the default
	 * locale will be returned.
	 *
	 * <p>This method does never return {@code null}, even if no default locale was
	 * specified, because the locale set for the english language or a {@link UnitedStatesLocale}
	 * instance will be returned then.
	 *
	 * @return the target locale
	 * @see #getDefaultLocale
	 */
	public function getTargetLocale(Void):Locale {
		var result:Locale = locales[targetLanguageCode + targetCountryCode];
		if (result == null) {
			result = locales[targetLanguageCode];
			if (result == null) {
				result = getDefaultLocale();
			}
		}
		return result;
	}

	/**
	 * Sets the target locale.
	 *
	 * <p>If the given target language and country codes differ from the currently set
	 * codes a {@code onLocaleChange} will be triggered on all registered listeners.
	 *
	 * @param targetLanguageCode the language code of the new target locale
	 * @param targetCountryCode the country code of the new target locale
	 * @see #addListener
	 */
	public function setTargetLocale(targetLanguageCode:String, targetCountryCode:String):Void {
		if (this.targetLanguageCode != targetLanguageCode || this.targetCountryCode != targetCountryCode) {
			this.targetLanguageCode = targetLanguageCode;
			this.targetCountryCode = targetCountryCode;
			var distributor:LocaleListener = distributorControl.getDistributor(LocaleListener);
			distributor.onLocaleChange(this);
		}
	}

	/**
	 * Returns the default locale of this locale manager.
	 *
	 * <p>If there is no locale added for the default language and country codes,
	 * the locale for the english language will be used. If this does not exist
	 * either, a new {@link UnitedStatesLocale} instance will be created and added
	 * as locale.
	 *
	 * <p>This method does never return {@code null}.
	 *
	 * @return the default locale
	 */
	public function getDefaultLocale(Void):Locale {
		var result:Locale = locales[defaultLanguageCode + defaultCountryCode];
		if (result == null) {
			result = locales[defaultLanguageCode];
			if (result == null) {
				// The default locale does not exist => return the english locale.
				// DateFormat and NumberFormat depend on this functionality if the
				// programmer is not interested in locales, but just wants to format
				// his dates and numbers with english date and number symbols.
				if (locales["en"] == null) {
					// English locale does not exist => add it.
					addLocale(new UnitedStatesLocale());
				}
				result = locales["en"];
			}
		}
		return result;
	}

	/**
	 * Sets the default locale.
	 *
	 * @param defaultLanguageCode the language code of the new default locale
	 * @param defaultCountryCode the country code of the new default locale
	 */
	public function setDefaultLocale(defaultLanguageCode:String, defaultCountryCode:String):Void {
		this.defaultLanguageCode = defaultLanguageCode;
		this.defaultCountryCode = defaultCountryCode;
	}

	/**
	 * Returns the locale for the given language and country codes. If there is no
	 * locale for the combination of the two, the locale for the language code
	 * will be returned.
	 *
	 * @param languageCode the language code to return the locale for
	 * @param countryCode the country code to return the locale for
	 * @return the locale for the given language and country codes combined or only
	 * for the given language code
	 */
	public function getLocale(languageCode:String, countryCode:String):Locale {
		var result:Locale = locales[languageCode + countryCode];
		if (result == null) {
			result = locales[languageCode];
		}
		return result;
	}

	/**
	 * Returns all added locales.
	 *
	 * @return all added locales
	 */
	public function getLocales(Void):Array {
		return locales.concat();
	}

	/**
	 * Adds the given locale to this locale manager.
	 *
	 * <p>The locale currently registered for the given language and country codes
	 * combined will be overwritten, but the locale for just the language code will
	 * be left unchanged. This means that regarding just the language code, the first
	 * locale added has higher priority.
	 *
	 * @param locale the new locale to add
	 */
	public function addLocale(locale:Locale):Void {
		if (locale != null) {
			var languageCode:String = locale.getLanguageCode();
			var countryCode:String = locale.getCountryCode();
			if (locales[languageCode] == null) {
				locales[languageCode] = locale;
			}
			locales[languageCode + countryCode] = locale;
		}
	}

	/**
	 * Adds all {@code Locale} instances contained in the given locales array.
	 *
	 * @param locales the {@code Locale} instances to add
	 */
	public function addLocales(locales:Array):Void {
		for (var i:Number = 0; i < locales.length; i++) {
			addLocale(Locale(locales[i]));
		}
	}

	/**
	 * Removes the locale registered for the given language and country codes. If
	 * there is another locale for the same language code, this other locale will be
	 * made the "owner" of the language.
	 *
	 * @param languageCode the language code of the locale to remove
	 * @param countryCode the country code of the locale to remove
	 */
	public function removeLocale(languageCode:String, countryCode:String):Void {
		var locale:Locale = locales[languageCode + countryCode];
		if (locale == null) {
			delete locales[languageCode];
		}
		else {
			if (locales[languageCode] == locale) {
				delete locales[languageCode];
				// Check whether there is another locale that has the same language code.
				// Make this other locale the new 'owner' of the language.
				for (var i:Number = 0; i < locales.length; i++) {
					var lc:Locale = locales[i];
					if (lc.getLanguageCode() == languageCode) {
						locales[languageCode] = lc;
					}
					break;
				}
			}
			delete locales[languageCode + countryCode];
		}
	}

}