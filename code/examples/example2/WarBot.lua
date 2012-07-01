WarBot = {}

function WarBot:new()

	if WarBot.spriteSheet == nil then
		local scoutSheet = sprite.newSpriteSheet("scout-sheet.png", 64, 64)
		local scoutSet = sprite.newSpriteSet(scoutSheet, 1, 10)
		sprite.add(scoutSet, "scout", 1, 10, 1000, 0)

		local artillerySheet = sprite.newSpriteSheet("artillery-sheet.png", 84, 84)
		local artillerySet = sprite.newSpriteSet(artillerySheet, 1, 17)
		sprite.add(artillerySet, "artillery", 1, 17, 1000, 1)

		local defendSheet = sprite.newSpriteSheet("defend-sheet.png", 64, 64)
		local defendSet = sprite.newSpriteSet(defendSheet, 1, 1)
		sprite.add(defendSet, "defend", 1, 1, 1, 1)

		local sightSheet = sprite.newSpriteSheet("sight-sheet.png", 64, 64)
		local sightSet = sprite.newSpriteSet(sightSheet, 1, 5)
		sprite.add(sightSet, "sight", 1, 5, 500, 1)

		local sniperSheet = sprite.newSpriteSheet("sniper-sheet.png", 128, 128)
		local sniperSet = sprite.newSpriteSet(sniperSheet, 1, 21)
		sprite.add(sniperSet, "sniper", 1, 21, 2000, 0)

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
	bot.defense = 4 -- set externally via StateMachine
	
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

	function bot:showSprite(anime, direction)
		if self.image then 
			self.image:removeSelf()
		end
		local image
		local showTheWheels = false
		if anime == "scout" and direction == nil then
			image = display.newImage("stand.png")
		elseif anime == "assault" then
			image = display.newImage("assault.png")
			showTheWheels = true
		elseif anime == "scout" then
			image = sprite.newSprite(WarBot.scoutSet)
			image:prepare("scout")
			image:play()
		elseif anime == "artillery" then
			image = sprite.newSprite(WarBot.artillerySet)
			image:prepare("artillery")
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
		elseif anime == "sniper" then
			image = sprite.newSprite(WarBot.sniperSet)
			image:prepare("sniper")
			image:play()
		end

		if image == nil then error("failed to find an animation for: " .. anime) end
		image:setReferencePoint(display.TopLeftReferencePoint)
		self:insert(image)
		self.image = image
		self:showWheels(showTheWheels)

		-- now that we're inserted, it's easier to position things... these are the days when I miss Flash
		if anime == "scout" and direction == nil then
			image.x = self.WIDTH / 2 - image.width / 2
			image.y = 0
		elseif anime == "assault" then
			image.x = self.WIDTH / 2 - image.width / 2
			image.y = 0
		elseif anime == "scout" then
			image.x = self.WIDTH / 2 - image.width / 2
			image.y = 0
		elseif anime == "artillery" then
			image.x = self.WIDTH / 2 - image.width / 2
			image.y = 0
		elseif anime == "defend" then
			image.x = 0
			image.y = 0
		elseif anime == "sight" then
			image.x = self.WIDTH / 2 - image.width / 2
			image.y = 0
		elseif anime == "sniper" then
			image.x = self.WIDTH / 2 - image.width / 2
			image.y = 0
		end
		-- TODO: handle above x transformations by putting in sub-group
		if direction == "left" then
			image.xScale = -1
			image.x = image.width
		elseif direction == "right" or direction == nil then
			image.xScale = 1
			image.x = 0
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
		self:dispatchEvent({name="onSpeedChanged", target=self, oldValue=oldValue, value=value})
	end

	function bot:setDefense(value)
		assert(value ~= nil, "Value must not be nil.")
		assert(type(value) == "number", "value must be a number.")
		local oldValue = self.defense
		self.defense = value
		self:dispatchEvent({name="onDefenseChanged", target=self, oldValue=oldValue, value=value})
	end

	bot:showSprite("scout")

	return bot

end

return WarBot