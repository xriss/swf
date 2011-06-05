--+-----------------------------------------------------------------------------------------------------------------+--
--
-- (C) Kriss Daniels 2005 http://www.XIXs.com
--
--+-----------------------------------------------------------------------------------------------------------------+--

wavyedit.tabs={}
wavyedit.gizmos={}


-- color button minimum sizes
local CBH=16
local CBW=16

-- minimum body button sizes
local PBH=32
local PBW=32

--
-- Interface layout data
--

wavyedit.tabs.main =
{
	limit_wide=1,
	{
		max_height=32,
		limit_high=1,
		{	group="top",	target="BTN_LayoutRandom",	toggle="BTN_SelectRandom",		{	text=XLT("Randomizer"),			},	},
		{	group="top",	target="BTN_LayoutParts",	toggle="BTN_SelectParts",		{	text=XLT("Parts"),		},	selected=1,	},
		{	group="top",	target="BTN_LayoutPose",	toggle="BTN_SelectPose",		{	text=XLT("Pose"),			},	},
		{	group="top",	target="BTN_LayoutColors",	toggle="BTN_SelectColors",		{	text=XLT("Colors"),		},	},
		{	group="top",	target="BTN_LayoutFile",	toggle="BTN_SelectFile",		{	text=XLT("Load/Save"),			},	},
	},
	{
		hide=1,
		label="BTN_LayoutRandom",
		limit_wide=1,
		{
			limit_wide=1,
			{
				max_height=32,
				limit_high=1,
				{	group="sex",	toggle="BTN_SelectSexBoy",		{	text=XLT("Boy"),		},	},
				{	group="sex",	toggle="BTN_SelectSexGirl",		{	text=XLT("Girl"),	},	selected=1, },
				{	group="sex",	toggle="BTN_SelectSexAll",		{	text=XLT("Any"),		},  },
			},
			{	button="BTN_Randomize",		{	text=XLT("Randomize"),		},  },
			{
				label="BTN_Avatar",
				min_width=200,
				min_height=200,
			},
			{
				xalign=0,
				{
					handle_x="BTN_RotY",
					{
						{	text=XLT("Rotate"), },
					},
				}
			},
--			{	button="BTN_RandomSave",		{	text=XLT("Save many many many random avatars."),		},  },
		},
	},
	{
		hide=0,
		label="BTN_LayoutParts",
		limit_wide=1,
		{
			limit_wide=1,
			{
				max_height=32,
				limit_high=1,
				{	group="part",	target="BTN_LayoutPartHead",		toggle="BTN_SelectPartHead",		{	text=XLT("Head"),		},	},
				{	group="part",	target="BTN_LayoutPartHair",		toggle="BTN_SelectPartHair",		{	text=XLT("Hair"),		},	},
				{	group="part",	target="BTN_LayoutPartBody",		toggle="BTN_SelectPartBody",		{	text=XLT("Body"),		},	selected=1, },
				{	group="part",	target="BTN_LayoutPartHands",		toggle="BTN_SelectPartHands",		{	text=XLT("Hands"),		},	},
				{	group="part",	target="BTN_LayoutPartFeet",		toggle="BTN_SelectPartFeet",		{	text=XLT("Feet"),		},	},
				{	group="part",	target="BTN_LayoutPartTail",		toggle="BTN_SelectPartTail",		{	text=XLT("Tail"),		},	},
			},
			{
				max_height=32,
				limit_high=1,
				{	group="part",	target="BTN_LayoutPartEyes",		toggle="BTN_SelectPartEyes",		{	text=XLT("Eyes"),		},	},
				{	group="part",	target="BTN_LayoutPartEyeBalls",	toggle="BTN_SelectPartEyeBalls",	{	text=XLT("EyeBalls"),	},	},
				{	group="part",	target="BTN_LayoutPartSpecs",		toggle="BTN_SelectPartSpecs",		{	text=XLT("Specs"),		},	},
				{	group="part",	target="BTN_LayoutPartMouth",		toggle="BTN_SelectPartMouth",		{	text=XLT("Mouth"),		},	},
				{	group="part",	target="BTN_LayoutPartBeard",		toggle="BTN_SelectPartBeard",		{	text=XLT("Beard"),		},	},
				{	group="part",	target="BTN_LayoutPartNose",		toggle="BTN_SelectPartNose",		{	text=XLT("Nose"),		},	},
				{	group="part",	target="BTN_LayoutPartEars",		toggle="BTN_SelectPartEars",		{	text=XLT("Ears"),		},	},
			},
		},
		{
			limit_high=1,
			{
				{
					hide=1,
					label="BTN_LayoutPartHead",
					limit_wide=1,
					{
						limit_wide=4,
						{	button="BTN_HeadSelect",	part_group="head", style="nofill", part_name="default",		{	min_width=PBW,	min_height=PBH,	},	},
						{	button="BTN_HeadSelect",	part_group="head", style="nofill", part_name="chinless",	{	min_width=PBW,	min_height=PBH,	},	},
						{	button="BTN_HeadSelect",	part_group="head", style="nofill", part_name="none",		{	min_width=PBW,	min_height=PBH,	},	},
						{	button="BTN_HeadSelect",	part_group="head", style="nofill", part_name="none",		{	min_width=PBW,	min_height=PBH,	},	},
						
						{	button="BTN_HeadSelect",	part_group="head", style="nofill", part_name="skull",		{	min_width=PBW,	min_height=PBH,	},	},
						{	button="BTN_HeadSelect",	part_group="head", style="nofill", part_name="robox",		{	min_width=PBW,	min_height=PBH,	},	},
						{	button="BTN_HeadSelect",	part_group="head", style="nofill", part_name="none",		{	min_width=PBW,	min_height=PBH,	},	},
						{	button="BTN_HeadSelect",	part_group="head", style="nofill", part_name="none",		{	min_width=PBW,	min_height=PBH,	},	},
						
						{	button="BTN_HeadSelect",	part_group="head", style="nofill", part_name="none",		{	min_width=PBW,	min_height=PBH,	},	},
						{	button="BTN_HeadSelect",	part_group="head", style="nofill", part_name="none",		{	min_width=PBW,	min_height=PBH,	},	},
						{	button="BTN_HeadSelect",	part_group="head", style="nofill", part_name="none",		{	min_width=PBW,	min_height=PBH,	},	},
						{	button="BTN_HeadSelect",	part_group="head", style="nofill", part_name="none",		{	min_width=PBW,	min_height=PBH,	},	},
						
						{	button="BTN_HeadSelect",	part_group="head", style="nofill", part_name="default",		{	min_width=PBW,	min_height=PBH,	},	},
						{	button="BTN_HeadSelect",	part_group="head", style="nofill", part_name="cheekbones",	{	min_width=PBW,	min_height=PBH,	},	},
						{	button="BTN_HeadSelect",	part_group="head", style="nofill", part_name="chub",		{	min_width=PBW,	min_height=PBH,	},	},
						{	button="BTN_HeadSelect",	part_group="head", style="nofill", part_name="thin",		{	min_width=PBW,	min_height=PBH,	},	},
					},
						{
							max_height=CBH*2,
							xalign=0,
							{
								handle_x="BTN_MorphHead",
								{
									{	text=XLT("Weight"),	},
								},
							}
						},
					{
						xalign=0,
						{
							handle_x="BTN_HeadAspect",
							{
								{	text=XLT("Aspect"), },
							},
						}
					},
				},
				{
					hide=1,
					label="BTN_LayoutPartHair",
					{
						limit_wide=1,
						{
							max_height=32,
							limit_high=1,
							{	group="hair",	target="BTN_LayoutPartHairA",	toggle="BTN_SelectPartHairA",	{	text="A",	},	},
							{	group="hair",	target="BTN_LayoutPartHairB",	toggle="BTN_SelectPartHairB",	{	text="B",	},	selected=1, },
							{	group="hair",	target="BTN_LayoutPartHairC",	toggle="BTN_SelectPartHairC",	{	text="C",	},	},
						},
						{
							hide=1,
							limit_wide=1,
							label="BTN_LayoutPartHairA",
							{
								max_height=32,
								limit_high=1,
								{	group="hairA",	target="BTN_LayoutPartHairA1",	toggle="BTN_SelectPartHairA1",	{	text="1",	},	selected=1,	},
								{	group="hairA",	target="BTN_LayoutPartHairA2",	toggle="BTN_SelectPartHairA2",	{	text="2",	},	selected=0,	},
								{	group="hairA",	target="BTN_LayoutPartHairA3",	toggle="BTN_SelectPartHairA3",	{	text="3",	},	selected=0,	},
							},
							{
								hide=0,
								label="BTN_LayoutPartHairA1",
								limit_wide=4,
								{	button="BTN_HairASelect",	part_group="hat", style="nofill", part_name="baseball",				{	min_width=PBW,	min_height=PBH,		},	},
								{	button="BTN_HairASelect",	part_group="hat", style="nofill", part_name="pirate",				{	min_width=PBW,	min_height=PBH,		},	},
								{	button="BTN_HairASelect",	part_group="hat", style="nofill", part_name="kerchief",				{	min_width=PBW,	min_height=PBH,		},	},
								{	button="BTN_HairASelect",	part_group="hat", style="nofill", part_name="bunny_ears",			{	min_width=PBW,	min_height=PBH,		},	},
								
								{	button="BTN_HairASelect",	part_group="hair", style="nofill", part_name="none",				{	min_width=PBW,	min_height=PBH,			},	},
								{	button="BTN_HairASelect",	part_group="hair", style="nofill", part_name="none",				{	min_width=PBW,	min_height=PBH,			},	},
								{	button="BTN_HairASelect",	part_group="hair", style="nofill", part_name="none",				{	min_width=PBW,	min_height=PBH,			},	},
								{	button="BTN_HairASelect",	part_group="hair", style="nofill", part_name="none",				{	min_width=PBW,	min_height=PBH,			},	},

								{	button="BTN_HairASelect",	part_group="hair", style="nofill", part_name="none",				{	min_width=PBW,	min_height=PBH,			},	},
								{	button="BTN_HairASelect",	part_group="hair", style="nofill", part_name="none",				{	min_width=PBW,	min_height=PBH,			},	},
								{	button="BTN_HairASelect",	part_group="hair", style="nofill", part_name="none",				{	min_width=PBW,	min_height=PBH,			},	},
								{	button="BTN_HairASelect",	part_group="hair", style="nofill", part_name="none",				{	min_width=PBW,	min_height=PBH,			},	},
								
								{	button="BTN_HairASelect",	part_group="hair", style="nofill", part_name="none",				{	min_width=PBW,	min_height=PBH,			},	},
								{	button="BTN_HairASelect",	part_group="hair", style="nofill", part_name="none",				{	min_width=PBW,	min_height=PBH,			},	},
								{	button="BTN_HairASelect",	part_group="hair", style="nofill", part_name="none",				{	min_width=PBW,	min_height=PBH,			},	},
								{	button="BTN_HairASelect",	part_group="hair", style="nofill", part_name="none",				{	min_width=PBW,	min_height=PBH,			},	},
							},
							{
								hide=1,
								label="BTN_LayoutPartHairA2",
								limit_wide=4,
								{	button="BTN_HairASelect",	part_group="hair_xtra", style="nofill", part_name="long",			{	min_width=PBW,	min_height=PBH,			},	},
								{	button="BTN_HairASelect",	part_group="hair_xtra", style="nofill", part_name="ponytail",		{	min_width=PBW,	min_height=PBH,			},	},
								{	button="BTN_HairASelect",	part_group="hair_xtra", style="nofill", part_name="pigtails",		{	min_width=PBW,	min_height=PBH,			},	},
								{	button="BTN_HairASelect",	part_group="hair_xtra", style="nofill", part_name="bunches",		{	min_width=PBW,	min_height=PBH,			},	},

								{	button="BTN_HairASelect",	part_group="hair_xtra", style="nofill", part_name="bang",			{	min_width=PBW,	min_height=PBH,			},	},
								{	button="BTN_HairASelect",	part_group="hair_xtra", style="nofill", part_name="bang_zigs",		{	min_width=PBW,	min_height=PBH,			},	},
								{	button="BTN_HairASelect",	part_group="hair_xtra", style="nofill", part_name="bang_goff",		{	min_width=PBW,	min_height=PBH,			},	},
								{	button="BTN_HairASelect",	part_group="hair_xtra", style="nofill", part_name="bang_nerd",		{	min_width=PBW,	min_height=PBH,			},	},
								
								{	button="BTN_HairASelect",	part_group="hair_xtra", style="nofill", part_name="bang_sidel",		{	min_width=PBW,	min_height=PBH,			},	},
								{	button="BTN_HairASelect",	part_group="hair_xtra", style="nofill", part_name="bang_sider",		{	min_width=PBW,	min_height=PBH,			},	},
								{	button="BTN_HairASelect",	part_group="hair_xtra", style="nofill", part_name="bang_emol",		{	min_width=PBW,	min_height=PBH,			},	},
								{	button="BTN_HairASelect",	part_group="hair_xtra", style="nofill", part_name="bang_emor",		{	min_width=PBW,	min_height=PBH,			},	},
								
								{	button="BTN_HairASelect",	part_group="hair_xtra", style="nofill", part_name="bang_hugh",		{	min_width=PBW,	min_height=PBH,			},	},
								{	button="BTN_HairASelect",	part_group="hair", style="nofill", part_name="none",				{	min_width=PBW,	min_height=PBH,			},	},
								{	button="BTN_HairASelect",	part_group="hair", style="nofill", part_name="none",				{	min_width=PBW,	min_height=PBH,			},	},
								{	button="BTN_HairASelect",	part_group="hair", style="nofill", part_name="none",				{	min_width=PBW,	min_height=PBH,			},	},
							},
							{
								hide=1,
								label="BTN_LayoutPartHairA3",
								limit_wide=4,
								{	button="BTN_HairASelect",	part_group="hair_base", style="nofill", part_name="default",		{	min_width=PBW,	min_height=PBH,			},	},
								{	button="BTN_HairASelect",	part_group="hair_base", style="nofill", part_name="bowl",			{	min_width=PBW,	min_height=PBH,			},	},
								{	button="BTN_HairASelect",	part_group="hair", style="nofill", part_name="topspiked_short",		{	min_width=PBW,	min_height=PBH,			},	},
								{	button="BTN_HairASelect",	part_group="hair", style="nofill", part_name="peak",				{	min_width=PBW,	min_height=PBH,			},	},

								{	button="BTN_HairASelect",	part_group="hair", style="nofill", part_name="bob",					{	min_width=PBW,	min_height=PBH,				},	},
								{	button="BTN_HairASelect",	part_group="hair", style="nofill", part_name="goth_long",			{	min_width=PBW,	min_height=PBH,			},	},
								{	button="BTN_HairASelect",	part_group="hair", style="nofill", part_name="spikey_short",		{	min_width=PBW,	min_height=PBH,		},	},
								{	button="BTN_HairASelect",	part_group="hair", style="nofill", part_name="trihawk_short",		{	min_width=PBW,	min_height=PBH,		},	},

								{	button="BTN_HairASelect",	part_group="hair", style="nofill", part_name="trihawk_hi",			{	min_width=PBW,	min_height=PBH,		},	},
								{	button="BTN_HairASelect",	part_group="hair", style="nofill", part_name="hedgehog",			{	min_width=PBW,	min_height=PBH,		},	},
								{	button="BTN_HairASelect",	part_group="hair", style="nofill", part_name="afro",				{	min_width=PBW,	min_height=PBH,		},	},
								{	button="BTN_HairASelect",	part_group="hair", style="nofill", part_name="quiff",				{	min_width=PBW,	min_height=PBH,		},	},

								{	button="BTN_HairASelect",	part_group="hair", style="nofill", part_name="curl_left",			{	min_width=PBW,	min_height=PBH,		},	},
								{	button="BTN_HairASelect",	part_group="hair", style="nofill", part_name="curl_right",			{	min_width=PBW,	min_height=PBH,		},	},
								{	button="BTN_HairASelect",	part_group="hair", style="nofill", part_name="afro_tall",			{	min_width=PBW,	min_height=PBH,			},	},
								{	button="BTN_HairASelect",	part_group="hair", style="nofill", part_name="none",				{	min_width=PBW,	min_height=PBH,			},	},
							},
						},
						{
							hide=0,
							limit_wide=1,
							label="BTN_LayoutPartHairB",
							{
								max_height=32,
								limit_high=1,
								{	group="hairB",	target="BTN_LayoutPartHairB1",	toggle="BTN_SelectPartHairB1",	{	text="1",	},	selected=0,	},
								{	group="hairB",	target="BTN_LayoutPartHairB2",	toggle="BTN_SelectPartHairB2",	{	text="2",	},	selected=1,	},
								{	group="hairB",	target="BTN_LayoutPartHairB3",	toggle="BTN_SelectPartHairB3",	{	text="3",	},	selected=0,	},
							},
							{
								hide=1,
								label="BTN_LayoutPartHairB1",
								limit_wide=4,
								{	button="BTN_HairBSelect",	part_group="hat", style="nofill", part_name="baseball",				{	min_width=PBW,	min_height=PBH,		},	},
								{	button="BTN_HairBSelect",	part_group="hat", style="nofill", part_name="pirate",				{	min_width=PBW,	min_height=PBH,		},	},
								{	button="BTN_HairBSelect",	part_group="hat", style="nofill", part_name="kerchief",				{	min_width=PBW,	min_height=PBH,		},	},
								{	button="BTN_HairBSelect",	part_group="hat", style="nofill", part_name="bunny_ears",			{	min_width=PBW,	min_height=PBH,		},	},
								
								{	button="BTN_HairBSelect",	part_group="hair", style="nofill", part_name="none",				{	min_width=PBW,	min_height=PBH,			},	},
								{	button="BTN_HairBSelect",	part_group="hair", style="nofill", part_name="none",				{	min_width=PBW,	min_height=PBH,			},	},
								{	button="BTN_HairBSelect",	part_group="hair", style="nofill", part_name="none",				{	min_width=PBW,	min_height=PBH,			},	},
								{	button="BTN_HairBSelect",	part_group="hair", style="nofill", part_name="none",				{	min_width=PBW,	min_height=PBH,			},	},

								{	button="BTN_HairBSelect",	part_group="hair", style="nofill", part_name="none",				{	min_width=PBW,	min_height=PBH,			},	},
								{	button="BTN_HairBSelect",	part_group="hair", style="nofill", part_name="none",				{	min_width=PBW,	min_height=PBH,			},	},
								{	button="BTN_HairBSelect",	part_group="hair", style="nofill", part_name="none",				{	min_width=PBW,	min_height=PBH,			},	},
								{	button="BTN_HairBSelect",	part_group="hair", style="nofill", part_name="none",				{	min_width=PBW,	min_height=PBH,			},	},
								
								{	button="BTN_HairBSelect",	part_group="hair", style="nofill", part_name="none",				{	min_width=PBW,	min_height=PBH,			},	},
								{	button="BTN_HairBSelect",	part_group="hair", style="nofill", part_name="none",				{	min_width=PBW,	min_height=PBH,			},	},
								{	button="BTN_HairASelect",	part_group="hair", style="nofill", part_name="none",				{	min_width=PBW,	min_height=PBH,			},	},
								{	button="BTN_HairBSelect",	part_group="hair", style="nofill", part_name="none",				{	min_width=PBW,	min_height=PBH,			},	},
							},
							{
								hide=0,
								label="BTN_LayoutPartHairB2",
								limit_wide=4,
								{	button="BTN_HairBSelect",	part_group="hair_xtra", style="nofill", part_name="long",			{	min_width=PBW,	min_height=PBH,			},	},
								{	button="BTN_HairBSelect",	part_group="hair_xtra", style="nofill", part_name="ponytail",		{	min_width=PBW,	min_height=PBH,			},	},
								{	button="BTN_HairBSelect",	part_group="hair_xtra", style="nofill", part_name="pigtails",		{	min_width=PBW,	min_height=PBH,			},	},
								{	button="BTN_HairBSelect",	part_group="hair_xtra", style="nofill", part_name="bunches",		{	min_width=PBW,	min_height=PBH,			},	},

								{	button="BTN_HairBSelect",	part_group="hair_xtra", style="nofill", part_name="bang",			{	min_width=PBW,	min_height=PBH,			},	},
								{	button="BTN_HairBSelect",	part_group="hair_xtra", style="nofill", part_name="bang_zigs",		{	min_width=PBW,	min_height=PBH,			},	},
								{	button="BTN_HairBSelect",	part_group="hair_xtra", style="nofill", part_name="bang_goff",		{	min_width=PBW,	min_height=PBH,			},	},
								{	button="BTN_HairBSelect",	part_group="hair_xtra", style="nofill", part_name="bang_nerd",		{	min_width=PBW,	min_height=PBH,			},	},
								
								{	button="BTN_HairBSelect",	part_group="hair_xtra", style="nofill", part_name="bang_sidel",		{	min_width=PBW,	min_height=PBH,			},	},
								{	button="BTN_HairBSelect",	part_group="hair_xtra", style="nofill", part_name="bang_sider",		{	min_width=PBW,	min_height=PBH,			},	},
								{	button="BTN_HairBSelect",	part_group="hair_xtra", style="nofill", part_name="bang_emol",		{	min_width=PBW,	min_height=PBH,			},	},
								{	button="BTN_HairBSelect",	part_group="hair_xtra", style="nofill", part_name="bang_emor",		{	min_width=PBW,	min_height=PBH,			},	},
								
								{	button="BTN_HairBSelect",	part_group="hair_xtra", style="nofill", part_name="bang_hugh",		{	min_width=PBW,	min_height=PBH,			},	},
								{	button="BTN_HairBSelect",	part_group="hair", style="nofill", part_name="none",				{	min_width=PBW,	min_height=PBH,			},	},
								{	button="BTN_HairBSelect",	part_group="hair", style="nofill", part_name="none",				{	min_width=PBW,	min_height=PBH,			},	},
								{	button="BTN_HairBSelect",	part_group="hair", style="nofill", part_name="none",				{	min_width=PBW,	min_height=PBH,			},	},
							},
							{
								hide=1,
								label="BTN_LayoutPartHairB3",
								limit_wide=4,
								{	button="BTN_HairBSelect",	part_group="hair_base", style="nofill", part_name="default",		{	min_width=PBW,	min_height=PBH,			},	},
								{	button="BTN_HairBSelect",	part_group="hair_base", style="nofill", part_name="bowl",			{	min_width=PBW,	min_height=PBH,			},	},
								{	button="BTN_HairBSelect",	part_group="hair", style="nofill", part_name="topspiked_short",		{	min_width=PBW,	min_height=PBH,			},	},
								{	button="BTN_HairBSelect",	part_group="hair", style="nofill", part_name="peak",				{	min_width=PBW,	min_height=PBH,			},	},

								{	button="BTN_HairBSelect",	part_group="hair", style="nofill", part_name="bob",					{	min_width=PBW,	min_height=PBH,				},	},
								{	button="BTN_HairBSelect",	part_group="hair", style="nofill", part_name="goth_long",			{	min_width=PBW,	min_height=PBH,			},	},
								{	button="BTN_HairBSelect",	part_group="hair", style="nofill", part_name="spikey_short",		{	min_width=PBW,	min_height=PBH,		},	},
								{	button="BTN_HairBSelect",	part_group="hair", style="nofill", part_name="trihawk_short",		{	min_width=PBW,	min_height=PBH,		},	},

								{	button="BTN_HairBSelect",	part_group="hair", style="nofill", part_name="trihawk_hi",			{	min_width=PBW,	min_height=PBH,		},	},
								{	button="BTN_HairBSelect",	part_group="hair", style="nofill", part_name="hedgehog",			{	min_width=PBW,	min_height=PBH,		},	},
								{	button="BTN_HairBSelect",	part_group="hair", style="nofill", part_name="afro",				{	min_width=PBW,	min_height=PBH,		},	},
								{	button="BTN_HairBSelect",	part_group="hair", style="nofill", part_name="quiff",				{	min_width=PBW,	min_height=PBH,		},	},

								{	button="BTN_HairBSelect",	part_group="hair", style="nofill", part_name="curl_left",			{	min_width=PBW,	min_height=PBH,		},	},
								{	button="BTN_HairBSelect",	part_group="hair", style="nofill", part_name="curl_right",			{	min_width=PBW,	min_height=PBH,		},	},
								{	button="BTN_HairBSelect",	part_group="hair", style="nofill", part_name="afro_tall",			{	min_width=PBW,	min_height=PBH,			},	},
								{	button="BTN_HairBSelect",	part_group="hair", style="nofill", part_name="none",				{	min_width=PBW,	min_height=PBH,			},	},
							},
						},
						{
							hide=1,
							limit_wide=1,
							label="BTN_LayoutPartHairC",
							{
								max_height=32,
								limit_high=1,
								{	group="hairC",	target="BTN_LayoutPartHairC1",	toggle="BTN_SelectPartHairC1",	{	text="1",	},	selected=0,	},
								{	group="hairC",	target="BTN_LayoutPartHairC2",	toggle="BTN_SelectPartHairC2",	{	text="2",	},	selected=0,	},
								{	group="hairC",	target="BTN_LayoutPartHairC3",	toggle="BTN_SelectPartHairC3",	{	text="3",	},	selected=1,	},
							},
							{
								hide=1,
								label="BTN_LayoutPartHairC1",
								limit_wide=4,
								{	button="BTN_HairCSelect",	part_group="hat", style="nofill", part_name="baseball",				{	min_width=PBW,	min_height=PBH,		},	},
								{	button="BTN_HairCSelect",	part_group="hat", style="nofill", part_name="pirate",				{	min_width=PBW,	min_height=PBH,		},	},
								{	button="BTN_HairCSelect",	part_group="hat", style="nofill", part_name="kerchief",				{	min_width=PBW,	min_height=PBH,		},	},
								{	button="BTN_HairCSelect",	part_group="hat", style="nofill", part_name="bunny_ears",			{	min_width=PBW,	min_height=PBH,		},	},
								
								{	button="BTN_HairCSelect",	part_group="hair", style="nofill", part_name="none",				{	min_width=PBW,	min_height=PBH,			},	},
								{	button="BTN_HairCSelect",	part_group="hair", style="nofill", part_name="none",				{	min_width=PBW,	min_height=PBH,			},	},
								{	button="BTN_HairCSelect",	part_group="hair", style="nofill", part_name="none",				{	min_width=PBW,	min_height=PBH,			},	},
								{	button="BTN_HairCSelect",	part_group="hair", style="nofill", part_name="none",				{	min_width=PBW,	min_height=PBH,			},	},

								{	button="BTN_HairCSelect",	part_group="hair", style="nofill", part_name="none",				{	min_width=PBW,	min_height=PBH,			},	},
								{	button="BTN_HairCSelect",	part_group="hair", style="nofill", part_name="none",				{	min_width=PBW,	min_height=PBH,			},	},
								{	button="BTN_HairCSelect",	part_group="hair", style="nofill", part_name="none",				{	min_width=PBW,	min_height=PBH,			},	},
								{	button="BTN_HairCSelect",	part_group="hair", style="nofill", part_name="none",				{	min_width=PBW,	min_height=PBH,			},	},
								
								{	button="BTN_HairCSelect",	part_group="hair", style="nofill", part_name="none",				{	min_width=PBW,	min_height=PBH,			},	},
								{	button="BTN_HairCSelect",	part_group="hair", style="nofill", part_name="none",				{	min_width=PBW,	min_height=PBH,			},	},
								{	button="BTN_HairCSelect",	part_group="hair", style="nofill", part_name="none",				{	min_width=PBW,	min_height=PBH,			},	},
								{	button="BTN_HairCSelect",	part_group="hair", style="nofill", part_name="none",				{	min_width=PBW,	min_height=PBH,			},	},
							},
							{
								hide=1,
								label="BTN_LayoutPartHairC2",
								limit_wide=4,
								{	button="BTN_HairCSelect",	part_group="hair_xtra", style="nofill", part_name="long",			{	min_width=PBW,	min_height=PBH,			},	},
								{	button="BTN_HairCSelect",	part_group="hair_xtra", style="nofill", part_name="ponytail",		{	min_width=PBW,	min_height=PBH,			},	},
								{	button="BTN_HairCSelect",	part_group="hair_xtra", style="nofill", part_name="pigtails",		{	min_width=PBW,	min_height=PBH,			},	},
								{	button="BTN_HairCSelect",	part_group="hair_xtra", style="nofill", part_name="bunches",		{	min_width=PBW,	min_height=PBH,			},	},

								{	button="BTN_HairCSelect",	part_group="hair_xtra", style="nofill", part_name="bang",			{	min_width=PBW,	min_height=PBH,			},	},
								{	button="BTN_HairCSelect",	part_group="hair_xtra", style="nofill", part_name="bang_zigs",		{	min_width=PBW,	min_height=PBH,			},	},
								{	button="BTN_HairCSelect",	part_group="hair_xtra", style="nofill", part_name="bang_goff",		{	min_width=PBW,	min_height=PBH,			},	},
								{	button="BTN_HairCSelect",	part_group="hair_xtra", style="nofill", part_name="bang_nerd",		{	min_width=PBW,	min_height=PBH,			},	},
								
								{	button="BTN_HairCSelect",	part_group="hair_xtra", style="nofill", part_name="bang_sidel",		{	min_width=PBW,	min_height=PBH,			},	},
								{	button="BTN_HairCSelect",	part_group="hair_xtra", style="nofill", part_name="bang_sider",		{	min_width=PBW,	min_height=PBH,			},	},
								{	button="BTN_HairCSelect",	part_group="hair_xtra", style="nofill", part_name="bang_emol",		{	min_width=PBW,	min_height=PBH,			},	},
								{	button="BTN_HairCSelect",	part_group="hair_xtra", style="nofill", part_name="bang_emor",		{	min_width=PBW,	min_height=PBH,			},	},
								
								{	button="BTN_HairCSelect",	part_group="hair_xtra", style="nofill", part_name="bang_hugh",		{	min_width=PBW,	min_height=PBH,			},	},
								{	button="BTN_HairCSelect",	part_group="hair", style="nofill", part_name="none",				{	min_width=PBW,	min_height=PBH,			},	},
								{	button="BTN_HairCSelect",	part_group="hair", style="nofill", part_name="none",				{	min_width=PBW,	min_height=PBH,			},	},
								{	button="BTN_HairCSelect",	part_group="hair", style="nofill", part_name="none",				{	min_width=PBW,	min_height=PBH,			},	},
							},
							{
								hide=0,
								label="BTN_LayoutPartHairC3",
								limit_wide=4,
								{	button="BTN_HairCSelect",	part_group="hair_base", style="nofill", part_name="default",		{	min_width=PBW,	min_height=PBH,			},	},
								{	button="BTN_HairCSelect",	part_group="hair_base", style="nofill", part_name="bowl",			{	min_width=PBW,	min_height=PBH,			},	},
								{	button="BTN_HairCSelect",	part_group="hair", style="nofill", part_name="topspiked_short",		{	min_width=PBW,	min_height=PBH,			},	},
								{	button="BTN_HairCSelect",	part_group="hair", style="nofill", part_name="peak",				{	min_width=PBW,	min_height=PBH,			},	},

								{	button="BTN_HairCSelect",	part_group="hair", style="nofill", part_name="bob",					{	min_width=PBW,	min_height=PBH,				},	},
								{	button="BTN_HairCSelect",	part_group="hair", style="nofill", part_name="goth_long",			{	min_width=PBW,	min_height=PBH,			},	},
								{	button="BTN_HairCSelect",	part_group="hair", style="nofill", part_name="spikey_short",		{	min_width=PBW,	min_height=PBH,		},	},
								{	button="BTN_HairCSelect",	part_group="hair", style="nofill", part_name="trihawk_short",		{	min_width=PBW,	min_height=PBH,		},	},

								{	button="BTN_HairCSelect",	part_group="hair", style="nofill", part_name="trihawk_hi",			{	min_width=PBW,	min_height=PBH,		},	},
								{	button="BTN_HairCSelect",	part_group="hair", style="nofill", part_name="hedgehog",			{	min_width=PBW,	min_height=PBH,		},	},
								{	button="BTN_HairCSelect",	part_group="hair", style="nofill", part_name="afro",				{	min_width=PBW,	min_height=PBH,		},	},
								{	button="BTN_HairCSelect",	part_group="hair", style="nofill", part_name="quiff",				{	min_width=PBW,	min_height=PBH,		},	},

								{	button="BTN_HairCSelect",	part_group="hair", style="nofill", part_name="curl_left",			{	min_width=PBW,	min_height=PBH,		},	},
								{	button="BTN_HairCSelect",	part_group="hair", style="nofill", part_name="curl_right",			{	min_width=PBW,	min_height=PBH,		},	},
								{	button="BTN_HairCSelect",	part_group="hair", style="nofill", part_name="afro_tall",			{	min_width=PBW,	min_height=PBH,			},	},
								{	button="BTN_HairSelect",	part_group="hair", style="nofill", part_name="none",				{	min_width=PBW,	min_height=PBH,			},	},
							},
						},
					},
				},
				{
					hide=0,
					label="BTN_LayoutPartBody",
					{
						limit_wide=1,
						{
							max_height=32,
							limit_high=1,
							{	group="body",	target="BTN_LayoutPartBodyBoy",		toggle="BTN_SelectPartBodyBoy",		{	text=XLT("Boy"),		},	selected=1,	},
							{	group="body",	target="BTN_LayoutPartBodyGirl",	toggle="BTN_SelectPartBodyGirl",	{	text=XLT("Girl"),		},	},
							{	group="body",	target="BTN_LayoutPartBodyXtra",	toggle="BTN_SelectPartBodyXtra",	{	text=XLT("Extra"),		},	},
							{	group="body",	target="BTN_LayoutPartBodyOld",		toggle="BTN_SelectPartBodyOld",		{	text=XLT("Old"),		},  },
						},
						{
							hide=1,
							label="BTN_LayoutPartBodyOld",
							{
								limit_wide=4,
								{	button="BTN_BodySelect",	part_group="body", style="nofill", part_name="bare_boobs_small",	{	min_width=PBW,	min_height=PBH,		},	},
								{	button="BTN_BodySelect",	part_group="body", style="nofill", part_name="bare_boobs_medium",	{	min_width=PBW,	min_height=PBH,		},	},
								{	button="BTN_BodySelect",	part_group="body", style="nofill", part_name="bare_boobs_large",	{	min_width=PBW,	min_height=PBH,		},	},
								{	button="BTN_BodySelect",	part_group="body", style="nofill", part_name="bare_chest",			{	min_width=PBW,	min_height=PBH,			},	},

								{	button="BTN_BodySelect",	part_group="body", style="nofill", part_name="bare_gut",			{	min_width=PBW,	min_height=PBH,			},	},
								{	button="BTN_BodySelect",	part_group="body", style="nofill", part_name="bodess_medium",		{	min_width=PBW,	min_height=PBH,			},	},
								{	button="BTN_BodySelect",	part_group="body", style="nofill", part_name="bodess_large",		{	min_width=PBW,	min_height=PBH,			},	},
								{	button="BTN_BodySelect",	part_group="body", style="nofill", part_name="tshirt_boobs_small",	{	min_width=PBW,	min_height=PBH,	},	},

								{	button="BTN_BodySelect",	part_group="body", style="nofill", part_name="tshirt_boobs_medium",	{	min_width=PBW,	min_height=PBH,		},	},
								{	button="BTN_BodySelect",	part_group="body", style="nofill", part_name="tshirt_boobs_large",	{	min_width=PBW,	min_height=PBH,	},	},
								{	button="BTN_BodySelect",	part_group="body", style="nofill", part_name="tshirt_chest",		{	min_width=PBW,	min_height=PBH,		},	},
								{	button="BTN_BodySelect",	part_group="body", style="nofill", part_name="tshirt_gut",			{	min_width=PBW,	min_height=PBH,			},	},

								{	button="BTN_BodySelect",	part_group="body", style="nofill", part_name="tshirt_lowcut_large",	{	min_width=PBW,	min_height=PBH,		},	},
								{	button="BTN_BodySelect",	part_group="body", style="nofill", part_name="tshirt_skinny",		{	min_width=PBW,	min_height=PBH,			},	},
								{	button="BTN_BodySelect",	part_group="body", style="nofill", part_name="none",				{	min_width=PBW,	min_height=PBH,				},	},
								{	button="BTN_BodySelect",	part_group="body", style="nofill", part_name="none",				{	min_width=PBW,	min_height=PBH,				},	},
							},
						},
						{
							hide=1,
							label="BTN_LayoutPartBodyXtra",
							{
								limit_wide=4,
								{	button="BTN_BodySelect2",	part_group="body", style="nofill", part_name="tie",	{	min_width=PBW,	min_height=PBH,		},	},
								{	button="BTN_BodySelect2",	part_group="body", style="nofill", part_name="tie_boobs",	{	min_width=PBW,	min_height=PBH,		},	},
								{	button="BTN_BodySelect2",	part_group="body", style="nofill", part_name="none",	{	min_width=PBW,	min_height=PBH,		},	},
								{	button="BTN_BodySelect2",	part_group="body", style="nofill", part_name="none",			{	min_width=PBW,	min_height=PBH,			},	},

								{	button="BTN_BodySelect2",	part_group="body", style="nofill", part_name="none",			{	min_width=PBW,	min_height=PBH,			},	},
								{	button="BTN_BodySelect2",	part_group="body", style="nofill", part_name="none",		{	min_width=PBW,	min_height=PBH,			},	},
								{	button="BTN_BodySelect2",	part_group="body", style="nofill", part_name="none",		{	min_width=PBW,	min_height=PBH,			},	},
								{	button="BTN_BodySelect2",	part_group="body", style="nofill", part_name="none",	{	min_width=PBW,	min_height=PBH,	},	},

								{	button="BTN_BodySelect2",	part_group="body", style="nofill", part_name="none",	{	min_width=PBW,	min_height=PBH,		},	},
								{	button="BTN_BodySelect2",	part_group="body", style="nofill", part_name="none",	{	min_width=PBW,	min_height=PBH,	},	},
								{	button="BTN_BodySelect2",	part_group="body", style="nofill", part_name="none",		{	min_width=PBW,	min_height=PBH,		},	},
								{	button="BTN_BodySelect2",	part_group="body", style="nofill", part_name="none",			{	min_width=PBW,	min_height=PBH,			},	},

								{	button="BTN_BodySelect2",	part_group="body", style="nofill", part_name="none",	{	min_width=PBW,	min_height=PBH,		},	},
								{	button="BTN_BodySelect2",	part_group="body", style="nofill", part_name="none",		{	min_width=PBW,	min_height=PBH,			},	},
								{	button="BTN_BodySelect2",	part_group="body", style="nofill", part_name="none",				{	min_width=PBW,	min_height=PBH,		},	},
								{	button="BTN_BodySelect2",	part_group="body", style="nofill", part_name="none",				{	min_width=PBW,	min_height=PBH,		},	},
							},
						},
						{
							hide=0,
							label="BTN_LayoutPartBodyBoy",
							{
								limit_wide=4,
								{	button="BTN_BodySelect",	part_group="body", style="nofill", part_name="bare",				{	min_width=PBW,	min_height=PBH,		},	},
								{	button="BTN_BodySelect",	part_group="body", style="nofill", part_name="tshirt",				{	min_width=PBW,	min_height=PBH,		},	},
								{	button="BTN_BodySelect",	part_group="body", style="nofill", part_name="vest",				{	min_width=PBW,	min_height=PBH,				},	},
								{	button="BTN_BodySelect",	part_group="body", style="nofill", part_name="overalls",			{	min_width=PBW,	min_height=PBH,				},	},

								{	button="BTN_BodySelect",	part_group="body", style="nofill", part_name="coat",				{	min_width=PBW,	min_height=PBH,			},	},
								{	button="BTN_BodySelect",	part_group="body", style="nofill", part_name="robox",				{	min_width=PBW,	min_height=PBH,			},	},
								{	button="BTN_BodySelect",	part_group="body", style="nofill", part_name="none",				{	min_width=PBW,	min_height=PBH,			},	},
								{	button="BTN_BodySelect",	part_group="body", style="nofill", part_name="none",				{	min_width=PBW,	min_height=PBH,			},	},

								{	button="BTN_BodySelect",	part_group="body", style="nofill", part_name="none",				{	min_width=PBW,	min_height=PBH,			},	},
								{	button="BTN_BodySelect",	part_group="body", style="nofill", part_name="none",				{	min_width=PBW,	min_height=PBH,			},	},
								{	button="BTN_BodySelect",	part_group="body", style="nofill", part_name="none",				{	min_width=PBW,	min_height=PBH,				},	},
								{	button="BTN_BodySelect",	part_group="body", style="nofill", part_name="none",				{	min_width=PBW,	min_height=PBH,				},	},

								{	button="BTN_BodySelect",	part_group="body", style="nofill", part_name="none",				{	min_width=PBW,	min_height=PBH,				},	},
								{	button="BTN_BodySelect",	part_group="body", style="nofill", part_name="none",				{	min_width=PBW,	min_height=PBH,				},	},
								{	button="BTN_BodySelect",	part_group="body", style="nofill", part_name="none",				{	min_width=PBW,	min_height=PBH,				},	},
								{	button="BTN_BodySelect",	part_group="body", style="nofill", part_name="none",				{	min_width=PBW,	min_height=PBH,				},	},
							},
						},
						{
							hide=1,
							label="BTN_LayoutPartBodyGirl",
							{
								limit_wide=4,
								{	button="BTN_BodySelect",	part_group="body", style="nofill", part_name="bare_boobs",			{	min_width=PBW,	min_height=PBH,		},	},
								{	button="BTN_BodySelect",	part_group="body", style="nofill", part_name="bodess",				{	min_width=PBW,	min_height=PBH,		},	},
								{	button="BTN_BodySelect",	part_group="body", style="nofill", part_name="tshirt_boobs_low",	{	min_width=PBW,	min_height=PBH,		},	},
								{	button="BTN_BodySelect",	part_group="body", style="nofill", part_name="tshirt_boobs",		{	min_width=PBW,	min_height=PBH,		},	},

								{	button="BTN_BodySelect",	part_group="body", style="nofill", part_name="vest_boobs",			{	min_width=PBW,	min_height=PBH,			},	},
								{	button="BTN_BodySelect",	part_group="body", style="nofill", part_name="none",				{	min_width=PBW,	min_height=PBH,			},	},
								{	button="BTN_BodySelect",	part_group="body", style="nofill", part_name="none",				{	min_width=PBW,	min_height=PBH,			},	},
								{	button="BTN_BodySelect",	part_group="body", style="nofill", part_name="none",				{	min_width=PBW,	min_height=PBH,			},	},

								{	button="BTN_BodySelect",	part_group="body", style="nofill", part_name="none",				{	min_width=PBW,	min_height=PBH,			},	},
								{	button="BTN_BodySelect",	part_group="body", style="nofill", part_name="none",				{	min_width=PBW,	min_height=PBH,			},	},
								{	button="BTN_BodySelect",	part_group="body", style="nofill", part_name="none",				{	min_width=PBW,	min_height=PBH,			},	},
								{	button="BTN_BodySelect",	part_group="body", style="nofill", part_name="none",				{	min_width=PBW,	min_height=PBH,			},	},

								{	button="BTN_BodySelect",	part_group="body", style="nofill", part_name="none",				{	min_width=PBW,	min_height=PBH,			},	},
								{	button="BTN_BodySelect",	part_group="body", style="nofill", part_name="none",				{	min_width=PBW,	min_height=PBH,			},	},
								{	button="BTN_BodySelect",	part_group="body", style="nofill", part_name="none",				{	min_width=PBW,	min_height=PBH,			},	},
								{	button="BTN_BodySelect",	part_group="body", style="nofill", part_name="none",				{	min_width=PBW,	min_height=PBH,			},	},
							},
						},
						{
							max_height=CBH*2,
							xalign=0,
							{
								handle_x="BTN_MorphChest",
								{
									{	text=XLT("Chest"),	},
								},
							}
						},
						{
							max_height=CBH*2,
							xalign=0,
							{
								handle_x="BTN_MorphThin",
								{
									{	text=XLT("Thin"),	},
								},
							}
						},
					},
				},
				{
					hide=1,
					label="BTN_LayoutPartHands",
					{
						limit_wide=1,
						{
							max_height=32,
							limit_high=1,
							{	group="hands",	target="BTN_LayoutPartHand",		toggle="BTN_SelectPartHand",		{	text=XLT("Hands"),		},	selected=1, },
							{	group="hands",	target="BTN_LayoutPartHandL",		toggle="BTN_SelectPartHandL",		{	text=XLT("Left"),		},	},
							{	group="hands",	target="BTN_LayoutPartHandR",		toggle="BTN_SelectPartHandR",		{	text=XLT("Right"),		},	 },
						},
						{
							hide=0,
							label="BTN_LayoutPartHand",
							{
								limit_wide=4,
								{	button="BTN_HandsSelect",	part_group="hand",	style="nofill", part_name="default",			{	min_width=PBW,	min_height=PBH,					},	},
								{	button="BTN_HandsSelect",	part_group="hand",	style="nofill", part_name="foot",				{	min_width=PBW,	min_height=PBH,				},	},
								{	button="BTN_HandsSelect",	part_group="hand",	style="nofill", part_name="hoof",				{	min_width=PBW,	min_height=PBH,				},	},
								{	button="BTN_HandsSelect",	part_group="hand",	style="nofill", part_name="none",				{	min_width=PBW,	min_height=PBH,				},	},

								{	button="BTN_HandsSelect",	part_group="hand",	style="nofill", part_name="robox",				{	min_width=PBW,	min_height=PBH,				},	},
								{	button="BTN_HandsSelect",	part_group="hand",	style="nofill", part_name="none",				{	min_width=PBW,	min_height=PBH,				},	},
								{	button="BTN_HandsSelect",	part_group="hand",	style="nofill", part_name="none",				{	min_width=PBW,	min_height=PBH,				},	},
								{	button="BTN_HandsSelect",	part_group="hand",	style="nofill", part_name="none",				{	min_width=PBW,	min_height=PBH,				},	},

								{	button="BTN_HandsSelect",	part_group="hand",	style="nofill", part_name="none",				{	min_width=PBW,	min_height=PBH,				},	},
								{	button="BTN_HandsSelect",	part_group="hand",	style="nofill", part_name="none",				{	min_width=PBW,	min_height=PBH,				},	},
								{	button="BTN_HandsSelect",	part_group="hand",	style="nofill", part_name="none",				{	min_width=PBW,	min_height=PBH,				},	},
								{	button="BTN_HandsSelect",	part_group="hand",	style="nofill", part_name="none",				{	min_width=PBW,	min_height=PBH,				},	},

								{	button="BTN_HandsSelect",	part_group="hand",	style="nofill", part_name="none",				{	min_width=PBW,	min_height=PBH,				},	},
								{	button="BTN_HandsSelect",	part_group="hand",	style="nofill", part_name="none",				{	min_width=PBW,	min_height=PBH,				},	},
								{	button="BTN_HandsSelect",	part_group="hand",	style="nofill", part_name="none",				{	min_width=PBW,	min_height=PBH,				},	},
								{	button="BTN_HandsSelect",	part_group="hand",	style="nofill", part_name="none",				{	min_width=PBW,	min_height=PBH,				},	},
							},
						},
						{
							hide=1,
							label="BTN_LayoutPartHandL",
							{
								limit_wide=4,
								{	button="BTN_InHandLSelect",	part_group="inhand",	style="nofill", part_name="dagger",				{	min_width=PBW,	min_height=PBH,				},	},
								{	button="BTN_InHandLSelect",	part_group="inhand",	style="nofill", part_name="hammer",				{	min_width=PBW,	min_height=PBH,				},	},
								{	button="BTN_InHandLSelect",	part_group="inhand",	style="nofill", part_name="pistol",				{	min_width=PBW,	min_height=PBH,				},	},
								{	button="BTN_InHandLSelect",	part_group="inhand",	style="nofill", part_name="bottle_smashed",				{	min_width=PBW,	min_height=PBH,				},	},

								{	button="BTN_InHandLSelect",	part_group="inhand",	style="nofill", part_name="fag",				{	min_width=PBW,	min_height=PBH,				},	},
								{	button="BTN_InHandLSelect",	part_group="inhand",	style="nofill", part_name="cigar",				{	min_width=PBW,	min_height=PBH,				},	},
								{	button="BTN_InHandLSelect",	part_group="inhand",	style="nofill", part_name="pipe",				{	min_width=PBW,	min_height=PBH,				},	},
								{	button="BTN_InHandLSelect",	part_group="inhand",	style="nofill", part_name="bottle",				{	min_width=PBW,	min_height=PBH,				},	},

								{	button="BTN_InHandLSelect",	part_group="inhand",	style="nofill", part_name="joint",				{	min_width=PBW,	min_height=PBH,				},	},
								{	button="BTN_InHandLSelect",	part_group="inhand",	style="nofill", part_name="none",				{	min_width=PBW,	min_height=PBH,				},	},
								{	button="BTN_InHandLSelect",	part_group="inhand",	style="nofill", part_name="none",				{	min_width=PBW,	min_height=PBH,				},	},
								{	button="BTN_InHandLSelect",	part_group="inhand",	style="nofill", part_name="none",				{	min_width=PBW,	min_height=PBH,				},	},

								{	button="BTN_InHandLSelect",	part_group="inhand",	style="nofill", part_name="none",				{	min_width=PBW,	min_height=PBH,				},	},
								{	button="BTN_InHandLSelect",	part_group="inhand",	style="nofill", part_name="none",				{	min_width=PBW,	min_height=PBH,				},	},
								{	button="BTN_InHandLSelect",	part_group="inhand",	style="nofill", part_name="none",				{	min_width=PBW,	min_height=PBH,				},	},
								{	button="BTN_InHandLSelect",	part_group="inhand",	style="nofill", part_name="none",				{	min_width=PBW,	min_height=PBH,				},	},
							},
						},
						{
							hide=1,
							label="BTN_LayoutPartHandR",
							{
								limit_wide=4,
								{	button="BTN_InHandRSelect",	part_group="inhand",	style="nofill", part_name="dagger",				{	min_width=PBW,	min_height=PBH,				},	},
								{	button="BTN_InHandRSelect",	part_group="inhand",	style="nofill", part_name="hammer",				{	min_width=PBW,	min_height=PBH,				},	},
								{	button="BTN_InHandRSelect",	part_group="inhand",	style="nofill", part_name="pistol",				{	min_width=PBW,	min_height=PBH,				},	},
								{	button="BTN_InHandRSelect",	part_group="inhand",	style="nofill", part_name="bottle_smashed",				{	min_width=PBW,	min_height=PBH,				},	},

								{	button="BTN_InHandRSelect",	part_group="inhand",	style="nofill", part_name="fag",				{	min_width=PBW,	min_height=PBH,				},	},
								{	button="BTN_InHandRSelect",	part_group="inhand",	style="nofill", part_name="cigar",				{	min_width=PBW,	min_height=PBH,				},	},
								{	button="BTN_InHandRSelect",	part_group="inhand",	style="nofill", part_name="pipe",				{	min_width=PBW,	min_height=PBH,				},	},
								{	button="BTN_InHandRSelect",	part_group="inhand",	style="nofill", part_name="bottle",				{	min_width=PBW,	min_height=PBH,				},	},

								{	button="BTN_InHandRSelect",	part_group="inhand",	style="nofill", part_name="joint",				{	min_width=PBW,	min_height=PBH,				},	},
								{	button="BTN_InHandRSelect",	part_group="inhand",	style="nofill", part_name="none",				{	min_width=PBW,	min_height=PBH,				},	},
								{	button="BTN_InHandRSelect",	part_group="inhand",	style="nofill", part_name="none",				{	min_width=PBW,	min_height=PBH,				},	},
								{	button="BTN_InHandRSelect",	part_group="inhand",	style="nofill", part_name="none",				{	min_width=PBW,	min_height=PBH,				},	},

								{	button="BTN_InHandRSelect",	part_group="inhand",	style="nofill", part_name="none",				{	min_width=PBW,	min_height=PBH,				},	},
								{	button="BTN_InHandRSelect",	part_group="inhand",	style="nofill", part_name="none",				{	min_width=PBW,	min_height=PBH,				},	},
								{	button="BTN_InHandRSelect",	part_group="inhand",	style="nofill", part_name="none",				{	min_width=PBW,	min_height=PBH,				},	},
								{	button="BTN_InHandRSelect",	part_group="inhand",	style="nofill", part_name="none",				{	min_width=PBW,	min_height=PBH,				},	},
							},
						},
					},
				},
				{
					hide=1,
					label="BTN_LayoutPartFeet",
					{
						limit_wide=4,
						{	button="BTN_FeetSelect",	part_group="foot",	style="nofill", part_name="bare",			{	min_width=PBW,	min_height=PBH,				},	},
						{	button="BTN_FeetSelect",	part_group="foot",	style="nofill", part_name="flipflop",		{	min_width=PBW,	min_height=PBH,			},	},
						{	button="BTN_FeetSelect",	part_group="foot",	style="nofill", part_name="slipper",		{	min_width=PBW,	min_height=PBH,			},	},
						{	button="BTN_FeetSelect",	part_group="foot",	style="nofill", part_name="shoe",			{	min_width=PBW,	min_height=PBH,				},	},

						{	button="BTN_FeetSelect",	part_group="foot",	style="nofill", part_name="boot",			{	min_width=PBW,	min_height=PBH,				},	},
						{	button="BTN_FeetSelect",	part_group="foot",	style="nofill", part_name="heel",			{	min_width=PBW,	min_height=PBH,				},	},
						{	button="BTN_FeetSelect",	part_group="foot",	style="nofill", part_name="hoof",			{	min_width=PBW,	min_height=PBH,			},	},
						{	button="BTN_FeetSelect",	part_group="foot",	style="nofill", part_name="none",			{	min_width=PBW,	min_height=PBH,			},	},

						{	button="BTN_FeetSelect",	part_group="foot",	style="nofill", part_name="robox",			{	min_width=PBW,	min_height=PBH,			},	},
						{	button="BTN_FeetSelect",	part_group="foot",	style="nofill", part_name="none",			{	min_width=PBW,	min_height=PBH,			},	},
						{	button="BTN_FeetSelect",	part_group="foot",	style="nofill", part_name="none",			{	min_width=PBW,	min_height=PBH,			},	},
						{	button="BTN_FeetSelect",	part_group="foot",	style="nofill", part_name="none",			{	min_width=PBW,	min_height=PBH,			},	},

						{	button="BTN_FeetSelect",	part_group="foot",	style="nofill", part_name="none",			{	min_width=PBW,	min_height=PBH,			},	},
						{	button="BTN_FeetSelect",	part_group="foot",	style="nofill", part_name="none",			{	min_width=PBW,	min_height=PBH,			},	},
						{	button="BTN_FeetSelect",	part_group="foot",	style="nofill", part_name="none",			{	min_width=PBW,	min_height=PBH,			},	},
						{	button="BTN_FeetSelect",	part_group="foot",	style="nofill", part_name="none",			{	min_width=PBW,	min_height=PBH,			},	},
					},
				},
				{
					hide=1,
					label="BTN_LayoutPartTail",
					{
						limit_wide=4,
						{	button="BTN_TailSelect",	part_group="tail",	style="nofill", part_name="default",		{	min_width=PBW,	min_height=PBH,					},	},
						{	button="BTN_TailSelect",	part_group="tail",	style="nofill", part_name="bunny",		{	min_width=PBW,	min_height=PBH,					},	},
						{	button="BTN_TailSelect",	part_group="tail",	style="nofill", part_name="devil",		{	min_width=PBW,	min_height=PBH,					},	},
						{	button="BTN_TailSelect",	part_group="tail",	style="nofill", part_name="none",			{	min_width=PBW,	min_height=PBH,					},	},

						{	button="BTN_TailSelect",	part_group="tail",	style="nofill", part_name="none",			{	min_width=PBW,	min_height=PBH,					},	},
						{	button="BTN_TailSelect",	part_group="tail",	style="nofill", part_name="none",			{	min_width=PBW,	min_height=PBH,					},	},
						{	button="BTN_TailSelect",	part_group="tail",	style="nofill", part_name="none",			{	min_width=PBW,	min_height=PBH,					},	},
						{	button="BTN_TailSelect",	part_group="tail",	style="nofill", part_name="none",			{	min_width=PBW,	min_height=PBH,					},	},

						{	button="BTN_TailSelect",	part_group="tail",	style="nofill", part_name="none",			{	min_width=PBW,	min_height=PBH,					},	},
						{	button="BTN_TailSelect",	part_group="tail",	style="nofill", part_name="none",			{	min_width=PBW,	min_height=PBH,					},	},
						{	button="BTN_TailSelect",	part_group="tail",	style="nofill", part_name="none",			{	min_width=PBW,	min_height=PBH,					},	},
						{	button="BTN_TailSelect",	part_group="tail",	style="nofill", part_name="none",			{	min_width=PBW,	min_height=PBH,					},	},

						{	button="BTN_TailSelect",	part_group="tail",	style="nofill", part_name="none",			{	min_width=PBW,	min_height=PBH,					},	},
						{	button="BTN_TailSelect",	part_group="tail",	style="nofill", part_name="none",			{	min_width=PBW,	min_height=PBH,					},	},
						{	button="BTN_TailSelect",	part_group="tail",	style="nofill", part_name="none",			{	min_width=PBW,	min_height=PBH,					},	},
						{	button="BTN_TailSelect",	part_group="tail",	style="nofill", part_name="none",			{	min_width=PBW,	min_height=PBH,					},	},
					},
				},
				{
					hide=1,
					label="BTN_LayoutPartEyes",
					limit_wide=1,
					{
						limit_wide=4,
						{	button="BTN_EyesSelect",	part_group="eye",	style="nofill", part_name="default",		{	min_width=PBW,	min_height=PBH,				},	},
						{	button="BTN_EyesSelect",	part_group="eye",	style="nofill", part_name="bigbrow",		{	min_width=PBW,	min_height=PBH,				},	},
						{	button="BTN_EyesSelect",	part_group="eye",	style="nofill", part_name="brow",			{	min_width=PBW,	min_height=PBH,			},	},
						{	button="BTN_EyesSelect",	part_group="eye",	style="nofill", part_name="tribrow",		{	min_width=PBW,	min_height=PBH,			},	},

						{	button="BTN_EyesSelect",	part_group="eye",	style="nofill", part_name="robox",			{	min_width=PBW,	min_height=PBH,			},	},
						{	button="BTN_EyesSelect",	part_group="eye",	style="nofill", part_name="none",			{	min_width=PBW,	min_height=PBH,			},	},
						{	button="BTN_EyesSelect",	part_group="eye",	style="nofill", part_name="none",			{	min_width=PBW,	min_height=PBH,			},	},
						{	button="BTN_EyesSelect",	part_group="eye",	style="nofill", part_name="none",			{	min_width=PBW,	min_height=PBH,			},	},

						{	button="BTN_EyesSelect",	part_group="eye",	style="nofill", part_name="none",			{	min_width=PBW,	min_height=PBH,			},	},
						{	button="BTN_EyesSelect",	part_group="eye",	style="nofill", part_name="none",			{	min_width=PBW,	min_height=PBH,			},	},
						{	button="BTN_EyesSelect",	part_group="eye",	style="nofill", part_name="none",			{	min_width=PBW,	min_height=PBH,			},	},
						{	button="BTN_EyesSelect",	part_group="eye",	style="nofill", part_name="none",			{	min_width=PBW,	min_height=PBH,			},	},

						{	button="BTN_EyesSelect",	part_group="eye",	style="nofill", part_name="none",			{	min_width=PBW,	min_height=PBH,			},	},
						{	button="BTN_EyesSelect",	part_group="eye",	style="nofill", part_name="none",			{	min_width=PBW,	min_height=PBH,			},	},
						{	button="BTN_EyesSelect",	part_group="eye",	style="nofill", part_name="none",			{	min_width=PBW,	min_height=PBH,			},	},
						{	button="BTN_EyesSelect",	part_group="eye",	style="nofill", part_name="none",			{	min_width=PBW,	min_height=PBH,			},	},
					},
					{
						xalign=0,
						{
							handle_x="BTN_LeftEyeSize",
							{
								{	text=XLT("Left"), },
							},
						}
					},
					{
						xalign=0,
						{
							handle_x="BTN_RightEyeSize",
							{
								{	text=XLT("Right"), },
							},
						}
					},
				},
				{
					hide=1,
					label="BTN_LayoutPartEyeballs",
					{
						limit_wide=4,
						{	button="BTN_EyeBallsSelect",	part_group="eyeball",	style="nofill", part_name="default",		{	min_width=PBW,	min_height=PBH,			},	},
						{	button="BTN_EyeBallsSelect",	part_group="eyeball",	style="nofill", part_name="diamond",		{	min_width=PBW,	min_height=PBH,				},	},
						{	button="BTN_EyeBallsSelect",	part_group="eyeball",	style="nofill", part_name="none",			{	min_width=PBW,	min_height=PBH,				},	},
						{	button="BTN_EyeBallsSelect",	part_group="eyeball",	style="nofill", part_name="none",			{	min_width=PBW,	min_height=PBH,				},	},

						{	button="BTN_EyeBallsSelect",	part_group="eyeball",	style="nofill", part_name="none",			{	min_width=PBW,	min_height=PBH,				},	},
						{	button="BTN_EyeBallsSelect",	part_group="eyeball",	style="nofill", part_name="none",			{	min_width=PBW,	min_height=PBH,				},	},
						{	button="BTN_EyeBallsSelect",	part_group="eyeball",	style="nofill", part_name="none",			{	min_width=PBW,	min_height=PBH,				},	},
						{	button="BTN_EyeBallsSelect",	part_group="eyeball",	style="nofill", part_name="none",			{	min_width=PBW,	min_height=PBH,				},	},

						{	button="BTN_EyeBallsSelect",	part_group="eyeball",	style="nofill", part_name="none",			{	min_width=PBW,	min_height=PBH,				},	},
						{	button="BTN_EyeBallsSelect",	part_group="eyeball",	style="nofill", part_name="none",			{	min_width=PBW,	min_height=PBH,				},	},
						{	button="BTN_EyeBallsSelect",	part_group="eyeball",	style="nofill", part_name="none",			{	min_width=PBW,	min_height=PBH,				},	},
						{	button="BTN_EyeBallsSelect",	part_group="eyeball",	style="nofill", part_name="none",			{	min_width=PBW,	min_height=PBH,				},	},

						{	button="BTN_EyeBallsSelect",	part_group="eyeball",	style="nofill", part_name="none",			{	min_width=PBW,	min_height=PBH,				},	},
						{	button="BTN_EyeBallsSelect",	part_group="eyeball",	style="nofill", part_name="none",			{	min_width=PBW,	min_height=PBH,				},	},
						{	button="BTN_EyeBallsSelect",	part_group="eyeball",	style="nofill", part_name="none",			{	min_width=PBW,	min_height=PBH,				},	},
						{	button="BTN_EyeBallsSelect",	part_group="eyeball",	style="nofill", part_name="none",			{	min_width=PBW,	min_height=PBH,				},	},
					},
				},
				{
					hide=1,
					label="BTN_LayoutPartSpecs",
					{
						limit_wide=4,
						{	button="BTN_SpecsSelect",	part_group="specs",	style="nofill", part_name="default",			{	min_width=PBW,	min_height=PBH,			},	},
						{	button="BTN_SpecsSelect",	part_group="specs",	style="nofill", part_name="round",				{	min_width=PBW,	min_height=PBH,			},	},
						{	button="BTN_SpecsSelect",	part_group="specs",	style="nofill", part_name="eyepatch_left",		{	min_width=PBW,	min_height=PBH,			},	},
						{	button="BTN_SpecsSelect",	part_group="specs",	style="nofill", part_name="eyepatch_right",		{	min_width=PBW,	min_height=PBH,			},	},

						{	button="BTN_SpecsSelect",	part_group="specs",	style="nofill", part_name="none",				{	min_width=PBW,	min_height=PBH,			},	},
						{	button="BTN_SpecsSelect",	part_group="specs",	style="nofill", part_name="none",				{	min_width=PBW,	min_height=PBH,			},	},
						{	button="BTN_SpecsSelect",	part_group="specs",	style="nofill", part_name="none",				{	min_width=PBW,	min_height=PBH,			},	},
						{	button="BTN_SpecsSelect",	part_group="specs",	style="nofill", part_name="none",				{	min_width=PBW,	min_height=PBH,			},	},

						{	button="BTN_SpecsSelect",	part_group="specs",	style="nofill", part_name="none",				{	min_width=PBW,	min_height=PBH,			},	},
						{	button="BTN_SpecsSelect",	part_group="specs",	style="nofill", part_name="none",				{	min_width=PBW,	min_height=PBH,			},	},
						{	button="BTN_SpecsSelect",	part_group="specs",	style="nofill", part_name="none",				{	min_width=PBW,	min_height=PBH,			},	},
						{	button="BTN_SpecsSelect",	part_group="specs",	style="nofill", part_name="none",				{	min_width=PBW,	min_height=PBH,			},	},

						{	button="BTN_SpecsSelect",	part_group="specs",	style="nofill", part_name="none",				{	min_width=PBW,	min_height=PBH,			},	},
						{	button="BTN_SpecsSelect",	part_group="specs",	style="nofill", part_name="none",				{	min_width=PBW,	min_height=PBH,			},	},
						{	button="BTN_SpecsSelect",	part_group="specs",	style="nofill", part_name="none",				{	min_width=PBW,	min_height=PBH,			},	},
						{	button="BTN_SpecsSelect",	part_group="specs",	style="nofill", part_name="none",				{	min_width=PBW,	min_height=PBH,			},	},
					},
				},
				{
					hide=1,
					label="BTN_LayoutPartMouth",
					limit_wide=1,
					{
						limit_wide=4,
						{	button="BTN_MouthSelect",	part_group="mouth",	style="nofill", part_name="default",		{	min_width=PBW,	min_height=PBH,		},	},
						{	button="BTN_MouthSelect",	part_group="mouth",	style="nofill", part_name="fat",			{	min_width=PBW,	min_height=PBH,			},	},
						{	button="BTN_MouthSelect",	part_group="mouth",	style="nofill", part_name="thin",			{	min_width=PBW,	min_height=PBH,			},	},
						{	button="BTN_MouthSelect",	part_group="mouth",	style="nofill", part_name="bow",			{	min_width=PBW,	min_height=PBH,			},	},

						{	button="BTN_MouthSelect",	part_group="mouth",	style="nofill", part_name="bow_fat",		{	min_width=PBW,	min_height=PBH,			},	},
						{	button="BTN_MouthSelect",	part_group="mouth",	style="nofill", part_name="bow_thin",		{	min_width=PBW,	min_height=PBH,			},	},
						{	button="BTN_MouthSelect",	part_group="mouth",	style="nofill", part_name="beak",			{	min_width=PBW,	min_height=PBH,		},	},
						{	button="BTN_MouthSelect",	part_group="mouth",	style="nofill", part_name="squid",			{	min_width=PBW,	min_height=PBH,		},	},

						{	button="BTN_MouthSelect",	part_group="mouth",	style="nofill", part_name="jaw",			{	min_width=PBW,	min_height=PBH,		},	},
						{	button="BTN_MouthSelect",	part_group="mouth",	style="nofill", part_name="robox",			{	min_width=PBW,	min_height=PBH,		},	},
						{	button="BTN_MouthSelect",	part_group="mouth",	style="nofill", part_name="none",			{	min_width=PBW,	min_height=PBH,		},	},
						{	button="BTN_MouthSelect",	part_group="mouth",	style="nofill", part_name="none",			{	min_width=PBW,	min_height=PBH,		},	},

						{	button="BTN_MouthSelect",	part_group="mouth",	style="nofill", part_name="none",			{	min_width=PBW,	min_height=PBH,		},	},
						{	button="BTN_MouthSelect",	part_group="mouth",	style="nofill", part_name="none",			{	min_width=PBW,	min_height=PBH,		},	},
						{	button="BTN_MouthSelect",	part_group="mouth",	style="nofill", part_name="none",			{	min_width=PBW,	min_height=PBH,		},	},
						{	button="BTN_MouthSelect",	part_group="mouth",	style="nofill", part_name="none",			{	min_width=PBW,	min_height=PBH,		},	},
					},
					{
						xalign=0,
						{
							handle_x="BTN_MouthSize",
							{
								{	text=XLT("Size"), },
							},
						}
					},
				},
				{
					hide=1,
					label="BTN_LayoutPartBeard",
					{
						limit_wide=4,
						{	button="BTN_BeardSelect",	part_group="beard",	style="nofill", part_name="circle",			{	min_width=PBW,	min_height=PBH,				},	},
						{	button="BTN_BeardSelect",	part_group="beard",	style="nofill", part_name="circle_point",	{	min_width=PBW,	min_height=PBH,	},	},
						{	button="BTN_BeardSelect",	part_group="beard",	style="nofill", part_name="tash",			{	min_width=PBW,	min_height=PBH,				},	},
						{	button="BTN_BeardSelect",	part_group="beard",	style="nofill", part_name="whiskers",		{	min_width=PBW,	min_height=PBH,				},	},

						{	button="BTN_BeardSelect",	part_group="beard",	style="nofill", part_name="none",			{	min_width=PBW,	min_height=PBH,			},	},
						{	button="BTN_BeardSelect",	part_group="beard",	style="nofill", part_name="none",			{	min_width=PBW,	min_height=PBH,			},	},
						{	button="BTN_BeardSelect",	part_group="beard",	style="nofill", part_name="none",			{	min_width=PBW,	min_height=PBH,			},	},
						{	button="BTN_BeardSelect",	part_group="beard",	style="nofill", part_name="none",			{	min_width=PBW,	min_height=PBH,			},	},

						{	button="BTN_InMouthSelect",	part_group="inmouth",	style="nofill", part_name="pipe",			{	min_width=PBW,	min_height=PBH,			},	},
						{	button="BTN_InMouthSelect",	part_group="inmouth",	style="nofill", part_name="fag",			{	min_width=PBW,	min_height=PBH,			},	},
						{	button="BTN_InMouthSelect",	part_group="inmouth",	style="nofill", part_name="cigar",			{	min_width=PBW,	min_height=PBH,			},	},
						{	button="BTN_InMouthSelect",	part_group="inmouth",	style="nofill", part_name="joint",			{	min_width=PBW,	min_height=PBH,			},	},

						{	button="BTN_InMouthSelect",	part_group="inmouth",	style="nofill", part_name="sushi_nigiri",	{	min_width=PBW,	min_height=PBH,			},	},
						{	button="BTN_InMouthSelect",	part_group="inmouth",	style="nofill", part_name="none",			{	min_width=PBW,	min_height=PBH,			},	},
						{	button="BTN_InMouthSelect",	part_group="inmouth",	style="nofill", part_name="none",			{	min_width=PBW,	min_height=PBH,			},	},
						{	button="BTN_InMouthSelect",	part_group="inmouth",	style="nofill", part_name="none",			{	min_width=PBW,	min_height=PBH,			},	},
					},
				},
				{
					hide=1,
					label="BTN_LayoutPartNose",
					limit_wide=1,
					{
						limit_wide=4,
						{	button="BTN_NoseSelect",	part_group="nose",	style="nofill", part_name="small",			{	min_width=PBW,	min_height=PBH,				},	},
						{	button="BTN_NoseSelect",	part_group="nose",	style="nofill", part_name="wide",			{	min_width=PBW,	min_height=PBH,			},	},
						{	button="BTN_NoseSelect",	part_group="nose",	style="nofill", part_name="small_up",		{	min_width=PBW,	min_height=PBH,			},	},
						{	button="BTN_NoseSelect",	part_group="nose",	style="nofill", part_name="wide_up",		{	min_width=PBW,	min_height=PBH,			},	},

						{	button="BTN_NoseSelect",	part_group="nose",	style="nofill", part_name="snub",			{	min_width=PBW,	min_height=PBH,			},	},
						{	button="BTN_NoseSelect",	part_group="nose",	style="nofill", part_name="clown",			{	min_width=PBW,	min_height=PBH,			},	},
						{	button="BTN_NoseSelect",	part_group="nose",	style="nofill", part_name="snout",			{	min_width=PBW,	min_height=PBH,			},	},
						{	button="BTN_NoseSelect",	part_group="nose",	style="nofill", part_name="none",			{	min_width=PBW,	min_height=PBH,			},	},

						{	button="BTN_NoseSelect",	part_group="nose",	style="nofill", part_name="robox",			{	min_width=PBW,	min_height=PBH,			},	},
						{	button="BTN_NoseSelect",	part_group="nose",	style="nofill", part_name="none",			{	min_width=PBW,	min_height=PBH,			},	},
						{	button="BTN_NoseSelect",	part_group="nose",	style="nofill", part_name="none",			{	min_width=PBW,	min_height=PBH,			},	},
						{	button="BTN_NoseSelect",	part_group="nose",	style="nofill", part_name="none",			{	min_width=PBW,	min_height=PBH,			},	},

						{	button="BTN_NoseSelect",	part_group="nose",	style="nofill", part_name="none",			{	min_width=PBW,	min_height=PBH,			},	},
						{	button="BTN_NoseSelect",	part_group="nose",	style="nofill", part_name="none",			{	min_width=PBW,	min_height=PBH,			},	},
						{	button="BTN_NoseSelect",	part_group="nose",	style="nofill", part_name="none",			{	min_width=PBW,	min_height=PBH,			},	},
						{	button="BTN_NoseSelect",	part_group="nose",	style="nofill", part_name="none",			{	min_width=PBW,	min_height=PBH,			},	},
					},
					{
						xalign=0,
						{
							handle_x="BTN_NoseSize",
							{
								{	text=XLT("Size"), },
							},
						}
					},
				},
				{
					hide=1,
					label="BTN_LayoutPartEars",
					limit_wide=1,
					{
						limit_wide=4,
						{	button="BTN_EarsSelect",	part_group="ear",	style="nofill", part_name="default",		{	min_width=PBW,	min_height=PBH,			},	},
						{	button="BTN_EarsSelect",	part_group="ear",	style="nofill", part_name="big",			{	min_width=PBW,	min_height=PBH,				},	},
						{	button="BTN_EarsSelect",	part_group="ear",	style="nofill", part_name="big_sticky",		{	min_width=PBW,	min_height=PBH,		},	},
						{	button="BTN_EarsSelect",	part_group="ear",	style="nofill", part_name="none",			{	min_width=PBW,	min_height=PBH,		},	},

						{	button="BTN_EarsSelect",	part_group="ear",	style="nofill", part_name="robox",			{	min_width=PBW,	min_height=PBH,		},	},
						{	button="BTN_EarsSelect",	part_group="ear",	style="nofill", part_name="none",			{	min_width=PBW,	min_height=PBH,		},	},
						{	button="BTN_EarsSelect",	part_group="ear",	style="nofill", part_name="none",			{	min_width=PBW,	min_height=PBH,		},	},
						{	button="BTN_EarsSelect",	part_group="ear",	style="nofill", part_name="none",			{	min_width=PBW,	min_height=PBH,		},	},

						{	button="BTN_EarsSelect",	part_group="ear",	style="nofill", part_name="none",			{	min_width=PBW,	min_height=PBH,		},	},
						{	button="BTN_EarsSelect",	part_group="ear",	style="nofill", part_name="none",			{	min_width=PBW,	min_height=PBH,		},	},
						{	button="BTN_EarsSelect",	part_group="ear",	style="nofill", part_name="none",			{	min_width=PBW,	min_height=PBH,		},	},
						{	button="BTN_EarsSelect",	part_group="ear",	style="nofill", part_name="none",			{	min_width=PBW,	min_height=PBH,		},	},

						{	button="BTN_EarsSelect",	part_group="ear",	style="nofill", part_name="none",			{	min_width=PBW,	min_height=PBH,		},	},
						{	button="BTN_EarsSelect",	part_group="ear",	style="nofill", part_name="none",			{	min_width=PBW,	min_height=PBH,		},	},
						{	button="BTN_EarsSelect",	part_group="ear",	style="nofill", part_name="none",			{	min_width=PBW,	min_height=PBH,		},	},
						{	button="BTN_EarsSelect",	part_group="ear",	style="nofill", part_name="none",			{	min_width=PBW,	min_height=PBH,		},	},
					},
					{
						xalign=0,
						{
							handle_x="BTN_LeftEarSize",
							{
								{	text=XLT("Left"), },
							},
						}
					},
					{
						xalign=0,
						{
							handle_x="BTN_RightEarSize",
							{
								{	text=XLT("Right"), },
							},
						}
					},
				},
			},
			{
				limit_wide=1,
				{
					label="BTN_Avatar",
					min_width=200,
					min_height=200,
				},
				{
					xalign=0,
					{
						handle_x="BTN_RotY",
						{
							{	text=XLT("Rotate"), },
						},
					}
				},
			},
		},
	},
	{
		hide=1,
		label="BTN_LayoutPose",
		limit_wide=1,
		{
			limit_wide=2,
			{
				{
					limit_wide=1,
					{	button="BTN_AnimCycleWalk",				{	text=XLT("Walk"),			},	},
					{	button="BTN_AnimCycleZeeWalk",			{	text=XLT("Zee Walk"),		},	},
					{	button="BTN_AnimCycleQuadWalk",			{	text=XLT("Quad Walk"),		},	},
					{	button="BTN_AnimCycleQuadRun",			{	text=XLT("Quad Run"),		},	},
					{	button="BTN_AnimPush",					{	text=XLT("Push"),			},	},
					{	button="BTN_AnimSplatToIdle",			{	text=XLT("Get Up"),			},	},
					{	button="BTN_AnimIdleBreath",			{	text=XLT("Breath"),			},	},
					{	button="BTN_AnimPoseIdle",				{	text=XLT("Idle"),			},	},
					{	button="BTN_AnimPoseQuadIdle",			{	text=XLT("Quad Idle"),		},	},
					{	button="BTN_AnimPosePointUpDown",		{	text=XLT("Point up down"),	},	},
					{	button="BTN_AnimPosePointDownUp",		{	text=XLT("Point down up"),	},	},
					{	button="BTN_AnimPoseGunner",			{	text=XLT("Gunner"),			},	},
					{	button="BTN_AnimPoseHandsOnHips",		{	text=XLT("Hands on hips"),	},	},
					{	button="BTN_AnimPoseBird",				{	text=XLT("Bird"),			},	},
					{	button="BTN_AnimPoseTeapot",			{	text=XLT("Teapot"),			},	},
					{	button="BTN_AnimPoseAngry",				{	text=XLT("Angry"),			},	},
					{	button="BTN_AnimPoseAwake",				{	text=XLT("Awake"),			},	},
					{	button="BTN_AnimPoseConfused",			{	text=XLT("Confused"),		},	},
					{	button="BTN_AnimPoseDetermind",			{	text=XLT("Determind"),		},	},
					{	button="BTN_AnimPoseDevious",			{	text=XLT("Devious"),		},	},
					{	button="BTN_AnimPoseEmbarrassed",		{	text=XLT("Embarrassed"),	},	},
					{	button="BTN_AnimPoseEnergetic",			{	text=XLT("Energetic"),		},	},
					{	button="BTN_AnimPoseEnthralled",		{	text=XLT("Enthralled"),		},	},
					{	button="BTN_AnimPoseExcited",			{	text=XLT("Excited"),		},	},
					{	button="BTN_AnimPoseHappy",				{	text=XLT("Happy"),			},	},
					{	button="BTN_AnimPoseIndescribable",		{	text=XLT("Indescribable"),	},	},
					{	button="BTN_AnimPoseNerdy",				{	text=XLT("Nerdy"),			},	},
					{	button="BTN_AnimPoseOkay",				{	text=XLT("Okay"),			},	},
					{	button="BTN_AnimPoseSad",				{	text=XLT("Sad"),			},	},
					{	button="BTN_AnimPoseSleepy",			{	text=XLT("Sleepy"),			},	},
					{	button="BTN_AnimPoseScared",			{	text=XLT("Scared"),			},	},
					{	button="BTN_AnimPoseThoughtful",		{	text=XLT("Thoughtful"),		},	},
					{	button="BTN_AnimPoseWorking",			{	text=XLT("Working"),		},	},
					{	button="BTN_AnimTest",					{	text=XLT("Test"),			},	},
					{	button="BTN_AnimSwing",					{	text=XLT("Swing"),			},	},
					{	button="BTN_AnimStab",					{	text=XLT("Stab"),			},	},
				},
				{
					limit_wide=1,
					{
						label="BTN_Avatar",
						min_width=200,
						min_height=200,
					},
					{
						xalign=0,
						{
							handle_x="BTN_RotY",
							{
								{	text=XLT("Rotate"), },
							},
						}
					},
					{
						limit_wide=2,
						{	button="BTN_ViewFront",			{	text=XLT("Front"),			},	},
						{	button="BTN_ViewBack",			{	text=XLT("Back"),			},	},
						{	button="BTN_ViewLeft",			{	text=XLT("Left"),			},	},
						{	button="BTN_ViewRight",			{	text=XLT("Right"),			},	},
						{	group="rotate",		button="BTN_ViewRotateOn",			{	text=XLT("Rotate ON"),			},	selected=1,	},
						{	group="rotate",		button="BTN_ViewRotateOff",			{	text=XLT("Rotate OFF"),			},	selected=0,	},
					},
				},
			},
		},
	},
	{
		hide=1,
		label="BTN_LayoutColors",
		limit_wide=1,
		{
			limit_wide=2,
			{
				limit_wide=1,
				{
					max_height=32,
					limit_high=1,
					{	group="color",	target="BTN_LayoutColor",	toggle="BTN_SelectColor",	{	text=XLT("Color"),	},	selected=1,	},
					{	group="color",	target="BTN_LayoutShine",	toggle="BTN_SelectShine",	{	text=XLT("Shine"),	},	selected=0,	},
				},
				{
					hide=0,
					limit_wide=1,
					label="BTN_LayoutColor",
					{
						limit_wide=8,
						{	button="BTN_ColorPick",		color="0xff000000",		min_width=CBW,	min_height=CBH,	},
						{	button="BTN_ColorPick",		color="0xff444444",		min_width=CBW,	min_height=CBH,	},
						{	button="BTN_ColorPick",		color="0xff666666",		min_width=CBW,	min_height=CBH,	},
						{	button="BTN_ColorPick",		color="0xff888888",		min_width=CBW,	min_height=CBH,	},
						{	button="BTN_ColorPick",		color="0xffaaaaaa",		min_width=CBW,	min_height=CBH,	},
						{	button="BTN_ColorPick",		color="0xffcccccc",		min_width=CBW,	min_height=CBH,	},
						{	button="BTN_ColorPick",		color="0xffeeeeee",		min_width=CBW,	min_height=CBH,	},
						{	button="BTN_ColorPick",		color="0xffffffff",		min_width=CBW,	min_height=CBH,	},

						{	button="BTN_ColorPick",		color="0xff0000ff",		min_width=CBW,	min_height=CBH,	},
						{	button="BTN_ColorPick",		color="0xff0088ff",		min_width=CBW,	min_height=CBH,	},
						{	button="BTN_ColorPick",		color="0xff8800ff",		min_width=CBW,	min_height=CBH,	},
						{	button="BTN_ColorPick",		color="0xff8888ff",		min_width=CBW,	min_height=CBH,	},
						{	button="BTN_ColorPick",		color="0xff00ff00",		min_width=CBW,	min_height=CBH,	},
						{	button="BTN_ColorPick",		color="0xff00ff88",		min_width=CBW,	min_height=CBH,	},
						{	button="BTN_ColorPick",		color="0xff88ff00",		min_width=CBW,	min_height=CBH,	},
						{	button="BTN_ColorPick",		color="0xff88ff88",		min_width=CBW,	min_height=CBH,	},

						{	button="BTN_ColorPick",		color="0xff0000cc",		min_width=CBW,	min_height=CBH,	},
						{	button="BTN_ColorPick",		color="0xff0066cc",		min_width=CBW,	min_height=CBH,	},
						{	button="BTN_ColorPick",		color="0xff6600cc",		min_width=CBW,	min_height=CBH,	},
						{	button="BTN_ColorPick",		color="0xff6666cc",		min_width=CBW,	min_height=CBH,	},
						{	button="BTN_ColorPick",		color="0xff00cc00",		min_width=CBW,	min_height=CBH,	},
						{	button="BTN_ColorPick",		color="0xff00cc66",		min_width=CBW,	min_height=CBH,	},
						{	button="BTN_ColorPick",		color="0xff66cc00",		min_width=CBW,	min_height=CBH,	},
						{	button="BTN_ColorPick",		color="0xff66cc66",		min_width=CBW,	min_height=CBH,	},

						{	button="BTN_ColorPick",		color="0xff999900",		min_width=CBW,	min_height=CBH,	},
						{	button="BTN_ColorPick",		color="0xff666600",		min_width=CBW,	min_height=CBH,	},
						{	button="BTN_ColorPick",		color="0xff000066",		min_width=CBW,	min_height=CBH,	},
						{	button="BTN_ColorPick",		color="0xff000099",		min_width=CBW,	min_height=CBH,	},
						{	button="BTN_ColorPick",		color="0xff990000",		min_width=CBW,	min_height=CBH,	},
						{	button="BTN_ColorPick",		color="0xff660000",		min_width=CBW,	min_height=CBH,	},
						{	button="BTN_ColorPick",		color="0xff006600",		min_width=CBW,	min_height=CBH,	},
						{	button="BTN_ColorPick",		color="0xff009900",		min_width=CBW,	min_height=CBH,	},


						{	button="BTN_ColorPick",		color="0xffcccc00",		min_width=CBW,	min_height=CBH,	},
						{	button="BTN_ColorPick",		color="0xffcccc66",		min_width=CBW,	min_height=CBH,	},
						{	button="BTN_ColorPick",		color="0xffcc6600",		min_width=CBW,	min_height=CBH,	},
						{	button="BTN_ColorPick",		color="0xffcc0000",		min_width=CBW,	min_height=CBH,	},
						{	button="BTN_ColorPick",		color="0xffcc0066",		min_width=CBW,	min_height=CBH,	},
						{	button="BTN_ColorPick",		color="0xffcc6666",		min_width=CBW,	min_height=CBH,	},
						{	button="BTN_ColorPick",		color="0xffcc66cc",		min_width=CBW,	min_height=CBH,	},
						{	button="BTN_ColorPick",		color="0xff66cccc",		min_width=CBW,	min_height=CBH,	},

						{	button="BTN_ColorPick",		color="0xffffff00",		min_width=CBW,	min_height=CBH,	},
						{	button="BTN_ColorPick",		color="0xffffff88",		min_width=CBW,	min_height=CBH,	},
						{	button="BTN_ColorPick",		color="0xffff8800",		min_width=CBW,	min_height=CBH,	},
						{	button="BTN_ColorPick",		color="0xffff0000",		min_width=CBW,	min_height=CBH,	},
						{	button="BTN_ColorPick",		color="0xffff0088",		min_width=CBW,	min_height=CBH,	},
						{	button="BTN_ColorPick",		color="0xffff8888",		min_width=CBW,	min_height=CBH,	},
						{	button="BTN_ColorPick",		color="0xffff88ff",		min_width=CBW,	min_height=CBH,	},
						{	button="BTN_ColorPick",		color="0xff88ffff",		min_width=CBW,	min_height=CBH,	},

						{	button="BTN_ColorPick",		color="0xffaa6644",		min_width=CBW,	min_height=CBH,	},
						{	button="BTN_ColorPick",		color="0xffdd9977",		min_width=CBW,	min_height=CBH,	},
						{	button="BTN_ColorPick",		color="0xffddcc99",		min_width=CBW,	min_height=CBH,	},
						{	button="BTN_ColorPick",		color="0xffeebb99",		min_width=CBW,	min_height=CBH,	},
						{	button="BTN_ColorPick",		color="0xffffbb99",		min_width=CBW,	min_height=CBH,	},
						{	button="BTN_ColorPick",		color="0xffffaaaa",		min_width=CBW,	min_height=CBH,	},
						{	button="BTN_ColorPick",		color="0xffddbbbb",		min_width=CBW,	min_height=CBH,	},
						{	button="BTN_ColorPick",		color="0xffbbbbdd",		min_width=CBW,	min_height=CBH,	},
					},
					{
						limit_wide=1,
						{
							xalign=0,
							{
								handle_x="BTN_ColorA",
								{
									{	text="A",	min_width=CBW,	min_height=CBH,	},
								},
							}
						},
						{
							xalign=0,
							{
								handle_x="BTN_ColorR",
								{
									{	text="R",	min_width=CBW,	min_height=CBH,	},
								},
							}
						},
						{
							xalign=0,
							{
								handle_x="BTN_ColorG",
								{
									{	text="G",	min_width=CBW,	min_height=CBH,	},
								},
							}
						},
						{
							xalign=0,
							{
								handle_x="BTN_ColorB",
								{
									{	text="B",	min_width=CBW,	min_height=CBH,	},
								},
							}
						},
					},
				},
				{
					hide=1,
					limit_wide=1,
					label="BTN_LayoutShine",
					{
						limit_wide=8,
						{	button="BTN_SpecPick",		color="0xff000000",		min_width=CBW,	min_height=CBH,	},
						{	button="BTN_SpecPick",		color="0xff444444",		min_width=CBW,	min_height=CBH,	},
						{	button="BTN_SpecPick",		color="0xff666666",		min_width=CBW,	min_height=CBH,	},
						{	button="BTN_SpecPick",		color="0xff888888",		min_width=CBW,	min_height=CBH,	},
						{	button="BTN_SpecPick",		color="0xffaaaaaa",		min_width=CBW,	min_height=CBH,	},
						{	button="BTN_SpecPick",		color="0xffcccccc",		min_width=CBW,	min_height=CBH,	},
						{	button="BTN_SpecPick",		color="0xffeeeeee",		min_width=CBW,	min_height=CBH,	},
						{	button="BTN_SpecPick",		color="0xffffffff",		min_width=CBW,	min_height=CBH,	},

						{	button="BTN_SpecPick",		color="0xff0000ff",		min_width=CBW,	min_height=CBH,	},
						{	button="BTN_SpecPick",		color="0xff0088ff",		min_width=CBW,	min_height=CBH,	},
						{	button="BTN_SpecPick",		color="0xff8800ff",		min_width=CBW,	min_height=CBH,	},
						{	button="BTN_SpecPick",		color="0xff8888ff",		min_width=CBW,	min_height=CBH,	},
						{	button="BTN_SpecPick",		color="0xff00ff00",		min_width=CBW,	min_height=CBH,	},
						{	button="BTN_SpecPick",		color="0xff00ff88",		min_width=CBW,	min_height=CBH,	},
						{	button="BTN_SpecPick",		color="0xff88ff00",		min_width=CBW,	min_height=CBH,	},
						{	button="BTN_SpecPick",		color="0xff88ff88",		min_width=CBW,	min_height=CBH,	},

						{	button="BTN_SpecPick",		color="0xff0000cc",		min_width=CBW,	min_height=CBH,	},
						{	button="BTN_SpecPick",		color="0xff0066cc",		min_width=CBW,	min_height=CBH,	},
						{	button="BTN_SpecPick",		color="0xff6600cc",		min_width=CBW,	min_height=CBH,	},
						{	button="BTN_SpecPick",		color="0xff6666cc",		min_width=CBW,	min_height=CBH,	},
						{	button="BTN_SpecPick",		color="0xff00cc00",		min_width=CBW,	min_height=CBH,	},
						{	button="BTN_SpecPick",		color="0xff00cc66",		min_width=CBW,	min_height=CBH,	},
						{	button="BTN_SpecPick",		color="0xff66cc00",		min_width=CBW,	min_height=CBH,	},
						{	button="BTN_SpecPick",		color="0xff66cc66",		min_width=CBW,	min_height=CBH,	},

						{	button="BTN_SpecPick",		color="0xff999900",		min_width=CBW,	min_height=CBH,	},
						{	button="BTN_SpecPick",		color="0xff666600",		min_width=CBW,	min_height=CBH,	},
						{	button="BTN_SpecPick",		color="0xff000066",		min_width=CBW,	min_height=CBH,	},
						{	button="BTN_SpecPick",		color="0xff000099",		min_width=CBW,	min_height=CBH,	},
						{	button="BTN_SpecPick",		color="0xff990000",		min_width=CBW,	min_height=CBH,	},
						{	button="BTN_SpecPick",		color="0xff660000",		min_width=CBW,	min_height=CBH,	},
						{	button="BTN_SpecPick",		color="0xff006600",		min_width=CBW,	min_height=CBH,	},
						{	button="BTN_SpecPick",		color="0xff009900",		min_width=CBW,	min_height=CBH,	},


						{	button="BTN_SpecPick",		color="0xffcccc00",		min_width=CBW,	min_height=CBH,	},
						{	button="BTN_SpecPick",		color="0xffcccc66",		min_width=CBW,	min_height=CBH,	},
						{	button="BTN_SpecPick",		color="0xffcc6600",		min_width=CBW,	min_height=CBH,	},
						{	button="BTN_SpecPick",		color="0xffcc0000",		min_width=CBW,	min_height=CBH,	},
						{	button="BTN_SpecPick",		color="0xffcc0066",		min_width=CBW,	min_height=CBH,	},
						{	button="BTN_SpecPick",		color="0xffcc6666",		min_width=CBW,	min_height=CBH,	},
						{	button="BTN_SpecPick",		color="0xffcc66cc",		min_width=CBW,	min_height=CBH,	},
						{	button="BTN_SpecPick",		color="0xff66cccc",		min_width=CBW,	min_height=CBH,	},

						{	button="BTN_SpecPick",		color="0xffffff00",		min_width=CBW,	min_height=CBH,	},
						{	button="BTN_SpecPick",		color="0xffffff88",		min_width=CBW,	min_height=CBH,	},
						{	button="BTN_SpecPick",		color="0xffff8800",		min_width=CBW,	min_height=CBH,	},
						{	button="BTN_SpecPick",		color="0xffff0000",		min_width=CBW,	min_height=CBH,	},
						{	button="BTN_SpecPick",		color="0xffff0088",		min_width=CBW,	min_height=CBH,	},
						{	button="BTN_SpecPick",		color="0xffff8888",		min_width=CBW,	min_height=CBH,	},
						{	button="BTN_SpecPick",		color="0xffff88ff",		min_width=CBW,	min_height=CBH,	},
						{	button="BTN_SpecPick",		color="0xff88ffff",		min_width=CBW,	min_height=CBH,	},

						{	button="BTN_SpecPick",		color="0xffaa6644",		min_width=CBW,	min_height=CBH,	},
						{	button="BTN_SpecPick",		color="0xffdd9977",		min_width=CBW,	min_height=CBH,	},
						{	button="BTN_SpecPick",		color="0xffddcc99",		min_width=CBW,	min_height=CBH,	},
						{	button="BTN_SpecPick",		color="0xffeebb99",		min_width=CBW,	min_height=CBH,	},
						{	button="BTN_SpecPick",		color="0xffffbb99",		min_width=CBW,	min_height=CBH,	},
						{	button="BTN_SpecPick",		color="0xffffaaaa",		min_width=CBW,	min_height=CBH,	},
						{	button="BTN_SpecPick",		color="0xffddbbbb",		min_width=CBW,	min_height=CBH,	},
						{	button="BTN_SpecPick",		color="0xffbbbbdd",		min_width=CBW,	min_height=CBH,	},
					},
					{
						limit_wide=1,
						{
							xalign=0,
							{
								handle_x="BTN_Gloss",
								{
									{	text=XLT("Gloss"),	min_width=CBW,	min_height=CBH,	},
								},
							}
						},
						{
							xalign=0,
							{
								handle_x="BTN_SpecR",
								{
									{	text="R",	min_width=CBW,	min_height=CBH,	},
								},
							}
						},
						{
							xalign=0,
							{
								handle_x="BTN_SpecG",
								{
									{	text="G",	min_width=CBW,	min_height=CBH,	},
								},
							}
						},
						{
							xalign=0,
							{
								handle_x="BTN_SpecB",
								{
									{	text="B",	min_width=CBW,	min_height=CBH,	},
								},
							}
						},
					},
				},
			},
			{
				limit_wide=1,
				{
					label="BTN_Avatar",
					min_width=200,
					min_height=200,
				},
				{
					xalign=0,
					{
						handle_x="BTN_RotY",
						{
							{	text=XLT("Rotate"), },
						},
					}
				},
			},
		},

		{
			limit_wide=1,

			{
				limit_high=1,
				{	button="BTN_ColorSkinGroup",	{	text=XLT("All skin colours"),	},		},
				{	button="BTN_ColorSkin",			color="0xffffffff",		{	text=XLT("Skin"),		},	min_width=CBW,	min_height=CBH,	},	{	button="BTN_AColorSkin",				gfx="flat",		color="0xff000000",	min_width=CBW,	min_height=CBH,	},
				{	button="BTN_ColorNipples",		color="0xffffffff",		{	text=XLT("Nipples"),	},	min_width=CBW,	min_height=CBH,	},	{	button="BTN_AColorNipples",			gfx="flat",		color="0xff000000",	min_width=CBW,	min_height=CBH,	},
				{	button="BTN_ColorLips",			color="0xffffffff",		{	text=XLT("Lips"),		},	min_width=CBW,	min_height=CBH,	},	{	button="BTN_AColorLips",				gfx="flat",		color="0xff000000",	min_width=CBW,	min_height=CBH,	},
			},

			{
				limit_high=1,
				{	button="BTN_ColorHairGroup",	{	text=XLT("All hair colours"),	},		},
				{	button="BTN_ColorHair",			color="0xffffffff",		{	text=XLT("Hair"),		},	min_width=CBW,	min_height=CBH,	},	{	button="BTN_AColorHair",				gfx="flat",	color="0xff000000",	min_width=CBW,	min_height=CBH,	},
				{	button="BTN_ColorHairHi",		color="0xffffffff",		{	text=XLT("Hair High"),	},	min_width=CBW,	min_height=CBH,	},	{	button="BTN_AColorHairHi",			gfx="flat",	color="0xff000000",	min_width=CBW,	min_height=CBH,	},
				{	button="BTN_ColorHairLo",		color="0xffffffff",		{	text=XLT("Hair Low"),	},	min_width=CBW,	min_height=CBH,	},	{	button="BTN_AColorHairLo",			gfx="flat",	color="0xff000000",	min_width=CBW,	min_height=CBH,	},
				{	button="BTN_ColorBeard",		color="0xffffffff",		{	text=XLT("Beard"),		},	min_width=CBW,	min_height=CBH,	},	{	button="BTN_AColorBeard",			gfx="flat",	color="0xff000000",	min_width=CBW,	min_height=CBH,	},
				{	button="BTN_ColorEyebrows",		color="0xffffffff",		{	text=XLT("EyeBrows"),	},	min_width=CBW,	min_height=CBH,	},	{	button="BTN_AColorEyebrows",			gfx="flat",	color="0xff000000",	min_width=CBW,	min_height=CBH,	},
			},

			{
				limit_high=1,
				{	button="BTN_ColorBodyGroup",	{	text=XLT("All body colours"),	},		},
				{	button="BTN_ColorBody",			color="0xffffffff",		{	text=XLT("Body"),		},	min_width=CBW,	min_height=CBH,	},	{	button="BTN_AColorBody",				gfx="flat",	color="0xff000000",	min_width=CBW,	min_height=CBH,	},
				{	button="BTN_ColorBodyHi",		color="0xffffffff",		{	text=XLT("Body High"),	},	min_width=CBW,	min_height=CBH,	},	{	button="BTN_AColorBodyHi",			gfx="flat",	color="0xff000000",	min_width=CBW,	min_height=CBH,	},
				{	button="BTN_ColorBodyLo",		color="0xffffffff",		{	text=XLT("Body Low"),	},	min_width=CBW,	min_height=CBH,	},	{	button="BTN_AColorBodyLo",			gfx="flat",	color="0xff000000",	min_width=CBW,	min_height=CBH,	},
			},

			{
				limit_high=1,
				{	button="BTN_ColorFootGroup",	{	text=XLT("All foot colours"),	},		},	
				{	button="BTN_ColorFoot",			color="0xffffffff",		{	text=XLT("Foot"),		},	min_width=CBW,	min_height=CBH,	},	{	button="BTN_AColorFoot",				gfx="flat",	color="0xff000000",	min_width=CBW,	min_height=CBH,	},
				{	button="BTN_ColorToecaps",		color="0xffffffff",		{	text=XLT("Toecaps"),	},	min_width=CBW,	min_height=CBH,	},	{	button="BTN_AColorToecaps",			gfx="flat",	color="0xff000000",	min_width=CBW,	min_height=CBH,	},
				{	button="BTN_ColorSocks",		color="0xffffffff",		{	text=XLT("Socks"),		},	min_width=CBW,	min_height=CBH,	},	{	button="BTN_AColorSocks",			gfx="flat",	color="0xff000000",	min_width=CBW,	min_height=CBH,	},
				{	button="BTN_ColorSole",			color="0xffffffff",		{	text=XLT("Sole"),		},	min_width=CBW,	min_height=CBH,	},	{	button="BTN_AColorSole",				gfx="flat",	color="0xff000000",	min_width=CBW,	min_height=CBH,	},
			},

			{
				limit_high=1,
				{	button="BTN_ColorEye",			color="0xffffffff",		{	text=XLT("Eye"),		},	min_width=CBW,	min_height=CBH,	},	{	button="BTN_AColorEye",				gfx="flat",	color="0xff000000",	min_width=CBW,	min_height=CBH,	},
				{	button="BTN_ColorIris",			color="0xffffffff",		{	text=XLT("Iris"),		},	min_width=CBW,	min_height=CBH,	},	{	button="BTN_AColorIris",				gfx="flat",	color="0xff000000",	min_width=CBW,	min_height=CBH,	},
				{	button="BTN_ColorSpecs",		color="0xffffffff",		{	text=XLT("Specs"),		},	min_width=CBW,	min_height=CBH,	},	{	button="BTN_AColorSpecs",			gfx="flat",	color="0xff000000",	min_width=CBW,	min_height=CBH,	},
			},
		},
	},
	{
		hide=1,
		label="BTN_LayoutFile",
		limit_wide=1,
		{
			limit_wide=2,
			{
				{
					limit_wide=1,
					{	button="BTN_LoadSoul",		{	text=XLT("Load an avatar soul"),	},	},
					{
						label="BTN_Avatar",
						min_width=200,
						min_height=200,
					},
					{
						xalign=0,
						{
							handle_x="BTN_RotY",
							{
								{	text=XLT("Rotate"), },
							},
						}
					},
					{	button="BTN_SaveSoul",		{	text=XLT("Save an avatar soul"),	},	},
					{	button="BTN_SavePNG",			{	text=XLT("Save viewed pose as .PNG files in all sizes"),	},	},
					{	button="BTN_SaveAnim",			{	text=XLT("Save viewed anim as .PNG files in 100x100"),	},	},
					{	button="BTN_SaveMoods",			{	text=XLT("Save all mood poses as .PNG files of selected size"),	},	},

--					{	button="lua",lua="wavyedit.testrender()",		{	text=XLT("TestRender"),	},	},

					{
						limit_wide=5,
						{	group="xysize",	toggle="BTN_SetSize50x50",		{	text="50 x 50",			},	},
						{	group="xysize",	toggle="BTN_SetSize64x64",		{	text="64 x 64",			},	},
						{	group="xysize",	toggle="BTN_SetSize80x80",		{	text="80 x 80",			},	},
						{	group="xysize",	toggle="BTN_SetSize100x100",	{	text="100 x 100",		},	selected=1,		},
						{	group="xysize",	toggle="BTN_SetSize200x200",	{	text="200 x 200",		},	},
						{	group="xysize",	toggle="BTN_SetSize50x50c",		{	text="50 x 50 "..XLT("face"),	},	},
						{	group="xysize",	toggle="BTN_SetSize64x64c",		{	text="64 x 64 "..XLT("face"),	},	},
						{	group="xysize",	toggle="BTN_SetSize80x80c",		{	text="80 x 80 "..XLT("face"),	},	},
						{	group="xysize",	toggle="BTN_SetSize100x100c",	{	text="100 x 100 "..XLT("face"),	},	},
						{	group="xysize",	toggle="BTN_SetSize200x200c",	{	text="200 x 200 "..XLT("face"),	},	},
						{	group="xysize",	toggle="BTN_SetSize50x50z",		{	text="50 x 50 "..XLT("zoom"),	},	},
						{	group="xysize",	toggle="BTN_SetSize64x64z",		{	text="64 x 64 "..XLT("zoom"),	},	},
						{	group="xysize",	toggle="BTN_SetSize80x80z",		{	text="80 x 80 "..XLT("zoom"),	},	},
						{	group="xysize",	toggle="BTN_SetSize100x100z",	{	text="100 x 100 "..XLT("zoom"),	},	},
						{	group="xysize",	toggle="BTN_SetSize200x200z",	{	text="200 x 200 "..XLT("zoom"),	},	},
					},
				},
			},
		},
	},
}


