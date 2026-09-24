local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local EVENT_FOLDER = ServerScriptService.Services:WaitForChild("Events")

local remotesFolder = ReplicatedStorage:FindFirstChild("SurvivalRemotes") or Instance.new("Folder")
remotesFolder.Name = "SurvivalRemotes"
remotesFolder.Parent = ReplicatedStorage

local eventRemote = remotesFolder:FindFirstChild("Event") or Instance.new("RemoteEvent")
eventRemote.Name = "Event"
eventRemote.Parent = remotesFolder

local events = {}
local rng = Random.new()

for _, module in EVENT_FOLDER:GetChildren() do
    if module:IsA("ModuleScript") then
        local event = require(module)
        if type(event.Run) == "function" then
            table.insert(events, event)
        end
    end
end

local Shared = {}

function Shared.OnStart()
end

function Shared.RunRandomEvent(duration: number?)
    if #events == 0 then
        warn("EventService: no events found")
        return nil
    end

    local arena = workspace:WaitForChild("Arena")
    local event = events[rng:NextInteger(1, #events)]
    local eventDuration = duration or rng:NextInteger(8, 14)

    eventRemote:FireAllClients("start", event.Name, eventDuration)

    local ok, errorMessage = pcall(function()
        event.Run(arena, eventDuration, rng)
    end)

    if not ok then
        warn("EventService failed: " .. tostring(errorMessage))
    end

    eventRemote:FireAllClients("end", event.Name)
    return event.Name
end

function Shared.Broadcast(kind: string, ...)
    eventRemote:FireAllClients(kind, ...)
end

return Shared
