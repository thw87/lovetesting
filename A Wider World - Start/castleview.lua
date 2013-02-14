Hero = Tile:extend
{
    image = 'mapobjects.png',
    onUpdate = function (self)
        self.velocity.x = 0
        self.velocity.y = 0
 
        if the.keys:pressed('up') then
            self.velocity.y = -200
        elseif the.keys:pressed('down') then
            self.velocity.y = 200
        end
 
        if the.keys:pressed('left') then
            self.velocity.x = -200
        elseif the.keys:pressed('right') then
            self.velocity.x = 200
        end
    end
}
 
Chest = Tile:extend
{
    image = 'mapobjects.png',
    imageOffset = { x = 32, y = 0 },
    onCollide = function (self, other)
        if other:instanceOf(Hero) then
            if self.hassword then
                other.hassword = true
                the.view:flash({255, 255, 255}, 1)
            end
 
            self:die()
        end
    end
}
 
Dragon = Tile:extend
{
    image = 'dragon.png',
    onCollide = function (self, other)
        if other:instanceOf(Hero) then
            if other.hassword then
                self:die()
            else
                other:die()
            end
        end
    end
}
 
CastleView = View:extend
{
    onNew = function (self)
        self:loadLayers('map.lua')
        self.focus = the.hero
        self:clampTo(self.map)
    end,
 
    onUpdate = function (self)
        self.map:subdisplace(the.hero)
        self.objects:collide(self.objects)
		
		if not the.hero.active then
			the.app.view = EndingView:new{ won = false }
		end
		
		if not the.dragon.active then
			the.app.view = EndingView:new{ won = true }
		end
    end
}