wavyedit.gizmos.main = hud.alloc():build( wavyedit.tabs.main )


wavyedit.gizmos.main:display()




-- perform a test render

-- I have no idea why everything insists on being upside down by default, but meh I need to rewrite the icky devil stuffs

local function testrender_obj()

for i,nam in ipairs{"arcade","acube","solid_aether_face","column"} do

local ga
local gb
local gt

gb=grd.create("GRD_FMT_U8_BGRA",400,400,1)
	
	for i=1,16 do
	
		ga=grd.create("GRD_FMT_U8_BGRA",400,400,1)
		wavyedit.xoxsnapshot(ga,0.9,math.rad(-5),math.rad( ( (i-1)*(360/16) )+10),math.rad(0),0,-0.9,"onfloor/"..nam)
		ga:scale(100,100,1)

		if i<=4 then
			gb:pixels(1*((i- 1)*100),1*(400-100),1*(100),1*(100),ga:pixels(0,0,1*(100),1*(100)))			
		elseif i<=8 then
			gb:pixels(1*((i- 5)*100),1*(400-200),1*(100),1*(100),ga:pixels(0,0,1*(100),1*(100)))
		elseif i<=12 then
			gb:pixels(1*((i- 9)*100),1*(400-300),1*(100),1*(100),ga:pixels(0,0,1*(100),1*(100)))
		elseif i<=16 then
			gb:pixels(1*((i-13)*100),1*(400-400),1*(100),1*(100),ga:pixels(0,0,1*(100),1*(100)))
		end
		
