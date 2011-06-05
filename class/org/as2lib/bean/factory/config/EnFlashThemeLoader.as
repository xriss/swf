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

import org.as2lib.app.exec.AbstractProcess;
import org.as2lib.bean.factory.InitializingBean;
import org.as2lib.env.except.IllegalArgumentException;

import com.asual.enflash.managers.ThemeManager;

/**
 * @author Simon Wacker
 */
class org.as2lib.bean.factory.config.EnFlashThemeLoader extends AbstractProcess implements
		InitializingBean {
	
	private var themeManager:ThemeManager;
	
	public function EnFlashThemeLoader(Void) {
	}
	
	public function getThemeManager(Void):ThemeManager {
		return themeManager;
	}
	
	public function setThemeManager(themeManager:ThemeManager):Void {
		this.themeManager = themeManager;
	}
	
	public function afterPropertiesSet(Void):Void {
		if (themeManager == null) {
			throw new IllegalArgumentException("Theme manager is required.", this, arguments);
		}
		if (getName() == null) {
			setName(themeManager.theme.url);
		}
	}
	
	private function run() {
		working = true;
		themeManager.addEventListener("themeload", this, finish);
	}
	
}