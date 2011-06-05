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
import org.as2lib.env.log.LogHandler;
import org.as2lib.env.log.LogMessage;
import org.as2lib.util.Stringifier;

/**
 * {@code CacheLogHandler} caches all log messages. You can retrieve cached messages
 * via the {@link #getMessages} method.
 *
 * @author Simon Wacker
 */
class org.as2lib.env.log.handler.CacheLogHandler extends AbstractLogHandler implements LogHandler {

	/** Maximum size of this cache. */
	private var cacheSize:Number;

	/** Cached {@code LogMessage} instances. */
	private var messages:Array;

	/**
	 * Constructs a new {@code CacheLogHandler} instance.
	 *
	 * @param cacheSize the maximum size of this cache (maximum amount of messages to
	 * cache); default is infinite (used when {@code cacheSize} is {@code null} or
	 * {@code undefined}, or less than or equal to {@code 0})
	 * @param messageStringifier the message stringifier to stringify messages with
	 */
	public function CacheLogHandler(cacheSize:Number, messageStringifier:Stringifier) {
		super(messageStringifier);
		this.cacheSize = cacheSize != null && cacheSize > 0 ? cacheSize : Infinity;
		messages = new Array();
	}

	/**
	 * Returns the maximum size of this cache (maximum amount of cached messages).
	 */
	public function getCacheSize(Void):Number {
		return cacheSize;
	}

	/**
	 * Returns the latest message.
	 */
	public function getLatestMessage(Void):LogMessage {
		return messages[messages.length - 1];
	}

	/**
	 * Returns all cached {@code LogMessage} instances. The latest messages are at the
	 * end and the oldest at the beginning of the returned array.
	 *
	 * @return all cached log messages
	 */
	public function getMessages(Void):Array {
		return messages.concat();
	}

	/**
	 * Returns the string representation of all added messages. The latest message is
	 * at the end of the returned string and the oldest at the beginning.
	 *
	 * @see #convertMessage
	 */
	public function stringifyMessages(Void):String {
		var result:String = "";
		for (var i:Number = 0; i < messages.length; i++) {
			if (i > 0) {
				result += "\n";
			}
			result += convertMessage(messages[i]);
		}
		return result;
	}

	/**
	 * Adds the given message to the local cache (removes the oldest message if the
	 * local cache is full).
	 */
	public function write(message:LogMessage):Void {
		messages.push(message);
		if (messages.length > cacheSize) {
			messages.shift();
		}
	}

}