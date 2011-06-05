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

import org.as2lib.test.perform.CompoundProfile;
import org.as2lib.test.perform.MethodInvocation;
import org.as2lib.test.perform.Profile;
import org.as2lib.util.StringUtil;

/**
 * {@code CompoundMethodInvocation} is a method invocation that can hold sub
 * method invocations. The sub method invocations can for example be method
 * invocations made by this method invocation building a method invocation tree.
 *
 * @author Simon Wacker
 */
class org.as2lib.test.perform.CompoundMethodInvocation extends CompoundProfile {

	/** Makes the static variables of the super-class accessible through this class. */
	private static var __proto__:Object = CompoundProfile;

	/** The held method invocation. */
	private var methodInvocation:MethodInvocation;

	/**
	 * Constructs a new {@code CompoundMethodInvocation} instance.
	 *
	 * @param methodInvocation the method invocation to hold
	 */
	public function CompoundMethodInvocation(methodInvocation:MethodInvocation) {
		super(null);
		this.methodInvocation = methodInvocation;
	}

	/**
	 * Returns the method invocation this profile represents.
	 */
	public function getMethodInvocation(Void):MethodInvocation {
		return methodInvocation;
	}

	/**
	 * Returns the name of this method invocation. This is the name of the held method
	 * invocation.
	 */
	public function getName(Void):String {
		return methodInvocation.getName();
	}

	/**
	 * Returns the total invocation time in milliseconds. This is the time returned by
	 * the held method invocation.
	 */
	public function getTime(Void):Number {
		return methodInvocation.getTime();
	}

	/**
	 * Returns the string representation of this method invocation. This includes the
	 * string representation of all subprofiles.
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
		result += " - " + getMethodInvocationPercentage(rootProfile.getMethodInvocationCount()) + "%";
		result += ", " + getMethodInvocationCount() + " inv.";
		result += " - " + getAverageTime() + " ms/inv.";
		result += " - " + getName();
		if (hasProfiles()) {
			var totalTime:Number = getTime();
			for (var i:Number = 0; i < profiles.length; i++) {
				var profile:Profile = profiles[i];
				if (profile.hasMethodInvocations() || profile.getMethodInvocation() != null) {
					result += "\n";
					result += StringUtil.addSpaceIndent(profile.toString(rootProfile), 2);
				}
			}
		}
		return result;
	}

}