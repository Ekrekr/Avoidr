---------------------------------------------------------------------------------------
--
-- player.lua
--
-- Player implementation file
--
---------------------------------------------------------------------------------------

local playerGroup = {}
playerGroup.anchorX, playerGroup.anchorY = 0.5, 1
playerGroup.movingDown = false
playerGroup.centered = true

-------------------------------------------------
-- PRIVATE FUNCTIONS
-------------------------------------------------

--Audio
local deathCry = audio.loadSound("audio/sound effects/projectile launches/arrow shot.mp3")

basicCatSequences = { 
	{ 
		name = "stand", 
		start = 1, 
	},
	{ 
		name = "crouch", 
		start = 2, 
	},
}
catSheetOptions = {width = 160, height = 157, numFrames = 2}
catSheet = graphics.newImageSheet("artwork/cats/cat idle.png", catSheetOptions)

-------------------------------------------------
-- PUBLIC FUNCTIONS
-------------------------------------------------

function playerGroup:createPlayer()
	display.setDefault("anchorX", 0.5)	-- default to TopLeft anchor point for new objects
	display.setDefault("anchorY", 1)

	player = display.newSprite(catSheet, basicCatSequences)

	player.x, player.y = SCRORIX + SCRW/2, SCRORIY + SCRH/2
	player.lastX, player.lastY =  SCRORIX + SCRW/2, SCRORIY + SCRH/2
	player.changeX, player.changeY = 0.0, 0.0
	player.yAcceleration = 0.98
	player.ySpeed = 0.0

	player.fixedRotation = true
	player:setSequence("normalRun")
	player:play()
	player.name = "player"
	player.type = "player"

	player.bounce = function()
		-- player:setLinearVelocity(0, -500)
	end

	player.gravityScale = 0

	table.insert(playerGroup, player)

	return player
end

function playerGroup:reset()
	-- playerGroup:removeSelf()
	-- display.remove(playerGroup)
end

function playerGroup:bounce(speedMod)
	for i, player in ipairs(playerGroup) do
		player.ySpeed = -speedMod
		-- stages.y = stages.y + player.ySpeed
	end
end

-- function playerGroup:directionFlip(inpAngle)
-- 	playerGroup[1]:pause()
-- 	playerGroup[1]:setSequence("normalRun")
-- 	playerGroup[1]:play()
-- 	-- playerItem:play()
-- 	if inpAngle < 0 then
-- 		if playerGroup.currentRot == true then
-- 			playerGroup.currentRot = false
-- 			playerGroup:scale(-1, 1)
-- 		end
-- 	else
-- 		if playerGroup.currentRot == false then
-- 			playerGroup:scale(-1, 1)
-- 			playerGroup.currentRot = true
-- 		end
-- 	end
-- end

function playerGroup:tick(event)
	local ySpeed = 0

	for i, player in ipairs(playerGroup) do
		if player.y then
			player:toFront()
			player.ySpeed = player.ySpeed + player.yAcceleration
			stages.y = stages.y - player.ySpeed
			if player.ySpeed >= 0 then
				player:setSequence("crouch")
				player:play()
			else
				player:setSequence("stand")
				player:play()
			end
		end
	end		
end

function playerGroup:touchEvent(event)
	for i, player in ipairs(playerGroup) do
		player.x = event.x
		player.bounce()
	end
end

function playerGroup:die()
	-- if playerGroup[1] then
	-- 	playerGroup[1]:setSequence("death")
	-- 	playerGrou[1]:play()
	-- end
end



return playerGroup
