--[[
    Aurora UI Library - Loader
    GitHub: https://github.com/Devzhtz1/UILIB
    Author: Devzhtz1
    
    USO:
    local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Devzhtz1/UILIB/main/loader.lua"))()
--]]

local GITHUB_RAW = "https://raw.githubusercontent.com/Devzhtz1/UILIB/main/"

print("[Aurora UI] Carregando biblioteca...")

-- Carregar dependências
local Signal = loadstring(game:HttpGet(GITHUB_RAW .. "Signal.lua"))()
local Spring = loadstring(game:HttpGet(GITHUB_RAW .. "Spring.lua"))()

-- Módulos fake para require
local FakeModules = {
    Signal = Signal,
    Spring = Spring,
}

-- Carregar outros módulos
local Icons = loadstring(game:HttpGet(GITHUB_RAW .. "Icons.lua"))()
local BaseAddons = loadstring(game:HttpGet(GITHUB_RAW .. "BaseAddons.lua"))()
local Elements = loadstring(game:HttpGet(GITHUB_RAW .. "Elements.lua"))()
local Window = loadstring(game:HttpGet(GITHUB_RAW .. "Window.lua"))()
local ESP = loadstring(game:HttpGet(GITHUB_RAW .. "ESP.lua"))()

FakeModules.Icons = Icons
FakeModules.BaseAddons = BaseAddons
FakeModules.Elements = Elements
FakeModules.Window = Window
FakeModules.ESP = ESP

