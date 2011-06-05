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
import org.as2lib.env.reflect.ClassInfo;
import org.as2lib.env.reflect.PropertyInfo;
import org.as2lib.test.perform.AbstractProfiler;
import org.as2lib.test.perform.CompoundProfile;
import org.as2lib.test.perform.MethodProfiler;
import org.as2lib.test.perform.Profile;
import org.as2lib.test.perform.Profiler;

/**
 * {@code PropertyProfiler} profiles a property by recording get- and set-access
 * to the profiled property with all available data like duration, its value,
 * exception, caller, etc.
 *
 * <p>Profiling is started when the {@link #start} method is invoked and stopped
 * on {@link #stop}.
 *
 * <p>{@link #getProfile} returns the profile of the profiled property during the
 * time period between {@code start} and {@code stop} (or the current time if stop
 * has not been called yet).
 *
 * @author Simon Wacker
 */
class org.as2lib.test.perform.PropertyProfiler extends AbstractProfiler implements Profiler {

	/** The property to profile. */
	private var property:PropertyInfo;

	/** Profiler of the getter. */
	private var getterProfiler:MethodProfiler;

	/** Profiler of the setter. */
	private var setterProfiler:MethodProfiler;

	/**
	 * @overload #PropertyProfilerByProperty
	 * @overload #PropertyProfilerByObjectAndName
	 */
	public function PropertyProfiler() {
		var o:Overload = new Overload(this);
		o.addHandler([PropertyInfo], PropertyProfilerByProperty);
		o.addHandler([Object, String], PropertyProfilerByObjectAndName);
		o.forward(arguments);
	}

	/**
	 * Constructs a new {@code PropertyProfiler} for the given property.
	 *
	 * <p>If you want to profile a property, referenced from a different scope and with
	 * a different name you can specify these with the last two arguments. Note that if
	 * specified the property declared on the class will not be profiled but its
	 * reference.
	 *
	 * @param property the property to profile
	 * @param referenceScope (optional) the scope of the property reference to profile
	 * @param referenceName (optional) the name of the property reference to profile
	 * @throws IllegalArgumentException if the passed-in {@code property} is
	 * {@code null} or {@code undefined}
	 */
	public function PropertyProfilerByProperty(property:PropertyInfo, referenceScope, referenceName:String):Void {
		if (!property) {
			throw new IllegalArgumentException("Argument 'property' [" + property +
					"] must not be 'null' nor 'undefined'.", this, arguments);
		}
		this.property = property;
		if (property.getGetter()) {
			getterProfiler = new MethodProfiler(property.getGetter(),
					referenceScope, "__get__" + referenceName);
		}
		if (property.getSetter()) {
			setterProfiler = new MethodProfiler(property.getSetter(),
					referenceScope, "__set__" + referenceName);
		}
	}

	/**
	 * Constructs a new {@code PropertyProfiler} by object and property name.
	 *
	 * @param object the object that declares the property to profile
	 * @param propertyName the name of the property to profile
	 * @throws IllegalArgumentException if there is no property with the given
	 * {@code propertyName} on the given {@code object}
	 */
	public function PropertyProfilerByObjectAndName(object, propertyName:String):Void {
		var c:ClassInfo = ClassInfo.forObject(object);
		if (c.hasProperty(propertyName)) {
			PropertyProfilerByProperty(c.getPropertyByName(propertyName));
		}
		else {
			if (!object["__set__" + propertyName] && !object["__get__" + propertyName]) {
				throw new IllegalArgumentException("Property with name [" + propertyName +
						"] does not exist on object [" + object + "].", this, arguments);
			}
			var setter:Function = object["__set__" + propertyName];
			var getter:Function = object["__get__" + propertyName];
			var p:PropertyInfo = new PropertyInfo(propertyName, c, false, setter, getter);
			PropertyProfilerByProperty(p, object, propertyName);
		}
	}

	/**
	 * Returns the profiled property.
	 */
	public function getProperty(Void):PropertyInfo {
		return this.property;
	}

	public function start(Void):Profile {
		profile = new CompoundProfile(property.getFullName());
		getterProfiler.start();
		setterProfiler.start();
		profile.addProfile(getterProfiler.getProfile());
		profile.addProfile(setterProfiler.getProfile());
		return profile;
	}

	public function stop(Void):Profile {
		getterProfiler.stop();
		setterProfiler.stop();
		return profile;
	}

}