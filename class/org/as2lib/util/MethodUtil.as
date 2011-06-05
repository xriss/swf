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

/**
 * @author Simon Wacker
 */
class org.as2lib.util.MethodUtil extends BasicClass {
	
	/**
	 * Invokes the method with the given name {@code methodName} on the given
	 * {@code scope} using the givne {@code args}.
	 * 
	 * <p>This method does basically the same as {@code Function.apply}, but it solves
	 * the {@code super}-problem that occurs with methods invoked by {@code apply}. The
	 * occuring error is that {@code super} refers to the wrong node in the prototype
	 * chain, and does may invoke a wrong method (in most cases the same method that
	 * invoked {@code super}, resulting an an infinite loop).
	 * 
	 * <p>Note you can use {@code apply} for per class (static) methods, because these
	 * methods have no {@code super}.
	 * 
	 * @param methodName the name of the method to invoke on the given {@code scope}
	 * @param scope the scope to invoke the method on
	 * @param args the arguments for the method invocation
	 * @return the result of the method invocation
	 */
	public static function invoke(methodName:String, scope, args:Array) {
		var m:Function = scope[methodName];
		if (m != null) {
			if (scope.__proto__[methodName] != null) {
				if (scope.__proto__[methodName] == scope.__proto__.__proto__[methodName]) {
					var s = scope.__proto__;
					while (s.__proto__[methodName] == s.__proto__.__proto__[methodName]) {
						s = s.__proto__;
					}
					s.__as2lib__invoker = function() {
						delete s.__as2lib__invoker;
						return m.apply(super, args);
					};
					return scope.__as2lib__invoker();
				}
			}
			return m.apply(scope, args);
		}
	}
	
	/**
	 * Constructs a new {@code MethodUtil} instance.
	 */
	private function MethodUtil() {
	}
	
}