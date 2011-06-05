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

import org.as2lib.io.conn.core.event.MethodInvocationErrorInfo;
import org.as2lib.io.conn.core.ServiceProxy;

/**
 * {@code RemotingMethodInvocationErrorInfo} gives details about errors that occurred
 * on remote method invocations.
 *
 * @author Simon Wacker
 */
class org.as2lib.io.conn.remoting.RemotingMethodInvocationErrorInfo extends MethodInvocationErrorInfo {

	private var detail:String;

	private var description:String;

	private var type:String;

	/**
	 * Constructs a new {@code RemotingMethodInvocationErrorInfo} instance.
	 *
	 * <p>If {@code errorCode} is {@code null} or {@code undefined}, {@link #UNKNOWN_ERROR}
	 * is used.
	 *
	 * @param serviceProxy the service proxy that tried to invoke the method
	 * @param methodName the name of the method that should be or was invoked on the service
	 * @param methodArguments the arguments used as parameters for the method invocation
	 * @param errorCode the error code indicating the type of the error
	 * @param errorMessage the message that describes the error
	 * @param detail the detail information provided by the remote service
	 * @param description the description of the error provided by the remote service
	 * @param type the type information provided by the remote service
	 */
	public function RemotingMethodInvocationErrorInfo(serviceProxy:ServiceProxy,
			methodName:String, methodArguments:Array, errorCode:String, errorMessage:String,
			detail:String, description:String, type:String) {
		super(serviceProxy, methodName, methodArguments, errorCode, errorMessage);
		this.detail = detail;
		this.description = description;
		this.type = type;
	}

	/**
	 * Returns the detail information provided by the remote service.
	 */
	public function getDetail(Void):String {
		return detail;
	}

	/**
	 * Returns the description of the error provided by the remote service.
	 */
	public function getDescription(Void):String {
		return description;
	}

	/**
	 * Returns the type information provided by the remote service.
	 */
	public function getType(Void):String {
		return type;
	}

}