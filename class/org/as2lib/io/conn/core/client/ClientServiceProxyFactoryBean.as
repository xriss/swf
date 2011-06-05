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

import org.as2lib.bean.factory.FactoryBean;
import org.as2lib.bean.factory.InitializingBean;
import org.as2lib.bean.PropertyAccess;
import org.as2lib.core.BasicClass;
import org.as2lib.env.except.IllegalArgumentException;
import org.as2lib.env.reflect.InterfaceProxyFactory;
import org.as2lib.env.reflect.InvocationHandler;
import org.as2lib.env.reflect.ProxyFactory;
import org.as2lib.io.conn.core.client.ClientServiceProxy;
import org.as2lib.io.conn.core.event.MethodInvocationCallback;

/**
 * {@code ClientServiceProxyFactoryBean} creates a service proxy based on a
 * service interface.
 *
 * @author Simon Wacker
 */
class org.as2lib.io.conn.core.client.ClientServiceProxyFactoryBean extends BasicClass implements
		FactoryBean, InvocationHandler, InitializingBean {

	private var serviceProxy:ClientServiceProxy;

	private var typedServiceProxy;

	private var serviceInterface:Function;

	/**
	 * Constructs a new {@code ClientServiceProxyFactoryBean} instance.
	 */
	public function ClientServiceProxyFactoryBean(Void) {
	}

	/**
	 * Creates the typed service proxy with the given service interface.
	 *
	 * @throws IllegalArgumentException if {@code serviceProxy} is not specified
	 * @throws IllegalArgumentException if {@code serviceInterface} is not specified
	 */
	public function afterPropertiesSet(Void):Void {
		if (serviceProxy == null) {
			throw new IllegalArgumentException("Service proxy is required.", this, arguments);
		}
		if (serviceInterface == null) {
			throw new IllegalArgumentException("Service interface is required.", this, arguments);
		}
		var typedServiceProxyFactory:ProxyFactory = new InterfaceProxyFactory();
		typedServiceProxy = typedServiceProxyFactory.createProxy(serviceInterface, this);
	}

	public function getServiceProxy(Void):ClientServiceProxy {
		return serviceProxy;
	}

	public function setServiceProxy(serviceProxy:ClientServiceProxy):Void {
		this.serviceProxy = serviceProxy;
	}

	public function getServiceInterface(Void):Function {
		return serviceInterface;
	}

	public function setServiceInterface(serviceInterface:Function):Void {
		this.serviceInterface = serviceInterface;
	}

	public function getObject(property:PropertyAccess) {
		return typedServiceProxy;
	}

	public function getObjectType(Void):Function {
		return serviceInterface;
	}

	public function isSingleton(Void):Boolean {
		return true;
	}

	public function invoke(proxy, methodName:String, args:Array) {
		if (args[args.length - 1] instanceof MethodInvocationCallback) {
			var callback:MethodInvocationCallback = MethodInvocationCallback(args.pop());
			return serviceProxy.invokeByNameAndArgumentsAndCallback(methodName, args, callback);
		}
		return serviceProxy.invokeByNameAndArguments(methodName, args);
	}

}