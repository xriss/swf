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
 * limitations under the License.
 */

import org.as2lib.core.BasicClass;
import org.as2lib.env.log.Logger;

/**
 * {@code AsdtLogger} provides support for the ASDT Eclipse Plugin's 
 * logger console.
 * 
 * {@code AsdtLogger} delegates all messages to the {@code Log.addMessage} method.
 * 
 * <p>Using this class instead of the {@code Log} class in your application
 * directly enables you to switch between almost every available Logging API without
 * having to change the logging calls but just the configuration on startup.
 *
 * <p>Every global configuration must be done via the static methods on the
 * {@code Log} class itself.
 * 
 * @author Simon Wacker
 * @author Igor Sadovskiy
 * 
 * @see org.as2lib.env.log.handler.AsdtHandler
 * @see <a href="http://www.asdt.org">AS Development Tool (ASDT)</a>
 */
class org.as2lib.env.log.logger.AsdtLogger extends BasicClass implements Logger {
	
	/**
	 * Indicates that all messages shall be logged. This level is equivalent to the
	 * ASDT logger {@code VERBOSE} level.
	 */
	public static var ALL:Number = Log.VERBOSE;
	
	/**
	 * Indicates that all messages at debug and higher levels shall be logged. This
	 * level is equivalent to the ASDT logger {@code VERBOSE} level.
	 */
	public static var DEBUG:Number = Log.VERBOSE;
	
	/**
	 * Indicates that all messages at info and higher levels shall be logged. This
	 * level is equivalent to the ASDT logger {@code INFO} level.
	 */
	public static var INFO:Number = Log.INFO;
	
	/**
	 * Indicates that all messages at warning and higher levels shall be logged. This
	 * level is equivalent to the ASDT logger {@code WARNING} level.
	 */
	public static var WARNING:Number = Log.WARNING;
	
	/**
	 * Indicates that all messages at error and higher levels shall be logged. This
	 * level is equivalent to the ASDT logger {@code ERROR} level.
	 */
	public static var ERROR:Number = Log.ERROR;
	
	/**
	 * Indicates that all messages at fatal and higher levels shall be logged. This
	 * level is equivalent to the ASDT logger {@code ERROR} level.
	 */
	public static var FATAL:Number = Log.ERROR;
	
	/**
	 * Indicates that no messages shall be logged; logging shall be turned off. This
	 * level is equivalent to the ASDT logger {@code NONE} level.
	 */
	public static var NONE:Number = Log.NONE;
	
	/**
	 * Proxy trace method for MTASC that directly outputs the specified {@code message} to
	 * the ASDT logger console.
	 * 
	 * <p>You can use this method as trace method for MTASC's trace support:
	 * <code>mtasc ... -trace org.as2lib.env.log.logger.AsdtLogger.trace</code>
	 * 
	 * @param message the message to log
	 * @param location the fully qualified name of the class and method which invoked the
	 * {@code trace} method separated by "::"
	 * @param fileName the name of the source file which defines the class and method
	 * which called the {@code trace} method
	 * @param lineNumber the line number in the file at which the {@code trace} method was
	 * called
	 */
	public static function trace(message, location:String, fileName:String, lineNumber:Number):Void {
		Log.addMessage(message, ALL, location, fileName, lineNumber);
	}
	
	/** The name of this logger. */
	private var name:String;
	
	/** The set level as number. */
	private var level:Number;
	
	/** Debug level. */
	private var debugLevel:Number;
	
	/** Info level. */
	private var infoLevel:Number;
	
	/** Warn level. */
	private var warningLevel:Number;
	
	/** Error level. */
	private var errorLevel:Number;
	
	/** Fatal level. */
	private var fatalLevel:Number;
	
	/**
	 * Constructs a new {@code AsdtLogger} instance.
	 *
	 * <p>The default log level is {@code ALL}. This means all messages regardless of
	 * their level are logged.
	 *
	 *<p>The name is used as class name for the {@code Log.addMessage} method, if
	 * the passed class name is {@code null} or {@code undefined}.
	 * 
	 * @param name (optional) the name of this logger
	 */
	public function AsdtLogger(name:String) {
		this.name = name;
		this.level = ALL;
		this.debugLevel = DEBUG;
		this.infoLevel = INFO;
		this.warningLevel = WARNING;
		this.errorLevel = ERROR;
		this.fatalLevel = FATAL;
	}
	
	/**
	 * Returns the name of this logger.
	 *
	 * <p>This method returns {@code null} if no name has been set via the
	 * {@link #setName} method nor on construction.
	 *
	 * @return the name of this logger
	 */
	public function getName(Void):String {
		return name;
	}
	
