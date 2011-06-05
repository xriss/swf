//
// $Id$
//
// Copyright (c) 2007 Three Rings Design, Inc.  Please do not redistribute.

package com.whirled {

import flash.display.DisplayObject;
import flash.errors.IllegalOperationError;

import com.threerings.util.Util;

/**
 * Dispatched when the user controlling this avatar speaks. You may trigger a speak animation off
 * of this event.
 * 
 * @eventType com.whirled.ControlEvent.AVATAR_SPOKE
 */
[Event(name="avatarSpoke", type="com.whirled.ControlEvent")]

/**
 * Dispatched when the user controlling this avatar triggers an action.
 * 
 * @eventType com.whirled.ControlEvent.ACTION_TRIGGERED
 */
[Event(name="actionTriggered", type="com.whirled.ControlEvent")]

/**
 * Defines the mechanism by which avatars interact with the world view.
 */
public class AvatarControl extends ActorControl
{
    /**
     */
    public function AvatarControl (disp :DisplayObject)
    {
        super(disp);
    }

    /**
     * Register the named actions that can be used to animate the avatar.  Actions are "one-time"
     * events that cause the avatar to do something in the whirled, like laugh, play a sound, or do
     * a quick animation.  Actions are different from states- states are persistent and do not go
     * away if you walk, talk, or play actions.
     *
     * Note: actions must be 64 characters or less.
     */
    public function registerActions (... actions) :void
    {
        actions = Util.unfuckVarargs(actions);
        verifyActionsOrStates(actions, true);
        _actions = actions;
    }

    /**
     * Register the named states that this actor may be in.
     *
     * States are persistent. An actor may only be in one state at a time.  If the actor is in a
     * state and then needs to walk, talk, or play an action, then it should still be in the state
     * during and after those actions.
     *
     * When an actor is first instantiated, it is in the normal state.  If no states are registered
     * then there is an implicit unnamed normal state.
     *
     * States are different from actions- actions are not persistent and are instantly forgotten as
     * soon as you play them. If an action is a laugh animation that plays for 5 seconds, someone
     * who walks in the room 1 second after you laugh will see nothing.
     *
     * The first registered state will be your "default" state. If you call getState() without
     * registering states you will get null.
     *
     * Note: states must be 64 characters or less.
     */
    public function registerStates (... states) :void
    {
        states = Util.unfuckVarargs(states);
        verifyActionsOrStates(states, false);
        _states = states;
    }

    /**
     * Is this avatar "sleeping"? An avatar is sleeping either when a user has intentially gone AFK
     * (away from keyboard) or have let their client go idle, and zzz's appear over their head. You
     * may react to isSleeping (if you want) to render a sleep state, or transition to an
     * unregistered state that looks like sleeping.
     *
     * Whenever this value changes an APPEARANCE_CHANGED event will be generated.
     */
    public function isSleeping () :Boolean
    {
        return _isSleeping;
    }

    /**
     * Set this avatar's preferred height off the ground, in pixels.  If unset, it defaults to 0,
     * meaning that it walks on the ground.
     *
     * Calling this does not adjust the current location.
     */
    public function setPreferredY (pixels :int) :void
    {
        callHostCode("setPreferredY_v1", pixels);
    }

    // documentation in ActorControl
    override public function setState (state :String) :void
    {
        // translate to null if setting to the default state
        if (_states.length > 0 && state == _states[0]) {
            state = null;
        }
        super.setState(state);
    }

    // documentation in ActorControl
    override public function getState () :String
    {
        // if the state is null, call it by the name of the first registered state
        var state :String = super.getState();
        if (state == null && _states.length > 0) {
            state = String(_states[0]);
        }
        return state;
    }

    override protected function populateProperties (o :Object) :void
    {
        super.populateProperties(o);

        o["avatarSpoke_v1"] = avatarSpoke_v1;
        o["getActions_v1"] = getActions_v1;
        o["getStates_v1"] = getStates_v1;
    }

    override protected function gotInitProperties (o :Object) :void
    {
        super.gotInitProperties(o);

        _isSleeping = (o["isSleeping"] as Boolean);
    }

    protected function avatarSpoke_v1 () :void
    {
        dispatch(ControlEvent.AVATAR_SPOKE);
    }

    /** 
     * Get the names of all the current actions.
     */
    protected function getActions_v1 () :Array
    {
        return _actions;
    }

    /**
     * Get the names of all the current states.
     */
    protected function getStates_v1 () :Array
    {
        return _states;
    }

    override protected function appearanceChanged_v2 (
        location :Array, orient :Number, moving :Boolean, sleeping :Boolean) :void
    {
        // we need to catch sleeping here (ActorControl doesn't care)
        _isSleeping = sleeping;
        // but our superclass will catch the rest and dispatch the event
        super.appearanceChanged_v2(location, orient, moving, sleeping);
    }

    /**
     * Helpy method to verify that the actions or states are legal.
     */
    protected function verifyActionsOrStates (vals :Array, isAction :Boolean) :void
    {
        var name :String = isAction ? "action" : "state";
        for (var ii :int = 0; ii < vals.length; ii++) {
            // null is a valid state/action, but otherwise must be a String less than 64 chars
            if (vals[ii] != null) {
                if (!(vals[ii] is String)) {
                    throw new ArgumentError("All " + name + "s must be Strings (" + ii + ").");
                }
                if (String(vals[ii]).length > 64) {
                    throw new ArgumentError("All " + name + "s must be less than 64 characters.");
                }
            }
            for (var jj :int = 0; jj < ii; jj++) {
                if (vals[jj] === vals[ii]) {
                    throw new ArgumentError("Duplicate " + name + " specified: " +
                        vals[ii]);
                }
            }
        }
    }

    override protected function isAbstract () :Boolean
    {
        return false;
    }

    /** An array of all action names. */
    protected var _actions :Array = [];

    /** An array of state names. */
    protected var _states :Array = [];

    /** Is this avatar asleep? */
    protected var _isSleeping :Boolean;
}
}
