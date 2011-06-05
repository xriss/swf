--+-----------------------------------------------------------------------------------------------------------------+--
--
-- (C) Kriss Daniels 2005 http://www.XIXs.com
--
--+-----------------------------------------------------------------------------------------------------------------+--


print( "menu:1")

menu.tabs={}

print( "menu:1a")

menu.gizmos={}

print( "menu:1b")

-- function call backs
menu.func={}


print( "menu:1c")

--
-- build some general menu structures to be used in all states if necesary
--


menu.colors={

	red				='0xffff0000',
	green			='0xff00ff00',

	button_blue		='0xcc7777cc',
	button_red		='0xcccc7777',
	button_green	='0xcc77bb77',
	button_yellow	='0xcc999966',
}

print( "menu:1d")

--
-- return a table to initalise a simple menu item
--
menu.create_menu_item = function(idstr,luastr,namestr)

local ret

	ret=
	{
		button=idstr,
		lua=luastr,
		{
			text=namestr, -- pretranslated
 		},
	}

	return ret;
end


print( "menu:1e")

--
-- basic pause menu with quit option
--

menu.tabs.pause =
{
	limit_wide=1,
	{	min_height=200,		},
	{	button="MENU_Continue",				{	text=XLT("Continue"),				},	},
	{	button="MENU_Restart",				{	text=XLT("Restart"),					},	},
	{	button="MENU_MainMenu",				{	text=XLT("Quit to menu"),		},	},
	{	min_height=200,		},
}


menu.gizmos.pause = hud.alloc():build( menu.tabs.pause )



-- load in level amaze basic info

dofile( wet.local_dir .. "amaze/basic/levels.lua")

local amaze=amaze


-- then build table from the info


function menu.build_amaze_basic_levels()

local t={}
local ti

	t.label="MENU_LayoutAmazeBasic"
	t.hide=1
	t.limit_wide=1

	ti=1

	t[ti]={ min_height=16 }
	ti=ti+1

	t[ti]={	text=XLT("Select level from basic set.") }
	ti=ti+1

	for i=0,amaze.levels.n do

	local v

		if i==0 then

			t[ti]={	text=XLT("Part 1 : Introducing the amazing maze.") }
			ti=ti+1

			t[ti]={	limit_high=1,{limit_wide=1},{limit_wide=1},{limit_wide=1},{limit_wide=1} }
			ti=ti+1


		elseif i==10 then

			t[ti]={	text=XLT("Part 2 : Introducing the art of pushing.") }
			ti=ti+1

			t[ti]={	limit_high=1,{limit_wide=1},{limit_wide=1},{limit_wide=1},{limit_wide=1} }
			ti=ti+1

		end

		v=amaze.levels[i]

		if v then -- we have a level in this slot
			
--			{	text="Level "..i , min_width=100 , max_width=100 },

			table.insert(t[ti-1][1],
				{
					text=string.format('%05d',i)
				}
			)

			table.insert(t[ti-1][2],
				{
					button="lua",
					lua="menu.goto_amaze_basic("..i..")",
					{
						text=v.name
					}
				}
			)

			do
			local info=wet['amaze']
			local name_level=string.format('%05d',i)
			local list

				list = xtra.dir(wet.local_dir..'replay/'..info.name_str..'_'..info.version_str..'/basic/'..name_level..'/'..'*.xml')

				if list[1] then

					table.insert(t[ti-1][3],
						{
							text=':)',
							color=menu.colors.green,
						}
					)

				else

					table.insert(t[ti-1][3],
						{
							text=':(',
							color=menu.colors.red,
						}
					)

				end

				table.insert(t[ti-1][4],
					{
						button="lua",
						lua="menu.goto_amaze_basic_scores("..i..",1)",
						{
							text=XLT("Scores.")
						}
					}
				)

			end


			
--			print( v.name )

		end

	end

	t[ti]={ min_height=16 }
	ti=ti+1

	t[ti]={	button="lua",lua='menu.goto_main_menu()',				{	text=XLT("Back to main menu"),			},	}
	ti=ti+1

	t[ti]={ min_height=16 }

	return t

end


-- function to start a level

function menu.goto_amaze_basic(num,replay_name)

	if replay_name then

		journal.last=journal.load_journal(replay_name)
		journal.replay=journal.last

	end

	opt.next_level("basic")

	opt.next_number(num)

	opt.next_state("main_state_amaze")

end


function menu.goto_wavy_editor()

	opt.next_state("main_state_bud_test")

end

function menu.goto_main_menu()

	menu.setmenu(menu.gizmos.main)
	menu.update=null

