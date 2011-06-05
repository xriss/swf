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
import org.as2lib.env.except.IllegalStateException;
import org.as2lib.test.perform.CompoundProfile;
import org.as2lib.test.perform.Profile;

/**
 * {@code AbstractProfiler} implements methods commonly needed be {@link Profiler}
 * implementations.
 *
 * @author Simon Wacker
 */
class org.as2lib.test.perform.AbstractProfiler extends BasicClass {

	/** The profile of this profiler. */
	private var profile:CompoundProfile;

	/**
	 * Constructs a new {@code AbstractProfiler} instance.
	 */
	private function AbstractProfiler(Void) {
	}

	public function getProfile(Void):Profile {
		if (profile == null) {
			throw new IllegalStateException("You must call 'start' before getting " +
					"the profile.", this, arguments);
		}
		return profile;
	}

}