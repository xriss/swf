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

import org.as2lib.core.BasicClass;
import org.as2lib.util.ClassUtil;
import org.as2lib.bean.PropertyValueConverter;

/**
 * {@code PropertyValueConverterHolder} holds a property value converter with its
 * registered type.
 *
 * @author Simon Wacker
 */
class org.as2lib.bean.PropertyValueConverterHolder extends BasicClass {

	/** The property value converter. */
	private var propertyValueConverter:PropertyValueConverter;

	/** The registered type of the property value converter. */
	private var registeredType:Function;

	/**
	 * Constructs a new {@code PropertyValueConverterHolder} instance.
	 *
	 * @param propertyValueConverter the property value converter
	 * @param registeredType the type the converter is registered for
	 */
	public function PropertyValueConverterHolder(propertyValueConverter:PropertyValueConverter, registeredType:Function) {
		// Remove this class and either use an associative array to register converter to type (or store type directly in converter). The latter would require changes in the registerPropertyValueConverter methods.
		this.propertyValueConverter = propertyValueConverter;
		this.registeredType = registeredType;
	}

	/**
	 * Returns the type the converter is registered with.
	 *
	 * @return the type the converter is registered with
	 */
	public function getRegisteredType(Void):Function {
		return registeredType;
	}

	/**
	 * Returns the property value converter of the given required type is assignable
	 * from the registered type of the converter.
	 *
	 * @param requiredType the type a converter is needed for
	 * @return the converter if the required type is assignable from the registred type
	 * else {@code null}
	 */
	public function getPropertyValueConverter(requiredType:Function):PropertyValueConverter {
		if (ClassUtil.isAssignable(requiredType, registeredType)) {
			return propertyValueConverter;
		}
		return null;
	}

}