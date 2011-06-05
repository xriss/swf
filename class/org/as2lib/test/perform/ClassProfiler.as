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

import org.as2lib.env.overload.Overload;
import org.as2lib.env.reflect.ClassInfo;
import org.as2lib.env.reflect.MethodInfo;
import org.as2lib.env.reflect.PropertyInfo;
import org.as2lib.test.perform.CompoundProfiler;
import org.as2lib.test.perform.MethodProfiler;
import org.as2lib.test.perform.PropertyProfiler;

/**
 * {@code ClassProfiler} profiles a class: its constructor and super constructors,
 * its methods and its properties.
 *
 * @author Simon Wacker
 */
class org.as2lib.test.perform.ClassProfiler extends CompoundProfiler {

	private var clazz:ClassInfo;

	/**
	 * @overload #ClassProfilerByClass
	 * @overload #ClassProfilerByClassInfo
	 */
	public function ClassProfiler() {
		var o:Overload = new Overload(this);
		o.addHandler([Function], ClassProfilerByClass);
		o.addHandler([ClassInfo], ClassProfilerByClassInfo);
		o.forward(arguments);
	}

	/**
	 * Constructs a new {@code ClassProfiler} for the given class.
	 *
	 * @param clazz the class to profile
	 */
	private function ClassProfilerByClass(clazz:Function):Void {
		ClassProfilerByClassInfo(ClassInfo.forClass(clazz));
	}

	/**
	 * Constructs a new {@code ClassProfiler} for the given class.
	 *
	 * @param clazz the class to profile
	 */
	private function ClassProfilerByClassInfo(clazz:ClassInfo):Void {
		this.clazz = clazz;
		addConstructorProfilers();
		addMethodProfilers();
		addPropertyProfilers();
	}

	/**
	 * Adds constructor profilers for the constructor of the profiled class and the
	 * ones of all super-classes.
	 */
	private function addConstructorProfilers(Void):Void {
		addProfiler(new MethodProfiler(clazz.getConstructor()));
		var prototype = clazz.getType().prototype;
		if (prototype.__constructor__ != null) {
			var constructor:Function = prototype.__constructor__;
			var superConstructor:MethodInfo = ClassInfo(clazz.getSuperType()).getConstructor();
			// fixes a bug with the super-class constructor
			if (constructor != superConstructor.getMethod()) {
				prototype.__constructor__ = superConstructor.getMethod();
			}
			// adds a profiler for the super-class constructor (to profile super-calls)
			addProfiler(new MethodProfiler(superConstructor, prototype, "__constructor__"));
		}
	}

	/**
	 * Adds method profilers for all methods of the profiled class.
	 */
	private function addMethodProfilers(Void):Void {
		var methods:Array = clazz.getMethods(true);
		for (var i:Number = 0; i < methods.length; i++) {
			addProfiler(new MethodProfiler(methods[i]));
		}
	}

	/**
	 * Adds property profilers for all properties of the profiled class.
	 */
	private function addPropertyProfilers(Void):Void {
		var properties:Array = clazz.getProperties(true);
		for (var i:Number = 0; i < properties.length; i++) {
			addProfiler(new PropertyProfiler(properties[i]));
		}
	}

	private function getName(Void):String {
		return clazz.getFullName();
	}

}