//
// $Id$
//
// Copyright (c) 2007 Three Rings Design, Inc.  Please do not redistribute.

package com.whirled {

import flash.display.DisplayObject;

/**
 * Dispatched to pets, when they overhear chatter in the room.
 * 
 * @eventType com.whirled.ControlEvent.RECEIVED_CHAT
 */
[Event(name="receivedChat", type="com.whirled.ControlEvent")]

/**
 * Defines actions, accessors and callbacks available to all Pets.
 */
public class PetControl extends ActorControl
{
    /**
     * Creates a controller for a Pet. The display object is the Pet's visualization.
     */
    public function PetControl (disp :DisplayObject)
    {
        super(disp);
    }

    override protected function isAbstract () :Boolean
    {
        return false;
    }

    // from WhirledControl
    override protected function populateProperties (o :Object) :void
    {
        super.populateProperties(o);

        o["receivedChat_v1"] = receivedChat_v1;
    }

    /**
     * Send a chat message to the entire room. The chat message will be treated as if it
     * were typed in at the chat message box - it will be filtered, and any action commands
     * (e.g. /emote) will be handled appropriately.
     */
    public function sendChatMessage (msg :String) :void
    {
        callHostCode("sendChatMessage_v1", msg);
    }

    /**
     * Called when the pet is overhearing a line of chatter in the room.
     * If this instance of the pet has control, it will dispatch a new receivedChat event,
     * otherwise the line will be ignored.
     */
    protected function receivedChat_v1 (speaker :String, message :String) :void
    {
        if (_hasControl) {
            dispatch(ControlEvent.RECEIVED_CHAT, speaker, message);
        }
    }
}
}
