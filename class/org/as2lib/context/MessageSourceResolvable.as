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

/**
 * {@code MessageSourceResolvable} is an interface for objects that are suitable for
 * message resolution in a {@link MessageSource}.
 * 
 * @author Simon Wacker
 */
interface org.as2lib.context.MessageSourceResolvable {
	
	/**
	 * Returns the codes as {@code String}s to be used to resolve this message, in the
	 * order that they shall be tried. The last code will therefore be the default one.
	 * 
	 * @return a {@code String} array of codes associated with the message to look-up
	 */
	public function getCodes(Void):Array;
	
	/**
	 * Returns the arguments that shall be used to resolve the message.
	 * 
	 * @return an array of {@code Object}s to use as parameters to replace placeholders
	 * within the message text
	 */
	public function getArguments(Void):Array;
	
	/**
	 * Returns the default message to use if the message could not been looked-up.
	 * 
	 * @return the default message or {@code null} if no default message exists
	 */
	public function getDefaultMessage(Void):String;
	
}