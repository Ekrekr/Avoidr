-----------------------------------------------------------------------------------------
--
-- stages.lua
--
-- stages implementation file
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local widget = require "widget"

local stages = {}
-------------------------------------------------
-- PRIVATE FUNCTIONS
-------------------------------------------------

local gameOverSound = audio.loadSound("audio/stage sounds/game over.mp3")


noteSound1 = audio.loadSound("audio/notes/sound 1.mp3")
noteSound2 = audio.loadSound("audio/notes/sound 2.mp3")
noteSound3 = audio.loadSound("audio/notes/sound 3.mp3")
noteSound4 = audio.loadSound("audio/notes/sound 4.mp3")
noteSound5 = audio.loadSound("audio/notes/sound 5.mp3")
noteSound6 = audio.loadSound("audio/notes/sound 6.mp3")

auraSequences = { 
	{ 
		name = "slow", 
		start = 1, 
		count = 1, 
		time = 1000
	}
}
earthAuraSheet = graphics.newImageSheet("artwork/meteor madness/earth aura.png", {width = 110, height = 110, numFrames = 2})

earthSequences = { 
	{ 
		name = "slow", 
		start = 1, 
		count = 24, 
		time = 1000
	}
}
earthBasicSheet = graphics.newImageSheet("artwork/meteor madness/globespin.png", {width = 90, height = 90, numFrames = 24})


-------------------------------------------------
-- PUBLIC FUNCTIONS
-------------------------------------------------

