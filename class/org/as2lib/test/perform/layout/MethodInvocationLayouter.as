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
import org.as2lib.test.perform.CompoundProfile;
import org.as2lib.test.perform.MethodInvocation;
import org.as2lib.test.perform.Profile;
import org.as2lib.test.perform.ProfileLayouter;

/**
 * {@code MethodInvocationLayouter} lays-out profiles with method invocations as
 * root elements of the tree.
 *
 * @author Simon Wacker */
class org.as2lib.test.perform.layout.MethodInvocationLayouter extends BasicClass
		implements ProfileLayouter {

	/**
	 * Constructs a new {@code MethodInvocationLayouter} instance.	 */
	public function MethodInvocationLayouter(Void) {
	}

	/**
	 * Lays-out the given profile with method invocations as root elements of the tree
	 * and returns the new laid-out profile.
	 */
	public function layOut(profile:Profile):Profile {
		if (profile == null) {
			throw new IllegalArgumentException("Argument 'profile' [" + profile +
					"] must not be 'null' nor 'undefined'.", this, arguments);
		}
		var result:CompoundProfile = new CompoundProfile(profile.getName());
		var methodInvocations:Array = profile.getMethodInvocations();
		for (var i:Number = 0; i < methodInvocations.length; i++) {
			result.addProfile(methodInvocations[i]);
		}
		result.sort(CompoundProfile.TIME, true);
		return result;
	}

}