	/**
	 * Sets the name of this logger.
	 *
	 * <p>The name is used as class name for the {@code Log.addMessage} method, if
	 * the passed class name is {@code null} or {@code undefined}.
	 * 
	 * @param name the new name of this logger
	 */
	public function setName(name:String):Void {
		this.name = name;
	}
	
	/**
	 * Sets the log level.
	 *
	 * <p>The log level determines which messages are logged and which are not.
	 *
	 * <p>A level of value {@code null} or {@code undefined} is interpreted as level
	 * {@code ALL} which is also the default level.
	 *
	 * @param level the new log level
	 */
	public function setLevel(level:Number):Void {
		if (level == null) {
			this.level = ALL;
		} else {
			this.level = level;
		}
	}
	
	/**
	 * Returns the set level.
	 *
	 * @return the set level
	 */
	public function getLevel(Void):Number {
		return this.level;
	}
	
	/**
	 * Checks whether this logger is enabled for the passed-in {@code level}.
	 *
	 * <p>{@code false} will be returned if:
	 * <ul>
	 *   <li>This logger is not enabled for the passed-in {@code level}.</li>
	 *   <li>The passed-in {@code level} is {@code null} or {@code undefined}.</li>
	 * </ul>
	 *
	 * @param level the level to make the check upon
	 * @return {@code true} if this logger is enabled for the given {@code level} else
	 * {@code false}
	 * @see #log
	 */
	public function isEnabled(level:Number):Boolean {
		if (!level) return false;
		return (this.level >= level);
	}
	
	/**
	 * Checks if this logger is enabled for debug level log messages.
	 *
	 * @return {@code true} if debug messages are logged
	 * @see #debug
	 */
	public function isDebugEnabled(Void):Boolean {
		return (this.level >= this.debugLevel);
	}
	
	/**
	 * Checks if this logger is enabled for info level log messages.
	 *
	 * @return {@code true} if info messages are logged
	 * @see #info
	 */
	public function isInfoEnabled(Void):Boolean {
		return (this.level >= this.infoLevel);
	}
	
	/**
	 * Checks if this logger is enabled for warning level log messages.
	 * 
	 * @return {@code true} if warning messages are logged
	 * @see #warning
	 */
	public function isWarningEnabled(Void):Boolean {
		return (this.level >= this.warningLevel);
	}
	
	/**
	 * Checks if this logger is enabled for error level log messages.
	 * 
	 * @return {@code true} if error messages are logged
	 * @see #error
	 */
	public function isErrorEnabled(Void):Boolean {
		return (this.level >= this.errorLevel);
	}
	
	/**
	 * Checks if this logger is enabled for fatal level log messages.
	 * 
	 * @return {@code true} if fatal messages are logged
	 * @see #fatal
	 */
	public function isFatalEnabled(Void):Boolean {
		return (this.level >= this.fatalLevel);
	}
	
	/**
	 * Logs the passed-in {@code message} at the given {@code level}.
	 *
	 * <p>The {@code message} is only logged when this logger is enabled for the
	 * passed-in {@code level}.
	 *
	 * <p>The {@code message} is always logged using {@code Log.addMessage} passing
	 * at least the arguments {@code message} and {@code level} and {@code className},
	 * {@code fileName} and {@code lineNumber} if specified.
	 * 
	 * <p>If {@code className} is {@code null} or {@code undefined}, the name of this
	 * logger is used instead.
	 *
	 * @param message the message object to log
	 * @param level the specific level at which the {@code message} shall be logged
	 * @param className (optional) the name of the class that logs the {@code message}
	 * @param fileName (optional) the name of the file that declares the class
	 * @param lineNumber (optional) the line number at which the logging call stands
	 * @see #isEnabled
	 */
	public function log(message, level:Number):Void {
		if (isEnabled(level)) {
			var className:String = (arguments[2] != null) ? arguments[2] : this.name;
			Log.addMessage(message, level, className, arguments[3], arguments[4]);
		}
	}
	
	/**
	 * Logs the passed-in {@code message} at debug level.
	 *
	 * <p>The {@code message} is only logged when the level is set to {@code DEBUG} or
	 * a level above.
	 *
	 * <p>The {@code message} is always logged using {@code Log.addMessage} passing
	 * at least the arguments {@code message}, the debug level and {@code className},
	 * {@code fileName} and {@code lineNumber} if specified.
	 * 
	 * <p>If {@code className} is {@code null} or {@code undefined}, the name of this
	 * logger is used instead.
	 *
	 * @param message the message object to log
	 * @param className (optional) the name of the class that logs the {@code message}
	 * @param fileName (optional) the name of the file that declares the class
	 * @param lineNumber (optional) the line number at which the logging call stands
	 * @see #isDebugEnabled
	 */
	public function debug(message):Void {
		if (isDebugEnabled()) {
			var className:String = (arguments[1] != null) ? arguments[1] : this.name;
			Log.addMessage(message, this.debugLevel, className, arguments[2], arguments[3]);
		}
	}
	
