EndingView = View:extend
{
	onNew = function (self)
		local message
		
		if self.won then
			message = 'You rock!'
		else
			message = 'Your rock ... not!'
		end
		
		self:add(Text:new{ x = 0, y = 300, width = the.app.width, text = message, align = 'center'})
		end

}