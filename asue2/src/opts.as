#(

VERSION_BUILD='cc'

VERSION_SITE=''

-- some version information

VERSION_AUTH			=	'Shi+Kriss Daniels'

VERSION_NAME			=	'ASUE2'
VERSION_NUMBER			=	'1.01'
VERSION_TIME			=	os.time()
VERSION_STAMP			=	os.date("%b %d %Y",VERSION_TIME) -- '1st April 2008'
VERSION_STAMPNUMBER	=	os.date("%Y%m%d",VERSION_TIME) -- '20080401'
VERSION_MOCHIBOT		=	'059dee01'
VERSION_MOCHIADS		=	'c64b0c12a78388e9'
VERSION_MOCHISCORES		=	'1b5d6aca903aee4c'


file_names=
{
"asue2",
"intro",
}

function XLT(s)

	if xlate and xlate.str then xlate.str(s) end
	
	return 'XLT.str("'..s..'")'
	
end



#)