ga:convert("GRD_FMT_U8_INDEXED")
ga:save( string.format(wet.local_dir..'/rendered/'..nam..'%03d.png',i) )

		ga:destroy()
		
		coroutine.yield()

	end
	
gb:convert("GRD_FMT_U8_INDEXED")
gb:save( wet.local_dir .. '/rendered/'..nam..'.png' )


end

end

local build_avatar = function(name)

local walk_name='cycle_walk'

--local name

if name then -- load avatar

	wavyedit.load_avatar( wet.local_dir .. '/avatar/soul/'..(name or "test")..'.xml' )
	
	if string.sub(name,1,2)=="z." then -- zombiewalk
	
		walk_name='cycle_zeewalk'

	end
	
end


local ga
local gb
local gt


	gb=grd.create("GRD_FMT_U8_BGRA",800,600,1)

--if false then

local walk_len=32/30
local breath_len=64/30

	for i=1,8 do

		ga=grd.create("GRD_FMT_U8_BGRA",400,400,1)
		wavyedit.snapshot(ga,0.9,math.rad(-5),math.rad(-90+10),math.rad(0),0,-0.9,walk_name,1,walk_len*((i-1)/8))
		ga:scale(100,100,1)

		gb:pixels(1*((i-1)*100),1*(600-100),1*(100),1*(100),ga:pixels(0,0,1*(100),1*(100)))

		ga:destroy()

		coroutine.yield()

	end

	for i=1,8 do

		ga=grd.create("GRD_FMT_U8_BGRA",400,400,1)
		wavyedit.snapshot(ga,0.9,math.rad(-5),math.rad(90+10),math.rad(0),0,-0.9,walk_name,1,walk_len*((i-1)/8))
		ga:scale(100,100,1)

		gb:pixels(1*((i-1)*100),1*(600-200),1*(100),1*(100),ga:pixels(0,0,1*(100),1*(100)))

		ga:destroy()

		coroutine.yield()

	end

	for i=1,4 do

		ga=grd.create("GRD_FMT_U8_BGRA",400,400,1)
		wavyedit.snapshot(ga,0.9,math.rad(-5),math.rad(0+10),math.rad(0),0,-0.9,walk_name,1,walk_len*((i-1)/4))
		ga:scale(100,100,1)

		gb:pixels(1*((i-1)*100),1*(600-300),1*(100),1*(100),ga:pixels(0,0,1*(100),1*(100)))

		ga:destroy()

		coroutine.yield()

	end

	for i=1,4 do

		ga=grd.create("GRD_FMT_U8_BGRA",400,400,1)
		wavyedit.snapshot(ga,0.9,math.rad(-5),math.rad(180+10),math.rad(0),0,-0.9,walk_name,1,walk_len*((i-1)/4))
		ga:scale(100,100,1)

		gb:pixels(1*((4+i-1)*100),1*(600-300),1*(100),1*(100),ga:pixels(0,0,1*(100),1*(100)))

		ga:destroy()

		coroutine.yield()

	end

	for i=1,4 do

		ga=grd.create("GRD_FMT_U8_BGRA",400,400,1)
		wavyedit.snapshot(ga,0.9,math.rad(-5),math.rad(0+10),math.rad(0),0,-0.9,'cycle_breath',1,breath_len*((i-1)/6))
		ga:scale(100,100,1)

		gb:pixels(1*((0+i-1)*100),1*(600-400),1*(100),1*(100),ga:pixels(0,0,1*(100),1*(100)))

		ga:destroy()

		coroutine.yield()

	end
	

		ga=grd.create("GRD_FMT_U8_BGRA",400,400,1)
		wavyedit.snapshot(ga,0.9,math.rad(-5),math.rad(-90+10),math.rad(0),0,-0.9,'cycle_breath',1,0)
		ga:scale(100,100,1)

		gb:pixels(1*((5)*100),1*(600-400),1*(100),1*(100),ga:pixels(0,0,1*(100),1*(100)))

		ga:destroy()

		coroutine.yield()
		
		ga=grd.create("GRD_FMT_U8_BGRA",400,400,1)
		wavyedit.snapshot(ga,0.9,math.rad(-5),math.rad(180+10),math.rad(0),0,-0.9,'cycle_breath',1,0)
		ga:scale(100,100,1)

		gb:pixels(1*((6)*100),1*(600-400),1*(100),1*(100),ga:pixels(0,0,1*(100),1*(100)))

		ga:destroy()

		coroutine.yield()
		
		ga=grd.create("GRD_FMT_U8_BGRA",400,400,1)
		wavyedit.snapshot(ga,0.9,math.rad(-5),math.rad(90+10),math.rad(0),0,-0.9,'cycle_breath',1,0)
		ga:scale(100,100,1)

		gb:pixels(1*((7)*100),1*(600-400),1*(100),1*(100),ga:pixels(0,0,1*(100),1*(100)))

		ga:destroy()

		coroutine.yield()
		
	for i,v in ipairs(
{
"anim_splat_to_idle",
--[["pose_bird",
"pose_gunner",
"pose_hands_on_hips",]]
})
	do
		ga=grd.create("GRD_FMT_U8_BGRA",400,400,1)
		wavyedit.snapshot(ga,0.9,math.rad(-5),math.rad(0+10),math.rad(0),0,-0.9, v ,1,0)
		ga:scale(100,100,1)

		gb:pixels(1*((4+i-1)*100),1*(600-400),1*(100),1*(100),ga:pixels(0,0,1*(100),1*(100)))

		ga:destroy()

		coroutine.yield()
	end


	for i,v in ipairs(
{
"pose_teapot",
"pose_angry",
"pose_confused",
"pose_determind",
"pose_devious",
"pose_embarrassed",
"pose_energetic",
"pose_excited",
})
	do
		ga=grd.create("GRD_FMT_U8_BGRA",400,400,1)
		wavyedit.snapshot(ga,0.9,math.rad(-5),math.rad(0+10),math.rad(0),0,-0.9, v ,1,0)
		ga:scale(100,100,1)

		gb:pixels(1*((0+i-1)*100),1*(600-500),1*(100),1*(100),ga:pixels(0,0,1*(100),1*(100)))

		ga:destroy()

		coroutine.yield()
	end

	for i,v in ipairs(
{
"pose_bird",
"pose_indescribable",
"pose_nerdy",
"pose_sad",
"pose_scared",
"pose_sleepy",
"pose_thoughtful",
"pose_working",
})
	do
		ga=grd.create("GRD_FMT_U8_BGRA",400,400,1)
		wavyedit.snapshot(ga,0.9,math.rad(-5),math.rad(0+10),math.rad(0),0,-0.9, v ,1,0)
		ga:scale(100,100,1)

		gb:pixels(1*((0+i-1)*100),1*(600-600),1*(100),1*(100),ga:pixels(0,0,1*(100),1*(100)))

		ga:destroy()

		coroutine.yield()
	end



	gb:convert("GRD_FMT_U8_INDEXED")
	gb:save( wet.local_dir .. '/rendered/'..(name or "test")..'.png' )
	gb:destroy()


	
	

