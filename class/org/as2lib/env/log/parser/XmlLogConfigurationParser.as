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
import org.as2lib.env.log.LogConfigurationParser;
import org.as2lib.env.log.LogManager;
import org.as2lib.env.log.parser.AbstractLogConfigurationParser;
import org.as2lib.env.log.parser.LogConfigurationParseException;
import org.as2lib.env.reflect.ReflectUtil;

/**
 * {@code XmlLogConfigurationParser} parses log configuration files in XML format.
 * 
 * <p>The root node of the configuration file must be "&lt;logging&gt;". Its child
 * nodes' names must correspond to {@code set*} or {@code add*} methods on the given
 * or default log manager: {@link #XmlLogConfigurationParser}. There is only one
 * exception to this rule, the register-node, to which we will come later.
 * 
 * <p>The root node has one special attribute, that is the enabled-attribute. If
 * you set it to false the configuration will not be parsed and logging will thus
 * be disabled.
 * <code>&lt;logging enabled="false"&gt;...&lt;logging/&gt;</code>
 * 
 * <p>Every node except the root-node is a bean. A bean is in this case an instance
 * defined or looked-up via information in xml-format. There are four different
 * types of nodes: normal-, singleton-, method- and variable-nodes.
 * 
 * <p>If you do not specify a specific type-attribute, 'normal' is used by default.
 * A normal-node must have at least a class-attribute, but you can add further
 * attributes corresponding to set-methods of the class and child-nodes corresponding
 * to add- or set-methods of the class. Attributes are treated as primitive type
 * properties, while child-nodes can be primitive type properties or complex properties,
 * beans themselves. A primitive type node looks like this:
 * <code>&lt;level&gt;INFO&lt;level/&gt;</code>
 * 
 * <p>The following example creates an instance of class 'SimpleHierarchicalLogger',
 * sets its name via the {@code setName} method to 'com.simonwacker' and its level
 * via the {@code setLevel} method to 'INFO'. After this is done, the two handlers
 * 'DebugItHandler' and 'TraceHandler' are instantiated and added via the
 * {@code addHandler} method to the logger instance, their parent node. The logger
 * itself will be set or added to its parent node (which is omitted).
 * <code>
 *   &lt;logger name="com.simonwacker" level="INFO" class="org.as2lib.env.log.logger.SimpleHierarchicalLogger"&gt;
 *     &lt;handler class="org.as2lib.env.log.handler.DebugItHandler"/&gt;
 *     &lt;handler class="org.as2lib.env.log.handler.TraceHandler"/&gt;
 *   &lt;/logger&gt;
 * </code>
 * 
 * <p>The attributes 'name' and 'level' and the nodes 'handler' are called properties.
 * Properties are basically methods that follow a specific naming convention. If you
 * specify an attribute named {@code "name"} your bean class must provide a {@code setName}
 * method. If you specify a child node named {@code "handler"}, the bean class must provide
 * a {@code addHandler} or {@code setHandler} method. Child nodes can themselves be beans.
 * 
 * <p>If you specify 'method' as type, the bean is looked-up via a static (per class)
 * method. You must thus specify the class-attribute plus the name-attribute.
 * As with 'normal' nodes you can specify primitive type properties as attributes
 * and complex properties as child nodes to configure the looked-up bean.
 * The following example looks-up a level with the static {@link AbstractLogLevel#forName}
 * method, passing the string-argument 'INFO'.
 * <code>
 *   &lt;logger name="com.simonwacker" class="org.as2lib.env.log.logger.SimpleHierarchicalLogger"&gt;
 *     &lt;level name="forName" class="org.as2lib.env.log.level.AbstractLogLevel" type="method"&gt;INFO&lt;level/&gt;
 *   &lt;/logger&gt;
 * </code>
 * 
 * <p>If you have multiple arguments to pass to the method you can specify method-arg-nodes.
 * These method-arg-nodes may of course be beans themselves (as every node).
 * <code>
 *   &lt;level name="forName" class="org.as2lib.env.log.level.AbstractLogLevel" type="method"&gt;
 *     &lt;method-arg&gt;INFO&lt;/method-arg&gt;
 *   &lt;level/&gt;
 * </code>
 * 
 * <p>If you specifiy 'variable' as type, the bean is looked-up via a static variable.
 * You must again specify the class- and the name-attribute.
 * <code>
 *   &lt;logger name="com.simonwacker" class="org.as2lib.env.log.logger.SimpleHierarchicalLogger"&gt;
 *     &lt;level name="INFO" class="org.as2lib.env.log.level.AbstractLogLevel" type="variable"/&gt;
 *   &lt;/logger&gt;
 * </code>
 * 
 * <p>As you may have noticed, looking-up levels from static methods or variables
 * is not very intuitive they way it is done above. To make everything much more
 * simpler and less to write we can use the register-node, that is as stated above,
 * treated in a special manner. The register-node lets you register default or
 * common configuration for nodes with a specific name or id attribute.
 * 
 * <p>In the following example we set the default level to 'INFO' and the default
 * class to 'org.as2lib.env.log.logger.SimpleHierarchicalLogger' for nodes named
 * 'logger' or for nodes with the id 'logger'. This configuration can be overridden
 * in the specific nodes that inherit this configuration.
 * <code>&lt;register id="logger" level="INFO" class="org.as2lib.env.log.logger.SimpleHierarchicalLogger"/&gt;</code>
 * 
 * <p>The above register-node was for normal nodes, but we can do the same for
 * nodes of type 'method' or 'variable'. In the following example we are registering
 * nodes named 'level' or nodes with the id 'level' or attributes with the name 'level'
 * with method look-ups. Note that attributes are only registered for nodes for
 * registrations of type 'method' or 'variable'.
 * <code>&lt;register id="level" name="forName" class="org.as2lib.env.log.level.AbstractLogLevel" type="method"/&gt;</code>
 * 
 * <p>Given the above registration we can now simply write the following to achieve
 * the same effect as in our first method node example. The {@code forName} method
 * is invoked on the class {@code AbstractLogLevel} with on argument {@code 'INFO'}
 * and the result is set on the logger via the {@code setLevel} method.
 * <code>&lt;logger name="com.simonwacker" level="INFO" class="org.as2lib.env.log.logger.SimpleHierarchicalLogger"&gt;</code>
 * 
 * <p>The same can be achieved with a variable registration. In this case the asterisk
 * is replaced by 'INFO', which is used as variable name to look-up the bean on the
 * {@code AbstractLogLevel} class.
 * <code>&lt;register id="level" name="*" class="org.as2lib.env.log.level.AbstractLogLevel" type="variable"/&gt;</code>
 * 
 * <p>A bean type which we have not taken a look at yet is the singleton. The type
 * singleton may only be used for register-nodes. The instance is created once at
 * the beginning and every node that has the same node name as the registered id
 * or has the same id is treated as a reference to that instance. That said, the
 * configuration of a singleton cannot be overridden.
 * <code>
 *   &lt;register id="stringifier" class="org.as2lib.env.log.stringifier.PatternLogMessageStringifier" type="singleton"&gt;
 *     &lt;constructor-arg&gt;%d{HH:nn:ss.SSS} %7l %n{1}.%O  %m&lt;/constructor-arg&gt;
 *   &lt;/register&gt;
 * </code>
 * 
 * <p>If a node has a name that has a registration, but you do not want to inherit
 * from this default configuration you can specify a different type in this node,
 * to prevent inheritance.
 * 
 * <p>As you have seen, it is also possible to pass constructor arguments. You do
 * this with the constructor-arg-node. Note that the order matters! As you can see
 * in the following example, the constructor-arg can itself be a bean.
 * <code>
 *   &lt;handler class="org.as2lib.env.log.handler.TraceHandler"&gt;
 *     &lt;constructor-arg class="org.as2lib.env.log.stringifier.SimpleLogMessageStringifier"/&gt;
 *   &lt;/handler&gt;
 * </code>
 * 
 * <p>If we wanted the constructor-arg-node to inherit from the 'stringifier' registration
 * we could specify the id attribute.
 * <code>&lt;constructor-arg id="stringifier"/&gt;</code>
 * 
 * <p>If a node- or attribute-value is a primitive type it will automatically
 * be converted. This means the strings {@code "true"} and {@code "false"} are
 * converted to the booleans {@code true} and {@code false} respectively. The
 * strings {@code "1"}, {@code "2"}, ... are converted to numbers. Only if the
 * node- or attribute-value is non of the above 'special cases' it is used as
 * string.
 * <code>
 *   &lt;handler class="org.as2lib.env.log.handler.TraceHandler"&gt;
 *     &lt;constructor-arg class="org.as2lib.env.log.stringifier.PatternLogMessageStringifier"&gt;
 *       &lt;constructor-arg&gt;false&lt;/contructor-arg&gt;
 *       &lt;constructor-arg&gt;true&lt;/contructor-arg&gt;
 *       &lt;constructor-arg&gt;HH:nn:ss.S&lt;/contructor-arg&gt;
 *     &lt;/constructor-arg&gt;
 *   &lt;/handler&gt;
 * </code>
 * 
 * <p>A complete log configuration may look something like this:
 * <code>
 *   &lt;logging&gt;
 *     &lt;register id="logger" class="org.as2lib.env.log.logger.SimpleHierarchicalLogger"/&gt;
 *     &lt;register id="handler" class="org.as2lib.env.log.handler.TraceHandler"/&gt;
 *     &lt;register id="level" name="forName" class="org.as2lib.env.log.level.AbstractLogLevel" type="method"/&gt;
 *     &lt;register id="stringifier" class="org.as2lib.env.log.stringifier.PatternLogMessageStringifier" type="singleton"&gt;
 *       &lt;constructor-arg&gt;%d{HH:nn:ss.SSS} %7l %n{1}.%O  %m&lt;/constructor-arg&gt;
 *     &lt;/register&gt;
 *     &lt;loggerRepository class="org.as2lib.env.log.repository.LoggerHierarchy"&gt;
 *       &lt;logger name="main" level="ERROR"&gt;
 *         &lt;handler&gt;&lt;constructor-arg id="stringifier"/&gt;&lt;/handler&gt;
 *       &lt;/logger&gt;
 *       &lt;logger name="org.as2lib.sample.filebrowser"&gt;
 *         &lt;handler class="org.as2lib.env.log.handler.LevelFilterHandler"&gt;
 *           &lt;constructor-arg id="handler"&gt;&lt;constructor-arg id="stringifier"/&gt;&lt;/constructor-arg&gt;
 *           &lt;constructor-arg id="level"&gt;INFO&lt;/constructor-arg&gt;
 *         &lt;/handler&gt;
 *       &lt;/logger&gt;
 *       &lt;logger name="org.as2lib.env.log.aspect.TraceLoggingAspect"&gt;
 *         &lt;handler&gt;
 *           &lt;constructor-arg class="org.as2lib.env.log.stringifier.SimpleLogMessageStringifier"/&gt;
 *         &lt;/handler&gt;
 *       &lt;/logger&gt;
 *     &lt;/loggerRepository&gt;
 *   &lt;/logging&gt;
 * </code>
 * 
 * @author Simon Wacker
 */
