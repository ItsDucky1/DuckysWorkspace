local HttpService = game:GetService("HttpService")
local WorkspaceTypes = {}
local RepositoryURL = "https://api.github.com/repos/ItsDucky1/DuckysWorkspace/"

local SynapseEnv = getgenv()
SynapseEnv.oldRequire = SynapseEnv.require
SynapseEnv.require = nil
getrenv().require = nil

local Workspaces = {}

local Workspace = {}
Workspace.__index = Workspace
setmetatable(Workspaces, Workspace)


function Workspace.new(Name, Type, ...)
    local WorkspaceType = WorkspaceTypes[Type]
    if not Type then
        error("Type '"..Type.."' does not exist.")
    end

    local NewWorkspace = WorkspaceType.new(...)
    NewWorkspace.Name = Name
    Workspaces[Name] = Workspace
    return NewWorkspace
end

function Workspace:GetModule(ModuleName)
    local Module = self.Modules[ModuleName] or self.Modules[ModuleName..".lua"]
    return Module
end

function Workspace:AddModule(Name, Source)
    print("Added Module ", Name, Source)
    local NewModule = {
        Loaded = false,
        Source = loadstring(Source)
    }
    self.Modules[Name] = NewModule

    return NewModule
end

function Workspace:AddScript(ScriptName, Script)
    print("Added Script ", ScriptName)
    self.Scripts[ScriptName] = coroutine.wrap(loadstring(Script))

    return Script.Scripts[ScriptName]
end

function Workspace:require(ModuleName)
    local Module = self:GetModule(ModuleName)
    if not Module then
        return false,  "Couldn't find module '"..ModuleName.."' in the "..self.Name.." workspace."
    end

    if not Module.Loaded then
        local Success, Error = pcall(function()
            Module.Source = Module.Source()
            Module.Loaded = true
        end)
        if not Success then
            warn("Module "..ModuleName.." had an error while loading.")
            error(Error)
        elseif not Module.Source then
            error("Module "..ModuleName.." didn't return anything!")
        end
    end

    return Module.Source
end

function Workspace:Run()
    require = function(ModuleName)
        print("Override require func called ",ModuleName)
        local Module = self:require(ModuleName)
        print("Module: ", Module)
        if Module then
            return Module
        else
            for i,v in pairs (self.Modules) do print(i, v) end
            warn("Module not found with require, using reg require")
            return oldRequire(ModuleName)
        end
    end

    for ScriptName, Script in pairs (self.Scripts) do
        print("Scope Changed: Initializing Script", ScriptName)
        Script()
    end
    print("Workspace "..self.Name.." is running!")

    return true
end

-- Global Functions

function GetWorkspace(Workspace)
    return Workspaces[Workspace]
end

function HTTPRequire(URL)
    local Source = game:HttpGet(URL)
    return loadstring(Source)()
end

-- Run on Start

local WorkspaceTypesURLArray = HttpService:JSONDecode(game:HttpGet(RepositoryURL.."contents/WorkspaceTypes"))
for i, WorkspaceTypeObject in pairs (WorkspaceTypesURLArray) do
    local TypeName = WorkspaceTypeObject.name:match("(%w+).lua")
    local Source = game:HttpGet(WorkspaceTypeObject.download_url)
    print(TypeName, Source)
    local Module = loadstring(Source)()
    print(Module)
    Module.__index = Module
    setmetatable(Module, Workspace)
    WorkspaceTypes[TypeName] = Module
end


-- Return of Module

return Workspaces