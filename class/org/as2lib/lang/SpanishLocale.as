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
 * {@code SpanishLocale} represents any Spanish speaking country with the language
 * code "es" and either no country code or the provided one.
 *
 * @author Diego S. Guebel
 */
class org.as2lib.lang.SpanishLocale extends ConcreteLocale {

	/**
	 * Constructs a new {@code SpanishLocale} instance.
	 *
	 * @param countryCode the country code of this locale if it shall represent
	 * a specific Spanish speaking country
	 */
	public function SpanishLocale(countryCode:String) {
		super("es", countryCode, null);
	}

	private function createSymbols(Void):Properties {
		var result:Properties = new SimpleProperties();

		result.setProp("SHORT", "dd.mm.yy hh:nn");
		result.setProp("MEDIUM", "MM dd, yyyy, hh:nn");
		result.setProp("LONG", "MMMM dd, yyyy, hh:nn");
		result.setProp("FULL", "DDDD, MMMM dd, yyyy, hh:nn:ss");

		result.setProp("long.day.1", "domingo");
		result.setProp("long.day.2", "lunes");
		result.setProp("long.day.3", "aartes");
		result.setProp("long.day.4", "miércoles");
		result.setProp("long.day.5", "jueves");
		result.setProp("long.day.6", "viernes");
		result.setProp("long.day.7", "sábado");
		result.setProp("short.day.1", "Do");
		result.setProp("short.day.2", "Lu");
		result.setProp("short.day.3", "Ma");
		result.setProp("short.day.4", "Mi");
		result.setProp("short.day.5", "Ju");
		result.setProp("short.day.6", "Vi");
		result.setProp("short.day.7", "Sa");

		result.setProp("long.month.1", "Enero");
		result.setProp("long.month.2", "Febrero");
		result.setProp("long.month.3", "Marzo");
		result.setProp("long.month.4", "Abril");
		result.setProp("long.month.5", "Mayo");
		result.setProp("long.month.6", "Junio");
		result.setProp("long.month.7", "Julio");
		result.setProp("long.month.8", "Agosto");
		result.setProp("long.month.9", "Septiembre");
		result.setProp("long.month.10", "Octubre");
		result.setProp("long.month.11", "Noviembre");
		result.setProp("long.month.12", "Diciembre");
		result.setProp("short.month.1", "Ene");
		result.setProp("short.month.2", "Feb");
		result.setProp("short.month.3", "Mar");
		result.setProp("short.month.4", "Abr");
		result.setProp("short.month.5", "May");
		result.setProp("short.month.6", "Jun");
		result.setProp("short.month.7", "Jul");
		result.setProp("short.month.8", "Ago");
		result.setProp("short.month.9", "Sep");
		result.setProp("short.month.10", "Oct");
		result.setProp("short.month.11", "Nov");
		result.setProp("short.month.12", "Dic");

		result.setProp("long.millisecond", "Milisegundo");
		result.setProp("long.milliseconds", "Milisegundos");
		result.setProp("long.second", "Segundo");
		result.setProp("long.seconds", "Segundos");
		result.setProp("long.minute", "Minuto");
		result.setProp("long.minutes", "Minutos");
		result.setProp("long.hour", "Hora");
		result.setProp("long.hours", "Horas");
		result.setProp("long.day", "Día");
		result.setProp("long.days", "Días");
		result.setProp("long.month", "Mes");
		result.setProp("long.months", "Meses");
		result.setProp("long.year", "Año");
		result.setProp("long.years", "Años");

		result.setProp("short.milliseconds", "ms");
		result.setProp("short.second", "s");
		result.setProp("short.minute", "m");
		result.setProp("short.hour", "h");
		result.setProp("short.day", "d");
		result.setProp("short.month", "M");
		result.setProp("short.year", "A");

		result.setProp("NUMBER", "0.##");
		result.setProp("INTEGER", "0");
		result.setProp("CURRENCY", "Â¤0.00");
		result.setProp("PERCENT", "0%");

		result.setProp("round", "round");
		result.setProp("comma", ".");
		result.setProp("currency", "$");

		result.setProp("en", "Inglés");
		result.setProp("GB", "Gran Bretaña");
		result.setProp("US", "Estados Unidos");
		result.setProp("de", "Aleman");
		result.setProp("DE", "Alemania");
		result.setProp("nl", "Holanda");
		result.setProp("BE", "Belgica");
		result.setProp("NL", "Holanda");
		result.setProp("es", "Español");
		result.setProp("ES", "España");
		result.setProp("fr", "Francés");
		result.setProp("FR", "Francia");

		return result;
	}

}