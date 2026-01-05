--[[
    ╔═══════════════════════════════════════════════════════════════════╗
    ║                     AURORA UI LIBRARY                              ║
    ║                    Version 1.0.0                                   ║
    ╠═══════════════════════════════════════════════════════════════════╣
    ║  GitHub: https://github.com/Devzhtz1/UILIB                        ║
    ║  Author: Devzhtz1                                                  ║
    ╚═══════════════════════════════════════════════════════════════════╝
    
    Uma biblioteca de UI moderna e completa para Roblox
    
    Features:
    - Sistema de temas editáveis (8 temas predefinidos)
    - Suporte a ESP/Overlays (Box, Name, Health, Distance, Tracers, Chams)
    - Componentes: Window, Tab, GroupBox, Toggle, Slider, Button, Dropdown, Input, ColorPicker, KeyPicker
    - Sistema de notificações
    - Watermark customizável
    - Keybind list
    - DependencyBox (elementos condicionais)
    
    Loadstring:
    local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Devzhtz1/UILIB/main/loader.lua"))()
]]

-- Dependências
local Signal = require(script.Signal)
local Spring = require(script.Spring)

-- Serviços
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TextService = game:GetService("TextService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local camera = workspace.CurrentCamera

-- Funções auxiliares para compatibilidade
local function clonefunction(f) return f end
local function cloneref(instance) return instance end

-- Cache de funções
local _Instancenew = Instance.new
local _UDim2New = UDim2.new
local _UDim2fromOffset = UDim2.fromOffset
local _UDim2fromScale = UDim2.fromScale
local _UDimNew = UDim.new
local _Vector2New = Vector2.new
local _Vector3New = Vector3.new
local _Color3New = Color3.new
local _Color3FromRGB = Color3.fromRGB
local _Color3FromHSV = Color3.fromHSV
local _Color3ToHSV = Color3.toHSV
local _Color3FromHex = Color3.fromHex
local _TableInsert = table.insert
local _TableRemove = table.remove
local _TableFind = table.find
local _TableConcat = table.concat
local _TableSort = table.sort
local _MathClamp = math.clamp
local _MathFloor = math.floor
local _MathMax = math.max
local _MathMin = math.min
local _MathCeil = math.ceil
local _StringFormat = string.format
local _StringGsub = string.gsub
local _StringSub = string.sub
local _StringLower = string.lower
local _Type = type
local _Pcall = pcall
local _TaskWait = task.wait
local _TaskSpawn = task.spawn
local _TaskDelay = task.delay
local _tonumber = tonumber
local _tostring = tostring
local _Select = select
local _ColorSequenceNew = ColorSequence.new
local _ColorSequenceKeypointNew = ColorSequenceKeypoint.new
local _NumberSequenceNew = NumberSequence.new
local _NumberSequenceKeypointNew = NumberSequenceKeypoint.new

local RenderStepped = RunService.RenderStepped

-- Proteção de GUI
local ProtectGui = protectgui or protect_gui or (syn and syn.protect_gui) or function() end

-- ScreenGui principal
local CoreGui = cloneref(game:GetService("CoreGui"))

local ScreenGui = _Instancenew('ScreenGui')
ProtectGui(ScreenGui)
ScreenGui.Name = "AuroraUILib"
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
ScreenGui.DisplayOrder = 999999999
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui

-- Tabelas globais
local Toggles = {}
local Options = {}
local Flags = setmetatable({}, {
	__index = function(self, value)
		if Toggles[value] ~= nil then
			return Toggles[value].Value
		elseif Options[value] ~= nil then
			local success, data = _Pcall(function()
				return Options[value]:GetState()
			end)
			if success then
				return data
			end
			return Options[value].Value
		end
	end
})

--[[ ========================================
    TEMAS - ESTILO VIZOR
======================================== ]]
local Themes = {
	-- Tema Vizor: dark gray minimalista
	Default = {
		FontColor = _Color3FromRGB(255, 255, 255),
		MainColor = _Color3FromRGB(30, 30, 30), -- Dark gray background
		BackgroundColor = _Color3FromRGB(25, 25, 25), -- Slightly darker
		AccentColor = _Color3FromRGB(255, 255, 255), -- White accents
		OutlineColor = _Color3FromRGB(50, 50, 50), -- Subtle borders
		RiskColor = _Color3FromRGB(255, 80, 80),
		SeparatorColor = _Color3FromRGB(60, 60, 60), -- Separator lines
		HoverColor = _Color3FromRGB(40, 40, 40), -- Hover states
		SelectedColor = _Color3FromRGB(35, 35, 35), -- Selected items
	},
	-- Aurora: laranja quente elegante
	Aurora = {
		FontColor = _Color3FromRGB(235, 235, 240),
		MainColor = _Color3FromRGB(25, 25, 25),
		BackgroundColor = _Color3FromRGB(20, 20, 20),
		AccentColor = _Color3FromRGB(255, 135, 50),
		OutlineColor = _Color3FromRGB(45, 45, 45),
		RiskColor = _Color3FromRGB(255, 85, 85),
	},
	-- Ocean: azul clean
	Ocean = {
		FontColor = _Color3FromRGB(255, 255, 255),
		MainColor = _Color3FromRGB(25, 25, 25),
		BackgroundColor = _Color3FromRGB(20, 20, 20),
		AccentColor = _Color3FromRGB(59, 165, 255),
		OutlineColor = _Color3FromRGB(45, 45, 45),
		RiskColor = _Color3FromRGB(255, 100, 100),
	},
	-- Midnight: roxo elegante
	Midnight = {
		FontColor = _Color3FromRGB(255, 255, 255),
		MainColor = _Color3FromRGB(25, 25, 25),
		BackgroundColor = _Color3FromRGB(20, 20, 20),
		AccentColor = _Color3FromRGB(155, 89, 255),
		OutlineColor = _Color3FromRGB(45, 45, 45),
		RiskColor = _Color3FromRGB(255, 95, 95),
	},
	-- Emerald: verde moderno
	Emerald = {
		FontColor = _Color3FromRGB(255, 255, 255),
		MainColor = _Color3FromRGB(25, 25, 25),
		BackgroundColor = _Color3FromRGB(20, 20, 20),
		AccentColor = _Color3FromRGB(52, 211, 153),
		OutlineColor = _Color3FromRGB(45, 45, 45),
		RiskColor = _Color3FromRGB(255, 110, 110),
	},
	-- Rose: rosa moderno
	Rose = {
		FontColor = _Color3FromRGB(255, 255, 255),
		MainColor = _Color3FromRGB(25, 25, 25),
		BackgroundColor = _Color3FromRGB(20, 20, 20),
		AccentColor = _Color3FromRGB(244, 114, 182),
		OutlineColor = _Color3FromRGB(45, 45, 45),
		RiskColor = _Color3FromRGB(255, 100, 100),
	},
	-- Crimson: vermelho elegante
	Crimson = {
		FontColor = _Color3FromRGB(255, 255, 255),
		MainColor = _Color3FromRGB(25, 25, 25),
		BackgroundColor = _Color3FromRGB(20, 20, 20),
		AccentColor = _Color3FromRGB(239, 68, 68),
		OutlineColor = _Color3FromRGB(45, 45, 45),
		RiskColor = _Color3FromRGB(255, 200, 80),
	},
	-- Nord: tema nórdico
	Nord = {
		FontColor = _Color3FromRGB(255, 255, 255),
		MainColor = _Color3FromRGB(25, 25, 25),
		BackgroundColor = _Color3FromRGB(20, 20, 20),
		AccentColor = _Color3FromRGB(136, 192, 208),
		OutlineColor = _Color3FromRGB(45, 45, 45),
		RiskColor = _Color3FromRGB(191, 97, 106),
	},
	-- Dracula: tema roxo
	Dracula = {
		FontColor = _Color3FromRGB(255, 255, 255),
		MainColor = _Color3FromRGB(25, 25, 25),
		BackgroundColor = _Color3FromRGB(20, 20, 20),
		AccentColor = _Color3FromRGB(189, 147, 249),
		OutlineColor = _Color3FromRGB(45, 45, 45),
		RiskColor = _Color3FromRGB(255, 85, 85),
	},
	-- Catppuccin: pastel
	Catppuccin = {
		FontColor = _Color3FromRGB(255, 255, 255),
		MainColor = _Color3FromRGB(25, 25, 25),
		BackgroundColor = _Color3FromRGB(20, 20, 20),
		AccentColor = _Color3FromRGB(203, 166, 247),
		OutlineColor = _Color3FromRGB(45, 45, 45),
		RiskColor = _Color3FromRGB(243, 139, 168),
	},
	-- Gruvbox: amarelo quente
	Gruvbox = {
		FontColor = _Color3FromRGB(255, 255, 255),
		MainColor = _Color3FromRGB(25, 25, 25),
		BackgroundColor = _Color3FromRGB(20, 20, 20),
		AccentColor = _Color3FromRGB(250, 189, 47),
		OutlineColor = _Color3FromRGB(45, 45, 45),
		RiskColor = _Color3FromRGB(251, 73, 52),
	},
	-- Light: tema claro
	Light = {
		FontColor = _Color3FromRGB(30, 30, 35),
		MainColor = _Color3FromRGB(245, 245, 245),
		BackgroundColor = _Color3FromRGB(255, 255, 255),
		AccentColor = _Color3FromRGB(59, 130, 246),
		OutlineColor = _Color3FromRGB(200, 200, 200),
		RiskColor = _Color3FromRGB(239, 68, 68),
	},
}

--[[ ========================================
    BIBLIOTECA PRINCIPAL
======================================== ]]
local Library = {
	-- Registry
	Registry = {},
	RegistryMap = {},
	HudRegistry = {},
	
	-- Estado
	LoadingCFG = false,
	Toggled = true,
	ToggleKey = Enum.KeyCode.RightControl,
	
	-- Cores (tema padrão: Vizor)
	FontColor = Themes.Default.FontColor,
	MainColor = Themes.Default.MainColor,
	BackgroundColor = Themes.Default.BackgroundColor,
	AccentColor = Themes.Default.AccentColor,
	OutlineColor = Themes.Default.OutlineColor,
	RiskColor = Themes.Default.RiskColor,
	SeparatorColor = Themes.Default.SeparatorColor or _Color3FromRGB(60, 60, 60),
	HoverColor = Themes.Default.HoverColor or _Color3FromRGB(40, 40, 40),
	SelectedColor = Themes.Default.SelectedColor or _Color3FromRGB(35, 35, 35),
	Black = _Color3New(0, 0, 0),
	
	-- Fonte moderna (Vizor style)
	Font = Enum.Font.Gotham,
	FontBold = Enum.Font.GothamBold,
	FontLight = Enum.Font.Gotham,
	
	-- Frames abertos
	OpenedFrames = {},
	DependencyBoxes = {},
	
	-- Signals e referências
	Signals = {},
	ScreenGui = ScreenGui,
	
	-- Módulos
	Signal = Signal,
	Spring = Spring,
	
	-- Temas disponíveis
	Themes = Themes,
	CurrentTheme = "Default",
	
	-- Globals
	Toggles = Toggles,
	Options = Options,
	Flags = Flags,
	
	-- Sistema de ícones
	Icons = nil, -- Será carregado em Components
}

-- Computar cores derivadas
function Library:ComputeDerivedColors()
	Library.AccentColorDark = Library:GetDarkerColor(Library.AccentColor)
	Library.AccentColorLight = Library:GetLighterColor(Library.AccentColor)
	Library.FontColorDark = Library:GetDarkerColor(Library.FontColor)
	Library.MainColorLight = Library:GetLighterColor(Library.MainColor)
	Library.BorderColor = Library.OutlineColor
end

function Library:GetDarkerColor(Color)
	local H, S, V = _Color3ToHSV(Color)
	return _Color3FromHSV(H, S, V / 2.5)
end

function Library:GetLighterColor(Color)
	local H, S, V = _Color3ToHSV(Color)
	V = _MathClamp(V * 1.5, 0, 1)
	return _Color3FromHSV(H, S, V)
end

Library:ComputeDerivedColors()

--[[ ========================================
    SISTEMA DE TEMAS
======================================== ]]
function Library:SetTheme(themeName)
	local theme = Themes[themeName]
	if not theme then
		warn("Aurora UI: Tema não encontrado: " .. tostring(themeName))
		return false
	end
	
	Library.CurrentTheme = themeName
	Library.FontColor = theme.FontColor
	Library.MainColor = theme.MainColor
	Library.BackgroundColor = theme.BackgroundColor
	Library.AccentColor = theme.AccentColor
	Library.OutlineColor = theme.OutlineColor
	Library.RiskColor = theme.RiskColor
	
	Library:ComputeDerivedColors()
	Library:UpdateColorsUsingRegistry()
	
	return true
end

function Library:CreateCustomTheme(name, colors)
	Themes[name] = {
		FontColor = colors.FontColor or Themes.Aurora.FontColor,
		MainColor = colors.MainColor or Themes.Aurora.MainColor,
		BackgroundColor = colors.BackgroundColor or Themes.Aurora.BackgroundColor,
		AccentColor = colors.AccentColor or Themes.Aurora.AccentColor,
		OutlineColor = colors.OutlineColor or Themes.Aurora.OutlineColor,
		RiskColor = colors.RiskColor or Themes.Aurora.RiskColor,
	}
	return Themes[name]
end

function Library:GetThemeNames()
	local names = {}
	for name, _ in pairs(Themes) do
		_TableInsert(names, name)
	end
	_TableSort(names)
	return names
end

function Library:SetAccentColor(color)
	Library.AccentColor = color
	Library:ComputeDerivedColors()
	Library:UpdateColorsUsingRegistry()
end

--[[ ========================================
    RAINBOW SYSTEM
======================================== ]]
local RainbowStep = 0
local Hue = 0

_TableInsert(Library.Signals, RenderStepped:Connect(function(Delta)
	RainbowStep = RainbowStep + Delta
	
	if RainbowStep >= (1 / 60) then
		RainbowStep = 0
		Hue = Hue + (1 / 400)
		
		if Hue > 1 then
			Hue = 0
		end
		
		Library.CurrentRainbowHue = Hue
		Library.CurrentRainbowColor = _Color3FromHSV(Hue, 0.8, 1)
	end
end))

--[[ ========================================
    FUNÇÕES DE CRIAÇÃO
======================================== ]]
function Library:Create(Class, Properties)
	local _Instance = Class
	
	if _Type(Class) == 'string' then
		_Instance = _Instancenew(Class)
	end
	
	for Property, Value in next, Properties do
		_Instance[Property] = Value
	end
	
	return _Instance
end

function Library:CreateLabel(Properties, IsHud)
	local _Instance = Library:Create('TextLabel', {
		BackgroundTransparency = 1,
		Font = Library.Font,
		TextColor3 = Library.FontColor,
		TextSize = 16,
		TextStrokeTransparency = 1,
	})
	
	Library:AddToRegistry(_Instance, {
		TextColor3 = 'FontColor',
	}, IsHud)
	
	return Library:Create(_Instance, Properties)
end

--[[ ========================================
    REGISTRY SYSTEM
======================================== ]]
function Library:AddToRegistry(Instance, Properties, IsHud)
	local Idx = #Library.Registry + 1
	local Data = {
		Instance = Instance,
		Properties = Properties,
		Idx = Idx,
	}
	
	_TableInsert(Library.Registry, Data)
	Library.RegistryMap[Instance] = Data
	
	if IsHud then
		_TableInsert(Library.HudRegistry, Data)
	end
end

function Library:RemoveFromRegistry(Instance)
	local Data = Library.RegistryMap[Instance]
	
	if Data then
		for Idx = #Library.Registry, 1, -1 do
			if Library.Registry[Idx] == Data then
				_TableRemove(Library.Registry, Idx)
			end
		end
		
		for Idx = #Library.HudRegistry, 1, -1 do
			if Library.HudRegistry[Idx] == Data then
				_TableRemove(Library.HudRegistry, Idx)
			end
		end
		
		Library.RegistryMap[Instance] = nil
	end
end

function Library:UpdateColorsUsingRegistry()
	for Idx, Object in next, Library.Registry do
		for Property, ColorIdx in next, Object.Properties do
			if _Type(ColorIdx) == 'string' then
				Object.Instance[Property] = Library[ColorIdx]
			elseif _Type(ColorIdx) == 'function' then
				Object.Instance[Property] = ColorIdx()
			end
		end
	end
end

--[[ ========================================
    FUNÇÕES UTILITÁRIAS
======================================== ]]
function Library:GetTextBounds(Text, Font, Size, Resolution)
	local Bounds = TextService:GetTextSize(Text, Size, Font, Resolution or _Vector2New(camera.ViewportSize.X, camera.ViewportSize.Y))
	return Bounds.X, Bounds.Y
end

function Library:MapValue(Value, MinA, MaxA, MinB, MaxB)
	return (1 - ((Value - MinA) / (MaxA - MinA))) * MinB + ((Value - MinA) / (MaxA - MinA)) * MaxB
end

function Library:MouseIsOverOpenedFrame()
	for Frame, _ in next, Library.OpenedFrames do
		local AbsPos, AbsSize = Frame.AbsolutePosition, Frame.AbsoluteSize
		
		if Mouse.X >= AbsPos.X and Mouse.X <= AbsPos.X + AbsSize.X
			and Mouse.Y >= AbsPos.Y and Mouse.Y <= AbsPos.Y + AbsSize.Y then
			return true
		end
	end
	return false
end

function Library:IsMouseOverFrame(Frame)
	local AbsPos, AbsSize = Frame.AbsolutePosition, Frame.AbsoluteSize
	
	if Mouse.X >= AbsPos.X and Mouse.X <= AbsPos.X + AbsSize.X
		and Mouse.Y >= AbsPos.Y and Mouse.Y <= AbsPos.Y + AbsSize.Y then
		return true
	end
	return false
end

function Library:UpdateDependencyBoxes()
	for _, Depbox in next, Library.DependencyBoxes do
		Depbox:Update()
	end
end

function Library:AttemptSave()
	if Library.SaveManager then
		Library.SaveManager:Save()
	end
end

function Library:SafeCallback(f, ...)
	if not f then return end
	
	local success, err = _Pcall(f, ...)
	if not success then
		warn("Aurora UI Callback Error:", err)
	end
	return success
end

function Library:GiveSignal(Signal)
	_TableInsert(Library.Signals, Signal)
end

function Library:AddSignal(signal, func)
	local connectedsignal = signal:Connect(func)
	Library:GiveSignal(connectedsignal)
	return connectedsignal
end

--[[ ========================================
    HOVER HIGHLIGHT
======================================== ]]
function Library:OnHighlight(HighlightInstance, Instance, Properties, PropertiesDefault)
	HighlightInstance.MouseEnter:Connect(function()
		local Reg = Library.RegistryMap[Instance]
		
		for Property, ColorIdx in next, Properties do
			Instance[Property] = Library[ColorIdx] or ColorIdx
			
			if Reg and Reg.Properties[Property] then
				Reg.Properties[Property] = ColorIdx
			end
		end
	end)
	
	HighlightInstance.MouseLeave:Connect(function()
		local Reg = Library.RegistryMap[Instance]
		
		for Property, ColorIdx in next, PropertiesDefault do
			Instance[Property] = Library[ColorIdx] or ColorIdx
			
			if Reg and Reg.Properties[Property] then
				Reg.Properties[Property] = ColorIdx
			end
		end
	end)
end

--[[ ========================================
    TOOLTIP SYSTEM
======================================== ]]
function Library:BreakTextIntoLines(text, maxWidth, font, textSize)
	local result = ""
	local currentLine = ""
	
	for word in string.gmatch(text, "%S+") do
		local testLine = currentLine == "" and word or currentLine .. " " .. word
		local lineWidth = Library:GetTextBounds(testLine, font, textSize)
		
		if lineWidth > maxWidth then
			result = result .. (result == "" and currentLine or "\n" .. currentLine)
			currentLine = word
		else
			currentLine = testLine
		end
	end
	
	if currentLine ~= "" then
		result = result .. (result == "" and currentLine or "\n" .. currentLine)
	end
	
	return result
end

function Library:AddToolTip(InfoStr, HoverInstance)
	local MaxWidth = 200
	local X, Y = Library:GetTextBounds(InfoStr, Library.Font, 15)
	
	if X > MaxWidth then
		InfoStr = Library:BreakTextIntoLines(InfoStr, MaxWidth, Library.Font, 15)
		X, Y = Library:GetTextBounds(InfoStr, Library.Font, 15)
	end
	
	local Tooltip = Library:Create('Frame', {
		BackgroundColor3 = Library.MainColor,
		BorderColor3 = Library.OutlineColor,
		Size = _UDim2fromOffset(X + 8, Y + 4),
		ZIndex = 100,
		Parent = Library.ScreenGui,
		Visible = false,
	})
	
	local Label = Library:CreateLabel({
		Position = _UDim2fromOffset(3, 1),
		Size = _UDim2fromOffset(X, Y),
		TextSize = 15,
		Text = InfoStr,
		TextColor3 = Library.FontColor,
		TextXAlignment = Enum.TextXAlignment.Center,
		ZIndex = 101,
		Parent = Tooltip,
	})
	
	Library:AddToRegistry(Tooltip, {
		BackgroundColor3 = 'MainColor',
		BorderColor3 = 'OutlineColor',
	})
	
	local IsHovering = false
	
	HoverInstance.MouseEnter:Connect(function()
		if Library:MouseIsOverOpenedFrame() then return end
		
		IsHovering = true
		
		_TaskDelay(0.5, function()
			if IsHovering then
				Tooltip.Position = _UDim2fromOffset(Mouse.X + 15, Mouse.Y + 12)
				Tooltip.Visible = true
			end
		end)
		
		_TaskSpawn(function()
			while IsHovering do
				RunService.Heartbeat:Wait()
				Tooltip.Position = _UDim2fromOffset(Mouse.X + 15, Mouse.Y + 12)
			end
		end)
	end)
	
	HoverInstance.MouseLeave:Connect(function()
		IsHovering = false
		Tooltip.Visible = false
	end)
end

--[[ ========================================
    DRAGGABLE SYSTEM
======================================== ]]
function Library:MakeDraggable(Instance, Cutoff, Performance)
	Instance.Active = true
	
	Instance.InputBegan:Connect(function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseButton1 then
			local ObjPos = _Vector2New(
				Mouse.X - Instance.AbsolutePosition.X,
				Mouse.Y - Instance.AbsolutePosition.Y
			)
			
			if ObjPos.Y > (Cutoff or 40) then
				return
			end
			
			while UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
				local NewPos = _UDim2New(
					0,
					Mouse.X - ObjPos.X + (Instance.Size.X.Offset * Instance.AnchorPoint.X),
					0,
					Mouse.Y - ObjPos.Y + (Instance.Size.Y.Offset * Instance.AnchorPoint.Y)
				)
				
				Instance.Position = NewPos
				
				-- Se tiver Performance frame, mover junto
				if Performance then
					Performance.Position = NewPos
				end
				
				RunService.Heartbeat:Wait()
			end
		end
	end)
end

--[[ ========================================
    UNLOAD SYSTEM
======================================== ]]
function Library:OnUnload(Callback)
	Library.UnloadCallback = Callback
end

function Library:Unload()
	for Idx = #Library.Signals, 1, -1 do
		local Connection = _TableRemove(Library.Signals, Idx)
		Connection:Disconnect()
	end
	
	if Library.UnloadCallback then
		Library.UnloadCallback()
	end
	
	ScreenGui:Destroy()
end

--[[ ========================================
    NOTIFICATION SYSTEM
======================================== ]]
do
	Library.NotificationArea = Library:Create('Frame', {
		BackgroundTransparency = 1,
		Position = _UDim2New(0, 10, 0, 40),
		Size = _UDim2New(0, 300, 0, 400),
		ZIndex = 100,
		Parent = ScreenGui,
	})
	
	Library:Create('UIListLayout', {
		Padding = _UDimNew(0, 4),
		FillDirection = Enum.FillDirection.Vertical,
		SortOrder = Enum.SortOrder.LayoutOrder,
		Parent = Library.NotificationArea,
	})
	
	Library.NotificationAreaCenter = Library:Create('Frame', {
		BackgroundTransparency = 1,
		AnchorPoint = _Vector2New(0.5, 0),
		Position = _UDim2New(0.5, 0, 0.75, 0),
		Size = _UDim2New(0, 300, 0, 200),
		ZIndex = 100,
		Parent = ScreenGui,
	})
	
	Library:Create('UIListLayout', {
		Padding = _UDimNew(0, 4),
		FillDirection = Enum.FillDirection.Vertical,
		HorizontalAlignment = Enum.HorizontalAlignment.Center,
		SortOrder = Enum.SortOrder.LayoutOrder,
		Parent = Library.NotificationAreaCenter,
	})
	
	function Library:Notify(Text, Time, Position)
		local XSize, YSize = Library:GetTextBounds(Text, Library.Font, 15)
		YSize = (YSize * 1.5) + 3
		
		local Parent = Library.NotificationArea
		if _Type(Position) == "string" and _StringLower(Position) == "center" then
			Parent = Library.NotificationAreaCenter
		end
		
		local NotifyOuter = Library:Create('Frame', {
			Position = _UDim2New(0, 100, 0, 10),
			BorderColor3 = _Color3New(0, 0, 0),
			Size = _UDim2New(0, 0, 0, YSize),
			ClipsDescendants = true,
			ZIndex = 100,
			Parent = Parent,
		})
		
		local NotifyInner = Library:Create('Frame', {
			BackgroundColor3 = Library.MainColor,
			BorderColor3 = Library.OutlineColor,
			BorderMode = Enum.BorderMode.Inset,
			Size = _UDim2New(1, 0, 1, 0),
			ZIndex = 101,
			Parent = NotifyOuter,
		})
		
		Library:AddToRegistry(NotifyInner, {
			BackgroundColor3 = 'MainColor',
			BorderColor3 = 'OutlineColor',
		}, true)
		
		local InnerFrame = Library:Create('Frame', {
			BackgroundColor3 = _Color3New(1, 1, 1),
			BorderSizePixel = 0,
			BackgroundTransparency = 1,
			Position = _UDim2New(0, 1, 0, 1),
			Size = _UDim2New(1, -2, 1, -2),
			ZIndex = 102,
			Parent = NotifyInner,
		})
		
		local Gradient = Library:Create('UIGradient', {
			Color = _ColorSequenceNew({
				_ColorSequenceKeypointNew(0, Library:GetDarkerColor(Library.MainColor)),
				_ColorSequenceKeypointNew(1, Library.MainColor),
			}),
			Rotation = -90,
			Parent = InnerFrame,
		})
		
		local NotifyLabel = Library:CreateLabel({
			Position = _UDim2New(0, 5, 0, 1),
			Size = _UDim2New(1, -10, 1, -1),
			Text = Text,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextSize = 15,
			ZIndex = 103,
			Parent = InnerFrame,
		})
		
		local TopColor = Library:Create('Frame', {
			BackgroundColor3 = Library.AccentColor,
			BorderSizePixel = 0,
			Position = _UDim2New(0, 1, 0, 1),
			Size = _UDim2New(1, -2, 0, 2),
			ZIndex = 104,
			Parent = NotifyOuter,
		})
		
		Library:AddToRegistry(TopColor, {
			BackgroundColor3 = 'AccentColor',
		}, true)
		
		NotifyOuter:TweenSize(_UDim2New(0, XSize + 20, 0, YSize), 'Out', 'Quad', 0.3, true)
		
		_TaskSpawn(function()
			_TaskWait(Time or 5)
			NotifyOuter:TweenSize(_UDim2New(0, 0, 0, YSize), 'Out', 'Quad', 0.3, true)
			_TaskWait(0.35)
			NotifyOuter:Destroy()
		end)
	end
end

--[[ ========================================
    CLEANUP
======================================== ]]
Library:GiveSignal(ScreenGui.DescendantRemoving:Connect(function(Instance)
	if Library.RegistryMap[Instance] then
		Library:RemoveFromRegistry(Instance)
	end
end))

-- Carregar componentes
local Components = require(script.Components)
Components:Init(Library, Toggles, Options, ScreenGui)

-- Carregar ESP
local ESP = require(script.ESP)
Library.ESP = ESP

return Library
