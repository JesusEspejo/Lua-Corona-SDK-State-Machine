Wall = {}

function Wall:new(startX, startY, startWidth, startHeight)

	local wall = display.newRect(startX, startY, startWidth, startHeight)
	wall.classType = "Wall"
	wall:setFillColor(100, 0, 0)
	wall:setReferencePoint(display.TopLeftReferencePoint)
	physics.addBody(wall, "static", {density=2, friction=0.6, bound=0.1})
	return wall

end

return Wall