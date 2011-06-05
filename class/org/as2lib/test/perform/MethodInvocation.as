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
import org.as2lib.env.reflect.ClassInfo;
import org.as2lib.env.reflect.ConstructorInfo;
import org.as2lib.env.reflect.MethodInfo;
import org.as2lib.test.perform.AbstractProfile;
import org.as2lib.test.perform.Profile;

/**
 * {@code MethodInvocation} is the profile of a method invocation.
 *
 * @author Simon Wacker
 */
class org.as2lib.test.perform.MethodInvocation extends AbstractProfile implements Profile {

	/** Designates an unknown type in the type signature. */
	public static var UNKNOWN:String = "[unknown]";

	/** Designates type {@code Void} in the type signature. */
	public static var VOID:String = "Void";

	/** Invoked method. */
	private var method:MethodInfo;

	/** Caller of this method invocation. */
	private var caller:MethodInvocation;

	/** Time needed for this method invocation. */
	private var time:Number;

	/** Arguments used for this method invocation. */
	private var args:Array;

	/** Return value of this method invocation. */
	private var returnValue;

	/** Exception thrown during this method invocation. */
	private var exception;

	/** The previous method invocation. */
	private var previousMethodInvocation:MethodInvocation;

	/**
	 * Constructs a new {@code MethodInvocation} instance.
	 *
	 * @param method the invoked method
	 * @throws IllegalArgumentException if {@code method} is {@code null} or
	 * {@code undefined}
	 */
	public function MethodInvocation(method:MethodInfo) {
		if (!method) {
			throw new IllegalArgumentException("Argument 'method' [" + method +
					"] must not be 'null' nor 'undefined'.", this, arguments);
		}
		this.method = method;
	}

	/**
	 * Returns the invoked method.
	 */
	public function getMethod(Void):MethodInfo {
		return method;
	}

	/**
	 * Returns the name of this method invocation. This is the method's name plus the
	 * signature of this method invocation.
	 *
	 * @return the name of this method invocation
	 * @see #getMethodName
	 * @see #getSignature
	 */
	public function getName(Void):String {
		return (getMethodName() + getSignature());
	}

	/**
	 * Returns the full name of the invoked method.
	 */
	public function getMethodName(Void):String {
		return method.getFullName();
	}

	/**
	 * Returns the signature of this method invocation.
	 *
	 * <p>If any information needed to generate the signature is not defined,
	 * {@link #UNKNOWN} is used as placeholder.
	 */
	public function getSignature(Void):String {
		var result:String = "(";
		if (args.length > 0) {
			for (var i:Number = 0; i < args.length; i++) {
				if (i != 0) {
					result += ", ";
				}
				result += getFullTypeName(args[i]);
			}
		}
		else {
			result += VOID;
		}
		if (method instanceof ConstructorInfo) {
			result += ")";
		}
		else {
			result += "):";
			if (returnValue === undefined) {
				result += VOID;
			} else {
				result += getFullTypeName(returnValue);
			}
		}
		if (!wasSuccessful()) {
			result += " throws ";
			result += getFullTypeName(exception);
		}
		return result;
	}

	/**
	 * Returns the fully qualified type name for the passed-in {@code instance}.
	 *
	 * @param instance the instance to return the type name for
	 * @return the fully qualified type name for the passed-in {@code instance}.
	 */
	private function getFullTypeName(instance):String {
		if (instance == null) {
			return UNKNOWN;
		}
		var typeName:String = ClassInfo.forInstance(instance).getFullName();
		if (typeName == null) {
			return UNKNOWN;
		}
		else {
			return typeName;
		}
	}

	/**
	 * Returns the time in milliseconds needed for this method invocation.
	 */
	public function getTime(Void):Number {
		return time;
	}

	public function getAverageTime(Void):Number {
		return time;
	}

	/**
	 * Sets the time in milliseconds needed for this method invocation.
	 */
	public function setTime(time:Number):Void {
		this.time = time;
	}

