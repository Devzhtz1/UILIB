--[[
    ╔═══════════════════════════════════════════════════════════════════╗
    ║                      FLUID UI LIBRARY                              ║
    ║                    Complete Usage Example                          ║
    ╠═══════════════════════════════════════════════════════════════════╣
    ║  GitHub: https://github.com/Devzhtz1/UILIB                        ║
    ║  Version: 2.0.0                                                    ║
    ║  Author: Devzhtz1                                                  ║
    ╚═══════════════════════════════════════════════════════════════════╝
--]]

-----------------------------------------------------------------
-- CARREGANDO A BIBLIOTECA VIA URL
-----------------------------------------------------------------
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Devzhtz1/UILIB/main/loader.lua"))()

-----------------------------------------------------------------
-- ACESSANDO MÓDULOS
-----------------------------------------------------------------
local ESP = Library.ESP
local Toggles = Library.Toggles
local Options = Library.Options
local Flags = Library.Flags

-----------------------------------------------------------------
-- CONFIGURAÇÃO DA TECLA DO MENU
-----------------------------------------------------------------
Library.ToggleKey = Enum.KeyCode.RightControl -- Tecla para abrir/fechar

-----------------------------------------------------------------
-- CRIANDO A JANELA PRINCIPAL
-----------------------------------------------------------------
local Window = Library:CreateWindow({
    Title = "Fluid UI Library | by Devzhtz1",
    Center = true,
    AutoShow = true,
    TabPadding = 2,
    MenuFadeTime = 0.2,
})

--=================================================================
--                         ABA MAIN
--=================================================================
local MainTab = Window:AddTab("Main", "Person") -- Tab com ícone opcional

-----------------------------------------------------------------
-- GROUPBOX ESQUERDO - Features Principais
-----------------------------------------------------------------
local MainGroup = MainTab:AddLeftGroupbox("GENERAL") -- Título em uppercase estilo Vizor

-- Toggle simples (com botão de config e descrição estilo Vizor)
MainGroup:AddToggle("Enabled", {
    Text = "Enable Script",
    Default = true,
    Description = "Includes the basic functions of the script", -- Descrição estilo Vizor
    Tooltip = "Liga/desliga o script",
    ConfigButton = true, -- Mostra botão de config (padrão: true)
    ConfigCallback = function(Toggle)
        Library:Notify("Config button clicked!", 3)
        -- Aqui você pode abrir um menu de configurações
    end,
    Callback = function(Value)
        print("Script enabled:", Value)
    end
})

-- Toggle Risky (aparece em vermelho)
MainGroup:AddToggle("RiskyMode", {
    Text = "Risky Mode",
    Default = false,
    Risky = true,
    Tooltip = "Essa feature pode ser detectada!",
    Callback = function(Value)
        print("Risky mode:", Value)
    end
})

-- Botão simples
MainGroup:AddButton({
    Text = "Click Me",
    Tooltip = "Clique para executar",
    Func = function()
        Library:Notify("Botão clicado!", 3)
    end
})

-- Botão com confirmação (double click)
MainGroup:AddButton({
    Text = "Reset Settings",
    DoubleClick = true,
    Tooltip = "Clique duas vezes para confirmar",
    Func = function()
        Library:Notify("Configurações resetadas!", 3)
    end
})

-- Dois botões lado a lado
MainGroup:AddButton({
    Text = "Save",
    Func = function()
        Library:Notify("Salvo!", 2)
    end
}):AddButton({
    Text = "Load",
    Func = function()
        Library:Notify("Carregado!", 2)
    end
})

-- Slider
MainGroup:AddSlider("WalkSpeed", {
    Text = "Walk Speed",
    Default = 16,
    Min = 0,
    Max = 200,
    Rounding = 0,
    Suffix = " studs/s",
    Callback = function(Value)
        local player = game:GetService("Players").LocalPlayer
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.WalkSpeed = Value
        end
    end
})

MainGroup:AddSlider("JumpPower", {
    Text = "Jump Power",
    Default = 50,
    Min = 0,
    Max = 300,
    Rounding = 0,
    Callback = function(Value)
        local player = game:GetService("Players").LocalPlayer
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.JumpPower = Value
        end
    end
})

