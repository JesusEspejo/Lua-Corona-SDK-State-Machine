require "sprite"
require "GameLoop"
require "com.jessewarden.statemachine.StateMachine"

function startGame()
	gameLoop = GameLoop:new()
	gameLoop:start()

	player = getPlayer()
	gameLoop:addLoop(player)

	fireFSM = StateMachine:new()

	local showOption1 = true

	if showOption1 == true then
		-- option1: use the onStateMachineStateChanged to react to state changes
		fireFSM:addState("fire1", {from="*"})
		fireFSM:addState("fire2", {from="*"})
		fireFSM:addState("fire3", {from="*"})
		Runtime:addEventListener("onStateMachineStateChanged", onChangePlayerFireFunction)
	else
		-- option2: Use the enter handler to react when you enter each state
		fireFSM:addState("fire1", {from="*", enter=onEnterFire1})
		fireFSM:addState("fire2", {from="*", enter=onEnterFire2})
		fireFSM:addState("fire3", {from="*", enter=onEnterFire3})
	end

	fireFSM:setInitialState("fire1")
	
	-- move the plane and fire
	Runtime:addEventListener("touch", onTouch)

	-- when you press the buttons, they'll change the state machine
	fire1Button = getButton("Fire 1", function() fireFSM:changeState("fire1") end)
	fire2Button = getButton("Fire 2", function() fireFSM:changeState("fire2") end)
	fire3Button = getButton("Fire 3", function() fireFSM:changeState("fire3") end)

	fire1Button.x = 4
	fire1Button.y = 4

	fire2Button.x = fire1Button.x
	fire2Button.y = fire1Button.y + fire1Button.height + 2

	fire3Button.x = fire2Button.x
	fire3Button.y = fire2Button.y + fire2Button.height + 2
end

-- option 1
function onChangePlayerFireFunction(event)
	local fireFunkyFunk
	local state = fireFSM.state
	local fireSpeed
	if state == "fire1" then
		fireFunkyFunk = player.fire1
		fireSpeed = 300
	elseif state == "fire2" then
		fireFunkyFunk = player.fire2
		fireSpeed = 200
	elseif state == "fire3" then
		fireFunkyFunk = player.fire3
		fireSpeed = 150
	end
	player.fire = fireFunkyFunk
	player.FIRE_TIME = fireSpeed
end

-- option 2
function onEnterFire1(event)
	player.fire = player.fire1
	player.FIRE_TIME = 300
end

-- option 2
function onEnterFire2(event)
	player.fire = player.fire2
	player.FIRE_TIME = 200
end

-- option 2
function onEnterFire3(event)
	player.fire = player.fire3
	player.FIRE_TIME = 150
end


function onTouch(event)
	local phase = event.phase

	if phase == "began" then player.firing = true end

	if phase == "began" or phase == "moved" then
		player:setDestination(event.x, event.y - 40)
	end

	if phase == "ended" or phase == "cancelled" then player.firing = false end
end

