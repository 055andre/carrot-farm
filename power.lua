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

-- ⚙️ FIELD SETTINGS (ANPASSEN!)
local fieldMin = Vector3.new(-50, 0, -50)
local fieldMax = Vector3.new(50, 0, 50)

local gridSize = 6 -- etwas größer für weniger Rechenlast

local heatmap = {}

-- 🧠 Grid erstellen
for x = fieldMin.X, fieldMax.X, gridSize do
    for z = fieldMin.Z, fieldMax.Z, gridSize do
        table.insert(heatmap, {
            pos = Vector3.new(x, fieldMin.Y, z),
            value = 0
        })
    end
end

-- 🥕 Heatmap updaten
local function updateHeatmap()
    for _, cell in pairs(heatmap) do
        cell.value = 0
    end

    for _, carrot in pairs(workspace.Carrots:GetChildren()) do
        if carrot:IsA("Part") then
            local closestCell = nil
            local shortest = math.huge

            for _, cell in pairs(heatmap) do
                local dist = (carrot.Position - cell.pos).Magnitude
                if dist < shortest then
                    shortest = dist
                    closestCell = cell
                end
            end

            if closestCell then
                closestCell.value += 1
            end
        end
    end
end

-- 🎯 beste Zone finden
local function getBestCell()
    local best = nil
    local highest = 0

    for _, cell in pairs(heatmap) do
        if cell.value > highest then
            highest = cell.value
            best = cell
        end
    end

    return best
end

-- 🚶 normales Laufen
local function walkTo(pos)
    local humanoid = getHumanoid()
    humanoid:MoveTo(pos)

    humanoid.MoveToFinished:Wait()
end

-- 🔁 MAIN LOOP
while true do
    updateHeatmap()

    local target = getBestCell()

    if target then
        walkTo(target.pos)
    end

    task.wait(0.1)
end
