



#BRANDEAD={"unrealplanetad.png","http://www.theunrealplanet.com/"}



#BRANDEAD={"",""}



#if brandead_xml then

#if BRANDEAD[1]~="" then

<clip id="splash_brandead"		import="../brandead/#(BRANDEAD[1])" />

#end

#else

	var brandead_link="#(BRANDEAD[2])";
	var brandead_image="splash_brandead";
	
#end
