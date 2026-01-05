--[[
    BaseAddons - Metatable para elementos com addons (ColorPicker, KeyPicker)
]]

local BaseAddons = {}

function BaseAddons:Init(Library, Toggles, Options, ScreenGui)
	local _Instancenew = Instance.new
	local _UDim2New = UDim2.new
	local _UDim2fromOffset = UDim2.fromOffset
	local _UDimNew = UDim.new
	local _Vector2New = Vector2.new
	local _Color3New = Color3.new
	local _Color3FromRGB = Color3.fromRGB
	local _Color3FromHSV = Color3.fromHSV
	local _Color3ToHSV = Color3.toHSV
	local _TableInsert = table.insert
	local _TableRemove = table.remove
	local _TableConcat = table.concat
	local _MathClamp = math.clamp
	local _MathFloor = math.floor
	local _MathMax = math.max
	local _Type = type
	local _Pcall = pcall
	local _TaskSpawn = task.spawn
	local _ColorSequenceNew = ColorSequence.new
	local _ColorSequenceKeypointNew = ColorSequenceKeypoint.new
	
	local UserInputService = game:GetService("UserInputService")
	local RunService = game:GetService("RunService")
	local Mouse = game:GetService("Players").LocalPlayer:GetMouse()
	local RenderStepped = RunService.RenderStepped
	
	local Funcs = {}
	
	--[[ ========================================
	    COLOR PICKER
	======================================== ]]
	function Funcs:AddColorPicker(Idx, Info)
		local ToggleLabel = self.TextLabel
		
		assert(Info.Default, 'AddColorPicker: Missing default value.')
		
		local ColorPicker = {
			Value = Info.Default,
			Transparency = Info.Transparency or 0,
			Type = 'ColorPicker',
			Title = _Type(Info.Title) == 'string' and Info.Title or 'Color picker',
			Callback = Info.Callback or function(Color) end,
		}
		
		function ColorPicker:SetHSVFromRGB(Color)
			local H, S, V = _Color3ToHSV(Color)
			ColorPicker.Hue = H
			ColorPicker.Sat = S
			ColorPicker.Vib = V
		end
		
		ColorPicker:SetHSVFromRGB(ColorPicker.Value)
		
		local DisplayFrame = Library:Create('Frame', {
			BackgroundColor3 = ColorPicker.Value,
			BorderColor3 = Library:GetDarkerColor(ColorPicker.Value),
			BorderMode = Enum.BorderMode.Inset,
			Size = _UDim2New(0, 18, 0, 14),
			ZIndex = 6,
			Parent = ToggleLabel,
		})
		
		local CheckerFrame = Library:Create('ImageLabel', {
			BorderSizePixel = 0,
			Size = _UDim2New(0, 17, 0, 13),
			ZIndex = 5,
			Image = 'http://www.roblox.com/asset/?id=12977615774',
			Visible = not not Info.Transparency,
			Parent = DisplayFrame,
		})
		
		local PickerFrameOuter = Library:Create('Frame', {
			Name = 'Color',
			BackgroundColor3 = _Color3New(1, 1, 1),
			BorderColor3 = _Color3New(0, 0, 0),
			BorderSizePixel = 0,
			Position = _UDim2fromOffset(DisplayFrame.AbsolutePosition.X, DisplayFrame.AbsolutePosition.Y + 18),
			Size = _UDim2fromOffset(230, Info.Transparency and 271 or 253),
			Visible = false,
			ZIndex = 15,
			Parent = ScreenGui,
		})
		
		DisplayFrame:GetPropertyChangedSignal('AbsolutePosition'):Connect(function()
			PickerFrameOuter.Position = _UDim2fromOffset(DisplayFrame.AbsolutePosition.X, DisplayFrame.AbsolutePosition.Y + 18)
		end)
		
		local PickerFrameInner = Library:Create('Frame', {
			BackgroundColor3 = Library.BackgroundColor,
			BorderColor3 = Library.OutlineColor,
			BorderMode = Enum.BorderMode.Inset,
			Size = _UDim2New(1, 0, 1, 0),
			ZIndex = 16,
			Parent = PickerFrameOuter,
		})
		
		local Highlight = Library:Create('Frame', {
			BackgroundColor3 = Library.AccentColor,
			BorderSizePixel = 0,
			Size = _UDim2New(1, 0, 0, 2),
			ZIndex = 17,
			Parent = PickerFrameInner,
		})
		
		local SatVibMapOuter = Library:Create('Frame', {
			BorderColor3 = _Color3New(0, 0, 0),
			BorderSizePixel = 0,
			Position = _UDim2New(0, 4, 0, 25),
			Size = _UDim2New(0, 200, 0, 200),
			ZIndex = 17,
			Parent = PickerFrameInner,
		})
		
		local SatVibMapInner = Library:Create('Frame', {
			BackgroundColor3 = Library.BackgroundColor,
			BorderColor3 = Library.OutlineColor,
			BorderMode = Enum.BorderMode.Inset,
			Size = _UDim2New(1, 0, 1, 0),
			ZIndex = 18,
			Parent = SatVibMapOuter,
		})
		
		local SatVibMap = Library:Create('ImageLabel', {
			BorderSizePixel = 0,
			Size = _UDim2New(1, 0, 1, 0),
			ZIndex = 18,
			Image = 'rbxassetid://4155801252',
			Parent = SatVibMapInner,
		})
		
		local CursorOuter = Library:Create('ImageLabel', {
			AnchorPoint = _Vector2New(0.5, 0.5),
			Size = _UDim2New(0, 6, 0, 6),
			BackgroundTransparency = 1,
			Image = 'http://www.roblox.com/asset/?id=9619665977',
			ImageColor3 = _Color3New(0, 0, 0),
			ZIndex = 19,
			Parent = SatVibMap,
		})
		
		local CursorInner = Library:Create('ImageLabel', {
			Size = _UDim2New(0, 4, 0, 4),
			Position = _UDim2New(0, 1, 0, 1),
			BackgroundTransparency = 1,
			Image = 'http://www.roblox.com/asset/?id=9619665977',
			ZIndex = 20,
			Parent = CursorOuter,
		})
		
		local HueSelectorOuter = Library:Create('Frame', {
			BorderColor3 = _Color3New(0, 0, 0),
			BorderSizePixel = 0,
			Position = _UDim2New(0, 208, 0, 25),
			Size = _UDim2New(0, 15, 0, 200),
			ZIndex = 17,
			Parent = PickerFrameInner,
		})
		
		local HueSelectorInner = Library:Create('Frame', {
			BackgroundColor3 = _Color3New(1, 1, 1),
			BorderSizePixel = 0,
			Size = _UDim2New(1, 0, 1, 0),
			ZIndex = 18,
			Parent = HueSelectorOuter,
		})
		
		local HueCursor = Library:Create('Frame', {
			BackgroundColor3 = _Color3New(1, 1, 1),
			AnchorPoint = _Vector2New(0, 0.5),
			BorderColor3 = _Color3New(0, 0, 0),
			Size = _UDim2New(1, 0, 0, 1),
			ZIndex = 18,
			Parent = HueSelectorInner,
		})
		
		local HueBoxOuter = Library:Create('Frame', {
			BorderColor3 = _Color3New(0, 0, 0),
			BorderSizePixel = 0,
			Position = _UDim2fromOffset(4, 228),
			Size = _UDim2New(0.5, -6, 0, 20),
			ZIndex = 18,
			Parent = PickerFrameInner,
		})
		
		local HueBoxInner = Library:Create('Frame', {
			BackgroundColor3 = Library.MainColor,
			BorderColor3 = Library.OutlineColor,
			BorderMode = Enum.BorderMode.Inset,
			Size = _UDim2New(1, 0, 1, 0),
			ZIndex = 18,
			Parent = HueBoxOuter,
		})
		
		Library:Create('UIGradient', {
			Color = _ColorSequenceNew({
				_ColorSequenceKeypointNew(0, _Color3New(1, 1, 1)),
				_ColorSequenceKeypointNew(1, _Color3FromRGB(212, 212, 212))
			}),
			Rotation = 90,
			Parent = HueBoxInner,
		})
		
		local HueBox = Library:Create('TextBox', {
			BackgroundTransparency = 1,
			Position = _UDim2New(0, 5, 0, 0),
			Size = _UDim2New(1, -5, 1, 0),
			Font = Library.Font,
			PlaceholderColor3 = _Color3FromRGB(190, 190, 190),
			PlaceholderText = 'Hex color',
			Text = '#FFFFFF',
			TextColor3 = Library.FontColor,
			TextSize = 15,
			ClearTextOnFocus = false,
			TextStrokeTransparency = 1,
			TextXAlignment = Enum.TextXAlignment.Left,
			ZIndex = 20,
			Parent = HueBoxInner,
		})
		
		local DisplayLabel = Library:CreateLabel({
			Size = _UDim2New(1, 0, 0, 14),
			Position = _UDim2fromOffset(5, 5),
			TextXAlignment = Enum.TextXAlignment.Left,
			TextSize = 15,
			Text = ColorPicker.Title,
			TextWrapped = false,
			ZIndex = 16,
			Parent = PickerFrameInner,
		})
		
		Library:AddToRegistry(PickerFrameInner, { BackgroundColor3 = 'BackgroundColor', BorderColor3 = 'OutlineColor' })
		Library:AddToRegistry(Highlight, { BackgroundColor3 = 'AccentColor' })
		Library:AddToRegistry(SatVibMapInner, { BackgroundColor3 = 'BackgroundColor', BorderColor3 = 'OutlineColor' })
		Library:AddToRegistry(HueBoxInner, { BackgroundColor3 = 'MainColor', BorderColor3 = 'OutlineColor' })
		Library:AddToRegistry(HueBox, { TextColor3 = 'FontColor' })
		
		local SequenceTable = {}
		for Hue = 0, 1, 0.1 do
			_TableInsert(SequenceTable, _ColorSequenceKeypointNew(Hue, _Color3FromHSV(Hue, 1, 1)))
		end
		
		local HueSelectorGradient = Library:Create('UIGradient', {
			Color = _ColorSequenceNew(SequenceTable),
			Rotation = 90,
			Parent = HueSelectorInner,
		})
		
		local function ToHex(color)
			return string.format("%02X%02X%02X", _MathFloor(color.R * 255), _MathFloor(color.G * 255), _MathFloor(color.B * 255))
		end
		
		HueBox.FocusLost:Connect(function(enter)
			if enter then
				local success, result = _Pcall(Color3.fromHex, HueBox.Text)
				if success and typeof(result) == 'Color3' then
					ColorPicker.Hue, ColorPicker.Sat, ColorPicker.Vib = _Color3ToHSV(result)
				end
			end
			ColorPicker:Display()
		end)
		
		function ColorPicker:Display()
			ColorPicker.Value = _Color3FromHSV(ColorPicker.Hue, ColorPicker.Sat, ColorPicker.Vib)
			SatVibMap.BackgroundColor3 = _Color3FromHSV(ColorPicker.Hue, 1, 1)
			
			DisplayFrame.BackgroundColor3 = ColorPicker.Value
			DisplayFrame.BackgroundTransparency = ColorPicker.Transparency
			DisplayFrame.BorderColor3 = Library:GetDarkerColor(ColorPicker.Value)
			
			CursorOuter.Position = _UDim2New(ColorPicker.Sat, 0, 1 - ColorPicker.Vib, 0)
			HueCursor.Position = _UDim2New(0, 0, ColorPicker.Hue, 0)
			
			HueBox.Text = '#' .. ToHex(ColorPicker.Value)
			
			Library:SafeCallback(ColorPicker.Callback, ColorPicker.Value)
			Library:SafeCallback(ColorPicker.Changed, ColorPicker.Value)
		end
		
		function ColorPicker:OnChanged(Func)
			ColorPicker.Changed = Func
			Func(ColorPicker.Value)
		end
		
		function ColorPicker:Show()
			for Frame, Val in next, Library.OpenedFrames do
				if Frame.Name == 'Color' then
					Frame.Visible = false
					Library.OpenedFrames[Frame] = nil
				end
			end
			
			PickerFrameOuter.Visible = true
			Library.OpenedFrames[PickerFrameOuter] = true
		end
		
		function ColorPicker:Hide()
			PickerFrameOuter.Visible = false
			Library.OpenedFrames[PickerFrameOuter] = nil
		end
		
		function ColorPicker:SetValue(HSV, Transparency)
			local Color = _Color3FromHSV(HSV[1], HSV[2], HSV[3])
			ColorPicker.Transparency = Transparency or 0
			ColorPicker:SetHSVFromRGB(Color)
			ColorPicker:Display()
		end
		
		function ColorPicker:SetValueRGB(Color, Transparency)
			ColorPicker.Transparency = Transparency or 0
			ColorPicker:SetHSVFromRGB(Color)
			ColorPicker:Display()
		end
		
		SatVibMap.InputBegan:Connect(function(Input)
			if Input.UserInputType == Enum.UserInputType.MouseButton1 then
				while UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
					local MinX = SatVibMap.AbsolutePosition.X
					local MaxX = MinX + SatVibMap.AbsoluteSize.X
					local MouseX = _MathClamp(Mouse.X, MinX, MaxX)
					
					local MinY = SatVibMap.AbsolutePosition.Y
					local MaxY = MinY + SatVibMap.AbsoluteSize.Y
					local MouseY = _MathClamp(Mouse.Y, MinY, MaxY)
					
					ColorPicker.Sat = (MouseX - MinX) / (MaxX - MinX)
					ColorPicker.Vib = 1 - ((MouseY - MinY) / (MaxY - MinY))
					ColorPicker:Display()
					
					RenderStepped:Wait()
				end
				Library:AttemptSave()
			end
		end)
		
		HueSelectorInner.InputBegan:Connect(function(Input)
			if Input.UserInputType == Enum.UserInputType.MouseButton1 then
				while UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
					local MinY = HueSelectorInner.AbsolutePosition.Y
					local MaxY = MinY + HueSelectorInner.AbsoluteSize.Y
					local MouseY = _MathClamp(Mouse.Y, MinY, MaxY)
					
					ColorPicker.Hue = ((MouseY - MinY) / (MaxY - MinY))
					ColorPicker:Display()
					
					RenderStepped:Wait()
				end
				Library:AttemptSave()
			end
		end)
		
		DisplayFrame.InputBegan:Connect(function(Input)
			if Input.UserInputType == Enum.UserInputType.MouseButton1 and not Library:MouseIsOverOpenedFrame() then
				if PickerFrameOuter.Visible then
					ColorPicker:Hide()
				else
					ColorPicker:Show()
				end
			end
		end)
		
		Library:GiveSignal(UserInputService.InputBegan:Connect(function(Input)
			if Input.UserInputType == Enum.UserInputType.MouseButton1 then
				local AbsPos, AbsSize = PickerFrameOuter.AbsolutePosition, PickerFrameOuter.AbsoluteSize
				
				if Mouse.X < AbsPos.X or Mouse.X > AbsPos.X + AbsSize.X
					or Mouse.Y < (AbsPos.Y - 20 - 1) or Mouse.Y > AbsPos.Y + AbsSize.Y then
					ColorPicker:Hide()
				end
			end
		end))
		
		ColorPicker:Display()
		
		Options[Idx] = ColorPicker
		_TableInsert(self.Addons, ColorPicker)
		
		return ColorPicker
	end
	
	--[[ ========================================
	    KEY PICKER
	======================================== ]]
	function Funcs:AddKeyPicker(Idx, Info)
		local ToggleLabel = self.TextLabel
		
		assert(Info.Default, 'AddKeyPicker: Missing default value.')
		
		local KeyPicker = {
			Value = Info.Default,
			Toggled = false,
			Mode = Info.Mode or 'Toggle',
			Type = 'KeyPicker',
			Callback = Info.Callback or function(Value) end,
			ChangedCallback = Info.ChangedCallback or function(New) end,
			SyncToggleState = Info.SyncToggleState or false,
		}
		
		local PickOuter = Library:Create('Frame', {
			BackgroundColor3 = _Color3New(0, 0, 0),
			BorderColor3 = _Color3New(0, 0, 0),
			BorderSizePixel = 0,
			Size = _UDim2New(0, 32, 0, 15),
			ZIndex = 6,
			Parent = ToggleLabel,
		})
		
		local PickInner = Library:Create('Frame', {
			BackgroundColor3 = Library.BackgroundColor,
			BorderColor3 = Library.OutlineColor,
			BorderMode = Enum.BorderMode.Inset,
			Size = _UDim2New(1, 0, 1, 0),
			ZIndex = 7,
			Parent = PickOuter,
		})
		
		Library:AddToRegistry(PickInner, {
			BackgroundColor3 = 'BackgroundColor',
			BorderColor3 = 'OutlineColor',
		})
		
		local DisplayLabel = Library:CreateLabel({
			Size = _UDim2New(1, 0, 1, 0),
			TextSize = 14,
			Text = Info.Default,
			TextWrapped = true,
			ZIndex = 8,
			Parent = PickInner,
		})
		
		local ModeSelectOuter = Library:Create('Frame', {
			BorderColor3 = _Color3New(0, 0, 0),
			Position = _UDim2fromOffset(PickOuter.AbsolutePosition.X, PickOuter.AbsolutePosition.Y + 18),
			Size = _UDim2New(0, 60, 0, 50),
			Visible = false,
			ZIndex = 14,
			Parent = ScreenGui,
		})
		
		PickOuter:GetPropertyChangedSignal('AbsolutePosition'):Connect(function()
			ModeSelectOuter.Position = _UDim2fromOffset(PickOuter.AbsolutePosition.X, PickOuter.AbsolutePosition.Y + 18)
		end)
		
		local ModeSelectInner = Library:Create('Frame', {
			BackgroundColor3 = Library.BackgroundColor,
			BorderColor3 = Library.OutlineColor,
			BorderMode = Enum.BorderMode.Inset,
			Size = _UDim2New(1, 0, 1, 0),
			ZIndex = 15,
			Parent = ModeSelectOuter,
		})
		
		Library:AddToRegistry(ModeSelectInner, {
			BackgroundColor3 = 'BackgroundColor',
			BorderColor3 = 'OutlineColor',
		})
		
		Library:Create('UIListLayout', {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Parent = ModeSelectInner,
		})
		
		local Modes = Info.Modes or { 'Always', 'Toggle', 'Hold' }
		
		for Idx, Mode in next, Modes do
			local ModeButton = Library:CreateLabel({
				Size = _UDim2New(1, 0, 0, 15),
				TextSize = 14,
				Text = Mode,
				ZIndex = 16,
				Parent = ModeSelectInner,
			})
			
			ModeButton.InputBegan:Connect(function(Input)
				if Input.UserInputType == Enum.UserInputType.MouseButton1 then
					KeyPicker.Mode = Mode
					ModeSelectOuter.Visible = false
					Library.OpenedFrames[ModeSelectOuter] = nil
					KeyPicker:Update()
				end
			end)
			
			Library:OnHighlight(ModeButton, ModeButton,
				{ TextColor3 = 'AccentColor' },
				{ TextColor3 = 'FontColor' }
			)
		end
		
		function KeyPicker:Update()
			if KeyPicker.Mode == 'Always' then
				KeyPicker.Toggled = true
			elseif KeyPicker.Mode == 'Toggle' then
				-- Keep current state
			elseif KeyPicker.Mode == 'Hold' then
				KeyPicker.Toggled = UserInputService:IsKeyDown(Enum.KeyCode[KeyPicker.Value]) or 
					(Enum.UserInputType[KeyPicker.Value] and UserInputService:IsMouseButtonPressed(Enum.UserInputType[KeyPicker.Value]))
			end
			
			Library:SafeCallback(KeyPicker.Callback, KeyPicker.Toggled)
			Library:SafeCallback(KeyPicker.Changed, KeyPicker.Toggled)
		end
		
		function KeyPicker:OnChanged(Func)
			KeyPicker.Changed = Func
			Func(KeyPicker.Toggled)
		end
		
		function KeyPicker:OnClick(Func)
			KeyPicker.Clicked = Func
		end
		
		function KeyPicker:SetValue(Data)
			if _Type(Data) == 'table' then
				KeyPicker.Value = Data[1]
				KeyPicker.Mode = Data[2]
			else
				KeyPicker.Value = Data
			end
			DisplayLabel.Text = KeyPicker.Value
		end
		
		function KeyPicker:GetState()
			return KeyPicker.Toggled
		end
		
		local Picking = false
		
		PickOuter.InputBegan:Connect(function(Input)
			if Input.UserInputType == Enum.UserInputType.MouseButton1 and not Library:MouseIsOverOpenedFrame() then
				Picking = true
				DisplayLabel.Text = '...'
				
				Library:GiveSignal(UserInputService.InputBegan:Once(function(Input)
					if Input.UserInputType == Enum.UserInputType.Keyboard then
						KeyPicker.Value = Input.KeyCode.Name
					elseif Input.UserInputType == Enum.UserInputType.MouseButton1 then
						KeyPicker.Value = 'MouseButton1'
					elseif Input.UserInputType == Enum.UserInputType.MouseButton2 then
						KeyPicker.Value = 'MouseButton2'
					end
					
					DisplayLabel.Text = KeyPicker.Value
					Picking = false
					
					Library:SafeCallback(KeyPicker.ChangedCallback, KeyPicker.Value)
					Library:AttemptSave()
				end))
			elseif Input.UserInputType == Enum.UserInputType.MouseButton2 and not Library:MouseIsOverOpenedFrame() then
				ModeSelectOuter.Visible = not ModeSelectOuter.Visible
				if ModeSelectOuter.Visible then
					Library.OpenedFrames[ModeSelectOuter] = true
				else
					Library.OpenedFrames[ModeSelectOuter] = nil
				end
			end
		end)
		
		Library:GiveSignal(UserInputService.InputBegan:Connect(function(Input, Processed)
			if Processed then return end
			if Picking then return end
			
			local Key = nil
			if Input.UserInputType == Enum.UserInputType.Keyboard then
				Key = Input.KeyCode.Name
			elseif Input.UserInputType == Enum.UserInputType.MouseButton1 then
				Key = 'MouseButton1'
			elseif Input.UserInputType == Enum.UserInputType.MouseButton2 then
				Key = 'MouseButton2'
			end
			
			if Key == KeyPicker.Value then
				if KeyPicker.Mode == 'Toggle' then
					KeyPicker.Toggled = not KeyPicker.Toggled
				elseif KeyPicker.Mode == 'Hold' then
					KeyPicker.Toggled = true
				end
				
				KeyPicker:Update()
				Library:SafeCallback(KeyPicker.Clicked)
			end
		end))
		
		Library:GiveSignal(UserInputService.InputEnded:Connect(function(Input)
			local Key = nil
			if Input.UserInputType == Enum.UserInputType.Keyboard then
				Key = Input.KeyCode.Name
			elseif Input.UserInputType == Enum.UserInputType.MouseButton1 then
				Key = 'MouseButton1'
			elseif Input.UserInputType == Enum.UserInputType.MouseButton2 then
				Key = 'MouseButton2'
			end
			
			if Key == KeyPicker.Value then
				if KeyPicker.Mode == 'Hold' then
					KeyPicker.Toggled = false
					KeyPicker:Update()
				end
			end
		end))
		
		Options[Idx] = KeyPicker
		_TableInsert(self.Addons, KeyPicker)
		
		return KeyPicker
	end
	
	return Funcs
end

return BaseAddons