--end

	gb=grd.create("GRD_FMT_U8_BGRA",800,600,1)
	
local swing_len=20/30

	for i=1,4 do

		ga=grd.create("GRD_FMT_U8_BGRA",400,400,1)
		wavyedit.snapshot(ga,0.9,math.rad(-5),math.rad(10-90),math.rad(0),0,-0.9,'anim_swing',1,swing_len*((i-1)/3))
		ga:scale(100,100,1)

		gb:pixels(1*((i-1)*100),1*(600-100),1*(100),1*(100),ga:pixels(0,0,1*(100),1*(100)))

		ga:destroy()

		coroutine.yield()

	end
	
	for i=1,4 do

		ga=grd.create("GRD_FMT_U8_BGRA",400,400,1)
		wavyedit.snapshot(ga,0.9,math.rad(-5),math.rad(10+90),math.rad(0),0,-0.9,'anim_swing',1,swing_len*((i-1)/3))
		ga:scale(100,100,1)

		gb:pixels(1*((4+i-1)*100),1*(600-100),1*(100),1*(100),ga:pixels(0,0,1*(100),1*(100)))

		ga:destroy()

		coroutine.yield()

	end
	
	gb:convert("GRD_FMT_U8_INDEXED")
	gb:save( wet.local_dir .. '/rendered/'..(name or "test")..'.slash.png' )
	gb:destroy()

