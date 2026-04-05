local player = game.Players.LocalPlayer

local function getCharacter()
    return player.Character or player.CharacterAdded:Wait()
end

local function getHumanoid()
    return getCharacter():WaitForChild("Humanoid")
end

local function getRoot()
    return getCharacter():WaitForChild("HumanoidRootPart")
end

-- 🥕 Nächste Karotte finden
local function getNearestCarrot()
    local closest = nil
    local shortest = math.huge

    for _, obj in pairs(workspace:GetDescendants()) do
        if obj.Name == "Easter Carrots Costume" then
            
            local position = nil

            -- Für Parts
            if obj:IsA("BasePart") then
                position = obj.Position

            -- Für Models (sehr wichtig!)
            elseif obj:IsA("Model") then
                position = obj:GetPivot().Position
            end

            if position then
                local dist = (getRoot().Position - position).Magnitude

                if dist < shortest then
                    shortest = dist
                    closest = position
                end
            end
        end
    end

    return closest
end

-- 🚶 Bewegung (mit Timeout, damit nichts hängen bleibt)
local function walkTo(pos)
    local humanoid = getHumanoid()
    humanoid:MoveTo(pos)

    local finished = false

    local conn
    conn = humanoid.MoveToFinished:Connect(function()
        finished = true
        conn:Disconnect()
    end)

    local start = tick()
    while not finished and tick() - start < 3 do
        task.wait()
    end
end

-- 🔁 MAIN LOOP
while true do
    local target = getNearestCarrot()

    if target then
        walkTo(target)
    else
        warn("Keine Karotte gefunden!")
        task.wait(1)
    end

    task.wait(0.1)
end
