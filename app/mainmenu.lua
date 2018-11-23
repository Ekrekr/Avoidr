-----------------------------------------------------------------------------------------
--
-- menu.lua
--
-----------------------------------------------------------------------------------------
-- Importing and ad setup
local composer = require( "composer" )
local scene = composer.newScene()

explosions = require("explosions")

-- fbtable = require("fbtable")

-- include Corona's "widget" library
local widget = require "widget"

transitionType = "fromRight"
transitionLength = 500

adsEnabled = false
adLoaded = false

runtimeTime = 0	

-- print("@@:@@")
-- tempName = "cunt"
-- for j = 1, #tempName do
-- 	local c = tempName:sub(j,j):lower()
-- 	if checkInTable(lowerLetters, c) == false then
-- 		print("invalid character used")
-- 	end
-- end

-- testingName = tempName:gsub(" ", ""):lower()
-- print(testingName)

-- if checkInTable(rudeWords, testingName) then
-- 	print("Name not allowed")
-- end

tPreviousMenu = 0.0
-------------------------------------------------------------
ads = require("ads")
bannerAppID = "ca-app-pub-9370980936566720/1829542498"
if ( system.getInfo( "platformName" ) == "Android" ) then
    bannerAppID = "ca-app-pub-9370980936566720/1829542498"
end

adProvider = "admob"
function adListener( event )
    local msg = event.response
    -- Quick debug message regarding the response from the library
    print( "Message from the ads library: ", msg )
 
    if ( event.isError ) then
        print( "Error, no ad received", msg )
        -- statusMessage.textObject.text = "Error, no ad received".. msg 
    else
        print( "Ah ha! Got one!" )
        -- statusMessage.textObject.text = "Ah ha! Got one!" 
    end
end
 
ads.init( adProvider, bannerAppID, adListener )

menuTransition = audio.loadSound("audio/transitions/menu.mp3")

noteSound7 = audio.loadSound("audio/notes/sound 7.mp3")
-------------------------------------------------------------
--High score and save stuff
highScoreText = nil

gameMode = ""

transitionCalled = false
-------------------------------------------------------------
-- menu button sprites
local classicBtnSequences = {{name = "slow", frames = {10,9,8,7,6,5,4,3,2,1, 10}, loopCount = 1, time = 500}}

local classicBtnSheet = graphics.newImageSheet("artwork/menu items/classic button hold.png", {width = 540, height = 150, numFrames = 10})
-------------------------------------------------------------

local function menuMove(event)
	runtimeTime = event.time

	if classicBtn then 
		classicBtn.lastSparkle = classicBtn.lastSparkle + event.time - tPreviousMenu
		-- print(classicBtn.lastSparkle)
		if classicBtn.lastSparkle > classicBtn.nextSparkle then
			classicBtn.lastSparkle = 0
			classicBtn.nextSparkle = math.random(2000, 5000)
			classicBtn.sparkle()
		end
	end

	if meteorMadnessBtn then 
		meteorMadnessBtn.lastSparkle = meteorMadnessBtn.lastSparkle + event.time - tPreviousMenu
		-- print(classicBtn.lastSparkle)
		if meteorMadnessBtn.lastSparkle > meteorMadnessBtn.nextSparkle then
			meteorMadnessBtn.lastSparkle = 0
			meteorMadnessBtn.nextSparkle = math.random(500, 1000)
			meteorMadnessBtn.sparkle()
		end
	end

	if multiplayerBtn then 
		multiplayerBtn.lastSparkle = multiplayerBtn.lastSparkle + event.time - tPreviousMenu
		-- print(classicBtn.lastSparkle)
		if multiplayerBtn.lastSparkle > multiplayerBtn.nextSparkle then
			multiplayerBtn.lastSparkle = 0
			multiplayerBtn.nextSparkle = math.random(7000, 10000)
			multiplayerBtn.sparkle()
		end
	end

	if menuToBe == nil and menuRedSq == nil and menuBlueSq == nil then
		menuToBe = {}
		menuToBe.posMod = math.random(1, 2) - 1.5
		menuToBe.colorMod = math.random(1, 2) - 1
	end

	if menuRedSq then
		menuRedSq.x = menuRedSq.x + 10
		if menuRedSq.x >= SCRORIX + SCRW*11/10 then
			display.remove(menuRedSq)
			menuRedSq = nil
			menuToBe = nil
		end
	end

	if menuBlueSq then
		menuBlueSq.x = menuBlueSq.x - 10
		if menuBlueSq.x <= SCRORIX - SCRW*1/10 then
			display.remove(menuBlueSq)
			menuBlueSq = nil
			menuToBe = nil
		end
	end

	if statusMessage then statusMessage.textObject.text = fbtable.lastStatus end

	if creditsSlide then
		if creditsSlide.y >= -SCRH then
			creditsSlide.y = creditsSlide.y - 4
			creditsSlide:toFront()
		else
			display.remove(creditsSlide)
			creditsSlide = nil
		end
	end

	explosions:tick(event)

	tPreviousMenu = event.time
