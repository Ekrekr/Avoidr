-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- hide the status bar
display.setStatusBar( display.HiddenStatusBar )

-- local declarations for constants based on screen size
SCRW, SCRH, halfW, halfH = display.actualContentWidth, display.actualContentHeight, display.contentCenterX, display.contentCenterY
SCRORIX, SCRORIY = display.screenOriginX, display.screenOriginY

-- include the Corona "composer" module
local composer = require "composer"
-- for debugging
function printTable(inpTable)
	for k, v in pairs( inpTable ) do
   		print(k, v)
   	end
end

function checkInTable(inpTable, searchItem)
	for i, item in ipairs(inpTable) do
		if item == searchItem then
			return true
		end
	end
	return false
end

local systemFonts = native.getFontNames()
-- print("@@@@@")
-- printTable(systemFonts)
-- print("@@@@@")
function toSCRW(inpPixels, scale)
	if scale == nil then scale = 1 end
	return ((inpPixels/540) * SCRW * scale) 
end

function toSCRH(inpPixels, scale)
	if scale == nil then scale = 1 end
	return ((inpPixels/960) * SCRH * scale) 
end

function round(num, idp)
	local mult = 10^(idp or 0)
	num = math.floor(num * mult + 0.5) / mult
	if num % 1 == 0 then
		return tostring(num)..".0"
	elseif num % 0.1 == 0 then
		return tostring(num).."0"
	else
		return tostring(num)
	end
end

function roundNum(num, idp)
	local mult = 10^idp
	return math.floor(num * mult + 0.5) / mult
end

function reverseTable(t)
    local reversedTable = {}
    local itemCount = #t
    for k, v in ipairs(t) do
        reversedTable[itemCount + 1 - k] = v
    end
    return reversedTable
end

-- load menu screen
composer.gotoScene("nickname")