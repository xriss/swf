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
 * {@code Mergeable} represents an object whose value set can be merged with that of
 * a parent object.
 * 
 * @author Simon Wacker
 */
interface org.as2lib.bean.Mergeable extends BasicInterface {
	
	/**
	 * Is merging enabled for this particular instance?
	 * 
	 * @return {@code true} if merging is enabled else {@code false}
	 */
	public function isMergeEnabled(Void):Boolean;
	
	/**
	 * Merges the current value set with that of the supplied object. The supplied
	 * object is considered the parent, and values in the callee's value set should
	 * override those of the supplied object.
	 * 
	 * @param parent the value set of the parent to merge with this one
	 * @return the result of the merge operation
	 * @throws IllegalArgumentException if the supplied parent is {@code null}
	 * @throws IllegalStateException if merging is not enabled for this instance
	 */
	public function merge(parent);
	
}