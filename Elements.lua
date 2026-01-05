--[[
    Elements - Toggle, Slider, Button, Input, Dropdown, DependencyBox
]]

local Elements = {}

function Elements:Init(Library, Toggles, Options, ScreenGui, BaseAddons)
	local _Instancenew = Instance.new
	local _UDim2New = UDim2.new
	local _UDim2fromOffset = UDim2.fromOffset
	local _UDimNew = UDim.new
	local _Vector2New = Vector2.new
	local _Color3New = Color3.new
	local _Color3FromRGB = Color3.fromRGB
	local _TableInsert = table.insert
	local _TableRemove = table.remove
	local _TableFind = table.find
	local _MathClamp = math.clamp
	local _MathFloor = math.floor
	local _MathMax = math.max
	local _MathCeil = math.ceil
	local _StringFormat = string.format
	local _Type = type
	local _Pcall = pcall
	local _TaskSpawn = task.spawn
	local _tonumber = tonumber
	local _Select = select
	local _ColorSequenceNew = ColorSequence.new
	local _ColorSequenceKeypointNew = ColorSequenceKeypoint.new
	
	local UserInputService = game:GetService("UserInputService")
	local TextService = game:GetService("TextService")
	local RunService = game:GetService("RunService")
	local Players = game:GetService("Players")
	local Mouse = Players.LocalPlayer:GetMouse()
	local RenderStepped = RunService.RenderStepped
	
	local Funcs = {}
	
	--[[ ========================================
	    ADD BLANK
	======================================== ]]
	function Funcs:AddBlank(Size)
		local Groupbox = self
		local Container = Groupbox.Container
		
		Library:Create('Frame', {
			BackgroundTransparency = 1,
			Size = _UDim2New(1, 0, 0, Size),
			ZIndex = 1,
			Parent = Container,
		})
	end
	
	--[[ ========================================
	    ADD LABEL
	======================================== ]]
	function Funcs:AddLabel(Text, DoesWrap)
		local Label = {
			Addons = {}, -- Necessário para ColorPicker e KeyPicker
		}
		local Groupbox = self
		local Container = Groupbox.Container
		
		local TextLabel = Library:CreateLabel({
			Size = _UDim2New(1, -4, 0, 18),
			TextSize = 13,
			Font = Library.Font or Enum.Font.GothamMedium,
			Text = Text,
			TextWrapped = DoesWrap or false,
			TextXAlignment = Enum.TextXAlignment.Left,
			ZIndex = 5,
			Parent = Container,
		})
		
		if DoesWrap then
			local Y = _Select(2, Library:GetTextBounds(Text, Library.Font, 13, _Vector2New(TextLabel.AbsoluteSize.X, math.huge)))
			TextLabel.Size = _UDim2New(1, -4, 0, Y)
		else
			Library:Create('UIListLayout', {
				Padding = _UDimNew(0, 4),
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Right,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Parent = TextLabel,
			})
		end
		
		Label.TextLabel = TextLabel
		Label.Container = Container
		
		function Label:SetText(NewText)
			TextLabel.Text = NewText
			if DoesWrap then
				local Y = _Select(2, Library:GetTextBounds(NewText, Library.Font, 13, _Vector2New(TextLabel.AbsoluteSize.X, math.huge)))
				TextLabel.Size = _UDim2New(1, -4, 0, Y)
			end
			Groupbox:Resize()
		end
		
		if not DoesWrap then
			setmetatable(Label, BaseAddons)
		end
		
		Groupbox:AddBlank(5)
		Groupbox:Resize()
		
		return Label
	end
	
	--[[ ========================================
	    ADD DIVIDER - ESTILO VIZOR
	======================================== ]]
	function Funcs:AddDivider()
		local Groupbox = self
		local Container = self.Container
		
		-- Separator no estilo Vizor (linha sutil)
		local DividerFrame = Library:Create('Frame', {
			BackgroundColor3 = Library.SeparatorColor or Library.OutlineColor,
			BackgroundTransparency = 0,
			BorderSizePixel = 0,
			Size = _UDim2New(1, 0, 0, 1),
			ZIndex = 5,
			Parent = Container,
		})
		
		Library:AddToRegistry(DividerFrame, { BackgroundColor3 = 'SeparatorColor' })
		
		Groupbox:AddBlank(8)
		Groupbox:Resize()
	end
	
	--[[ ========================================
	    ADD BUTTON
	======================================== ]]
	function Funcs:AddButton(...)
		local Button = {}
		
		local function ProcessButtonParams(Obj, ...)
			local Props = _Select(1, ...)
			if _Type(Props) == 'table' then
				Obj.Text = Props.Text
				Obj.Func = Props.Func
				Obj.DoubleClick = Props.DoubleClick
				Obj.Tooltip = Props.Tooltip
			else
				Obj.Text = _Select(1, ...)
				Obj.Func = _Select(2, ...)
			end
			assert(_Type(Obj.Func) == 'function', 'AddButton: `Func` callback is missing.')
		end
		
		ProcessButtonParams(Button, ...)
		
		local Groupbox = self
		local Container = Groupbox.Container
		
		local function CreateBaseButton(Btn)
			-- Botão minimalista com gradiente suave
			local Outer = Library:Create('TextButton', {
				BackgroundColor3 = Library.MainColor,
				BorderSizePixel = 0,
				Size = _UDim2New(1, 0, 0, 32),
				AutoButtonColor = false,
				Text = '',
				ZIndex = 5,
			})
			Library:Create('UICorner', {
				CornerRadius = _UDimNew(0, 8),
				Parent = Outer,
			})
			
			-- Gradiente suave no botão
			local ButtonGradient = Library:Create('UIGradient', {
				Color = _ColorSequenceNew({
					_ColorSequenceKeypointNew(0, Library.MainColor),
					_ColorSequenceKeypointNew(1, Library:GetDarkerColor(Library.MainColor)),
				}),
				Rotation = 90,
				Parent = Outer,
			})
			
			-- Contorno suave
			local OuterStroke = Library:Create('UIStroke', {
				Color = Library.OutlineColor,
				Thickness = 1.5,
				Transparency = 0.6,
				Parent = Outer,
			})
			
			local Label = Library:CreateLabel({
				Size = _UDim2New(1, 0, 1, 0),
				TextSize = 13,
				Font = Library.Font or Enum.Font.GothamMedium,
				Text = Btn.Text,
				ZIndex = 6,
				Parent = Outer,
			})
			
			Library:AddToRegistry(Outer, { BackgroundColor3 = 'MainColor' })
			Library:AddToRegistry(OuterStroke, { Color = 'OutlineColor' })
			
			-- Hover effect suave com gradiente animado
			local buttonHoverSpring = Library.Spring.new(0)
			local buttonHoverConnection = RunService.RenderStepped:Connect(function()
				local alpha = buttonHoverSpring.Position
				
				-- Interpolar cor do stroke
				OuterStroke.Color = Color3.new(
					Library.OutlineColor.R + (Library.AccentColor.R - Library.OutlineColor.R) * alpha * 0.8,
					Library.OutlineColor.G + (Library.AccentColor.G - Library.OutlineColor.G) * alpha * 0.8,
					Library.OutlineColor.B + (Library.AccentColor.B - Library.OutlineColor.B) * alpha * 0.8
				)
				OuterStroke.Transparency = 0.6 - (alpha * 0.4)
				OuterStroke.Thickness = 1.5 + (alpha * 0.5)
				
				-- Interpolar gradiente
				local accentR, accentG, accentB = Library.AccentColor.R, Library.AccentColor.G, Library.AccentColor.B
				local mainR, mainG, mainB = Library.MainColor.R, Library.MainColor.G, Library.MainColor.B
				local darkerR, darkerG, darkerB = Library:GetDarkerColor(Library.MainColor).R, 
					Library:GetDarkerColor(Library.MainColor).G, 
					Library:GetDarkerColor(Library.MainColor).B
				
				ButtonGradient.Color = _ColorSequenceNew({
					_ColorSequenceKeypointNew(0, Color3.new(
						mainR + (accentR - mainR) * alpha * 0.3,
						mainG + (accentG - mainG) * alpha * 0.3,
						mainB + (accentB - mainB) * alpha * 0.3
					)),
					_ColorSequenceKeypointNew(1, Color3.new(
						darkerR + (accentR - darkerR) * alpha * 0.2,
						darkerG + (accentG - darkerG) * alpha * 0.2,
						darkerB + (accentB - darkerB) * alpha * 0.2
					)),
				})
			end)
			
			Outer.MouseEnter:Connect(function()
				buttonHoverSpring.Target = 1
				buttonHoverSpring.Speed = 25
				buttonHoverSpring.Damper = 0.8
			end)
			Outer.MouseLeave:Connect(function()
				buttonHoverSpring.Target = 0
			end)
			
			return Outer, Outer, Label
		end
		
		local function InitEvents(Btn)
			local function ValidateClick(Input)
				if Library:MouseIsOverOpenedFrame() then return false end
				if Input.UserInputType ~= Enum.UserInputType.MouseButton1 then return false end
				return true
			end
			
			Btn.Outer.InputBegan:Connect(function(Input)
				if not ValidateClick(Input) then return end
				if Btn.Locked then return end
				
				if Btn.DoubleClick then
					Library:RemoveFromRegistry(Btn.Label)
					Library:AddToRegistry(Btn.Label, { TextColor3 = 'AccentColor' })
					Btn.Label.TextColor3 = Library.AccentColor
					Btn.Label.Text = 'Are you sure?'
					Btn.Locked = true
					
					local clicked = false
					local conn
					conn = Btn.Outer.InputBegan:Connect(function(Input2)
						if ValidateClick(Input2) then
							clicked = true
							conn:Disconnect()
						end
					end)
					
					task.delay(1, function()
						if conn.Connected then
							conn:Disconnect()
						end
						
						Library:RemoveFromRegistry(Btn.Label)
						Library:AddToRegistry(Btn.Label, { TextColor3 = 'FontColor' })
						Btn.Label.TextColor3 = Library.FontColor
						Btn.Label.Text = Btn.Text
						Btn.Locked = false
						
						if clicked then
							Library:SafeCallback(Btn.Func)
						end
					end)
					
					return
				end
				
				Library:SafeCallback(Btn.Func)
			end)
		end
		
		Button.Outer, Button.Inner, Button.Label = CreateBaseButton(Button)
		Button.Outer.Parent = Container
		
		InitEvents(Button)
		
		function Button:AddTooltip(tooltip)
			if _Type(tooltip) == 'string' then
				Library:AddToolTip(tooltip, self.Outer)
			end
			return self
		end
		
		function Button:AddButton(...)
			local SubButton = {}
			ProcessButtonParams(SubButton, ...)
			
			self.Outer.Size = _UDim2New(0.5, -2, 0, 20)
			
			SubButton.Outer, SubButton.Inner, SubButton.Label = CreateBaseButton(SubButton)
			SubButton.Outer.Position = _UDim2New(1, 3, 0, 0)
			SubButton.Outer.Size = _UDim2fromOffset(self.Outer.AbsoluteSize.X - 2, self.Outer.AbsoluteSize.Y)
			SubButton.Outer.Parent = self.Outer
			
			InitEvents(SubButton)
			return SubButton
		end
		
		if _Type(Button.Tooltip) == 'string' then
			Button:AddTooltip(Button.Tooltip)
		end
		
		Groupbox:AddBlank(5)
		Groupbox:Resize()
		
		return Button
	end
	
	--[[ ========================================
	    ADD TOGGLE - MODERNO (SWITCH STYLE)
	======================================== ]]
	function Funcs:AddToggle(Idx, Info)
		assert(Info.Text, 'AddToggle: Missing `Text` string.')
		
		local Toggle = {
			Value = Info.Default or false,
			Type = 'Toggle',
			Callback = Info.Callback or function(Value) end,
			Addons = {},
			Risky = Info.Risky,
		}
		
		local Groupbox = self
		local Container = Groupbox.Container
		
		-- Container do toggle
		local ToggleFrame = Library:Create('Frame', {
			BackgroundTransparency = 1,
			Size = _UDim2New(1, 0, 0, 22),
			ZIndex = 5,
			Parent = Container,
		})
		
		-- Label do toggle
		local ToggleLabel = Library:CreateLabel({
			Size = _UDim2New(1, -90, 1, 0), -- Espaço para switch + config button
			Position = _UDim2New(0, 0, 0, 0),
			TextSize = 13,
			Font = Library.Font or Enum.Font.Gotham,
			Text = Info.Text,
			TextXAlignment = Enum.TextXAlignment.Left,
			ZIndex = 6,
			Parent = ToggleFrame,
		})
		
		-- Container para addons (ColorPicker, KeyPicker)
		Library:Create('UIListLayout', {
			Padding = _UDimNew(0, 4),
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Right,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Parent = ToggleLabel,
		})
		
		-- Botão de configuração (estilo Vizor)
		local ConfigButton = nil
		if Info.ConfigButton ~= false then -- Por padrão mostra, a menos que seja false
			ConfigButton = Library:Create('TextButton', {
				BackgroundColor3 = _Color3FromRGB(40, 40, 40),
				BackgroundTransparency = 0,
				BorderSizePixel = 0,
				Size = _UDim2New(0, 20, 0, 20),
				Position = _UDim2New(1, -70, 0.5, -10),
				AutoButtonColor = false,
				Text = '',
				ZIndex = 7,
				Parent = ToggleFrame,
			})
			Library:Create('UICorner', {
				CornerRadius = _UDimNew(0, 4),
				Parent = ConfigButton,
			})
			
			-- Ícone de gear
			local ConfigIcon = nil
			if Library.Icons then
				ConfigIcon = Library.Icons:CreateIcon("Settings", 12, ConfigButton, false)
				ConfigIcon.Position = UDim2.new(0.5, 0, 0.5, 0)
				ConfigIcon.AnchorPoint = Vector2.new(0.5, 0.5)
				ConfigIcon.TextColor3 = _Color3FromRGB(200, 200, 200)
			else
				ConfigIcon = Library:CreateLabel({
					Text = "⚙",
					TextSize = 12,
					TextColor3 = _Color3FromRGB(200, 200, 200),
					Size = UDim2.new(1, 0, 1, 0),
					ZIndex = 8,
					Parent = ConfigButton,
				})
			end
			
			-- Animações com Spring para o botão de config
			local configHoverSpring = Library.Spring.new(0)
			local configHoverConnection = RunService.RenderStepped:Connect(function()
				local alpha = configHoverSpring.Position
				ConfigButton.BackgroundColor3 = Color3.new(0.15 + alpha * 0.1, 0.15 + alpha * 0.1, 0.15 + alpha * 0.1)
			end)
			
			ConfigButton.MouseEnter:Connect(function()
				configHoverSpring.Target = 1
				configHoverSpring.Speed = 20
				configHoverSpring.Damper = 0.7
			end)
			ConfigButton.MouseLeave:Connect(function()
				configHoverSpring.Target = 0
			end)
			
			-- Callback do botão de config
			if Info.ConfigCallback then
				ConfigButton.MouseButton1Click:Connect(function()
					Info.ConfigCallback(Toggle)
				end)
			end
		end
		
		-- Switch minimalista com gradiente suave
		local SwitchOuter = Library:Create('Frame', {
			BackgroundColor3 = _Color3FromRGB(40, 40, 50),
			BorderSizePixel = 0,
			Size = _UDim2New(0, 44, 0, 24),
			Position = _UDim2New(1, -44, 0.5, -12),
			ZIndex = 6,
			Parent = ToggleFrame,
		})
		Library:Create('UICorner', {
			CornerRadius = _UDimNew(0, 12),
			Parent = SwitchOuter,
		})
		
		-- Gradiente suave no switch
		local SwitchGradient = Library:Create('UIGradient', {
			Color = _ColorSequenceNew({
				_ColorSequenceKeypointNew(0, _Color3FromRGB(40, 40, 50)),
				_ColorSequenceKeypointNew(1, _Color3FromRGB(35, 35, 45)),
			}),
			Rotation = 90,
			Parent = SwitchOuter,
		})
		
		local SwitchStroke = Library:Create('UIStroke', {
			Color = Library.OutlineColor,
			Thickness = 1.5,
			Transparency = 0.7,
			Parent = SwitchOuter,
		})
		
		-- Knob do switch com sombra suave
		local SwitchKnob = Library:Create('Frame', {
			BackgroundColor3 = _Color3New(1, 1, 1),
			BorderSizePixel = 0,
			Size = _UDim2New(0, 18, 0, 18),
			Position = _UDim2New(0, 3, 0.5, -9),
			ZIndex = 8,
			Parent = SwitchOuter,
		})
		Library:Create('UICorner', {
			CornerRadius = _UDimNew(0, 9),
			Parent = SwitchKnob,
		})
		
		-- Sombra suave no knob
		local KnobShadow = Library:Create('UIStroke', {
			Color = _Color3New(0, 0, 0),
			Thickness = 1,
			Transparency = 0.6,
			Parent = SwitchKnob,
		})
		
		-- Gradiente no knob quando ativado
		local KnobGradient = Library:Create('UIGradient', {
			Color = _ColorSequenceNew({
				_ColorSequenceKeypointNew(0, _Color3New(1, 1, 1)),
				_ColorSequenceKeypointNew(1, _Color3FromRGB(240, 240, 250)),
			}),
			Rotation = 135,
			Parent = SwitchKnob,
		})
		
		-- Animações suaves com Spring
		local switchSpring = Library.Spring.new(Toggle.Value and 1 or 0)
		local switchColorSpring = Library.Spring.new(Toggle.Value and 1 or 0)
		local switchConnection = RunService.RenderStepped:Connect(function()
			local value = switchSpring.Position
			local colorValue = switchColorSpring.Position
			
			-- Interpolar posição do knob (de 3px a 23px)
			local knobX = 3 + (value * 23)
			SwitchKnob.Position = _UDim2New(0, knobX, 0.5, -9)
			
			-- Interpolar cor do switch com gradiente suave
			local accentR, accentG, accentB = Library.AccentColor.R, Library.AccentColor.G, Library.AccentColor.B
			local accent2R, accent2G, accent2B = (Library.AccentColorSecondary and Library.AccentColorSecondary.R or accentR), 
				(Library.AccentColorSecondary and Library.AccentColorSecondary.G or accentG),
				(Library.AccentColorSecondary and Library.AccentColorSecondary.B or accentB)
			local baseR, baseG, baseB = 0.15, 0.15, 0.18
			
			SwitchGradient.Color = _ColorSequenceNew({
				_ColorSequenceKeypointNew(0, Color3.new(
					baseR + (accentR - baseR) * colorValue * 0.6,
					baseG + (accentG - baseG) * colorValue * 0.6,
					baseB + (accentB - baseB) * colorValue * 0.6
				)),
				_ColorSequenceKeypointNew(1, Color3.new(
					baseR + (accent2R - baseR) * colorValue * 0.4,
					baseG + (accent2G - baseG) * colorValue * 0.4,
					baseB + (accent2B - baseB) * colorValue * 0.4
				)),
			})
			
			-- Escala suave do knob
			local scale = 0.95 + (colorValue * 0.05)
			SwitchKnob.Size = _UDim2New(0, 18 * scale, 0, 18 * scale)
		end)
		
		-- Hover effect suave
		local switchHoverSpring = Library.Spring.new(0)
		local switchHoverConnection = RunService.RenderStepped:Connect(function()
			local alpha = switchHoverSpring.Position
			SwitchStroke.Transparency = 0.7 - (alpha * 0.5)
			SwitchStroke.Thickness = 1.5 + (alpha * 0.5)
		end)
		
		SwitchOuter.MouseEnter:Connect(function()
			switchHoverSpring.Target = 1
			switchHoverSpring.Speed = 25
			switchHoverSpring.Damper = 0.8
		end)
		SwitchOuter.MouseLeave:Connect(function()
			switchHoverSpring.Target = 0
		end)
		
		if _Type(Info.Tooltip) == 'string' then
			Library:AddToolTip(Info.Tooltip, ToggleFrame)
		end
		
		-- Função Display com animação Spring suave
		function Toggle:Display()
			if Toggle.Value then
				switchSpring.Target = 1
				switchColorSpring.Target = 1
				switchSpring.Speed = 30
				switchSpring.Damper = 0.85
				switchColorSpring.Speed = 25
				switchColorSpring.Damper = 0.8
			else
				switchSpring.Target = 0
				switchColorSpring.Target = 0
				switchSpring.Speed = 30
				switchSpring.Damper = 0.85
				switchColorSpring.Speed = 25
				switchColorSpring.Damper = 0.8
			end
		end
		
		function Toggle:OnChanged(Func)
			Toggle.Changed = Func
			Func(Toggle.Value)
		end
		
		function Toggle:SetValue(Bool)
			Bool = (not not Bool)
			Toggle.Value = Bool
			
			-- Atualizar visual imediatamente
			Toggle:Display()
			
			for _, Addon in next, Toggle.Addons do
				if Addon.Type == 'KeyPicker' and Addon.SyncToggleState then
					Addon.Toggled = Bool
					Addon:Update()
				end
			end
			
			Library:SafeCallback(Toggle.Callback, Toggle.Value)
			Library:SafeCallback(Toggle.Changed, Toggle.Value)
			Library:UpdateDependencyBoxes()
		end
		
		-- Detectar clique no frame inteiro ou no switch
		local function OnToggleClick(Input)
			if Input.UserInputType == Enum.UserInputType.MouseButton1 and not Library:MouseIsOverOpenedFrame() then
				Toggle:SetValue(not Toggle.Value)
				Library:AttemptSave()
			end
		end
		
		ToggleFrame.InputBegan:Connect(OnToggleClick)
		SwitchOuter.InputBegan:Connect(OnToggleClick)
		SwitchKnob.InputBegan:Connect(OnToggleClick) -- Também detectar clique no knob
		
		if Toggle.Risky then
			Library:RemoveFromRegistry(ToggleLabel)
			ToggleLabel.TextColor3 = Library.RiskColor
			Library:AddToRegistry(ToggleLabel, { TextColor3 = 'RiskColor' })
		end
		
		-- Atualizar visual inicial
		Toggle:Display()
		
		-- Descrição abaixo do toggle (estilo Vizor)
		if Info.Description then
			local DescLabel = Library:CreateLabel({
				Size = _UDim2New(1, 0, 0, 14),
				Position = _UDim2New(0, 0, 1, 2),
				TextSize = 11,
				Font = Library.Font or Enum.Font.Gotham,
				Text = Info.Description,
				TextColor3 = _Color3FromRGB(180, 180, 180),
				TextXAlignment = Enum.TextXAlignment.Left,
				TextWrapped = true,
				ZIndex = 6,
				Parent = ToggleFrame,
			})
			ToggleFrame.Size = _UDim2New(1, 0, 0, 22 + DescLabel.TextBounds.Y + 4)
		end
		
		Groupbox:AddBlank(Info.Description and 6 or 2)
		Groupbox:Resize()
		
		Toggle.TextLabel = ToggleLabel
		Toggle.Container = Container
		Toggle.ConfigButton = ConfigButton
		setmetatable(Toggle, BaseAddons)
		
		Toggles[Idx] = Toggle
		Library:UpdateDependencyBoxes()
		
		return Toggle
	end
	
	--[[ ========================================
	    ADD SLIDER - MODERNO
	======================================== ]]
	function Funcs:AddSlider(Idx, Info)
		assert(Info.Default, 'AddSlider: Missing default value.')
		assert(Info.Text, 'AddSlider: Missing slider text.')
		assert(Info.Min, 'AddSlider: Missing minimum value.')
		assert(Info.Max, 'AddSlider: Missing maximum value.')
		assert(Info.Rounding, 'AddSlider: Missing rounding value.')
		
		local Slider = {
			Value = Info.Default,
			Min = Info.Min,
			Max = Info.Max,
			Rounding = Info.Rounding,
			MaxSize = 0, -- Será calculado dinamicamente
			Type = 'Slider',
			Callback = Info.Callback or function(Value) end,
		}
		
		local Groupbox = self
		local Container = Groupbox.Container
		
		-- Label e valor em linha
		local SliderFrame = Library:Create('Frame', {
			BackgroundTransparency = 1,
			Size = _UDim2New(1, 0, 0, Info.Compact and 24 or 38),
			ZIndex = 5,
			Parent = Container,
		})
		
		if not Info.Compact then
			local Label = Library:CreateLabel({
				Size = _UDim2New(0.7, 0, 0, 16),
				Position = _UDim2New(0, 0, 0, 0),
				TextSize = 13,
				Font = Library.Font or Enum.Font.GothamMedium,
				Text = Info.Text,
				TextXAlignment = Enum.TextXAlignment.Left,
				ZIndex = 5,
				Parent = SliderFrame,
			})
		end
		
		-- Track do slider com gradiente suave
		local SliderOuter = Library:Create('Frame', {
			BackgroundColor3 = _Color3FromRGB(35, 35, 45),
			BorderSizePixel = 0,
			Size = _UDim2New(1, 0, 0, 6),
			Position = _UDim2New(0, 0, 1, -10),
			ZIndex = 5,
			Parent = SliderFrame,
		})
		Library:Create('UICorner', {
			CornerRadius = _UDimNew(0, 3),
			Parent = SliderOuter,
		})
		
		local TrackGradient = Library:Create('UIGradient', {
			Color = _ColorSequenceNew({
				_ColorSequenceKeypointNew(0, _Color3FromRGB(35, 35, 45)),
				_ColorSequenceKeypointNew(1, _Color3FromRGB(30, 30, 40)),
			}),
			Rotation = 90,
			Parent = SliderOuter,
		})
		
		local SliderStroke = Library:Create('UIStroke', {
			Color = Library.OutlineColor,
			Thickness = 1,
			Transparency = 0.7,
			Parent = SliderOuter,
		})
		Library:AddToRegistry(SliderStroke, { Color = 'OutlineColor' })
		
		-- Fill do slider com gradiente suave
		local Fill = Library:Create('Frame', {
			BackgroundColor3 = Library.AccentColor,
			BorderSizePixel = 0,
			Size = _UDim2New(0, 0, 1, 0),
			ZIndex = 6,
			Parent = SliderOuter,
		})
		Library:Create('UICorner', {
			CornerRadius = _UDimNew(0, 3),
			Parent = Fill,
		})
		
		local FillGradient = Library:Create('UIGradient', {
			Color = _ColorSequenceNew({
				_ColorSequenceKeypointNew(0, Library.AccentColor),
				_ColorSequenceKeypointNew(1, Library.AccentColorSecondary or Library.AccentColor),
			}),
			Rotation = 90,
			Parent = Fill,
		})
		Library:AddToRegistry(Fill, { BackgroundColor3 = 'AccentColor' })
		
		-- Knob do slider com sombra suave
		local Knob = Library:Create('Frame', {
			BackgroundColor3 = _Color3New(1, 1, 1),
			BorderSizePixel = 0,
			Size = _UDim2New(0, 18, 0, 18),
			Position = _UDim2New(0, -9, 0.5, -9),
			ZIndex = 8,
			Parent = SliderOuter,
		})
		Library:Create('UICorner', {
			CornerRadius = _UDimNew(0, 9),
			Parent = Knob,
		})
		
		local KnobGradient = Library:Create('UIGradient', {
			Color = _ColorSequenceNew({
				_ColorSequenceKeypointNew(0, _Color3New(1, 1, 1)),
				_ColorSequenceKeypointNew(1, _Color3FromRGB(240, 240, 250)),
			}),
			Rotation = 135,
			Parent = Knob,
		})
		
		-- Contorno suave no knob
		local KnobStroke = Library:Create('UIStroke', {
			Color = Library.AccentColor,
			Thickness = 2,
			Transparency = 0.4,
			Parent = Knob,
		})
		Library:AddToRegistry(KnobStroke, { Color = 'AccentColor' })
		
		-- Display do valor
		local DisplayLabel = Library:CreateLabel({
			Size = _UDim2New(0, 50, 0, 16),
			Position = _UDim2New(1, -50, 0, 0),
			TextSize = 12,
			Font = Library.Font or Enum.Font.GothamMedium,
			Text = 'Value',
			TextXAlignment = Enum.TextXAlignment.Right,
			ZIndex = 9,
			Parent = SliderFrame,
		})
		
		-- Hover effect com animação Spring
		local sliderHoverSpring = Library.Spring.new(0)
		local sliderHoverConnection = RunService.RenderStepped:Connect(function()
			local alpha = sliderHoverSpring.Position
			SliderStroke.Transparency = 0.7 - (alpha * 0.7)
		end)
		
		SliderFrame.MouseEnter:Connect(function()
			sliderHoverSpring.Target = 1
			sliderHoverSpring.Speed = 20
			sliderHoverSpring.Damper = 0.7
		end)
		SliderFrame.MouseLeave:Connect(function()
			sliderHoverSpring.Target = 0
		end)
		
		if _Type(Info.Tooltip) == 'string' then
			Library:AddToolTip(Info.Tooltip, SliderOuter)
		end
		
		-- Spring para animação do slider
		local sliderSpring = Library.Spring.new(0)
		local sliderConnection = RunService.RenderStepped:Connect(function()
			local value = sliderSpring.Position
			Slider.MaxSize = SliderOuter.AbsoluteSize.X
			if Slider.MaxSize == 0 then Slider.MaxSize = 200 end
			
			-- Atualizar fill e knob com animação
			Fill.Size = _UDim2New(value, 0, 1, 0)
			local knobX = (Slider.MaxSize * value) - 8
			Knob.Position = _UDim2New(0, _MathClamp(knobX, -8, Slider.MaxSize - 8), 0.5, -8)
		end)
		
		function Slider:Display()
			local Suffix = Info.Suffix or ''
			
			if Info.Compact then
				DisplayLabel.Text = Info.Text .. ': ' .. Slider.Value .. Suffix
			else
				DisplayLabel.Text = Slider.Value .. Suffix
			end
			
			Slider.MaxSize = SliderOuter.AbsoluteSize.X
			if Slider.MaxSize == 0 then Slider.MaxSize = 200 end -- Fallback
			
			local Percent = (Slider.Value - Slider.Min) / (Slider.Max - Slider.Min)
			Percent = _MathClamp(Percent, 0, 1)
			
			-- Animar para o novo valor
			sliderSpring.Target = Percent
			sliderSpring.Speed = 30
			sliderSpring.Damper = 0.8
		end
		
		function Slider:OnChanged(Func)
			Slider.Changed = Func
			Func(Slider.Value)
		end
		
		local function Round(Value)
			if Slider.Rounding == 0 then
				return _MathFloor(Value)
			end
			return _tonumber(_StringFormat('%.' .. Slider.Rounding .. 'f', Value))
		end
		
		function Slider:GetValueFromXOffset(X)
			return Round(Library:MapValue(X, 0, Slider.MaxSize, Slider.Min, Slider.Max))
		end
		
		function Slider:SetValue(Str)
			local Num = _tonumber(Str)
			if not Num then return end
			
			Num = _MathClamp(Num, Slider.Min, Slider.Max)
			Slider.Value = Round(Num)
			Slider:Display()
			
			Library:SafeCallback(Slider.Callback, Slider.Value)
			Library:SafeCallback(Slider.Changed, Slider.Value)
		end
		
		SliderOuter.InputBegan:Connect(function(Input)
			if Input.UserInputType == Enum.UserInputType.MouseButton1 and not Library:MouseIsOverOpenedFrame() then
				Slider.MaxSize = SliderOuter.AbsoluteSize.X
				
				while UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
					local mPos = Mouse.X
					local sliderPos = SliderOuter.AbsolutePosition.X
					local nX = _MathClamp(mPos - sliderPos, 0, Slider.MaxSize)
					
					local nValue = Slider:GetValueFromXOffset(nX)
					local OldValue = Slider.Value
					Slider.Value = nValue
					
					Slider:Display()
					
					if nValue ~= OldValue then
						Library:SafeCallback(Slider.Callback, Slider.Value)
						Library:SafeCallback(Slider.Changed, Slider.Value)
					end
					
					RenderStepped:Wait()
				end
				
				Library:AttemptSave()
			end
		end)
		
		-- Inicializar spring com valor inicial
		local initialPercent = (Slider.Value - Slider.Min) / (Slider.Max - Slider.Min)
		sliderSpring.Position = _MathClamp(initialPercent, 0, 1)
		
		Slider:Display()
		Groupbox:AddBlank(Info.BlankSize or 6)
		Groupbox:Resize()
		
		Options[Idx] = Slider
		
		return Slider
	end
	
	--[[ ========================================
	    ADD INPUT
	======================================== ]]
	function Funcs:AddInput(Idx, Info)
		assert(Info.Text, 'AddInput: Missing `Text` string.')
		
		local Textbox = {
			Value = Info.Default or '',
			Numeric = Info.Numeric or false,
			Finished = Info.Finished or false,
			Type = 'Input',
			Callback = Info.Callback or function(Value) end,
		}
		
		local Groupbox = self
		local Container = Groupbox.Container
		
		local InputLabel = Library:CreateLabel({
			Size = _UDim2New(1, 0, 0, 15),
			TextSize = 15,
			Text = Info.Text,
			TextXAlignment = Enum.TextXAlignment.Left,
			ZIndex = 5,
			Parent = Container,
		})
		
		Groupbox:AddBlank(1)
		
		local TextBoxOuter = Library:Create('Frame', {
			BackgroundColor3 = _Color3New(0, 0, 0),
			BorderColor3 = _Color3New(0, 0, 0),
			BorderSizePixel = 0,
			Size = _UDim2New(1, -4, 0, 18),
			ZIndex = 5,
			Parent = Container,
		})
		
		local TextBoxInner = Library:Create('Frame', {
			BackgroundColor3 = Library.MainColor,
			BorderColor3 = Library.OutlineColor,
			BorderMode = Enum.BorderMode.Inset,
			Size = _UDim2New(1, 0, 1, 0),
			ZIndex = 6,
			Parent = TextBoxOuter,
		})
		
		Library:AddToRegistry(TextBoxInner, { BackgroundColor3 = 'MainColor', BorderColor3 = 'OutlineColor' })
		
		Library:OnHighlight(TextBoxOuter, TextBoxOuter,
			{ BorderColor3 = 'AccentColor' },
			{ BorderColor3 = 'Black' }
		)
		
		if _Type(Info.Tooltip) == 'string' then
			Library:AddToolTip(Info.Tooltip, TextBoxOuter)
		end
		
		Library:Create('UIGradient', {
			Color = _ColorSequenceNew({
				_ColorSequenceKeypointNew(0, _Color3New(1, 1, 1)),
				_ColorSequenceKeypointNew(1, _Color3FromRGB(212, 212, 212))
			}),
			Rotation = 90,
			Parent = TextBoxInner,
		})
		
		local BoxContainer = Library:Create('Frame', {
			BackgroundTransparency = 1,
			ClipsDescendants = true,
			Position = _UDim2New(0, 5, 0, 0),
			Size = _UDim2New(1, -5, 1, 0),
			ZIndex = 7,
			Parent = TextBoxInner,
		})
		
		local Box = Library:Create('TextBox', {
			BackgroundTransparency = 1,
			Position = _UDim2fromOffset(0, 0),
			Size = _UDim2New(5, 0, 1, 0),
			Font = Library.Font,
			PlaceholderColor3 = _Color3FromRGB(190, 190, 190),
			PlaceholderText = Info.Placeholder or '',
			Text = Info.Default or '',
			TextColor3 = Library.FontColor,
			TextSize = 15,
			TextStrokeTransparency = 1,
			TextXAlignment = Enum.TextXAlignment.Left,
			ZIndex = 7,
			Parent = BoxContainer,
		})
		
		Library:AddToRegistry(Box, { TextColor3 = 'FontColor' })
		
		function Textbox:SetValue(Text)
			if Info.MaxLength and #Text > Info.MaxLength then
				Text = Text:sub(1, Info.MaxLength)
			end
			
			if Textbox.Numeric then
				if not _tonumber(Text) and #Text > 0 then
					Text = Textbox.Value
				end
			end
			
			Textbox.Value = Text
			Box.Text = Text
			
			Library:SafeCallback(Textbox.Callback, Textbox.Value)
			Library:SafeCallback(Textbox.Changed, Textbox.Value)
		end
		
		if Textbox.Finished then
			Box.FocusLost:Connect(function(enter)
				if not enter then return end
				Textbox:SetValue(Box.Text)
				Library:AttemptSave()
			end)
		else
			Box:GetPropertyChangedSignal('Text'):Connect(function()
				Textbox:SetValue(Box.Text)
				Library:AttemptSave()
			end)
		end
		
		function Textbox:OnChanged(Func)
			Textbox.Changed = Func
			Func(Textbox.Value)
		end
		
		Groupbox:AddBlank(5)
		Groupbox:Resize()
		
		Options[Idx] = Textbox
		
		return Textbox
	end
	
	--[[ ========================================
	    ADD DROPDOWN
	======================================== ]]
	function Funcs:AddDropdown(Idx, Info)
		assert(Info.Values, 'AddDropdown: Missing dropdown value list.')
		assert(Info.AllowNull or Info.Default, 'AddDropdown: Missing default value.')
		
		if not Info.Text then
			Info.Compact = true
		end
		
		local Dropdown = {
			Values = Info.Values,
			Value = Info.Multi and {} or nil,
			Multi = Info.Multi,
			Type = 'Dropdown',
			Callback = Info.Callback or function(Value) end,
		}
		
		local Groupbox = self
		local Container = Groupbox.Container
		
		if not Info.Compact then
			local DropdownLabel = Library:CreateLabel({
				Size = _UDim2New(1, 0, 0, 10),
				TextSize = 15,
				Text = Info.Text,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Bottom,
				ZIndex = 5,
				Parent = Container,
			})
			Groupbox:AddBlank(3)
		end
		
		local DropdownOuter = Library:Create('Frame', {
			BackgroundColor3 = _Color3New(0, 0, 0),
			BorderColor3 = _Color3New(0, 0, 0),
			BorderSizePixel = 0,
			Size = _UDim2New(1, -4, 0, 18),
			ZIndex = 5,
			Parent = Container,
		})
		
		Library:AddToRegistry(DropdownOuter, { BorderColor3 = 'Black' })
		
		local DropdownInner = Library:Create('Frame', {
			BackgroundColor3 = Library.MainColor,
			BorderColor3 = Library.OutlineColor,
			BorderMode = Enum.BorderMode.Inset,
			Size = _UDim2New(1, 0, 1, 0),
			ZIndex = 6,
			Parent = DropdownOuter,
		})
		
		Library:AddToRegistry(DropdownInner, { BackgroundColor3 = 'MainColor', BorderColor3 = 'OutlineColor' })
		
		Library:Create('UIGradient', {
			Color = _ColorSequenceNew({
				_ColorSequenceKeypointNew(0, _Color3New(1, 1, 1)),
				_ColorSequenceKeypointNew(1, _Color3FromRGB(212, 212, 212))
			}),
			Rotation = 90,
			Parent = DropdownInner,
		})
		
		local DropdownArrow = Library:CreateLabel({
			AnchorPoint = _Vector2New(0, 0.5),
			BackgroundTransparency = 1,
			Position = _UDim2New(1, -16, 0.5, 0),
			Size = _UDim2New(0, 12, 0, 12),
			TextSize = 14,
			Text = '+',
			ZIndex = 8,
			Parent = DropdownInner,
		})
		
		local ItemList = Library:CreateLabel({
			Position = _UDim2New(0, 5, 0, 0),
			Size = _UDim2New(1, -5, 1, 0),
			TextSize = 15,
			Text = '--',
			TextXAlignment = Enum.TextXAlignment.Left,
			TextWrapped = true,
			ZIndex = 7,
			Parent = DropdownInner,
		})
		
		Library:OnHighlight(DropdownOuter, DropdownOuter,
			{ BorderColor3 = 'AccentColor', BorderSizePixel = 1 },
			{ BorderColor3 = 'Black', BorderSizePixel = 0 }
		)
		
		if _Type(Info.Tooltip) == 'string' then
			Library:AddToolTip(Info.Tooltip, DropdownOuter)
		end
		
		local MAX_DROPDOWN_ITEMS = 8
		
		local ListOuter = Library:Create('Frame', {
			BackgroundColor3 = _Color3New(0, 0, 0),
			BorderColor3 = _Color3New(0, 0, 0),
			BorderSizePixel = 0,
			ZIndex = 20,
			Visible = false,
			Parent = ScreenGui,
		})
		
		local function RecalculateListPosition()
			ListOuter.Position = _UDim2fromOffset(DropdownOuter.AbsolutePosition.X, DropdownOuter.AbsolutePosition.Y + DropdownOuter.Size.Y.Offset + 1)
		end
		
		local function RecalculateListSize(YSize)
			ListOuter.Size = _UDim2fromOffset(DropdownOuter.AbsoluteSize.X, YSize or (MAX_DROPDOWN_ITEMS * 20 + 2))
		end
		
		RecalculateListPosition()
		RecalculateListSize()
		
		DropdownOuter:GetPropertyChangedSignal('AbsolutePosition'):Connect(RecalculateListPosition)
		
		local ListInner = Library:Create('Frame', {
			BackgroundColor3 = Library.MainColor,
			BorderColor3 = Library.OutlineColor,
			BorderMode = Enum.BorderMode.Inset,
			BorderSizePixel = 0,
			Size = _UDim2New(1, 0, 1, 0),
			ZIndex = 21,
			Parent = ListOuter,
		})
		
		Library:AddToRegistry(ListInner, { BackgroundColor3 = 'MainColor', BorderColor3 = 'OutlineColor' })
		
		local Scrolling = Library:Create('ScrollingFrame', {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			CanvasSize = _UDim2New(0, 0, 0, 0),
			Size = _UDim2New(1, 0, 1, 0),
			ZIndex = 21,
			Parent = ListInner,
			TopImage = 'rbxasset://textures/ui/Scroll/scroll-middle.png',
			BottomImage = 'rbxasset://textures/ui/Scroll/scroll-middle.png',
			ScrollBarThickness = 3,
			ScrollBarImageColor3 = Library.AccentColor,
		})
		
		Library:AddToRegistry(Scrolling, { ScrollBarImageColor3 = 'AccentColor' })
		
		Library:Create('UIListLayout', {
			Padding = _UDimNew(0, 0),
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			Parent = Scrolling,
		})
		
		function Dropdown:Display()
			local Values = Dropdown.Values
			local Str = ''
			
			if Info.Multi then
				for _, Value in next, Values do
					if Dropdown.Value[Value] then
						Str = Str .. Value .. ', '
					end
				end
				Str = Str:sub(1, #Str - 2)
			else
				Str = Dropdown.Value or ''
			end
			
			ItemList.Text = (Str == '' and '--' or Str)
		end
		
		function Dropdown:GetActiveValues()
			if Info.Multi then
				local T = {}
				for Value, Bool in next, Dropdown.Value do
					_TableInsert(T, Value)
				end
				return T
			else
				return Dropdown.Value and 1 or 0
			end
		end
		
		function Dropdown:BuildDropdownList()
			local Values = Dropdown.Values
			local Buttons = {}
			
			for _, Element in next, Scrolling:GetChildren() do
				if not Element:IsA('UIListLayout') then
					Element:Destroy()
				end
			end
			
			local Count = 0
			
			for _, Value in next, Values do
				local Table = {}
				Count = Count + 1
				
				local Button = Library:Create('Frame', {
					BackgroundColor3 = Library.MainColor,
					BorderColor3 = Library.OutlineColor,
					BorderMode = Enum.BorderMode.Middle,
					Size = _UDim2New(1, -5, 0, 20),
					ZIndex = 23,
					Active = true,
					Parent = Scrolling,
				})
				
				Library:AddToRegistry(Button, { BackgroundColor3 = 'MainColor', BorderColor3 = 'OutlineColor' })
				
				local ButtonLabel = Library:CreateLabel({
					Active = false,
					Size = _UDim2New(1, -6, 1, 0),
					Position = _UDim2New(0, 6, 0, 0),
					TextSize = 15,
					Text = Value,
					TextXAlignment = Enum.TextXAlignment.Left,
					ZIndex = 25,
					Parent = Button,
				})
				
				Library:OnHighlight(Button, Button,
					{ BorderColor3 = 'AccentColor', ZIndex = 24 },
					{ BorderColor3 = 'OutlineColor', ZIndex = 23 }
				)
				
				local Selected
				if Info.Multi then
					Selected = Dropdown.Value[Value]
				else
					Selected = Dropdown.Value == Value
				end
				
				function Table:UpdateButton()
					if Info.Multi then
						Selected = Dropdown.Value[Value]
					else
						Selected = Dropdown.Value == Value
					end
					
					ButtonLabel.TextColor3 = Selected and Library.AccentColor or Library.FontColor
					Library.RegistryMap[ButtonLabel].Properties.TextColor3 = Selected and 'AccentColor' or 'FontColor'
				end
				
				ButtonLabel.InputBegan:Connect(function(Input)
					if Input.UserInputType == Enum.UserInputType.MouseButton1 then
						local Try = not Selected
						
						if Dropdown:GetActiveValues() == 1 and (not Try) and (not Info.AllowNull) then
							-- Can't deselect
						else
							if Info.Multi then
								Selected = Try
								if Selected then
									Dropdown.Value[Value] = true
								else
									Dropdown.Value[Value] = nil
								end
							else
								Selected = Try
								if Selected then
									Dropdown.Value = Value
								else
									Dropdown.Value = nil
								end
								
								for _, OtherButton in next, Buttons do
									OtherButton:UpdateButton()
								end
							end
							
							Table:UpdateButton()
							Dropdown:Display()
							
							Library:SafeCallback(Dropdown.Callback, Dropdown.Value)
							Library:SafeCallback(Dropdown.Changed, Dropdown.Value)
							Library:AttemptSave()
						end
					end
				end)
				
				Table:UpdateButton()
				Dropdown:Display()
				
				Buttons[Button] = Table
			end
			
			Scrolling.CanvasSize = _UDim2fromOffset(0, (Count * 20) + 1)
			
			local Y = _MathClamp(Count * 20, 0, MAX_DROPDOWN_ITEMS * 20) + 1
			RecalculateListSize(Y)
		end
		
		function Dropdown:SetValues(NewValues)
			if NewValues then
				Dropdown.Values = NewValues
			end
			Dropdown:BuildDropdownList()
		end
		
		function Dropdown:OpenDropdown()
			ListOuter.Visible = true
			Library.OpenedFrames[ListOuter] = true
			DropdownArrow.Text = '-'
		end
		
		function Dropdown:CloseDropdown()
			ListOuter.Visible = false
			Library.OpenedFrames[ListOuter] = nil
			DropdownArrow.Text = '+'
		end
		
		function Dropdown:OnChanged(Func)
			Dropdown.Changed = Func
			Func(Dropdown.Value)
		end
		
		function Dropdown:SetValue(Val)
			if Dropdown.Multi then
				local nTable = {}
				for Value, Bool in next, Val do
					if _TableFind(Dropdown.Values, Value) then
						nTable[Value] = true
					end
				end
				Dropdown.Value = nTable
			else
				if not Val then
					Dropdown.Value = nil
				elseif _TableFind(Dropdown.Values, Val) then
					Dropdown.Value = Val
				end
			end
			
			Dropdown:BuildDropdownList()
			Library:SafeCallback(Dropdown.Callback, Dropdown.Value)
			Library:SafeCallback(Dropdown.Changed, Dropdown.Value)
		end
		
		DropdownOuter.InputBegan:Connect(function(Input)
			if Input.UserInputType == Enum.UserInputType.MouseButton1 and not Library:MouseIsOverOpenedFrame() then
				if ListOuter.Visible then
					Dropdown:CloseDropdown()
				else
					Dropdown:OpenDropdown()
				end
			end
		end)
		
		UserInputService.InputBegan:Connect(function(Input)
			if Input.UserInputType == Enum.UserInputType.MouseButton1 then
				local AbsPos, AbsSize = ListOuter.AbsolutePosition, ListOuter.AbsoluteSize
				
				if Mouse.X < AbsPos.X or Mouse.X > AbsPos.X + AbsSize.X
					or Mouse.Y < (AbsPos.Y - 20 - 1) or Mouse.Y > AbsPos.Y + AbsSize.Y then
					Dropdown:CloseDropdown()
				end
			end
		end)
		
		Dropdown:BuildDropdownList()
		Dropdown:Display()
		
		-- Set default value
		if Info.Default then
			if Info.Multi then
				if _Type(Info.Default) == 'table' then
					for _, Value in next, Info.Default do
						if _TableFind(Dropdown.Values, Value) then
							Dropdown.Value[Value] = true
						end
					end
				end
			else
				if _TableFind(Dropdown.Values, Info.Default) then
					Dropdown.Value = Info.Default
				end
			end
			Dropdown:BuildDropdownList()
			Dropdown:Display()
		end
		
		Groupbox:AddBlank(Info.BlankSize or 5)
		Groupbox:Resize()
		
		Options[Idx] = Dropdown
		
		return Dropdown
	end
	
	--[[ ========================================
	    ADD DEPENDENCY BOX
	======================================== ]]
	function Funcs:AddDependencyBox()
		local Depbox = {
			Dependencies = {},
		}
		
		local Groupbox = self
		local Container = Groupbox.Container
		
		local Holder = Library:Create('Frame', {
			BackgroundTransparency = 1,
			Size = _UDim2New(1, 0, 0, 0),
			Visible = false,
			Parent = Container,
		})
		
		local Frame = Library:Create('Frame', {
			BackgroundTransparency = 1,
			Size = _UDim2New(1, 0, 1, 0),
			Visible = true,
			Parent = Holder,
		})
		
		local Layout = Library:Create('UIListLayout', {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Parent = Frame,
		})
		
		function Depbox:Resize()
			Holder.Size = _UDim2New(1, 0, 0, Layout.AbsoluteContentSize.Y)
			Groupbox:Resize()
		end
		
		Layout:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()
			Depbox:Resize()
		end)
		
		Holder:GetPropertyChangedSignal('Visible'):Connect(function()
			Depbox:Resize()
		end)
		
		local IsNotHidden = true
		
		function Depbox:Update()
			for _, Dependency in next, Depbox.Dependencies do
				local Elem = Dependency[1]
				local Value = Dependency[2]
				
				if Elem.Type == 'Toggle' and Elem.Value ~= Value then
					Holder.Visible = false
					Depbox:Resize()
					return
				end
			end
			if IsNotHidden then
				Holder.Visible = true
				Depbox:Resize()
			end
		end
		
		function Depbox:SetupDependencies(Dependencies)
			for _, Dependency in next, Dependencies do
				assert(_Type(Dependency) == 'table', 'SetupDependencies: Dependency is not of type `table`.')
				assert(Dependency[1], 'SetupDependencies: Dependency is missing element argument.')
				assert(Dependency[2] ~= nil, 'SetupDependencies: Dependency is missing value argument.')
			end
			
			Depbox.Dependencies = Dependencies
			Depbox:Update()
		end
		
		function Depbox:Show()
			Holder.Visible = true
			IsNotHidden = true
		end
		
		function Depbox:Hide()
			Holder.Visible = false
			IsNotHidden = false
		end
		
		Depbox.Container = Frame
		
		setmetatable(Depbox, { __index = Funcs })
		
		_TableInsert(Library.DependencyBoxes, Depbox)
		
		return Depbox
	end
	
	return Funcs
end

return Elements

