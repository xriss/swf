--+-----------------------------------------------------------------------------------------------------------------+--
--
-- (C) Kriss Daniels 2005 http://www.XIXs.com
--
--+-----------------------------------------------------------------------------------------------------------------+--

local num

global.amaze = amaze or {} -- make sure we have a table here


amaze.levels={}


amaze.levels.epitaph=
		XLT("Outwitted by dumb AI?") .. "\n\n" ..
		XLT("Well, I guess you could try again.") .. "\n\n" ..
		XLT("Or if it is all too much for little old you then just skip to the next one.") .. "\n"

num=0
amaze.levels[num] = {}
amaze.levels[num].name = XLT("The Prologue.")
amaze.levels[num].start = function(info)

local item

	item=amaze.alloc_item("director")
	item.name="director"
	item:setmind(amaze.mind_director_basic,"T")
	item.type="director"

	amaze.load_cont_basic("00000_cont.png")
	amaze.load_maze_basic("00000_maze.png")

	amaze.hudtabs.prefab("prologue","prologue",
		XLT("Behold") .. " \"" .. info.name .. "\"\n\n" ..
		XLT("Today we are going to play at being Prometheus.") .. "\n\n" ..
		XLT("Wander the maze and steal all the fire, easy peasy.") .. "\n\n" ..
		XLT("TopTip: Use W A S D or the cursor keys to move.") .. "\n" )

	amaze.hudtabs.prefab("epitaph","epitaph",amaze.levels.epitaph)

	amaze.hudtabs.prefab("epilogue","epilogue",
		XLT("Real easy, huh?") .. "\n\n" ..
		XLT("Although you could try for a faster time.") .. "\n" )
	amaze.next_level=1

end


num=1
amaze.levels[num] = {}
amaze.levels[num].name = XLT("A Spaced Invader.")
amaze.levels[num].start = function(info)

local item

	item=amaze.alloc_item("director")
	item.name="director"
	item:setmind(amaze.mind_director_basic,"T")
	item.type="director"

	amaze.load_cont_basic("00001_cont.png")
	amaze.load_maze_basic("00001_maze.png")

	amaze.hudtabs.prefab("prologue","prologue",
		XLT("Behold") .. " \"" .. info.name .. "\"\n\n" ..
		XLT("This time be carefull not to let the pesky guardians trap you in a corner.") .. "\n\n" ..
		XLT("TopTip: The avatar editor can be used to customize your player character, simply save a wavy avatar soul with the default name of 'me', for it to be used here.") .. "\n" )

	amaze.hudtabs.prefab("epitaph","epitaph",amaze.levels.epitaph)

	amaze.hudtabs.prefab("epilogue","epilogue",
		XLT("Still easy?") .. "\n\n" ..
		XLT("Try playing it again with your eyes shut.")	..  "\n" )
	amaze.next_level=2

end


num=2
amaze.levels[num] = {}
amaze.levels[num].name = XLT("The Time of the Month.")
amaze.levels[num].start = function(info)

local item

	item=amaze.alloc_item("director")
	item.name="director"
	item:setmind(amaze.mind_director_basic,"T")
	item.type="director"

	amaze.load_cont_basic("00002_cont.png")
	amaze.load_maze_basic("00002_maze.png")

	amaze.hudtabs.prefab("prologue","prologue",
		XLT("Behold") .. " \"" .. info.name .. "\"\n\n" ..
		XLT("More fire to steal, more guardians to avoid, lets see how you do this time.") .. "\n\n" ..
		XLT("TopTip: The ESC key can be used to bring up a menu that will let you quickly restart the current level.") .. "\n" )

	amaze.hudtabs.prefab("epitaph","epitaph",amaze.levels.epitaph)

	amaze.hudtabs.prefab("epilogue","epilogue",
		XLT("Well I sure enjoyed that, I know you did too.") .. "\n\n" ..
		XLT("Wouldn't it be fun to play again?")	.. "\n" )
	amaze.next_level=3

end



