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

import org.as2lib.env.except.Exception;
import org.as2lib.lang.Locale;

/**
 * {@code NoSuchMessageException} is thrown when a message cannot be resolved.
 * 
 * @author Simon Wacker
 */
class org.as2lib.context.NoSuchMessageException extends Exception {
	
	/**
	 * Constructs a new {@code NoSuchMessageException} instance.
	 *
	 * <p>All arguments are allowed to be {@code null} or {@code undefined}. But if one
	 * is, the string representation returned by the {@code toString} method will not
	 * be complete.
	 *
	 * <p>The {@code args} array should be the internal arguments array of the method
	 * that throws the throwable. The internal arguments array exists in every method
	 * and contains its parameters, the callee method and the caller method. You can
	 * refernce it in every method using {@code arguments}.
	 *
	 * @param code the code that could not be resolved for given locale
	 * @param locale the locale that was used to search for the code
	 * @param object the object the method that throws this exception was invoked on
	 * @param args the arguments of the throwing method
	 */
	public function NoSuchMessageException(code:String, locale:Locale, object, args:Array) {
		super("No message found under code '" + code + "' for locale '" + locale + "'.", object, args);
	}

}