-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------



-- Importing foreign scripts
local composer = require( "composer" )
local widget = require "widget"
local scene = composer.newScene()

-- These must only be called once throughout all sheets, or multiple instances of classes will be called!
clouds = require("clouds")
stages = require("stages")

queuedFunction = nil
--global runtime for when move has been initialised

--------------------------------------------
-- local declarations for constants based on screen size

basicMusic = audio.loadSound("audio/music/basic music.mp3")

-- Touch handler
local function onSystemTouch(event)
	if stages.gameStarted == true then
		if stages.gameOver == false then
			if event.phase == "began" then
				if gameMode == "classic" or gameMode == "mm" then
					if event.x > SCRORIX + SCRW/2 then
						if stages.playerLane < stages.totalLanes then
							-- print("Moving right")
							stages.playerLane = stages.playerLane + 1
						end
					elseif event.x < SCRORIX + SCRW/2 then
						if stages.playerLane > 1 then
							-- print("Moving left")
							stages.playerLane = stages.playerLane - 1
						end
					end
				elseif gameMode == "mp" then
					if event.y <= SCRORIX + SCRH/2 then
						if event.x > SCRORIX + SCRW/2 then
							if stages.playerLaneBottom < stages.totalLanes then
								-- print("Moving right")
								stages.playerLaneBottom = stages.playerLaneBottom + 1
							end
						elseif event.x < SCRORIX + SCRW/2 then
							if stages.playerLaneBottom > 1 then
								-- print("Moving left")
								stages.playerLaneBottom = stages.playerLaneBottom - 1
							end
						end
					else
						if event.x > SCRORIX + SCRW/2 then
							if stages.playerLaneTop < stages.totalLanes then
								-- print("Moving right")
								stages.playerLaneTop = stages.playerLaneTop + 1
							end
						elseif event.x < SCRORIX + SCRW/2 then
							if stages.playerLaneTop > 1 then
								-- print("Moving left")
								stages.playerLaneTop = stages.playerLaneTop - 1
							end
						end
					end
				end
			end
		end
	elseif stages.stageTotalTime >= 500 then
		stages:startGame()
	end
end

-- Runtime event, is called every frame after scene comes into view
local function move(event)
	if stages.gameStarted == false then
		if stages.stageTotalTime >= 5000 then
			stages:startGame()
		end
	end


	runtimeTime = event.time

	if queuedFunction then
		queuedFunction()
		queuedFunction = nil
	end

	stages:stageHandlerTick(event)
end


function scene:create( event )
	local sceneGroup = self.view

	-- Seed randomizer
	local seed = os.time();
	math.randomseed( seed )

	-- Some local variables

	display.setDefault("anchorX", 0)	-- default to TopLeft anchor point for new objects
	display.setDefault("anchorY", 0)
end



function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then
		-- Called when the scene's view does not exist.
		-- 
		-- INSERT code here to initialize the scene
		-- e.g. add display objects to 'sceneGroup', add touch listeners, etc.
		

		ads.hide()
		adLoaded = false
		stages:create(gameMode, sceneGroup)

		Runtime:addEventListener( "enterFrame", move )


	-- Called when the scene is still off screen and is about to move on screen
	elseif phase == "did" then
		-- Called when the scene is now on screen
		-- 
		-- INSERT code here to make the scene come alive
		-- e.g. start timers, begin animation, play audio, etc.
		-- men:tick()

		runtimeTime = 0	
		if -foundData["highScore"] >= 6 then	
			stages:startGame()

			stages.stageTotalTime = 0
			tPrevious = event.time
		end

		Runtime:addEventListener( "touch", onSystemTouch )
		runtimeTime = event.time

	end
end

function scene:hide( event )
	local sceneGroup = self.view
	
	local phase = event.phase
	
	if event.phase == "will" then
		-- Called when the scene is on screen and is about to move off screen
		--
		-- INSERT code here to pause the scene
		-- e.g. stop timers, stop animation, unload sounds, etc.)
		gameMode = ""

		Runtime:removeEventListener( "touch", onSystemTouch )

		Runtime:removeEventListener( "enterFrame", move )

		audio.stop()

		transitionCalled = false

	elseif phase == "did" then
			-- Called when the scene is now off screen
		explosions:reset()
		stages:reset()

	end	
end


function scene:destroy( event )

	-- Called prior to the removal of scene's "view" (sceneGroup)
	-- 
	-- INSERT code here to cleanup the scene
	-- e.g. remove display objects, remove touch listeners, save state, etc.
	local sceneGroup = self.view
	
end


---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene