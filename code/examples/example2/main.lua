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
end

function onEnterScout()
	warBot:showSprite("scout")
	warBot:setSpeed(6)
end

function onEnterScoutLeft()
	warBot:showSprite("scout", "left")
end

function onExitScoutLeft()
	warBot:showSprite("scout")
end

function onEnterScoutRight()
	warBot:showSprite("scout", "right")
end

function onExitScoutRight()
	warBot:showSprite("scout")
end

function onEnterDefendState()
	warBot:showSprite("defend")
	warBot:setDefense(10)
end

function onExitDefendState()
	warBot:setDefense(4)
end

function onEnterAssaultState()
	warBot:showSprite("assault")
end

function onEnterAssaultLeft()
	warBot:showSprite("assault", "left")
	-- TODO: roll left
end

function onExitAssfaultLeft()
	-- TODO: stop roll left
end

function onEnterAssaultRight()
	warBot:showSprite("assault", "right")
	-- TODO: roll right
end

function onExitAssaultRight()
	-- TODO: stop roll right
end


startGame()