	/**
	 * Logs the passed-in {@code message} at info level.
	 *
	 * <p>The {@code message} is only logged when the level is set to {@code INFO} or
	 * a level above.
	 *
	 * <p>The {@code message} is always logged using {@code Log.addMessage} passing
	 * at least the arguments {@code message}, the info level and {@code className},
	 * {@code fileName} and {@code lineNumber} if specified.
	 * 
	 * <p>If {@code className} is {@code null} or {@code undefined}, the name of this
	 * logger is used instead.
	 *
	 * @param message the message object to log
	 * @param className (optional) the name of the class that logs the {@code message}
	 * @param fileName (optional) the name of the file that declares the class
	 * @param lineNumber (optional) the line number at which the logging call stands
	 * @see #isInfoEnabled
	 */
	public function info(message):Void {
		if (isInfoEnabled()) {
			var className:String = (arguments[1] != null) ? arguments[1] : this.name;
			Log.addMessage(message, this.infoLevel, className, arguments[2], arguments[3]);
		}
	}
	
	/**
	 * Logs the passed-in {@code message} at warning level.
	 *
	 * <p>The {@code message} is only logged when the level is set to {@code WARNING}
	 * or a level above.
	 *
	 * <p>The {@code message} is always logged using {@code Log.addMessage} passing
	 * at least the arguments {@code message}, the warning level and {@code className},
	 * {@code fileName} and {@code lineNumber} if specified.
	 * 
	 * <p>If {@code className} is {@code null} or {@code undefined}, the name of this
	 * logger is used instead.
	 *
	 * @param message the message object to log
	 * @param className (optional) the name of the class that logs the {@code message}
	 * @param fileName (optional) the name of the file that declares the class
	 * @param lineNumber (optional) the line number at which the logging call stands
	 * @see #isWarningEnabled
	 */
	public function warning(message):Void {
		if (isWarningEnabled()) {
			var className:String = (arguments[1] != null) ? arguments[1] : this.name;
			Log.addMessage(message, this.warningLevel, className, arguments[2], arguments[3]);
		}
	}
	
	/**
	 * Logs the passed-in {@code message} at error level.
	 *
	 * <p>The {@code message} is only logged when the level is set to {@code ERROR} or
	 * a level above.
	 *
	 * <p>The {@code message} is always logged using {@code Log.addMessage} passing
	 * at least the arguments {@code message}, the error level and {@code className},
	 * {@code fileName} and {@code lineNumber} if specified.
	 * 
	 * <p>If {@code className} is {@code null} or {@code undefined}, the name of this
	 * logger is used instead.
	 *
	 * @param message the message object to log
	 * @param className (optional) the name of the class that logs the {@code message}
	 * @param fileName (optional) the name of the file that declares the class
	 * @param lineNumber (optional) the line number at which the logging call stands
	 * @see #isErrorEnabled
	 */
	public function error(message):Void {
		if (isErrorEnabled()) {
			var className:String = (arguments[1] != null) ? arguments[1] : this.name;
			Log.addMessage(message, this.errorLevel, className, arguments[2], arguments[3]);
		}
	}
	
	/**
	 * Logs the passed-in {@code message} at fatal level.
	 * 
	 * <p>The {@code message} is only logged when the level is set to {@code FATAL} or
	 * a level above.
	 * 
	 * <p>The {@code message} is always logged using {@code Log.addMessage} passing
	 * at least the arguments {@code message}, the fatal level and {@code className},
	 * {@code fileName} and {@code lineNumber} if specified.
	 * 
	 * <p>If {@code className} is {@code null} or {@code undefined}, the name of this
	 * logger is used instead.
	 * 
	 * @param message the message object to log
	 * @param className (optional) the name of the class that logs the {@code message}
	 * @param fileName (optional) the name of the file that declares the class
	 * @param lineNumber (optional) the line number at which the logging call stands
	 * @see #isFatalEnabled
	 */
	public function fatal(message):Void {
		if (isFatalEnabled()) {
			var className:String = (arguments[1] != null) ? arguments[1] : this.name;
			Log.addMessage(message, this.fatalLevel, className, arguments[2], arguments[3]);
		}
	}
	
}