//
// $Id: StateChangedEvent.as 271 2007-04-07 00:25:58Z dhoover $
//
// Vilya library - tools for developing networked games
// Copyright (C) 2002-2007 Three Rings Design, Inc., All Rights Reserved
// http://www.threerings.net/code/vilya/
//
// This library is free software; you can redistribute it and/or modify it
// under the terms of the GNU Lesser General Public License as published
// by the Free Software Foundation; either version 2.1 of the License, or
// (at your option) any later version.
//
// This library is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
// Lesser General Public License for more details.
//
// You should have received a copy of the GNU Lesser General Public
// License along with this library; if not, write to the Free Software
// Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

package com.threerings.ezgame {

import flash.events.Event;

/**
 * Dispatched when the state of the game has changed.
 */
public class StateChangedEvent extends EZEvent
{
    /** Indicates that the game has transitioned to a started state. */
    public static const GAME_STARTED :String = "GameStarted";

    /** Indicates that the game has transitioned to a ended state. */
    public static const GAME_ENDED :String = "GameEnded";

    /** Indicates that a round has started. Games that do not require multiple rounds can ignore
     * this event. */
    public static const ROUND_STARTED :String = "RoundStarted";

    /** Indicates that the current round has ended. */
    public static const ROUND_ENDED :String = "RoundEnded";

    /** Indicates that a new controller has been assigned. */
    public static const CONTROL_CHANGED :String = "ControlChanged";

    /** Indicates that the turn has changed. */
    // TODO: move to own event?
    public static const TURN_CHANGED :String = "TurnChanged";

    public function StateChangedEvent (type :String, ezgame :EZGameControl)
    {
        super(type, ezgame);
    }

    override public function toString () :String
    {
        return "[StateChangedEvent type=" + type + "]";
    }

    override public function clone () :Event
    {
        return new StateChangedEvent(type, _ezgame);
    }
}
}
