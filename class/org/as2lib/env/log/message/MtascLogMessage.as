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
import org.as2lib.env.log.level.AbstractLogLevel;

/**
 * {@code MtascLogMessage} is a data holder that contains all information to
 * log messages using MTASC's <i>-trace</i> facility.
 * 
 * <p>The {@link #toString} method uses the set stringifier to obtain its string
 * representation. If you want a different appearance of the log message you can
 * use the static {@link #setStringifier} method to set your custom stringifier.
 *
 * <p>The {@link PatternLogMessageStringifier} supports different presentation styles.
 * It allows to switch the class name, method name and line number on and off.
 *
 * @author Simon Wacker
 * @author Igor Sadovskiy
 */
class org.as2lib.env.log.message.MtascLogMessage extends AbstractLogMessage implements LogMessage {
	
	/** The currently used stringifier. */
	private static var stringifier:Stringifier;
	
	/**
	 * Returns either the stringifier set via {@link #setStringifier} or the default
	 * MTASC stringifier which is an instance of class {@link PatternLogMessageStringifier}
	 * and uses {@link PatternLogMessageStringifier#MTASC_PATTERN} pattern.
	 *
	 * @return the currently used MTASC stringifier
	 */
	public static function getStringifier(Void):Stringifier {
		if (!stringifier) stringifier = new PatternLogMessageStringifier(PatternLogMessageStringifier.MTASC_PATTERN);
		return stringifier;
	}
	
	/**
	 * Sets a new MTASC stringifier to be used by the {@link #toString} method.
	 *
	 * <p>If {@code newStringifier} is {@code null} the {@link #getStringifier} method
	 * will return the default MTASC stringifier.
	 *
	 * @param newMtascStringifier the new MTASC stringifier to be used
	 */
	public static function setStringifier(newStringifier:Stringifier):Void {
		stringifier = newStringifier;
	}
	
	/**
	 * Constructs a new {@code MtascLogMessage} instance.
	 * 
	 * @param message the message to log
	 * @param level (optional) the level of the logging. Default is {@code AbstractLogLevel#INFO}.
	 * @param location the fully qualified class name and the method name separated by "::"
	 * @param fileName the name of the file defining the class
	 * @param lineNumber the line number at which the message was logged
	 */
	public function MtascLogMessage(message) {
		super(message);
		if (arguments[1] instanceof LogLevel) {
			this.level = arguments[1];
			setSourceClassAndMethodNames(arguments[2]);
			this.fileName = arguments[3];
			this.lineNumber = arguments[4];
		} else {
			this.level = AbstractLogLevel.INFO;
			setSourceClassAndMethodNames(arguments[1]);
			this.fileName = arguments[2];
			this.lineNumber = arguments[3];
		}
	}
	
	/**
	 * Sets the source class name and the source method name. The given class and
	 * method name must be separated by "::". This is a convenience method to split
	 * the class and method name passed to MTASC trace methods.
	 * 
	 * @param sourceClassAndMethodNames source class and method names separacted by "::"
	 */
	public function setSourceClassAndMethodNames(sourceClassAndMethodNames:String):Void {
		var names:Array = sourceClassAndMethodNames.split("::");
		sourceClassName = names[0];
		sourceMethodName = names[1];
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
