-- Code from https://github.com/JesterXL/Lua-Corona-SDK-State-Machine/blob/master/code/examples/example2/com/jessewarden/components/ProgressBar.lua
-- Modified by @JesusEspejo
-- Adjustment done to keep compatibility with Corona’s Graphics 2.0 
ProgressBar = {} 
function ProgressBar:new(backRed, backGreen, backBlue, frontRed, frontGreen, frontBlue, startWidth, startHeight)
	local group = display.newGroup()
	local frontBarOriginX = startWidth / 2

	-- 35, 6 are good defaults
	local backBar = display.newRect(0, 0, startWidth, startHeight)
	group:insert(backBar)
	backBar:setFillColor(backRed, backGreen, backBlue)
	backBar:setStrokeColor(0, 0, 0)
	backBar.strokeWidth = 1
 
	local frontBar = display.newRect(0, 0, startWidth, startHeight)
	frontBar.x = 0 - frontBarOriginX
	group:insert(frontBar)
	frontBar:setFillColor(frontRed, frontGreen, frontBlue)
	frontBar:setStrokeColor(0, 0, 0)
	frontBar.strokeWidth = 1
 
	function group:setProgress(current, max)
		if current == nil then
			error("parameter 'current' cannot be nil.")
		end

		if max == nil then
			error("parameter 'max' cannot be nil")
		end
		
		local percent = current / max

		-- Avoiding current to surpass extension
		if (percent > 1) then
			percent = 1
		end

		-- Applying calculated percentage
		local desiredWidth = startWidth * percent
		if percent ~= 0 then
			frontBar.width = desiredWidth
			frontBar.isVisible = true
		else
			frontBar.isVisible = false
		end
		-- Relocating frontBar depending on the 
		frontBar.x = 0 - frontBarOriginX + desiredWidth / 2
	end
 
	return group
end
 
return ProgressBar
