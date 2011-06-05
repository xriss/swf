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

import org.as2lib.env.log.Logger;
import org.as2lib.env.log.logger.AbstractLogger;
import org.as2lib.env.log.LogLevel;
import org.as2lib.env.log.message.MtascLogMessage;

import de.richinternet.utils.Dumper;

/**
 * {@code RichInternetLogger} delegates all log messages to the appropriate methods
 * of the {@code de.richinternet.utils.Dumper} class of Dirk Eisman's Flex Trace
 * Panel.
 * 
 * <p>Using this class instead of the {@code Dumper} class in your application
 * directly enables you to switch between almost every available Logging API without
 * having to change the logging calls, but just the underlying configuration on
 * startup.
 * 
 * @author Simon Wacker
 * @author Igor Sadovskiy
 * 
 * @see org.as2lib.env.log.handler.RichInternetHandler
 * @see <a href="http://www.richinternet.de/blog/index.cfm?entry=EB3BA9D6-A212-C5FA-A9B1B5DB4BB7F555">Flex Trace Panel</a>
 */
class org.as2lib.env.log.logger.RichInternetLogger extends AbstractLogger implements Logger {
	
	/** Makes the static variables of the super-class accessible through this class. */
	private static var __proto__:Object = AbstractLogger;
	
	/**
	 * Proxy trace method for MTASC that directly outputs the specified {@code message} to
	 * the Dirk Eisman's Flex Trace Panel.
	 * 
	 * <p>You can use this method as trace method for MTASC's trace support:
	 * <code>mtasc ... -trace org.as2lib.env.log.logger.RichInternetLogger.trace</code>
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
		Dumper.dump(new MtascLogMessage(message, location, fileName, lineNumber));
	}
	
	/** The set level. */
	private var level:LogLevel;
	
	/** The set level as number. */
	private var levelAsNumber:Number;
	
	/**
	 * Constructs a new {@code RichInternetLogger} instance.
	 *
	 * <p>The default log level is {@code ALL}. This means all messages regardless of
	 * their level are logged.
	 */
	public function RichInternetLogger(Void) {
		level = ALL;
		levelAsNumber = level.toNumber();
	}
	
	/**
	 * Sets the log level.
	 *
	 * <p>The log level determines which messages are logged and which are not.
	 *
	 * <p>A level of value {@code null} or {@code undefined} os interpreted as level
	 * {@code ALL} which is also the default level.
	 *
	 * @param level the new log level
	 */
	public function setLevel(level:LogLevel):Void {
		if (level) {
			this.level = level;
			levelAsNumber = level.toNumber();
		} else {
			this.level = ALL;
			levelAsNumber = level.toNumber();
		}
	}
	
	/**
	 * Returns the set level.
	 *
	 * @return the set level
	 */
	public function getLevel(Void):LogLevel {
		return level;
	}
	
	/**
	 * Checks if this logger is enabled for debug level log messages.
	 *
	 * @return {@code true} if debug messages are logged
	 * @see org.as2lib.env.log.level.AbstractLogLevel#DEBUG
	 * @see #debug
	 */
	public function isDebugEnabled(Void):Boolean {
		return (levelAsNumber >= debugLevelAsNumber);
	}
	
	/**
	 * Checks if this logger is enabled for info level log messages.
	 *
	 * @return {@code true} if info messages are logged
	 * @see org.as2lib.env.log.level.AbstractLogLevel#INFO
	 * @see #info
	 */
	public function isInfoEnabled(Void):Boolean {
		return (levelAsNumber >= infoLevelAsNumber);
	}
	
	/**
	 * Checks if this logger is enabled for warning level log messages.
	 *
	 * @return {@code true} if warning messages are logged
	 * @see org.as2lib.env.log.level.AbstractLogLevel#WARNING
	 * @see #warning
	 */
	public function isWarningEnabled(Void):Boolean {
		return (levelAsNumber >= warningLevelAsNumber);
	}
	
	/**
	 * Checks if this logger is enabled for error level log messages.
	 *
	 * @return {@code true} if error messages are logged
	 * @see org.as2lib.env.log.level.AbstractLogLevel#ERROR
	 * @see #error
	 */
	public function isErrorEnabled(Void):Boolean {
		return (levelAsNumber >= errorLevelAsNumber);
	}
	
	/**
	 * Checks if this logger is enabled for fatal level log messages.
	 *
	 * @return {@code true} if fatal messages are logged
	 * @see org.as2lib.env.log.level.AbstractLogLevel#FATAL
	 * @see #fatal
	 */
	public function isFatalEnabled(Void):Boolean {
		return (levelAsNumber >= fatalLevelAsNumber);
	}
	
	/**
	 * Logs the passed-in {@code message} at debug level.
	 *
	 * <p>The {@code message} is only logged when the level is set to {@code DEBUG} or
	 * a level above.
	 *
	 * <p>The {@code message} is logged using the {@code Dumper.trace} method.
	 *
	 * @param message the message object to log
	 * @see #isDebugEnabled
	 */
	public function debug(message):Void {
		if (isDebugEnabled()) {
			Dumper.trace(message);
		}
	}
	
	/**
	 * Logs the passed-in {@code message} object at info level.
	 *
	 * <p>The {@code message} is only logged when the level is set to {@code INFO} or
	 * a level above.
	 *
	 * <p>The {@code message} is logged using the {@code Dumper.info} method.
	 *
	 * @param message the message object to log
	 * @see #isInfoEnabled
	 */
	public function info(message):Void {
		if (isInfoEnabled()) {
			Dumper.info(message);
		}
	}
	
	/**
	 * Logs the passed-in {@code message} object at warning level.
	 *
	 * <p>The {@code message} is only logged when the level is set to {@code WARNING}
	 * or a level above.
	 *
	 * <p>The {@code message} is logged using the {@code Dumper.warn} method.
	 *
	 * @param message the message object to log
	 * @see #isWarningEnabled
	 */
	public function warning(message):Void {
		if (isWarningEnabled()) {
			Dumper.warn(message);
		}
	}
	
	/**
	 * Logs the passed-in {@code message} object at error level.
	 *
	 * <p>The {@code message} is only logged when the level is set to {@code ERROR} or
	 * a level above.
	 *
	 * <p>The {@code message} is logged using the {@code Dumper.error} method.
	 *
	 * @param message the message object to log
	 * @see #isErrorEnabled
	 */
	public function error(message):Void {
		if (isErrorEnabled()) {
			Dumper.error(message);
		}
	}
	
	/**
	 * Logs the passed-in {@code message} object at fatal level.
	 *
	 * <p>The {@code message} is only logged when the level is set to {@code FATAL} or
	 * a level above.
	 *
	 * <p>The {@code message} is logged using the {@code Dumper.error} method.
	 *
	 * @param message the message object to log
	 * @see #isFatalEnabled
	 */
	public function fatal(message):Void {
		if (isFatalEnabled()) {
			Dumper.error(message);
		}
	}
	
}