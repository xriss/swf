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

import org.as2lib.env.log.handler.AbstractLogHandler;
import org.as2lib.env.log.level.AbstractLogLevel;
import org.as2lib.env.log.LogHandler;
import org.as2lib.env.log.LogLevel;
import org.as2lib.env.log.LogMessage;
import org.as2lib.util.Stringifier;

/**
 * {@code AsdtHandler} logs messages with {@code Logger.addMessage} method.
 *   
 * @author Simon Wacker  
 * @author Igor Sadovskiy
 * @see <a href="http://www.asdt.org">AS Development Tool (ASDT)</a>
 */
class org.as2lib.env.log.handler.AsdtHandler extends AbstractLogHandler implements LogHandler {
    
    /** Holds a asdt handler. */
    private static var asdtHandler:AsdtHandler;
        
    /**
     * Returns an instance of this class.
     *
     * <p>This method always returns the same instance.
     *
     * <p>The {@code messageStringifier} argument is only recognized on first
     * invocation of this method.
     *
     * @param messageStringifier (optional) the log message stringifier to be used by
     * the returned handler
     * @return a asdt handler
     */
    public static function getInstance(messageStringifier:Stringifier):AsdtHandler {
        if (!asdtHandler) asdtHandler = new AsdtHandler(messageStringifier);
        return asdtHandler;
    }   
    
    /**
     * Constructs a new {@code AsdtHandler} instance.
     * 
     * @param messageStringifier (optional) the log message stringifier to use
     */
    public function AsdtHandler(messageStringifier:Stringifier) {
        super(messageStringifier);
    }
    
    /**
     * Writes the passed-in {@code message} to the Asdt Logger Plugin Console.
     *
     * <p>The string representation of the {@code message} to log is obtained via
     * the {@code convertMessage} method.
     *
     * @param message the message to log
     */
    public function write(message:LogMessage):Void {
        var level:Number = convertLevel(message.getLevel());
        var m:String = convertMessage(message);
        Log.addMessage(m, level, message.getSourceObject());
    }
    
    /**
     * Converts the As2lib {@code LogLevel} into a ASDT level.
     *
     * <dl>
     *   <dt>ALL</dt>
     *   <dd>Is converted to {@code Log.VERBOSE}.</dd>
     *   <dt>DEBUG</dt>
     *   <dd>Is converted to {@code Log.VERBOSE}.</dd>
     *   <dt>INFO</dt>
     *   <dd>Is converted to {@code Log.INFO}.</dd>
     *   <dt>WARNING</dt>
     *   <dd>Is converted to {@code Log.WARNING}.</dd>
     *   <dt>ERROR</dt>
     *   <dd>Is converted to {@code Log.ERROR}.</dd>
     *   <dt>FATAL</dt>
     *   <dd>Is converted to {@code Log.ERROR}.</dd>
     *   <dt>NONE</dt>
     *   <dd>Is converted to {@code Log.NONE}.</dd>
     * </dl>
     *
     * <p>If the passed-in {@code level} is none of the above, {@code null} is returned.
     *
     * @param level the As2lib log level to convert
     * @return the equivalent ASDT level number or {@code null}
     */
    private function convertLevel(level:LogLevel):Number {
        switch (level) {
            case AbstractLogLevel.ALL:
                return Log.VERBOSE;
            case AbstractLogLevel.DEBUG:
                return Log.VERBOSE;
            case AbstractLogLevel.INFO:
                return Log.INFO;
            case AbstractLogLevel.WARNING:
                return Log.WARNING;
            case AbstractLogLevel.ERROR:
                return Log.ERROR;
            case AbstractLogLevel.FATAL:
                return Log.ERROR;
            case AbstractLogLevel.NONE:
                return Log.NONE;
            default:
                return null;
        }
    }   
    
}