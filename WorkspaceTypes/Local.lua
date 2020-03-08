local HttpService = game:GetService("HttpService")

local LocalWorkspace = {}

function LocalWorkspace.new(Directory)
    local NewWorkspace = {
        Modules = {},
        Scripts = {}
    }

    local PackageJSONExists, PackageJSON = pcall(readfile, "./"..Directory.."/package.json")
    if not PackageJSONExists then
        error("Creation of Local Workspace failed. Directory "..Directory.." doesn't contain required package.json file")
    end
    PackageJSON = HttpService:JSONDecode(HttpService)

    for Index, ScriptName in pairs (PackageJSON.scripts) do
        local ScriptExists, ScriptSource = pcall(readfile, "./"..Directory.."/Scripts/"..ScriptName)
        if ScriptExists and ScriptSource then
            self:AddScript(ScriptName, ScriptSource)
        else
            warn("Script "..ScriptName.." doesn't exist in Directory "..Directory.."/Scripts".." but is listed in package.json")
        end
    end
end

function LocalWorkspace:require(ModuleName)
    print("LocalWorkspace required was called! Yay!")
    local Module = self.Modules[ModuleName]
    if Module then
        if not Module.Loaded then
            Module.Source()
            Module.Loaded = true
        end
        return Module.Source
    end
    local ModuleExists, ModuleSource = pcall(readfile, "./"..Directory.."/Modules/"..ModuleName)
    if not ModuleExists then
        error("Tried to require LocalWorkspace module "..ModuleName..", but module does not exist")
    end

    self:AddModule(ModuleName, ModuleSource)
    return self:require(ModuleName)
end

return LocalWorkspace