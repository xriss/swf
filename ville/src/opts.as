#(

VERSION_BUILD='cc'

VERSION_SITE=''


-- some version information


VERSION_NAME			=	'ZeeGrind'
VERSION_MOCHIADS		=	'd276d427f34a1058'

VERSION_NAME			=	'WetPokr'
VERSION_MOCHIADS		=	'5d58a5ffba6b2a82'



VERSION_NAME			=	'WetVille'
VERSION_MOCHIADS		=	'18bab4920aa4a276'



VERSION_AUTH			=	'Shi+Kriss Daniels'
VERSION_NUMBER			=	'0.922'
VERSION_TIME			=	os.time()
VERSION_STAMP			=	os.date("%b %d %Y",VERSION_TIME) -- '1st April 2008'
VERSION_STAMPNUMBER		=	os.date("%Y%m%d",VERSION_TIME) -- '20080401'

VERSION_MOCHIBOT		=	'2170f459'
--VERSION_WONDERFUL		=	'5306'


SFX={
	'argh',
	'arghhigh',
	'arse',
	'balloonshigh',
	'balloonslow',
	'brains',
	'urh',
	'wilhelm',
	'bounce',
	'wikwikwik',
}

-- override above with option file
local opts_set=loadfile("src/opts.lua")
setfenv(opts_set,getfenv())
opts_set()
	
	
VERSION_NUMBER=tostring(VERSION_NUMBER)


#)