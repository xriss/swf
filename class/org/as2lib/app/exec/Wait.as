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
import org.as2lib.env.event.impulse.FrameImpulseListener;
import org.as2lib.env.event.impulse.FrameImpulse;

/**
 * {@code Wait} is a util to interrupt execution for a defined amount of frames
 * 
 * <p>In case you want to interrupt a batch to wait until some operation has
 * finished just instanciate this class and add it to the batch.
 * 
 * @author Martin Heidegger
 * @version 1.0
 */
class org.as2lib.app.exec.Wait extends AbstractProcess implements FrameImpulseListener {
	
	/** Counts the amount of frames alreadz waited */
	private var alreadyWaited:Number = 0;
	
	/** Holds the amount of frames to wait */
	private var amountOfFrames:Number;
	
	/**
	 * Creates a new instance of {@code Wait}.
	 * 
	 * @param amountOfFrames amount of frames to wait
	 */
	public function Wait(amountOfFrames:Number) {
		super();
		this.amountOfFrames = amountOfFrames;
	}
	
	/**
	 * Implementation of abstract method to start the process.
	 */
	public function run(Void):Void {
		FrameImpulse.getInstance().addListener(this);
		working = true;
	}
	
	/**
	 * Listener implementation to react at frame impulse.
	 * 
	 * @param impulse Source of the impulse.
	 */
	public function onFrameImpulse(impulse:FrameImpulse):Void {
		alreadyWaited ++;
		if (alreadyWaited == amountOfFrames) {
			FrameImpulse.getInstance().removeListener(this);
			finish();
		}
	}

}