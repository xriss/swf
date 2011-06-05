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

import mx.services.Log;
import mx.services.PendingCall;
import mx.services.SOAPFault;
import mx.services.WebService;

import org.as2lib.env.except.IllegalArgumentException;
import org.as2lib.io.conn.core.client.AbstractClientServiceProxy;
import org.as2lib.io.conn.core.client.ClientServiceProxy;
import org.as2lib.io.conn.core.event.MethodInvocationCallback;
import org.as2lib.io.conn.core.event.MethodInvocationReturnInfo;
import org.as2lib.io.conn.webservice.WebServiceMethodInvocationErrorInfo;

/**
 * {@code WebServiceProxy} handles client requests to a certain SOAP-based web
 * service and its responses.
 *
 * @author Simon Wacker
 */
class org.as2lib.io.conn.webservice.WebServiceProxy extends AbstractClientServiceProxy
		implements ClientServiceProxy {

	private var service:WebService;

	private var wsdlUri:String;

	private var proxyUri:String;

	private var endpointProxyUri:String;

	private var serviceName:String;

	private var portName:String;

	/**
	 * Constructs a new {@code WebServiceProxy} instance.
	 *
	 * @param wsdlUri the location of the WSDL document of the web service
	 * @param logger the logger to send debugging messages to
	 * @param proxyUri
	 * @param endpointProxyUri the location of the web service
	 * @param serviceName the name of the service within the WSDL document to use
	 * @param portName the port within the WSDL document to use
	 */
	public function WebServiceProxy(wsdlUri:String, logger:Log, proxyUri:String,
			endpointProxyUri:String, serviceName:String, portName:String) {
		this.wsdlUri = wsdlUri;
		this.proxyUri = proxyUri;
		this.endpointProxyUri = endpointProxyUri;
		this.serviceName = serviceName;
		this.portName = portName;
		service = new WebService(wsdlUri, logger, proxyUri, endpointProxyUri, serviceName, portName);
	}

	/**
	 * Returns the location of the WSDL document of the web service.
	 */
	public function getWsdlUri(Void):String {
		return wsdlUri;
	}

	public function getProxyUri(Void):String {
		return proxyUri;
	}

	/**
	 * Returns the location of the web service.
	 */
	public function getEndpointProxyUri(Void):String {
		return endpointProxyUri;
	}

	/**
	 * Returns the name of the service within the WSDL document.
	 */
	public function getServiceName(Void):String {
		return serviceName;
	}

	/**
	 * Returns the port within the WSDL document.
	 */
	public function getPortName(Void):String {
		return portName;
	}

	public function invokeByNameAndArgumentsAndCallback(methodName:String, args:Array,
			callback:MethodInvocationCallback):MethodInvocationCallback {
		if (methodName == null) {
			throw new IllegalArgumentException("Argument 'methodName' [" + methodName +
					"] must not be 'null' nor 'undefined'", this, arguments);
		}
		if (args == null) {
			args = new Array();
		}
		if (callback == null) {
			callback = getBlankMethodInvocationCallback();
		}
		var pc:PendingCall = service[methodName].apply(service, args);
		pc.onResult = function(result):Void {
			callback.onReturn(new MethodInvocationReturnInfo(this, methodName, args, result));
		};
		pc.onFault = function(fault:SOAPFault):Void {
			callback.onError(new WebServiceMethodInvocationErrorInfo(this, methodName, args,
					fault.faultcode, fault.faultstring, fault.detail, fault.element,
					fault.faultactor));
		};
		return callback;
	}

}