class org.as2lib.env.log.parser.XmlLogConfigurationParser extends AbstractLogConfigurationParser implements LogConfigurationParser {
	
	/** Indicates the normal and default type of a node. */
	public static var NORMAL_TYPE:String = "normal";
	
	/** Indicates that the node shall be handled as a singleton. */
	public static var SINGLETON_TYPE:String = "singleton";
	
	/** Indicates that the node shall be handled as a method invocation. */
	public static var METHOD_TYPE:String = "method";
	
	/** Indicates that the node shall be handled as a variable look-up. */
	public static var VARIABLE_TYPE:String = "variable";
	
	/** Node name for constructor arguments. */
	public static var CONSTRUCTOR_ARGUMENT_NODE:String = "constructor-arg";
	
	/** Node name for method arguments. */
	public static var METHOD_ARGUMENT_NODE:String = "method-arg";
	
	/** Id-definition registrations. */
	private var definitions;
	
	/** Id-singleton registrations. */
	private var singletons;
	
	/** The manager to configure. */
	private var manager;
	
	/**
	 * Constructs a new {@code XmlLogConfigurationParser} instance.
	 * 
	 * <p>If {@code logManager} is {@code null} or {@code undefined}, {@link LogManager}
	 * will be used by default.
	 * 
	 * @param logManager (optional) the manager to configure with the beans specified
	 * in the log configuration XML-file
	 */
	public function XmlLogConfigurationParser(logManager) {
		if (logManager) {
			this.manager = logManager;
		} else {
			this.manager = LogManager;
		}
		definitions = new Object();
		singletons = new Object();
	}
	
