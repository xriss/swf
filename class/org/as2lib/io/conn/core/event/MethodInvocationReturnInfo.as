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
 * {@code MethodInvocationReturnInfo} informs clients that the method invocation
 * returned successfully.
 * 
 * <p>This class is used in conjunction with the {@link MethodInvocationCallback}
 * and {@link MethodInvocationReturnListener} classes.
 *
 * @author Simon Wacker
 */
class org.as2lib.io.conn.core.event.MethodInvocationReturnInfo extends BasicClass {
	
	/** The return value returned by the invoked method. */
	private var returnValue;
	
	/** The service proxy that invoked the method. */
	private var serviceProxy:ServiceProxy;
	
	/** The name of the method that was invoked. */
	private var methodName:String;
	
	/** The arguments used for the invocation. */
	private var methodArguments:Array;
	
	/**
	 * Constructs a new {@code MethodInvocationReturnInfo} instance.
	 * 
	 * @param serviceProxy the service proxy that invoked the method
	 * @param methodName the name of the method that was invoked
	 * @param methodArguments the arguments used as parameters for the method invocation
	 * @param returnValue the result of the method invocation
	 */
	public function MethodInvocationReturnInfo(serviceProxy:ServiceProxy, methodName:String, methodArguments:Array, returnValue) {
		this.serviceProxy = serviceProxy;
		this.methodName = methodName;
		this.methodArguments = methodArguments;
		this.returnValue = returnValue;
	}
	
	/**
	 * Returns the service proxy that invoked the method.
	 * 
	 * @return the service proxy that invoked the method
	 */
	public function getServiceProxy(Void):ServiceProxy {
		return serviceProxy;
	}
	
	/**
	 * Returns the name of the method that was invoked on the service
	 *
	 * @return the name of the method that was invoked on the service
	 */
	public function getMethodName(Void):String {
		return methodName;
	}
	
	/**
	 * Returns the arguments used as parameters for the method invocation.
	 *
	 * @return the arguments used as parameters for the method invocation
	 */
	public function getMethodArguments(Void):Array {
		return methodArguments;
	}
	
	/*
	 * Returns the return value of the method invocation.
	 *
	 * @return the return value of the method invocation
	 */
	public function getReturnValue(Void) {
		return returnValue;
	}
	
	public function toString():String {
		var result:String = "MethodInvocationReturnInfo(";
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
		if (returnValue != null) {
			result += "\n  " + returnValue;
		}
		result += "\n)";
		return result;
	}
	
}