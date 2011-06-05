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

import org.as2lib.bean.PropertyValueConverter;
import org.as2lib.core.BasicClass;
import org.as2lib.env.except.IllegalArgumentException;

/**
 * {@code PackageConverter} converts values to packages.
 * 
 * @author Simon Wacker
 */
class org.as2lib.bean.converter.PackageConverter extends BasicClass implements PropertyValueConverter {
	
	/**
	 * Constructs a new {@code PackageConverter} instance.
	 */
	public function PackageConverter(Void) {
	}
	
	/**
	 * Converts the given {@code value} to a package. The value is supposed to be
	 * the fully qualified name of a package, that is a package path, and it must
	 * exist in {@code _global}.
	 * 
	 * @param value the package path
	 * @param type the type of the package (ignored by this implementation}
	 * @return the package
	 * @throws IllegalArgumentException if there is no package with the given name
	 */
	public function convertPropertyValue(value:String, type:Function) {
		var package:Object = eval("_global." + value);
		if (package != null) {
			return package;
		}
		throw new IllegalArgumentException("Package with name '" + value + "' could not be found.", this, arguments);
	}
	
}