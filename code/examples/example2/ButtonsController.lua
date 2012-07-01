ButtonsController = {}

function ButtonsController:new()

	local buttons = display.newGroup()
	buttons.stateMachine = nil

	function buttons:init()
		local defaultCallback = function(e)self:onButtonClick(e)end

		local buttonWidth = 80
		local buttonHeight = 40

		local walkLeftButton = Button:new("Left", function(e)self:onMoveLeft(e)end, 4, 0, buttonWidth, buttonHeight)
		local walkRightButton = Button:new("Right", function(e)self:onMoveRight(e)end, walkLeftButton.x + walkLeftButton.width + 4, walkLeftButton.y, buttonWidth, buttonHeight)
		local defendButton = Button:new("Defend", function(e)self:onDefend(e)end, walkRightButton.x + walkRightButton.width + 4, walkRightButton.y, buttonWidth, buttonHeight)
		local attackButton = Button:new("Attack", function(e)self:onAssault(e)end, defendButton.x + defendButton.width + 4, defendButton.y, buttonWidth, buttonHeight)
		
		local scoutButton = Button:new("Scout", function(e)self:onScout(e)end, 4, walkLeftButton.y - walkLeftButton.height - 4, buttonWidth, buttonHeight)


		self:insert(walkLeftButton)
		self:insert(walkRightButton)
		self:insert(defendButton)
		self:insert(attackButton)

		self:insert(scoutButton)

		self.walkLeftButton = walkLeftButton
		self.walkRightButton = walkRightButton
		self.defendButton = defendButton
		self.attackButton = attackButton

		self.scoutButton = scoutButton
	end

	function buttons:setStateMachine(fsm)
		if self.stateMachine then
			self.stateMachine:removeEventListener("onStateMachineStateChanged", self)
		end
		self.stateMachine = fsm
		if fsm then
			fsm:addEventListener("onStateMachineStateChanged", self)
		end
		self:onStateMachineStateChanged()
	end

	function buttons:hideAllButtons()
		self.walkLeftButton.isVisible = false
		self.walkRightButton.isVisible = false
		self.defendButton.isVisible = false
		self.attackButton.isVisible = false
		self.scoutButton.isVisible = false
	end

	function buttons:onStateMachineStateChanged(event)
		local state = self.stateMachine.state
		print("state: ", state)
		self:hideAllButtons()
		if state == "scout" or state == "scoutLeft" or state == "scoutRight" then
			self.walkLeftButton.isVisible = true
			self.walkRightButton.isVisible = true
			self.defendButton.isVisible = true
			self.attackButton.isVisible = true
		elseif state == "defend" then
			self.defendButton.isVisible = true
		elseif state == "assault" then
			self.walkLeftButton.isVisible = true
			self.walkRightButton.isVisible = true
			self.defendButton.isVisible = true
			self.scoutButton.isVisible = true
		elseif state == "assaultLeft" or state == "assaultRight" then
			self.walkLeftButton.isVisible = true
			self.walkRightButton.isVisible = true
			self.scoutButton.isVisible = true
		end

	end

	function buttons:onMoveLeft(event)
		local sm = self.stateMachine
		if event.phase == "began" then
			if sm.state == "assault" then
				sm:changeState("assaultLeft") 
			else
				sm:changeState("scoutLeft")
			end
		elseif event.phase == "ended" or event.phase == "cancelled" then
			if sm.state == "assaultLeft" then
				sm:changeState("assault")
			else
				sm:changeState("scout")
			end
		end
	end

	function buttons:onMoveRight(event)
		local sm = self.stateMachine
		if event.phase == "began" then
			if sm.state == "assault" then
				sm:changeState("assaultRight") 
			else
				sm:changeState("scoutRight")
			end
		elseif event.phase == "ended" or event.phase == "cancelled" then
			if sm.state == "assaultRight" then
				sm:changeState("assault")
			else
				sm:changeState("scout")
			end
		end
	end

	function buttons:onDefend(event)
		if event.phase == "began" then
			self.stateMachine:changeState("defend")
		elseif event.phase == "ended" then
			self.stateMachine:changeState(self.stateMachine.previousState)
		end
	end

	function buttons:onAssault(event)
		if event.phase == "began" then
			self.stateMachine:changeState("assault")
		end
	end

	function buttons:onScout(event)
		if event.phase == "ended" then
			self.stateMachine:changeState("scout")
		end
	end



	return buttons
end

return ButtonsController