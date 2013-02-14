STRICT = true
DEBUG = true
 
require 'zoetrope'
require 'levelview'
require 'endingview'
 
the.app = App:new
{
    onRun = function (self)
         self.view = LevelView:new{}
    end
}