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
import org.as2lib.data.holder.properties.SimpleProperties;
import org.as2lib.lang.ConcreteLocale;

/**
 * {@code DutchLocale} represents any Dutch speaking country with the
 * language code "nl".
 *
 * @author Christophe Herreman
 */
class org.as2lib.lang.DutchLocale extends ConcreteLocale {

	/**
	 * Constructs a new {@code DutchLocale} instance.
	 *
	 * @param countryCode the country code of this locale if it shall represent
	 * a specific Dutch speaking country
	 */
	public function DutchLocale(countryCode:String) {
		super("nl", countryCode, null);
	}

	private function createSymbols(Void):Properties {
		var result:Properties = new SimpleProperties();

		result.setProp("SHORT", "dd.mm.yy hh:nn");
		result.setProp("MEDIUM", "MM dd, yyyy, hh:nn");
		result.setProp("LONG", "MMMM dd, yyyy, hh:nn");
		result.setProp("FULL", "DDDD, MMMM dd, yyyy, hh:nn:ss");

		result.setProp("long.day.1", "zondag");
		result.setProp("long.day.2", "maandag");
		result.setProp("long.day.3", "dinsdag");
		result.setProp("long.day.4", "woensdag");
		result.setProp("long.day.5", "donderdag");
		result.setProp("long.day.6", "vrijdag");
		result.setProp("long.day.7", "zaterdag");
		result.setProp("short.day.1", "zo");
		result.setProp("short.day.2", "ma");
		result.setProp("short.day.3", "di");
		result.setProp("short.day.4", "wo");
		result.setProp("short.day.5", "do");
		result.setProp("short.day.6", "vr");
		result.setProp("short.day.7", "za");

		result.setProp("long.month.1", "januari");
		result.setProp("long.month.2", "februari");
		result.setProp("long.month.3", "maart");
		result.setProp("long.month.4", "april");
		result.setProp("long.month.5", "mei");
		result.setProp("long.month.6", "juni");
		result.setProp("long.month.7", "juli");
		result.setProp("long.month.8", "augustus");
		result.setProp("long.month.9", "september");
		result.setProp("long.month.10", "oktober");
		result.setProp("long.month.11", "november");
		result.setProp("long.month.12", "december");
		result.setProp("short.month.1", "jan");
		result.setProp("short.month.2", "feb");
		result.setProp("short.month.3", "maa");
		result.setProp("short.month.4", "apr");
		result.setProp("short.month.5", "mei");
		result.setProp("short.month.6", "jun");
		result.setProp("short.month.7", "jul");
		result.setProp("short.month.8", "aug");
		result.setProp("short.month.9", "sep");
		result.setProp("short.month.10", "okt");
		result.setProp("short.month.11", "nov");
		result.setProp("short.month.12", "dec");

		result.setProp("long.millisecond", "milliseconde");
		result.setProp("long.milliseconds", "milliseconden");
		result.setProp("long.second", "seconde");
		result.setProp("long.seconds", "seconden");
		result.setProp("long.minute", "minuut");
		result.setProp("long.minutes", "minuten");
		result.setProp("long.hour", "uur");
		result.setProp("long.hours", "uren");
		result.setProp("long.day", "dag");
		result.setProp("long.days", "dagen");
		result.setProp("long.month", "maand");
		result.setProp("long.months", "maanden");
		result.setProp("long.year", "jaar");
		result.setProp("long.years", "jaren");

		result.setProp("short.milliseconds", "ms");
		result.setProp("short.second", "sec");
		result.setProp("short.minute", "min");
		result.setProp("short.hour", "h");
		result.setProp("short.day", "d");
		result.setProp("short.month", "m");
		result.setProp("short.year", "j");

		result.setProp("NUMBER", "0.##");
		result.setProp("INTEGER", "0");
		// Netherlands and Flanders-Belgium use "¤ 0.00".
		// Belgium uses "0.00 ¤".
		result.setProp("CURRENCY", "¤ 0.00");
		result.setProp("PERCENT", "0%");

		result.setProp("round", "round");
		result.setProp("comma", ",");
		result.setProp("currency", "€");

		result.setProp("en", "Engels");
		result.setProp("GB", "Verenigd Koninkrijk");
		result.setProp("US", "Verenigde Staten");
		result.setProp("de", "Duits");
		result.setProp("DE", "Duitsland");
		result.setProp("du", "Nederlands");
		result.setProp("BE", "België");
		result.setProp("NL", "Nederland");
		result.setProp("es", "Spaans");
		result.setProp("ES", "Spanje");
		result.setProp("fr", "Frans");
		result.setProp("FR", "Frankrijk");

		return result;
	}

}