end

local function menuTouchListener(event)
	if transitionCalled == false then
		if event.y > SCRORIY + SCRH*2.7/10 - toSCRH(150/2) and event.y < SCRORIY + SCRH*2.7/10 + toSCRH(150/2) then
			if event.phase == "began" then
				classicBtn.lastSparkle = 0
				classicBtn.nextSparkle = math.random(2000, 5000)
				classicBtn.sparkle()
			elseif event.phase == "ended" then
				gameMode = "classic"
				print("Going to ingame")
				transitionCalled = true
				composer.gotoScene( "ingame", "flipFadeOutIn", 100 )
			end
		elseif event.y > SCRORIY + SCRH*4.7/10 - toSCRH(150/2) and event.y < SCRORIY + SCRH*4.7/10 + toSCRH(150/2) then
			if event.phase == "began" then
				meteorMadnessBtn.lastSparkle = 0
				meteorMadnessBtn.nextSparkle = math.random(500, 1000)
				meteorMadnessBtn.sparkle("extra")
			elseif event.phase == "ended" then
				gameMode = "mm"
				print("Going to ingame")
				transitionCalled = true
				composer.gotoScene( "ingame", "fromRight", 500 )
			end
		elseif event.y > SCRORIY + SCRH*6.7/10 - toSCRH(150/2) and event.y < SCRORIY + SCRH*6.7/10 + toSCRH(150/2) then
			if event.phase == "began" then
				multiplayerBtn.lastSparkle = 0
				multiplayerBtn.nextSparkle = math.random(7000, 10000)
				multiplayerBtn.sparkle()
			elseif event.phase == "ended" then
				gameMode = "mp"
				print("Going to ingame")
				transitionCalled = true
				composer.gotoScene( "ingame", "flipFadeOutIn", 100 )
			end
		end
	end
end

function updateNewestUser()
	print("updating newest user")
	local function RetrieveUserData( event )
		if welcomeText then
		    if ( event.isError ) then
		        welcomeText.text = "Network error!"
		    else
		        local response = json.decode(event.response)
		        if response["nickname"] ~= nil then -- If creation successful
		        	welcomeText.text = "Our newest user: " .. response["nickname"] .. "\nwelcome!"
		        else
		        	welcomeText.text = "network error"
		        end
				welcomeText.alpha = 1
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

	network.request("https://api.backendless.com/v1/data/nicknames/last", "GET", RetrieveUserData, params)
end

function scene:create( event )
	-- Happens when the scene is first created, and never again (scene:show is also called, so buttons that need to be deleted to prevent scene interferance should be put there)
	local sceneGroup = self.view
