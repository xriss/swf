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

import org.as2lib.app.exec.Call;
import org.as2lib.util.ClassUtil;

/**
 * {@code ConstructorCall} enables the creation of an instance of an unknown class
 * with custom arguments.
 *
 * @author Martin Heidegger
 * @author Christoph Atteneder
 * @author Simon Wacker
 */
class org.as2lib.app.exec.ConstructorCall extends Call {

	/** The class to instantiate. */
	private var clazz:Function;

	/**
	 * Constructs a new {@code ConstructorCall} instance.
	 *
	 * @param clazz the class to instantiate
	 */
	public function ConstructorCall(clazz:Function) {
		super(this, clazz);
		this.clazz = clazz;
	}

	/**
	 * Instantiates the class given on construction with the given arguments {@code args}.
	 *
	 * @param args the arguments to pass to the class's constructor
	 * @return the created instance
	 */
	public function executeArguments(args) {
		return ClassUtil.createInstance(clazz, args);
	}

}