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
import org.as2lib.env.except.IllegalArgumentException;
import org.as2lib.test.perform.CompoundMethodInvocation;
import org.as2lib.test.perform.CompoundProfile;
import org.as2lib.test.perform.MethodInvocation;
import org.as2lib.test.perform.Profile;
import org.as2lib.test.perform.ProfileLayouter;

/**
 * {@code MethodInvocationTreeLayouter} lays-out profiles in a tree like structure.
 * The method invocations are ordered by their invocation succession and by
 * which-invocation-caused-which-other-invocation.
 *
 * @author Simon Wacker */
class org.as2lib.test.perform.layout.MethodInvocationTreeLayouter extends BasicClass
		implements ProfileLayouter {

	private var hashCodeCounter:Number;

	/** All method invocations of the profile to lay-out. */
	private var allMethodInvocations:Array;

	/** Caches created compound method invocations by hash codes. */
	private var compoundMethodInvocations:Array;

	/**
	 * Constructs a new {@code MethodInvocationTreeLayouter} instance.	 */
	public function MethodInvocationTreeLayouter(Void) {
	}

	/**
	 * Lays-out the given profile as method invocation tree and returns a new laid-out
	 * profile.
	 */
	public function layOut(profile:Profile):Profile {
		if (profile == null) {
			throw new IllegalArgumentException("Argument 'profile' [" + profile +
					"] must not be 'null' nor 'undefined'.", this, arguments);
		}
		var result:CompoundProfile = new CompoundProfile(profile.getName());
		compoundMethodInvocations = new Array();
		hashCodeCounter = 0;
		allMethodInvocations = profile.getMethodInvocations();
		for (var i:Number = 0; i < allMethodInvocations.length; i++) {
			var methodInvocation:MethodInvocation = allMethodInvocations[i];
			var compoundMethodInvocation:CompoundMethodInvocation = getCompoundMethodInvocation(methodInvocation);
			var caller:MethodInvocation = methodInvocation.getCaller();
			if (caller == null) {
				result.addProfile(compoundMethodInvocation);
			}
			else {
				var compoundCaller:CompoundMethodInvocation = getCompoundMethodInvocation(caller);
				compoundCaller.addProfile(compoundMethodInvocation);
			}
		}
		result.sort(CompoundProfile.METHOD_INVOCATION_SUCCESSION);
		return result;
	}

	private function getCompoundMethodInvocation(methodInvocation:MethodInvocation):CompoundMethodInvocation {
		var result:CompoundMethodInvocation = compoundMethodInvocations[methodInvocation["__as2lib__layouter"]];
		if (result == null) {
			result = new CompoundMethodInvocation(methodInvocation);
			methodInvocation["__as2lib__layouter"] = hashCodeCounter++;
			compoundMethodInvocations[methodInvocation["__as2lib__layouter"]] = result;
		}
		return result;
	}

}