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

import org.as2lib.data.type.Time;
import org.as2lib.env.event.EventSupport;

/**
 * {@code AbstractTimeConsumer} provides methods to measure execution time.
 *
 * <p>The concrete implementation needs to take care of {@code startTime},
 * {@code endTime}, {@code getPercentage}, {@code started} and {@code finished}.
 *
 * @author Martin Heidegger
 * @author Simon Wacker
 * @version 1.0
 */
class org.as2lib.app.exec.AbstractTimeConsumer extends EventSupport {

	/** The time stamp at which execution started. */
	private var startTime:Number;

	/** The time stamp at which execution finished. */
	private var endTime:Number;

	/** The current duration. */
	private var duration:Time;

	/** The total execution time. */
	private var totalTime:Time;

	/** The time still needed for the execution. */
	private var restTime:Time;

	/** Has execution already started? */
	private var started:Boolean;

	/** Has execution already finished? */
	private var finished:Boolean;

	/**
	 * Constructs a new {@code AbstractTimeConsumer} instance.
	 */
	public function AbstractTimeConsumer(Void) {
		duration = new Time(0);
		totalTime = new Time(0);
		restTime = new Time(0);
		started = false;
		finished = false;
	}

	/**
	 * Returns {@code true} if execution has already started.
	 *
	 * <p>If execution has already finished {@code false} will be returned.
	 *
	 * @return {@code true} if execution has already started else {@code false}
	 */
	public function hasStarted(Void):Boolean {
		return started;
	}

	/**
	 * Returns {@code true} if execution has already finished.
	 *
	 * <p>If execution has not started yet {@code false} will be returned.
	 *
	 * @return {@code true} if execution has already finished else {@code false}
	 */
	public function hasFinished(Void):Boolean {
		return finished;
	}

    /**
     * Returns the execution progress in percent.
     *
     * <p>Note that this implementation just returns {@code null}; override this method
     * in subclasses to reutrn an actual value.
     *
     * @return the current execution progress in percent
     */
    public function getPercentage(Void):Number {
		return null;
	}

	/**
	 * Returns the time needed for the execution (until now).
	 *
	 * <p>If execution has already finished, the totally needed execution time will be
	 * returned. Otherwise the time needed from the start of the execution until this
	 * point in the execution will be returned.
	 *
	 * @return the time needed for executing this process (until now)
	 */
	public function getDuration(Void):Time {
		if (endTime == null) {
			return duration.setValue(getTimer() - startTime);
		}
		else {
			return duration.setValue(endTime - startTime);
		}
	}

	/**
	 * Estimates the time needed for the total execution.
	 *
	 * @return the estimated total time needed for the execution
	 */
	public function getEstimatedTotalTime(Void):Time {
		if ((hasStarted() || hasFinished()) && getPercentage() != null) {
			return totalTime.setValue(getDuration().inMilliSeconds() / getPercentage() * 100);
		}
		return null;
	}

	/**
	 * Estimates the rest time needed until the execution finishes.
	 *
	 * @return the estimated rest time needed for the execution
	 */
	public function getEstimatedRestTime(Void):Time {
		var totalTime:Time = getEstimatedTotalTime();
		if (totalTime != null) {
			return (restTime.setValue(getEstimatedTotalTime().inMilliSeconds() -
					getDuration().inMilliSeconds()));
		}
		return null;
	}

}