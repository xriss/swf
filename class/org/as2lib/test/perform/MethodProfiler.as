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

import org.as2lib.env.except.IllegalArgumentException;
import org.as2lib.env.overload.Overload;
import org.as2lib.env.reflect.ClassInfo;
import org.as2lib.env.reflect.ConstructorInfo;
import org.as2lib.env.reflect.MethodInfo;
import org.as2lib.test.perform.AbstractProfiler;
import org.as2lib.test.perform.CompoundProfile;
import org.as2lib.test.perform.MethodInvocation;
import org.as2lib.test.perform.Profile;
import org.as2lib.test.perform.Profiler;

/**
 * {@code MethodProfiler} profiles a method by recording method invocations to
 * the profiled method with all available data like duration, arguments, return
 * value, exception, caller, etc.
 *
 * <p>Profiling is started when the {@link #start} method is invoked and stopped
 * on {@link #stop}.
 *
 * <p>{@link #getProfile} returns the profile of the profiled method during the
 * time period between {@code start} and {@code stop} (or the current time if stop
 * has not been called yet).
 *
 * @author Simon Wacker
 */
class org.as2lib.test.perform.MethodProfiler extends AbstractProfiler implements Profiler {

	/** The profiled method. */
	private var method:MethodInfo;

	/** Scope of the profiled method. */
	private var s;

	/** Name of the profiled method. */
	private var n:String;

	/**
	 * @overload #MethodProfilerByMethod
	 * @overload #MethodProfilerByObjectAndMethod
	 * @overload #MethodProfilerByObjectAndName
	 */
	public function MethodProfiler() {
		var o:Overload = new Overload(this);
		o.addHandler([MethodInfo], MethodProfilerByMethod);
		o.addHandler([MethodInfo, Object, String], MethodProfilerByMethod);
		o.addHandler([Object, Function], MethodProfilerByObjectAndMethod);
		o.addHandler([Object, String], MethodProfilerByObjectAndName);
		o.forward(arguments);
	}

	/**
	 * Constructs a new {@code MethodProfiler} instance for the given method.
	 *
	 * <p>If you want to profile a method, referenced from a different scope and with a
	 * different name you can specify these with the last tewo arguments. Note that if
	 * specified the method declared on the class will not be profiled but its
	 * reference.
	 *
	 * @param method the method to profile
	 * @param referenceScope (optional) the scope of the method reference to profile
	 * @param referenceName (optional) the name of the method reference to profile
	 * @throws IllegalArgumentException if the passed-in {@code method} is {@code null}
	 * or {@code undefined}
	 */
	private function MethodProfilerByMethod(method:MethodInfo, referenceScope,
			referenceName:String):Void {
		if (method == null) {
			throw new IllegalArgumentException("Argument 'method' [" + method +
					"] must not be 'null' nor 'undefined' or this instance must " +
					"declare a method named 'doRun'.", this, arguments);
		}
		this.method = method.snapshot();
		if (referenceScope) {
			this.s = referenceScope;
		}
		else {
			if (method instanceof ConstructorInfo) {
				this.s = method.getDeclaringType().getPackage().getPackage();
			}
			else if (method.isStatic()) {
				this.s = method.getDeclaringType().getType();
			}
			else {
				this.s = method.getDeclaringType().getType().prototype;
			}
		}
		if (referenceName) {
			this.n = referenceName;
		}
		else {
			if (method instanceof ConstructorInfo) {
				this.n = method.getDeclaringType().getName();
			}
			else {
				this.n = method.getName();
			}
		}
	}

	/**
	 * Constructs a new {@code MethodProfiler} instance by object and method.
	 *
	 * @param object the object that declares the method to profile
	 * @param method the method to profile
	 * @throws IllegalArgumentException if {@code object} or {@code method} is
	 * {@code null} or {@code undefined}
	 */
	private function MethodProfilerByObjectAndMethod(object, method:Function):Void {
		if (object == null || !method) {
			throw new IllegalArgumentException("Neither argument 'object' [" + object +
					"] nor 'method' [" + method + "] is allowed to be 'null' or " +
					"'undefined'.", this, arguments);
		}
		var c:ClassInfo = ClassInfo.forObject(object);
		MethodProfilerByMethod(c.getMethodByMethod(method));
	}

	/**
	 * Constructs a new {@code MethodProfiler} instance by object and method name.
	 *
	 * @param object the object that declares the method to profile
	 * @param methodName the name of the method to profile
	 * @throws IllegalArgumentException if a method with the given {@code methodName}
	 * does not exist on the given {@code object} or is not of type {@code "function"}
	 */
	private function MethodProfilerByObjectAndName(object, methodName:String):Void {
		if (!object[methodName]) {
			throw new IllegalArgumentException("Method [" + object[methodName] +
					"] with name '" + methodName + "' on object [" + object +
					"] must not be 'null' nor 'undefined'.", this, arguments);
		}
		if (typeof(object[methodName]) != "function") {
			throw new IllegalArgumentException("Method [" + object[methodName] +
					"] with name '" + methodName + "' on object [" + object +
					"] must be of type 'function'.", this, arguments);
		}
		var c:ClassInfo = ClassInfo.forObject(object);
		if (c.hasMethod(methodName)) {
			MethodProfilerByMethod(c.getMethodByName(methodName));
		}
		else {
			var m:MethodInfo = new MethodInfo(methodName, c, false, object[methodName]);
			MethodProfilerByMethod(m, object, methodName);
		}
	}

	/**
	 * Returns the profiled method.
	 */
	public function getMethod(Void):MethodInfo {
		return method;
	}

	public function start(Void):Profile {
		profile = new CompoundProfile(method.getFullName());
		s[n] = createClosure();
		return profile;
	}

	/**
	 * Creates a closure, that is a wrapper method, for the method to profile.
	 *
	 * @return the created closure
	 */
	private function createClosure(Void):Function {
		var t:MethodProfiler = this;
		var mi:MethodInfo = method;
		var m:Function = method.getMethod();
		var closure:Function = function() {
			var i:MethodInvocation = t["c"]();
			i.setPreviousMethodInvocation(MethodProfiler["p"]);
			i.setArguments(arguments);
			i.setCaller(arguments.caller.__as2lib__i);
			m.__as2lib__i = i;
			var b:Number = getTimer();
			try {
				var r = mi.invoke(this, arguments);
				i.setTime(getTimer() - b);
				i.setReturnValue(r);
				return r;
			}
			catch (e) {
				i.setTime(getTimer() - b);
				i.setException(e);
				throw e;
			}
			finally {
				t["a"](i);
				MethodProfiler["p"] = i;
				delete m.__as2lib__i;
			}
		};
		closure.valueOf = function():Object {
			return m.valueOf();
		};
		closure.__resolve = function(name:String) {
			return m[name];
		};
		// sets class specific variables needed for closures of classes
		closure.__proto__ = m.__proto__;
		closure.prototype = m.prototype;
		closure.__constructor__ = m.__constructor__;
		closure.constructor = m.constructor;
		return closure;
	}

	/**
	 * Creates a new method invocation profile for the profiled method.
	 */
	private function c(Void):MethodInvocation {
		return new MethodInvocation(method);
	}

	/**
	 * Adds the given method invocation profile.
	 */
	private function a(m:MethodInvocation):Void {
		profile.addProfile(m);
	}

	public function stop(Void):Profile {
		s[n] = method.getMethod();
		return profile;
	}

}