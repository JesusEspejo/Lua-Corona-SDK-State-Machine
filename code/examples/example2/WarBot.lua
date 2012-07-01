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
	
	local bg = display.newRect(0, 0, 64, 64)
	bg:setFillColor(255, 0, 0, 50)
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

	bot:showSprite("scout")

	return bot

end

return WarBot