end



function wavyedit.rt(v)

			build_avatar(v)

local	fp=io.open( wet.local_dir .. '/rendered/'..v..'.xml' , "w" )

		fp:write(			
[[
<?xml version="1.0" encoding="UTF-8"?>

<ville><vtard>

<img type="base" src="http://data.wetgenes.com/game/s/ville/test/vtard/]]..v..[[.png" />

</vtard></ville>
]])
		fp:close()

end

function wavyedit.rts()

--		build_avatar(nil)

	for i,v in ipairs(
{
--[[
"casper",
"zombie",
"haziel",
"zalastus",
'sk8t3r_boy',
'victoria',
'emily',
'default.pirate_punk_chik',
'default.pirate_punk_dude',
'default.bboy',
'default.bgirl',
'default.bunny_chik',
'default.killer_blonde',
'default.lib_killer',
'default.red_head_stabber',
'default.emo_gof_fag',
'default.emo_gof_whore',
'default.vlad',
'default.storm',
'default.mystique',
'default.matrix_chic',
'default.matrix_boy',
'default.joker',
'erik_revolution',

'default.cheer_leader',
'default.clown_boy',
'default.clown_girl',
'default.geek_boy',
'default.geek_girl',
'default.rocker_billy',
'default.rocker_girl',
'batman',
'cyclops09',

'jeeves',
'lieza',
'meatwad',
'moon',
'reg',
'ygor',
'noir',
'666',
'guitardude25',
'spys',
'kolumbo',

'hatsune_miku',
'casper',
'erik_revolution',

'default.brakku',
'default.miku',
'default.failchan',
]]

'z.baldie',
'z.creep',
'z.hippie',
'z.kid',
'z.liz',
'z.maddy',
'z.mary',
'z.nerd',
'z.prof',
'z.rock',
'z.rod',

}) do

		wavyedit.rt(v)
	
	end
	
end


wavyedit.testrender=wavyedit.rts