function getPlayer()
	local spriteSheet = sprite.newSpriteSheet("player.png", 22, 17)
	local spriteSet = sprite.newSpriteSet(spriteSheet, 1, 2)
	sprite.add(spriteSet, "planeFly", 1, 2, 50, 0)
	local player = sprite.newSprite(spriteSet)
	player:setReferencePoint(display.TopLeftReferencePoint)
	player:prepare("planeFly")
	player:play()

	player.speed = 0.2
	player.reachedDestination = false
	player.planeXTarget = 200
	player.planeYTarget = 200
	player.FIRE_TIME = 500
	player.startFireTime = 0
	player.firing = false

	function player:setDestination(x, y)
		self.planeXTarget = x
		self.planeYTarget = y
		self.reachedDestination = false
	end

	function player:tick(millisecondsPassed)
		if self.firing == true then
			self.startFireTime = self.startFireTime + millisecondsPassed
			if self.startFireTime >= self.FIRE_TIME then
				self.startFireTime = 0
				self:fire()
			end
		end

		if self.reachedDestination == true then return true end
		
		if(self.x == self.planeXTarget and self.y == self.planeYTarget) then
			return
		else
			local deltaX = self.x - self.planeXTarget
			local deltaY = self.y - self.planeYTarget
			local dist = math.sqrt((deltaX * deltaX) + (deltaY * deltaY))
			local moveX = self.speed * (deltaX / dist) * millisecondsPassed
			local moveY = self.speed * (deltaY / dist) * millisecondsPassed
				
			if (math.abs(moveX) > dist or math.abs(moveY) > dist) then
				self.x = self.planeXTarget
				self.y = self.planeYTarget
				self.reachedDestination = true
			else
				self.x = self.x - moveX
				self.y = self.y - moveY
			end
		end	
	end

	function player:fire1()
		local bullet = getBasicBullet("player_bullet_1.png", self.x + self.width / 2, self.y)
	end

	function player:fire2()
		local bullet = getBasicBullet("player_bullet_2.png", self.x, self.y)
		bullet.x = bullet.x + bullet.width / 2
	end

	function player:fire3()
		local bullet1 = getBasicBullet("player_bullet_1.png", self.x, self.y)
		bullet1.rotation = -45
		bullet1.rot = math.atan2(bullet1.y -  -800,  bullet1.x - -800) / math.pi * 180 -90;
		bullet1.angle = (bullet1.rot -90) * math.pi / 180;

		local bullet2 = getBasicBullet("player_bullet_1.png", self.x, self.y)
		bullet2.rotation = 45
		bullet2.rot = math.atan2(bullet2.y -  -800,  bullet2.x - -800) / math.pi * 180 -90;
		bullet2.angle = (bullet2.rot) * math.pi / 180;
		
		-- override the functions with these instead
		function bullet1:tick(millisecondsPassed)
			self.x = self.x + math.cos(self.angle) * self.speed * millisecondsPassed
		   	self.y = self.y + math.sin(self.angle) * self.speed * millisecondsPassed
		end
		
		function bullet2:tick(millisecondsPassed)
			self.x = self.x + math.cos(self.angle) * self.speed * millisecondsPassed
		   	self.y = self.y + math.sin(self.angle) * self.speed * millisecondsPassed
		end

		local bullet3 = getBasicBullet("player_bullet_1.png", self.x + self.width / 2, self.y)
	end

	player.fire = player.fire1

	return player
end

function getBasicBullet(image, startX, startY)
	local bullet = display.newImage(image)
	bullet.speed = 0.4
	bullet.x = startX
	bullet.y = startY

	function bullet:destroy()
		gameLoop:removeLoop(self)
		self:removeSelf()
	end

	function bullet:tick(millisecondsPassed)
		if(self.y < 0) then
			self:destroy()
			return
		else
			local deltaX = 0
			local deltaY = self.y - 0
			local dist = math.sqrt((deltaX * deltaX) + (deltaY * deltaY))

			local moveX = self.speed * (deltaX / dist) * millisecondsPassed
			local moveY = self.speed * (deltaY / dist) * millisecondsPassed
			
			if (math.abs(moveX) > dist or math.abs(moveY) > dist) then
				self:destroy()
			else
				self.y = self.y - moveY
			end
		end
	end

	gameLoop:addLoop(bullet)

	return bullet
end

function getButton(label, callback)
	local group = display.newGroup()
	group.callback = callback

	local rect = display.newRect(0, 0, 100, 60)
	rect:setReferencePoint(display.TopLeftReferencePoint)
	rect:setStrokeColor(0, 0, 0)
	rect:setFillColor(255, 255, 255)
	rect.strokeWidth = 2

	local field = display.newText(label, 0, 0, 100, 30, native.systemFont, 16)
	field:setReferencePoint(display.TopLeftReferencePoint)
	field:setTextColor(0, 0, 0)
	field.y = 15
	field.x = 15

	group:insert(rect)
	group:insert(field)

	function group:touch(event)
		self.callback({name="touch", target=self})
		return true
	end

	group:addEventListener("touch", group)

	return group
end

startGame()