require "com.jessewarden.statemachine.StateMachine"

require "states.ReadyState"
require "states.RestingState"
require "states.MovingRightState"
require "states.MovingLeftState"
require "states.JumpLeftState"
require "states.JumpRightState"
require "states.AttackState"

Player = {}

function Player:new(gameLoop)
	
	if Player.sheet == nil then
		local sheet = sprite.newSpriteSheet("player_jesterxl_sheet.png", 64, 64)
		local standSet = sprite.newSpriteSet(sheet, 1, 6)
		sprite.add(standSet, "PlayerStand", 1, 6, 1000, 0)
		local moveSet = sprite.newSpriteSet(sheet, 9, 8)
		sprite.add(moveSet, "PlayerMove", 1, 8, 500, 0)
		local jumpSet = sprite.newSpriteSet(sheet, 17, 6)
		sprite.add(jumpSet, "PlayerJump", 1, 6, 600, 1)
		local attackSet = sprite.newSpriteSet(sheet, 25, 6)
		sprite.add(attackSet, "PlayerAttack", 1, 6, 300, 1)
		local hangSet = sprite.newSpriteSet(sheet, 31, 1)
		sprite.add(hangSet, "PlayerHang", 1, 1, 1000)
		
		Player.sheet = sheet
		Player.standSet = standSet
		Player.moveSet = moveSet
		Player.jumpSet = jumpSet
		Player.attackSet = attackSet
		Player.hangSet = hangSet
	end

	local player = display.newGroup()
	player.spriteHolder = display.newGroup()
	player:insert(player.spriteHolder)

	--local bg = display.newRect(0, 0, 64, 64)
	--bg:setFillColor(255, 0, 0, 100)
	--player:insert(bg)

	player.startMoveTime = nil
	player.MOVE_STAMINA_TIME = 500
	player.jumpForwardForce = 3
	player.jumpForce = 1
	player.JUMP_INTERVAL = 100
	player.jumpGravity = nil
	player.jumpStartY = nil
	player.lastJump = nil
	player.speed = 3
	player.INACTIVE_TIME = 3000
	player.REST_TIME = 2000
	player.lastSprite = nil

	function player:setDirection(dir)
		self.direction = dir
		assert(self.direction ~= nil, "You cannot set direction to a nil value.")
		local spriteHolder = player.spriteHolder
		if dir == "right" then
			spriteHolder.xScale = 1
			spriteHolder.x = 0
		else
			spriteHolder.xScale = -1
			spriteHolder.x = spriteHolder.width
		end
	end

	function player:showSprite(name)
		if name == self.lastSprite then return true end
		self.lastSprite = name
		local spriteAnime
		if name == "move" then
			spriteAnime = sprite.newSprite(Player.moveSet)
			spriteAnime:prepare("PlayerMove")
		elseif name == "jump" then
			spriteAnime = sprite.newSprite(Player.jumpSet)
			spriteAnime:prepare("PlayerJump")
		elseif name == "stand" then
			spriteAnime = sprite.newSprite(Player.standSet)
			spriteAnime:prepare("PlayerStand")
		elseif name == "attack" then
			spriteAnime = sprite.newSprite(Player.attackSet)
			spriteAnime:prepare("PlayerAttack")
			spriteAnime:addEventListener("sprite", function(e)
														if e.phase == "end" then
															player:dispatchEvent({name="onAttackAnimationCompleted"})
														end
													end)
		elseif name == "hang" then
			spriteAnime = sprite.newSprite(Player.hangSet)
			spriteAnime:prepare("PlayerHang")
		end
		spriteAnime:setReferencePoint(display.TopLeftReferencePoint)
		spriteAnime:play()
		if player.sprite ~= nil then
			player.sprite:removeSelf()
		end
		player.sprite = spriteAnime
		player.spriteHolder:insert(spriteAnime)
		spriteAnime.x = 0
		spriteAnime.y = 0
	end

	function player:startResting()
		player.sprite.timeScale = 0.5
	end

	function player:stopResting()
		player.sprite.timeScale = 1
	end

	function player:tick(time)
	end

	player:showSprite("stand")

	physics.addBody(player, "dynamic", {density = 0.8, friction = 0.2, bounce = 0.2, shape={22,4, 42,4, 42,55, 22,55}})
	player.isFixedRotation = true

	local fsm = StateMachine:new(player)
	player.fsm = fsm

	fsm:addState2(ReadyState:new())
	fsm:addState2(RestingState:new())
	fsm:addState2(MovingRightState:new())
	fsm:addState2(MovingLeftState:new())
	fsm:addState2(JumpLeftState:new())
	fsm:addState2(JumpRightState:new())
	fsm:addState2(AttackState:new())
	fsm:setInitialState("ready")

	gameLoop:addLoop(player)
	gameLoop:addLoop(fsm)

	return player
end

return Player