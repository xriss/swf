/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) Kriss Daniels 2006 http://www.XIXs.com
//
/*+-----------------------------------------------------------------------------------------------------------------+*/



//#VERSION_BUILD='debug'
#VERSION_BUILD=''




#VERSION_SITE='generic'
//#VERSION_SITE='bunchball'
//#VERSION_SITE='pepere'
//#VERSION_SITE='pnflashgames'



// some version information

#VERSION_NAME='Clownoids'
#VERSION_NUMBER='0.95a'
#VERSION_TIME			=	os.time()
#VERSION_STAMP			=	os.date("%b %d %Y",VERSION_TIME) -- '1st April 2008'
#VERSION_STAMPNUMBER	=	os.date("%Y%m%d",VERSION_TIME) -- '20080401'


#if VERSION_BUILD=='debug' then

#TRON='xray'

#end