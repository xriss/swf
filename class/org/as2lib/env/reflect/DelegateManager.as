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
import org.as2lib.data.holder.Map;
import org.as2lib.data.holder.map.HashMap;
import org.as2lib.env.overload.Overload;
import org.as2lib.env.reflect.Delegate;

/**
 * {@code DelegateManager} provides proxy method for {@link Delegate#create} that cache 
 * created delegates. Also it provides routines allowed to manage cached delegates.
 * 
 * <p>Each {@code Delegate#create} call returns a new instance of the delegate for the 
 * passed-in method and scope. It causes inconvenience using delegates as event listeners
 * with the MX-like event dispatching model. It requires to create special class members
 * to store references to the created delegates to remove event listeners later.
 * 
 * <p>Delegate methods obtained through {@code DelegateManager} class are cached. So
 * every {@code DelegateManager#create} call for the same scope and method will return
 * the same delegate.
 * 
 * <p>Example:
 * <code>
 *   import mx.controls.Button;
 *   import org.as2lib.env.reflect.DelegateManager;
 *   
 *   class com.domain.MyClass {
 *   	private var myButton:Button; 
 *   
 *   	public function MyClass(Void) {
 *	 		myButton = Button(_root.attachMovie("Button", "myButton", 0));
 *	 		myButton.addEventListener("click", DelegateManager.create(this, onButtonClick));
 *	 	}
 *	   
 *   	private function onButtonClick():Void {
 *   		trace("Click!");
 *   		myButton.removeEventListener("click", DelegateManager.remove(this, onButtonClick));
 *   	}
 *   }
 *  
 * </code>
 * 
 * @author Igor Sadovskiy
 * @version 1.1
 * @see org.as2lib.env.reflect.Delegate
 */
class org.as2lib.env.reflect.DelegateManager extends BasicClass {
	
	/** Scope cache for delegates. */
	private static var scopeCache:Map;
	
	/**
	 * Looks if a delegate method for the given {@code scope} and {@code method} already
	 * has been created by the {@code #create} method and returns it if found.
	 * Otherwise a new delegate is created and put into the cache so it can be
	 * reused in the future. {@code method} could be both method's name or reference 
	 * to the method. 
	 * 
	 * <p>Note, delegates created for the same {@code scope} and {@code method}
	 * but used different method's representation types (for example, first as 
	 * {@code String} and second as {@code Function}) will be represented by different 
	 * delegates in the cache. 
	 * 
	 * @param scope the scope to invoke the given {@code method} on
	 * @param method the reference to the method or method's name to invoke on the 
	 * given {@code scope}
	 * @return the method that delegates invocations to the given {@code method} on the
	 * given {@code scope}
	 * @see Delegate#createByMethod
	 * @see Delegate#createByName
	 */
	public static function create(scope, method):Function {
		// checks if cache is initialized
		if (scopeCache == null) scopeCache = new HashMap();
		
		// checks for delegate cache in the scope cache
		var delegateCache:Map = scopeCache.get(scope);
		if (delegateCache == null) {
			delegateCache = new HashMap();
			scopeCache.put(scope, delegateCache);
		}
		
		// checks delegate cache for delegate
		var delegate:Function = delegateCache.get(method);
		if (delegate == null) {
			delegate = Delegate.create(scope, method);
			delegateCache.put(method, delegate);
		}
		
		return delegate;
	}
	
	/**
	 * Removes delegate method for the given {@code scope} and {@code method} if it 
	 * already has been created by the {@code #create} method from the cache and returns 
	 * a reference to. {@code method} could be both method's name or reference 
	 * to the method. 
	 * 
	 * @param scope the scope to invoke the given {@code method} on
	 * @param method the reference to the method or method's name to invoke on the 
	 * given {@code scope}
	 * @return the method that delegates invocations to the given {@code method} on the
	 * given {@code scope} stored in cache. If specified {@code method} for the given 
	 * {@code scope} isn't found in cache returns {@code null}.
	 * @see #create
	 */
	public static function remove(scope, method):Function {
		if (scopeCache == null) return null;
		
		var delegateCache:Map = scopeCache.get(scope);
		if (delegateCache == null) return null;
		
		return delegateCache.remove(method);
	}
	
	/**
	 * Removes all delegates from cache for the given {@code scope} regardless of method's 
	 * type. If {@code scope} isn't specified clears all delegates for all scopes.
	 * 
	 * @param scope the scope which delegates must be removed from cache. If {@code scope}
	 * isn't specified all delegates for all scopes will be removed.
	 */
	public static function clear(scope):Void {
		if (scope != null) {
			Map(scopeCache.get(scope)).clear();	
		} else { 
			scopeCache.clear();
		}
	}
	
	/**
	 * Constructs a new {@code DelegateManager} instance.
	 */
	private function DelegateManager(Void) {
	}
	
}