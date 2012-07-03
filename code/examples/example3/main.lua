require "physics"
require "GameLoop"
require "sprite"
require "Player"
require "ButtonsController"
require "Wall"

function startGame()
	physics.setDrawMode("normal")
	physics.start()
	physics.setGravity(0, 9.8)
	physics.setPositionIterations(10)

	gameLoop = GameLoop:new()
	gameLoop:start()
	
	stage = display.getCurrentStage()

	backgroundRect = display.newRect(0, 0, stage.width, stage.height)
	backgroundRect:setFillColor(240, 240, 240)

	leftWall = Wall:new(-58, 0, 60, 500)
	rightWall = Wall:new(stage.width - 2, 0, 60, 500)
	floor = Wall:new(0, stage.height - 40, 700, 60)

	player = Player:new(gameLoop)
	player.x = 100
	player.y = 200

	buttons = ButtonsController:new()
	buttons:init()
	buttons.x = 4
	buttons.y = stage.height - buttons.height + 4

end

startGame()