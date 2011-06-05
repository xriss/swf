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
import org.as2lib.env.reflect.ClassInfo;
import org.as2lib.test.perform.CompoundProfile;
import org.as2lib.test.perform.layout.MethodLayouter;
import org.as2lib.test.perform.MethodInvocation;
import org.as2lib.test.perform.Profile;
import org.as2lib.test.perform.ProfileLayouter;

/**
 * {@code ClassLayouter} lays-out profiles with classes as root elements of the
 * tree.
 *
 * @author Simon Wacker */
class org.as2lib.test.perform.layout.ClassLayouter extends BasicClass implements
		ProfileLayouter {

	/** The result of laying-out the current profile. */
	private var result:CompoundProfile;

	/** All method invocations of the profile to lay-out. */
	private var methodInvocations:Array;

	/**
	 * Constructs a new {@code ClassLayouter} instance.	 */
	public function ClassLayouter(Void) {
	}

	/**
	 * Lays-out the given profile with classes as root elements of the tree and returns
	 * a new laid-out profile.
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
			i -= addMethodInvocations(ClassInfo(methodInvocation.getMethod().getDeclaringType()));
		}
		result.sort(CompoundProfile.TIME, true);
		return result;
	}

	/**
	 * Adds all method invocations of methods of the passed-in {@code clazz} to the
	 * result and removes these invocations from the {@code methodInvocations} array.
	 *
	 * @param clazz the class to add method invocations for
	 * @return the number of removed method invocations	 */
	private function addMethodInvocations(clazz:ClassInfo):Number {
		var count:Number = 0;
		var classResult:CompoundProfile = new CompoundProfile(clazz.getFullName());
		for (var i:Number = 0; i < methodInvocations.length; i++) {
			var methodInvocation:MethodInvocation = methodInvocations[i];
			if (methodInvocation.getMethod().getDeclaringType() == clazz) {
				classResult.addProfile(methodInvocation);
				methodInvocations.splice(i, 1);
				i--;
				count++;
			}
		}
		result.addProfile((new MethodLayouter()).layOut(classResult));
		return count;
	}

}