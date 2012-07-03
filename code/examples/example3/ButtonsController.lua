require "Button"

ButtonsController = {}

function ButtonsController:new()

	local buttons = display.newGroup()

	function buttons:init()
		local buttonWidth = 80
		local buttonHeight = 40
		local defaultHandler = function(event)
								local label = event.label
								if event.phase == "began" then
									if label == "Left" then
										Runtime:dispatchEvent({name="onMoveLeftStarted"})
									elseif label == "Right" then
										Runtime:dispatchEvent({name="onMoveRightStarted"})
									elseif label == "Attack" then
										Runtime:dispatchEvent({name="onAttackStarted"})
									elseif label == "Jump Left" then
										Runtime:dispatchEvent({name="onJumpLeftStarted"})
									elseif label == "Jump Right" then
										Runtime:dispatchEvent({name="onJumpRightStarted"})
									end
								elseif event.phase == "ended" then
									if label == "Left" then
										Runtime:dispatchEvent({name="onMoveEnded"})
									elseif label == "Right" then
										Runtime:dispatchEvent({name="onMoveEnded"})
									end
								end
							end

		local walkLeftButton = Button:new("Left", defaultHandler, 0, 0, buttonWidth, buttonHeight)
		local walkRightButton = Button:new("Right", defaultHandler, 0, 0, buttonWidth, buttonHeight)
		local attackButton = Button:new("Attack", defaultHandler, 0, 0, buttonWidth, buttonHeight)
		local jumpLeftButton = Button:new("Jump Left", defaultHandler, 0, 0, buttonWidth + 20, buttonHeight)
		local jumpRightButton = Button:new("Jump Right", defaultHandler, 0, 0, buttonWidth + 20, buttonHeight)

		self:insert(walkLeftButton)
		self:insert(walkRightButton)
		self:insert(attackButton)
		self:insert(jumpLeftButton)
		self:insert(jumpRightButton)

		jumpLeftButton.x = 0

		walkLeftButton.x = jumpLeftButton.x + jumpLeftButton.width + 4

		attackButton.x = walkLeftButton.x + walkLeftButton.width + 4

		walkRightButton.x = attackButton.x + attackButton.width + 4

		jumpRightButton.x = walkRightButton.x + walkRightButton.width + 4

		self.walkLeftButton = walkLeftButton
		self.walkRightButton = walkRightButton
		self.attackButton = attackButton
		self.jumpLeftButton = jumpLeftButton
		self.jumpRightButton = jumpRightButton
	end

	return buttons
end

return ButtonsController