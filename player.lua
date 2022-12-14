Player = {}
anim8 = require("libraries/anim8")
function Player:load()
    self.x = 100    
    self.y = 100
    self.width = 36
    self.height = 36
    self.xVel = 0
    self.yVel = 0
    self.maxSpeed = 200
    self.acceleration = 4000
    self.friction = 1000 
    self.gravity = 2000
    self.grounded = false
    self.jumpAmount = -500
    self.canDoubleJump = false

    self.spriteSheet = love.graphics.newImage("sprites/King/idle_right.png")
    self.grid = anim8.newGrid(78,58,self.spriteSheet:getWidth(),self.spriteSheet:getHeight())

    self.animations = {}
    self.animations.idle = anim8.newAnimation(self.grid('1-10',1),0.1)

    self.graceTime = 0
    self.graceDuration = 0.8
    self.physics = {}
    self.physics.body = love.physics.newBody(World,self.x,self.y,"dynamic")
    self.physics.body:setFixedRotation(true)
    self.physics.shape = love.physics.newRectangleShape(self.width, self.height)
    self.physics.fixture = love.physics.newFixture(self.physics.body,self.physics.shape)
end



function Player:update(dt)
    self:decreaseGraceTime(dt)
    self:syncPhysics()
    self:move(dt)
    self:applyGravity(dt)
    self.animations.idle:update(dt)
end

function Player:decreaseGraceTime(dt)
    if not self.grounded then
        self.graceTime = self.graceTime - dt

    end
end

function Player:applyGravity(dt)
    if not self.grounded then
        self.yVel = self.yVel + self.gravity * dt
    end
end 

function Player:move(dt)
    if love.keyboard.isDown("d") then
        if self.xVel < self.maxSpeed then
            if self.xVel + self.acceleration * dt < self.maxSpeed then
                self.xVel = self.xVel + self.acceleration * dt
            else
                self.xVel = self.maxSpeed
            end
        end
    elseif love.keyboard.isDown("a") then
        if self.xVel > -self.maxSpeed then
            if self.xVel - self.acceleration * dt > -self.maxSpeed then
                self.xVel = self.xVel - self.acceleration * dt
            else
                self.xVel = -self.maxSpeed
            end
        end
    else 
        self:applyFriction(dt)
    end
end

function Player:applyFriction(dt)
    if self.xVel > 0 then
        if self.xVel - self.friction * dt > 0 then
            self.xVel = self.xVel - self.friction * dt
        else
            self.xVel = 0
        end
    elseif self.xVel < 0 then
        if self.xVel + self.friction * dt < 0 then
            self.xVel = self.xVel + self.friction * dt
        else
            self.xVel = 0
        end
    end
end

function Player:syncPhysics()
    self.x, self.y = self.physics.body:getPosition()
    self.physics.body:setLinearVelocity(self.xVel, self.yVel)
end

function Player:beginContact(a,b,collision)
    if self.grounded == true then return end
    local nx, ny = collision:getNormal()
    if a == self.physics.fixture then
        if ny > 0 then
            self:land(collision)
        end
    elseif b == self.physics.fixture then
        if ny < 0 then
            self:land(collision)
        end
    end
end

function Player:land(collision)
    self.currentGroundCollision = collision
    self.yVel = 0
    self.canDoubleJump = true
    self.grounded = true
    self.graceTime = self.graceDuration
end

function Player:jump(key)
    
    if key == "space" then
        if self.grounded or self.graceTime > 0 then
            self.yVel = self.jumpAmount
            self.grounded = false
            self.graceTime = 0
        elseif self.canDoubleJump then
            self.canDoubleJump = false
            self.yVel = self.jumpAmount 
        end
    end
end

function Player:endContact(a,b,collision)
    if a == self.physics.fixture or b == self.physics.fixture then
        if self.currentGroundCollision == collision then 
            self.grounded = false
        end
    end
end

function Player:draw()
    -- love.graphics.rectangle("fill", self.x - self.width / 2, self.y - self.height / 2,self.width,self.height)
    self.animations.idle:draw(self.spriteSheet, self.x - 28 ,  self.y - 26)
end