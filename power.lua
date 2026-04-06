local player = game.Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local running = false
local positions = {}
local currentTween = nil

local function getCharacter()
    return player.Character or player.CharacterAdded:Wait()
end

local function getRoot()
    return getCharacter():WaitForChild("HumanoidRootPart")
end

-- 📍 Position speichern (F1)
local function savePosition()
    local root = getRoot()
    table.insert(positions, root.Position)
    print("Position gespeichert:", #positions)
end

-- 🚀 Tween zu Position
local function tweenTo(pos)
    local root = getRoot()

    if currentTween then
        currentTween:Cancel()
    end

    local distance = (root.Position - pos).Magnitude
    local speed = 60
    local time = math.clamp(distance / speed, 0.1, 3)

    local tweenInfo = TweenInfo.new(time, Enum.EasingStyle.Linear)

    currentTween = TweenService:Create(root, tweenInfo, {
        CFrame = CFrame.new(pos + Vector3.new(0, 3, 0))
    })

    currentTween:Play()
    currentTween.Completed:Wait()
end

-- 🔁 Route Loop
local function routeLoop()
    while running do
        if #positions == 0 then
            warn("Keine Positionen gespeichert!")
            task.wait(1)
            continue
        end

        for i, pos in ipairs(positions) do
            if not running then break end
            print("Gehe zu Punkt:", i)
            tweenTo(pos)
            task.wait(0.2)
        end
    end
end

-- 🎮 Controls
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end

    if input.KeyCode == Enum.KeyCode.F1 then
        savePosition()
    end

    if input.KeyCode == Enum.KeyCode.F8 then
        running = not running
        print("Route Farm:", running and "AN" or "AUS")

        if running then
            task.spawn(routeLoop)
        else
            if currentTween then
                currentTween:Cancel()
            end
        end
    end
end)
