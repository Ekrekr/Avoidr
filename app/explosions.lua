---------------------------------------------------------------------------------------
--
-- player.lua
--
-- Player implementation file
--
---------------------------------------------------------------------------------------

local explosions = {}

-------------------------------------------------
-- PRIVATE FUNCTIONS
-------------------------------------------------

local explosionSequences = {{name = "slow", frames = {21,20,19,18,17,16,15,14,13,12,11,10,9,8,7,6,5,4,3,2,1}, loopCount=1, time = 2000}}

local meteorStreamSequences = {{name = "slow", frames = {1,2,3,4,5,6,7,8}, loopCount=1, time = 400}}


local rambowExplosionSheet = graphics.newImageSheet("artwork/explosions/big explosion.png", {width = 328, height = 328, numFrames = 21})

local meteorStreamSheet = graphics.newImageSheet("artwork/explosions/meteorstream.png", {width = 50, height = 200, numFrames = 8})

explosionSound = audio.loadSound("audio/sound effects/explosion sound.mp3")

--Audio
-------------------------------------------------
-- PUBLIC FUNCTIONS
-------------------------------------------------

function explosions.new(explosionType, xPos, yPos, extraScale, direction, sceneGroup)
	local newExplosion = nil

	if explosionType == "basic" then
		newExplosion = display.newSprite(rambowExplosionSheet, explosionSequences) 
		newExplosion.anchorX, newExplosion.anchorY = 43/100, 48/100
		newExplosion.requiredTime = 2000
		newExplosion.rotation = math.random(1, 360)
		if direction == nil then audio.play(explosionSound) end
	elseif explosionType == "meteorstream" then
		newExplosion = display.newSprite(meteorStreamSheet, meteorStreamSequences) 
		newExplosion.anchorX, newExplosion.anchorY = 0.5, 0.5
		newExplosion.requiredTime = 400
		newExplosion.alpha = 0.5
		if direction == -1 then
			newExplosion.rotation = 180
		else
			newExplosion.rotation = 0
		end
	end

	if extraScale then
		newExplosion:scale(extraScale, extraScale)
	end

	newExplosion.x, newExplosion.y = xPos, yPos

	newExplosion.type = explosionType

	newExplosion.inceptionTime = runtimeTime

	newExplosion:setSequence("slow")
	newExplosion:play()

	if sceneGroup ~= nil then
		sceneGroup:insert(newExplosion)
	end

	newExplosion.reset = function()
		display.remove(newExplosion)
		newExplosion = nil
	end


	table.insert(explosions, newExplosion)
	return newExplosion
end

function explosions:tick(event)
	for i, explosion in ipairs(explosions) do
		if explosion then
			if event.time >= explosion.inceptionTime + explosion.requiredTime then
				-- print(event.time, explosion.inceptionTime, explosion.requiredTime)
				explosion.reset()
			end
		end
	end
end

function explosions:reset()
	for i, explosion in ipairs(explosions) do
		if explosion then
			display.remove(explosion)
			explosion = nil
		end
	end
end

return explosions
