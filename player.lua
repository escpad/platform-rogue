Player = {}

function Player:load()
    self.x = 100
    self.y = 0
    self.width = 58 
    self.height = 78

    self.physics = {}
    self.physics.body = love.physics.newBody(World,self.x,self.y,"dynamic")
    self.physics.body:setFixedRotation(true)
    self.physics.shape = love.physics.RectangleShape(self.width, self.height)
    
end

function Player:upate(dt)

end

function Player:draw()

end
