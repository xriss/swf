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

/**
 * {@code StackTraceAspect} traces method invocations or set and get access to
 * properties and stores them as stack trace elements in a stack trace.
 * 
 * <p>Note that this aspect is not bound to the usage of exceptions. You may
 * use this aspect even if you do not use exceptions, just to have access to a
 * stack trace that may help you during debugging.
 * 
 * @author Scott Hyndman
 * @author Simon Wacker
 * @see StackTraceElement
 */
class org.as2lib.env.except.StackTraceAspect extends AbstractAspect implements Aspect {
    
    /** The stack of stack trace elements preceding and including the current method invocation. */
    private static var stackTrace:Array;
    
    /**
     * Returns the stack of {@link StackTraceElement} instances preceding and including
     * the current method invocation.
     * 
     * @return the stack trace
     */
    public static function getStackTrace(Void):Array {
        return stackTrace.concat();
    }
    
    /** Pointcut capturing join points to trace. */
    private var tracedJoinPointsPointcut:String;
    
    /**
     * Constructs a new {@code StackAspect} instance.
     * 
     * <p>If {@code tracedJoinPointsPointcut} is not specified, the default pointcut is used.
     * The default pointcut captures all methods except the methods of this aspect.
     * <code>execution(* ..*.*()) && !within(org.as2lib.aop.aspect.StackTraceAspect)</code>
     * 
     * @param tracedJoinPointsPointcut (optional) the pointcut capturing methods whose
     * invocations or properties whose accesses shall be included in the stack trace
     */
    public function StackTraceAspect(tracedJoinPointsPointcut:String) {
        if (tracedJoinPointsPointcut == null) {
            this.tracedJoinPointsPointcut = "execution(* ..*.*()) && !within(org.as2lib.aop.aspect.StackTraceAspect)";
        } else {
            this.tracedJoinPointsPointcut = tracedJoinPointsPointcut;
        }
        stackTrace = new Array();
        addAdvice(AbstractAdvice.AROUND, getTracedJoinPointsPointcut(), aroundTracedJoinPointsAdvice);
    }
    
    /**
     * Pushes stack trace elements to and pops stack trace elements from the stack trace.
     * 
     * @param joinPoint the called method or set or get property access to trace
     * @param args the argument used for the method call or set or get property access
     * @return the result of the procession of the given {@code joinPoint}
     */
    private function aroundTracedJoinPointsAdvice(joinPoint:JoinPoint, args:Array) {
        var stackTraceElement:StackTraceElement = new StackTraceElement(
                joinPoint.getThis(),
                AbstractJoinPoint.getMethod(joinPoint).getMethod(),
                args);
        stackTrace.push(stackTraceElement);
        var result = joinPoint.proceed();;
        stackTrace.pop();
        return result;
    }
    
    /**
     * Returns the pointcut capturing methods whose invocations or properties whose get
     * or set access shall be included in the stack trace.
     * 
     * @param the pointcut capturing methods and property accesses to trace
     */
    public function getTracedJoinPointsPointcut(Void):String {
        return tracedJoinPointsPointcut;
    }
    
}