-- Components loader
local Components = {}
function Components:Init(Library, Toggles, Options, ScreenGui)
    local IconsModule = FakeModules.Icons
    local BaseAddonsModule = FakeModules.BaseAddons
    local ElementsModule = FakeModules.Elements
    local WindowModule = FakeModules.Window
    
    -- Carregar sistema de ícones
    Library.Icons = IconsModule
    
    -- Inicializar funções de addons (ColorPicker, KeyPicker)
    local AddonFuncs = BaseAddonsModule:Init(Library, Toggles, Options, ScreenGui)
    
    -- Criar BaseAddons metatable para Labels
    local BaseAddons = {}
    BaseAddons.__index = AddonFuncs
    
    -- Inicializar funções de elementos
    local ElementFuncs = ElementsModule:Init(Library, Toggles, Options, ScreenGui, BaseAddons)
    
    -- Criar BaseGroupbox metatable
    local BaseGroupbox = {}
    BaseGroupbox.__index = ElementFuncs
    
    -- Inicializar Window
    WindowModule:Init(Library, Toggles, Options, ScreenGui, BaseGroupbox)
    
    -- Watermark
    do
        local WatermarkOuter = Library:Create('Frame', {
            BorderColor3 = Color3.new(0, 0, 0),
            BorderSizePixel = 0,
            Position = UDim2.new(0, 10, 0, 10),
            Size = UDim2.new(0, 213, 0, 21),
            ZIndex = 200,
            Visible = false,
            Parent = ScreenGui,
        })
        
        local WatermarkInner = Library:Create('Frame', {
            BackgroundColor3 = Library.MainColor,
            BorderColor3 = Library.OutlineColor,
            BorderSizePixel = 1,
            Size = UDim2.new(1, 0, 1, 0),
            ZIndex = 201,
            Parent = WatermarkOuter,
        })
        
        Library:AddToRegistry(WatermarkInner, {
            BackgroundColor3 = 'MainColor',
            BorderColor3 = 'OutlineColor',
        })
        
        local InnerFrame = Library:Create('Frame', {
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 1, 0, 1),
            Size = UDim2.new(1, -2, 1, -2),
            ZIndex = 202,
            Parent = WatermarkInner,
        })
        
        local FrameLine = Library:Create('Frame', {
            BackgroundColor3 = Library.AccentColor,
            BorderSizePixel = 0,
            Position = UDim2.new(0, -1, 1, 0),
            Size = UDim2.new(1, 1, 0, 2),
            ZIndex = 202,
            Parent = WatermarkInner,
        })
        
        Library:AddToRegistry(FrameLine, {
            BackgroundColor3 = 'AccentColor',
        })
        
        local WatermarkLabel = Library:CreateLabel({
            Position = UDim2.new(0, 5, 0, 0),
            Size = UDim2.new(1, -10, 1, 0),
            TextSize = 15,
            RichText = true,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 203,
            Parent = InnerFrame,
        })
        
        Library.Watermark = WatermarkOuter
        Library.WatermarkText = WatermarkLabel
        Library:MakeDraggable(Library.Watermark)
        
        function Library:SetWatermarkVisibility(Bool)
            Library.Watermark.Visible = Bool
        end
        
        function Library:SetWatermark(Text)
            local cleanText = string.gsub(Text, "<.->", "")
            local X = Library:GetTextBounds(cleanText, Library.Font, 15)
            Library.Watermark.Size = UDim2.new(0, X + 18, 0, 21)
            Library.WatermarkText.Text = Text
        end
    end
    
    -- Keybind List
    do
        local KeybindOuter = Library:Create('Frame', {
            BorderSizePixel = 0,
            Position = UDim2.new(0, 10, 0.5, 0),
            Size = UDim2.new(0, 210, 0, 20),
            Visible = false,
            ZIndex = 100,
            Parent = ScreenGui,
        })
        
        local KeybindInner = Library:Create('Frame', {
            BackgroundColor3 = Library.MainColor,
            BorderColor3 = Library.OutlineColor,
            BorderMode = Enum.BorderMode.Inset,
            Size = UDim2.new(1, 0, 1, 7),
            ZIndex = 101,
            Parent = KeybindOuter,
        })
        
        Library:AddToRegistry(KeybindInner, {
            BackgroundColor3 = 'MainColor',
            BorderColor3 = 'OutlineColor',
        }, true)
        
        local FrameLine = Library:Create('Frame', {
            BackgroundColor3 = Library.AccentColor,
            BorderSizePixel = 0,
            Position = UDim2.new(0, 0, 0, 24),
            Size = UDim2.new(1, 0, 0, 2),
            ZIndex = 202,
            Parent = KeybindInner,
        })
        
        Library:AddToRegistry(FrameLine, {
            BackgroundColor3 = 'AccentColor',
        })
        
        Library:CreateLabel({
            Size = UDim2.new(1, 0, 0, 20),
            Position = UDim2.fromOffset(5, 2),
            TextXAlignment = Enum.TextXAlignment.Center,
            Text = 'Keybinds',
            ZIndex = 104,
            Parent = KeybindInner,
        })
        
        Library.KeybindFrame = KeybindOuter
        Library:MakeDraggable(KeybindOuter)
        
        function Library:SetKeyListVisibility(Bool)
            Library.KeybindFrame.Visible = Bool
        end
    end
    
    return Components
end

FakeModules.Components = Components

-- Carregar init.lua
local initCode = game:HttpGet(GITHUB_RAW .. "init.lua")

-- Substituir requires
initCode = initCode:gsub('require%(script%.Signal%)', 'FakeModules.Signal')
initCode = initCode:gsub('require%(script%.Spring%)', 'FakeModules.Spring')
initCode = initCode:gsub('require%(script%.Components%)', 'FakeModules.Components')
initCode = initCode:gsub('require%(script%.ESP%)', 'FakeModules.ESP')
initCode = initCode:gsub('require%(script%.Icons%)', 'FakeModules.Icons')

-- Disponibilizar FakeModules globalmente
getgenv().FakeModules = FakeModules

-- Executar init
local Library = loadstring(initCode)()

-- Adicionar ESP
Library.ESP = FakeModules.ESP

-- Limpar
getgenv().FakeModules = nil

print("[Aurora UI] Biblioteca carregada com sucesso!")

return Library