-----------------------------------------------------------------
-- GROUPBOX DIREITO - Configurações
-----------------------------------------------------------------
local SettingsGroup = MainTab:AddRightGroupbox("SETTINGS") -- Título em uppercase estilo Vizor

-- Dropdown de tema
SettingsGroup:AddDropdown("Theme", {
    Text = "UI Theme",
    Values = Library:GetThemeNames(),
    Default = "Default",
    Callback = function(Value)
        Library:SetTheme(Value)
        Library:Notify("Tema alterado: " .. Value, 3)
    end
})

-- Dropdown multi-seleção
SettingsGroup:AddDropdown("Features", {
    Text = "Active Features",
    Values = {"Aimbot", "ESP", "Speed", "Fly"},
    Default = {"ESP"},
    Multi = true,
    Callback = function(Value)
        local selected = {}
        for name, enabled in pairs(Value) do
            if enabled then table.insert(selected, name) end
        end
        print("Features ativas:", table.concat(selected, ", "))
    end
})

-- Input de texto
SettingsGroup:AddInput("Username", {
    Text = "Custom Name",
    Default = "",
    Placeholder = "Digite seu nome...",
    Callback = function(Value)
        print("Nome:", Value)
    end
})

-- Input numérico
SettingsGroup:AddInput("Delay", {
    Text = "Delay (ms)",
    Default = "100",
    Numeric = true,
    Finished = true,
    Callback = function(Value)
        print("Delay:", Value)
    end
})

-- Label com ColorPicker
local AccentLabel = SettingsGroup:AddLabel("Accent Color")
AccentLabel:AddColorPicker("AccentColor", {
    Default = Library.AccentColor,
    Title = "Cor de Destaque",
    Callback = function(Value)
        Library:SetAccentColor(Value)
    end
})

-- Divider
SettingsGroup:AddDivider()

-- Label com wrap
SettingsGroup:AddLabel("Aurora UI Library - Uma biblioteca moderna de UI para Roblox.", true)

--=================================================================
--                         ABA ESP
--=================================================================
local ESPTab = Window:AddTab("ESP", "Eye") -- Tab com ícone

-----------------------------------------------------------------
-- GROUPBOX ESQUERDO - ESP Settings
-----------------------------------------------------------------
local ESPGroup = ESPTab:AddLeftGroupbox("ESP SETTINGS")

ESPGroup:AddToggle("ESPEnabled", {
    Text = "Enable ESP",
    Default = false,
    Callback = function(Value)
        ESP:Toggle(Value)
    end
})

ESPGroup:AddToggle("ESPBox", {
    Text = "Box ESP",
    Default = true,
    Callback = function(Value)
        ESP.BoxEnabled = Value
    end
})

ESPGroup:AddToggle("ESPName", {
    Text = "Name ESP",
    Default = true,
    Callback = function(Value)
        ESP.NameEnabled = Value
    end
})

ESPGroup:AddToggle("ESPHealth", {
    Text = "Health Bar",
    Default = true,
    Callback = function(Value)
        ESP.HealthEnabled = Value
    end
})

ESPGroup:AddToggle("ESPDistance", {
    Text = "Distance",
    Default = true,
    Callback = function(Value)
        ESP.DistanceEnabled = Value
    end
})

ESPGroup:AddToggle("ESPTracer", {
    Text = "Tracers",
    Default = false,
    Callback = function(Value)
        ESP.TracerEnabled = Value
    end
})

ESPGroup:AddToggle("ESPChams", {
    Text = "Chams",
    Default = false,
    Callback = function(Value)
        ESP.ChamsEnabled = Value
    end
})

ESPGroup:AddDivider()

ESPGroup:AddToggle("ESPTeamCheck", {
    Text = "Team Check",
    Default = false,
    Callback = function(Value)
        ESP.TeamCheck = Value
    end
})

ESPGroup:AddSlider("ESPMaxDistance", {
    Text = "Max Distance",
    Default = 1000,
    Min = 100,
    Max = 5000,
    Rounding = 0,
    Suffix = " studs",
    Callback = function(Value)
        ESP.MaxDistance = Value
    end
})

