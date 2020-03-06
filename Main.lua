local HttpService = game:GetService("HttpService")
local WorkspaceTypes = {}

local WorkspaceTypesURLArray = {}





local Workspaces = {}


local Workspace = {}
Workspace.__index = Workspace
setmetatable(Workspaces, Workspace)


function Workspace.new(Name, Type, Settings, PresetWorkspace)
    local NewWorkspace;
    if Type == "Local" then
        
    elseif Type == "GitHub" then

    end
    NewWorkspace.Modules = NewWorkspace.Modules or {}
    NewWorkspace.Scripts = NewWorkspace.Scripts or 
end

-- Global Functions 

function HTTPRequire(URL)
    local Source = game:HttpGet(URL)
    return loadstring(Source)()
end



-- Return of Module

return Workspaces