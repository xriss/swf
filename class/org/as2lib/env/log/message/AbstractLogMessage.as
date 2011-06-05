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
import org.as2lib.env.log.LogLevel;

/**
 * {@code AbstractLogMessage} is a dumb data holder that contains all the information about
 * the message to log.
 * 
 * <p>These information are the message to log, its level and the name of the
 * logger that is responsible for logging the message.
 * 
 * @author Simon Wacker
 * @author Igor Sadovskiy
 */
class org.as2lib.env.log.message.AbstractLogMessage extends BasicClass {
	
	/** The message object to log. */
	private var message;
	
	/** The level the of the log message. */
	private var level:LogLevel;
	
	/** The name of the logger that logs the message. */
	private var loggerName:String;
	
	/** The number of milliseconds elapsed from 1/1/1970 until log message was created. */
	private var timeStamp:Number;
	
	/** The name of the source class. */
	private var sourceClassName:String;
	
	/** The object whose method that logs this message (the method's this-scope). */
	private var sourceObject;
	
	/** The name of the source method of this message. */
	private var sourceMethodName:String;
	
	/** The method that logs this message. */
	private var sourceMethod:Function;
	
	/** The name of the file containing the class that logs this message. */
	private var fileName:String;
	
	/** The line number in the file where the log is being made. */
	private var lineNumber:Number;
	
	/**
	 * Constructs an abstract {@code LogMessage} instance.
	 * 
	 * <p>If {@code timeStamp} is {@code null} or {@code undefined} this constructor
	 * sets it by itself using the current time.
	 *
	 * @param message the message object to log
	 * @param timeStamp the number of milliseconds elapsed from 1/1/1970 until this
	 * message was created
	 */
	private function AbstractLogMessage(message, timeStamp:Number) {
		this.message = message;
		// new Date().getTime() is not mtasc compatible
		this.timeStamp = timeStamp == null ? (new Date()).getTime() : timeStamp;
	}
	
	/**
	 * Returns the message object to log
	 *
	 * @return message the message object to log
	 */
	public function getMessage(Void) {
		return message;
	}
	
	/**
	 * Returns the level of the message.
	 *
	 * @return the level of the message
	 */
	public function getLevel(Void):LogLevel {
		return level;
	}
	
	/**
	 * Returns the name of the logger that logs the message.
	 *
	 * @return the name of the logging logger
	 */
	public function getLoggerName(Void):String {
		return loggerName;
	}
	
	/**
	 * Returns the number of milliseconds elapsed from 1/1/1970 until message was
	 * created.
	 *
	 * @return the number of milliseconds elapsed from 1/1/1970 until message was
	 * created.
	 */
	public function getTimeStamp(Void):Number {
		return timeStamp;
	}
		
	/**
	 * Returns the source class name.
	 * 
	 * @return the source class name
	 */
	public function getSourceClassName(Void):String {
		return sourceClassName;
	}
	
	/**
	 * Sets the name of the source class.
	 * 
	 * @param sourceClassName the name of the source class
	 */
	public function setSourceClassName(sourceClassName:String):Void {
		this.sourceClassName = sourceClassName;
	}
	
	/**
	 * Returns the name of the source method of this message.
	 * 
	 * @return the name of the source method of this message
	 */
	public function getSourceMethodName(Void):String {
		return sourceMethodName;
	}
	
	/**
	 * Sets the name of the source method.
	 * 
	 * @param sourceMethodName the name of the source method
	 */
	public function setSourceMethodName(sourceMethodName:String):Void {
		this.sourceMethodName = sourceMethodName;
	}
	
	/**
	 * Returns the method that logs this message.
	 * 
	 * @return the method that logs this message
	 */
	public function getSourceMethod(Void):Function {
		return sourceMethod;
	}
	
	/**
	 * Returns the object whose method logs this message (the methods this-scope).
	 * 
	 * @return the object whose method logs this message
	 */
	public function getSourceObject(Void) {
		return sourceObject;
	}
	
	/**
	 * Sets the source object.
	 * 
	 * @param sourceObject the source object
	 */
	public function setSourceObject(sourceObject):Void {
		this.sourceObject = sourceObject;
	}
	
	/**
	 * Returns the name of the file containing the class that logs this message.
	 * 
	 * @return thre file name
	 */
	public function getFileName(Void):String {
		return fileName;
	}
	
	/**
	 * Sets the name of the file containing the class that logs this message.
	 * 
	 * @param fileName the file name
	 */
	public function setFileName(fileName:String):Void {
		this.fileName = fileName;
	}
	
	/**
	 * Returns the line number at which the log is being made.
	 * 
	 * @return the line number
	 */
	public function getLineNumber(Void):Number {
		return lineNumber;
	}
	
	/**
	 * Sets the line number at which the log is being made.
	 * 
	 * @param lineNumber the line number
	 */
	public function setLineNumber(lineNumber:Number):Void {
		this.lineNumber = lineNumber;
	}
		
}