function stages:create(gameMode, sceneGroup)
	if gameMode == "multiplayer" then gameMode = "mp" end
	print("NEWGAME, gamemode:", gameMode)

	local seed = os.time();
	math.randomseed( seed )

	stages.sceneGroup = sceneGroup

	stages.stageTotalTime = 0
	stages.tPrevious = system.getTimer()
	if gameMode == "classic" or gameMode == "mm" then
		stages.playerLane = 2 --1 is left, 2 mid, 3 right
	elseif gameMode == "mp" then
		stages.playerLaneTop = 2 --1 is left, 2 mid, 3 right
		stages.playerLaneBottom = 2 --1 is left, 2 mid, 3 right
	end
	stages.totalLanes = 3
	stages.gameOver = false
	stages.notes = {}
	stages.glows = {}
	stages.lastLanes = {}
	stages.gameStarted = false

	-- stages.dodgeCount = 0

	stages.gameMode = gameMode
	if stages.gameMode == nil then
		stages.gameMode = "classic"
	end

	stages.speedMod = 1
	stages.lastNote = 0
	stages.nextNote = 1000

	if gameMode == "mm" then
		stages.background1 = display.newImageRect("artwork/meteor madness/space horizontal.png", toSCRW(920*3), toSCRH(540*3))
		stages.background1.anchorX, stages.background1.anchorY = 0.5, 0.5
		stages.background1.x, stages.background1.y = SCRORIX + SCRW/2 - toSCRW(920*1), SCRORIY + SCRH/2
		stages.sceneGroup:insert(stages.background1)
		stages.background2 = display.newImageRect("artwork/meteor madness/space horizontal.png", toSCRW(920*3), toSCRH(540*3))
		stages.background2.anchorX, stages.background2.anchorY = 0.5, 0.5
		stages.background2.x, stages.background2.y = SCRORIX + SCRW/2 + toSCRW(920*2), SCRORIY + SCRH/2
		stages.sceneGroup:insert(stages.background2)
		stages.backgroundAngle = 0
	else
		stages.background = display.newRect(SCRORIX, SCRORIY, SCRW, SCRH)
		stages.background.anchorX, stages.background.anchorY = 0, 0
		stages.background:setFillColor(1, 1, 1)
		stages.sceneGroup:insert(stages.background)
	end

	if stages.gameMode == "classic" then
		stages.playerSquare = display.newRect(SCRORIX + SCRW/2, SCRORIY + SCRH/2, toSCRW(100), toSCRW(100))
		stages.playerSquare:setFillColor(1, 0, 0)
		stages.playerSquare.anchorX, stages.playerSquare.anchorY = 0.5, 0.5
		stages.sceneGroup:insert(stages.playerSquare)
	elseif stages.gameMode == "mm" then
		stages.playerAura = display.newSprite(earthAuraSheet, auraSequences)
		stages.playerAura:setSequence("slow")
		stages.playerAura:play()
		stages.playerAura.x, stages.playerAura.y = SCRORIX + SCRW/2, SCRORIY + SCRH/2
		stages.playerAura.anchorX, stages.playerAura.anchorY = 0.5, 0.5
		stages.playerAura.alpha = 0.2
		stages.sceneGroup:insert(stages.playerAura)

		stages.playerSquare = display.newSprite(earthBasicSheet, earthSequences)
		stages.playerSquare:setSequence("slow")
		stages.playerSquare:play()
		stages.playerSquare.x, stages.playerSquare.y = SCRORIX + SCRW/2, SCRORIY + SCRH/2
		stages.playerSquare.anchorX, stages.playerSquare.anchorY = 0.5, 0.5
		stages.sceneGroup:insert(stages.playerSquare)
	elseif stages.gameMode == "mp" then
		stages.playerSquareTop = display.newRect(SCRORIX + SCRW/2, SCRORIY + SCRH*2/3, toSCRW(100), toSCRW(100))
		stages.playerSquareTop:setFillColor(1, 0, 0)
		stages.playerSquareTop.anchorX, stages.playerSquareTop.anchorY = 0.5, 0.5
		stages.sceneGroup:insert(stages.playerSquareTop)
		stages.playerSquareBottom = display.newRect(SCRORIX + SCRW/2, SCRORIY + SCRH*1/3, toSCRW(100), toSCRW(100))
		stages.playerSquareBottom:setFillColor(0, 0, 1)
		stages.playerSquareBottom.anchorX, stages.playerSquareBottom.anchorY = 0.5, 0.5
		stages.sceneGroup:insert(stages.playerSquareBottom)
	end


	-- local dottedLine = display.newImageRect("artwork/backgrounds/dotted line.png", 540, 3)
	-- dottedLine.anchorX, dottedLine.anchorY = 0.5, 0.5
	-- dottedLine.x, dottedLine.y = SCRORIX + SCRW/2, SCRORIY + SCRH * 4/5

	stages.timeText = display.newText("0.00", SCRORIX, SCRORIY + SCRH, native.systemFontBold, 40)
	stages.timeText.anchorX, stages.timeText.anchorY = 0, 1
	stages.timeText:setFillColor(0, 0, 0)
	stages.sceneGroup:insert(stages.timeText)
	if gameMode == "mm" then stages.timeText:setFillColor(1, 1, 1)
	elseif gameMode == "mp" then
		stages.timeTextTop = display.newText("0.00", SCRORIX + SCRW, SCRORIY, native.systemFontBold, 40)
		stages.timeTextTop.anchorX, stages.timeTextTop.anchorY = 0, 1
		stages.timeTextTop:rotate(180)
		stages.timeTextTop:setFillColor(0, 0, 0)
		stages.sceneGroup:insert(stages.timeTextTop)
	end


	stages.tempScoreText = display.newText(round(-foundData["highScore"], 3), SCRORIX + SCRW*1/2, SCRORIY + SCRH*3.5/10, native.systemFontBold, 100)
	stages.tempScoreText.anchorX, stages.tempScoreText.anchorY = 0.5, 1
	stages.tempScoreText:setFillColor(0, 0, 0)
	if gameMode == "mm" then stages.tempScoreText:setFillColor(1, 1, 1)
	elseif gameMode == "mp" then 
		stages.tempScoreText.alpha = 0
	end

	-- Tutorial stuff
	if -foundData["highScore"] <= 6 then
		stages.helpText1 = display.newText("Tap here to move left", SCRORIX + SCRW*1/20, SCRORIY + SCRH*2/3, native.systemFontBold, 30)
		stages.helpText1:rotate(90)
		stages.helpText1.anchorX, stages.helpText1.anchorY = 1, 0.5
		stages.helpText1:setFillColor(1, 0, 0)
		stages.sceneGroup:insert(stages.helpText1)

		stages.helpText2 = display.newText("Tap here to move right", SCRORIX + SCRW*19/20, SCRORIY + SCRH*2/3, native.systemFontBold, 30)
		stages.helpText2:rotate(-90)
		stages.helpText2.anchorX, stages.helpText2.anchorY = 0, 0.5
		stages.helpText2:setFillColor(1, 0, 0)
		stages.sceneGroup:insert(stages.helpText2)

		stages.helpText3 = display.newText("DANGER: AVOID", SCRORIX + SCRW*1/2, SCRORIY, native.systemFontBold, 40)
		stages.helpText3.anchorX, stages.helpText3.anchorY = 0.5, 0
		stages.helpText3:setFillColor(1, 0, 0)
		stages.sceneGroup:insert(stages.helpText3)

		stages.helpText4 = display.newText("DANGER: AVOID", SCRORIX + SCRW*1/2, SCRORIY + SCRH, native.systemFontBold, 40)
		stages.helpText4.anchorX, stages.helpText4.anchorY = 0.5, 1
		stages.helpText4:setFillColor(1, 0, 0)
		stages.sceneGroup:insert(stages.helpText4)

		if stages.gameMode  == "mm" then
			stages.helpText3.text = "METEORS INCOMING"
			stages.helpText4.text = "METEORS INCOMING"
		end

		table.insert(stages, stages.helpText1)
		table.insert(stages, stages.helpText2)
		table.insert(stages, stages.helpText3)
		table.insert(stages, stages.helpText4)
	else
		-- stages:startGame()
	end

	firstPlay = false

	table.insert(stages, stages.background)
	table.insert(stages, stages.playerSquare)
	table.insert(stages, dottedLine)
