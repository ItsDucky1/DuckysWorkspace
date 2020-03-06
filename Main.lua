local HttpService = game:GetService("HttpService")
local WorkspaceTypes = {}
local RepositoryURL = "https://api.github.com/repos/ItsDucky1/DuckysWorkspace/"

local WorkspaceTypesURLArray = HttpService:JSONDecode(game:HttpGet(RepositoryURL.."contents/WorkspaceTypes"))
for i, WorkspaceTypeObject in pairs (WorkspaceTypesURLArray) do
    local TypeName = WorkspaceTypeObject:match("(%w+).lua")
    local Source = game:HttpGet(WorkspaceTypeObject.download_url)
    WorkspaceTypes[TypeName] = loadstring(Source)()
    print("Added Type "..TypeName)
end

local Workspaces = {}


local Workspace = {}
Workspace.__index = Workspace
setmetatable(Workspaces, Workspace)


function Workspace.new(Name, Type, Settings, PresetWorkspace)
    local NewWorkspace;
    local WorkspaceType = WorkspaceTypes[Type]
    if not Type then
        error("Type '"..Type.."' does not exist.")
    end
    NewWorkspace = WorkspaceType.new(Settings, PresetWorkspace)

    Workspaces[Name] = Workspace
end

-- Global Functions 

function HTTPRequire(URL)
    local Source = game:HttpGet(URL)
    return loadstring(Source)()
end



-- Return of Module

return Workspaces