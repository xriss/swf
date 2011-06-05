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

import org.as2lib.bean.factory.support.MethodOverride;
import org.as2lib.core.BasicClass;

/**
 * {@code MethodOverrides} is a set of method overrides, determining which, if any,
 * methods on a managed object the Spring IoC container will override at runtime.
 * 
 * <p>The currently supported method override variants are {@link LookupOverride}
 * and {@link ReplaceOverride}.
 * 
 * @author Simon Wacker
 */
class org.as2lib.bean.factory.support.MethodOverrides extends BasicClass {
	
	/** All added {@code MethodOverride} instances. */
	private var overrides:Array;
	
	/**
	 * Constructs a new {@code MethodOverrides} instance.
	 * 
	 * <p>Supplying the source on construction is faster than using the
	 * {@code addOverrides} method because duplicates must not be checked.
	 * 
	 * @param source the method overrides to add to this instance
	 */
	public function MethodOverrides(source:MethodOverrides) {
		overrides = new Array();
		if (source != null) {
			var mo:Array = source.getOverrides();
			for (var i:Number = 0; i < mo.length; i++) {
				overrides.push(mo[i]);
			}
		}
	}
	
	/**
	 * Copies all given method overrides into this instance.
	 * 
	 * @param source the method overrides to copy
	 */
	public function addOverrides(source:MethodOverrides):Void {
		if (source != null) {
			var mo:Array = source.getOverrides();
			for (var i:Number = 0; i < mo.length; i++) {
				addOverride(mo[i]);
			}
		}
	}

	/**
	 * Adds the given method override.
	 * 
	 * @param override the method override to add
	 */
	public function addOverride(override:MethodOverride):Void {
		for (var i:Number = 0; i < overrides.length; i++) {
			var currentOverride:MethodOverride = overrides[i];
			if (currentOverride == override) {
				return;
			}
		}
		overrides.push(override);
	}
	
	/**
	 * Returns the override for the given method, if any.
	 * 
	 * @param method the method to check for overrides for
	 * @return the method override, or {@code null} if none
	 */
	public function getOverride(methodName:String):MethodOverride {
		for (var i:Number = 0; i < overrides.length; i++) {
			var methodOverride:MethodOverride = overrides[i];
			if (methodOverride.matches(methodName)) {
				return methodOverride;
			}			
		}
		return null;
	}

	/**
	 * Returns all added method overrides.
	 * 
	 * @return an array of {@link MethodOverride} instances
	 */
	public function getOverrides(Void):Array {
		return overrides;
	}

	/**
	 * Returns whether this instance contains any method overrides.
	 * 
	 * @return {@code true} if this instance contains no method overrides else
	 * {@code false}
	 */
	public function isEmpty(Void):Boolean {
		return (overrides.length == 0);
	}
	
}