end

function stages:newGlow(xPos, side)
	newGlow = display.newImageRect("artwork/explosions/glow.png", 150, 40)
	newGlow.anchorX, newGlow.anchorY = 0.5, 1
	newGlow.x = xPos
	if side == "top" then
		newGlow:rotate(180)
		newGlow.y = SCRORIY
	elseif side == "bottom" then
		newGlow.y = SCRORIY + SCRH
	end
	stages.sceneGroup:insert(newGlow)
	-- newGlow.alpha
	table.insert(stages.glows, newGlow)
end

function stages:startGame()
	stages.gameStarted = true
	stages.stageTotalTime = 0
	stages.tPrevious = system.getTimer()

	if stages.helpText1 then display.remove(stages.helpText1) stages.helpText1 = nil end
	if stages.helpText2 then display.remove(stages.helpText2) stages.helpText2 = nil end
	if stages.helpText3 then display.remove(stages.helpText3) stages.helpText3 = nil end
	if stages.helpText4 then display.remove(stages.helpText4) stages.helpText4 = nil end
end

-- Happens every "enterFrame" runtime event listener tick. Handles wave and stage progression, object deletion,
-- and pretty much everything to do with stages
function stages:stageHandlerTick(event)
	inpTime = event.time
	stages.stageTotalTime = stages.stageTotalTime + inpTime - stages.tPrevious
	stages.lastNote = stages.lastNote + inpTime - stages.tPrevious
	explosions:tick(event)

	-- Background manipulation for meteor madness
	if stages.background1 and stages.background2 and stages.backgroundAngle then
		stages.backgroundAngle = stages.backgroundAngle + stages.speedMod * 1
		if stages.backgroundAngle >= 360 then
			stages.backgroundAngle = stages.backgroundAngle - 360
		end
		if stages.gameOver == false then
			stages.background1.x = stages.background1.x - stages.speedMod * 5
			stages.background1.y = SCRORIY + SCRH/2 + math.sin(math.rad(stages.backgroundAngle)) * SCRH/3
			stages.background2.x = stages.background2.x - stages.speedMod * 5
			stages.background2.y = SCRORIY + SCRH/2 + math.sin(math.rad(stages.backgroundAngle)) * SCRH/3
			stages.playerSquare.rotation = 30*math.sin(math.rad(stages.backgroundAngle))
		end
		if stages.background1.x <= SCRORIX + SCRW/2 -toSCRW(920*3) then
			stages.background1.x = SCRORIX + SCRW/2 +toSCRW(920*3)
		end
		if stages.background2.x <= SCRORIX + SCRW/2 -toSCRW(920*3) then
			stages.background2.x = SCRORIX + SCRW/2 +toSCRW(920*3)
		end
	end

	if stages.gameStarted == true then
		if stages.gameOver == false then
			stages.speedMod = stages.speedMod + (inpTime - stages.tPrevious)/15000--0.002
			if stages.gameMode == "mm" then stages.playerSquare.timeScale = stages.speedMod^0.5 end

			-- note spawning
			if stages.lastNote >= stages.nextNote then
				if math.random(2) == 1 then
					stages:newNote("top")
				else
					stages:newNote("bottom")
				end
				stages.lastNote = 0
				stages.nextNote = math.random(2000/(2^stages.speedMod), 4000/(2^stages.speedMod))
			end

			--player square movement handling
			if stages.gameMode == "classic" or stages.gameMode == "mm" then
				if stages.playerLane == 1 then
					if (stages.playerSquare.x <= SCRORIX + SCRW * 1/5 - toSCRW(1)) or (stages.playerSquare.x >= SCRORIX + SCRW * 1/5 + toSCRW(1)) then
						stages.playerSquare.x = stages.playerSquare.x - (stages.playerSquare.x - SCRORIX - SCRW * 1/5)/1.5
					end
				elseif stages.playerLane == 2 then
					if (stages.playerSquare.x <= SCRORIX + SCRW/2 - toSCRW(1)) or (stages.playerSquare.x >= SCRORIX + SCRW/2 + toSCRW(1)) then
						stages.playerSquare.x = stages.playerSquare.x - (stages.playerSquare.x - SCRORIX - SCRW * 1/2)/1.5
					end
				elseif stages.playerLane == 3 then
					if (stages.playerSquare.x <= SCRORIX + SCRW * 4/5 - toSCRW(1)) or (stages.playerSquare.x >= SCRORIX + SCRW * 4/5 + toSCRW(1)) then
						stages.playerSquare.x = stages.playerSquare.x - (stages.playerSquare.x - SCRORIX - SCRW * 4/5)/1.5
					end
				end
				-- special effects for meteor madness
				if stages.gameMode == "mm" and stages.playerAura then
					stages.playerAura.x = stages.playerSquare.x
					stages.playerAura.y = stages.playerSquare.y
					stages.playerSquare.rotation = 30*math.sin(math.rad(stages.backgroundAngle))
				end
				stages.playerSquare:toFront()

			elseif stages.gameMode == "mp" then
				if stages.playerLaneTop == 1 then
					if (stages.playerSquareTop.x <= SCRORIX + SCRW * 1/5 - toSCRW(1)) or (stages.playerSquareTop.x >= SCRORIX + SCRW * 1/5 + toSCRW(1)) then
						stages.playerSquareTop.x = stages.playerSquareTop.x - (stages.playerSquareTop.x - SCRORIX - SCRW * 1/5)/1.5
					end
				elseif stages.playerLaneTop == 2 then
					if (stages.playerSquareTop.x <= SCRORIX + SCRW/2 - toSCRW(1)) or (stages.playerSquareTop.x >= SCRORIX + SCRW/2 + toSCRW(1)) then
						stages.playerSquareTop.x = stages.playerSquareTop.x - (stages.playerSquareTop.x - SCRORIX - SCRW * 1/2)/1.5
					end
				elseif stages.playerLaneTop == 3 then
					if (stages.playerSquareTop.x <= SCRORIX + SCRW * 4/5 - toSCRW(1)) or (stages.playerSquareTop.x >= SCRORIX + SCRW * 4/5 + toSCRW(1)) then
						stages.playerSquareTop.x = stages.playerSquareTop.x - (stages.playerSquareTop.x - SCRORIX - SCRW * 4/5)/1.5
					end
				end
				stages.playerSquareTop:toFront()

				if stages.playerLaneBottom == 1 then
					if (stages.playerSquareBottom.x <= SCRORIX + SCRW * 1/5 - toSCRW(1)) or (stages.playerSquareBottom.x >= SCRORIX + SCRW * 1/5 + toSCRW(1)) then
						stages.playerSquareBottom.x = stages.playerSquareBottom.x - (stages.playerSquareBottom.x - SCRORIX - SCRW * 1/5)/1.5
					end
				elseif stages.playerLaneBottom == 2 then
					if (stages.playerSquareBottom.x <= SCRORIX + SCRW/2 - toSCRW(1)) or (stages.playerSquareBottom.x >= SCRORIX + SCRW/2 + toSCRW(1)) then
						stages.playerSquareBottom.x = stages.playerSquareBottom.x - (stages.playerSquareBottom.x - SCRORIX - SCRW * 1/2)/1.5
					end
				elseif stages.playerLaneBottom == 3 then
					if (stages.playerSquareBottom.x <= SCRORIX + SCRW * 4/5 - toSCRW(1)) or (stages.playerSquareBottom.x >= SCRORIX + SCRW * 4/5 + toSCRW(1)) then
						stages.playerSquareBottom.x = stages.playerSquareBottom.x - (stages.playerSquareBottom.x - SCRORIX - SCRW * 4/5)/1.5
					end
				end
				stages.playerSquareBottom:toFront()
			end




			--note movement and collision detection
			for i, note in ipairs(stages.notes) do
				if note.y then
					-- note position change
					note.y = note.y - stages.speedMod * note.direction * note.speedMod * (inpTime - stages.tPrevious)/15

					if stages.gameMode == "classic" or stages.gameMode == "mm" then
						if (note.x >= stages.playerSquare.x - (toSCRW(75/2) + toSCRW(100/2))) and (note.x <= stages.playerSquare.x + (toSCRW(75/2) + toSCRW(100/2))) then
							if (stages.playerSquare.y >= note.y - note.noteLength/2 - toSCRW(30)) and (stages.playerSquare.y <= note.y + note.noteLength/2 + toSCRW(30)) then
								stages:endGame()
							end
						end
					elseif stages.gameMode == "mp" then
						if (note.x >= stages.playerSquareTop.x - (toSCRW(75/2) + toSCRW(100/2))) and (note.x <= stages.playerSquareTop.x + (toSCRW(75/2) + toSCRW(100/2))) then
							if (stages.playerSquareTop.y >= note.y - note.noteLength/2 - toSCRW(30)) and (stages.playerSquareTop.y <= note.y + note.noteLength/2 + toSCRW(30)) then
								stages:endGame("Blue")
							end
						end
						if (note.x >= stages.playerSquareBottom.x - (toSCRW(75/2) + toSCRW(100/2))) and (note.x <= stages.playerSquareBottom.x + (toSCRW(75/2) + toSCRW(100/2))) then
							if (stages.playerSquareBottom.y >= note.y - note.noteLength/2 - toSCRW(30)) and (stages.playerSquareBottom.y <= note.y + note.noteLength/2 + toSCRW(30)) then
								stages:endGame("Red")
							end
						end
					end

					-- --Counting score for dodging meteorites
					-- if note.scoreCounted == false then
					-- 	if (note.direction == -1) and (note.y >= SCRORIY + SCRH/2 + note.noteLength/2 + toSCRW(50)) then
					-- 		note.scoreCounted = true
					-- 		stages.dodgeCount = stages.dodgeCount + 1
					-- 		print("meteor dodged!") 
					-- 	elseif (note.direction == 1) and (note.y <= SCRORIY + SCRH/2 - note.noteLength/2 - toSCRW(50)) then
					-- 		note.scoreCounted = true
					-- 		stages.dodgeCount = stages.dodgeCount + 1
					-- 		print("meteor dodged!") 
					-- 	end
					-- end

					-- Removing notes if far enough off screen
					if note.y >= SCRORIY + SCRH + note.noteLength/2 + toSCRW(200) or note.y <= SCRORIY - note.noteLength/2 - toSCRW(200) then
						display.remove(note)
						note = nil
					else --Triggering sparkle
						if stages.gameMode == "mm" then
							note.sparkleTime = note.sparkleTime + inpTime - stages.tPrevious
							if note.sparkleTime >= note.nextSparkle then
								note.nextSparkle = 100/stages.speedMod
								note.sparkleTime = 0
								explosions.new("meteorstream", note.x + toSCRW(math.random(-30, 30)), 
									note.y + note.direction*math.random(1, (note.noteLength/1.5)/stages.speedMod), 0.5, note.direction, stages.sceneGroup)
							end
						end
						note:toFront()
					end
				end
			end

			if stages.tempScoreText then
				if stages.tempScoreText.alpha > 0 then
					stages.tempScoreText.alpha = stages.tempScoreText.alpha - 0.02
				end
			end

			--setting score text
			stages.timeText.text = round(stages.stageTotalTime/1000, 2)
			-- if stages.gameMode == "mm" then stages.timeText.text = tostring(stages.dodgeCount) end
			stages.timeText:toFront()
			if stages.timeTextTop then
				stages.timeTextTop.text = stages.timeText.text
				stages.timeTextTop:toFront()
			end

		else -- Game over effects go here
			stages.inGameMenu:toFront()

			-- Making earth and aura dissapear
			if stages.gameMode == "mm" then
				if stages.playerSquare then
					stages.playerSquare.alpha = stages.playerSquare.alpha - 0.03
					if stages.playerSquare.alpha <= 0 then
						display.remove(stages.playerSquare)
						stages.playerSquare = nil
					end
				end
				if stages.playerAura then
					stages.playerAura.alpha = stages.playerAura.alpha - 0.03
					if stages.playerAura.alpha <= 0 then
						display.remove(stages.playerAura)
						stages.playerAura = nil
					end
				end
			end

			for i, note in ipairs(stages.notes) do
				if note.alpha then
					if note.alpha > 0 then
						note.alpha = note.alpha - 0.01
					end
				end
			end

			if stages.gameMode == "mm" or stages.gameMode == "classic" then
				stages.timeText.text = finalScore.text
			else
				if stages.timeText then display.remove(stages.timeText) stages.timeText = nil end
				if stages.timeTextTop then display.remove(stages.timeTextTop) stages.timeTextTop = nil end
			end

			if stages.inGameMenu.y <= 0 then
				stages.inGameMenu.y = stages.inGameMenu.y + -(stages.inGameMenu.y)/10
			end
			--Removing game over display and returning to main menu after game over
			-- if stages.stageTotalTime >= 3000 then
			-- 	display.remove(stages.gameOverDisplay)
			-- 	stages.gameOverDisplay = nil
			-- 	stages.gameStarted = false
	  --      		composer.gotoScene( "mainmenu", "slideRight", 700)
	  --      end
	   end
	end
	for i, glow in ipairs(stages.glows) do
		if glow.alpha then
			glow.alpha = glow.alpha - 0.03
			if glow.alpha <= 0 then
				display.remove(glow)
				glow = nil
			end
		end
	end
	stages.tPrevious = inpTime
