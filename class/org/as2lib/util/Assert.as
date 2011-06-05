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
	
import org.as2lib.core.BasicClass;
import org.as2lib.env.except.IllegalArgumentException;
import org.as2lib.env.overload.Overload;
	
/**
 * Assert utility class that assists in validating arguments. Useful for
 * identifying programmer errors early and obviously at runtime.
 * 
 * @author Christophe Herreman
 */
class org.as2lib.util.Assert extends BasicClass {

	/**
	 * Private constructor.
	 */
	private function Assert(){
	}
		
	/**
	 * @overload #isTrueByExpression
	 * @overload #isTrueByExpressionAndMessage
	 */
	public static function isTrue():Void {
		var o:Overload = new Overload(eval("th"+"is"));
		o.addHandler([Boolean], isTrueByExpression);
		o.addHandler([Boolean, String], isTrueByExpressionAndMessage);
		o.forward(arguments);
	}
	
	/**
	 * Assert a boolean expression, throwing <code>IllegalArgumentException</code>
	 * if the test result is <code>false</code>.
	 * <pre>
	 * Assert.isTrue(i > 0, "The value must be greater than zero");</pre>
	 * 
	 * @param expression a boolean expression
	 * @param message the exception message to use if the assertion fails
	 * @throws IllegalArgumentException if expression is <code>false</code>
	 */
	private static function isTrueByExpressionAndMessage(expression:Boolean, message:String):Void {
		if (!expression) {
			throw new IllegalArgumentException(message, eval("th"+"is"), arguments);
		}
	}
	
	/**
	 * Assert a boolean expression, throwing <code>IllegalArgumentException</code>
	 * if the test result is <code>false</code>.
	 * <pre>
	 * Assert.isTrue(i > 0);</pre>
	 * 
	 * @param expression a boolean expression
	 * @throws IllegalArgumentException if expression is <code>false</code>
	 */
	private static function isTrueByExpression(expression:Boolean):Void{
		isTrue(expression, "[Assertion failed] - this expression must be true");
	}
	
	/**
	 * @overload #isNullByObject
	 * @overload #isNullByObjectAndMessage
	 */
	public static function isNull():Void {
		var o:Overload = new Overload(eval("th"+"is"));
		o.addHandler([Object], isNullByObject);
		o.addHandler([Object, String], isNullByObjectAndMessage);
		o.forward(arguments);
	}
	
	/**
	 * Assert that an object is null.
	 * <pre>
	 * Assert.isNull(value, "The value must be null");</pre>
	 * 
	 * @param object the object to check
	 * @param message the exception message to use if the assertion fails
	 * @throws IllegalArgumentException if the object is not <code>null</code>
	 */
	private static function isNullByObjectAndMessage(object:Object, message:String):Void {
		if (object != null) {
			throw new IllegalArgumentException(message);
		}
	}

	/**
	 * Assert that an object is null.
	 * <pre>
	 * Assert.isNull(value);</pre>
	 * 
	 * @param object the object to check
	 * @throws IllegalArgumentException if the object is not <code>null</code>
	 */
	private static function isNullByObject(object:Object):Void {
		isNull(object, "[Assertion failed] - the object argument must be null");
	}
	
	/**
	 * @overload #notNullByObject
	 * @overload #notNullByObjectAndMessage
	 */
	public static function notNull():Void {
		var o:Overload = new Overload(eval("th"+"is"));
		o.addHandler([Object], notNullByObject);
		o.addHandler([Object, String], notNullByObjectAndMessage);
		o.forward(arguments);
	}

	/**
	 * Assert that an object is not null.
	 * <pre>
	 * Assert.notNull(clazz, "The class must not be null");</pre>
	 * 
	 * @param object the object to check
	 * @param message the exception message to use if the assertion fails
	 * @throws IllegalArgumentException if the object is <code>null</code>
	 */
	private static function notNullByObjectAndMessage(object:Object, message:String):Void {
		if (object == null) {
			throw new IllegalArgumentException(message);
		}
	}

	/**
	 * Assert that an object is not null.
	 * <pre>
	 * Assert.notNull(clazz);</pre>
	 * @param object the object to check
	 * @throws IllegalArgumentException if the object is <code>null</code>
	 */
	private static function notNullByObject(object:Object):Void {
		notNull(object, "[Assertion failed] - this argument is required; it cannot be null");
	}
}