local HttpService = game:GetService("HttpService")


local function GetScriptsFromGitHub(RepositoryURL, Path)
    local URL = RepositoryURL.."contents/"..(Path or "")
    local Scripts = {}

    local Contents = game:HttpGet(URL)
    Contents = HttpService:JSONDecode(Contents)
    for i, Content in pairs (Contents) do
        if Content.download_url then
            local Name = Content.name
            local Source = game:HttpGet(Content.download_url)
            Scripts[Name] = Source
        end
    end

    return Scripts
end



local GitHubWorkspace = {}

function GitHubWorkspace.new(URL)
    local NewGitHubWorkspace = setmetatable({
        Modules = {},
        Scripts = {},
        GitHubURL = URL,
    }, GitHubWorkspace)

    NewGitHubWorkspace:LinkGitHub()

    return NewGitHubWorkspace
end

function GitHubWorkspace:LinkGitHub(ModulesPath, ScriptsPath)
    local Modules = GetScriptsFromGitHub(self.GitHubURL, ModulesPath or "Modules")
    for ModuleName, ModuleScript in pairs (Modules) do
        self:AddModule(ModuleName, ModuleScript)
    end

    local Scripts = GetScriptsFromGitHub(self.GitHubURL, ScriptsPath or "Scripts")
    for ScriptName, Script in pairs (Scripts) do
        self:AddScript(ScriptName, Script)
    end
end





return GitHubWorkspace