	/**
	 * Registers the given {@code clazz} for the given {@code id}.
	 * 
	 * <p>Previous registrations for the same id get overwritten.
	 * 
	 * @param id the id to register the {@code clazz} with
	 * @param clazz the class to register with the {@code id}
	 */
	public function registerClazz(id:String, clazz:Function):Void {
		// name 'registerClass' hides fungtion in ancestor class in Flex
		var node:XMLNode = new XMLNode(1, "register");
		node.attributes["class"] = clazz;
		definitions[id] = node;
	}
	
	/**
	 * Parses the log configuration. If argument {@code xmlLogConfiguration} is
	 * {@code null} or {@code undefined} the one returned by {@link #getLogConfiguration}
	 * will be used.
	 * 
	 * @param xmlLogConfiguration XML log configuration
	 * @throws IllegalArgumentException if argument {@code xmlLogConfiguration} is
	 * {@code null} or {@code undefined} and no log configuration was set via
	 * {@link #setLogConfiguration} previously
	 * @throws LogConfigurationParseException if the bean definition could not be parsed
	 */
	public function parse(xmlLogConfiguration:String):Void {
		if (xmlLogConfiguration == null) {
			xmlLogConfiguration = getLogConfiguration();
			if (xmlLogConfiguration == null) {
				throw new IllegalArgumentException("Either argument 'xmlLogConfiguration' " +
						"must be supplied or the log configuration must be set via " +
						"'setLogConfiguration' before invoking this method.", this, arguments);
			}
		}
		var rootNode:XMLNode = parseXml(xmlLogConfiguration);
		if (rootNode.attributes.enabled != "false") {
			var childNodes:Array = rootNode.childNodes;
			for (var i:Number = 0; i < childNodes.length; i++) {
				var childNode:XMLNode = childNodes[i];
				if (childNode.nodeName == "register") {
					parseRegisterNode(childNode);
				} else {
					var methodName:String = findMethodName(manager, childNode.nodeName, ["set", "add"]);
					var childBean = parseBeanDefinition(childNode);
					manager[methodName](childBean);
				}
			}
		}
		definitions = new Object();
		singletons = new Object();
	}
	
