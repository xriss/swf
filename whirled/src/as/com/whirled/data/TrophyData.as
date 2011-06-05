//
// $Id$
//
// Copyright (c) 2007 Three Rings Design, Inc. Please do not redistribute.

package com.whirled.data {

/**
 * Contains information on a trophy offered by this game.
 */
public class TrophyData extends GameData
{
    public function TrophyData ()
    {
        // nada
    }

    // from GameData
    override public function getType () :int
    {
        return TROPHY_DATA;
    }
}
}
