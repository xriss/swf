--+-----------------------------------------------------------------------------------------------------------------+--
--
-- (C) Kriss Daniels 2005 http://www.XIXs.com
--
--+-----------------------------------------------------------------------------------------------------------------+--


--
-- cache some values for speed and readability
--
local game			=	structor				-- main state cache
local game_name		=	"structor"

local items			=	structor_items			-- item generator








--
-- create some menu pieces,
--

game.menu={}		--	a place to keep state information

game.vars={}		--	some settings
local vars=game.vars

--vars.snap_x=16
--vars.snap_y=16

opt.grd_x(0)
opt.grd_y(0)
opt.grd_w(16)
opt.grd_h(16)



game.menu_checks={}		--	callhook to update the display state
game.menu_actions={}	--	callhook on use
game.menu_items={}
game.menu_builds={}
game.menus={}
game.hooks={}

game.menu_check=function(id) game.menu_checks[id](id) end		-- check lookup and call stub
game.menu_action=function(id) game.menu_actions[id](id) end		-- action lookup and call stub

game.menu_actions.null=function(id) print(id) end				-- null action function
game.menu_checks.null=function() end							-- null check function
game.hooks.null=function() end									-- null hook function


--
-- default snaping
--
game.hooks.snap=function(x,y)

	local w,h=opt.grd_w(),opt.grd_h()
	
	return math.floor(x/w+0.5)*w , math.floor(y/h+0.5)*h

end
--
-- tick edit control, called every edit frame
--
game.hooks.edit_tick=coroutine.wrap(function()

	repeat

		coroutine.yield()

	until false
	

end)


game.create_menu_item=function(id,txt)

	id=tostring(id)

	game.menu_items[id] = menu.create_menu_item(id,	game_name..".menu_action('"..id.."')"	,txt)

	game.menu_actions[id] = game.menu_actions.null
	game.menu_checks[id] = game.menu_checks.null

	return game.menu_items[id]

end

game.delete_menu_item=function(id)

	id=tostring(id)

	game.menu_items[id] = null
	game.menu_actions[id] = null
	game.menu_checks[id] = null

end


game.create_menu_item(	"play"				,	XLT("Play.")	)
game.create_menu_item(	"stop"				,	XLT("Stop.")	)
game.create_menu_item(	"reset"				,	XLT("Reset.")	)

game.menu_actions.play	=function(id) game.pause_request(false) end
game.menu_actions.stop	=function(id) game.pause_request(true) end
game.menu_actions.reset	=function(id) game.reset_request(true) end


game.create_menu_item(	"edit"				,	XLT("Edit.")	)
game.create_menu_item(	"start"				,	XLT("Start.")	)
game.create_menu_item(	"brush_edit"		,	XLT("Edit Brush.")	)
game.create_menu_item(	"map_edit"			,	XLT("Edit Map.")	)
game.create_menu_item(	"links_edit"		,	XLT("Edit Links.")	)
game.create_menu_item(	"map_add"			,	XLT("Add Item.")	)
game.create_menu_item(	"brush_select"		,	XLT("Select Brush.")	)
game.create_menu_item(	"brush_add"			,	XLT("Add Brush.")	)
game.create_menu_item(	"ball_add"			,	XLT("Add Ball.")	)
game.create_menu_item(	"zone_add"			,	XLT("Add Zone.")	)


game.menu_actions.edit	=function(id)

	game.pause_request(true)
	game.reset_request(true)
	game.edit_request(true)
	game.edit_state("map")
	game.rebuildcells_request(true)
	game.menus.map_edit:display("old")

end

game.menu_actions.start	=function(id)

	game.pause_request(false)
	game.reset_request(true)
	game.edit_request(false)
	game.menus.main:display("old")
	
end

game.menu_actions.brush_edit	=function(id)

local brush
local items_tab=items.get('selected',{})

	game.edit_state("brush")
	game.menus.brush_edit:display("old")

	for i,v in ipairs(items_tab) do -- get first selected brush

		if v.type=="brush" then

			brush=v
			break
		end

	end

	if brush==null then

		items_tab=items.get('all',items_tab)

		for i,v in ipairs(items_tab) do -- get first selected brush

			if v.type=="brush" then

				brush=v
				break
			end

		end

	end

	if brush then

		brush.set_focus()

	else

		items.clr_focus()

	end

