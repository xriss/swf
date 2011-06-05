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
import org.as2lib.env.log.level.AbstractLogLevel;
import org.as2lib.env.log.Logger;
import org.as2lib.env.log.LogLevel;
import org.as2lib.env.log.LogManager;
import org.as2lib.env.log.message.MtascLogMessage;
import org.as2lib.env.overload.Overload;
import org.as2lib.env.log.GenericLogger;

/**
 * {@code MtascUtil} offers support for MTASCs trace functionality that allows
 * for multiple arguments and provides information like the class name, the file
 * name and the line number.
 *
 * <p>Usage:
 * <pre>
 *   mtasc -trace org.as2lib.env.log.MtascUtil.log Test.as (...)
 * </pre>
 *
 * @author Simon Wacker
 * @author Igor Sadovskiy
 * @see <a href="http://www.mtasc.org/#trace">MTASC - Tracing facilities</a> */
class org.as2lib.env.log.MtascUtil extends BasicClass {

	/** Debug level output. */
	public static var DEBUG:Number = 2;

	/** Info level output. */
	public static var INFO:Number = 3;

	/** Warning level output. */
	public static var WARNING:Number = 4;

	/** Error level output. */
	public static var ERROR:Number = 5;

	/** Fatal level output. */
	public static var FATAL:Number = 6;

	/** Default log level to use if no level for a message to log is specified. */
	private static var defaultLevel:Number = INFO;

	/**
	 * Returns the current default log level.
	 *
	 * @return the default log level
	 */
	public static function getDefaultLevel(Void):Number {
		return defaultLevel;
	}

	/**
	 * Sets the new default log level.
	 *
	 * @param level the new default log level
	 */
	public static function setDefaultLevel(level:Number):Void {
		defaultLevel = level;
	}

	/**
	 * @overload #logByDefaultLevel
	 * @overload #logByLevel	 */
	public static function log():Void {
		var o:Overload = new Overload(eval("th" + "is"));
		o.addHandler([Object, String, String, Number], logByDefaultLevel);
		o.addHandler([Object, Number, String, String, Number], logByLevel);
		o.forward(arguments);
	}

	/**
	 * Logs the {@code message} at the level returned by the {@link #getDefaultLevel}
	 * method.
	 *
	 * @param message the message to log
	 * @param location the name of the class and method that logs the {@code message}
	 * @param fileName the name of the file that declares the class
	 * @param lineNumber the line number at which the logging call is placed
	 * @see #logByLevel	 */
	public static function logByDefaultLevel(message:Object, location:String, fileName:String, lineNumber:Number):Void {
		logByLevel(message, getDefaultLevel(), location, fileName, lineNumber);
	}

	/**
	 * Logs the {@code message} at the specified {@code level}.
	 *
	 * <p>If this level is none of the declared ones, the default level is used. This
	 * is also the case if {@code level} is {@code null} or {@code undefined}.
	 *
	 * <p>The {@code message} is logged using the logger returned by the
	 * {@link LogManager#getLogger} method passing-in the given {@code sourceClassName}.
	 * If this logger implements the {@link GenericLogger} interface, its {@code logMessage}
	 * method is invoked with a {@link MtascLogMessage} instance as argument. Otherwise
	 * the log method corresponding to the level of the log message (declared in the
	 * {@link Logger} interface) is invoked with the given {@code message}. Note that in
	 * the latter case all additional information is lost.
	 *
	 * @param message the message to log
	 * @param level the level code of the level of the message
	 * @param location the name of the class and method that logs the {@code message}
	 * @param fileName the name of the file that declares the class
	 * @param lineNumber the line number at which the logging call stands
	 * @see #getDefaultLevel	 */
	public static function logByLevel(message:Object, level:Number, location:String, fileName:String, lineNumber:Number):Void {
		var l:LogLevel = resolveLevel(level, defaultLevel);
		var m:MtascLogMessage = new MtascLogMessage(message, l, location, fileName, lineNumber);
		var logger:Logger = LogManager.getLoggerByName(m.getSourceClassName());
		if (logger instanceof GenericLogger) {
			GenericLogger(logger).logMessage(m);
		} else {
			switch (l) {
				case AbstractLogLevel.DEBUG:
					logger.debug(m.getMessage());
					break;
				case AbstractLogLevel.INFO:
					logger.info(m.getMessage());
					break;
				case AbstractLogLevel.WARNING:
					logger.warning(m.getMessage());
					break;
				case AbstractLogLevel.ERROR:
					logger.error(m.getMessage());
					break;
				case AbstractLogLevel.FATAL:
					logger.fatal(m.getMessage());
					break;
			}
		}
	}

	/**
	 * Resolves the log level for the given {@code level}. If the given level does not
	 * match any of the levels declared in {@link AbstractLogLevel}, the default level
	 * is used. If the default level does also not match any of the levels declared in
	 * {@code AbstractLogLevel}, {@link AbstractLogLevel#INFO} is returned.
	 */
	private static function resolveLevel(level:Number, defaultLevel:Number):LogLevel {
		switch (level) {
			case DEBUG:
				return AbstractLogLevel.DEBUG;
				break;
			case INFO:
				return AbstractLogLevel.INFO;
				break;
			case WARNING:
				return AbstractLogLevel.WARNING;
				break;
			case ERROR:
				return AbstractLogLevel.ERROR;
				break;
			case FATAL:
				return AbstractLogLevel.FATAL;
				break;
			default:
				if (defaultLevel == null) {
					return AbstractLogLevel.INFO;
				} else {
					return resolveLevel(defaultLevel);
				}
				break;
		}
	}

	/**
	 * Private constructor.	 */
	private function MtascUtil(Void) {
	}

}