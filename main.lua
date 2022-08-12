local STI = require("libraries/sti")
require("player")
anim8 = require("libraries/anim8")

function love.load()
    Map = STI("map/map.lua", {"box2d"})
    World = love.physics.newWorld(0,0)
    World:setCallbacks(beginContact, endContact)
    Map:box2d_init(World)
    Map.layers.solid.visible = false
    Player:load()
end

function love.update(dt)
    World:update(dt)
    Player:update(dt)
end

function love.draw()
    Map:draw(0,0,2,2)
    love.graphics.push()
    love.graphics.scale(2,2)

    Player:draw()
    love.graphics.pop()
end

function love.keypressed(key)
    Player:jump(key)
end

function beginContact(a,b,collision)
    Player:beginContact(a,b,collision)
end

function endContact(a,b,collision)
    Player:endContact(a,b,collision)
end