	/**
	 * Returns the arguments used for this method invocation.
	 */
	public function getArguments(Void):Array {
		return args;
	}

	/**
	 * Sets the arguments used for this method invocation.
	 */
	public function setArguments(args:Array):Void {
		this.args = args;
	}

	/**
	 * Returns this method invocation's return value.
	 */
	public function getReturnValue(Void) {
		return returnValue;
	}

	/**
	 * Sets the return value of this method invocation.
	 */
	public function setReturnValue(returnValue):Void {
		exception = undefined;
		this.returnValue = returnValue;
	}

	/**
	 * Returns the exception thrown during this method invocation.
	 */
	public function getException(Void) {
		return exception;
	}

	/**
	 * Sets the exception thrown during this method invocation.
	 */
	public function setException(exception):Void {
		returnValue = undefined;
		this.exception = exception;
	}

	/**
	 * Returns whether this method invocation was successful. Successful means that it
	 * returned a proper return value and did not throw an exception.
	 *
	 * @return {@code true} if this method invocation was successful else {@code false}
	 */
	public function wasSuccessful(Void):Boolean {
		return (exception === undefined);
	}

	/**
	 * Returns the method invocation that called the method that resulted in this
	 * method invocation.
	 */
	public function getCaller(Void):MethodInvocation {
		return caller;
	}

	/**
	 * Sets the method invocation that called the method that resulted in this method
	 * invocation.
	 */
	public function setCaller(caller:MethodInvocation):Void {
		this.caller = caller;
	}

	/**
	 * Returns the previous method invocation.
	 */
	public function getPreviousMethodInvocation(Void):MethodInvocation {
		return previousMethodInvocation;
	}

	/**
	 * Sets the previous method invocation.
	 */
	public function setPreviousMethodInvocation(previousMethodInvocation:MethodInvocation):Void {
		previousMethodInvocation = previousMethodInvocation;
	}

	/**
	 * Checks whether this method invocation was invoked before the passed-in
	 * {@code methodInvocation}.
	 *
	 * @param methodInvocation the method invocation to make the check upon
	 * @return {@code true} if this method invocation was invoked previously to the
	 * passed-in {@code methodInvocation} else {@code false}
	 */
	public function isPreviousMethodInvocation(methodInvocation:MethodInvocation):Boolean {
		if (methodInvocation == this) {
			return false;
		}
		var previousMethodInvocation:MethodInvocation = methodInvocation.getPreviousMethodInvocation();
		while (previousMethodInvocation) {
			if (previousMethodInvocation == this) {
				return true;
			}
			previousMethodInvocation = previousMethodInvocation.getPreviousMethodInvocation();
		}
		return false;
	}

	/**
	 * Returns this instance.
	 */
	public function getMethodInvocation(Void):MethodInvocation {
		return this;
	}

	/**
	 * Has this profile any method invocations?
	 *
	 * @return {@code false} because there are no sub method invocations
	 */
	public function hasMethodInvocations(Void):Boolean {
		return false;
	}

	/**
	 * Returns the number of method invocations of this profile.
	 *
	 * @return {@code 0} because there are no sub method invocations
	 */
	public function getMethodInvocationCount(Void):Number {
		return 0;
	}

	/**
	 * Returns the {@link MethodInvocation} instances of this profile.
	 *
	 * @return an empty array because there are no sub method invocations
	 */
	public function getMethodInvocations(Void):Array {
		return [];
	}

	public function sort(property:Number, descending:Boolean):Void {
	}

	/**
	 * Returns the string representation of this method invocation.
	 *
	 * @param rootProfile the profile that holds the total values needed for percentage
	 * calculations
	 * @return the string representation of this method invocation
	 */
	public function toString():String {
		var rootProfile:Profile = arguments[0];
		if (rootProfile == null) {
			rootProfile = this;
		}
		var result:String = getTimePercentage(rootProfile.getTime()) + "%";
		result += ", " + getTime() + " ms";
		result += " - " + getName();
		return result;
	}

}