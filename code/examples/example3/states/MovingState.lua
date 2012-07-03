require "com.jessewarden.statemachine.BaseState"
MovingState = {}

function MovingState:new(stateName)
	local state = BaseState:new(stateName)
	state.player = nil
	
	function state:onEnterState(event)
		local player = self.entity
		player.startMoveTime = system.getTimer()
		--player:setDirection(direction)
		--player:showSprite("move")
		
		Runtime:addEventListener("onMoveEnded", self)
		Runtime:addEventListener("onAttackStarted", self)
		Runtime:addEventListener("onJumpLeftStarted", self)
		Runtime:addEventListener("onJumpRightStarted", self)
	end
	
	function state:onExitState(event)
		Runtime:removeEventListener("onMoveEnded", self)
		Runtime:removeEventListener("onAttackStarted", self)
		Runtime:removeEventListener("onJumpLeftStarted", self)
		Runtime:removeEventListener("onJumpRightStarted", self)
	end
	
	function state:tick(time)
		local player = self.entity
		self:handleMove(time)
		if system.getTimer() - player.startMoveTime >= player.MOVE_STAMINA_TIME then
			player.startMoveTime = system.getTimer()
		end
	end
	
	function state:handleMove(time)
		local player = self.entity
		local speed = player.speed
		if speed <= 0 then return true end
		local targetX
		local targetY = player.y
		if player.direction == "right" then
			targetX = player.x + speed
		elseif player.direction == "left" then
			targetX = player.x - speed
		else
			targetX = 0
		end

		local deltaX = player.x - targetX
		local deltaY = player.y - targetY
		local dist = math.sqrt((deltaX * deltaX) + (deltaY * deltaY))
		local moveX = speed * (deltaX / dist) * time
		local moveY = speed * (deltaY / dist) * time

		if (math.abs(moveX) > dist or math.abs(moveY) > dist) then
			player.x = targetX
			player.y = targetY
		else
			player.x = player.x - moveX
			player.y = player.y - moveY
		end
	end
	
	function state:onMoveEnded(event)
		self.stateMachine:changeStateToAtNextTick("ready")
	end
	
	function state:onAttackStarted(event)
		self.stateMachine:changeStateToAtNextTick("attack")
	end
	
	function state:onJumpLeftStarted(event)
		self.stateMachine:changeStateToAtNextTick("jumpLeft")
	end
	
	function state:onJumpRightStarted(event)
		self.stateMachine:changeStateToAtNextTick("jumpRight")
	end
	
	return state
end

return MovingState