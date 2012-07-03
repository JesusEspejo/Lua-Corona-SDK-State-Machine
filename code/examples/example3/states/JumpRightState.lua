require "states.JumpState"

JumpRightState = {}

function JumpRightState:new()
	local state = JumpState:new("jumpRight")
	
	state.superOnEnterState = state.onEnterState
	function state:onEnterState(event)
		print("JumpRightState::onEnterState")
		self:superOnEnterState(event)
		
		local player = self.entity
		player:setDirection("right")
		--local multiplier = 60
		--player:applyForce(xForce* multiplier, self.jumpForce * multiplier, 40, 32)
	end
	
	state.superOnExitState = state.onExitState
	function state:onExitState(event)
		local player = self.entity
		player:applyLinearImpulse(player.jumpForwardForce / 3, 0, 40, 32)
		self:superOnExitState(event)
	end
	
	state.superTick = state.tick
	function state:tick(time)
		local player = self.entity
		player.x = player.x + player.jumpForwardForce
		self:superTick(time)
	end
	
	return state
	
end

return JumpRightState