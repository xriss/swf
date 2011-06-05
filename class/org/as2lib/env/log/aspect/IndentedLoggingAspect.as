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
import org.as2lib.util.StringUtil;

/**
 * {@code IndentedLoggingAspect} indents logging of messages.
 * 
 * <p>Note that this class can be used with every logging framework. It is not
 * bound to the one of the as2lib.
 * 
 * @author Simon Wacker
 */
class org.as2lib.env.log.aspect.IndentedLoggingAspect extends AbstractAspect implements Aspect {
	
	/** The temporary indentation level. */
	private var indentationLevel:Number = -1;
	
	/** The pointcut that captures join points to log. */
	private var loggedJoinPointsPointcut:String;
	
	/** The pointcut that captures logging methods. */
	private var loggingMethodsPointcut:String;
	
	/**
	 * Constructs a new {@code IndentedLoggingAspect} instance.
	 * 
	 * <p>The {@code loggedJoinPointsPointcut} determines when the indentation level
	 * will be increased or decreased.
	 * 
	 * <p>The {@code loggingMethodsPointcut} determines the log methods whose first
	 * argument, that is supposed to be the message, will be indented by the current
	 * indentation level.
	 * 
	 * @param loggedJoinPointsPointcut the pointcut that captures join points to log
	 * @param loggingMethodsPointcut the pointcut that captures methods that log
	 * messages
	 */
	public function IndentedLoggingAspect(loggedJoinPointsPointcut:String, loggingMethodsPointcut:String) {
		this.loggingMethodsPointcut = loggingMethodsPointcut;
		this.loggedJoinPointsPointcut = loggedJoinPointsPointcut;
		initAdvices();
	}
	
	/**
	 * Initializes the advices around logging methods and before and after logged join
	 * points.
	 */
	private function initAdvices(Void):Void {
		addAdvice(AbstractAdvice.AROUND, getLoggingMethodsPointcut(), aroundLoggingMethodsAdvice);
		addAdvice(AbstractAdvice.BEFORE, getLoggedJoinPointsPointcut(), beforeLoggedJoinPointsAdvice);
		addAdvice(AbstractAdvice.AFTER, getLoggedJoinPointsPointcut(), afterLoggedJoinPointsAdvice);
	}
	
	/**
	 * Adds the indentation to the message to log.
	 * 
	 * <p>It is expected that {@code args} has the message as first parameter. This
	 * message is made to a string via its {@code toString} method and the indentation
	 * is added to the resulting string. After this is done, the given {@code args}
	 * array with the first element stringified and indented is used to proceed the
	 * given {@code joinPoint}.
	 * 
	 * @param joinPoint the called log method
	 * @param args the arguments used for the method call
	 * @return the result of the invocation of the given {@code joinPoint} with the
	 * changed {@code args}
	 */
	private function aroundLoggingMethodsAdvice(joinPoint:JoinPoint, args:Array) {
		if (indentationLevel > 0) {
			args[0] = StringUtil.addSpaceIndent(args[0].toString(), indentationLevel * 2);
		}
		return joinPoint.proceed(args);
	}
	
	/**
	 * Increases the indentation level before a logged join point is invoked.
	 * 
	 * @param joinPoint the logged join point
	 * @param args the arguments used for invoking the logged method
	 */
	private function beforeLoggedJoinPointsAdvice(joinPoint:JoinPoint, args:Array):Void {
		indentationLevel++;
	}
	
	/**
	 * Decreases the indentation level after a logged join point was invoked.
	 * 
	 * @param joinPoint the logged join point
	 */
	private function afterLoggedJoinPointsAdvice(joinPoint:JoinPoint):Void {
		indentationLevel--;
	}
	
	/**
	 * Returns the pointcut that captures join points that shall be logged.
	 * 
	 * @return the pointcut that captures join points to log
	 */
	public function getLoggedJoinPointsPointcut(Void):String {
		return loggedJoinPointsPointcut;
	}
	
	/**
	 * Returns the pointcut that captures methods that are responsible for logging
	 * messages. Such a method is for example the {@code Logger.info} method.
	 * 
	 * @return the pointcut that captures log methods
	 */
	public function getLoggingMethodsPointcut(Void):String {
		return loggingMethodsPointcut;
	}
	
	/**
	 * Returns the current indentation level.
	 * 
	 * <p>The smallest indentation level is {@code -1}.
	 * 
	 * @return the current indentation level 
	 */
	public function getIndentationLevel(Void):Number {
		return indentationLevel;
	}
	
}