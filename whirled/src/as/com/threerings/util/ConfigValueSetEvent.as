//
// $Id: ConfigValueSetEvent.as 4734 2007-06-14 17:40:52Z mdb $
//
// Narya library - tools for developing networked games
// Copyright (C) 2002-2007 Three Rings Design, Inc., All Rights Reserved
// http://www.threerings.net/code/narya/
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

package com.threerings.util {

import flash.events.Event;

/**
 * Dispatched whenever a config value is changed.
 */
public class ConfigValueSetEvent extends Event
{
    /** The type of a ConfigValueSetEvent. */
    public static const TYPE :String = "ConfigValSet";

    /** The name of the config value set. */
    public var name :String;

    /** The new value. */
    public var value :Object;

    /**
     */
    public function ConfigValueSetEvent (name :String, value :Object)
    {
        super(TYPE);

        this.name = name;
        this.value = value;
    }

    override public function clone () :Event
    {
        return new ConfigValueSetEvent(name, value);
    }
}
}