-----------------------------------------------------------------
-- GROUPBOX DIREITO - ESP Colors
-----------------------------------------------------------------
local ESPColorsGroup = ESPTab:AddRightGroupbox("ESP Colors")

local BoxColorLabel = ESPColorsGroup:AddLabel("Box Color")
BoxColorLabel:AddColorPicker("ESPBoxColor", {
    Default = Color3.fromRGB(255, 255, 255),
    Title = "Cor do Box",
    Callback = function(Value)
        ESP.BoxColor = Value
    end
})

local TracerLabel = ESPColorsGroup:AddLabel("Tracer Color")
TracerLabel:AddColorPicker("ESPTracerColor", {
    Default = Color3.fromRGB(255, 255, 255),
    Title = "Cor do Tracer",
    Callback = function(Value)
        ESP.TracerColor = Value
    end
})

local ChamsLabel = ESPColorsGroup:AddLabel("Chams Color")
ChamsLabel:AddColorPicker("ESPChamsColor", {
    Default = Color3.fromRGB(255, 0, 255),
    Title = "Cor do Chams",
    Callback = function(Value)
        ESP.ChamsColor = Value
    end
})

ESPColorsGroup:AddDropdown("TracerOrigin", {
    Text = "Tracer Origin",
    Values = {"Bottom", "Center", "Mouse"},
    Default = "Bottom",
    Callback = function(Value)
        ESP.TracerOrigin = Value
    end
})

--=================================================================
--                         ABA VISUALS
--=================================================================
local VisualsTab = Window:AddTab("Visuals")

-----------------------------------------------------------------
-- GROUPBOX ESQUERDO - World
-----------------------------------------------------------------
local WorldGroup = VisualsTab:AddLeftGroupbox("World")

WorldGroup:AddToggle("Fullbright", {
    Text = "Fullbright",
    Default = false,
    Callback = function(Value)
        local lighting = game:GetService("Lighting")
        if Value then
            lighting.Brightness = 2
            lighting.ClockTime = 14
            lighting.FogEnd = 100000
            lighting.GlobalShadows = false
        else
            lighting.Brightness = 1
            lighting.GlobalShadows = true
        end
    end
})

WorldGroup:AddToggle("NoFog", {
    Text = "Remove Fog",
    Default = false,
    Callback = function(Value)
        game:GetService("Lighting").FogEnd = Value and 100000 or 1000
    end
})

WorldGroup:AddSlider("Brightness", {
    Text = "Brightness",
    Default = 1,
    Min = 0,
    Max = 5,
    Rounding = 1,
    Callback = function(Value)
        game:GetService("Lighting").Brightness = Value
    end
})

WorldGroup:AddSlider("TimeOfDay", {
    Text = "Time",
    Default = 14,
    Min = 0,
    Max = 24,
    Rounding = 1,
    Callback = function(Value)
        game:GetService("Lighting").ClockTime = Value
    end
})

WorldGroup:AddSlider("FOV", {
    Text = "Field of View",
    Default = 70,
    Min = 30,
    Max = 120,
    Rounding = 0,
    Suffix = "°",
    Callback = function(Value)
        workspace.CurrentCamera.FieldOfView = Value
    end
})

-----------------------------------------------------------------
-- GROUPBOX DIREITO - UI
-----------------------------------------------------------------
local UIGroup = VisualsTab:AddRightGroupbox("UI Settings")

UIGroup:AddToggle("Watermark", {
    Text = "Show Watermark",
    Default = false,
    Callback = function(Value)
        Library:SetWatermarkVisibility(Value)
        if Value then
            Library:SetWatermark("Aurora UI | by Devzhtz1")
        end
    end
})

UIGroup:AddToggle("KeybindList", {
    Text = "Show Keybind List",
    Default = false,
    Callback = function(Value)
        Library:SetKeyListVisibility(Value)
    end
})

UIGroup:AddToggle("WindowGlow", {
    Text = "Window Glow",
    Default = false,
    Callback = function(Value)
        Library:SetGlowVis(Value)
    end
})

UIGroup:AddDivider()

