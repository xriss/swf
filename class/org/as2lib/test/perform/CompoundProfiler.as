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

import org.as2lib.test.perform.AbstractProfiler;
import org.as2lib.test.perform.CompoundProfile;
import org.as2lib.test.perform.Profile;
import org.as2lib.test.perform.Profiler;

/**
 * {@code CompoundProfiler} manages multiple subprofilers.
 *
 * @author Simon Wacker
 */
class org.as2lib.test.perform.CompoundProfiler extends AbstractProfiler implements Profiler {

	private var profilers:Array;

	/**
	 * Constructs a new {@code CompoundProfiler} instance.
	 *
	 * @param name the name of this compound profiler
	 */
	public function CompoundProfiler(Void) {
		profilers = new Array();
	}

	/**
	 * Has this compound profiler any subprofilers?
	 */
	public function hasProfilers(Void):Boolean {
		return (profilers.length > 0);
	}

	/**
	 * Returns the number of subprofilers.
	 */
	public function getProfilerCount(Void):Number {
		return profilers.length;
	}

	/**
	 * Returns all subprofilers.
	 */
	public function getProfilers(Void):Array {
		return profilers.concat();
	}

	/**
	 * Adds the given profiler if it is neither {@code null} nor {@code undefined}.
	 */
	public function addProfiler(profiler:Profiler):Void {
		if (profiler != null) {
			profilers.push(profiler);
		}
	}

	public function start(Void):Profile {
		profile = new CompoundProfile(getName());
		for (var i:Number = 0; i < profilers.length; i++) {
			var profiler:Profiler = profilers[i];
			profiler.start();
			profile.addProfile(profiler.getProfile());
		}
		return profile;
	}

	/**
	 * Returns the name of this compound profiler.
	 *
	 * <p>May be overridden by subclasses to return a real name.
	 */
	private function getName(Void):String {
		return null;
	}

	public function stop(Void):Profile {
		for (var i:Number = 0; i < profilers.length; i++) {
			var profiler:Profiler = profilers[i];
			profiler.stop();
		}
		return profile;
	}

}