end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	if phase == "will" then
		-- Called when the scene is still off screen and is about to move on screen
		-- create a widget button (which will loads menscreen.lua on release)
		display.setDefault("anchorX", 0.5)	-- default to TopLeft anchor point for new objects
		display.setDefault("anchorY", 0.5)

		--Preventing HSTable error
		if HSTableHolder then
			for i, item in ipairs(HSTableHolder) do
				display.remove(item)
				item = nil
			end
		end

		background = display.newImageRect( "artwork/menu items/space.png", SCRW, SCRH )
		background.anchorX, background.anchorY = 0, 0
		background.x, background.y = SCRORIX, SCRORIY
		sceneGroup:insert(background)

		gameLogo = display.newImageRect( "artwork/menu items/game logo.png", toSCRW(416*1.1), toSCRH(109*1.1))
		gameLogo.anchorX, gameLogo.anchorY = 0.5, 0
		gameLogo.x, gameLogo.y = SCRORIX + SCRW/2, SCRORIY + SCRH*0.5/10
		sceneGroup:insert(gameLogo)

		-- highScoreText = display.newText("High Score: ".. tostring(round(-foundData["highScore"], 2)), SCRORIX + SCRW*6.5/10, SCRORIY + SCRH*3.05/10 + toSCRH(160/2), native.systemFontBold, 30)
		-- highScoreText.anchorX, highScoreText.anchorY = 0.5, 0
		-- highScoreText:setFillColor(1, 1, 1)
		-- sceneGroup:insert(highScoreText)

		if foundData and highScoreText then
			highScoreText.text = "High Score: "..round(-foundData["highScore"], 2)
		end

		classicBtn = display.newSprite(classicBtnSheet, classicBtnSequences)
		classicBtn.anchorX, classicBtn.anchorY = 0.5, 0.5
		classicBtn.x,classicBtn.y = SCRORIX + SCRW / 2, SCRORIY + SCRH *2.7/10
		classicBtn.label = "classicBtn"
		classicBtn.lastSparkle = 0
		classicBtn.nextSparkle = math.random(2000, 5000)
		classicBtn.sparkle = function()
			if classicBtn then
				classicBtn:setSequence("slow")
				classicBtn:play()
			end
		end
		sceneGroup:insert(classicBtn)
		classicBtn.sparkle()


		meteorMadnessBtn = display.newImageRect("artwork/menu items/meteor madness button.png", toSCRW(540*0.9), toSCRH(154*0.9))
		meteorMadnessBtn.anchorX, meteorMadnessBtn.anchorY = 0.5, 0.5
		meteorMadnessBtn.x,meteorMadnessBtn.y = SCRORIX + SCRW / 2, SCRORIY + SCRH *4.7/10
		meteorMadnessBtn.lastSparkle = 0
		meteorMadnessBtn.nextSparkle = math.random(500, 1000)
		meteorMadnessBtn.sparkle = function(tempVar)
			if meteorMadnessBtn then
				local xPos = SCRORIX + math.random(SCRW*1/10, SCRW*9/10)
				local yPos = SCRORIY + math.random(SCRH*3.2, SCRH*5.2)
				if tempVar == nil then
					explosions.new("basic", SCRORIX + math.random(SCRW*1/10, SCRW*9/10), SCRORIY + math.random(SCRH*3.9/10, SCRH*5.5/10), 0.1, 1, sceneGroup)
				else
					explosions.new("basic", SCRORIX + math.random(SCRW*1/10, SCRW*9/10), SCRORIY + math.random(SCRH*3.9/10, SCRH*5.5/10), 0.3, 1, sceneGroup)
				end
			end
		end
		sceneGroup:insert(meteorMadnessBtn)
		meteorMadnessBtn.sparkle()


		multiplayerBtn = display.newImageRect("artwork/menu items/multiplayer btn.png", toSCRW(540*0.9), toSCRH(148.5*0.9))
		multiplayerBtn.anchorX, multiplayerBtn.anchorY = 0.5, 0.5
		multiplayerBtn.x,multiplayerBtn.y = SCRORIX + SCRW / 2, SCRORIY + SCRH *6.7/10
		multiplayerBtn.lastSparkle = 0
		multiplayerBtn.nextSparkle = math.random(7000, 10000)

		menuToBe = {}
		menuToBe.posMod = math.random(1, 2) - 1.5
		menuToBe.colorMod = math.random(1, 2) - 1

		multiplayerBtn.sparkle = function()
			if meteorMadnessBtn then
				if menuRedSq == nil then
					-- print("@@@@POSMOD", menuToBe.posMod)
					-- print("@@@@RED", SCRORIY + SCRH * 6.3/10 + menuToBe.posMod*(SCRH*0.5/10))
					menuRedSq = display.newRect(SCRORIX - SCRW/10, SCRORIY + SCRH * 6.65/10 + menuToBe.posMod*(SCRH*1/10), 
						toSCRH(50), toSCRH(50))
					menuRedSq.anchorX, menuRedSq.anchorY = 0.5, 0.5
					menuRedSq:setFillColor(menuToBe.colorMod, 0, 1-menuToBe.colorMod, 0.5)
					sceneGroup:insert(menuRedSq)
				end
				if menuBlueSq == nil then
					-- print("@@@@BLUE", SCRORIY + SCRH * 6.3/10 + (1-menuToBe.posMod)*(SCRH*0.5/10))
					menuBlueSq = display.newRect(SCRORIX + SCRW*11/10, SCRORIY + SCRH * 6.65/10 + (-menuToBe.posMod)*(SCRH*1/10), 
						toSCRH(50), toSCRH(50))
					menuBlueSq.anchorX, menuBlueSq.anchorY = 0.5, 0.5
					menuBlueSq:setFillColor(1-menuToBe.colorMod, 0, menuToBe.colorMod, 0.5)
					sceneGroup:insert(menuBlueSq)
				end
			end
		end
		sceneGroup:insert(multiplayerBtn)
		multiplayerBtn.sparkle()

		creditsBtn = widget.newButton(
			{
				width = toSCRW(540/2), 
				height = toSCRH(158/2),
				defaultFile = "artwork/menu items/credits btn.png",
				overFile = "artwork/menu items/credits btn over.png",
				onEvent = function(event)
					if (event.phase == "ended") then
						if creditsSlide == nil then
							creditsSlide = display.newImageRect( "artwork/menu items/credits.png", SCRW, SCRH )
							creditsSlide.anchorX, creditsSlide.anchorY = 0.5, 0
							creditsSlide.x, creditsSlide.y = SCRORIX + SCRW/2, SCRORIY + SCRH
							sceneGroup:insert(creditsSlide)
						end
					end
				end
			}
		)
		creditsBtn.x,creditsBtn.y = SCRORIX + SCRW / 2, SCRORIY + SCRH * 8.4/10
		sceneGroup:insert(creditsBtn)

		-- create a widget to share on FB
		-- shareBtn = widget.newButton(
		-- 	{
		--         width = toSCRW(179, 0.8),
		--         height = toSCRH(65, 0.8),
		--         defaultFile = "artwork/menu items/fb share.png",
		--         overFile = "artwork/menu items/fb share over.png",
		-- 		-- onRelease = postPhoto_onRelease
		-- 		onRelease = function()
		-- 			fbtable:postPhoto_onRelease()
		-- 		end
		-- 	}
		-- )
		-- shareBtn.anchorX, shareBtn.anchorY = 0.5, 0.5
		-- shareBtn.x, shareBtn.y = SCRORIX + SCRW*5/10, SCRORIY + SCRH*8.6/10
		-- shareBtn.alpha = 0.7
		-- sceneGroup:insert(shareBtn)

		-- create a widget to share on FB
		highscoreBtn = widget.newButton(
			{
		        width = toSCRW(100, 0.8),
		        height = toSCRH(100, 0.8),
		        defaultFile = "artwork/menu items/highscore btn.png",
		        overFile = "artwork/menu items/highscore btn over.png",
				onRelease = function()
					-- Runtime:removeEventListener("touch", menuTouchListener)
					composer.gotoScene("highscores", "flipFadeOutIn", 100)
				end
			}
		)
		highscoreBtn.anchorX, highscoreBtn.anchorY = 0.5, 0.5
		highscoreBtn.x, highscoreBtn.y = SCRORIX + SCRW*1.5/10, SCRORIY + SCRH*8.4/10
		sceneGroup:insert(highscoreBtn)

		-- create a widget to share on FB
		settingsBtn = widget.newButton(
			{
		        width = toSCRW(100, 0.8),
		        height = toSCRH(100, 0.8),
		        defaultFile = "artwork/menu items/settings button.png",
		        overFile = "artwork/menu items/settings button over.png",
				onRelease = function()
					-- Runtime:removeEventListener("touch", menuTouchListener)
					composer.gotoScene("settings", "flipFadeOutIn", 100)
				end
			}
		)
		settingsBtn.anchorX, settingsBtn.anchorY = 0.5, 0.5
		settingsBtn.x, settingsBtn.y = SCRORIX + SCRW*8.5/10, SCRORIY + SCRH*8.4/10
		sceneGroup:insert(settingsBtn)

		Runtime:addEventListener( "enterFrame", menuMove)
		Runtime:addEventListener("touch", menuTouchListener)

		-- statusMessage = fbtable:createStatusMessage(fbtable.lastStatus, SCRORIX + SCRW*2.5/10, SCRORIY + SCRH * 4.5/10)
		-- statusMessage:scale(0.5, 0.5)
		-- statusMessage.alpha = 0.5
		-- sceneGroup:insert(statusMessage)

		-- if welcomeText == nil then
		-- 	local wtOptions = {
		-- 		text = "", 
		-- 		x = SCRORIX + SCRW*5/10, 
		-- 		y = SCRORIY + SCRH*1.85/10, 
		-- 		font = native.systemFontBold, 
		-- 		fontSize = 20, 
		-- 		align = "center"
		-- 	}
		-- 	welcomeText = display.newText(wtOptions)
		-- 	welcomeText.anchorX, welcomeText.anchorY = 0.5, 0.5
		-- 	welcomeText:setFillColor(1, 1, 1)
		-- 	sceneGroup:insert(welcomeText)
		-- else
		-- 	welcomeText.alpha = 0
		-- end

		-- updateNewestUser()

		if adsEnabled == true then
			if adLoaded == false then
				adLoaded = true
				ads.show( "banner", {x = toSCRW(36), y = SCRH, interval = 10, appId = bannerAppID, testMode = false} )
			end
		end


	elseif phase == "did" then
		-- Called when the scene is now on screen
		-- 
		-- INSERT code here to make the scene come alive
		-- e.g. start timers, begin animation, play audio, etc.
	end	
