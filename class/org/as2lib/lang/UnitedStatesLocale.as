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
import org.as2lib.lang.EnglishLocale;

/**
 * {@code UnitedStatesLocale} represents the United States with language code
 * "en" and country code "US".
 * 
 * @author Simon Wacker
 */
class org.as2lib.lang.UnitedStatesLocale extends EnglishLocale {
	
	public function UnitedStatesLocale(Void) {
		super("US");
	}
	
	private function createSymbols(Void):Properties {
		var result:Properties = super.createSymbols();
		result.setProp("currency", "$");
		return result;
	}
	
}