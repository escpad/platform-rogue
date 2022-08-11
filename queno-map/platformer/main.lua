local STI = require("sti") --simplified tiles implementation
require("player")
function love.load()
    Map = STI("map/1.lua", {"box2d"}) --physics
    World = love.physics.newWorld(0,0)
    World:setCallbacks(beginContact, endContact)
    Map:box2d_init(World) 
    Map.layers.platform.visible = false
    Player:load()
end

function love.update(dt)
    World:update(dt)
    Player:update(dt)
end

-- anything drawn before the push and after pop won't be
-- affected by the scaling
function love.draw()
    Map:draw(0, 0, 2) --(x, y, scale (200%))
    love.graphics.push()
    love.graphics.scale(2,2) --(x,y)

    Player:draw()

    love.graphics.pop() 
end

function love.keypressed(key)
    Player:jump(key)
end

-- to move after falling or jumping
function beginContact(a, b, collision)
    Player:beginContact(a, b, collision)
end

function endContact(a, b, collision)
    Player:endContact(a, b, collision)
end