karte = nil
dir = nil
PillCounter = 0
PillsInit = false


Hero = Animation:extend
{
	width = 32,
	height = 32,
    image = 'pillen.png',
	
	 sequences = 
    {
        up = { frames = {1, 2, 3 }, fps = 6 },
        down = { frames = {4, 5, 6}, fps = 6 },
		left = { frames = {7, 8, 9}, fps = 6 },
		right = { frames = {10, 11, 12}, fps = 6 }
    },
    onUpdate = function (self)
        self.velocity.x = 0
        self.velocity.y = 0
 
        if the.keys:pressed('up') then
            self.velocity.y = -200
			self:play('up')
        elseif the.keys:pressed('down') then
            self.velocity.y = 200
			self:play('down')
        elseif the.keys:pressed('left') then
            self.velocity.x = -200
			self:play('left')
        elseif the.keys:pressed('right') then
            self.velocity.x = 200
			self:play('right')
		else
			self:freeze()
        end
    end,
	
	onCollide = function (self, other)
	
		if other == the.pinky then
			self:die()
		end
	end
}

Pill = Tile:extend
{
    image = 'tiles.png',
	score = 200,
    imageOffset = { x = 32, y = 0 },
	
	onNew = function(self)
		PillCounter = PillCounter + 1
		PillsInit = true
	end,
	
    onCollide = function (self, other)
        if other:instanceOf(Hero) then
			PillCounter = PillCounter - 1
            self:die()
        end
    end
}

Path = Sprite:extend
{
	onNew = function(self)
		--print('blubb')
		PathList = {next = PathList, value = self}
	end
}

Pinky = Animation:extend
{
	width = 32,
	height = 32,
    image = 'pillen.png',
	sequences = 
    {
        up = { frames = {25, 26}, fps = 4 },
        down = { frames = {27, 28}, fps = 4 },
		left = { frames = {29, 30}, fps = 4 },
		right = { frames = {31, 32}, fps = 4 }
    },
	
	onUpdate = function (self)
		self.velocity.y = 0
		self.velocity.x = 0
		local l = PathList
		local xSelf, ySelf = karte:pixelToMap(self.x, self.y)
		local foundPath = false
		local xPath, yPath
		
		while l do
		xPath, yPath = karte:pixelToMap(l.value.x, l.value.y)
			if (xPath == xSelf) and (yPath 	== ySelf-1) and dir ~= "down" then
				self.velocity.y = -50
				self:play('up')
				dir = "up"
				foundpath = true
				break 
			
			elseif (xPath == xSelf-1) and (yPath == ySelf) and dir ~= "right" then
				self.velocity.x = -50
				self:play('left')
				dir = "left"
				foundpath = true
				break

			elseif (xPath == xSelf) and (yPath == ySelf+1) and dir ~= "up" then
				self.velocity.y = 50
				self:play('down')
				dir = "down"
				foundpath = true
				break
			
			elseif (xPath == xSelf+1) and (yPath == ySelf) and  dir ~= "left" then
				self.velocity.x = 50
				self:play('right')
				dir = "right"
				foundpath = true
				break
			end
					
			l = l.next
		end
		
		if foundpath == false then
			dir = nil
		end
	end,
	
    onCollide = function (self, other)

    end
}

LevelView = View:extend
{
    onNew = function (self)
        self:loadLayers('level.lua')
        --self.focus = the.hero
        --self:clampTo(self.map)
		karte = self.map
    end,
 
    onUpdate = function (self)
        self.map:subdisplace(the.hero)
        self.pills:collide(the.hero)
		the.pinky:collide(the.hero)
		print (PillCounter, PillsInit)
		
		if PillCounter == 0 and PillsInit == true then
			the.app.view = EndingView:new{ won = true }
		end
		
		if not the.hero.active then
			the.app.view = EndingView:new{ won = false }
		end
    end
}