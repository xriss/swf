﻿/*
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

import org.as2lib.aop.Aspect;
import org.as2lib.aop.JoinPoint;
import org.as2lib.aop.advice.AbstractAdvice;
import org.as2lib.aop.advice.AfterAdvice;

/**
 * {@code AbstractAfterAdvice} provides implementations of methods needed by
 * {@link AfterAdvice} implementations.
 * 
 * @author Simon Wacker
 * @see <a href="http://www.simonwacker.com/blog/archives/000066.php">Advice</a>
 */
class org.as2lib.aop.advice.AbstractAfterAdvice extends AbstractAdvice {
	
	/**
	 * Constructs a new {@code AbstractAfterAdvice} instance.
	 * 
	 * @param aspect (optional) the aspect that contains this advice
	 */
	private function AbstractAfterAdvice(aspect:Aspect) {
		super(aspect);
	}
	
	/**
	 * Proceeds the passed-in {@code joinPoint} and returns the result of this procession
	 * after invoking this advice's {@code execute} method passing the given
	 * {@code joinPoint}. This {@code execute} method is always invoked, no matter
	 * whether the procession of the {@code joinPoint} results in an exception of not.
	 * 
	 * @param joinPoint the reached join point
	 * @return the result of the procession of the given {@code joinPoint}
	 * @throws * if the procession of the {@code joinPoint} results in an exception or
	 * if this advice's {@code execute} method threw an exception
	 */
	private function executeJoinPoint(joinPoint:JoinPoint) {
		var result;
		try {
			result = joinPoint.proceed();
		} finally {
			AfterAdvice(this).execute(joinPoint);
		}
		return result;
	}
	
}