UIGroup:AddButton({
    Text = "Test Notification",
    Func = function()
        Library:Notify("Isso é uma notificação de teste!", 5)
    end
})

UIGroup:AddButton({
    Text = "Center Notification",
    Func = function()
        Library:Notify("Notificação centralizada!", 3, "center")
    end
})

--=================================================================
--                         ABA MISC
--=================================================================
local MiscTab = Window:AddTab("Misc")

-----------------------------------------------------------------
-- GROUPBOX ESQUERDO - Misc
-----------------------------------------------------------------
local MiscGroup = MiscTab:AddLeftGroupbox("Miscellaneous")

MiscGroup:AddToggle("AntiAFK", {
    Text = "Anti-AFK",
    Default = false,
    Tooltip = "Impede kick por inatividade",
    Callback = function(Value)
        if Value then
            local vu = game:GetService("VirtualUser")
            game:GetService("Players").LocalPlayer.Idled:Connect(function()
                vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                task.wait(1)
                vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
            end)
            Library:Notify("Anti-AFK ativado!", 3)
        end
    end
})

-- Toggle com KeyPicker
MiscGroup:AddToggle("InfiniteJump", {
    Text = "Infinite Jump",
    Default = false,
})

Toggles.InfiniteJump:AddKeyPicker("InfiniteJumpKey", {
    Default = "Space",
    Mode = "Hold",
    Callback = function(Active)
        if Active and Toggles.InfiniteJump.Value then
            local player = game:GetService("Players").LocalPlayer
            if player.Character and player.Character:FindFirstChild("Humanoid") then
                player.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end
    end
})

MiscGroup:AddToggle("Noclip", {
    Text = "Noclip",
    Default = false,
    Risky = true,
})

Toggles.Noclip:AddKeyPicker("NoclipKey", {
    Default = "V",
    Mode = "Toggle",
    SyncToggleState = true,
})

MiscGroup:AddDivider()

MiscGroup:AddButton({
    Text = "Rejoin Server",
    DoubleClick = true,
    Func = function()
        game:GetService("TeleportService"):Teleport(game.PlaceId, game:GetService("Players").LocalPlayer)
    end
})

MiscGroup:AddButton({
    Text = "Copy Game Link",
    Func = function()
        if setclipboard then
            setclipboard("https://www.roblox.com/games/" .. game.PlaceId)
            Library:Notify("Link copiado!", 3)
        else
            Library:Notify("Clipboard não suportado!", 3)
        end
    end
})

-----------------------------------------------------------------
-- GROUPBOX DIREITO - DependencyBox
-----------------------------------------------------------------
local CondGroup = MiscTab:AddRightGroupbox("Conditional Features")

CondGroup:AddToggle("ShowAdvanced", {
    Text = "Show Advanced Options",
    Default = false,
})

-- Elementos condicionais
local AdvBox = CondGroup:AddDependencyBox()
AdvBox:SetupDependencies({
    { Toggles.ShowAdvanced, true }
})

AdvBox:AddLabel("Opções avançadas visíveis!")

AdvBox:AddSlider("AdvValue", {
    Text = "Advanced Value",
    Default = 50,
    Min = 0,
    Max = 100,
    Rounding = 0,
})

AdvBox:AddToggle("AdvToggle", {
    Text = "Advanced Toggle",
    Default = false,
})

AdvBox:AddDropdown("AdvDropdown", {
    Text = "Advanced Mode",
    Values = {"Mode A", "Mode B", "Mode C"},
    Default = "Mode A",
})

--=================================================================
--                         ABA INFO
--=================================================================
local InfoTab = Window:AddTab("Info")

-----------------------------------------------------------------
-- GROUPBOX ESQUERDO - About
-----------------------------------------------------------------
local AboutGroup = InfoTab:AddLeftGroupbox("About")

AboutGroup:AddLabel("Aurora UI Library")
AboutGroup:AddLabel("Version: 1.0.0")
AboutGroup:AddLabel("Author: Devzhtz1")
AboutGroup:AddDivider()
AboutGroup:AddLabel("Uma biblioteca de UI moderna e completa para Roblox.", true)
AboutGroup:AddLabel("")
AboutGroup:AddLabel("Features:", true)
AboutGroup:AddLabel("• 8 temas de cores", true)
AboutGroup:AddLabel("• Sistema ESP completo", true)
AboutGroup:AddLabel("• Todos os elementos de UI", true)
AboutGroup:AddLabel("• Cores customizáveis", true)
AboutGroup:AddLabel("• Watermark & Keybinds", true)

