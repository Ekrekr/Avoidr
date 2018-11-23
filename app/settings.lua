-----------------------------------------------------------------------------------------
--
-- menu.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

-- include Corona's "widget" library
local widget = require "widget"

function scene:create( event )
	-- Happens when the scene is first created, and never again (scene:show is also called, so buttons that need to be deleted should be put there)
	local sceneGroup = self.view
end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	if phase == "will" then
		-- Called when the scene is still off screen and is about to move on screen

		settingsBG = display.newImageRect( "artwork/menu items/space.png", SCRW, SCRH )
		settingsBG.anchorX, settingsBG.anchorY = 0, 0
		settingsBG.x, settingsBG.y = SCRORIX, SCRORIY
		sceneGroup:insert(settingsBG)

		settingsGL = display.newImageRect( "artwork/menu items/game logo.png", toSCRW(416/1.5), toSCRH(109/1.5))
		settingsGL.anchorX, settingsGL.anchorY = 0.5, 0
		settingsGL.x, settingsGL.y = SCRORIX + SCRW/2, SCRORIY + SCRH*0.4/10
		sceneGroup:insert(settingsGL)

		-- create a widget to share on FB
		menuBtnS = widget.newButton(
			{
		        width = toSCRW(100),
		        height = toSCRH(100),
		        defaultFile = "artwork/menu items/back to menu button mm.png",
		        overFile = "artwork/menu items/back to menu button over mm.png",
				onRelease = function()
					loadsave.saveTable(foundData, "savedata.json")
					composer.gotoScene("mainmenu", "flipFadeOutIn", 100)
				end
			}
		)
		menuBtnS.anchorX, menuBtnS.anchorY = 0, 0
		menuBtnS.x, menuBtnS.y = SCRORIX + SCRW*0/10, SCRORIY + SCRH*0/10
		sceneGroup:insert(menuBtnS)

		-- Slider listener
		local function sliderListener( event )
		    -- print( "Slider at " .. event.value .. "%" )
		    foundData["gameVolume"] = event.value/100
		    audio.setVolume(foundData["gameVolume"])
		    if event.phase == "ended" then
		    	-- print("slider released")

				local channel, sound_object = audio.play(noteSound7)

				al.Source( sound_object, al.PITCH, 0.5 + foundData["gameVolume"] * 1.5)
		    end
		end

		-- Image sheet options and declaration
		-- For testing, you may copy/save the image under "Visual Customization" above
		local options = {
		    frames = {
		        { x=0, y=0, width=36, height=64 },
		        { x=40, y=0, width=36, height=64 },
		        { x=80, y=0, width=36, height=64 },
		        { x=124, y=0, width=36, height=64 },
		        { x=168, y=0, width=64, height=64 }
		    },
		    sheetContentWidth = 232,
		    sheetContentHeight = 64
		}
		local sliderSheet = graphics.newImageSheet( "artwork/menu items/slider.png", options )

		-- Create the widget
		local slider = widget.newSlider(
		    {
		        sheet = sliderSheet,
		        leftFrame = 1,
		        middleFrame = 2,
		        rightFrame = 3,
		        fillFrame = 4,
		        frameWidth = 36,
		        frameHeight = 64,
		        handleFrame = 5,
		        handleWidth = 64,
		        handleHeight = 64,
		        value = foundData["gameVolume"] * 100,
		        top = SCRORIY + SCRH*3/10,
		        left = SCRORIX + SCRW*1.25/10,
		        orientation = "horizontal",
		        width = SCRW*7.5/10,
		        listener = sliderListener
		    }
		)
		slider.anchorX, slider.anchorY = 0.5, 0.5
		sceneGroup:insert(slider)

		volumeHeader = display.newText("Volume", SCRORIX + SCRW*5/10, SCRORIY + SCRH*2.7/10, native.systemFontBold, 50)
		volumeHeader.anchorX, volumeHeader.anchorY = 0.5, 0.5
		volumeHeader:setFillColor(1, 1, 1)
		sceneGroup:insert(volumeHeader)

		resetUserDataBtn = widget.newButton(
			{
		        width = toSCRW(540*2/3),
		        height = toSCRH(154*2/3),
		        defaultFile = "artwork/menu items/reset user data btn.png",
		        overFile = "artwork/menu items/reset user data btn over.png",
				onRelease = function()
					if not confirmBtn then
						confirmBtn = widget.newButton(
							{
								width = toSCRW(540*5/10),
								height = toSCRH(154*5/10),
								shape = "rect",
								fontSize = 30,
						        label = "Confirm deletion",
						        fillColor = { default={1,0,0,0.6}, over={1, 0, 0, 1} },
	    						strokeColor = { default={0, 0, 0, 1}, over={0, 0, 0, 1} },
	        					strokeWidth = 4,
								onRelease = function()
									print("confirm sent")
									deleteUser()
									foundData = nil
									userID = nil
									loadsave.saveTable({}, "savedata.json")
									composer.gotoScene("nickname", "flip", 100)
								end
							}
						)
						confirmBtn.anchorX, confirmBtn.anchorY = 0.5, 0.5
						confirmBtn.x, confirmBtn.y = SCRORIX + SCRW*5/10, SCRORIY + SCRH*8/10
						sceneGroup:insert(confirmBtn)
					end
				end
			}
		)
		resetUserDataBtn.anchorX, resetUserDataBtn.anchorY = 0.5, 0.5
		resetUserDataBtn.x, resetUserDataBtn.y = SCRORIX + SCRW*5/10, SCRORIY + SCRH*7/10
		sceneGroup:insert(resetUserDataBtn)

		print("@@@@@@@")
		printTable(foundData)
		print("@@@@@@@")

		userTextS = display.newText(foundData["nickname"], SCRORIX + SCRW*5/10, SCRORIY + SCRH*6/10, native.systemFontBold, 30)
		userTextS.anchorX, userTextS.anchorY = 0.5, 0.5
		userTextS:setFillColor(1, 1, 1)
		sceneGroup:insert(userTextS)

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

		audio.play(menuTransition)

	elseif phase == "did" then

		if settingsBG then display.remove(settingsBG) settingsBG = nil end
		if settingsGL then display.remove(settingsGL) settingsGL = nil end
		if confirmBtn then display.remove(confirmBtn) confirmBtn = nil end

		if userTextS then display.remove(userTextS) userTextS = nil end

		if menuBtnS then display.remove(menuBtnS) menuBtnS = nil end
		if slider then display.remove(slider) slider = nil end
		if resetUserDataBtn then display.remove(resetUserDataBtn) resetUserDataBtn = nil end
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