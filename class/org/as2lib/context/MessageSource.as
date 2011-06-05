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

import org.as2lib.context.MessageSourceResolvable;
import org.as2lib.core.BasicInterface;
import org.as2lib.lang.Locale;

/**
 * {@code MessageSource} shall be implemented by classes that can resolve messages.
 * This enables parameterization and internationalization of messages.
 * 
 * @author Simon Wacker
 */
interface org.as2lib.context.MessageSource extends BasicInterface {
	
	/**
	 * @overload getMessageByResolvable
	 * @overload getMessageByCodeAndArguments
	 * @overload getMessageWithDefaultMessage
	 */
	public function getMessage():String;
	
	/**
	 * Tries to resolve the message using all the attributes contained within the given
	 * {@code resolvable}.
	 * 
	 * @param resolvable the value object storing attributes required to properly resolve
	 * a message
	 * @param locale the locale in which to do the look-up
	 * @return the resolved message if the lookup was successful, otherwise the default
	 * message of the given {@code resolvable}
	 * @throws NoSuchMessageException if the message was not found and the default message
	 * in the given {@code resolvable} is {@code undefined}
	 */
	public function getMessageByResolvable(resolvable:MessageSourceResolvable, locale:Locale):String;
	
	/**
	 * Tries to resolve the message.
	 * 
	 * @param code the code to look-up the message, such as 'calculator.noRateSet'
	 * @param args the arguments that will be filled in for parameters within the message
	 * (parameters look like "{0}", "{1,date}", "{2,time}" within a message)
	 * @param locale the locale in which to do the look-up
	 * @return the resolved message
	 * @throws NoSuchMessageException if the message was not found
	 */
	public function getMessageByCodeAndArguments(code:String, args:Array, locale:Locale):String;
	
	/**
	 * Tries to resolve the message and returns the default message if no message was
	 * found.
	 * 
	 * @param code the code to look-up the message, such as 'calculator.noRateSet'
	 * @param args the arguments that will be filled in for parameters within the message
	 * (parameters look like "{0}", "{1,date}", "{2,time}" within a message)
	 * @param defaultMessage the default message to return if the look-up fails
	 * @param locale the locale in which to do the look-up
	 * @return the resolved message if the lookup was successful, otherwise the given
	 * {@code defaultMessage}
	 */
	public function getMessageWithDefaultMessage(code:String, args:Array, defaultMessage:String, locale:Locale):String;
	
}