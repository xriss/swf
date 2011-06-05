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

import mx.remoting.Connection;
import mx.services.Log;

import org.as2lib.io.conn.core.client.ClientServiceProxyFactoryBean;
import org.as2lib.io.conn.remoting.RemotingServiceProxy;

/**
 * {@code RemotingServiceProxyFactoryBean} creates a {@link RemotingServiceProxy}
 * instance and initializes it with a given configuration. The created proxy is
 * stored and returned on every {@link #getObject} invocation.
 *
 * @author Simon Wacker
 */
class org.as2lib.io.conn.remoting.RemotingServiceProxyFactoryBean extends ClientServiceProxyFactoryBean {

	private var gatewayUri:String;

	private var serviceName:String;

	private var logger:Log;

	private var connection:Connection;

	/**
	 * Constructs a new {@code RemotingServiceProxyFactoryBean} instance.
	 */
	public function RemotingServiceProxyFactoryBean(Void) {
	}

	public function afterPropertiesSet(Void):Void {
		serviceProxy = new RemotingServiceProxy(gatewayUri, serviceName, logger, connection);
		super.afterPropertiesSet();
	}

	public function getGatewayUri(Void):String {
		return gatewayUri;
	}

	public function setGatewayUri(gatewayUri:String):Void {
		this.gatewayUri = gatewayUri;
	}

	public function getServiceName(Void):String {
		return serviceName;
	}

	public function setServiceName(serviceName:String):Void {
		this.serviceName = serviceName;
	}

	public function getLogger(Void):Log {
		return logger;
	}

	public function setLogger(logger:Log):Void {
		this.logger = logger;
	}

	public function getConnection(Void):Connection {
		return connection;
	}

	public function setConnection(connection:Connection):Void {
		this.connection = connection;
	}

}