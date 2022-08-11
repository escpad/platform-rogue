local STI = require("sti")

function love.load()
    Map = STI("map/map.lua", {"box2d"})
    World = love.physics.newWorld(0,0)
    Map:box2d_init(World)
    Map.layers.solid.visible = false
    

end

function love.update(dt)
    World:update(dt)
end

function love.draw()
    Map:draw(0,0,2,2)
    love.graphics.push()
    love.graphics.scale(2,2)
    love.graphics.pop()
end