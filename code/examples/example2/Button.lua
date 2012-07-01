Button = {}

function Button:new(label, callback, startX, startY, width, height)
	local group = display.newGroup()
	group.callback = callback
	group.label = label

	local rect = display.newRect(0, 0, width, height)
	rect:setReferencePoint(display.TopLeftReferencePoint)
	rect:setStrokeColor(0, 0, 0)
	rect:setFillColor(255, 255, 255)
	rect.strokeWidth = 2

	local field = display.newText(label, 0, 0, width - 15, height / 2, native.systemFont, 16)
	field:setReferencePoint(display.TopLeftReferencePoint)
	field:setTextColor(0, 0, 0)
	field.y = height / 4
	field.x = (width / 2) - (field.width / 2)

	group:insert(rect)
	group:insert(field)

	function group:touch(event)
		local phase
		if event.phase == "ended" or event.phase == "cancelled" then
			phase = "ended"
		else
			phase = event.phase
		end
		self.callback({name="touch", target=self, label=label, phase=phase})
		return true
	end

	group:addEventListener("touch", group)
	group.x = startX
	group.y = startY
	
	return group
end

return Button