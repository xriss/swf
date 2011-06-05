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

import org.as2lib.env.except.IllegalArgumentException;
import org.as2lib.env.overload.Overload;
import org.as2lib.env.reflect.PackageInfo;
import org.as2lib.test.perform.ClassProfiler;
import org.as2lib.test.perform.CompoundProfiler;

/**
 * {@code PackageProfiler} profiles all classes in a given package and subpackages.
 *
 * @author Simon Wacker
 */
class org.as2lib.test.perform.PackageProfiler extends CompoundProfiler {

	private var package:PackageInfo;

	/**
	 * @overload #PackageProfilerByPackage
	 * @overload #PackageProfilerByPackageInfo
	 */
	public function PackageProfiler() {
		var o:Overload = new Overload(this);
		o.addHandler([Object], PackageProfilerByPackage);
		o.addHandler([PackageInfo], PackageProfilerByPackageInfo);
		o.forward(arguments);
	}

	/**
	 * Constructs a new {@code PackageProfiler} instance for the given package.
	 *
	 * @param package the package to profile
	 */
	private function PackageProfilerByPackage(package):Void {
		PackageProfilerByPackageInfo(PackageInfo.forPackage(package));
	}

	/**
	 * Constructs a new {@code PackageProfiler} instance for the given package.
	 *
	 * @param package the package to profile
	 */
	private function PackageProfilerByPackageInfo(package:PackageInfo):Void {
		if (package == null) {
			throw new IllegalArgumentException("Argument 'package' [" + package +
					"] must not be 'null' nor 'undefined'.", this, arguments);
		}
		this.package = package;
		addClassProfilers();
		addPackageProfilers();
	}

	/**
	 * Adds class profilers for all member classes of the profiled package.
	 */
	private function addClassProfilers(Void):Void {
		var classes:Array = package.getMemberClasses();
		for (var i:Number = 0; i < classes.length; i++) {
			addProfiler(new ClassProfiler(classes[i]));
		}
	}

	/**
	 * Adds package profilers for all member packages of the profiled package.
	 */
	private function addPackageProfilers(Void):Void {
		var packages:Array = package.getMemberPackages();
		for (var i:Number = 0; i < packages.length; i++) {
			addProfiler(new PackageProfiler(packages[i]));
		}
	}

	private function getName(Void):String {
		return package.getFullName();
	}

}