	/**
	 * Parses the given {@code xmlLogConfiguration} and returns the root-node.
	 * 
	 * @param xmlLogConfiguration the string to parse
	 * @return the root-node of the given xml log configuration
	 * @throws LogConfigurationParseException if the xml log configuration could not be
	 * parsed because of a malformed xml
	 */
	private function parseXml(xmlLogConfiguration:String):XMLNode {
		var xml:XML = new XML();
		xml.ignoreWhite = true;
		xml.parseXML(xmlLogConfiguration);
		if (xml.status != 0) {
			throw new LogConfigurationParseException("XML log configuration [" + xmlLogConfiguration + "] is syntactically malformed.", this, arguments);
		}
		if (xml.lastChild.nodeName != "logging") {
			throw new LogConfigurationParseException("There must be a root node named 'logging'.", this, arguments);
		}
		return xml.lastChild;
	}
	
	/**
	 * Parses the given {@code registerNode}.
	 * 
	 * @param registerNode the register node to parse
	 */
	private function parseRegisterNode(registerNode:XMLNode):Void {
		var id:String = registerNode.attributes.id;
		delete registerNode.attributes.id;
		if (registerNode.attributes.type == SINGLETON_TYPE) {
			delete registerNode.attributes.type;
			singletons[id] = parseBeanDefinition(registerNode);
			return;
		}
		definitions[id] = registerNode;
	}
	
