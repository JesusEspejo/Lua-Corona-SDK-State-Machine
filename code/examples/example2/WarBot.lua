WarBot = {}

function WarBot:new()

	if WarBot.spriteSheet == nil then
		local scoutSheet = sprite.newSpriteSheet("scout-sheet.png", 64, 64)
		local scoutSet = sprite.newSpriteSet(scoutSheet, 1, 10)
		sprite.add(scoutSet, "scout", 1, 10, 1000, 0)

		local artillerySheet = sprite.newSpriteSheet("artillery-sheet.png", 84, 84)
		local artillerySet = sprite.newSpriteSet(artillerySheet, 1, 17)
		sprite.add(artillerySet, "artillery", 1, 17, 1000, 1)
		sprite.add(artillerySet, "artilleryReverse", 1, 17, 500, -1)

		local defendSheet = sprite.newSpriteSheet("defend-sheet.png", 64, 64)
		local defendSet = sprite.newSpriteSet(defendSheet, 1, 1)
		sprite.add(defendSet, "defend", 1, 1, 1, 1)

		local sightSheet = sprite.newSpriteSheet("sight-sheet.png", 64, 64)
		local sightSet = sprite.newSpriteSet(sightSheet, 1, 5)
		sprite.add(sightSet, "sight", 1, 5, 500, 1)
		sprite.add(sightSet, "sightReverse", 1, 5, 300, -1)

		local sniperSheet = sprite.newSpriteSheet("sniper-sheet.png", 128, 128)
		local sniperSet = sprite.newSpriteSet(sniperSheet, 1, 21)
		sprite.add(sniperSet, "sniper", 1, 21, 1000, 1)
		sprite.add(sniperSet, "sniperReverse", 1, 21, 500, -1)

		local explosionSheet = sprite.newSpriteSheet("explosion-sheet.png", 142, 200)
		local explosionSet = sprite.newSpriteSet(explosionSheet, 1, 8)
		sprite.add(explosionSet, "explosion", 1, 8, 800, 1)

		WarBot.scoutSheet = scoutSheet
		WarBot.scoutSet = scoutSet

		WarBot.artillerySheet = artillerySheet
		WarBot.artillerySet = artillerySet

		WarBot.defendSheet = defendSheet
		WarBot.defendSet = defendSet

		WarBot.sightSheet = sightSheet
		WarBot.sightSet = sightSet

		WarBot.sniperSheet = sniperSheet
		WarBot.sniperSet = sniperSet

		WarBot.explosionSheet = explosionSheet
		WarBot.explosionSet = explosionSet
	end

	local bot = display.newGroup()
	bot.WIDTH = 64
	bot.HEIGHT = 64
	bot.image = nil
	bot.speed = 6 -- set externally via StateMachine
	bot.maxSpeed = 10
	bot.defense = 4 -- set externally via StateMachine
	bot.maxDefense = 10
	bot.direction = "right"
	bot.sightSpeed = 0.4
	bot.sightX = nil
	bot.sightY = nil
	bot.currentSightX = nil
	bot.currentSightY = nil
	
	local bg = display.newRect(20, 0, 20, 0)
	bg:setFillColor(255, 0, 0, 255)
	bg:setReferencePoint(display.TopLeftReferencePoint)
	bot:insert(bg)

	local wheel1 = display.newImage("wheel.png")
	local wheel2 = display.newImage("wheel.png")
	local wheel3 = display.newImage("wheel.png")
	wheel1:setReferencePoint(display.TopLeftReferencePoint)
	wheel2:setReferencePoint(display.TopLeftReferencePoint)
	wheel3:setReferencePoint(display.TopLeftReferencePoint)

	bot:insert(wheel1)
	bot:insert(wheel2)
	bot:insert(wheel3)
	bot.wheel1 = wheel1
	bot.wheel2 = wheel2
	bot.wheel3 = wheel3

	-- holds srpites and flips for direction changing
	bot.spriteHolder = display.newGroup()
	bot:insert(bot.spriteHolder)

	function bot:showSprite(anime)
		if self.spriteHolder and self.spriteHolder.image then
			self.spriteHolder.image:removeSelf()
			self.spriteHolder.image = nil
		end

		local image
		local showTheWheels = false
		if anime == "scout" then
			image = display.newImage("stand.png")
		elseif anime == "assault" then
			image = display.newImage("assault.png")
			showTheWheels = true
		elseif anime == "scoutLeft" or anime == "scoutRight" then
			image = sprite.newSprite(WarBot.scoutSet)
			image:prepare("scout")
			image:play()
		elseif anime == "artillery" then
			image = sprite.newSprite(WarBot.artillerySet)
			image:prepare("artillery")
			image:play()
		elseif anime == "artilleryReverse" then
			image = sprite.newSprite(WarBot.artillerySet)
			image:prepare("artilleryReverse")
			image.currentFrame = 16
			image:play()
		elseif anime == "defend" then
			image = sprite.newSprite(WarBot.defendSet)
			image:prepare("defend")
			image:play()
		elseif anime == "sight" then
			image = sprite.newSprite(WarBot.sightSet)
			image:prepare("sight")
			image:play()
			showTheWheels = true
		elseif anime == "sightReverse" then
			image = sprite.newSprite(WarBot.sightSet)
			image:prepare("sightReverse")
			image.currentFrame = 4
			image:play()
			showTheWheels = true
		elseif anime == "sniper" then
			image = sprite.newSprite(WarBot.sniperSet)
			image:prepare("sniper")
			image:play()
		elseif anime == "sniperReverse" then
			image = sprite.newSprite(WarBot.sniperSet)
			image:prepare("sniperReverse")
			image.currentFrame = 20
			image:play()
		end

		if image == nil then error("failed to find an animation for: " .. anime) end
		image:setReferencePoint(display.TopLeftReferencePoint)
		self.spriteHolder:insert(image)
		self.spriteHolder.image = image
		self:showWheels(showTheWheels)

		-- now that we're inserted, it's easier to position things... these are the days when I miss Flash
		if anime == "scout" or anime == "scoutRight" or anime == "scoutLeft" then
			image.x = (self.WIDTH / 2) - (image.width / 2)
			image.y = (self.HEIGHT / 2) - (image.height / 2)
		elseif anime == "assault" then
			image.x = self.WIDTH / 2 - image.width / 2
			image.y = 0
		elseif anime == "artillery" or anime == "artilleryReverse" then
			image.x = self.WIDTH / 2 - image.width / 2
			image.y = 2
		elseif anime == "defend" then
			image.x = 0
			image.y = 0
		elseif anime == "sight" or anime == "sightReverse" then
			image.x = self.WIDTH / 2 - image.width / 2
			image.y = -10
		elseif anime == "sniper" or anime == "sniperReverse" then
			image.x = self.WIDTH / 2 - image.width / 2
			image.y = -40
		end

		self:setDirection(self.direction)
	end

	function bot:setDirection(direction)
		self.direction = direction
		local spriteHolder = self.spriteHolder
		if spriteHolder then
			if direction == "left" then
				spriteHolder.xScale = -1
				spriteHolder.x = self.WIDTH
			elseif direction == "right" or direction == nil then
				spriteHolder.xScale = 1
				spriteHolder.x = 0
			end
		end
	end

	function bot:showWheels(show)
		local wheel1 = self.wheel1
		local wheel2 = self.wheel2
		local wheel3 = self.wheel3

		wheel1.isVisible = show
		wheel2.isVisible = show
		wheel3.isVisible = show

		wheel1.x = 0
		wheel1.y = self.HEIGHT - wheel1.height - 2

		wheel2.x = self.WIDTH / 2 - wheel2.width / 2
		wheel2.y = wheel1.y

		wheel3.x = self.WIDTH - wheel3.width
		wheel3.y = wheel2.y
	end

	function bot:setSpeed(value)
		assert(value ~= nil, "Value must not be nil.")
		assert(type(value) == "number", "value must be a number.")
		local oldValue = self.speed
		self.speed = value
		self:dispatchEvent({name="onSpeedChanged", target=self, oldValue=oldValue, value=value, max=self.speedMax})
	end

	function bot:setDefense(value)
		assert(value ~= nil, "Value must not be nil.")
		assert(type(value) == "number", "value must be a number.")
		local oldValue = self.defense
		self.defense = value
		self:dispatchEvent({name="onDefenseChanged", target=self, oldValue=oldValue, value=value, max=self.defenseMax})
	end

	function bot:tick(time)

	end

	function bot:startTrackingSight()
		if self.sightTouchDelegate == nil then
			self.sightTouchDelegate = function(e)bot:onSightTouch(e)end
		end
		Runtime:addEventListener("touch", self.sightTouchDelegate)
		self.oldTick = self.tick
		self.tick = self.sightTick
		self.currentSightX = self.x + 30
		self.currentSightY = self.y - 10
		self.sightX = self.x
		self.sightY = self.y
	end

	function bot:onSightTouch(event)
		self.sightX = event.x
		self.sightY = event.y
		return true
	end

	function bot:stopTrackingSight()
		Runtime:removeEventListener("touch", self.sightTouchDelegate)
		self.tick = self.oldTick
		self:destroySight()
	end

	function bot:sightTick(time)
		if self.currentSightX == nil or self.sightX == nil then return true end
		if self.currentSightY == nil or self.sightY == nil then return true end
		--print("self.currentSightX: ", self.currentSightX, ", self.sightX: ", self.sightX)
		local deltaX = self.currentSightX - self.sightX
		local deltaY = self.currentSightY - self.sightY
		local dist = math.sqrt((deltaX * deltaX) + (deltaY * deltaY))
		-- HACK: too tired to rmemeber why it divides by zero and dist == 0... anyway
		if dist == 0 then
			self.currentSightX = self.sightX
			self.currentSightY = self.sightY
			self:redrawSight()
			return true
		end
		
		local moveX = self.sightSpeed * (deltaX / dist) * time
		local moveY = self.sightSpeed * (deltaY / dist) * time
		--print("s: ", self.sightSpeed, ", deltaX: ", deltaX, ", dist: ", dist, ", moveX: ", moveX)
		if (math.abs(moveX) > dist or math.abs(moveY) > dist) then
			self.currentSightX = self.sightX
			self.currentSightY = self.sightY
		else
			self.currentSightX = self.currentSightX - moveX
			self.currentSightY = self.currentSightY - moveY
		end
		
		self:redrawSight()
	end

	function bot:redrawSight()
		bot:destroySight()
		self.laserSight = display.newLine(self.x + 30, self.y - 10, self.currentSightX, self.currentSightY)
		self.laserSight:setColor(0, 255, 0, 180)
		self.laserSight.width = 2
	end

	function bot:destroySight()
		if self.laserSight then
			self.laserSight:removeSelf()
			self.laserSight = nil
		end
	end

	function bot:startArtillery()
		if self.artilleryTouchDelegate == nil then
			self.artilleryTouchDelegate = function(e)self:onArtilleryTouch(e)end
		end
		Runtime:addEventListener("touch", self.artilleryTouchDelegate)
	end

	function bot:stopArtillery()
		Runtime:removeEventListener("touch", self.sniperTouchDelegate)
	end

	function bot:onArtilleryTouch(event)
		if event.phase == "began" then
			local bullet = display.newCircle(self.x + 70, self.y + 27, 10)
			bullet.hit = false
			function bullet:collision(event)
				if self.hit == false then
					self.hit = true
					local boom = sprite.newSprite(WarBot.explosionSet)
					boom:prepare("explosion")
					boom:play()
					boom.x = self.x
					boom.y = self.y
					self.isVisible = false
					timer.performWithDelay(100, self, 1)
				end
			end
			function bullet:timer(event)
				self:removeSelf()
			end
			bullet:addEventListener("collision", bullet)
			physics.addBody(bullet, {density=3, friction=0.4, bounce=0.2, isBullet = true})
			local forceX = event.x - bullet.x
	   		local forceY = event.y - bullet.y
			forceX = forceX * 0.05
	   		forceY = forceY * 0.05
			bullet:applyLinearImpulse( forceX, forceY, bullet.x + (bullet.width / 2), bullet.y + (bullet.height / 2))
		end
	end

	function bot:startSniperShooting()
		if self.sniperTouchDelegate == nil then
			self.sniperTouchDelegate = function(e)self:onSniperTouch(e)end
		end
		Runtime:addEventListener("touch", self.sniperTouchDelegate)
	end

	function bot:getBusyTerryChildIGuessIDidntKnow(targetA, targetB)
		local dx = targetA.x - targetB.x
		local dy = targetA.y - targetB.y
		local radians = math.atan2(dy, dx)
		local deg = math.deg(radians)
		local theX = math.sin(deg)
		local theY = math.cos(deg)
		return theX, theY
	end

	function bot:onSniperTouch(event)
		if event.phase == "began" then
			local bullet = display.newCircle(self.x + 70, self.y + 27, 2)
			-- TODO: figure this out
			local theX, theY = self:getBusyTerryChildIGuessIDidntKnow(bullet, event)
			physics.addBody(bullet, {density=2, friction=0.2, bounce=0.2, isBullet = true})
			bullet.rot = math.atan2(bullet.y - event.y,  bullet.x - event.y) / math.pi * 180 -90;
			bullet.angle = (bullet.rot -90) * math.pi / 180;
			--self.x = self.x + math.cos(self.angle) * self.speed * millisecondsPassed
	   		--self.y = self.y + math.sin(self.angle) * self.speed * millisecondsPassed
	   		local targetX = math.cos(bullet.angle)
	   		local targetY = math.sin(bullet.angle)

	   		-- Charlie's
	   		local forceX = event.x - bullet.x
	   		local forceY = event.y - bullet.y
	   		local dist = math.sqrt((forceX * forceX) + (forceY * forceY))
	   		--[[
	   		-- hack to increase/decrease force to maximum
	   		local max = 160
	   		local xPer, yPer
	   		print("before, x: ", forceX, ", y: ", forceY)
	   		if forceX > max then
	   			xPer = max / forceX
	   			forceX = max
	   			forceY = forceY * xPer
	   		elseif forceY > max then
	   			yPer = max / forceY
	   			forceY = max
	   			forceX = forceX * yPer
	   		elseif forceX < max then
	   			xPer = forceX / max
	   			forceX = max
	   			forceY = forceY * xPer
   			elseif forceY < max then
   				yPer = forceY / max
   				forceY = max
   				forceX = forceX * yPer
   			end

	   		print("after, x: ", forceX, ", y: ", forceY)
			]]--
	   		forceX = forceX * 0.007
	   		forceY = forceY * 0.007
			bullet:applyLinearImpulse( forceX, forceY, bullet.x + (bullet.width / 2), bullet.y + (bullet.height / 2))
		end
	end

	function bot:stopSniperShooting()
		Runtime:removeEventListener("touch", self.sniperTouchDelegate)
	end

	function bot:getJoint(obj1, obj2, x, y)
		local joint = physics.newJoint("pivot", obj1, obj2, x, y)
		--local joint = physics.newJoint("wheel", obj1, obj2, x, y, 2, 2)
		joint.maxMotorTorque = 1000000
		--joint.maxMotorForce = torque
		joint.motorSpeed = 0
		return joint
	end

	function bot:getWheel()
		local radius = 10
		local wheelShape = display.newCircle(0, 0, radius)
		--self:insert(wheelShape)
		wheelShape:setFillColor(0, 255, 0, 0)
		physics.addBody(wheelShape, "dynamic", 
			{ density=0.3, friction=0.7, bounce=0.2, isBullet=true, radius=radius})
		return wheelShape
	end

	function bot:startMoving()
		local direction = self.direction
		local wheelJoint = self.wheelJoint
		if direction == "right" then
			wheelJoint.motorSpeed = self.speed * 10000
		elseif direction == "left" then
			wheelJoint.motorSpeed = -(self.speed * 10000)
		end
	end

	function bot:stopMoving()
		self.wheelJoint.motorSpeed = 0
		if self.speed <= 0 then return true end

		local force
		if self.direction == "right" then
			force = -self.speed
		else
			force = self.speed
		end
		force = force * 2
		self:applyLinearImpulse(force, 0, 40, 32)
	end


	bot:showSprite("scout")

	local botShape = {10,0, 52,0, 52,64, 10,64}
	physics.addBody(bot, "dynamic", 
			{ density=1, friction=0.4, bounce=0.2, isBullet=true, shape=botShape})
	bot.isFixedRotation = true

	

	local wheel1 = bot:getWheel()
	wheel1.x = bot.x + 32
	wheel1.y = bot.y + 60

	local cX, cY = bot:localToContent(bot.x + 32, bot.y + 60)
	local wheelJoint = bot:getJoint(bot, wheel1, wheel1.x, wheel1.y)
	--local joint2 = bot:getJoint(bot, wheel2, 60, 0)
	bot.wheelJoint = wheelJoint


	return bot

end

return WarBot