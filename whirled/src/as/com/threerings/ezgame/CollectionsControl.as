//
// $Id: CollectionsControl.as 271 2007-04-07 00:25:58Z dhoover $
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

/**
 * Contains EZ methods related to collections.
 */
public class CollectionsControl extends SubControl
{
    public function CollectionsControl (ctrl :EZGameControl)
    {
        super(ctrl);
    }

    /**
     * Create a collection containing the specified values,
     * clearing any previous collection with the same name.
     */
    public function create (collName :String, values :Array) :void
    {
        populate(collName, values, true);
    }

    /**
     * Add to an existing collection. If it doesn't exist, it will
     * be created. The new values will be inserted randomly into the
     * collection.
     */
    public function addTo (collName :String, values :Array) :void
    {
        populate(collName, values, false);
    }

    /**
     * Merge the specified collection into the other collection.
     * The source collection will be destroyed. The elements from
     * The source collection will be shuffled and appended to the end
     * of the destination collection.
     */
    public function merge (srcColl :String, intoColl :String) :void
    {
        _ctrl.callEZCodeFriend("mergeCollection_v1", srcColl, intoColl);
    }

    /**
     * Pick (do not remove) the specified number of elements from a collection,
     * and distribute them to a specific player or set them as a property
     * in the game data.
     *
     * @param collName the collection name.
     * @param count the number of elements to pick
     * @param msgOrPropName the name of the message or property
     *        that will contain the picked elements.
     * @param playerId if 0 (or unset), the picked elements should be
     *        set on the gameObject as a property for all to see.
     *        If a playerId is specified, only that player will receive
     *        the elements as a message.
     */
    // TODO: a way to specify exclusive picks vs. duplicate-OK picks?
    public function pick (
        collName :String, count :int, msgOrPropName :String,
        playerId :int = 0) :void
    {
        getFrom(collName, count, msgOrPropName, playerId, false, null);
    }

    /**
     * Deal (remove) the specified number of elements from a collection,
     * and distribute them to a specific player or set them as a property
     * in the game data.
     *
     * @param collName the collection name.
     * @param count the number of elements to pick
     * @param msgOrPropName the name of the message or property
     *        that will contain the picked elements.
     * @param playerId if 0 (or unset), the picked elements should be
     *        set on the gameObject as a property for all to see.
     *        If a playerId is specified, only that player will receive
     *        the elements as a message.
     */
    // TODO: figure out the method signature of the callback
    public function deal (
        collName :String, count :int, msgOrPropName :String,
        callback :Function = null, playerId :int = 0) :void
    {
        getFrom(collName, count, msgOrPropName, playerId, true, callback);
    }


    // == protected methods ==

    /**
     * Helper method for create and addTo.
     */
    protected function populate (
        collName :String, values :Array, clearExisting :Boolean) :void
    {
        _ctrl.callEZCodeFriend("populateCollection_v1", collName, values, clearExisting);
    }

    /**
     * Helper method for pick and deal.
     */
    protected function getFrom (
        collName :String, count :int, msgOrPropName :String, playerId :int,
        consume :Boolean, callback :Function) :void
    {
        _ctrl.callEZCodeFriend("getFromCollection_v2", collName, count, msgOrPropName,
            playerId, consume, callback);
    }
}
}