end

game.menu_actions.map_edit	=function(id)

	game.edit_state("map")
	game.menus.map_edit:display("old")

	items.clr_focus()
	
end

game.menu_actions.brush_select	=function(id)

	game.menus.list_brushes=game.menu_builds.list_brushes_build()
	game.menus.list_brushes:display("old")
	
end


game.menu_actions.map_add	=function(id)

	game.menus.map_add:display("old")
	
end

game.menu_actions.ball_add	=function(id)

local item

	item=items.alloc("aball")
	item.setpos(0,0)
	item.setsiz(32)
	item.setinitial()
	
	game.rebuildcells_request(true)

end




game.create_menu_item(	"click_mode"		,	XLT("Click mode...")	)

game.menu_actions.click_mode	=function(id)

	game.menus.click_mode:context(2)

end



game.create_menu_item(	"click_mode_off"	,	XLT("Select.")		)
game.create_menu_item(	"click_mode_move"	,	XLT("Move.")	)

game.menu_actions.click_mode_off	=function(id) game.menu.click_mode=null end
game.menu_actions.click_mode_move	=function(id) game.menu.click_mode='move' end

game.menu_actions.click_mode_move()



-- mouse overload action functions, only called when in edit state, should bring up and remove context menus
do

local level=0

	game.menu_actions.mouse_menu_on		=function(id)

		game.menus.item_context:context(1)

	end

	game.menu_actions.mouse_menu_off	=function(id)

		game.menus.item_context:context(0)

	end

end


-- mouse overload action functions, only called when in edit state,
-- mouse_click_state will get called repeatedly

do

local cx,cy
local x,y
local sel={}

	game.menu_actions.mouse_click_on	=function(id)

		cx,cy=game.pointer()

		sel=items.get('selected',{})

	end

	game.menu_actions.mouse_click_state	=function(id)

		x,y=game.pointer()

		if( game.menu.click_mode=='move' ) then

		local tx,ty

			for i,v in ipairs(sel) do

				tx,ty=v.initialpos()

				tx,ty=tx+x-cx,ty+y-cy	-- build dest pos
				tx,ty=game.hooks.snap(tx,ty)

				v.setpos(tx,ty)

			end

		end

	end

	game.menu_actions.mouse_click_off	=function(id)

		if( game.menu.click_mode=='move' ) then

			for i,v in ipairs(sel) do

				v.setinitial()

			end

			game.rebuildcells_request(true)

		end

	end

end





game.menus.main=hud.alloc():build(
{
	xalign=0,
	yalign=0,
	{
		handle="BTN_Window",
		{
		limit_wide=1,
			{ text=XLT("Main tool box.") },
			game.menu_items.play,
			game.menu_items.stop,
			game.menu_items.reset,
			game.menu_items.edit,
		}
	}
})

game.menus.map_edit=hud.alloc():build(
{
	xalign=0,
	yalign=0,
	{
		handle="BTN_Window",
		{
		limit_wide=1,
			{ text=XLT("Map edit tool box.") },
			game.menu_items.start,
			game.menu_items.map_add,
			game.menu_items.brush_edit,
		}
	}
})

game.menus.map_add=hud.alloc():build(
{
	xalign=0,
	yalign=0,
	{
		handle="BTN_Window",
		{
		limit_wide=1,
			{ text=XLT("Map add tool box.") },
			game.menu_items.map_edit,
			game.menu_items.ball_add,
			game.menu_items.brush_add,
		}
	}
})

game.menus.brush_edit=hud.alloc():build(
{
	xalign=0,
	yalign=0,
	{
		handle="BTN_Window",
		{
		limit_wide=1,
			{ text=XLT("Brush edit tool box.") },
			game.menu_items.map_edit,
			game.menu_items.brush_select,
		}
	}
})

game.menus.item_context=hud.alloc():build(
{
	xalign=0,
	yalign=0,
	{
		handle="BTN_Window",
		{
		limit_wide=1,
			game.menu_items.click_mode,
		}
	}
})

game.menus.click_mode=hud.alloc():build(
{
	xalign=0,
	yalign=0,
	{
		handle="BTN_Window",
		{
		limit_wide=1,
			game.menu_items.click_mode_off,
			game.menu_items.click_mode_move,
		}
	}
})

