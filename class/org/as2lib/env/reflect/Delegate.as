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
import org.as2lib.util.MethodUtil;
import org.as2lib.env.overload.Overload;

/**
 * {@code Delegate} offers different ways to create methods with fixed scopes.
 * This means that if you have a method that you want to pass around, but whose
 * scope should not change you can create a wrapper or delegate for this method
 * that ensures that the method is invoked on the scope you want.
 * 
 * <p>Event handling as in used in movie clipse creates problems in ActionScript
 * due to the fact that it uses functions as event listeners. This means that the
 * scope of these event listeners always refers to the movie clip they are assigned
 * to. Thus {@link #create} allows you to create delegates for such event listener
 * methods that redirect method invocations to the wanted scope.
 * 
 * <p>Example:
 * 
 * <p>Test class:
 * <code>
 *   class com.domain.MyMovieClipController {
 *     private var content:String;
 *     
 *     public function MyMovieClipController(content:String) {
 *       this.content = content;
 *     }
 *     
 *     public function onEnterFrame() {
 *       trace(content);
 *     }
 *   }
 * </code>
 * 
 * <p>Usage:
 * <code>
 *   import com.domain.MyMovieClipController;
 *   import org.as2lib.env.reflect.Delegate;
 *  
 *   var mc:MyMovieClipController = new MyMovieClipController("Hello World!");
 *   
 *   // Following will not work because of the wrong scope
 *   _root.onEnterFrame = mc.onEnterFrame;
 *   
 *   // Workaround using delegate
 *   _root.onEnterFrame = Delegate.create(mc, onEnterFrame);
 * </code>
 * 
 * @author Martin Heidegger
 * @author Simon Wacker
 * @version 1.0
 */
class org.as2lib.env.reflect.Delegate extends BasicClass {
	
	/**
	 * @overload #createByMethod
	 * @overload #createByMethodAndArguments
	 * @overload #createByName
	 */
	public static function create():Function {
		var o:Overload = new Overload(eval("th" + "is"));
		o.addHandler([Object, Function], createByMethod);
		o.addHandler([Object, Function, Array], createByMethodAndArguments);
		o.addHandler([Object, String], createByName);
		return o.forward(arguments);
	}
	
	/**
	 * Creates a method that invokes the given {@code method} on the given {@code scope},
	 * passing the arguments passed to it and returning the result of the invocation.
	 * 
	 * <p>Note that the given {@code method} must not use {@code super} if it is not
	 * implemented by the class {@code scope} is an instance of. Take a look at the
	 * {@link #createByName} method if you want {@code super} to work in all cases. This
	 * bug is due to a bug with {@code Function.apply}, that is also used by Macromedias
	 * {@code Delegate} class.
	 * 
	 * @param scope the scope to invoke the given {@code method} on
	 * @param method the method to invoke on the given {@code scope}
	 * @return the method that delegates invocations to the given {@code method} on the
	 * given {@code scope}
	 */
	public static function createByMethod(scope, method:Function):Function {
		var result:Function = function() {
			return arguments.callee.method.apply(arguments.callee.scope, arguments);
		};
		result.scope = scope;
		result.method = method;
		return result;
	}
	
	/**
	 * Creates a method that invokes the given {@code method} on the given {@code scope},
	 * passing a fixed set of arguments plus the arguments passed to it and returning
	 * the result of the invocation.
	 * 
	 * <p>Example:
	 * <code>
	 *   import org.as2lib.env.reflect.Delegate;
	 *   
	 *   function test(a:String, b:Number, c:String) {
	 *   	trace(a + ", " + b + ", " + c);
	 *   }
	 *   
	 *   var delegate:Function = Delegate.create(this, test, ["a"]);
	 *   delegate(1, "b"); // traces "a, 1, b"
	 * </code>
	 * 
	 * @param scope the scope to invoke the given {@code method} on
	 * @param method the method to invoke on the given {@code scope}
	 * @param args the arguments to use at the beginning of the method invocation
	 * @return the method that delegates invocations to the given {@code method} on the
	 * given {@code scope}
	 */
	public static function createByMethodAndArguments(scope, method:Function, args:Array):Function {
		var result:Function = function() {
			return arguments.callee.method.apply(arguments.callee.scope, arguments.callee.args.concat(arguments));
		};
		result.scope = scope;
		result.method = method;
		result.args = args;
		return result;
	}
	
	/**
	 * Creates a delegate method that invokes the method with the given {@code methodName}
	 * on the given {@code scope} passing the arguments that were passed to the delegate
	 * method and returning the result of the invocation.
	 * 
	 * <p>Special about this delegate is that {@code super} works correctly, in all cases,
	 * in the method invoked by it. Whereas in the other two delegate types {@code super}
	 * works only if the method invoked by the delegate is directly implemented by the
	 * class the scope is an instance of. This is due to a failure with {@code Function.apply}.
	 * But as said, this failure is bypassed by this delegate.
	 * 
	 * @param scope the scope to invoke the method on
	 * @param methodName the name of the method to invoke
	 * @return a delegate that invokes the method with the given {@code methodName} on
	 * the given {@code scope}
	 * @see MethodUtil#invoke
	 */
	public static function createByName(scope, methodName:String):Function {
		var result:Function = function() {
			return MethodUtil.invoke(arguments.callee.methodName, arguments.callee.scope, arguments);
		};
		result.scope = scope;
		result.methodName = methodName;
		return result;
	}
		
	/**
	 * Constructs a new {@code Delegate} instance.
	 */
	private function Delegate(Void) {
	}
	
}