	/**
	 * Parses the given {@code beanDefinition} and returns the resulting bean.
	 * 
	 * @param beanDefinition the definition to create a bean of
	 * @return the bean resulting from the given {@code beanDefinition}
	 * @throws LogConfigurationParseException if the bean definition could not be parsed
	 * because of for example missing information
	 */
	private function parseBeanDefinition(beanDefinition:XMLNode) {
		if (!beanDefinition) {
			throw new IllegalArgumentException("Argument 'beanDefinition' [" + beanDefinition + "] must not be 'null' nor 'undefined'", this, arguments);
		}
		if (isSingleton(beanDefinition)) {
			return getSingleton(beanDefinition);
		}
		if (hasRegisteredBeanDefinition(beanDefinition)) {
			mergeBeanDefinitions(beanDefinition, getRegisteredBeanDefinition(beanDefinition));
		}
		delete beanDefinition.attributes.id;
		if (beanDefinition.attributes["class"] == null) {
			throw new LogConfigurationParseException("Node [" + beanDefinition.nodeName + "] has no class. You must either specify the 'class' attribute or register it to a class.", this, arguments);
		}
		var beanClass:Function;
		var className:String;
		if (typeof(beanDefinition.attributes["class"]) == "string") {
			className = beanDefinition.attributes["class"];
			beanClass = findClass(className);
			if (!beanClass) {
				throw new LogConfigurationParseException("A class corresponding to the class name [" + className + "] of node [" + beanDefinition.nodeName + "] could not be found. You either misspelled the class name or forgot to import the class in your swf.", this, arguments);
			}
		} else {
			beanClass = beanDefinition.attributes["class"];
		}
		delete beanDefinition.attributes["class"];
		var bean;
		var childNodes:Array = beanDefinition.childNodes;
		var beanType:String = beanDefinition.attributes.type;
		delete beanDefinition.attributes.type;
		if (beanType == NORMAL_TYPE || beanType == null) {
			bean = new Object();
			bean.__proto__ = beanClass.prototype;
			bean.__constructor__ = beanClass;
			beanClass.apply(bean, extractNodes(childNodes, CONSTRUCTOR_ARGUMENT_NODE));
		} else if (beanType == METHOD_TYPE) {
			var methodName:String = beanDefinition.attributes.name;
			delete beanDefinition.attributes.name;
			if (methodName == null) {
				throw new LogConfigurationParseException("Node [" + beanDefinition.nodeName + "] of type [" + METHOD_TYPE + "] does not have the required name-attribute.", this, arguments);
			}
			var args:Array;
			if (beanDefinition.firstChild.nodeValue == null) {
				args = extractNodes(childNodes, METHOD_ARGUMENT_NODE);
			} else {
				args = [convertValue(beanDefinition.firstChild.nodeValue)];
			}
			if (beanClass[methodName] == null) {
				if (className == null) className = ReflectUtil.getTypeNameForType(beanClass);
				throw new LogConfigurationParseException("A static method with name [" + methodName + "] does not exist on class [" + className + "].", this, arguments);
			}
			bean = beanClass[methodName].apply(beanClass, args);
		} else if (beanType == VARIABLE_TYPE) {
			var variableName:String = beanDefinition.attributes.name;
			delete beanDefinition.attributes.name;
			if (variableName == null) {
				throw new LogConfigurationParseException("Node [" + beanDefinition.nodeName + "] of type [" + VARIABLE_TYPE + "] does not have the required name-attribute.", this, arguments);
			}
			if (variableName == "*") {
				variableName = beanDefinition.firstChild.nodeValue;
			}
			if (beanClass[variableName] === undefined) {
				if (className == null) className = ReflectUtil.getTypeNameForType(beanClass);
				throw new LogConfigurationParseException("A static variable with name [" + variableName + "] does not exist on class [" + className + "].", this, arguments);
			}
			bean = beanClass[variableName];
		}
		parseAttributes(bean, beanDefinition.attributes);
		parseNodes(bean, childNodes);
		return bean;
	}
	