num=3
amaze.levels[num] = {}
amaze.levels[num].name = XLT("The First Threesum.")
amaze.levels[num].start = function(info)

local item

	item=amaze.alloc_item("director")
	item.name="director"
	item:setmind(amaze.mind_director_basic,"T")
	item.type="director"

	amaze.load_cont_basic("00003_cont.png")
	amaze.load_maze_basic("00003_maze.png")

	amaze.hudtabs.prefab("prologue","prologue",
		XLT("Behold") .. " \"" .. info.name .. "\"\n\n" ..
		XLT("Getting harder.") .. "\n\n" ..
		XLT("But still no deadends so not that hard.") .. "\n\n" ..
		XLT("TopTip: The keys U H J K can be used to rotate the view.") .. "\n" )

	amaze.hudtabs.prefab("epitaph","epitaph",amaze.levels.epitaph)

	amaze.hudtabs.prefab("epilogue","epilogue",
		XLT("Wheeeeee.") .. "\n\n" ..
		XLT("Time to make it a little bit harder")	.. "\n" )
	amaze.next_level=4

end



num=4
amaze.levels[num] = {}
amaze.levels[num].name = XLT("A Simple Valley.")
amaze.levels[num].start = function(info)

local item

	item=amaze.alloc_item("director")
	item.name="director"
	item:setmind(amaze.mind_director_basic,"T")
	item.type="director"

	amaze.load_cont_basic("00004_cont.png")
	amaze.load_maze_basic("00004_maze.png")

	amaze.hudtabs.prefab("prologue","prologue",
		XLT("Behold") .. " \"" .. info.name .. "\"\n\n" ..
		XLT("Looksee, the floor isn't flat.") .. "\n\n" ..
		XLT("Sure it doesnt make much diference now but, soon, it will.") .. "\n\n" ..
		XLT("TopTip: The keys , and . or the mouse wheel can be used to zoom.") .. "\n" )

	amaze.hudtabs.prefab("epitaph","epitaph",amaze.levels.epitaph)

	amaze.hudtabs.prefab("epilogue","epilogue",
		XLT("Not bad, but I think the next level is going to have to be much more difficult.") .. "\n" )
	amaze.next_level=5

end



num=5
amaze.levels[num] = {}
amaze.levels[num].name = XLT("The Forgiven Hump.")
amaze.levels[num].start = function(info)

local item

	item=amaze.alloc_item("director")
	item.name="director"
	item:setmind(amaze.mind_director_basic,"T")
	item.type="director"

	amaze.load_cont_basic("00005_cont.png")
	amaze.load_maze_basic("00005_maze.png")

	amaze.hudtabs.prefab("prologue","prologue",
		XLT("Behold") .. " \"" .. info.name .. "\"\n\n" ..
		XLT("OK, this one might be slightly hard, not impossible, but not easy.") .. "\n" )

	amaze.hudtabs.prefab("epitaph","epitaph",amaze.levels.epitaph)

	amaze.hudtabs.prefab("epilogue","epilogue",
		XLT("Well done, now let's go play with some toys.") .. "\n" )
	amaze.next_level=11

end


num=11
amaze.levels[num] = {}
amaze.levels[num].name = XLT("A Gentle Slope.")
amaze.levels[num].start = function(info)

local item

	item=amaze.alloc_item("director")
	item.name="director"
	item:setmind(amaze.mind_director_basic,"T")
	item.type="director"

	amaze.load_cont_basic("00011_cont.png")
	amaze.load_maze_basic("00011_maze.png")

	amaze.hudtabs.prefab("prologue","prologue",
		XLT("Behold") .. " \"" .. info.name .. "\"\n\n" ..
		XLT("Some simple toys, push them down the hill.") .. "\n\n" ..
		XLT("Press Escape for restart option if you get stuck.") .. "\n" )

	amaze.hudtabs.prefab("epitaph","epitaph",amaze.levels.epitaph)

	amaze.hudtabs.prefab("epilogue","epilogue",
		XLT("Congratulations, now for something even simpler.") .. "\n" )
	amaze.next_level=12

