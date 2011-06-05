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

/**
 * {@code MethodReplacer} is to be implemented by classes that can reimplement any
 * method on an IoC-managed object: the method injection form of dependency injection.
 * 
 * @author Simon Wacker
 */
interface org.as2lib.bean.factory.support.MethodReplacer extends BasicInterface {
	
	/**
	 * Reimplements the given method.
	 * 
	 * @param object the instance we are reimplementing the method for
	 * @param methodName the name of the method to reimplement
	 * @param args the arguments passed-to the reimplemented method on invocation
	 * @return the return value of the reimplemented method
	 */
	public function reimplement(object, methodName:String, args:Array);
	
}