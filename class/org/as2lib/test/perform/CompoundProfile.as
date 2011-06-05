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

import org.as2lib.test.perform.AbstractProfile;
import org.as2lib.test.perform.MethodInvocation;
import org.as2lib.test.perform.Profile;
import org.as2lib.util.StringUtil;

/**
 * {@code CompoundProfile} organizes multiple subprofiles in a logical unit.
 *
 * @author Simon Wacker
 */
class org.as2lib.test.perform.CompoundProfile extends AbstractProfile implements Profile {

	/** Sort by name. */
	public static var NAME:Number = 0;

	/** Sort by time. */
	public static var TIME:Number = 1;

	/** Sort by average time. */
	public static var AVERAGE_TIME:Number = 2;

	/** Sort by time percentage. */
	public static var TIME_PERCENTAGE:Number = 3;

	/** Sort by method invocation count. */
	public static var METHOD_INVOCATION_COUNT:Number = 4;

	/** Sort by method invocation percentage. */
	public static var METHOD_INVOCATION_PERCENTAGE:Number = 5;

	/** Sort by the succession of method invocations. */
	public static var METHOD_INVOCATION_SUCCESSION:Number = 6;

	private var name;

	private var profiles:Array;

	/**
	 * Constructs a new {@code CompoundProfile} instance.
	 *
	 * @param name the name of this compound profile
	 */
	public function CompoundProfile(name:String) {
		this.name = name;
		profiles = new Array();
	}

	/**
	 * Has this compound profile any subprofiles?
	 */
	public function hasProfiles(Void):Boolean {
		return (profiles.length > 0);
	}

	/**
	 * Returns the number of subprofiles.
	 */
	public function getProfileCount(Void):Number {
		return profiles.length;
	}

	/**
	 * Returns all subprofiles.
	 */
	public function getProfiles(Void):Array {
		return profiles.concat();
	}

	/**
	 * Adds the given profile if it is neither {@code null} nor {@code undefined}.
	 */
	public function addProfile(profile:Profile):Void {
		if (profile != null) {
			profiles.push(profile);
		}
	}

	public function getName(Void):String {
		return name;
	}

	public function getTime(Void):Number {
		var result:Number = 0;
		for (var i:Number = 0; i < profiles.length; i++) {
			var profile:Profile = profiles[i];
			result += profile.getTime();
		}
		return result;
	}

	/**
	 * Returns the time needed per method invocation.
	 *
	 * @see #getTime
	 * @see #getMethodInvocationCount
	 */
	public function getAverageTime(Void):Number {
		return (Math.round((getTime() / getMethodInvocationCount()) * 100) / 100);
	}

	/**
	 * @return always {@code null} because this profile does not represent a method
	 * invocation
	 */
	public function getMethodInvocation(Void):MethodInvocation {
		return null;
	}

	/**
	 * Returns whether this profile or any subprofile has any method invocations.
	 *
	 * @return {@code true} if this profile or any subprofile has method invocations
	 * else {@code false}
	 */
	public function hasMethodInvocations(Void):Boolean {
		for (var i:Number = 0; i < profiles.length; i++) {
			var profile:Profile = profiles[i];
			if (profile.hasMethodInvocations() || profile.getMethodInvocation() != null) {
				return true;
			}
		}
		return false;
	}

	/**
	 * Returns the total number of method invocations of this profile and all
	 * subprofiles.
	 */
	public function getMethodInvocationCount(Void):Number {
		var result:Number = 0;
		for (var i:Number = 0; i < profiles.length; i++) {
			var profile:Profile = profiles[i];
			result += profile.getMethodInvocationCount();
			if (profile.getMethodInvocation() != null) {
				result++;
			}
		}
		return result;
	}

	/**
	 * Returns all profiled method invocations as {@link MethodInvocation} instances
	 * including method invocations of sub-compound profiles.
	 */
	public function getMethodInvocations(Void):Array {
		var result:Array = new Array();
		for (var i:Number = 0; i < profiles.length; i++) {
			var profile:Profile = profiles[i];
			var methodInvocation:MethodInvocation = profile.getMethodInvocation();
			if (methodInvocation != null) {
				result.push(methodInvocation);
			}
			result.push.apply(result, profile.getMethodInvocations());
		}
		return result;
	}

	/**
	 * Sorts this profile and its subprofiles.
	 *
	 * <p>Supported sort properties are:
	 * <ul>
	 *   <li>{@link #NAME}</li>
	 *   <li>{@link #TIME}</li>
	 *   <li>{@link #AVERAGE_TIME}</li>
	 *   <li>{@link #TIME_PERCENTAGE}</li>
	 *   <li>{@link #METHOD_INVOCATION_COUNT}</li>
	 *   <li>{@link #METHOD_INVOCATION_PERCENTAGE}</li>
	 *   <li>{@link #METHOD_INVOCATION_SUCCESSION}</li>
	 * </ul>
	 *
	 * @param property the property to sort by
	 * @param descending determines whether to sort descending {@code true} or
	 * ascending {@code false}
	 */
	public function sort(property:Number, descending:Boolean):Void {
		if (property == null) {
			return;
		}
		var comparator:Function = getComparator(property);
		if (comparator != null) {
			if (descending) {
				profiles.sort(comparator, Array.DESCENDING);
			}
			else {
				profiles.sort(comparator);
			}
		}
		for (var i:Number = 0; i < profiles.length; i++) {
			var profile:Profile = profiles[i];
			profile.sort(property, descending);
		}
	}