end

function scene:hide( event )
	local sceneGroup = self.view1
	local phase = event.phase
	
	if event.phase == "will" then
		-- Called when the scene is on screen and is about to move off screen
		--
		-- INSERT code here to pause the scene
		-- e.g. stop timers, stop animation, unload sounds, etc.)
		Runtime:removeEventListener("touch", menuTouchListener)

		--removal of menu touch listener must be put in widget effect functions before composer transitions


		audio.play(menuTransition)

	elseif phase == "did" then
		-- Called when the scene is now off screen
		Runtime:removeEventListener( "enterFrame", menuMove )
		explosions:reset()

		if classicBtn then classicBtn:removeSelf() display.remove(classicBtn) classicBtn = nil end
		if shareBtn then shareBtn:removeSelf() shareBtn.alpha = 0 display.remove(shareBtn) shareBtn = nil end
		if statusMessage then display.remove(statusMessage) statusMessage = nil end
		if settingsBtn then display.remove(settingsBtn) settingsBtn = nil end
		if welcomeText then display.remove(welcomeText) welcomeText = nil end

		if menuRedSq then display.remove(menuRedSq) menuRedSq = nil end
		if menuBlueSq then display.remove(menuBlueSq) menuBlueSq = nil end

		if highScoreText then display.remove(highScoreText) highScoreText = nil end

		if multiplayerBtn then multiplayerBtn:removeSelf() multiplayerBtn = nil end 
		if creditsBtn then creditsBtn:removeSelf() creditsBtn = nil end

		if background then display.remove(background) background = nil end
		if gameLogo then display.remove(gameLogo) gameLogo = nil end
		if highScoreText then display.remove(highScoreText) highScoreText = nil end
		if creditsSlide then display.remove(creditsSlide) creditsSlide = nil end
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