	/**
	 * Checks whether the given bean definition is a singleton.
	 * 
	 * @param beanDefinition the bean definition that may be a singleton
	 * @return {@code true} if the given {@code beanDefinition} is a singleton else
	 * {@code false}
	 */
	private function isSingleton(beanDefinition:XMLNode):Boolean {
		if (beanDefinition.attributes.type != null
				&& beanDefinition.attributes.type != SINGLETON_TYPE) {
			return false;
		}
		return (getSingleton(beanDefinition) != null);
	}
	
	/**
	 * Returns the singleton for the given bean definition.
	 * 
	 * @param beanDefinition the bean definition to return a singleton for
	 * @return the singleton
	 */
	private function getSingleton(beanDefinition:XMLNode) {
		var result = singletons[beanDefinition.attributes.id];
		if (result == null) {
			result = singletons[beanDefinition.nodeName];
		}
		return result;
	}
	
	/**
	 * Returns whether the given bean definition has a registered bean definition.
	 * 
	 * @param beanDefinition the bean definition
	 * @return {@code true} if there is a registered bean definition, otherwise {@code false}
	 */
	private function hasRegisteredBeanDefinition(beanDefinition:XMLNode):Boolean {
		var registeredBeanDefinition:XMLNode = getRegisteredBeanDefinition(beanDefinition);
		if (registeredBeanDefinition == null) return false;
		if (beanDefinition.attributes.type != null) {
			return (beanDefinition.attributes.type == registeredBeanDefinition.attributes.type);
		}
		return true;
	}
	
	/**
	 * Returns the bean definition registered for the given {@code beanDefinition}.
	 * 
	 * @param beanDefinition the bean definition to return a registered definition for
	 * @return the registered bean definition
	 */
	private function getRegisteredBeanDefinition(beanDefinition:XMLNode):XMLNode {
		var result:XMLNode = definitions[beanDefinition.attributes.id];
		if (result == null) {
			result = definitions[beanDefinition.nodeName];
		}
		return result;
	}
	
	/**
	 * Merges the two bean definitions.
	 * 
	 * @param beanDefinition the base bean definition
	 * @param registeredBeanDefinition the registered bean definitions to merge into the
	 * base bean definition
	 */
	private function mergeBeanDefinitions(beanDefinition:XMLNode, registeredBeanDefinition:XMLNode):Void {
		var attributes:Object = registeredBeanDefinition.attributes;
		for (var n:String in attributes) {
			if (beanDefinition.attributes[n] == null) {
				beanDefinition.attributes[n] = registeredBeanDefinition.attributes[n];
			}
		}
		var childNodes:Array = registeredBeanDefinition.childNodes;
		for (var i:Number = 0; i < childNodes.length; i++) {
			var childrenNode:XMLNode = childNodes[i];
			beanDefinition.appendChild(childrenNode.cloneNode(true));
		}
	}
	
