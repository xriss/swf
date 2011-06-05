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

import org.as2lib.bean.AbstractBeanWrapper;
import org.as2lib.bean.BeanWrapper;
import org.as2lib.bean.factory.BeanFactory;
import org.as2lib.bean.factory.BeanFactoryAware;
import org.as2lib.bean.factory.BeanNameAware;
import org.as2lib.bean.factory.FactoryBean;
import org.as2lib.bean.PropertyAccess;
import org.as2lib.bean.PropertyValue;
import org.as2lib.bean.SimpleBeanWrapper;
import org.as2lib.core.BasicClass;
import org.as2lib.env.except.IllegalArgumentException;
import org.as2lib.util.MethodUtil;
import org.as2lib.util.TrimUtil;

/**
 * @author Simon Wacker
 */
class org.as2lib.bean.factory.config.DataBindingFactoryBean extends BasicClass implements
		FactoryBean, BeanFactoryAware {

	public static var STATEMENT_SEPARATOR:String = ";";

	public static var ASSIGNMENT_OPERATOR:String = "=";

	public static var ARGUMENT_LIST_PREFIX:String = "(";

	public static var ARGUMENT_LIST_SUFFIX:String = ")";

	public static var ARGUMENT_LIST_SEPARATOR:String = ",";

	public static var TRUE_BOOLEAN_LITERAL:String = "true";

	public static var FALSE_BOOLEAN_LITERAL:String = "false";

	private var dataBinding:String;

	private var dataBindingMethod:Function;

	private var targetBeanName:String;

	private var beanFactory:BeanFactory;

	/**
	 * Constructs a new {@code DataBindingFactoryBean} instance.
	 */
	public function DataBindingFactoryBean(Void) {
	}

	public function setDataBinding(dataBinding:String):Void {
		this.dataBinding = TrimUtil.trim(dataBinding);
	}

	public function setTargetBeanName(targetBeanName:String):Void {
		this.targetBeanName = targetBeanName;
	}

	public function setBeanFactory(beanFactory:BeanFactory):Void {
		this.beanFactory = beanFactory;
		if (dataBinding == null) {
			throw new IllegalArgumentException("'dataBinding' is required.", this, arguments);
		}
		var statements:Array = dataBinding.split(STATEMENT_SEPARATOR);
		// If the data binding ends with a ';' (which is quite legal) the last element is no statement.
		if (statements[statements.length - 1] == "") {
			statements.pop();
		}
		var statementMethods:Array = new Array();
		for (var i:Number = 0; i < statements.length; i++) {
			var statement:String = TrimUtil.trim(statements[i]);
			var operatorIndex:Number = statement.indexOf(ASSIGNMENT_OPERATOR);
			if (operatorIndex != -1) {
				statementMethods.push(parseAssignmentExpression(statement, operatorIndex));
				continue;
			}
			var prefixIndex:Number = statement.indexOf(ARGUMENT_LIST_PREFIX);
			if (prefixIndex != -1) {
				statementMethods.push(parseMethodInvocationExpression(statement, prefixIndex));
				continue;
			}
			throw new IllegalArgumentException("Statement '" + statement + "' of data binding " +
					"is neither an assignment nor a method invocation.", this, arguments);
		}
		dataBindingMethod = function() {
			var ss:Array = arguments.callee.statements;
			for (var i:Number = 0; i < ss.length; i++) {
				ss[i]();
			}
		};
		dataBindingMethod.statements = statementMethods;
	}

	private function parseAssignmentExpression(expression:String, assignmentOperatorIndex:Number):Function {
		var property:String = TrimUtil.trim(expression.substring(0, assignmentOperatorIndex));
		var separatorIndex:Number = property.indexOf(AbstractBeanWrapper.NESTED_PROPERTY_SEPARATOR);
		var beanName:String;
		var propertyName:String;
		if (separatorIndex == -1 || separatorIndex > assignmentOperatorIndex) {
			if (targetBeanName == null) {
				throw new IllegalArgumentException("Either bean or property name [" + property +
						"] of assignment expression [" + expression + "] is missing.",
						this, arguments);
			}
			else {
				beanName = targetBeanName;
				propertyName = property;
			}
		}
		else {
			beanName = property.substring(0, separatorIndex);
			propertyName = property.substring(separatorIndex + 1);
		}
		var assignment:String = TrimUtil.trim(expression.substring(assignmentOperatorIndex + 1));
		var assignmentMethod:Function = parseExpression(assignment);
		var result:Function = function() {
			var bf:BeanFactory = arguments.callee.beanFactory;
			var bw:BeanWrapper = arguments.callee.beanWrapper;
			var bn:String = arguments.callee.beanName;
			if (bw.getWrappedBean() == null || !bf.isSingleton(bn)) {
				bw.setWrappedBean(bf.getBeanByName(bn));
			}
			var pn:String = arguments.callee.propertyName;
			var am = arguments.callee.assignment();
			bw.setPropertyValue(new PropertyValue(pn, am));
			return am;
		};
		result.beanFactory = beanFactory;
		result.beanWrapper = new SimpleBeanWrapper();
		result.beanName = beanName;
		result.propertyName = propertyName;
		result.assignment = assignmentMethod;
		return result;
	}

	private function parseExpression(expression:String):Function {
		// Number, string and boolean literals aren't expressions.
		if (!isNaN(expression)) {
			return parseNumberLiteral(expression);
		}
		if (expression == TRUE_BOOLEAN_LITERAL || expression == FALSE_BOOLEAN_LITERAL) {
			return parseBooleanLiteral(expression);
		}
		if (expression.indexOf("\"") == 0) {
			if (expression.lastIndexOf("\"") != expression.length - 1) {
				throw new IllegalArgumentException("String literal [" + expression + "] must be " +
						"properly terminated with a double quote.", this, arguments);
			}
			return parseStringLiteral(expression);
		}
		if (expression.indexOf("'") == 0) {
			if (expression.lastIndexOf("'") != expression.length - 1) {
				throw new IllegalArgumentException("String literal [" + expression + "] must " +
						"be properly terminated with a single quote.", this, arguments);
			}
			return parseStringLiteral(expression);
		}
		var operatorIndex:Number = expression.indexOf(ASSIGNMENT_OPERATOR);
		if (operatorIndex != -1) {
			return parseAssignmentExpression(expression, operatorIndex);
		}
		var prefixIndex:Number = expression.indexOf(ARGUMENT_LIST_PREFIX);
		if (prefixIndex != -1) {
			return parseMethodInvocationExpression(expression, prefixIndex);
		}
		var separatorIndex:Number = expression.indexOf(AbstractBeanWrapper.NESTED_PROPERTY_SEPARATOR);
		//if (separatorIndex != -1) {
		return parsePropertyAccessExpression(expression, separatorIndex);
		//}
		//throw new IllegalArgumentException("Unknown expression [" + expression + "].", this, arguments);
	}

	private function parseNumberLiteral(numberLiteral:String):Function {
		var result:Function = function() {
			return arguments.callee.number;
		};
		result.number = Number(numberLiteral);
		return result;
	}

	private function parseBooleanLiteral(booleanLiteral:String):Function {
		var result:Function = function() {
			return arguments.callee.boolean;
		};
		result.boolean = (booleanLiteral == TRUE_BOOLEAN_LITERAL);
		return result;
	}

	private function parseStringLiteral(stringLiteral:String):Function {
		var result:Function = function() {
			return arguments.callee.string;
		};
		result.string = stringLiteral.substring(1, stringLiteral.length - 1);
		return result;
	}

	private function parseMethodInvocationExpression(expression:String, prefixIndex:Number):Function {
		if (prefixIndex == 0) {
			throw new IllegalArgumentException("Bean and method name of method invocation [" +
					expression + "] are missing.", this, arguments);
		}
		var suffixIndex:Number = expression.lastIndexOf(ARGUMENT_LIST_SUFFIX);
		if (suffixIndex == -1 || suffixIndex < prefixIndex) {
			throw new IllegalArgumentException("Argument list of method invocation ["
					+ expression + "] is not terminated.", this, arguments);
		}
		var method:String = TrimUtil.trim(expression.substring(0, prefixIndex));
		var separatorIndex:Number = method.indexOf(AbstractBeanWrapper.NESTED_PROPERTY_SEPARATOR);
		var beanName:String;
		var methodName:String;
		if (separatorIndex == -1 || separatorIndex > prefixIndex) {
			if (targetBeanName == null) {
				throw new IllegalArgumentException("Either bean or method name [" + method +
						"] of assignment expression [" + expression + "] is missing.",
						this, arguments);
			}
			else {
				beanName = targetBeanName;
				methodName = method;
			}
		}
		else {
			beanName = method.substring(0, separatorIndex);
			methodName = method.substring(separatorIndex + 1);
		}
		var args:String = TrimUtil.trim(expression.substring(prefixIndex + 1, suffixIndex));
		var argMethods:Array;
		if (args != "") {
			// Problem with split: myBean.myMethod(bean.method(1, 2), "string");
			var argTokens:Array = args.split(ARGUMENT_LIST_SEPARATOR);
			argMethods = new Array();
			for (var i:Number = 0; i < argTokens.length; i++) {
				var argToken:String = TrimUtil.trim(argTokens[i]);
				argMethods.push(parseExpression(argToken));
			}
		}
		var result:Function = function() {
			var bean = arguments.callee.bean;
			if (bean == null) {
				var bf:BeanFactory = arguments.callee.beanFactory;
				var bn:String = arguments.callee.beanName;
				bean = bf.getBeanByName(bn);
				if (bf.isSingleton(bn)) {
					arguments.callee.bean = bean;
				}
			}
			var mn:String = arguments.callee.methodName;
			var as:Array = new Array();
			var am:Array = arguments.callee.args;
			for (var i:Number = 0; i < am.length; i++) {
				as.push(am[i]());
			}
			return MethodUtil.invoke(mn, bean, as);
		};
		result.beanFactory = beanFactory;
		result.beanName = beanName;
		result.methodName = methodName;
		result.args = argMethods;
		return result;
	}

	private function parsePropertyAccessExpression(expression:String, separatorIndex:Number):Function {
		var beanName:String;
		var propertyName:String;
		if (separatorIndex == -1) {
			if (targetBeanName == null) {
				throw new IllegalArgumentException("Either bean or property name of property access [" +
						expression + "] is missing.", this, arguments);
			}
			else {
				beanName = targetBeanName;
				propertyName = expression;
			}
		}
		else {
			beanName = expression.substring(0, separatorIndex);
			propertyName = expression.substring(separatorIndex + 1);
		}
		var result:Function = function() {
			var bf:BeanFactory = arguments.callee.beanFactory;
			var bw:BeanWrapper = arguments.callee.beanWrapper;
			var bn:String = arguments.callee.beanName;
			if (bw.getWrappedBean() == null || !bf.isSingleton(bn)) {
				bw.setWrappedBean(bf.getBeanByName(bn));
			}
			var pn:String = arguments.callee.propertyName;
			return bw.getPropertyValue(pn);
		};
		result.beanFactory = beanFactory;
		result.beanWrapper = new SimpleBeanWrapper();
		result.beanName = beanName;
		result.propertyName = propertyName;
		return result;
	}

	public function getObject(property:PropertyAccess) {
		return dataBindingMethod;
	}

	public function getObjectType(Void):Function {
		return Function;
	}

	public function isSingleton(Void):Boolean {
		return true;
	}

}