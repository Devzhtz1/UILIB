--[[
    Window - CreateWindow, Tab, GroupBox, Tabbox
]]

local Window = {}

function Window:Init(Library, Toggles, Options, ScreenGui, BaseGroupbox)
	local _Instancenew = Instance.new
	local _UDim2New = UDim2.new
	local _UDim2fromOffset = UDim2.fromOffset
	local _UDim2fromScale = UDim2.fromScale
	local _UDimNew = UDim.new
	local _Vector2New = Vector2.new
	local _Color3New = Color3.new
	local _Color3FromRGB = Color3.fromRGB
	local _TableInsert = table.insert
	local _Type = type
	
	local UserInputService = game:GetService("UserInputService")
	local RunService = game:GetService("RunService")
	local Players = game:GetService("Players")
	local Mouse = Players.LocalPlayer:GetMouse()
	
	--[[ ========================================
	    CREATE WINDOW
	======================================== ]]
	function Library:CreateWindow(...)
		local Arguments = { ... }
		local Config = { AnchorPoint = _Vector2New(0, 0) }
		
		if _Type(...) == 'table' then
			Config = ...
		else
			Config.Title = Arguments[1]
			Config.AutoShow = Arguments[2] or false
		end
		
		if _Type(Config.Title) ~= 'string' then Config.Title = 'Aurora UI' end
		if _Type(Config.TabPadding) ~= 'number' then Config.TabPadding = 0 end
		if _Type(Config.MenuFadeTime) ~= 'number' then Config.MenuFadeTime = 0.2 end
		
		if typeof(Config.Position) ~= 'UDim2' then Config.Position = _UDim2fromOffset(175, 50) end
		if typeof(Config.Size) ~= 'UDim2' then Config.Size = _UDim2fromOffset(800, 600) end
		if typeof(Config.Color) ~= 'Color3' then Config.Color = Library.FontColor end
		
		if Config.Center then
			Config.AnchorPoint = _Vector2New(0.5, 0.5)
			Config.Position = _UDim2fromScale(0.5, 0.5)
		end
		
		local Window = {
			Tabs = {},
			TabButtons = {},
		}
		
		-- Window no estilo Vizor (sem cantos arredondados, bordas sutis)
		local Outer = Library:Create('Frame', {
			AnchorPoint = Config.AnchorPoint,
			BackgroundColor3 = Library.MainColor,
			BorderSizePixel = 0,
			Position = Config.Position,
			Size = Config.Size,
			Visible = false,
			ZIndex = 1,
			Parent = ScreenGui,
		})
		Window.MainFrame = Outer
		
		-- Borda sutil estilo Vizor
		local OuterStroke = Library:Create('UIStroke', {
			Color = Library.OutlineColor,
			Thickness = 1,
			Transparency = 0.2,
			Parent = Outer,
		})
		Library:AddToRegistry(OuterStroke, { Color = 'OutlineColor' })
		
		local Outer2 = Library:Create('Frame', {
			AnchorPoint = Config.AnchorPoint,
			BackgroundColor3 = Library.MainColor,
			BorderSizePixel = 0,
			Position = Config.Position,
			Size = Config.Size,
			Visible = false,
			ZIndex = 0,
			Parent = ScreenGui,
		})
		
		Library:MakeDraggable(Outer, 32, Outer2)
		
		local Inner = Library:Create('Frame', {
			BackgroundColor3 = Library.BackgroundColor,
			BorderSizePixel = 0,
			Position = _UDim2New(0, 0, 0, 0),
			Size = _UDim2New(1, 0, 1, 0),
			ZIndex = 1,
			Parent = Outer,
		})
		
		local WindowGlow = Library:Create('ImageLabel', {
			ImageColor3 = Library.AccentColor,
			BackgroundTransparency = 1,
			AnchorPoint = _Vector2New(0.5, 0.5),
			Size = _UDim2New(1, 48, 1, 48),
			Position = _UDim2New(0.5, 0, 0.5, 0),
			BorderSizePixel = 0,
			Visible = false,
			ZIndex = -90,
			Image = "rbxassetid://73863974528152",
			Parent = Outer,
		})
		
		Library:AddToRegistry(Inner, { BackgroundColor3 = 'BackgroundColor' })
		Library:AddToRegistry(Outer, { BackgroundColor3 = 'MainColor' })
		Library:AddToRegistry(WindowGlow, { ImageColor3 = 'AccentColor' })
		Library:AddToRegistry(Outer2, { BackgroundColor3 = 'MainColor' })
		
		-- Header estilo Vizor (sem cantos arredondados)
		local HeaderFrame = Library:Create('Frame', {
			BackgroundColor3 = Library.MainColor,
			BackgroundTransparency = 0,
			BorderSizePixel = 0,
			Position = _UDim2New(0, 0, 0, 0),
			Size = _UDim2New(1, 0, 0, 40),
			ZIndex = 2,
			Parent = Inner,
		})
		
		-- Separator no header (estilo Vizor)
		local HeaderSeparator = Library:Create('Frame', {
			BackgroundColor3 = Library.SeparatorColor or Library.OutlineColor,
			BorderSizePixel = 0,
			Position = _UDim2New(0, 0, 1, -1),
			Size = _UDim2New(1, 0, 0, 1),
			ZIndex = 3,
			Parent = HeaderFrame,
		})
		Library:AddToRegistry(HeaderSeparator, { BackgroundColor3 = 'SeparatorColor' })
		
		local WindowLabel = Library:CreateLabel({
			Position = _UDim2New(0, 12, 0, 0),
			RichText = true,
			Size = _UDim2New(1, -24, 1, 0),
			TextColor3 = Library.FontColor,
			Text = Config.Title or '',
			TextXAlignment = Enum.TextXAlignment.Left,
			ZIndex = 3,
			TextSize = 14,
			Font = Library.Font or Enum.Font.Gotham,
			Parent = HeaderFrame,
		})
		
		local MainSectionOuter = Library:Create('Frame', {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Position = _UDim2New(0, 0, 0, 40),
			Size = _UDim2New(1, 0, 1, -40),
			ZIndex = 1,
			Parent = Inner,
		})
		
		local MainSectionInner = Library:Create('Frame', {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Position = _UDim2New(0, 0, 0, 0),
			Size = _UDim2New(1, 0, 1, 0),
			ZIndex = 1,
			Parent = MainSectionOuter,
		})
		
		-- Tab area estilo Vizor (sem cantos arredondados)
		local TabArea = Library:Create('Frame', {
			BackgroundColor3 = Library.MainColor,
			BackgroundTransparency = 0,
			BorderSizePixel = 0,
			Position = _UDim2New(0, 0, 0, 0),
			Size = _UDim2New(1, 0, 0, 30),
			ZIndex = 1,
			ClipsDescendants = false,
			Visible = true,
			Parent = MainSectionInner,
		})
		
		-- Separator abaixo das tabs
		local TabSeparator = Library:Create('Frame', {
			BackgroundColor3 = Library.SeparatorColor or Library.OutlineColor,
			BorderSizePixel = 0,
			Position = _UDim2New(0, 0, 1, -1),
			Size = _UDim2New(1, 0, 0, 1),
			ZIndex = 2,
			Parent = TabArea,
		})
		Library:AddToRegistry(TabSeparator, { BackgroundColor3 = 'SeparatorColor' })
		
		Library:Create('UIPadding', {
			PaddingLeft = _UDimNew(0, 2),
			PaddingRight = _UDimNew(0, 2),
			Parent = TabArea,
		})
		
		local TabListLayout = Library:Create('UIListLayout', {
			Padding = _UDimNew(0, 2),
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Parent = TabArea,
		})
		
		local TabContainer = Library:Create('Frame', {
			BackgroundColor3 = Library.BackgroundColor,
			BackgroundTransparency = 0,
			BorderSizePixel = 0,
			Position = _UDim2New(0, 0, 0, 30),
			Size = _UDim2New(1, 0, 1, -30),
			ZIndex = 2,
			Parent = MainSectionInner,
		})
		
		Library:AddToRegistry(TabArea, { BackgroundColor3 = 'MainColor' })
		Library:AddToRegistry(TabContainer, { BackgroundColor3 = 'BackgroundColor' })
		
		-- Função para recalcular tamanho das tabs
		local function RecalculateTabSizes()
			local tabCount = #Window.TabButtons
			if tabCount == 0 then return end
			
			local availableWidth = TabArea.AbsoluteSize.X
			if availableWidth <= 0 then
				availableWidth = MainSectionInner.AbsoluteSize.X
			end
			if availableWidth <= 0 then
				availableWidth = Outer.AbsoluteSize.X
			end
			
			local tabWidth = 120
			if availableWidth > 0 then
				local padding = 4
				local totalPadding = padding * (tabCount + 1)
				local usableWidth = availableWidth - totalPadding
				tabWidth = math.max(80, math.min(140, usableWidth / tabCount))
			else
				-- Fallback: tamanho padrão baseado no tamanho da janela
				local windowWidth = Config.Size and Config.Size.X.Offset or 800
				tabWidth = math.max(100, math.floor(windowWidth / tabCount))
			end
			
			-- Sempre garantir tamanho mínimo
			tabWidth = math.max(80, tabWidth)
			
			for i, v in next, Window.TabButtons do
				if v and v.Parent then
					v.Size = _UDim2New(0, tabWidth, 0, 30)
					v.Visible = true
				end
			end
		end
		
		-- Recalcular quando o TabArea mudar de tamanho
		TabArea:GetPropertyChangedSignal('AbsoluteSize'):Connect(RecalculateTabSizes)
		MainSectionInner:GetPropertyChangedSignal('AbsoluteSize'):Connect(RecalculateTabSizes)
		
		Library.WindowGlow = WindowGlow
		
		function Library:SetGlowVis(Bool)
			Library.WindowGlow.Visible = Bool
		end
		
		function Window:SetWindowTitle(Title)
			WindowLabel.Text = Title
		end
		
		function Window:Show()
			Outer.Visible = true
			Library.Toggled = true
		end
		
		function Window:Hide()
			Outer.Visible = false
			Library.Toggled = false
		end
		
		function Window:Toggle()
			if Outer.Visible then
				Window:Hide()
			else
				Window:Show()
			end
		end
		
		--[[ ========================================
		    ADD TAB - ESTILO VIZOR
		======================================== ]]
		function Window:AddTab(Name, Icon)
			local Tab = {
				Groupboxes = {},
				Tabboxes = {},
			}
			
			-- Tab button estilo Vizor (sem cantos arredondados)
			local TabButton = Library:Create('TextButton', {
				BackgroundColor3 = Library.MainColor,
				BackgroundTransparency = 0,
				BorderSizePixel = 0,
				Size = _UDim2New(0, 120, 0, 30),
				AutoButtonColor = false,
				Text = '',
				ZIndex = 2,
				Visible = true,
				Parent = TabArea,
			})
			
			_TableInsert(Window.TabButtons, TabButton)
			
			-- Recalcular tamanho das tabs imediatamente
			RecalculateTabSizes()
			
			-- Recalcular novamente após um frame para garantir
			task.spawn(function()
				task.wait()
				RecalculateTabSizes()
			end)
			
			-- Container para ícone e texto
			local TabContent = Library:Create('Frame', {
				BackgroundTransparency = 1,
				Size = _UDim2New(1, 0, 1, 0),
				ZIndex = 3,
				Parent = TabButton,
			})
			
			Library:Create('UIListLayout', {
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				Padding = _UDimNew(0, 6),
				SortOrder = Enum.SortOrder.LayoutOrder,
				Parent = TabContent,
			})
			
			-- Ícone da tab (se fornecido)
			if Icon and Library.Icons then
				local TabIcon = Library.Icons:CreateIcon(Icon, 14, TabContent, false)
				TabIcon.TextColor3 = Library.FontColor
				TabIcon.LayoutOrder = 1
			end
			
			local TabButtonLabel = Library:CreateLabel({
				Size = _UDim2New(0, 0, 1, 0),
				AutomaticSize = Enum.AutomaticSize.X,
				Text = Name,
				ZIndex = 3,
				TextSize = 13,
				Font = Library.Font or Enum.Font.Gotham,
				TextColor3 = Library.FontColor,
				LayoutOrder = 2,
				Parent = TabContent,
			})
			
			-- Indicador de tab ativa (background highlight estilo Vizor)
			local TabIndicator = Library:Create('Frame', {
				BackgroundColor3 = Library.SelectedColor or Library.HoverColor,
				BorderSizePixel = 0,
				Position = _UDim2New(0, 0, 0, 0),
				Size = _UDim2New(1, 0, 1, 0),
				Visible = false,
				ZIndex = 1,
				Parent = TabButton,
			})
			Library:AddToRegistry(TabIndicator, { BackgroundColor3 = 'SelectedColor' })
			
			-- Animações com Spring para hover
			local tabHoverSpring = Library.Spring.new(0)
			local tabHoverConnection = RunService.RenderStepped:Connect(function()
				local alpha = tabHoverSpring.Position
				if not TabIndicator.Visible then
					TabButton.BackgroundColor3 = Color3.new(
						0.117 + alpha * 0.02,
						0.117 + alpha * 0.02,
						0.117 + alpha * 0.02
					)
				end
			end)
			
			TabButton.MouseEnter:Connect(function()
				if not TabIndicator.Visible then
					tabHoverSpring.Target = 1
					tabHoverSpring.Speed = 20
					tabHoverSpring.Damper = 0.7
				end
			end)
			TabButton.MouseLeave:Connect(function()
				tabHoverSpring.Target = 0
			end)
			
			local TabFrame = Library:Create('Frame', {
				Name = 'TabFrame',
				BackgroundTransparency = 1,
				Position = _UDim2New(0, 0, 0, 0),
				Size = _UDim2New(1, 0, 1, 0),
				Visible = false,
				ZIndex = 2,
				Parent = TabContainer,
			})
			Tab.MainFrame = TabFrame
			
			-- Scrolling frames com padding moderno
			local LeftSide = Library:Create('ScrollingFrame', {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Position = _UDim2New(0, 10, 0, 10),
				Size = _UDim2New(0.5, -15, 1, -20),
				CanvasSize = _UDim2New(0, 0, 0, 0),
				BottomImage = '',
				TopImage = '',
				ScrollBarThickness = 2,
				ScrollBarImageColor3 = Library.AccentColor,
				ZIndex = 2,
				Parent = TabFrame,
			})
			
			local RightSide = Library:Create('ScrollingFrame', {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Position = _UDim2New(0.5, 5, 0, 10),
				Size = _UDim2New(0.5, -15, 1, -20),
				CanvasSize = _UDim2New(0, 0, 0, 0),
				BottomImage = '',
				TopImage = '',
				ScrollBarThickness = 2,
				ScrollBarImageColor3 = Library.AccentColor,
				ZIndex = 2,
				Parent = TabFrame,
			})
			
			Library:Create('UIListLayout', {
				Padding = _UDimNew(0, 10),
				FillDirection = Enum.FillDirection.Vertical,
				SortOrder = Enum.SortOrder.LayoutOrder,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				Parent = LeftSide,
			})
			
			Library:Create('UIListLayout', {
				Padding = _UDimNew(0, 10),
				FillDirection = Enum.FillDirection.Vertical,
				SortOrder = Enum.SortOrder.LayoutOrder,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				Parent = RightSide,
			})
			
			for _, Side in next, { LeftSide, RightSide } do
				Side:WaitForChild('UIListLayout'):GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()
					Side.CanvasSize = _UDim2fromOffset(0, Side.UIListLayout.AbsoluteContentSize.Y + 10)
				end)
			end
			
			function Tab:ShowTab()
				for _, T in next, Window.Tabs do
					T:HideTab()
				end
				
				-- Mostrar indicador e estilizar tab ativa
				TabIndicator.Visible = true
				TabButton.BackgroundTransparency = 0.8
				TabButtonLabel.TextColor3 = Library.AccentColor
				TabFrame.Visible = true
			end
			
			function Tab:HideTab()
				-- Esconder indicador
				TabIndicator.Visible = false
				TabButton.BackgroundTransparency = 1
				TabButtonLabel.TextColor3 = Library.FontColor
				TabFrame.Visible = false
			end
			
			function Tab:SetLayoutOrder(Position)
				TabButton.LayoutOrder = Position
				TabListLayout:ApplyLayout()
			end
			
			--[[ ========================================
			    ADD GROUPBOX - ESTILO VIZOR
			======================================== ]]
			function Tab:AddGroupbox(Info)
				local Groupbox = {}
				
				-- Groupbox estilo Vizor (sem cantos arredondados)
				local BoxOuter = Library:Create('Frame', {
					BackgroundColor3 = Library.MainColor,
					BorderSizePixel = 0,
					Size = _UDim2New(1, 0, 0, 0), -- Auto height
					AutomaticSize = Enum.AutomaticSize.Y,
					ZIndex = 2,
					Parent = Info.Side == 1 and LeftSide or RightSide,
				})
				Library:AddToRegistry(BoxOuter, { BackgroundColor3 = 'MainColor' })
				
				local BoxInner = Library:Create('Frame', {
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					Size = _UDim2New(1, 0, 1, 0),
					ZIndex = 4,
					Parent = BoxOuter,
				})
				
				-- Título do groupbox (estilo Vizor - uppercase)
				local GroupboxLabel = Library:CreateLabel({
					Size = _UDim2New(1, -20, 0, 20),
					Position = _UDim2New(0, 10, 0, 8),
					TextColor3 = Library.FontColor,
					TextSize = 12,
					Font = Library.Font or Enum.Font.Gotham,
					Text = string.upper(Info.Name or ""),
					TextXAlignment = Enum.TextXAlignment.Left,
					ZIndex = 5,
					Parent = BoxInner,
				})
				
				-- Separator abaixo do título (estilo Vizor)
				local TitleSeparator = Library:Create('Frame', {
					BackgroundColor3 = Library.SeparatorColor or Library.OutlineColor,
					BorderSizePixel = 0,
					Position = _UDim2New(0, 10, 0, 30),
					Size = _UDim2New(1, -20, 0, 1),
					ZIndex = 5,
					Parent = BoxInner,
				})
				Library:AddToRegistry(TitleSeparator, { BackgroundColor3 = 'SeparatorColor' })
				
				-- Container dos elementos
				local Container = Library:Create('Frame', {
					BackgroundTransparency = 1,
					Position = _UDim2New(0, 10, 0, 38),
					Size = _UDim2New(1, -20, 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y,
					ZIndex = 1,
					Parent = BoxInner,
				})
				
				Library:Create('UIListLayout', {
					FillDirection = Enum.FillDirection.Vertical,
					SortOrder = Enum.SortOrder.LayoutOrder,
					Padding = _UDimNew(0, 8),
					Parent = Container,
				})
				
				Library:Create('UIPadding', {
					PaddingBottom = _UDimNew(0, 10),
					Parent = Container,
				})
				
				function Groupbox:Resize()
					-- Auto-resize handled by AutomaticSize
					local Size = 0
					for _, Element in next, Container:GetChildren() do
						if not Element:IsA('UIListLayout') and not Element:IsA('UIPadding') and Element.Visible then
							Size = Size + Element.Size.Y.Offset + 8
						end
					end
					BoxOuter.Size = _UDim2New(1, 0, 0, 48 + Size)
				end
				
				Groupbox.Container = Container
				setmetatable(Groupbox, BaseGroupbox)
				
				Groupbox:AddBlank(3)
				Groupbox:Resize()
				
				Tab.Groupboxes[Info.Name] = Groupbox
				
				return Groupbox
			end
			
			function Tab:AddLeftGroupbox(Name)
				return Tab:AddGroupbox({ Side = 1, Name = Name })
			end
			
			function Tab:AddRightGroupbox(Name)
				return Tab:AddGroupbox({ Side = 2, Name = Name })
			end
			
			--[[ ========================================
			    ADD TABBOX
			======================================== ]]
			function Tab:AddTabbox(Info)
				local Tabbox = {
					Tabs = {},
				}
				
				local BoxOuter = Library:Create('Frame', {
					BackgroundColor3 = Library.BackgroundColor,
					BorderColor3 = Library.OutlineColor,
					BorderMode = Enum.BorderMode.Inset,
					Size = _UDim2New(1, 0, 0, 509),
					ZIndex = 2,
					Parent = Info.Side == 1 and LeftSide or RightSide,
				})
				
				Library:AddToRegistry(BoxOuter, { BackgroundColor3 = 'BackgroundColor', BorderColor3 = 'OutlineColor' })
				
				local BoxInner = Library:Create('Frame', {
					BackgroundColor3 = Library.BackgroundColor,
					BorderColor3 = _Color3New(0, 0, 0),
					BorderSizePixel = 0,
					Size = _UDim2New(1, -2, 1, -2),
					Position = _UDim2New(0, 1, 0, 1),
					ZIndex = 4,
					Parent = BoxOuter,
				})
				
				Library:AddToRegistry(BoxInner, { BackgroundColor3 = 'BackgroundColor' })
				
				local TabboxTitle = Library:CreateLabel({
					Size = _UDim2New(1, 0, 0, 18),
					Position = _UDim2New(0, 6, 0, 5),
					TextColor3 = Library.AccentColor,
					TextSize = 14,
					Text = Info.Title or "Tabbox",
					TextXAlignment = Enum.TextXAlignment.Left,
					ZIndex = 5,
					Parent = BoxInner,
				})
				
				Library:AddToRegistry(TabboxTitle, { TextColor3 = 'AccentColor' })
				
				local Highlight = Library:Create('Frame', {
					BackgroundColor3 = _Color3FromRGB(255, 255, 255),
					BackgroundTransparency = 0.9,
					BorderSizePixel = 0,
					Position = _UDim2New(0, 4, 0, 28),
					Size = _UDim2New(0.96, 0, 0, 1),
					ZIndex = 10,
					Parent = BoxInner,
				})
				
				local TabboxButtons = Library:Create('Frame', {
					BackgroundTransparency = 1,
					Position = _UDim2New(0, 0, 0, 31),
					Size = _UDim2New(1, 0, 0, 18),
					ZIndex = 5,
					Parent = BoxInner,
				})
				
				Library:Create('UIListLayout', {
					FillDirection = Enum.FillDirection.Horizontal,
					HorizontalAlignment = Enum.HorizontalAlignment.Left,
					SortOrder = Enum.SortOrder.LayoutOrder,
					Parent = TabboxButtons,
				})
				
				function Tabbox:AddTab(Name)
					local InnerTab = {}
					
					local TextSizeX = Library:GetTextBounds(Name, Library.Font, 14)
					
					local Button = Library:Create('Frame', {
						BackgroundColor3 = Library.BackgroundColor,
						BorderColor3 = _Color3New(0, 0, 0),
						BorderSizePixel = 0,
						Size = _UDim2New(0, TextSizeX + 10, 1, 0),
						ZIndex = 6,
						Parent = TabboxButtons,
					})
					
					Library:AddToRegistry(Button, { BackgroundColor3 = 'BackgroundColor' })
					
					local ButtonLabel = Library:CreateLabel({
						Size = _UDim2New(1, 0, 1, 0),
						TextSize = 14,
						Text = Name,
						TextXAlignment = Enum.TextXAlignment.Center,
						ZIndex = 7,
						Parent = Button,
					})
					
					Library:AddToRegistry(ButtonLabel, { TextColor3 = 'FontColorDark' })
					
					local Underline = Library:Create('Frame', {
						BackgroundColor3 = Library.AccentColor,
						BorderSizePixel = 0,
						Position = _UDim2New(0.5, -TextSizeX / 2, 1, -1),
						Size = _UDim2New(0, TextSizeX, 0, 2),
						Visible = false,
						ZIndex = 9,
						Parent = Button,
					})
					
					Library:AddToRegistry(Underline, { BackgroundColor3 = 'AccentColor' })
					
					local Container = Library:Create('Frame', {
						BackgroundTransparency = 1,
						Position = _UDim2New(0, 4, 0, 56),
						Size = _UDim2New(1, -4, 1, -40),
						ZIndex = 1,
						Visible = false,
						Parent = BoxInner,
					})
					
					Library:Create('UIListLayout', {
						FillDirection = Enum.FillDirection.Vertical,
						SortOrder = Enum.SortOrder.LayoutOrder,
						Parent = Container,
					})
					
					function InnerTab:Show()
						for _, T in next, Tabbox.Tabs do
							T:Hide()
						end
						
						Container.Visible = true
						Underline.Visible = true
						ButtonLabel.TextColor3 = Library.FontColor
						Library.RegistryMap[ButtonLabel].Properties.TextColor3 = 'FontColor'
						InnerTab:Resize()
					end
					
					function InnerTab:Hide()
						Container.Visible = false
						Underline.Visible = false
						ButtonLabel.TextColor3 = Library.FontColorDark
						Library.RegistryMap[ButtonLabel].Properties.TextColor3 = 'FontColorDark'
					end
					
					function InnerTab:Resize()
						if not Container.Visible then return end
						
						local Size = 0
						
						for _, Element in next, Container:GetChildren() do
							if not Element:IsA('UIListLayout') and Element.Visible then
								Size = Size + Element.Size.Y.Offset
							end
						end
						
						BoxOuter.Size = _UDim2New(1, 0, 0, 20 + Size + 2 + 40 - 4)
					end
					
					Button.InputBegan:Connect(function(Input)
						if Input.UserInputType == Enum.UserInputType.MouseButton1 and not Library:MouseIsOverOpenedFrame() then
							InnerTab:Show()
							InnerTab:Resize()
						end
					end)
					
					InnerTab.Container = Container
					setmetatable(InnerTab, BaseGroupbox)
					
					InnerTab:AddBlank(3)
					
					_TableInsert(Tabbox.Tabs, InnerTab)
					
					if #Tabbox.Tabs == 1 then
						InnerTab:Show()
					end
					
					return InnerTab
				end
				
				function Tabbox:AddLeftTabbox(Title)
					return Tab:AddTabbox({ Side = 1, Title = Title })
				end
				
				function Tabbox:AddRightTabbox(Title)
					return Tab:AddTabbox({ Side = 2, Title = Title })
				end
				
				Tab.Tabboxes[Info.Title or "Tabbox"] = Tabbox
				
				return Tabbox
			end
			
			function Tab:AddLeftTabbox(Title)
				return Tab:AddTabbox({ Side = 1, Title = Title })
			end
			
			function Tab:AddRightTabbox(Title)
				return Tab:AddTabbox({ Side = 2, Title = Title })
			end
			
			TabButton.InputBegan:Connect(function(Input)
				if Input.UserInputType == Enum.UserInputType.MouseButton1 and not Library:MouseIsOverOpenedFrame() then
					Tab:ShowTab()
				end
			end)
			
			_TableInsert(Window.Tabs, Tab)
			
			if #Window.Tabs == 1 then
				Tab:ShowTab()
			end
			
			return Tab
		end
		
		-- Toggle key handler
		Library:GiveSignal(UserInputService.InputBegan:Connect(function(Input, Processed)
			if Processed then return end
			
			if Input.KeyCode == Library.ToggleKey then
				Window:Toggle()
			end
		end))
		
		if Config.AutoShow then
			Window:Show()
		end
		
		return Window
	end
end

return Window

