local ball = Ball(Vector3(-2417.99609, -609.40497, 132.5625), 0.5)

addEventHandler('onClientRender', root, function()
    ball:renderDebug()
end)

addEventHandler('onClientPreRender', root, function(dt)
    ball:update(dt)
end)

bindKey('b', 'down', function()
    local matrix = getElementMatrix(getCamera())
    ball.position = Vector3(getElementPosition(getCamera())) + Vector3(matrix[2][1], matrix[2][2], matrix[2][3]) * 5
    ball.velocity = Vector3(matrix[2][1], matrix[2][2], matrix[2][3]) * 10
    ball.isStill = false
end)