end

function menu.goto_structor_basic(num)

	opt.next_level("basic")

	opt.next_number(num)

	opt.next_state("main_state_structor")

	menu.update=null

end

-- function to jump to a scores page for a given amaze level

function menu.goto_amaze_basic_scores(num,rank)


	if		rank < 1 then -- back to select menu

		menu.goto_amaze_basic_levels()

	else

		menu.update=function()
			menu.gizmos.scores=hud.alloc():build( menu.build_amaze_score_tab("basic",num,rank) )
			menu.setmenu(menu.gizmos.scores)
		end
		menu.update()

	end
	
end

function menu.goto_amaze_basic_levels()

	menu.update=function()
		menu.gizmos.amaze_basic_levels = hud.alloc():build( menu.build_amaze_basic_levels() )
		menu.setmenu(menu.gizmos.amaze_basic_levels)
	end
	menu.update()

end


function menu.set_lang(id,alt)

	opt.lang(id)
	opt.lang_alt(alt)

	opt.next_level("basic")
	opt.next_number(0)
	opt.next_state("main_state_menu")

	xlate.reset()

-- need to reload ourselves so we get translated again
-- other lua files should be loaded on state change so this fixes up most translations

	dofile(wet.lua_dir.."wet/menu.lua")	
end



menu.build_amaze_score_tab=function(name_set,level,rank)

local info=wet['amaze']

local tab
local v
local t
local s

local name_level=string.format('%05d',level)


	v=amaze.levels[level]

	s=journal.get_scores(wet.local_dir..'replay/'..info.name_str..'_'..info.version_str..'/'..name_set..'/'..name_level..'/')

	if		rank > table.getn(s) then

		return menu.build_amaze_score_tab(name_set,level,rank-10)

	end

	tab=
		{
			limit_wide=1,
		}
	
	table.insert(tab,
		{
			 min_height=16
		}
	)
	
	table.insert(tab,
		{
			 text=string.gsub(XLT("Scores for level _LEVEL_."),'_LEVEL_',name_level)
		}
	)
	table.insert(tab,
		{
			button="lua",
			lua="menu.goto_amaze_basic("..level..")",
			{
				text=v.name
			}
		}
	)
		
	table.insert(tab,
		{
			limit_high=1,
			{
				limit_wide=1,
				{
					text=XLT("Rank.")
				}
			}
			,
			{
				limit_wide=1,
				{
					text=XLT("Time.")
				}
			}
			,
			{
				limit_wide=1,
				{
					text=XLT("Name.")
				}
			}
			,
			{
				limit_wide=1,
				{
					text=XLT("When.")
				}
			}
			,
			{
				limit_wide=1,
				{
					text=' '
				}
			}
		}
	)
	t=tab[table.getn(tab)]


	for i=rank,rank+9 do

	local v=s[i]

		if v then

			table.insert(t[1],
				{
						text=string.format('%d',i)
				}
			)

			table.insert(t[2],
				{
						text=v.time
				}
			)

			table.insert(t[3],
				{
						text=v.owner
				}
			)

			table.insert(t[4],
				{
						text=v.timestamp
				}
			)

			table.insert(t[5],
				{
					button="lua",
					lua="menu.func["..(i+1-rank).."]()",
					{
						text=XLT("View.")
					}
				}
			)

			local a,b,c=menu.goto_amaze_basic,level,v.filename
			menu.func[i+1-rank]=function() a(b,c) end


		else -- make dummys for layout

			for i=1,5 do

				table.insert(t[i],
					{
							text=' '
					}
				)
			end

		end

	end

	table.insert(tab,
		{
			 min_height=16
		}
	)

	table.insert(tab,
		{
			limit_high=1,
			{
				button="lua",
				lua="menu.goto_amaze_basic_scores("..level..","..(rank-10)..")",
				{
					text=XLT("Back.")
				}
			}
			,
			{
				button="lua",
				lua="menu.goto_amaze_basic_scores("..level..","..(rank+10)..")",
				{
					text=XLT("Next.")
				}
			}
		}
	)

	table.insert(tab,
		{
			 min_height=16
		}
	)

	return tab

end

print( "menu:2")


--
-- Main menu and sub menus
--

