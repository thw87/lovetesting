STRICT = true
DEBUG = true

require 'zoetrope'

Player = Animation:extend
{
    width = 32,
    height = 48,
    image = 'player.png',
	sequences = 
	{
		right = { frames = {1, 2, 3, 4, 5, 6}, fps = 10 },
		left = { frames = {7, 8, 9, 10, 11, 12}, fps = 10}
	},
	
    acceleration = { x = 30, y = 600 },
    canJump = false,
 
    onUpdate = function (self)
        if the.keys:pressed('left') then
            self.velocity.x = -100
			self:play('left')
        elseif the.keys:pressed('right') then
            self.velocity.x = 100
			self:play('right')
		elseif the.keys:pressed('a') then
			the.app:quit()
        else
            self.velocity.x = 0
			self:freeze()
        end
		
 
        if the.keys:justPressed(' ') and self.canJump then
		playSound('Jump6.wav')
            self.velocity.y = -500
            self.canJump = false
        end
		
		
    end,
 
    onCollide = function (self)
        if self.velocity.y > 0 then
            self.velocity.y = 0
            self.canJump = true
        end
    end
}
		
Platform = Tile:extend
{
	width  = 128, height = 32,
	image = 'brick.png',
			
	onCollide = function (self, other)
		self:displace(other)
	end
}

function CheckFalling(pla)

	if pla.y > the.app.height then
		pla.y = 0
		pla.x = 0
	end
end

the.app = App:new
{
	name = 'Jumper',
	onRun = function(self)
		self.player = Player:new{x = 0, y = 0}
		self:add(self.player)
		self.platforms = Group:new()
		self.platforms:add(Platform:new{ x = 0, y = 400 })
		self.platforms:add(Platform:new{ x = 250, y = 400})
		self.platforms:add(Platform:new{ x = 500, y = 400})
				self.platforms:add(Platform:new{ x = 750, y = 400})
		self:add(self.platforms)
	end,
	
	onUpdate = function(self)
		self.platforms:collide(self.player)
		CheckFalling(self.player)
	end
}