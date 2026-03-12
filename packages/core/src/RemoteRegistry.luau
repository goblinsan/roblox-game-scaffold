-- packages/core/src/RemoteRegistry.luau
-- Issue #8: Centralized RemoteEvent/RemoteFunction registry.
-- All remotes are created (server) or resolved (client) through this module so
-- that ad-hoc string names scattered across scripts are eliminated and
-- registration conventions are enforced in one place.

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local FOLDER_NAME = "Remotes"
local CLIENT_WAIT_TIMEOUT = 10 -- seconds

local RemoteRegistry = {}

local remotesFolder = nil

local function getFolder()
    if remotesFolder then
        return remotesFolder
    end
    if RunService:IsServer() then
        local existing = ReplicatedStorage:FindFirstChild(FOLDER_NAME)
        if existing then
            remotesFolder = existing
        else
            local folder = Instance.new("Folder")
            folder.Name = FOLDER_NAME
            folder.Parent = ReplicatedStorage
            remotesFolder = folder
        end
    else
        remotesFolder = ReplicatedStorage:WaitForChild(FOLDER_NAME, CLIENT_WAIT_TIMEOUT)
    end
    return remotesFolder
end

--- Register a RemoteEvent with the given name (server-side only).
--- If a remote with that name already exists it is returned unchanged.
--- Returns the RemoteEvent instance.
function RemoteRegistry.registerEvent(name)
    assert(RunService:IsServer(), "[RemoteRegistry] registerEvent must be called on the server")
    local folder = getFolder()
    local existing = folder:FindFirstChild(name)
    if existing then
        return existing
    end
    local remote = Instance.new("RemoteEvent")
    remote.Name = name
    remote.Parent = folder
    return remote
end

--- Register a RemoteFunction with the given name (server-side only).
--- If a remote with that name already exists it is returned unchanged.
--- Returns the RemoteFunction instance.
function RemoteRegistry.registerFunction(name)
    assert(RunService:IsServer(), "[RemoteRegistry] registerFunction must be called on the server")
    local folder = getFolder()
    local existing = folder:FindFirstChild(name)
    if existing then
        return existing
    end
    local remote = Instance.new("RemoteFunction")
    remote.Name = name
    remote.Parent = folder
    return remote
end

--- Retrieve a registered remote by name.
--- On the server returns immediately (nil if not found).
--- On the client waits up to CLIENT_WAIT_TIMEOUT seconds for the remote to
--- replicate before returning (nil on timeout).
function RemoteRegistry.get(name)
    local folder = getFolder()
    if RunService:IsServer() then
        return folder:FindFirstChild(name)
    end
    return folder:WaitForChild(name, CLIENT_WAIT_TIMEOUT)
end

return RemoteRegistry
