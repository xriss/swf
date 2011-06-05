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
 * {@code FrenchLocale} represents any French speaking country with the
 * language code "fr".
 *
 * @author Christophe Herreman
 */
class org.as2lib.lang.FrenchLocale extends ConcreteLocale {

	/**
	 * Constructs a new {@code FrenchLocale} instance.
	 *
	 * @param countryCode the country code of this locale if it shall represent
	 * a specific French speaking country
	 */
	public function FrenchLocale(countryCode:String) {
		super("fr", countryCode, null);
	}

	private function createSymbols(Void):Properties {
		var result:Properties = new SimpleProperties();

		result.setProp("SHORT", "dd.mm.yy hh:nn");
		result.setProp("MEDIUM", "MM dd, yyyy, hh:nn");
		result.setProp("LONG", "MMMM dd, yyyy, hh:nn");
		result.setProp("FULL", "DDDD, MMMM dd, yyyy, hh:nn:ss");

		result.setProp("long.day.1", "dimanche");
		result.setProp("long.day.2", "lundi");
		result.setProp("long.day.3", "mardi");
		result.setProp("long.day.4", "mercredi");
		result.setProp("long.day.5", "jeudi");
		result.setProp("long.day.6", "vendredi");
		result.setProp("long.day.7", "samedi");
		result.setProp("short.day.1", "di");
		result.setProp("short.day.2", "lu");
		result.setProp("short.day.3", "ma");
		result.setProp("short.day.4", "me");
		result.setProp("short.day.5", "je");
		result.setProp("short.day.6", "ve");
		result.setProp("short.day.7", "sa");

		result.setProp("long.month.1", "janvier");
		result.setProp("long.month.2", "février");
		result.setProp("long.month.3", "mars");
		result.setProp("long.month.4", "avril");
		result.setProp("long.month.5", "mai");
		result.setProp("long.month.6", "juin");
		result.setProp("long.month.7", "juillet");
		result.setProp("long.month.8", "août");
		result.setProp("long.month.9", "septembre");
		result.setProp("long.month.10", "octobre");
		result.setProp("long.month.11", "novembre");
		result.setProp("long.month.12", "décembre");
		result.setProp("short.month.1", "jan");
		result.setProp("short.month.2", "fév");
		result.setProp("short.month.3", "mar");
		result.setProp("short.month.4", "avr");
		result.setProp("short.month.5", "mai");
		result.setProp("short.month.6", "juin");
		result.setProp("short.month.7", "juil");
		result.setProp("short.month.8", "aou");
		result.setProp("short.month.9", "sep");
		result.setProp("short.month.10", "oct");
		result.setProp("short.month.11", "nov");
		result.setProp("short.month.12", "déc");

		result.setProp("long.millisecond", "milliseconde");
		result.setProp("long.milliseconds", "millisecondes");
		result.setProp("long.second", "seconde");
		result.setProp("long.seconds", "secondes");
		result.setProp("long.minute", "minute");
		result.setProp("long.minutes", "minutes");
		result.setProp("long.hour", "heure");
		result.setProp("long.hours", "heures");
		result.setProp("long.day", "jour");
		result.setProp("long.days", "jours");
		result.setProp("long.month", "mois");
		result.setProp("long.months", "mois");
		// Correct translation for year/years (année vs. an), depends on the context.
		result.setProp("long.year", "an");
		result.setProp("long.years", "ans");

		result.setProp("short.milliseconds", "ms");
		result.setProp("short.second", "s");
		result.setProp("short.minute", "min");
		result.setProp("short.hour", "h");
		result.setProp("short.day", "j");
		result.setProp("short.month", "m");
		result.setProp("short.year", "a");

		result.setProp("NUMBER", "0.##");
		result.setProp("INTEGER", "0");
		result.setProp("CURRENCY", "0.00 ¤");
		result.setProp("PERCENT", "0%");

		result.setProp("round", "round");
		result.setProp("comma", ",");
		result.setProp("currency", "€");

		result.setProp("en", "anglais");
		result.setProp("GB", "Royaume-Uni");
		result.setProp("US", "Etats-Unis");
		result.setProp("de", "allemand");
		result.setProp("DE", "Allemagne");
		result.setProp("du", "néerlandais");
		result.setProp("BE", "Belgique");
		result.setProp("NL", "Pays-Bas");
		result.setProp("es", "espagnol");
		result.setProp("ES", "Espagne");
		result.setProp("fr", "français");
		result.setProp("FR", "France");

		return result;
	}

}