do
local brush_tab


	game.menu_builds.list_brushes_build=function()

	local menu_tab={}
	local items_tab=items.get('all',{})
	local tab

		if brush_tab then -- clean old list items

			for i,v in ipairs(brush_tab) do

				game.delete_menu_item(v)

			end

		end

		brush_tab={n=0}

		for i,v in ipairs(items_tab) do -- get only brush types

			if v.type=="brush" then

				table.insert(brush_tab,v)

			end

		end

-- need to remove dupes...



		menu_tab.limit_wide=1
		table.insert(menu_tab,{ text=XLT("Select brush.") })

		for i=1,#brush_tab,10 do -- break into pages of 10
		local v

			for i=i,i+9 do

				v=brush_tab[i]

				if v~=null then
					tab=game.create_menu_item(v,v.name)
					table.insert(menu_tab,tab);


					do
					local v=v
						game.menu_actions[tostring(v)]=function(id)
							v.set_focus()
							game.menus.brush_edit:display("old")
						end
					end

				else
					table.insert(menu_tab,{ button="",{text=""} });
				end


			end
		end


	return hud.alloc():build(
	{
		xalign=0,
		yalign=0,
		{
			handle="BTN_Window",
			menu_tab
		}
	})

	end

end

game.menus.main:display("center")



--t=txts.alloc( tdata.dir_data() .. "cuts/test.png" )

--sitem=structor_items.alloc("aball")
--sitem2=structor_items.alloc("aball")


-- this needs to be converted to an xml load/save section but in can live like this as a test for the now

local item

	item=items.alloc("aball")
	item.setpos(-64,-128)
	item.setsiz(16)
	item.setinitial()

	item=items.alloc("aball")
	item.setpos(-128,-128)
	item.setsiz(32)
	item.setinitial()

	item=items.alloc("aball")
	item.setpos(-192,-128)
	item.setsiz(48)
	item.setinitial()



	item=items.alloc("cells") -- fake cells item for draw order sorting


	item=items.alloc("brush")
	item.name="cuts/shi/fag_lipstick.xml"
	item.setpos(-256,64)
	item.setsiz(128)
	item.setcmp( cmps.alloc(wet.local_dir .. item.name ).steal_ptr() )
	item.setinitial()

	item=items.alloc("brush")
	item.name="cuts/shi/fruit_strawberry.xml"
	item.setpos(-128,64)
	item.setsiz(128)
	item.setcmp( cmps.alloc(wet.local_dir .. item.name ).steal_ptr() )
	item.setinitial()

	item=items.alloc("brush")
	item.name="cuts/shi/heart_eatme.xml"
	item.setpos(0,64)
	item.setsiz(128)
	item.setcmp( cmps.alloc(wet.local_dir .. item.name ).steal_ptr() )
	item.setinitial()

	item=items.alloc("brush")
	item.name="cuts/shi/lolly_ice.xml"
	item.setpos(128,64)
	item.setsiz(128)
	item.setcmp( cmps.alloc(wet.local_dir .. item.name ).steal_ptr() )
	item.setinitial()

	item=items.alloc("brush")
	item.name="cuts/shi/lolly_pop.xml"
	item.setpos(256,64)
	item.setsiz(128)
	item.setcmp( cmps.alloc(wet.local_dir .. item.name ).steal_ptr() )
	item.setinitial()

	item=items.alloc("brush")
	item.name="cuts/shi/sushi_fish.xml"
	item.setpos(-128,-64)
	item.setsiz(128)
	item.setcmp( cmps.alloc(wet.local_dir .. item.name ).steal_ptr() )
	item.setinitial()

	item=items.alloc("brush")
	item.name="cuts/shi/taco_devil.xml"
	item.setpos(128,-64)
	item.setsiz(128)
	item.setcmp( cmps.alloc(wet.local_dir .. item.name ).steal_ptr() )
	item.setinitial()


	game.rebuildcells_request(true)


	local items_tab=items.get('all',{})

	for i,v in ipairs(items_tab) do -- get only brush types

	local	x,y=v.initialpos()
	local	w,h=v.initialsiz()
		print ( v.type , v.name , x,y , w,h )

	end




------------------------------------------------------------------------
--
-- load in more files
--
------------------------------------------------------------------------

--dofile( structor.dir_local() .. "structor_basic.lua")