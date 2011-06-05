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

import org.as2lib.core.BasicInterface;
import org.as2lib.env.log.LogLevel;

/**
 * {@code LogMessage} declares methods to access data containing all the information 
 * about the message to log.
 * 
 * @author Simon Wacker
 * @author Igor Sadovskiy
 */
interface org.as2lib.env.log.LogMessage extends BasicInterface {
	
	/**
	 * Returns the message object to log
	 *
	 * @return message the message object to log
	 */
	public function getMessage(Void);
	
	/**
	 * Returns the level of the message.
	 *
	 * @return the level of the message
	 */
	public function getLevel(Void):LogLevel;
	
	/**
	 * Returns the name of the logger that logs the message.
	 *
	 * @return the name of the logging logger
	 */
	public function getLoggerName(Void):String;
	
	/**
	 * Returns the number of milliseconds elapsed from 1/1/1970 until message was
	 * created.
	 *
	 * @return the number of milliseconds elapsed from 1/1/1970 until message was
	 * created.
	 */
	public function getTimeStamp(Void):Number;
	
	/**
	 * Returns the source class name.
	 * 
	 * @return the source class name
	 */
	public function getSourceClassName(Void):String;
	
	/**
	 * Returns the name of the source method of this message.
	 * 
	 * @return the name of the source method of this message
	 */
	public function getSourceMethodName(Void):String;
	
	/**
	 * Returns the method that logs this message.
	 * 
	 * @return the method that logs this message
	 */
	public function getSourceMethod(Void):Function;
	
	/**
	 * Returns the object whose method logs this message (the methods this-scope).
	 * 
	 * @return the object whose method logs this message
	 */
	public function getSourceObject(Void);
	
	/**
	 * Returns the name of the file containing the class that logs this message.
	 * 
	 * @return thre file name
	 */
	public function getFileName(Void):String;
	
	/**
	 * Returns the line number at which the log is being made.
	 * 
	 * @return the line number
	 */
	public function getLineNumber(Void):Number;
	
}