	/**
	 * Extracts nodes with the given {@code nodeName} from the given {@code nodes}
	 * array.
	 * 
	 * @param nodes the nodes to extract from
	 * @return the extracted and parsed nodes
	 */
	private function extractNodes(nodes:Array, nodeName:String):Array {
		var result:Array = new Array();
		for (var i:Number = 0; i < nodes.length; i++) {
			var childNode:XMLNode = nodes[i];
			if (childNode.nodeName == nodeName) {
				if (childNode.firstChild.nodeValue == null) {
					result.push(parseBeanDefinition(childNode));
				} else {
					result.push(convertValue(childNode.firstChild.nodeValue));
				}
				nodes.splice(i, 1);
				i--;
			}
		}
		return result;
	}
	
	/**
	 * Parses the nodes attributes.
	 * 
	 * @param bean the bean to set the attributes on
	 * @param attributes the nodes attributes for the given {@code bean}
	 */
	private function parseAttributes(bean, attributes):Void {
		for (var n:String in attributes) {
			var methodName:String = findMethodName(bean, n, ["set"]);
			var value:String = attributes[n];
			if (definitions[n].attributes.type == METHOD_TYPE
					|| definitions[n].attributes.type == VARIABLE_TYPE) {
				var className:String = definitions[n].attributes["class"];
				var clazz:Function = findClass(className);
				if (clazz == null) {
					throw new LogConfigurationParseException("A class with the name [" + className + "] could not be found.", this, arguments);
				}
				var name:String = definitions[n].attributes.name;
				if (definitions[n].attributes.type == METHOD_TYPE) {
					if (clazz[name] == null) {
						throw new LogConfigurationParseException("A static method with name [" + name + "] does not exist on the class [" + className + "].", this, arguments);
					}
					bean[methodName](clazz[name](value));
					continue;
				}
				if (definitions[n].attributes.type == VARIABLE_TYPE) {
					if (name == "*") {
						name = value;
					}
					if (clazz[name] === undefined) {
						throw new LogConfigurationParseException("A static variable with name [" + name + "] does not exist on the class [" + className + "].", this, arguments);
					}
					bean[methodName](clazz[name]);
					continue;
				}
			}
			bean[methodName](convertValue(value));
		}
	}
	
	/**
	 * Parses the nodes.
	 * 
	 * @param bean the bean to set the nodes on
	 * @param nodes the nodes to parse
	 */
	private function parseNodes(bean, nodes:Array):Void {
		for (var i:Number = 0; i < nodes.length; i++) {
			var childNode:XMLNode = nodes[i];
			var childName:String = childNode.nodeName;
			var methodName:String = findMethodName(bean, childName, ["add", "set"]);
			if (childNode.firstChild.nodeValue == null) {
				bean[methodName](parseBeanDefinition(childNode));
			} else {
				bean[methodName](convertValue(childNode.firstChild.nodeValue));
			}
		}
	}
	
	/**
	 * Finds the method name that exists on the given {@code object}. The base {@code name}
	 * is combined with either of the given {@code prefixes} and it is checked whether
	 * such a method exists on the {@code object}.
	 * 
	 * @param object the object to check whether it contains a method with the given base
	 * name and either of the prefixes
	 * @param name the base name
	 * @param prefixes the prefixes as {@code String} values to combine with the base name
	 * @return the method name that exists on the {@code object}
	 * @throws LogConfigurationParseException if there is no name-prefix combination that exists
	 * on the given {@code object}
	 */
	private function findMethodName(bean, name:String, prefixes:Array):String {
		for (var i:Number = 0; i < prefixes.length; i++) {
			var result:String = generateMethodName(prefixes[i], name);
			if (existsMethod(bean, result)) {
				return result;
			}
		}
		throw new LogConfigurationParseException("There is no method with the base name [" + name + "] combined with any of the prefixes [" + prefixes + "] on the bean [" + bean + "].", this, arguments);
	}
	
}