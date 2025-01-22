-- main.lua
local player, bullets, enemies, particleSystems

function love.load()
    -- Player setup
    player = {
        x = 400,
        y = 500,
        width = 32,
        height = 32,
        speed = 300,
        image = love.graphics.newImage("player.png"),
    }

    -- Bullet setup
    bullets = {}
    bulletImage = love.graphics.newImage("bullet.png")

    -- Enemy setup
    enemies = {}
    enemyImage = love.graphics.newImage("enemy.png")
    enemySpawnTimer = 0
    enemySpawnInterval = 1 -- Spawn an enemy every 1 second

    -- Particle effects
    particleSystems = {}
    explosionImage = love.graphics.newImage("explosion.png")

    -- Screen setup
    love.graphics.setBackgroundColor(0, 0, 0.1)
end

function love.update(dt)
    -- Player movement
    if love.keyboard.isDown("left") then
        player.x = player.x - player.speed * dt
    end
    if love.keyboard.isDown("right") then
        player.x = player.x + player.speed * dt

-- Variables for the controller
local joystick = nil

function love.load()
    -- Load images and initialize variables (from previous code)
    playerImage = love.graphics.newImage("player.png")
    bulletImage = love.graphics.newImage("bullet.png")
    enemyImage = love.graphics.newImage("enemy.png")

    player = { x = 400, y = 500, width = 64, height = 64, speed = 300 }
    bullets = {}
    enemies = {}

    -- Spawn enemies (example)
    for i = 1, 5 do
        table.insert(enemies, { x = math.random(0, 736), y = math.random(-100, -40), width = 64, height = 64, speed = 100 })
    end
end

function love.joystickadded(joystickAdded)
    -- Set the joystick when a controller is connected
    joystick = joystickAdded
end

function love.gamepadpressed(joystick, button)
    -- Check if the A button is pressed
    if button == "a" then
        -- Fire a bullet
        table.insert(bullets, {
            x = player.x + player.width / 2 - 4, -- Center bullet horizontally
            y = player.y,                       -- Position bullet at the top of the player
            width = 8,
            height = 16,
            speed = 400
        })
    end
end

function love.update(dt)
    -- Player movement (keyboard and joystick support)
    if love.keyboard.isDown("left") or (joystick and joystick:isGamepadDown("dpleft")) then
        player.x = math.max(0, player.x - player.speed * dt)
    end
    if love.keyboard.isDown("right") or (joystick and joystick:isGamepadDown("dpright")) then
        player.x = math.min(800 - player.width, player.x + player.speed * dt)
    end

    -- Update bullets
    for i = #bullets, 1, -1 do
        local bullet = bullets[i]
        bullet.y = bullet.y - bullet.speed * dt
        if bullet.y < 0 then
            table.remove(bullets, i)
        end
    end

    -- Update enemies (basic movement)
    for i = #enemies, 1, -1 do
        local enemy = enemies[i]
        enemy.y = enemy.y + enemy.speed * dt
        if enemy.y > 600 then
            table.remove(enemies, i)
        end
    end
end

function love.draw()
    -- Draw the player
    love.graphics.draw(playerImage, player.x, player.y)

    -- Draw bullets
    for _, bullet in ipairs(bullets) do
        love.graphics.draw(bulletImage, bullet.x, bullet.y)
    end

    -- Draw enemies
    for _, enemy in ipairs(enemies) do
        love.graphics.draw(enemyImage, enemy.x, enemy.y)
    end
end

    


    end

    -- Keep player within screen bounds
    player.x = math.max(0, math.min(love.graphics.getWidth() - player.width, player.x))

    -- Update bullets
    for i = #bullets, 1, -1 do
        local bullet = bullets[i]
        bullet.y = bullet.y - bullet.speed * dt
        if bullet.y < 0 then
            table.remove(bullets, i)
        end
    end

    -- Spawn enemies
    enemySpawnTimer = enemySpawnTimer + dt
    if enemySpawnTimer >= enemySpawnInterval then
        enemySpawnTimer = 0
        table.insert(enemies, {
            x = math.random(0, love.graphics.getWidth() - 32),
            y = -32,
            width = 32,
            height = 32,
            speed = 100
        })
    end

    -- Update enemies
    for i = #enemies, 1, -1 do
        local enemy = enemies[i]
        enemy.y = enemy.y + enemy.speed * dt
        if enemy.y > love.graphics.getHeight() then
            table.remove(enemies, i)
        end
    end

    -- Check collisions
    for i = #bullets, 1, -1 do
        local bullet = bullets[i]
        for j = #enemies, 1, -1 do
            local enemy = enemies[j]
            if checkCollision(bullet, enemy) then
                -- Create particle explosion
                createExplosion(enemy.x + enemy.width / 2, enemy.y + enemy.height / 2)
                -- Remove bullet and enemy
                table.remove(bullets, i)
                table.remove(enemies, j)
                break
            end
        end
    end

    -- Update particle systems
    for i = #particleSystems, 1, -1 do
        local ps = particleSystems[i]
        ps:update(dt)
        if ps:getCount() == 0 then
            table.remove(particleSystems, i)
        end
    end
end

function love.draw()
    -- Draw player
    love.graphics.draw(player.image, player.x, player.y)

    -- Draw bullets
    for _, bullet in ipairs(bullets) do
        love.graphics.draw(bulletImage, bullet.x, bullet.y)
    end

    -- Draw enemies
    for _, enemy in ipairs(enemies) do
        love.graphics.draw(enemyImage, enemy.x, enemy.y)
    end

    -- Draw particle systems
    for _, ps in ipairs(particleSystems) do
        love.graphics.draw(ps, 0, 0)
    end
end

function love.keypressed(key)
    if key == "space" then
        -- Fire a bullet
        table.insert(bullets, {
            x = player.x + player.width / 2 - 4,
            y = player.y,
            width = 8,
            height = 16,
            speed = 400
        })
    end
end

function checkCollision(a, b)
    return a.x < b.x + b.width and
           a.x + a.width > b.x and
           a.y < b.y + b.height and
           a.y + a.height > b.y
end

function createExplosion(x, y)
    local ps = love.graphics.newParticleSystem(explosionImage, 100)
    ps:setParticleLifetime(0.5, 1)
    ps:setEmissionRate(100)
    ps:setSizeVariation(1)
    ps:setLinearAcceleration(-200, -200, 200, 200)
    ps:setColors(1, 1, 0, 1, 1, 0.5, 0, 0, 1, 0)
    ps:setPosition(x, y)
    ps:emit(50)
    table.insert(particleSystems, ps)
end
