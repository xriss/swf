--+-----------------------------------------------------------------------------------------------------------------+--
--
-- (C) Kriss Daniels 2007 http://www.XIXs.com
--
--+-----------------------------------------------------------------------------------------------------------------+--



FeatData={

	[((1*256)+(0*16)+1)]=
	{
		img1	=	"dike1st",
		txt1	=	"__USERNAME__ is currently 1st in the WetDike online rankings.",
	},
	[((1*256)+(0*16)+2)]=
	{
		img1	=	"dike2nd",
		txt1	=	"__USERNAME__ is currently 2nd in the WetDike online rankings.",
	},
	[((1*256)+(0*16)+3)]=
	{
		img1	=	"dike3rd",
		txt1	=	"__USERNAME__ is currently 3rd in the WetDike online rankings.",
	},
	[((1*256)+(0*16)+4)]=
	{
		img1	=	"dike4th",
		txt1	=	"__USERNAME__ is currently 4th in the WetDike online rankings.",
	},
	[((1*256)+(0*16)+5)]=
	{
		img1	=	"dike5th",
		txt1	=	"__USERNAME__ is currently 5th in the WetDike online rankings.",
	},
}




FeatData_idxs={}

	for i,v in pairs(FeatData) do
		table.insert(FeatData_idxs,i)
	end
	
	table.sort(FeatData_idxs)

		
		