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

import org.as2lib.context.ApplicationContext;
import org.as2lib.context.ApplicationContextAware;
import org.as2lib.context.ApplicationEventPublisher;
import org.as2lib.context.event.ErrorEvent;
import org.as2lib.context.event.SuccessEvent;
import org.as2lib.core.BasicClass;
import org.as2lib.env.log.Logger;
import org.as2lib.env.log.LogManager;
import org.as2lib.io.conn.core.event.MethodInvocationCallback;
import org.as2lib.io.conn.core.event.MethodInvocationErrorInfo;
import org.as2lib.io.conn.core.event.MethodInvocationReturnInfo;
import org.as2lib.util.StringUtil;

/**
 * {@code ContextMethodInvocationCallback} is a simple method invocation callback
 * designed to be used in an application context, that publishes {@link ErrorEvent}
 * or {@link SuccessEvent} instances with the given error code and success code
 * respectively.
 *
 * @author Simon Wacker
 */
class org.as2lib.io.conn.core.event.ContextMethodInvocationCallback extends BasicClass
		implements MethodInvocationCallback, ApplicationContextAware {

	//private static var logger:Logger = LogManager.getLogger("org.as2lib.io.conn.core.event.ContextMethodInvocationCallback");

	private var applicationContext:ApplicationContext;

	private var eventPublisher:ApplicationEventPublisher;

	private var code:String;

	private var errorCode:String;

	private var successCode:String;

	private var errorEventClass:Function;

	private var successEventClass:Function;

	/**
	 * Constructs a new {@code ContextMethodInvocationCallback} instance with error and
	 * success codes.
	 *
	 * @param errorCode the error code to use
	 * @param successCode the success code to use
	 */
	public function ContextMethodInvocationCallback(errorCode:String, successCode:String) {
		this.errorCode = errorCode;
		this.successCode = successCode;
		errorEventClass = ErrorEvent;
		successEventClass = SuccessEvent;
	}

	/**
	 * Returns the code used for publishing success or error events.
	 *
	 * @return the code
	 */
	public function getCode(Void):String {
		return code;
	}

	/**
	 * Sets the code to use for publishing success and error events.
	 *
	 * <p>Note that on error events the used error code will be the prefix "error."
	 * plus the given {@code code}. On success events the prefix "success." is used.
	 *
	 * @param code the code for publishing events
	 * @see #setSuccessCode
	 * @see #setErrorCode
	 */
	public function setCode(code:String):Void {
		this.code = code;
	}

	/**
	 * Returns the error code used for publishing error events.
	 *
	 * @return the error code
	 */
	public function getErrorCode(Void):String {
		if (errorCode == null) {
			return (ErrorEvent.ERROR_CODE_PREFIX + "." + code);
		}
		return errorCode;
	}

	/**
	 * Sets the error code to use for publishing error events.
	 *
	 * @param errorCode the error code
	 */
	public function setErrorCode(errorCode:String):Void {
		this.errorCode = errorCode;
	}

	/**
	 * Returns the success code used for publishing success events.
	 *
	 * @return the success code
	 */
	public function getSuccessCode(Void):String {
		if (successCode == null) {
			return (SuccessEvent.SUCCESS_CODE_PREFIX + "." + code);
		}
		return successCode;
	}

	/**
	 * Sets the success code to use for publishing success events.
	 *
	 * @param successCode the success code
	 */
	public function setSuccessCode(successCode:String):Void {
		this.successCode = successCode;
	}

	/**
	 * Sets the error event class to use. This event class will be instantiated when
	 * an error occurred and the constructor will be passed the error code and
	 * application context. The error event instance will then be published.
	 *
	 * @param errorEventClass the error event class to use on errors
	 */
	public function setErrorEventClass(errorEventClass:Function):Void {
		this.errorEventClass = errorEventClass;
	}

	/**
	 * Sets the success event class to use. This event class will be instantiated when
	 * the method invocation returned successfully and the constructor will be passed
	 * the success code and application context. The success event instance will then
	 * be published.
	 *
	 * @param successEventClass the success event class to use on successful returns
	 */
	public function setSuccessEventClass(successEventClass:Function):Void {
		this.successEventClass = successEventClass;
	}

	public function setApplicationContext(applicationContext:ApplicationContext):Void {
		this.applicationContext = applicationContext;
		this.eventPublisher = applicationContext.getEventPublisher();
	}

	/**
	 * Publishes a success event. The success event will contain the success code.
	 *
	 * @param returnInfo the return info of the method invocation
	 * @see SuccessEvent
	 */
	public function onReturn(returnInfo:MethodInvocationReturnInfo):Void {
		/*if (logger.isDebugEnabled()) {
			logger.debug("Method invocation returned successfully:\n" +
					StringUtil.addSpaceIndent(returnInfo.toString(), 2));
		}*/
		var event:SuccessEvent = new successEventClass(getSuccessCode(), applicationContext);
		eventPublisher.publishEvent(event);
	}

	/**
	 * Publishes an error event. The error event will contain the error code.
	 *
	 * @param errorInfo the error info of the method invocation
	 * @see ErrorEvent
	 */
	public function onError(errorInfo:MethodInvocationErrorInfo):Void {
		/*if (logger.isErrorEnabled()) {
			logger.error("Method invocation failed:\n" +
					StringUtil.addSpaceIndent(errorInfo.toString(), 2));
		}*/
		var event:ErrorEvent = new errorEventClass(getErrorCode(), applicationContext);
		eventPublisher.publishEvent(event);
	}

}