-----------------------------------------------------------------
-- GROUPBOX DIREITO - Links
-----------------------------------------------------------------
local LinksGroup = InfoTab:AddRightGroupbox("Links")

LinksGroup:AddLabel("GitHub:")
LinksGroup:AddButton({
    Text = "Copy GitHub Link",
    Func = function()
        if setclipboard then
            setclipboard("https://github.com/Devzhtz1/UILIB")
            Library:Notify("Link do GitHub copiado!", 3)
        end
    end
})

LinksGroup:AddDivider()

LinksGroup:AddLabel("Raw Files:")
LinksGroup:AddButton({
    Text = "Copy Loader URL",
    Func = function()
        if setclipboard then
            setclipboard('loadstring(game:HttpGet("https://raw.githubusercontent.com/Devzhtz1/UILIB/main/loader.lua"))()')
            Library:Notify("Loader copiado!", 3)
        end
    end
})

LinksGroup:AddDivider()

LinksGroup:AddButton({
    Text = "Unload Script",
    DoubleClick = true,
    Func = function()
        Library:Notify("Descarregando...", 2)
        task.wait(1)
        Library:Unload()
    end
})

--=================================================================
--                         ABA TABBOX
--=================================================================
local TabboxTab = Window:AddTab("Tabbox")

-- Tabbox à esquerda
local LeftTabbox = TabboxTab:AddLeftTabbox("Settings")

local Tab1 = LeftTabbox:AddTab("General")
Tab1:AddToggle("TbToggle1", { Text = "General Toggle 1", Default = false })
Tab1:AddToggle("TbToggle2", { Text = "General Toggle 2", Default = false })
Tab1:AddSlider("TbSlider1", { Text = "General Slider", Default = 50, Min = 0, Max = 100, Rounding = 0 })

local Tab2 = LeftTabbox:AddTab("Advanced")
Tab2:AddToggle("TbToggle3", { Text = "Advanced Toggle", Default = false })
Tab2:AddInput("TbInput1", { Text = "Advanced Input", Default = "", Placeholder = "Type..." })

local Tab3 = LeftTabbox:AddTab("Extra")
Tab3:AddLabel("Conteúdo extra aqui")
Tab3:AddButton({ Text = "Extra Button", Func = function() Library:Notify("Extra!", 2) end })

-- Groupbox normal à direita
local RightGroup = TabboxTab:AddRightGroupbox("Normal Groupbox")
RightGroup:AddLabel("Groupbox normal ao lado do Tabbox")
RightGroup:AddToggle("NormalToggle", { Text = "Normal Toggle", Default = false })

--=================================================================
--                     INICIALIZAÇÃO
--=================================================================

-- Iniciar ESP (desativado por padrão)
ESP:Start()

-- Atualizar watermark com FPS
task.spawn(function()
    while Library.Toggled ~= nil do
        task.wait(0.5)
        if Library.Watermark and Library.Watermark.Visible then
            local fps = math.floor(1 / game:GetService("RunService").RenderStepped:Wait())
            local ping = 0
            pcall(function()
                ping = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()
            end)
            Library:SetWatermark(string.format("Aurora UI | FPS: %d | Ping: %dms | by Devzhtz1", fps, math.floor(ping)))
        end
    end
end)

-- Notificações de carregamento
Library:Notify("Fluid UI Library carregada com sucesso!", 5)
Library:Notify("Pressione RightControl para abrir/fechar o menu", 5)

-- Print no console
print([[
╔════════════════════════════════════════════════════════╗
║           Fluid UI Library Loaded!                     ║
╠════════════════════════════════════════════════════════╣
║  Toggle Menu: RightControl                             ║
║  GitHub: https://github.com/Devzhtz1/UILIB             ║
║  Author: Devzhtz1                                      ║
╚════════════════════════════════════════════════════════╝
]])