menu.tabs.main =
{
	{
		label="MENU_LayoutMain",
		hide=0,
		limit_wide=1,
		{	min_height=200,		},
		{	button="MENU_Lang",															{	text=XLT("Choose Language"),			},	},
		{	button="lua",	lua='menu.goto_wavy_editor()',								{	text=XLT("Edit Avatars"),				},	},
		{	button="lua",	lua='menu.goto_amaze_basic_levels()',						{	text=XLT("Play Amaze"),					},	},
		{	button="MENU_Options",														{	text=XLT("Change Options"),				},	},
		{	button="lua",	lua="menu.goto_structor_basic(1)",							{	text=XLT("Test Water"),					},	},
		{	button="MENU_Quit",															{	text=XLT("Quit"),						},	},
		{	min_height=200,		},
	},
	{
		label="MENU_LayoutOptions",
		hide=1,
		limit_wide=1,
		{	min_height=200,		},
		{	button="MENU_MainMenu",				{	text=XLT("Back to main menu"),			},	},
		{
			limit_high=1,
			{	group="options",	target="MENU_LayoutOptionSFX",	toggle="MENU_SelectOptionSFX",		{	text=XLT("Audio"),		},	 },
			{	group="options",	target="MENU_LayoutOptionGFX",	toggle="MENU_SelectOptionGFX",		{	text=XLT("Visual"),		},	selected=1, },
			{	group="options",	target="MENU_LayoutOptionDBG",	toggle="MENU_SelectOptionDBG",		{	text=XLT("Debug"),		},	 },
		},
		{
			label="MENU_LayoutOptionSFX",
			hide=1,
			limit_wide=1,
			{
				limit_high=1,
				{	group="sfx",		button="MENU_SetOpt",		lua="opt.sfx_enabled(true)",		selected=(opt.sfx_enabled()==true),		{	text=XLT("Sound on"),			},	},
				{	group="sfx",		button="MENU_SetOpt",		lua="opt.sfx_enabled(false)",		selected=(opt.sfx_enabled()==false),	{	text=XLT("Sound off"),			},	},
			},
			{
				limit_high=1,
				{	text=XLT("Music volume"), min_width=300			},
				{	group="sfx_mzk",		button="MENU_SetOpt",		lua="opt.sfx_background_volume(0.00)",	selected=(opt.sfx_background_volume()==0.00),		{	text=XLT("Off"), 			},	min_width=100},
				{	group="sfx_mzk",		button="MENU_SetOpt",		lua="opt.sfx_background_volume(0.25)",	selected=(opt.sfx_background_volume()==0.25),		{	text=XLT("25%"), 			},	min_width=100},
				{	group="sfx_mzk",		button="MENU_SetOpt",		lua="opt.sfx_background_volume(0.50)",	selected=(opt.sfx_background_volume()==0.50),		{	text=XLT("50%"), 			},	min_width=100},
				{	group="sfx_mzk",		button="MENU_SetOpt",		lua="opt.sfx_background_volume(0.75)",	selected=(opt.sfx_background_volume()==0.75),		{	text=XLT("75%"), 			},	min_width=100},
				{	group="sfx_mzk",		button="MENU_SetOpt",		lua="opt.sfx_background_volume(1.00)",	selected=(opt.sfx_background_volume()==1.00),		{	text=XLT("100%"), 		},	min_width=100},
			},
			{
				limit_high=1,
				{	text=XLT("Effects volume"), min_width=300			},
				{	group="sfx_sfx",		button="MENU_SetOpt",		lua="opt.sfx_foreground_volume(0.00)",	selected=(opt.sfx_foreground_volume()==0.00),		{	text=XLT("Off"), 			},	min_width=100},
				{	group="sfx_sfx",		button="MENU_SetOpt",		lua="opt.sfx_foreground_volume(0.25)",	selected=(opt.sfx_foreground_volume()==0.25),		{	text=XLT("25%"), 			},	min_width=100},
				{	group="sfx_sfx",		button="MENU_SetOpt",		lua="opt.sfx_foreground_volume(0.50)",	selected=(opt.sfx_foreground_volume()==0.50),		{	text=XLT("50%"), 			},	min_width=100},
				{	group="sfx_sfx",		button="MENU_SetOpt",		lua="opt.sfx_foreground_volume(0.75)",	selected=(opt.sfx_foreground_volume()==0.75),		{	text=XLT("75%"), 			},	min_width=100},
				{	group="sfx_sfx",		button="MENU_SetOpt",		lua="opt.sfx_foreground_volume(1.00)",	selected=(opt.sfx_foreground_volume()==1.00),		{	text=XLT("100%"), 			},	min_width=100},
			},
		},
		{
			label="MENU_LayoutOptionGFX",
			hide=0,
			limit_wide=1,
			{
				limit_high=1,
				{	text=XLT("Startup settings.")		},
				{
					limit_wide=1,
					{
						limit_high=1,
						{	group="gfx.window_startup",		button="MENU_SetOpt",		lua="opt.window_startup(\"normal\")",		selected=(opt.window_startup()=="normal"),			{	text=XLT("Window normal"),		},	},
						{	group="gfx.window_startup",		button="MENU_SetOpt",		lua="opt.window_startup(\"maximised\")",	selected=(opt.window_startup()=="maximised"),		{	text=XLT("Window maximised"),	},	},
						{	group="gfx.window_startup",		button="MENU_SetOpt",		lua="opt.window_startup(\"fullscreen\")",	selected=(opt.window_startup()=="fullscreen"),		{	text=XLT("Fullscreen"),	},	},
					},
					{
						limit_high=1,
						{	group="gfx.window_size",		button="MENU_SetOpt",		lua="opt.window_width(800);opt.window_height(600)",		selected=(opt.window_width()==800),		{	text=XLT("800x600"),	},	},
						{	group="gfx.window_size",		button="MENU_SetOpt",		lua="opt.window_width(1024);opt.window_height(768)",	selected=(opt.window_width()==1024),	{	text=XLT("1024x768"),	},	},
						{	group="gfx.window_size",		button="MENU_SetOpt",		lua="opt.window_width(1280);opt.window_height(960)",	selected=(opt.window_width()==1280),	{	text=XLT("1280x960"),	},	},
						{	group="gfx.window_size",		button="MENU_SetOpt",		lua="opt.window_width(1600);opt.window_height(1200)",	selected=(opt.window_width()==1600),	{	text=XLT("1600x1200"),	},	},
					},
				},
			},
		},
		{
			label="MENU_LayoutOptionDBG",
			hide=1,
			limit_wide=1,
			{
				limit_high=1,
				{	group="opt.show_debug",		button="MENU_SetOpt",		lua="opt.show_debug(true)",		selected=(opt.show_debug()==true),			{	text=XLT("Debug ON"),		},	},
				{	group="opt.show_debug",		button="MENU_SetOpt",		lua="opt.show_debug(false)",	selected=(opt.show_debug()==false),			{	text=XLT("Debug OFF"),		},	},
			},
		},
		{	min_height=200,		},
	},
	{
		label="MENU_LayoutLang",
		hide=1,
		limit_wide=1,
		{	min_height=200,		},
		{										{	text=XLT("You may need to restart for this to take full effect."),			},	},
		{	button="MENU_MainMenu",				{	text=XLT("Back to main menu"),			},	},
		{	group="opt.lang",		button="MENU_SetOptLang",		lua="menu.set_lang('EN-UK','EN')",		selected=(opt.lang()=='EN-UK'),		{	text="English",		},	},
		{	group="opt.lang",		button="MENU_SetOptLang",		lua="menu.set_lang('DE','EN')",			selected=(opt.lang()=='DE'),		{	text="Deutsch",		},	},
		{	group="opt.lang",		button="MENU_SetOptLang",		lua="menu.set_lang('FR','EN')",			selected=(opt.lang()=='FR'),		{	text="French",		},	},
--		{	group="opt.lang",		button="MENU_SetOptLang",		lua="menu.set_lang('GR','EN')",			selected=(opt.lang()=='GR'),		{	text="Greek",		},	},
		{	group="opt.lang",		button="MENU_SetOptLang",		lua="menu.set_lang('IT','EN')",			selected=(opt.lang()=='IT'),		{	text="Italian",		},	},
		{	group="opt.lang",		button="MENU_SetOptLang",		lua="menu.set_lang('PT','EN')",			selected=(opt.lang()=='PT'),		{	text="Portuguese",	},	},
--		{	group="opt.lang",		button="MENU_SetOptLang",		lua="menu.set_lang('RU','EN')",			selected=(opt.lang()=='RU'),		{	text="Cyrillic",	},	},
		{	group="opt.lang",		button="MENU_SetOptLang",		lua="menu.set_lang('ES','EN')",			selected=(opt.lang()=='ES'),		{	text="Spanish",		},	},
		{	min_height=200,		},
	},
}

print( "menu:3")

menu.gizmos.main = hud.alloc():build( menu.tabs.main )


menu.setmenu=function(m)
	menu.state=m
	m:mastermenu()
end

print( "menu:4")

menu.refresh=function()

	if menu.update then

		menu.update()

	else

		menu.state:mastermenu()

	end

end

print( "menu:5")

menu.setmenu(menu.gizmos.main)



print( "menu:6")
