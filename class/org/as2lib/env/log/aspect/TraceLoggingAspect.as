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

import org.as2lib.aop.JoinPoint;
import org.as2lib.env.log.aspect.IndentedLoggingAspect;
import org.as2lib.env.log.Logger;
import org.as2lib.env.log.LogManager;
import org.as2lib.env.reflect.ReflectUtil;

/**
 * {@code TraceLoggingAspect} logs the trace and indents every logged join point.
 * 
 * <p>This means that for example all method invocations are logged with the used
 * arguments and that if for example method 'a' invokes method 'b' method be will
 * be indented by 2 spaces.
 * 
 * <p>You have to specify the join points to log as well as the methods that are
 * actually logging messages that shall be indented.
 * 
 * <p>Note that this aspect logs every captured join point at debug level to a
 * logger returned by the {@link LogManager#getLogger} method with this class's
 * name as logger name.
 * 
 * @author Simon Wacker
 */
class org.as2lib.env.log.aspect.TraceLoggingAspect extends IndentedLoggingAspect {
	
	/** The default logged join points pointcut. */
	public static var DEFAULT_LOGGED_JOIN_POINTS_POINTCUT:String = "execution(* ..*.*()) && !within(org.as2lib.env.log.aspect.TraceLoggingAspect) && !within(org.as2lib.env.log.aspect.IndentedLoggingAspect)";

	/** The default logging methods pointcut. */
	public static var DEFAULT_LOGGING_METHODS_POINTCUT:String = "execution(org.as2lib.env.log.logger.SimpleHierarchicalLogger.debug())";
	
	/** This class's logger. */
	private static var logger:Logger;
	
	/**
	 * Returns the logger for this class.
	 * 
	 * @return the logger for this class
	 */
	private static function getLogger(Void):Logger {
		if (!logger) logger = LogManager.getLogger("org.as2lib.env.log.aspect.TraceLoggingAspect");
		return logger;
	}
	
	/**
	 * Constructs a new {@code TraceLoggingAspect} instance.
	 * 
	 * <p>If argument {@code loggedJoinPointsPointcut} is not specified, the default
	 * pointcut will be used that captures all method invocations except the ones on
	 * this aspect or its super-aspect.
	 * <code>execution(* ..*.*()) && !within(org.as2lib.env.log.aspect.TraceLoggingAspect) && !within(org.as2lib.env.log.aspect.IndentedLoggingAspect)</code>
	 * 
	 * <p>If argument {@code loggingMethodsPointcut} is not specified, the default
	 * pointcut will be used that captures the {@code debug} logging method of the
	 * class {@link SimpleHierarchicalLogger}.
	 * <code>execution(org.as2lib.env.log.logger.SimpleHierarchicalLogger.debug())</code>
	 * 
	 * @param loggedJoinPointsPointcut (optional) the pointcut that captures join
	 * points whose invocations or accesses shall be logged
	 * @param loggingMethodsPointcut (optional) the pointcut that captures methods that
	 * log messages
	 */
	public function TraceLoggingAspect(loggedJoinPointsPointcut:String, loggingMethodsPointcut:String) {
		super(loggedJoinPointsPointcut == null ? DEFAULT_LOGGED_JOIN_POINTS_POINTCUT : loggedJoinPointsPointcut,
				loggingMethodsPointcut == null ? DEFAULT_LOGGING_METHODS_POINTCUT : loggingMethodsPointcut);
	}
	
	/**
	 * Logs the given {@code joinPoint} and the type names of the given {@code args}.
	 * 
	 * @param joinPoint the join point to log
	 * @param args the arguments whose type names to log
	 */
	private function beforeLoggedJoinPointsAdvice(joinPoint:JoinPoint, args:Array):Void {
		super.beforeLoggedJoinPointsAdvice();
		if (getLogger().isDebugEnabled()) {
			var message:String = joinPoint.getInfo().getFullName();
			message += "(";
			for (var i:Number = 0; i < args.length; i++) {
				if (i != 0) message += ", ";
				message += ReflectUtil.getTypeNameForInstance(args[i]);
			}
			message += ")";
			getLogger().debug(message);
		}
	}
	
}