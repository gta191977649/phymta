Ball = class()

local gravity = Vector3(0, 0, -9.81)

function Ball:init(position, radius)
    self.position = position
    self.radius = radius
    self.rotation = rotation or Vector3(0, 0, 0)
    self.velocity = Vector3(0, 0, 0)
    self.isStill = false
    self.friction = 0.9
    self.elasticity = 1
    self.lastStill = {
        position = position,
        velocity = Vector3(0, 0, 0)
    }
end

function Ball:update(dt)
    if not self.isStill then
        local dt = dt / 1000

        -- Apply gravity
        self.velocity = self.velocity + (gravity * dt)

        -- Predict the ball's future position
        local futurePosition = self.position + self.velocity * dt


    
        -- Raycast in the direction of movement to check for collisions
        local hit, hitX, hitY, hitZ, _,hitNormalX, hitNormalY, hitNormalZ = processLineOfSight(self.position.x, self.position.y, self.position.z, futurePosition.x, futurePosition.y, futurePosition.z, true, true, true, true, false, false, false, false, getLocalPlayer(), true, false)

        if debug then
            -- debug line shit
            local scaleFactor = 10 -- Adjust this value as needed
            -- Calculate the end point for the longer line
            local lineEndPoint = self.position + self.velocity * dt * scaleFactor
            -- Draw the debug line
            dxDrawLine3D(self.position.x, self.position.y, self.position.z, lineEndPoint.x, lineEndPoint.y, lineEndPoint.z,hit and  tocolor(255, 0, 0, 255) or tocolor(0, 255, 0, 255), 1)
        end


        if hit then
            -- Collision detected
            local collisionNormal = Vector3(hitNormalX, hitNormalY, hitNormalZ)
            collisionNormal:normalize()

        
            -- Adjust the velocity for collision response
            local velocityNormalComponent = self.velocity:dot(collisionNormal) * collisionNormal
            self.velocity = self.velocity - (1 + self.elasticity) * velocityNormalComponent

            -- Apply friction to horizontal components
            self.velocity.x = self.velocity.x * self.friction
            self.velocity.y = self.velocity.y * self.friction

            -- Adjust futurePosition based on the updated velocity after collision
            futurePosition = self.position + self.velocity * dt

            -- Check if the ball's movement is below the threshold
            local velocityLength = self.velocity:getLength()
            print(velocityLength)
            if velocityLength < 1 then
                self.stillCount = self.stillCount + 1
                if self.stillCount > 3 then
                    self.isStill = true
                end
            else
                self.stillCount = 0
            end
            
        end
        self.position = futurePosition
    end

end




function Ball:renderDebug()
    dxDrawWiredSphere(self.position.x, self.position.y, self.position.z, self.radius, 0xFF0000FF, 1.0, 3)
end
