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

function showProps(o)
	print("-- showProps --")
	print("o: ", o)
	for key,value in pairs(o) do
		print("key: ", key, ", value: ", value);
	end
	print("-- end showProps --")
end

function startGame()
	gameLoop = GameLoop:new()
	gameLoop:start()

	warBot = WarBot:new()
	warBot.x = 100
	warBot.y = 100

	stage = display.getCurrentStage()

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
	topHud.y = 40
end

function onEnterScout()
	warBot:showSprite("scout")
	warBot:setSpeed(4)
end

function onEnterScoutLeft()
	warBot:showSprite("scoutLeft")
	warBot:setDirection("left")
end

function onExitScoutLeft()
	warBot:showSprite("scout")
end

function onEnterScoutRight()
	warBot:showSprite("scoutRight")
	warBot:setDirection("right")
end

function onExitScoutRight()
	warBot:showSprite("scout")
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
	-- TODO: roll left
end

function onExitAssfaultLeft()
	-- TODO: stop roll left
end

function onEnterAssaultRight()
	warBot:setDirection("right")
	-- TODO: roll right
end

function onExitAssaultRight()
	-- TODO: stop roll right
end

function onEnterSightState()
	warBot:showSprite("sight")
	warBot:setSpeed(0)
end

function onExitSightState()
	warBot:showSprite("sightReverse")
	warBot:setSpeed(8)
end

function onEnterSniperState()
	warBot:showSprite("sniper")
	warBot:setSpeed(0)
end

function onExitSniperState()
	warBot:showSprite("sniperReverse")
	warBot:setSpeed(8)
end

function onEnterArtilleryState()
	warBot:showSprite("artillery")
	warBot:setSpeed(0)
end

function onExitArtilleryState()
	warBot:showSprite("artilleryReverse")
	warBot:setSpeed(8)
end


startGame()