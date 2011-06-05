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

import org.as2lib.context.HierarchicalMessageSource;
import org.as2lib.context.MessageSource;
import org.as2lib.context.MessageSourceResolvable;
import org.as2lib.context.NoSuchMessageException;
import org.as2lib.core.BasicClass;
import org.as2lib.env.overload.Overload;
import org.as2lib.lang.Locale;

/**
 * {@code DelegatingMessageSource} delegates all message look-ups to its parent message
 * source.
 * 
 * @author Simon Wacker
 */
class org.as2lib.context.support.DelegatingMessageSource extends BasicClass implements HierarchicalMessageSource {
	
	/** This message source's parent. */
	private var parent:MessageSource;
	
	/**
	 * Constructs a new {@code DelegatingMessageSource} instance.
	 * 
	 * @param parent the parent of this message source
	 */
	public function DelegatingMessageSource(parent:MessageSource) {
		this.parent = parent;
	}
	
	public function setParentMessageSource(parent:MessageSource):Void {
		this.parent = parent;
	}

	public function getParentMessageSource(Void):MessageSource {
		return parent;
	}
	
	public function getMessage():String {
		var o:Overload = new Overload(this);
		o.addHandler([String], getMessageByCodeAndArguments);
		o.addHandler([String, Array], getMessageByCodeAndArguments);
		o.addHandler([String, Array, Locale], getMessageByCodeAndArguments);
		o.addHandler([String, Array, String], getMessageWithDefaultMessage);
		o.addHandler([String, Array, String, Locale], getMessageWithDefaultMessage);
		o.addHandler([MessageSourceResolvable], getMessageByResolvable);
		o.addHandler([MessageSourceResolvable, Locale], getMessageByResolvable);
		return o.forward(arguments);
	}
	
	public function getMessageWithDefaultMessage(code:String, args:Array, defaultMessage:String, locale:Locale):String {
		if (parent != null) {
			return parent.getMessageWithDefaultMessage(code, args, defaultMessage, locale);
		}
		else {
			return defaultMessage;
		}
	}
	
	public function getMessageByCodeAndArguments(code:String, args:Array, locale:Locale):String {
		if (parent != null) {
			return parent.getMessageByCodeAndArguments(code, args, locale);
		}
		else {
			throw new NoSuchMessageException(code, locale, this, arguments);
		}
	}
	
	public function getMessageByResolvable(resolvable:MessageSourceResolvable, locale:Locale):String {
		if (parent != null) {
			return parent.getMessageByResolvable(resolvable, locale);
		}
		else {
			if (resolvable.getDefaultMessage() != null) {
				return resolvable.getDefaultMessage();
			}
			var codes:Array = resolvable.getCodes();
			var code:String = codes != null && codes.length > 0 ? codes[0] : null;
			throw new NoSuchMessageException(code, locale, this, arguments);
		}
	}
	
}