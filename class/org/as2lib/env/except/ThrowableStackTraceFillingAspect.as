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

import org.as2lib.aop.advice.AbstractAdvice;
import org.as2lib.aop.Aspect;
import org.as2lib.aop.aspect.AbstractAspect;
import org.as2lib.aop.JoinPoint;
import org.as2lib.aop.joinpoint.AbstractJoinPoint;
import org.as2lib.env.except.StackTraceElement;
import org.as2lib.env.except.Throwable;
import org.as2lib.util.ArrayUtil;

/**
 * {@code ThrowableStackTraceFillingAspect} fills the stack trace of all throwables
 * with the stack trace elements you captured with your pointcut.
 * 
 * <p>This means that if you weave this aspect in every join point, every throwable
 * will contain its full stack trace.
 * 
 * @author Simon Wacker
 */
class org.as2lib.env.except.ThrowableStackTraceFillingAspect extends AbstractAspect implements Aspect {
	
	/**
	 * Constructs a new {@code ThrowableStackTraceFillingAspect} instance.
	 * 
	 * <p>If {@code stackTraceElementsPointcut} is not specified, the default pointcut is used.
	 * The default pointcut captures all methods except the methods of this aspect.
	 * <code>execution(* ..*.*()) && !within(org.as2lib.env.except.ThrowableStackTraceFillingAspect)</code>
	 * 
	 * @param stackTraceElementPointcut (optional) the pointcut that captures join points that
	 * shall be added as stack trace elements to throwables that are thrown
	 */
	public function ThrowableStackTraceFillingAspect(stackTraceElementsPointcut:String) {
		if (stackTraceElementsPointcut == null) {
			stackTraceElementsPointcut = "execution(* ..*.*()) && !within(org.as2lib.env.except.ThrowableStackTraceFillingAspect)";
		}
		addAdvice(AbstractAdvice.AFTER_THROWING, stackTraceElementsPointcut, afterThrowingAdvice);
	}
	
	/**
	 * Adds the stack trace element represented by the {@code joinPoint} to the given
	 * {@code throwable}.
	 * 
	 * @param joinPoint the join point to add as stack trace element
	 * @param throwable the throwable to add the stack trace element to
	 */
	private function afterThrowingAdvice(joinPoint:JoinPoint, throwable):Void {
		if (throwable instanceof Throwable) {
			var exception:Throwable = throwable;
			var stackTrace:Array = exception.getStackTrace();
			var method:Function = AbstractJoinPoint.getMethod(joinPoint).getMethod();
			if (stackTrace.length != 1) {
				exception.addStackTraceElement(joinPoint.getThis(), method, joinPoint.getArguments());
			} else {
				var element:StackTraceElement = stackTrace[0];
				if (element.getThrower() != joinPoint.getThis()
						|| !ArrayUtil.isSame(element.getArguments(), joinPoint.getArguments())
						|| element.getMethod() != method) {
					exception.addStackTraceElement(joinPoint.getThis(), method, joinPoint.getArguments());
				}
			}
		}
	}
	
}