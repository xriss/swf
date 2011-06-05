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

import org.as2lib.bean.factory.FactoryBean;
import org.as2lib.bean.factory.InitializingBean;
import org.as2lib.env.reflect.InvocationHandler;
import org.as2lib.io.conn.core.client.ClientServiceProxyFactoryBean;
import org.as2lib.io.conn.webservice.WebServiceProxy;

/**
 * {@code WebServiceProxyFactoryBean} creates a {@link WebServiceProxy} instance
 * and initializes it with a given configuration. The created proxy is stored
 * and returned on every {@link #getObject} invocation.
 *
 * @author Simon Wacker
 */
class org.as2lib.io.conn.webservice.WebServiceProxyFactoryBean extends ClientServiceProxyFactoryBean {

	private var wsdlUri:String;

	private var proxyUri:String;

	private var endpointProxyUri:String;

	private var serviceName:String;

	private var portName:String;

	private var logger:Log;

	/**
	 * Constructs a new {@code WebServiceProxyFactoryBean} instance.
	 */
	public function WebServiceProxyFactoryBean(Void) {
	}

	public function afterPropertiesSet(Void):Void {
		serviceProxy = new WebServiceProxy(wsdlUri, logger, proxyUri, endpointProxyUri, serviceName, portName);
		super.afterPropertiesSet();
	}

	public function getWsdlUri(Void):String {
		return wsdlUri;
	}

	public function setWsdlUri(wsdlUri:String):Void {
		this.wsdlUri = wsdlUri;
	}

	public function getProxyUir(Void):String {
		return proxyUri;
	}

	public function setProxyUri(proxyUri:String):Void {
		this.proxyUri = proxyUri;
	}

	public function getEndpointProxyUri(Void):String {
		return endpointProxyUri;
	}

	public function setEndpointProxyUri(endpointProxyUri:String):Void {
		this.endpointProxyUri = endpointProxyUri;
	}

	public function getServiceName(Void):String {
		return serviceName;
	}

	public function setServiceName(serviceName:String):Void {
		this.serviceName = serviceName;
	}

	public function getPortName(Void):String {
		return portName;
	}

	public function setPortName(portName:String):Void {
		this.portName = portName;
	}

	public function getLogger(Void):Log {
		return logger;
	}

	public function setLogger(logger:Log):Void {
		this.logger = logger;
	}

}