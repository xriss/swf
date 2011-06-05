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
import org.as2lib.env.reflect.ReflectUtil;
import org.as2lib.io.conn.core.ServiceProxy;
import org.as2lib.util.StringUtil;

/**
 * {@code MethodInvocationErrorInfo} informs the client of an error that occured on
 * a method invocation.
 *
 * <p>It defines constants, that can be used to identify what kind of error occured.
 *
 * <p>This class is used in conjunction with the {@link MethodInvocationCallback}
 * and {@link MethodInvocationErrorListener} classes.
 *
 * @author Simon Wacker
 */
class org.as2lib.io.conn.core.event.MethodInvocationErrorInfo extends BasicClass {

	/** Indicates an error of unknown origin. */
	public static var UNKNOWN_ERROR:String = "unknownError";

	/** Indicates an error caused because of a not existing service. */
	public static var UNKNOWN_SERVICE_ERROR:String = "unknownServiceError";

	/** Indicates that the method to invoke does not exist. */
	public static var UNKNOWN_METHOD_ERROR:String = "unknownMethodError";

	/** Indicates an error caused by arguments that are out of size. */
	public static var OVERSIZED_ARGUMENTS_ERROR:String = "oversizedArgumentsError";

	/** Indicates that the service method to invoke threw an exception. */
	public static var METHOD_EXCEPTION_ERROR:String = "methodExceptionError";

	/** The service proxy that tried to invoke the method. */
	private var serviceProxy:ServiceProxy;

	/** The name of the method to be executed. */
	private var methodName:String;

	/** The arguments used for the invocation. */
	private var methodArguments:Array;

	/** The error code describing the type of error. */
	private var errorCode:String;

	/** The error message describing the error. */
	private var errorMessage:String;

	/** The exception that caused the error. */
	private var exception;

	/**
	 * Constructs a new {@code MethodInvocationErrorInfo} instance.
	 *
	 * <p>If {@code errorCode} is {@code null} or {@code undefined}, {@link #UNKNOWN_ERROR}
	 * is used.
	 *
	 * @param serviceProxy the service proxy that tried to invoke the method
	 * @param methodName the name of the method that should be or was invoked on the service
	 * @param methodArguments the arguments used as parameters for the method invocation
	 * @param errorCode the error code indicating the type of the error
	 * @param errorMessage the message that describes the error
	 * @param exception the exception that caused the error
	 */
	public function MethodInvocationErrorInfo(serviceProxy:ServiceProxy, methodName:String, methodArguments:Array, errorCode:String, errorMessage:String, exception) {
		this.serviceProxy = serviceProxy;
		this.methodName = methodName;
		this.methodArguments = methodArguments;
		this.errorCode = errorCode == null ? UNKNOWN_ERROR : errorCode;
		this.errorMessage = errorMessage;
		this.exception = exception;
	}

	/**
	 * Returns the service proxy that tried to invoke the method that caused this error.
	 *
	 * @return the service proxy that tried to invoke the method
	 */
	public function getServiceProxy(Void):ServiceProxy {
		return serviceProxy;
	}

	/**
	 * Sets the service proxy that tried to invoke the method that caused this errir.
	 *
	 * @param serviceProxy the service proxy that tried to invoke the method
	 */
	public function setServiceProxy(serviceProxy:ServiceProxy):Void {
		this.serviceProxy = serviceProxy;
	}

	/**
	 * Returns the name of the method that caused this error.
	 *
	 * @return the name of the method that should be or was invoked on the service
	 */
	public function getMethodName(Void):String {
		return methodName;
	}

	/**
	 * Returns the arguments used as parameters for the method invocaton
	 * that caused this error.
	 *
	 * @return the arguments used as parameters for the method invocation
	 */
	public function getMethodArguments(Void):Array {
		return methodArguments;
	}

	/**
	 * Returns the error code that describes the type of this error.
	 *
	 * <p>The error code may match one of the declared error constants.
	 *
	 * @return the error code that describes the type of this error
	 */
	public function getErrorCode(Void):String {
		return errorCode;
	}

	/**
	 * Returns the error message that describes this error.
	 *
	 * @return the error message describing this error
	 */
	public function getErrorMessage(Void):String {
		return errorMessage;
	}

	/**
	 * Returns the exception that caused this error.
	 *
	 * <p>Note that this error is not always caused by an exception. This method may
	 * does also return {@code null}.
	 *
	 * @return the exception that caused this error or {@code null}
	 */
	public function getException(Void) {
		return exception;
	}

	public function toString():String {
		var result:String = "MethodInvocationErrorInfo(";
		if (serviceProxy != null) {
			result += "\n" + StringUtil.addSpaceIndent(serviceProxy.toString(), 2);
		}
		if (methodName != null) {
			result += "\n  " + methodName + "(";
			if (methodArguments != null) {
				for (var i:Number = 0; i < methodArguments.length; i++) {
					var argument = methodArguments[i];
					result += ReflectUtil.getTypeNameForInstance(argument);
					if (i < methodArguments.length - 1) {
						result += ", ";
					}
				}
			}
			result += ")";
		}
		if (errorCode != null) {
			result += "\n  " + errorCode;
			if (errorMessage != null) {
				result += ": " + errorMessage;
			}
		}
		else if (errorMessage != null) {
			result += "\n  " + errorMessage;
		}
		result += "\n)";
		return result;
	}

}