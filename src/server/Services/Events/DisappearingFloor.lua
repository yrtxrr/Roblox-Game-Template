local TweenService = game:GetService("TweenService")

local Event = {}
Event.Name = "Исчезающий пол"

function Event.Run(arena, duration, rng)
    local floorModel = arena:FindFirstChild("Floor")
    local main = floorModel and floorModel:FindFirstChild("Main")
    if not main then return end

    local originalCFrame = main.CFrame
    local originalSize = main.Size
    local pieces = {}

    main.Transparency = 1
    main.CanCollide = false

    local pieceSize = 10
    local half = 55

    for x = -half, half - pieceSize, pieceSize do
        for z = -half, half - pieceSize, pieceSize do
            local piece = Instance.new("Part")
            piece.Name = "FloorPiece"
            piece.Size = Vector3.new(pieceSize - 0.35, 2, pieceSize - 0.35)
            piece.Position = Vector3.new(x + pieceSize / 2, 0, z + pieceSize / 2)
            piece.Anchored = true
            piece.Material = Enum.Material.Concrete
            piece.Color = main.Color
            piece.Parent = floorModel
            table.insert(pieces, piece)
        end
    end

    for i = #pieces, 2, -1 do
        local j = rng:NextInteger(1, i)
        pieces[i], pieces[j] = pieces[j], pieces[i]
    end

    local removeCount = math.floor(#pieces * 0.35)
    for i = 1, removeCount do
        local piece = pieces[i]
        piece.CanCollide = false
        TweenService:Create(piece, TweenInfo.new(0.25), {Transparency = 1}):Play()
    end

    task.wait(duration)

    for _, piece in pieces do
        if piece.Parent then
            piece:Destroy()
        end
    end

    main.CFrame = originalCFrame
    main.Size = originalSize
    main.Transparency = 0
    main.CanCollide = true
end

return Event
