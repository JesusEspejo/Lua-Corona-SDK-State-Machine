require "com.jessewarden.statemachine.BaseState"

AttackState = {}

function AttackState:new()
	
	local state = BaseState:new("attack")
	state.startTime = nil
	
	function state:onEnterState(event)
		self.startTime = system.getTimer()
		local player = self.entity
		player:addEventListener("onAttackAnimationCompleted", self)
		player:showSprite("attack")
	end

	function state:onExitState(event)
		local player = self.entity
		player:removeEventListener("onAttackAnimationCompleted", self)
		player:showSprite("stand")
	end

	function state:onAttackAnimationCompleted(event)
		self.entity:showSprite("stand")
		self.stateMachine:changeStateToAtNextTick("ready")
	end
	
	return state
	
end

return AttackState