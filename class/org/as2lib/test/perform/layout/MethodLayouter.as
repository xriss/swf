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
import org.as2lib.env.reflect.MethodInfo;
import org.as2lib.test.perform.CompoundProfile;
import org.as2lib.test.perform.MethodInvocation;
import org.as2lib.test.perform.Profile;
import org.as2lib.test.perform.ProfileLayouter;

/**
 * {@code MethodLayouter} lays-out profiles with methods as root elements of the
 * tree.
 *
 * @author Simon Wacker */
class org.as2lib.test.perform.layout.MethodLayouter extends BasicClass implements
		ProfileLayouter {

	/** The result of laying-out the current profile. */
	private var result:CompoundProfile;

	/** All method invocations of the profile to lay-out. */
	private var methodInvocations:Array;

	/**
	 * Constructs a new {@code MethodLayouter} instance.	 */
	public function MethodLayouter(Void) {
	}

	/**
	 * Lays-out the given profile with methods as root elements of the tree and returns
	 * a new laid-ou profile.
	 */
	public function layOut(profile:Profile):Profile {
		if (profile == null) {
			throw new IllegalArgumentException("Argument 'profile' [" + profile +
					"] must not be 'null' nor 'undefined'.", this, arguments);
		}
		result = new CompoundProfile(profile.getName());
		methodInvocations = profile.getMethodInvocations();
		for (var i:Number = 0; i < methodInvocations.length; i++) {
			var methodInvocation:MethodInvocation = methodInvocations[i];
			i -= addMethodInvocations(methodInvocation.getMethod());
		}
		result.sort(CompoundProfile.TIME, true);
		return result;
	}

	/**
	 * Adds all method invocations of the passed-in {@code method} to the result and
	 * removes the added invocations from the {@code methodInvocations} array.
	 *
	 * @param method the method to add the invocations for
	 * @return the number of method invocations added	 */
	private function addMethodInvocations(method:MethodInfo):Number {
		var count:Number = 0;
		var methodResult:CompoundProfile = new CompoundProfile(method.getFullName());
		for (var i:Number = 0; i < methodInvocations.length; i++) {
			var methodInvocation:MethodInvocation = methodInvocations[i];
			if (methodInvocation.getMethod() == method) {
				methodResult.addProfile(methodInvocation);
				methodInvocations.splice(i, 1);
				i--;
				count++;
			}
		}
		result.addProfile(methodResult);
		return count;
	}

}