end

num=12
amaze.levels[num] = {}
amaze.levels[num].name = XLT("A Simple Push.")
amaze.levels[num].start = function(info)

local item

	item=amaze.alloc_item("director")
	item.name="director"
	item:setmind(amaze.mind_director_basic,"T")
	item.type="director"

	amaze.load_cont_basic("00012_cont.png")
	amaze.load_maze_basic("00012_maze.png")

	amaze.hudtabs.prefab("prologue","prologue",
		XLT("Behold") .. " \"" .. info.name .. "\"\n\n" ..
		XLT("You should really try not to cover up anything you want to collect.") .. "\n" )

	amaze.hudtabs.prefab("epitaph","epitaph",amaze.levels.epitaph)

	amaze.hudtabs.prefab("epilogue","epilogue",
		XLT("To easy? Well it wasn't much of a puzzle, more of a test for brain activity.") .. "\n" )
	amaze.next_level=13

end

num=13
amaze.levels[num] = {}
amaze.levels[num].name = XLT("Not as hard as it looks.")
amaze.levels[num].start = function(info)

local item

	item=amaze.alloc_item("director")
	item.name="director"
	item:setmind(amaze.mind_director_basic,"T")
	item.type="director"

	amaze.load_cont_basic("00013_cont.png")
	amaze.load_maze_basic("00013_maze.png")

	amaze.hudtabs.prefab("prologue","prologue",
		XLT("Behold") .. " \"" .. info.name .. "\"\n\n" ..
		XLT("Again, just don't cover anything up and you will be fine.") .. "\n" )

	amaze.hudtabs.prefab("epitaph","epitaph",amaze.levels.epitaph)

	amaze.hudtabs.prefab("epilogue","epilogue",
		XLT("See, told you it was simple.") .. "\n" )
	amaze.next_level=14

end

num=14
amaze.levels[num] = {}
amaze.levels[num].name = XLT("A Question of Timing.")
amaze.levels[num].start = function(info)

local item

	item=amaze.alloc_item("director")
	item.name="director"
	item:setmind(amaze.mind_director_basic,"T")
	item.type="director"

	amaze.load_cont_basic("00014_cont.png")
	amaze.load_maze_basic("00014_maze.png")

	amaze.hudtabs.prefab("prologue","prologue",
		XLT("Behold") .. " \"" .. info.name .. "\"\n\n" ..
		XLT("Remember the antagonists are dumb, controlable and predictable.") .. "\n" ..
		XLT("Just keep trying till you out smart them.") .. "\n" )

	amaze.hudtabs.prefab("epitaph","epitaph",amaze.levels.epitaph)

	amaze.hudtabs.prefab("epilogue","epilogue",
		XLT("Congratulations, I bet that took a few trys.") .. "\n" )
	amaze.next_level=15

end

num=15
amaze.levels[num] = {}
amaze.levels[num].name = XLT("The Square Peg.")
amaze.levels[num].start = function(info)

local item

	item=amaze.alloc_item("director")
	item.name="director"
	item:setmind(amaze.mind_director_basic,"T")
	item.type="director"

	amaze.load_cont_basic("00015_cont.png")
	amaze.load_maze_basic("00015_maze.png")

	amaze.hudtabs.prefab("prologue","prologue",
		XLT("Behold") .. " \"" .. info.name .. "\"\n\n" ..
		XLT("The best tactic is simply to start by trapping the antagonists..") .. "\n" )

	amaze.hudtabs.prefab("epitaph","epitaph",amaze.levels.epitaph)

	amaze.hudtabs.prefab("epilogue","epilogue",
		XLT("Now I know you are not going to belive this and will probably consider it nothing more than a cheap trick to get you into a position where I can take advantage of you.") .. "\n" .. 
		XLT("But it turns out our princess is in another castle.") .. "\n" )
	amaze.next_level=0

end


amaze.levels.n=num
