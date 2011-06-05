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
import org.as2lib.aop.joinpoint.AbstractJoinPoint;
import org.as2lib.env.except.UnsupportedOperationException;
import org.as2lib.env.reflect.PropertyInfo;
import org.as2lib.env.reflect.TypeMemberInfo;
import org.as2lib.aop.JoinPoint;

/**
 * {@code PropertyJoinPoint} represents any type of access to a property, be it set or
 * get access.
 * 
 * @author Simon Wacker
 */
class org.as2lib.aop.joinpoint.PropertyJoinPoint extends AbstractJoinPoint implements JoinPoint {
	
	/** The info representing the property. */
	private var info:PropertyInfo;
	
	/**
	 * Constructs a new {@code PropertyJoinPoint} instance.
	 *
	 * @param info the property info of the represented property
	 * @param thiz the logical this of the interception
	 * @param args the new invocation argumetns
	 * @throws IllegalArgumentException if argument {@code info} is {@code null} or
	 * {@code undefined}
	 * @see <a href="http://www.simonwacker.com/blog/archives/000068.php">Passing Context</a>
	 */
	public function PropertyJoinPoint(info:PropertyInfo, thiz, args:Array) {
		super(thiz, args);
		if (!info) throw new IllegalArgumentException("Argument 'info' must not be 'null' nor 'undefined'.", this, arguments);
		this.info = info;
	}
	
	/**
	 * Returns the info of the represented property. This is a {@link PropertyInfo}
	 * instance.
	 * 
	 * @return the info of the represented property
	 */
	public function getInfo(Void):TypeMemberInfo {
		return info;
	}
	
	/**
	 * Throws an unsupported operation exception because this method is not supported
	 * by an unspecified property access. Use the {@link GetPropertyJoinPoint} or
	 * {@link SetPropertyJoinPoint} classes if you want to be able to proceed a property
	 * join point.
	 * 
	 * @param args the arguments to use for the procession
	 * @return the result of the procession
	 * @throws UnsupportedOperationException
	 */
	public function proceed(args:Array) {
		throw new UnsupportedOperationException("The execute operation is not supported by PropertyJoinPoint instances [" + this + "].", this, arguments);
	}
	
	/**
	 * Returns this join point's type.
	 * 
	 * @return {@link AbstractJoinPoint#getType}
	 */
	public function getType(Void):Number {
		return PROPERTY;
	}
	
	/**
	 * Returns a copy of this join point with updated logical this and invocation arguments.
	 * This join point is left unchanged.
	 * 
	 * @param thiz the new logical this
	 * @param args the new invocation argumetns
	 * @return a copy of this join point with an updated logical this
	 * @see #getThis
	 * @see #getArguments
	 */
	public function update(thiz, args:Array):JoinPoint {
		var result:PropertyJoinPoint = new PropertyJoinPoint(this.info, thiz, args);
		configure(result);
		return result;
	}
	
	/**
	 * Returns a copy of this join point that reflects its current state.
	 * 
	 * <p>It is common practice to create a new join point for a not-fixed method info.
	 * This is when the underlying concrete method this join point reflects may change.
	 * To make the concrete method and other parts that may change fixed you can use
	 * this method to get a new fixed join point, a snapshot.
	 * 
	 * @return a snapshot of this join point
	 */
	public function snapshot(Void):JoinPoint {
		var result:PropertyJoinPoint = new PropertyJoinPoint(this.info.snapshot(), thiz, args);
		configure(result);
		return result;
	}
	
}