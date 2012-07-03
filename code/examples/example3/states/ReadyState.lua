require "com.jessewarden.statemachine.BaseState"
ReadyState = {}

function ReadyState:new()
	local state = BaseState:new("ready")
	state.recharge = nil
	state.startRestTime = nil
	state.elapsedRestTime = nil
	
	function state:onEnterState(event)
		local player = self.entity
		self.recharge = false
		
		self:reset()
		
		player:showSprite("stand")
		
		Runtime:addEventListener("onMoveLeftStarted", self)
		Runtime:addEventListener("onMoveRightStarted", self)
		Runtime:addEventListener("onAttackStarted", self)
		Runtime:addEventListener("onJumpLeftStarted", self)
		Runtime:addEventListener("onJumpRightStarted", self)
	end
	
	function state:onExitState(event)
		Runtime:removeEventListener("onMoveLeftStarted", self)
		Runtime:removeEventListener("onMoveRightStarted", self)
		Runtime:removeEventListener("onAttackStarted", self)
		Runtime:removeEventListener("onJumpLeftStarted", self)
		Runtime:removeEventListener("onJumpRightStarted", self)
	end
	
	function state:tick(time)
		local player = self.entity
		self.elapsedRestTime = self.elapsedRestTime + time
		if self.elapsedRestTime >= player.INACTIVE_TIME then
			self.stateMachine:changeStateToAtNextTick("resting")
		end
	end
	
	function state:reset()
		self.startRestTime = system.getTimer()
		self.elapsedRestTime = 0
		self.recharge = false
	end
	
	function state:onMoveLeftStarted(event)
		self.stateMachine:changeStateToAtNextTick("movingLeft")
	end
	
	function state:onMoveRightStarted(event)
		print("ReadyState::onMoveRightStarted")
		self.stateMachine:changeStateToAtNextTick("movingRight")
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
	
	function state:onHealButtonTouch(event)
		self.stateMachine:changeStateToAtNextTick("selfHeal")
	end

	return state
end

return ReadyState