end

function stages:pathTest(inpLane, inpLength)
	-- boundsBook = {} 
	-- for theTime = 100, 5000, 100 do
	-- 	freeLanes = {0, 0, 0}
	-- 	for i, item in ipairs(stages.lastLanes) do
	-- 		itemCentre = item[2] + item[3]*(stages.speedMod*theTime + 0.5 * theTime/15000 * theTime^2)
	-- 		if itemCentre + item[3]*item[4] >= SCRORIX + SCRW/2 - toSCRW(50)) and
	-- 			itemCentre - item[3]*item[4] <= SCRORIX + SCRW/2 + toSCRW(50)) then

	-- 	end


	-- 	freeLanesCount = freeLanes[1] + freeLanes[2] + freeLanes[3]
	-- 	if freeLanesCount > 1 then
	-- 		return false
	-- 	end
	-- end
	return true
end

function stages:newNote(origin)

	local tempRand = math.random(3)
	local notePos
	if tempRand == 1 then notePos = SCRORIX + SCRW*1/5 end
	if tempRand == 2 then notePos = SCRORIX + SCRW*1/2 end
	if tempRand == 3 then notePos = SCRORIX + SCRW*4/5 end
	if tempRand == nil then print("ERROR IN NOTE CREATION") end
	local lengthMod = math.random(3)
	local length = toSCRH(lengthMod*50 + 50)


	local channel, sound_object = audio.play(noteSound7)

	if origin == "top" then
		if stages.gameMode == "classic" or stages.gameMode == "mp" then
			newNote = display.newRect(notePos, -toSCRW(100) - length/2, toSCRW(75), length)
			newNote:setFillColor(0.8 - math.random()*0.8, 0.8 - math.random()*0.8, 0.8 - math.random()*0.8)
		elseif stages.gameMode == "mm" then
			newNote = display.newImageRect("artwork/meteor madness/meteor"..tostring(lengthMod)..tostring(math.random(3))..".png", toSCRW(75), length)
			newNote.x, newNote.y = notePos, -toSCRW(100) - length/2
			newNote:setFillColor(0.9 - math.random()*0.5, 0.9 - math.random()*0.5, 0.9 - math.random()*0.5)
		end
		newNote.direction = -1
		al.Source( sound_object, al.PITCH, tempRand-0.5)
	elseif origin == "bottom" then
		if stages.gameMode == "classic" or stages.gameMode == "mp" then
			newNote = display.newRect(notePos, SCRORIY + SCRH + toSCRW(100) + length/2, toSCRW(75), length)
			newNote:setFillColor(0.8 - math.random()*0.8, 0.8 - math.random()*0.8, 0.8 - math.random()*0.8)
		elseif stages.gameMode == "mm" then
			newNote = display.newImageRect("artwork/meteor madness/meteor"..tostring(lengthMod)..tostring(math.random(3))..".png", toSCRW(75), length)
			newNote.x, newNote.y = notePos, SCRORIY + SCRH + toSCRW(100) + length/2
			newNote:setFillColor(0.9 - math.random()*0.5, 0.9 - math.random()*0.5, 0.9 - math.random()*0.5)
		end
		newNote.direction = 1
		al.Source( sound_object, al.PITCH, tempRand)
	else
		print("ERROR with input on newNote", origin)
	end

	if stages.gameMode == "mm" and math.random(2) == 1 then
		newNote.rotation = 180
	end
	stages:newGlow(notePos, origin)

	newNote.anchorY, newNote.anchorX = 0.5, 0.5
	newNote.anchorX, newNote.anchorY = 0.5, 0.5
	newNote.origin = origin
	newNote.type = "note"
	newNote.noteLength = length
	newNote.scoreCounted = false
	newNote.lane = tempRand
	newNote.speedMod = 4
	stages.lastLanes[#stages.lastLanes + 1] = {newNote.lane, newNote.origin, newNote.direction, newNote.noteLength, stages.stageTotalTime}

	stages.sceneGroup:insert(newNote)

	newNote.nextSparkle = math.random(100, 200)
	newNote.sparkleTime = 0
	-- print(stages.lastLanes[#stages.lastLanes][1], stages.lastLanes[#stages.lastLanes][2], stages.lastLanes[#stages.lastLanes][3], stages.lastLanes[#stages.lastLanes][4])
	table.insert(stages.notes, newNote)

end

-- Resets the stages table back to its default state, to allow for a new game
function stages:reset()

	if stages.glows then
		for i, item in ipairs(stages.glows) do
			display.remove(item)
			item = nil
		end
	end

	if stages.notes then
		for i, item in ipairs(stages.notes) do
			display.remove(item)
			item = nil
		end
	end

	for i, item in ipairs(stages) do
		display.remove(item)
		item = nil
	end

	display.remove(stages.timeText)
	stages.timeText = nil

	if stages.playerSquare then display.remove(stages.playerSquare) stages.playerSquare = nil end
	if stages.playerSquareTop then display.remove(stages.playerSquareTop) stages.playerSquareTop = nil end
	if stages.playerSquareBottom then display.remove(stages.playerSquareBottom) stages.playerSquareBottom = nil end

	stages.stageTotalTime = 0
	stages.tPrevious = system.getTimer()
	if stages.playerLane then stages.playerLane = 2 end --1 is left, 2 mid, 3 right
	if stages.playerLaneTop then stages.playerLaneTop = 2 end --1 is left, 2 mid, 3 right
	if stages.playerLaneBottom then stages.playerLaneBottom = 2 end --1 is left, 2 mid, 3 right
	stages.totalLanes = 3
	stages.gameOver = false
	stages.gameStarted = false

	stages.speedMod = 1
	stages.lastNote = 0
	stages.nextNote = 1000

	display.remove(stages.background)
	stages.background = nil
	display.remove(stages.background1)
	stages.background1 = nil
	display.remove(stages.background2)
	stages.background2 = nil

	if stages.inGameMenu then
		display.remove(stages.inGameMenu)
		stages.inGameMenu = nil
	end

	explosions:reset()
end

-- Initiates the game over sequence; sound is played and stages.gameOver handler is set as true
function stages:endGame(winner)
	audio.stop()
	local channel, sound_object = audio.play(noteSound1)
	al.Source( sound_object, al.PITCH, 0.5)

	if stages.gameMode == "mm" then
		stages.playerSquare:pause()
		stages.playerAura:pause()
		explosions.new("basic", stages.playerSquare.x, stages.playerSquare.y, 1, nil, stages.sceneGroup)
	end

	stages.gameOver = true
	print("Game over!")

	stages.inGameMenu = display.newGroup()

	-- score
	if stages.gameMode == "mm" then
		finalScore = display.newText(tostring(round(stages.stageTotalTime/1000, 2)), SCRORIX + SCRW/2, SCRORIY + SCRH*2/10, native.systemFontBold, 100)
		finalScore:setFillColor(1, 1, 1)
	elseif stages.gameMode == "classic" then
		finalScore = display.newText(tostring(round(stages.stageTotalTime/1000, 2)), SCRORIX + SCRW/2, SCRORIY + SCRH*2/10, native.systemFontBold, 100)
		finalScore:setFillColor(0, 0, 0)
	elseif stages.gameMode == "mp" then
		finalScore = display.newText(winner.." wins!", SCRORIX + SCRW/2, SCRORIY + SCRH*2/10, native.systemFontBold, 80)
		if winner == "Red" then finalScore:setFillColor(1, 0, 0)
		elseif winner == "Blue" then finalScore:setFillColor(0, 0, 1) end
	end
	finalScore.anchorX, finalScore.anchorY = 0.5, 0.5
	finalScore.alpha = 0.9
	stages.inGameMenu:insert(finalScore)

	if gameMode ~= "mp" then
		if stages.stageTotalTime/1000 > -foundData["highScore"] then
			finalScore.text = finalScore.text .. ", PB!"
			finalScore.size = 60
			-- highScoreText.text = "High Score: " .. round(stages.stageTotalTime/1000, 2)

			foundData["highScore"] = -roundNum(stages.stageTotalTime/1000, 2)

			loadsave.saveTable(foundData, "savedata.json")
		end
		timer.performWithDelay(100, updateHighscore(foundData["highScore"])) -- Making sure latest high score has been submitted to the server
	end

	-- background rect
	-- tempItem = display.newRect(SCRORIX + SCRW/2, SCRORIY + SCRH/6, SCRW, SCRH/3)
	-- tempItem.anchorX, tempItem.anchorY = 0.5, 0.5
	-- tempItem:setFillColor(0, 0, 0, 0)
	-- if stages.gameMode == "classic" or stages.gameMode == "mp" then
	-- 	tempItem:setFillColor(1, 1, 1, 0)
	-- end
	-- stages.inGameMenu:insert(tempItem)

	-- game over overlay
	tempItem = display.newText("Game Over", SCRORIX + SCRW/2, SCRORIY + SCRH*1/10, native.systemFontBold, 60)
	tempItem.anchorX, tempItem.anchorY = 0.5, 0.5
	tempItem:setFillColor(1, 1, 1)
	if stages.gameMode == "classic" or stages.gameMode == "mp" then
		tempItem:setFillColor(0, 0, 0)
	end
	tempItem.alpha = 0.9
	stages.inGameMenu:insert(tempItem)

	-- menu button
	if stages.gameMode == "mm" then
		tempItem = widget.newButton(
			{
		        width = toSCRW(100),
		        height = toSCRH(100),
		        defaultFile = "artwork/menu items/back to menu button mm.png",
		        overFile = "artwork/menu items/back to menu button over mm.png",
				-- onRelease = postPhoto_onRelease
				onRelease = function()
					composer.gotoScene( "mainmenu", "fromLeft", 500 )
				end
			}
		)
	elseif stages.gameMode == "classic" or stages.gameMode == "mp" then
		tempItem = widget.newButton(
			{
		        width = toSCRW(100),
		        height = toSCRH(100),
		        defaultFile = "artwork/menu items/back to menu button.png",
		        overFile = "artwork/menu items/back to menu button over.png",
				-- onRelease = postPhoto_onRelease
				onRelease = function()
					composer.gotoScene( "mainmenu", "flipFadeOutIn", 100 )
				end
			}
		)
	end
	tempItem.anchorX, tempItem.anchorY = 0.5, 0.5
	tempItem.x, tempItem.y = SCRORIX + SCRW*1/3, SCRORIY + SCRH*3/10
	tempItem.alpha = 0.9
	stages.inGameMenu:insert(tempItem)

	tempFunc = function() stages:startGame() end

	-- replay button
	if stages.gameMode == "mm" then
		tempItem = widget.newButton(
			{
		        width = toSCRW(100),
		        height = toSCRH(100),
		        defaultFile = "artwork/menu items/play again button mm.png",
		        overFile = "artwork/menu items/play again button over mm.png",
				-- onRelease = postPhoto_onRelease
				onRelease = function()
					stages:reset()
					stages:create(stages.gameMode, stages.sceneGroup)
					timer.performWithDelay(500, tempFunc)
				end
			}
		)
	elseif stages.gameMode == "classic" or stages.gameMode == "mp" then
		tempItem = widget.newButton(
			{
		        width = toSCRW(100),
		        height = toSCRH(100),
		        defaultFile = "artwork/menu items/play again button.png",
		        overFile = "artwork/menu items/play again button over.png",
				-- onRelease = postPhoto_onRelease
				onRelease = function()
					stages:reset()
					stages:create(stages.gameMode, stages.sceneGroup)
					timer.performWithDelay(500, tempFunc)
				end
			}
		)
	end
	tempItem.anchorX, tempItem.anchorY = 0.5, 0.5
	tempItem.x, tempItem.y = SCRORIX + SCRW*2/3, SCRORIY + SCRH*3/10
	tempItem.alpha = 0.9
	stages.inGameMenu:insert(tempItem)

	stages.inGameMenu.anchorX, stages.inGameMenu.anchorY = 0, 1
	stages.inGameMenu.x, stages.inGameMenu.y = 0, -SCRH/3

	stages.sceneGroup:insert(stages.inGameMenu)

	--resetting timers
	stages.tPrevious = system.getTimer()

	stages.stageTotalTime = 0
end

return stages

-- https://api.backendless.com/<version>/data/<table-name>/<object-id>