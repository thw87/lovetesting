DEBUG = true
STRICT = true
 
require 'zoetrope'
 
Ball = Fill:extend
{
    width = 16,
    height = 16,
    fill = {255, 255, 255},
    velocity = { x = 150, y = 150 },
 
    onUpdate = function (self)
        -- if the ball has fallen below the screen, reset position
 
        if self.y > the.app.height then
            self.x = 300
            self.y = 200
        end
 
        -- bounce off the other sides of the window
 
        if self.x < 0 or self.x > the.app.width then
            self.velocity.x = self.velocity.x * -1
        end
 
        if self.y < 0 then
            self.velocity.y = self.velocity.y * -1
        end
    end,
	
	onCollide = function (self, other)
		self.velocity.y = self.velocity.y * -1
		
		if other:instanceOf(Brick) then
			other:die()
			the.app.score = the.app.score + other.score
		end
	end
}

Brick = Fill:extend
{
	width = 75,
	height = 16,
	fill = {0, 255, 0},
	
	score = 100
}

Score = Text:extend
{
	font = 14,
	width = 300,
	height = 20,
	
	onUpdate = function (self)
		self.text = 'Score: ' .. the.app.score
	end

}
 
Paddle = Fill:extend
{
	width = 100,
	height = 16,
	fill = {0, 0, 255},
	
	onUpdate = function (self)
		self.x = the.mouse.x - self.width/2
	end

}
 
the.app = App:new
{
	score = 0,
    onRun = function (self)
        self.ball = Ball:new{ x = 400, y = 300 }
        self:add(self.ball)
		self.paddle = Paddle:new{ x = 400, y = 580 }
		self:add(self.paddle)
		
		self.tester = Brick:new{x= 300, y = 200}
		self:add(self.tester)
		
		self.bricks = Group:new()			
		for y = 100, 200, Brick.height + 4 do
			for x = 20, self.width - Brick.width, Brick.width + 10 do
				self.bricks:add(Brick:new{ x = x, y = y, score = 20 })
			end
		end
		self:add(self.bricks)
		
		self:add(Score:new{ x = 10, y = 10})
		self:useSysCursor(false)
    end,
	
	onUpdate = function (self)
		self.ball:collide(self.paddle)
		self.ball:collide(self.bricks)
	end
}