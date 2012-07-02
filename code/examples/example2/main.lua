--[[

	StateMachine Example 2

	The following example is a robot that has many attack & defense modes.
	It illustrates how you can define parent/child states that help ensure you're
	Entity must go back to a parent state first before it can go to another
	state. The StateMachine will throw errors if you attempt to go one state
	to another that it's not allowed to go to help you find bugs in your code.
	It also helps share initialziations that are common across a parent
	state or "mode".

]]--

require "sprite"
require "GameLoop"
require "com.jessewarden.statemachine.StateMachine"
require "WarBot"
require "Button"
require "ButtonsController"
require "TopHud"
require "physics"
require "Wall"

function showProps(o)
	print("-- showProps --")
	print("o: ", o)
	for key,value in pairs(o) do
		print("key: ", key, ", value: ", value);
	end
	print("-- end showProps --")
end

function startGame()
	physics.setDrawMode("normal")
	physics.start()
	physics.setGravity(0, 9.8)
	physics.setPositionIterations(10)

	gameLoop = GameLoop:new()
	gameLoop:start()
	
	stage = display.getCurrentStage()

	backgroundRect = display.newRect(0, 0, stage.width, stage.height)
	backgroundRect:setFillColor(40, 40, 40)

	warBot = WarBot:new()
	warBot.x = 100
	warBot.y = 100
	gameLoop:addLoop(warBot)

	

	leftWall = Wall:new(-58, 0, 60, 500)
	rightWall = Wall:new(stage.width - 2, 0, 60, 500)
	floor = Wall:new(0, stage.height - 40, 700, 60)

	buttons = ButtonsController:new()
	buttons:init()
	buttons.y = stage.contentHeight - 30

	botFSM = StateMachine:new()
	
	botFSM:addState("scout", {from={"defend", "assault"}, enter=onEnterScout})
	botFSM:addState("scoutLeft", {parent="scout", from="scoutRight", enter=onEnterScoutLeft, exit=onExitScoutLeft})
	botFSM:addState("scoutRight", {parent="scout", from="scoutLeft", enter=onEnterScoutRight, exit=onExitScoutRight})
	
	botFSM:addState("defend", {from={"scout", "assault"}, enter=onEnterDefendState, exit=onExitDefendState})
	
	botFSM:addState("assault", {from={"scout", "defend"}, enter=onEnterAssaultState, exit=onExitAsstaultState})
	botFSM:addState("assaultLeft", {parent="assault", from="assaultRight", enter=onEnterAssaultLeft, exit=onExitAssaultLeft})
	botFSM:addState("assaultRight", {parent="assault", from="assaultLeft", enter=onEnterAssaultRight, exit=onExitAssaultRight})
	botFSM:addState("sight", {parent="assault", from={"sniper", "artillery"}, enter=onEnterSightState, exit=onExitSightState})
	botFSM:addState("sniper", {parent="assault", from={"sight", "artillery"}, enter=onEnterSniperState, exit=onExitSniperState})
	botFSM:addState("artillery", {parent="assault", from={"sniper", "sight"}, enter=onEnterArtilleryState, exit=onExitArtilleryState})

	botFSM:setInitialState("scout")

	buttons:setStateMachine(botFSM)

	topHud = TopHud:new()
	topHud:setWarBot(warBot)
	topHud.x = 4
	topHud.y = 30

end

function onEnterScout()
	warBot:showSprite("scout")
	warBot:setSpeed(4)
end

function onEnterScoutLeft()
	warBot:showSprite("scoutLeft")
	warBot:setDirection("left")
	warBot:startMoving()
end

function onExitScoutLeft()
	warBot:showSprite("scout")
	warBot:stopMoving()
end

function onEnterScoutRight()
	warBot:showSprite("scoutRight")
	warBot:setDirection("right")
	warBot:startMoving()
end

function onExitScoutRight()
	warBot:showSprite("scout")
	warBot:stopMoving()
end

function onEnterDefendState()
	warBot:showSprite("defend")
	warBot:setDefense(10)
	warBot:setSpeed(0)
end

function onExitDefendState()
	warBot:setDefense(1)
end

function onEnterAssaultState()
	warBot:showSprite("assault")
	warBot:setSpeed(8)
end

function onEnterAssaultLeft()
	warBot:setDirection("left")
	warBot:setDirection("left")
	warBot:startMoving()
end

function onExitAssaultLeft()
	warBot:stopMoving()
end

function onEnterAssaultRight()
	warBot:setDirection("right")
	warBot:startMoving()
end

function onExitAssaultRight()
	warBot:stopMoving()
end

function onEnterSightState()
	warBot:showSprite("sight")
	warBot:setSpeed(0)
	warBot:startTrackingSight()
end

function onExitSightState()
	warBot:showSprite("sightReverse")
	warBot:setSpeed(8)
	warBot:stopTrackingSight()
end

function onEnterSniperState()
	warBot:showSprite("sniper")
	warBot:setSpeed(0)
	warBot:startSniperShooting()
end

function onExitSniperState()
	warBot:showSprite("sniperReverse")
	warBot:setSpeed(8)
	warBot:stopSniperShooting()
end

function onEnterArtilleryState()
	warBot:showSprite("artillery")
	warBot:setSpeed(0)
	warBot:startArtillery()
end

function onExitArtilleryState()
	warBot:showSprite("artilleryReverse")
	warBot:setSpeed(8)
	warBot:stopArtillery()
end


startGame()