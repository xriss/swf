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
import org.as2lib.test.perform.MethodInvocation;

/**
 * {@code Profile} stores the result of analysing the performance (profiling) of
 * ActionScript code.
 *
 * @author Simon Wacker
 */
interface org.as2lib.test.perform.Profile extends BasicInterface {

	/**
	 * Returns the name of the test.
	 *
	 * @return the test's name
	 */
	public function getName(Void):String;

	/**
	 * Returns the total invocation time in milliseconds.
	 *
	 * @return the total invocation time in milliseconds
	 */
	public function getTime(Void):Number;

	/**
	 * Returns the invocation time as percentage in relation to the passed-in
	 * {@code totalTime}.
	 *
	 * @param totalTime the total time to calculate the percentage with
	 * @return the invocation time as percentage
	 */
	public function getTimePercentage(totalTime:Number):Number;

	/**
	 * Returns the time needed per method invocation.
	 *
	 * <p>Leaf profiles like {@link MethodInvocation} just return the needed time.
	 *
	 * @return the time needed per method invocation
	 * @see #getTime
	 */
	public function getAverageTime(Void):Number;

	/**
	 * Returns the method invocation this profile represents.
	 */
	public function getMethodInvocation(Void):MethodInvocation;

	/**
	 * Has this profile any method invocations?
	 *
	 * <p>A composite profile returns {@code true} if it has any method invocations
	 * tha were directly added to it or to one of its sub-composite profiles otherwise
	 * {@code false}. A leaf profile always returns {@code false}. {@link CompoundProfile}
	 * is a composite profile; {@link MethodInvocation} is a leaf profile.
	 */
	public function hasMethodInvocations(Void):Boolean;

	/**
	 * Returns the number of method invocations of this profile.
	 *
	 * <p>A composite profile returns the total numbr of method invocations directly
	 * added to it plus the ones of all sub-composite profiles. A leaf profile always
	 * returns {@code 0}. {@link CompoundProfile} is a composite profile;
	 * {@link MethodInvocation} is a leaf profile.
	 */
	public function getMethodInvocationCount(Void):Number;

	/**
	 * Returns the percentage of method invocations in relation to the passed-in
	 * {@code totalMethodInvocationCount}.
	 *
	 * @param totalMethodInvocationCount the total number of method invocations to
	 * calculate the percentage with
	 * @return the percentage of method invocations of this profile
	 * @see #getMethodInvocationCount
	 */
	public function getMethodInvocationPercentage(totalMethodInvocationCount:Number):Number;

	/**
	 * Returns the {@link MethodInvocation} instances of this profile.
	 *
	 * <p>A composite profile returns the method invocations directly added to it plus
	 * the ones of all sub-composite profiles. A leaf profile returns an empty array.
	 * {@link CompoundProfile} is a composite profile; {@link MethodInvocation} is a
	 * leaf profile.
	 */
	public function getMethodInvocations(Void):Array;

	/**
	 * Sorts this profile.
	 *
	 * <p>A composite profile sorts itself and all sub-composite profile. A leaf profile
	 * does nothing. {@link CompoundProfile} is a composite profile; {@link MethodInvocation}
	 * is a leaf profile.
	 *
	 * @param property the property to sort by
	 * @param descending determines whether to sort descending {@code true} or
	 * ascending {@code false}
	 */
	public function sort(property:Number, descending:Boolean):Void;

}