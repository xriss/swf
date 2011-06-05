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
 * {@code GermanLocale} represents any english speaking country with the language
 * code "en" and either no country code or the provided one.
 * 
 * @author Simon Wacker
 */
class org.as2lib.lang.EnglishLocale extends ConcreteLocale {
	
	/**
	 * Constructs a new {@code EnglishLocale} instance.
	 * 
	 * @param countryCode the country code of this locale if it shall represent
	 * a specific english speaking country
	 */
	public function EnglishLocale(countryCode:String) {
		super("en", countryCode, null);
	}
	
	private function createSymbols(Void):Properties {
		var result:Properties = new SimpleProperties();
		
		result.setProp("SHORT", "dd.mm.yy hh:nn");
		result.setProp("MEDIUM", "MM dd, yyyy, hh:nn");
		result.setProp("LONG", "MMMM dd, yyyy, hh:nn");
		result.setProp("FULL", "DDDD, MMMM dd, yyyy, hh:nn:ss");
		
		result.setProp("long.day.1", "Sunday");
		result.setProp("long.day.2", "Monday");
		result.setProp("long.day.3", "Tuesday");
		result.setProp("long.day.4", "Wednesday");
		result.setProp("long.day.5", "Thursday");
		result.setProp("long.day.6", "Friday");
		result.setProp("long.day.7", "Saturday");
		result.setProp("short.day.1", "Su");
		result.setProp("short.day.2", "Mo");
		result.setProp("short.day.3", "Tu");
		result.setProp("short.day.4", "We");
		result.setProp("short.day.5", "Th");
		result.setProp("short.day.6", "Fr");
		result.setProp("short.day.7", "Sa");
		
		result.setProp("long.month.1", "January");
		result.setProp("long.month.2", "February");
		result.setProp("long.month.3", "March");
		result.setProp("long.month.4", "April");
		result.setProp("long.month.5", "May");
		result.setProp("long.month.6", "June");
		result.setProp("long.month.7", "July");
		result.setProp("long.month.8", "August");
		result.setProp("long.month.9", "September");
		result.setProp("long.month.10", "October");
		result.setProp("long.month.11", "November");
		result.setProp("long.month.12", "December");
		result.setProp("short.month.1", "Jan");
		result.setProp("short.month.2", "Feb");
		result.setProp("short.month.3", "Mar");
		result.setProp("short.month.4", "Apr");
		result.setProp("short.month.5", "May");
		result.setProp("short.month.6", "Jun");
		result.setProp("short.month.7", "Jul");
		result.setProp("short.month.8", "Aug");
		result.setProp("short.month.9", "Sep");
		result.setProp("short.month.10", "Oct");
		result.setProp("short.month.11", "Nov");
		result.setProp("short.month.12", "Dec");
		
		result.setProp("long.millisecond", "Millisecond");
		result.setProp("long.milliseconds", "Milliseconds");
		result.setProp("long.second", "Second");
		result.setProp("long.seconds", "Seconds");
		result.setProp("long.minute", "Minute");
		result.setProp("long.minutes", "Minutes");
		result.setProp("long.hour", "Hour");
		result.setProp("long.hours", "Hours");
		result.setProp("long.day", "Day");
		result.setProp("long.days", "Days");
		result.setProp("long.month", "Month");
		result.setProp("long.months", "Months");
		result.setProp("long.year", "Year");
		result.setProp("long.years", "Years");
		
		result.setProp("short.milliseconds", "ms");
		result.setProp("short.second", "s");
		result.setProp("short.minute", "m");
		result.setProp("short.hour", "h");
		result.setProp("short.day", "d");
		result.setProp("short.month", "M");
		result.setProp("short.year", "Y");
		
		result.setProp("NUMBER", "0.##");
		result.setProp("INTEGER", "0");
		result.setProp("CURRENCY", "¤0.00");
		result.setProp("PERCENT", "0%");
		
		result.setProp("round", "round");
		result.setProp("comma", ".");
		result.setProp("currency", "$");
		
		result.setProp("en", "English");
		result.setProp("GB", "United Kingdom");
		result.setProp("US", "United States");
		result.setProp("de", "German");
		result.setProp("DE", "Germany");
		result.setProp("nl", "Dutch");
		result.setProp("BE", "Belgium");
		result.setProp("NL", "Netherlands");
		result.setProp("es", "Spanish");
		result.setProp("ES", "Spain");
		result.setProp("fr", "French");
		result.setProp("FR", "France");
		
		return result;
	}
	
}