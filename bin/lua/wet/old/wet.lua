--+-----------------------------------------------------------------------------------------------------------------+--
--
-- (C) Kriss Daniels 2005 http://www.XIXs.com
--
--+-----------------------------------------------------------------------------------------------------------------+--

local info



------------------------------------------------------------------------
--
-- wet info
--
------------------------------------------------------------------------
info=wet

info.version_str		=	wet.str_version()
info.local_dir			=	wet.dir_local()
info.data_dir			=	wet.dir_data()
info.lua_dir			=	wet.dir_lua()




------------------------------------------------------------------------
--
-- amaze info
--
------------------------------------------------------------------------
wet.amaze={}
info=wet.amaze


info.name_str			=	'amaze'

info.version_str		=	wet.version_str
info.local_dir			=	wet.local_dir..info.name_str.."/"
info.data_dir			=	wet.data_dir ..info.name_str.."/"
info.lua_dir			=	wet.lua_dir .."wet/old/" ..info.name_str.."/"




------------------------------------------------------------------------
--
-- structor info
--
------------------------------------------------------------------------
wet.structor={}
info=wet.structor


info.name_str			=	'structor'

info.version_str		=	wet.version_str
info.local_dir			=	wet.local_dir..info.name_str.."/"
info.data_dir			=	wet.data_dir ..info.name_str.."/"
info.lua_dir			=	wet.lua_dir ..info.name_str.."/"

