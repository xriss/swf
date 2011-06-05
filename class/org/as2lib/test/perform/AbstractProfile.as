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
import org.as2lib.test.perform.Profile;

/**
 * {@code AbstractProfile} implements methods commonly needed by {@link Profile}
 * implementations.
 *
 * @author Simon Wacker
 */
class org.as2lib.test.perform.AbstractProfile extends BasicClass {

	private var thiz:Profile;

	/**
	 * Constructs a new {@code AbstractProfile} instance.
	 */
	private function AbstractProfile(Void) {
		thiz = Profile(this);
	}

	public function getTimePercentage(totalTime:Number):Number {
		return (Math.round((thiz.getTime() / totalTime) * 10000) / 100);
	}

	public function getMethodInvocationPercentage(totalMethodInvocationCount:Number):Number {
		return (Math.round((thiz.getMethodInvocationCount() / totalMethodInvocationCount) * 10000) / 100);
	}

}