	/**
	 * Returns the comparator for the passed-in {@code property}.
	 *
	 * @param property the property to return the comparator for
	 * @return the comparator for the passed-in {@code property}
	 */
	private function getComparator(property:Number):Function {
		switch (property) {
			case NAME:
				return getNameComparator();
				break;
			case TIME:
				return getTimeComparator();
				break;
			case AVERAGE_TIME:
				return getAverageTimeComparator();
				break;
			case TIME_PERCENTAGE:
				return getTimePercentageComparator();
				break;
			case METHOD_INVOCATION_COUNT:
				return getMethodInvocationCountComparator();
				break;
			case METHOD_INVOCATION_PERCENTAGE:
				return getMethodInvocationPercentageComparator();
				break;
			case METHOD_INVOCATION_SUCCESSION:
				return getMethodInvocationSuccessionComparator();
				break;
			default:
				return null;
				break;
		}
	}

	/**
	 * Returns the comparator that compares profiles by their names.
	 */
	private function getNameComparator(Void):Function {
		// returning function directly is not flex compatible
		// flex compiler would not recognize return statement
		// seems to be a flex compiler bug
		var r:Function = function(a:Profile, b:Profile):Number {
			var m:String = a.getName();
			var n:String = b.getName();
			if (m == n) return 0;
			if (m > n) return 1;
			return -1;
		};
		return r;
	}

	/**
	 * Returns the comparator that compares profiles by their needed time.
	 */
	private function getTimeComparator(Void):Function {
		// returning function directly is not flex compatible
		// flex compiler would not recognize return statement
		// seems to be a flex compiler bug
		var r:Function = function(a:Profile, b:Profile):Number {
			var m:Number = a.getTime();
			var n:Number = b.getTime();
			if (m == n) return 0;
			if (m > n) return 1;
			return -1;
		};
		return r;
	}

	/**
	 * Returns the comparator that compares profiles by their average time.
	 */
	private function getAverageTimeComparator(Void):Function {
		// returning function directly is not flex compatible
		// flex compiler would not recognize return statement
		// seems to be a flex compiler bug
		var r:Function = function(a:Profile, b:Profile):Number {
			var m:Number = a.getAverageTime();
			var n:Number = b.getAverageTime();
			if (m == n) return 0;
			if (m > n) return 1;
			return -1;
		};
		return r;
	}

	/**
	 * Returns the comparator that compares profiles by their needed time in
	 * percentage.
	 */
	private function getTimePercentageComparator(Void):Function {
		var scope:CompoundProfile = this;
		// returning function directly is not flex compatible
		// flex compiler would not recognize return statement
		// seems to be a flex compiler bug
		var r:Function = function(a:Profile, b:Profile):Number {
			var m:Number = a.getTimePercentage(scope.getTime());
			var n:Number = b.getTimePercentage(scope.getTime());
			if (m == n) return 0;
			if (m > n) return 1;
			return -1;
		};
		return r;
	}

	/**
	 * Returns the comparator that compares profiles by their invocation count.
	 */
	private function getMethodInvocationCountComparator(Void):Function {
		// returning function directly is not flex compatible
		// flex compiler would not recognize return statement
		// seems to be a flex compiler bug
		var r:Function = function(a:Profile, b:Profile):Number {
			var m:Number = a.getMethodInvocationCount();
			var n:Number = b.getMethodInvocationCount();
			if (m == n) return 0;
			if (m > n) return 1;
			return -1;
		};
		return r;
	}

	/**
	 * Returns the comparator that compares profiles by their method invocation
	 * count in percentage.
	 */
	private function getMethodInvocationPercentageComparator(Void):Function {
		var scope:CompoundProfile = this;
		// returning function directly is not flex compatible
		// flex compiler would not recognize return statement
		// seems to be a flex compiler bug
		var r:Function = function(a:Profile, b:Profile):Number {
			var m:Number = a.getMethodInvocationPercentage(scope.getMethodInvocationCount());
			var n:Number = b.getMethodInvocationPercentage(scope.getMethodInvocationCount());
			if (m == n) return 0;
			if (m > n) return 1;
			return -1;
		};
		return r;
	}

	/**
	 * Returns the method invocation succession comparator.
	 */
	private function getMethodInvocationSuccessionComparator(Void):Function {
		// returning function directly is not flex compatible
		// flex compiler would not recognize return statement
		// seems to be a flex compiler bug
		var r:Function = function(a:Profile, b:Profile):Number {
			var m:MethodInvocation = a.getMethodInvocation();
			var n:MethodInvocation = b.getMethodInvocation();
			if (m != null && n != null) {
				if (m.isPreviousMethodInvocation(n)) return -1;
				if (n.isPreviousMethodInvocation(m)) return 1;
			}
			return 0;
		};
		return r;
	}

	/**
	 * Returns the string representation of this compound profile. This includes the
	 * string representation of all subprofiles.
	 *
	 * @param rootProfile the profile that holds the total values needed for percentage
	 * calculations
	 * @return the string representation of this compound profile
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
		var firstProfile:Profile = profiles[0];
		if (profiles.length == 1 && !(firstProfile instanceof CompoundProfile)) {
			result += " - " + profiles[0].getName();
		}
		else if (profiles.length == 1 && !firstProfile.hasMethodInvocations()) {
			result += " - " + firstProfile.getName();
		}
		else {
			result += " - " + getName();
			var totalTime:Number = getTime();
			for (var i:Number = 0; i < profiles.length; i++) {
				var profile:Profile = profiles[i];
				if (profile.hasMethodInvocations()  || profile.getMethodInvocation() != null) {
					result += "\n";
					result += StringUtil.addSpaceIndent(profile.toString(rootProfile), 2);
				}
			}
		}
		return result;
	}

}