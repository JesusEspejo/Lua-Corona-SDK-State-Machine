require "com.jessewarden.components.ProgressBar"

TopHud = {}

function TopHud:new()

	local hud = display.newGroup()

	local speedField = display.newText("Speed:", 4, 4, 70, 30, native.systemFont, 16)
	speedField:setReferencePoint(display.TopLeftReferencePoint)
	speedField:setTextColor(255, 255, 255)
	hud.speedField = speedField
	hud:insert(speedField)

	local speedBar = ProgressBar:new(0, 20, 169, 0, 100, 255, 100, 10)
	hud.speedBar = speedBar
	hud:insert(speedBar)

	local defenseField = display.newText("Defense: ", 0, 0, 70, 30, native.systemFont, 16)
	defenseField:setReferencePoint(display.TopLeftReferencePoint)
	defenseField:setTextColor(255, 255, 255)
	hud.defenseField = defenseField
	hud:insert(defenseField)
	
	local defenseBar = ProgressBar:new(0, 100, 0, 0, 255, 0, 100, 10)
	hud.defenseBar = defenseBar
	hud:insert(defenseBar)

	speedField.x = 0
	speedField.y = 0

	speedBar.x = speedField.x + speedField.width + 4
	speedBar.y = speedField.y + (speedField.height / 2) - (speedBar.height)

	defenseField.x = 0
	defenseField.y = speedField.y + speedField.height

	defenseBar.x = defenseField.x + defenseField.width + 4
	defenseBar.y = defenseField.y + (defenseField.height / 2) - (defenseBar.height)

	function hud:setWarBot(warBot)
		if self.warBot then
			self.warBot:removeEventListener("onSpeedChanged", self)
			self.warBot:removeEventListener("onDefenseChanged", self)
		end
		self.warBot = warBot
		if self.warBot then
			self.warBot:addEventListener("onSpeedChanged", self)
			self.warBot:addEventListener("onDefenseChanged", self)
			self:onSpeedChanged()
			self:onDefenseChanged()
		end
	end

	function hud:onSpeedChanged(event)
		speedBar:setProgress(warBot.speed, warBot.maxSpeed)
	end

	function hud:onDefenseChanged(event)
		defenseBar:setProgress(warBot.defense, warBot.maxDefense)
	end

	return hud

end

return TopHud