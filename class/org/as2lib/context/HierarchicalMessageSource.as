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

import org.as2lib.context.MessageSource;

/**
 * {@code HierarchicalMessageSource} adds the capability to resolve messages
 * hierarchically to the basic message source.
 * 
 * @author Simon Wacker
 */
interface org.as2lib.context.HierarchicalMessageSource extends MessageSource {
	
	/** 
	 * Sets the parent that will be used to try to resolve messages that this object
	 * can't resolve.
	 * 
	 * @param parent the parent message source that will be used to resolve messages
	 * that this object can't resolve; may be {@ode null}, in which case no further
	 * resolution is possible
	 */
	public function setParentMessageSource(parent:MessageSource):Void;
	
	/**
	 * Returns the parent of this message source, or {@code null} if none.
	 * 
	 * @return this message source's parent
	 */
	public function getParentMessageSource(Void):MessageSource;
	
}