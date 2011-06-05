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

import org.as2lib.core.BasicInterface;
import org.as2lib.test.perform.Profile;

/**
 * {@code Profiler} is the base interface for all kinds of profilers. For example
 * {@link MethodProfiler method profilers} or {@link PropertyProfiler property
 * profilers}.
 *
 * <p>Profilers can be used as follows:
 *
 * <code>
 *   import org.as2lib.test.perform.Profiler;
 *   import org.as2lib.test.perform.PackageProfiler;
 *   import org.as2lib.test.perform.ProfileLayouter;
 *   import org.as2lib.test.perform.layout.MethodInvocationTreeLayouter;
 *
 *   var profiler:Profiler = new PackageProfiler(_global.org.as2lib.context);
 *   profiler.start();
 *
 *   // Create an application context and use it.
 *
 *   profiler.stop();
 *
 *   // Do some operations that shall not be profiled.
 *
 *   var layouter:ProfileLayouter = new MethodInvocationTreeLayouter();
 *   trace(layouter.layOut(profiler.getProfile()));
 * </code>
 *
 * @author Simon Wacker
 */
interface org.as2lib.test.perform.Profiler extends BasicInterface {

	/**
	 * Starts profiling.
	 *
	 * @return the new and empty profile that will be filled until {@link #stop} gets
	 * invoked
	 */
	public function start(Void):Profile;

	/**
	 * Stops profiling.
	 *
	 * @return the final profile (no further information will be added to it)
	 */
	public function stop(Void):Profile;

	/**
	 * Returns the profile. If profiling has already been stopped the returned profile
	 * is final; otherwise information may still be added to the returned profile.
	 */
	public function getProfile(Void):Profile;

}