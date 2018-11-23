-----------------------------------------------------------------------------------------
--
-- menu.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

-- include Corona's "widget" library
local widget = require "widget"

HSTableHolder = {}

local function retrieveHighestScores(sceneGroup)
	local function RetrieveUserData( event )
	    if ( event.isError ) then
	    	print("Network error!")
	    else
	        local response = json.decode(event.response)

			highScores = response["data"]

			tempItem = display.newText("Nickname", SCRORIX + SCRW * 3.5/10, SCRORIY + SCRH*2.5/10 - SCRH*0.6/10*0, "Arial Black", 40)
			table.insert(HSTableHolder, tempItem)
			sceneGroup:insert(tempItem)
			tempItem = display.newText("Score", SCRORIX + SCRW * 7.5/10, SCRORIY + SCRH*2.5/10 - SCRH*0.6/10*0, "Arial Black", 40)
			table.insert(HSTableHolder, tempItem)
			sceneGroup:insert(tempItem)
			for i, item in ipairs(highScores) do
				if i <= 10 then
					tempItem = display.newText(item["nickname"], SCRORIX + SCRW * 3.5/10, SCRORIY + SCRH*2.5/10 + i*SCRH*0.6/10, "Arial Black", 30)
					table.insert(HSTableHolder, tempItem)
					sceneGroup:insert(tempItem)
					tempItem = display.newText(round(-item["highscore"], 2), SCRORIX + SCRW * 7.5/10, SCRORIY + SCRH*2.5/10 + i*SCRH*0.6/10, "Arial Black", 30)
					table.insert(HSTableHolder, tempItem)
					sceneGroup:insert(tempItem)
				end
			end
	    end
	end     

	-- Create a table to hold our headers we'll be passing to 
	-- backendless. This is how Backendless 
	local headers = {}
	headers["application-id"] = "5146253E-BB38-8315-FFB0-E54AC75C3B00"
	headers["secret-key"] = "0ED284EE-37F3-3085-FF81-4D5E60025A00"
	headers["Content-Type"] = "application/json"
	headers["application-type"] = "REST"
	 
	local tempTable = {}
	local jsonData = json.encode(tempTable)

	local params = {}
	params.headers = headers
	params.body = jsonData

	network.request("https://api.backendless.com/v1/data/nicknames?props=nickname,highscore&pageSize=10&sortBy=highscore", "GET", RetrieveUserData, params)
end

function scene:create( event )
	-- Happens when the scene is first created, and never again (scene:show is also called, so buttons that need to be deleted should be put there)
	local sceneGroup = self.view

	local background = display.newImageRect( "artwork/menu items/space.png", SCRW, SCRH )
	background.anchorX, background.anchorY = 0, 0
	background.x, background.y = SCRORIX, SCRORIY
	sceneGroup:insert(background)

	local gameLogo = display.newImageRect( "artwork/menu items/game logo.png", toSCRW(416/1.5), toSCRH(109/1.5))
	gameLogo.anchorX, gameLogo.anchorY = 0.5, 0
	gameLogo.x, gameLogo.y = SCRORIX + SCRW/2, SCRORIY + SCRH*0.4/10
	sceneGroup:insert(gameLogo)

	local highScoreTitle = display.newImageRect( "artwork/menu items/highscores title.png", toSCRW(540*0.9), toSCRH(100*0.9))
	highScoreTitle.anchorX, highScoreTitle.anchorY = 0.5, .5
	highScoreTitle.x, highScoreTitle.y = SCRORIX + SCRW*5/10, SCRORIY + SCRH*1.5/10
	sceneGroup:insert(highScoreTitle)
end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	if phase == "will" then
		-- Called when the scene is still off screen and is about to move on screen


		-- create a widget to share on FB
		menuBtnHS = widget.newButton(
			{
		        width = toSCRW(100),
		        height = toSCRH(100),
		        defaultFile = "artwork/menu items/back to menu button mm.png",
		        overFile = "artwork/menu items/back to menu button over mm.png",
				onRelease = function()
					composer.gotoScene("mainmenu", "flipFadeOutIn", 100)
				end
			}
		)
		menuBtnHS.anchorX, menuBtnHS.anchorY = 0, 0
		menuBtnHS.x, menuBtnHS.y = SCRORIX + SCRW*0/10, SCRORIY + SCRH*0/10
		sceneGroup:insert(menuBtnHS)

		retrieveHighestScores(sceneGroup)

	elseif phase == "did" then
		-- Called when the scene is now on screen
		-- 
		-- INSERT code here to make the scene come alive
		-- e.g. start timers, begin animation, play audio, etc.
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

		if HSTableHolder then
			for i, item in ipairs(HSTableHolder) do
				display.remove(item)
				item = nil
			end
		end

		audio.play(menuTransition)

	elseif phase == "did" then

		if menuBtnHS then display.remove(menuBtnHS) menuBtnHS = nil end
	end	
end

function scene:destroy( event )
	local sceneGroup = self.view
	
	-- Called prior to the removal of scene's "view" (sceneGroup)
	-- 
	-- INSERT code here to cleanup the scene
	-- e.g. remove display objects, remove touch listeners, save state, etc.
end

-- Listener setup


-----------------------------------------------------------------------------------------

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene