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
 * {@code GermanLocale} represents Germany with the language code "de" and country
 * code "DE".
 *
 * @author Simon Wacker
 */
class org.as2lib.lang.GermanLocale extends ConcreteLocale {

	public function GermanLocale(Void) {
		super("de", "DE", null);
	}

	private function createSymbols(Void):Properties {
		var result:Properties = new SimpleProperties();

		result.setProp("SHORT", "dd.mm.yy hh:nn");
		result.setProp("MEDIUM", "MM dd, yyyy, hh:nn");
		result.setProp("LONG", "MMMM dd, yyyy, hh:nn");
		result.setProp("FULL", "DDDD, MMMM dd, yyyy, hh:nn:ss");

		result.setProp("long.day.1", "Sonntag");
		result.setProp("long.day.2", "Montag");
		result.setProp("long.day.3", "Dienstag");
		result.setProp("long.day.4", "Mittwoch");
		result.setProp("long.day.5", "Donnerstag");
		result.setProp("long.day.6", "Freitag");
		result.setProp("long.day.7", "Samstag");
		result.setProp("short.day.1", "So");
		result.setProp("short.day.2", "Mo");
		result.setProp("short.day.3", "Di");
		result.setProp("short.day.4", "Mi");
		result.setProp("short.day.5", "Do");
		result.setProp("short.day.6", "Fr");
		result.setProp("short.day.7", "Sa");

		result.setProp("long.month.1", "Januar");
		result.setProp("long.month.2", "Februar");
		result.setProp("long.month.3", "März");
		result.setProp("long.month.4", "April");
		result.setProp("long.month.5", "Mai");
		result.setProp("long.month.6", "Juni");
		result.setProp("long.month.7", "Juli");
		result.setProp("long.month.8", "August");
		result.setProp("long.month.9", "September");
		result.setProp("long.month.10", "Oktober");
		result.setProp("long.month.11", "November");
		result.setProp("long.month.12", "Dezember");
		result.setProp("short.month.1", "Jan");
		result.setProp("short.month.2", "Feb");
		result.setProp("short.month.3", "Mär");
		result.setProp("short.month.4", "Apr");
		result.setProp("short.month.5", "Mai");
		result.setProp("short.month.6", "Jun");
		result.setProp("short.month.7", "Jul");
		result.setProp("short.month.8", "Aug");
		result.setProp("short.month.9", "Sep");
		result.setProp("short.month.10", "Okt");
		result.setProp("short.month.11", "Nov");
		result.setProp("short.month.12", "Dez");

		result.setProp("long.millisecond", "Millisekunde");
		result.setProp("long.milliseconds", "Millisekunden");
		result.setProp("long.second", "Sekunde");
		result.setProp("long.seconds", "Sekunden");
		result.setProp("long.minute", "Minute");
		result.setProp("long.minutes", "Minuten");
		result.setProp("long.hour", "Stunde");
		result.setProp("long.hours", "Stunden");
		result.setProp("long.day", "Tag");
		result.setProp("long.days", "Tage");
		result.setProp("long.month", "Monat");
		result.setProp("long.months", "Monate");
		result.setProp("long.year", "Jahr");
		result.setProp("long.years", "Jahre");

		result.setProp("short.milliseconds", "ms");
		result.setProp("short.second", "s");
		result.setProp("short.minute", "min");
		result.setProp("short.hour", "h");
		result.setProp("short.day", "d");
		result.setProp("short.month", "M");
		result.setProp("short.year", "a");

		result.setProp("NUMBER", "0.##");
		result.setProp("INTEGER", "0");
		result.setProp("CURRENCY", "0.00 ¤");
		result.setProp("PERCENT", "0%");

		result.setProp("round", "round");
		result.setProp("comma", ",");
		result.setProp("currency", "€");

		result.setProp("en", "Englisch");
		result.setProp("GB", "Vereinigtes Königreich");
		result.setProp("US", "Vereinigte Staaten");
		result.setProp("de", "Deutsch");
		result.setProp("DE", "Deutschland");
		result.setProp("nl", "Niederländisch");
		result.setProp("BE", "Belgien");
		result.setProp("NL", "Niederlande");
		result.setProp("es", "Spanisch");
		result.setProp("ES", "Spanien");
		result.setProp("fr", "Französisch");
		result.setProp("FR", "Frankreich");

		return result;
	}

}