--[[
    Components - Carrega e inicializa todos os componentes da Aurora UI Library
]]

local Components = {}

function Components:Init(Library, Toggles, Options, ScreenGui)
	-- Carregar módulos
	local IconsModule = require(script.Parent.Icons)
	local BaseAddonsModule = require(script.Parent.BaseAddons)
	local ElementsModule = require(script.Parent.Elements)
	local WindowModule = require(script.Parent.Window)
	
	-- Carregar sistema de ícones
	Library.Icons = IconsModule
	
	-- Inicializar funções de addons (ColorPicker, KeyPicker)
	local AddonFuncs = BaseAddonsModule:Init(Library, Toggles, Options, ScreenGui)
	
	-- Criar BaseAddons metatable para Labels (que podem ter ColorPicker/KeyPicker)
	local BaseAddons = {}
	BaseAddons.__index = AddonFuncs
	
	-- Inicializar funções de elementos (Toggle, Slider, Button, etc.)
	local ElementFuncs = ElementsModule:Init(Library, Toggles, Options, ScreenGui, BaseAddons)
	
	-- Criar BaseGroupbox metatable que inclui todos os elementos
	local BaseGroupbox = {}
	BaseGroupbox.__index = ElementFuncs
	
	-- Inicializar Window
	WindowModule:Init(Library, Toggles, Options, ScreenGui, BaseGroupbox)
	
	--[[ ========================================
	    WATERMARK
	======================================== ]]
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
			BackgroundColor3 = Color3.new(1, 1, 1),
			BorderSizePixel = 0,
			BackgroundTransparency = 1,
			Position = UDim2.new(0, 1, 0, 1),
			Size = UDim2.new(1, -2, 1, -2),
			ZIndex = 202,
			Parent = WatermarkInner,
		})
		
		local FrameLine = Library:Create('Frame', {
			BorderColor3 = Library.AccentColor,
			BackgroundColor3 = Library.AccentColor,
			BorderSizePixel = 0,
			Position = UDim2.new(0, -1, 1, 0),
			Size = UDim2.new(1, 1, 0, 2),
			ZIndex = 202,
			Parent = WatermarkInner,
		})
		
		Library:AddToRegistry(FrameLine, {
			BorderColor3 = 'AccentColor',
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
		
		local function removeHtmlTags(str)
			return string.gsub(str, "<.->", "")
		end
		
		function Library:SetWatermark(Text)
			local X, Y = Library:GetTextBounds(removeHtmlTags(Text), Library.Font, 15)
			Library.Watermark.Size = UDim2.new(0, X + 18, 0, (Y * 1.5) + 0)
			Library.WatermarkText.Text = Text
		end
	end
	
	--[[ ========================================
	    KEYBIND LIST
	======================================== ]]
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
		
		local KeybindBackground = Library:Create('Frame', {
			BackgroundColor3 = Library.MainColor,
			BorderColor3 = Library.OutlineColor,
			BorderMode = Enum.BorderMode.Inset,
			Size = UDim2.new(1, 0, 0, 0),
			Position = UDim2.new(0, 0, 0, 0),
			ZIndex = -1,
			Parent = KeybindOuter,
		})
		
		Library:AddToRegistry(KeybindInner, {
			BackgroundColor3 = 'MainColor',
			BorderColor3 = 'OutlineColor',
		}, true)
		
		Library:AddToRegistry(KeybindBackground, {
			BorderColor3 = 'OutlineColor',
			BackgroundColor3 = 'MainColor',
		})
		
		local FrameLine2 = Library:Create('Frame', {
			BorderColor3 = Library.AccentColor,
			BackgroundColor3 = Library.AccentColor,
			BorderSizePixel = 0,
			Position = UDim2.new(0, 0, 0, 24),
			Size = UDim2.new(1, 0, 0, 2),
			ZIndex = 202,
			Parent = KeybindInner,
		})
		
		Library:AddToRegistry(FrameLine2, {
			BorderColor3 = 'AccentColor',
			BackgroundColor3 = 'AccentColor',
		})
		
		local KeybindLabel = Library:CreateLabel({
			Size = UDim2.new(1, 0, 0, 20),
			Position = UDim2.fromOffset(5, 2),
			TextXAlignment = Enum.TextXAlignment.Center,
			Text = 'Keybinds',
			ZIndex = 104,
			Parent = KeybindInner,
		})
		
		local KeybindContainer = Library:Create('Frame', {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, -20),
			Position = UDim2.new(0, 0, 0, 30),
			ZIndex = 1,
			Parent = KeybindInner,
		})
		
		local KeyListLayout = Library:Create('UIListLayout', {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 5),
			Parent = KeybindContainer,
		})
		
		Library:Create('UIPadding', {
			PaddingLeft = UDim.new(0, 5),
			Parent = KeybindContainer,
		})
		
		Library.KeybindBackground = KeybindBackground
		Library.KeyUilistlayout = KeyListLayout
		Library.KeybindFrame = KeybindOuter
		Library.KeybindContainer = KeybindContainer
		Library:MakeDraggable(KeybindOuter)
		
		function Library:SetKeyListVisibility(Bool)
			Library.KeybindFrame.Visible = Bool
		end
		
		function Library:UpdateKeybindList()
			-- Limpar lista existente
			for _, child in ipairs(KeybindContainer:GetChildren()) do
				if child:IsA("TextLabel") then
					child:Destroy()
				end
			end
			
			local YSize = 0
			local XSize = 0
			
			for idx, option in pairs(Options) do
				if option.Type == "KeyPicker" and option.Toggled then
					local label = Library:CreateLabel({
						TextXAlignment = Enum.TextXAlignment.Left,
						Size = UDim2.new(1, 0, 0, 18),
						TextSize = 14,
						ZIndex = 110,
						Text = string.format("[%s] %s", option.Value, idx),
						Parent = KeybindContainer,
					}, true)
					
					YSize = YSize + 18 + 5
					XSize = math.max(XSize, label.TextBounds.X)
				end
			end
			
			if YSize == 0 then
				KeybindBackground.Size = UDim2.new(1, 0, 0, 0)
				KeybindBackground.BackgroundTransparency = 1
			else
				KeybindBackground.Size = UDim2.new(0, math.max(XSize + 20, 210), 0, YSize + 30)
				KeybindBackground.BackgroundTransparency = 0
			end
		end
	end
	
	return Components
end

return Components

