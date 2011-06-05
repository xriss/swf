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

import org.as2lib.env.log.LogLevel;
import org.as2lib.env.log.LogMessage;
import org.as2lib.env.log.message.AbstractLogMessage;
import org.as2lib.env.log.stringifier.PatternLogMessageStringifier;
import org.as2lib.util.Stringifier;

/**
 * {@code SimpleLogMessage} is a simple data holder that is used to log messages
 * in As2Lib-native way (using loggers and log handlers).
 * 
 * <p>The {@link #toString} method uses the set stringifier to obtain its string
 * representation. If you want a different appearance of the log message you can
 * use the static {@link #setStringifier} method to set your custom stringifier.
 *
 * <p>The {@link PatternLogMessageStringifier} supports different presentation styles.
 * It allows to switch the log level, the logger name and the time on and off.
 *
 * @author Simon Wacker
 * @author Igor Sadovskiy
 */
class org.as2lib.env.log.message.SimpleLogMessage extends AbstractLogMessage implements LogMessage {
	
	/** The currently used stringifier. */
	private static var stringifier:Stringifier;
	
	/**
	 * Returns either the stringifier set via {@link #setStringifier} or the default
	 * one which is an instance of class {@link PatternLogMessageStringifier}.
	 *
	 * @return the currently used stringifier
	 */
	public static function getStringifier(Void):Stringifier {
		if (!stringifier) stringifier = new PatternLogMessageStringifier();
		return stringifier;
	}
	
	/**
	 * Sets a new stringifier to be used by the {@link #toString} method.
	 *
	 * <p>If {@code newStringifier} is {@code null} the {@link #getStringifier} method
	 * will return the default stringifier.
	 *
	 * @param newStringifier the new stringifier to be used
	 */
	public static function setStringifier(newStringifier:Stringifier):Void {
		stringifier = newStringifier;
	}
	
	/**
	 * Constructs a new {@code SimpleLogMessage} instance.
	 * 
	 * @param message the message object to log
	 * @param level the level of the passed-in {@code message}
	 * @param loggerName the name of the logger that logs the {@code message}
	 * @param timeStamp the number of milliseconds elapsed from 1/1/1970 until this
	 * message was created
	 * @param sourceMethod the method that logs this message
	 * @param sourceObject the object of the logging method
	 */
	public function SimpleLogMessage(message, level:LogLevel, loggerName:String, timeStamp:Number, sourceMethod:Function, sourceObject) {
		super(message, timeStamp);
		this.level = level;
		this.loggerName = loggerName;
		this.sourceMethod = sourceMethod;
		this.sourceObject = sourceObject;
	}
	
	/**
	 * Uses the stringifier returned by the static {@link #getStringifier} method
	 * to stringify this instance.
	 *
	 * @return the string representation of this log message
	 */
	public function toString():String {
		return getStringifier().execute(this);
	}
	
}