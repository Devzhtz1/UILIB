--[[
    ESP Module - Sistema de ESP/Overlays para a Aurora UI Library
    Suporta: Box ESP, Name ESP, Health Bar, Tracers, Distance, Chams
]]

local ESP = {}
ESP.__index = ESP

-- Serviços
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- Configurações padrão
ESP.Enabled = false
ESP.TeamCheck = false
ESP.TeamColor = false
ESP.BoxEnabled = true
ESP.NameEnabled = true
ESP.HealthEnabled = true
ESP.TracerEnabled = false
ESP.DistanceEnabled = true
ESP.ChamsEnabled = false

-- Cores padrão
ESP.BoxColor = Color3.fromRGB(255, 255, 255)
ESP.NameColor = Color3.fromRGB(255, 255, 255)
ESP.HealthColor = Color3.fromRGB(0, 255, 0)
ESP.TracerColor = Color3.fromRGB(255, 255, 255)
ESP.ChamsColor = Color3.fromRGB(255, 0, 255)
ESP.ChamsOutlineColor = Color3.fromRGB(0, 0, 0)

-- Configurações
ESP.MaxDistance = 1000
ESP.TextSize = 14
ESP.BoxThickness = 1
ESP.TracerThickness = 1
ESP.TracerOrigin = "Bottom" -- "Bottom", "Center", "Mouse"

-- Storage
ESP.Objects = {}
ESP.Connections = {}

--[[ ========================================
    FUNÇÕES UTILITÁRIAS
======================================== ]]
local function WorldToScreen(position)
	local screenPos, onScreen = Camera:WorldToViewportPoint(position)
	return Vector2.new(screenPos.X, screenPos.Y), onScreen, screenPos.Z
end

local function GetBoundingBox(character)
	local rootPart = character:FindFirstChild("HumanoidRootPart")
	if not rootPart then return nil end
	
	local humanoid = character:FindFirstChildOfClass("Humanoid")
	if not humanoid then return nil end
	
	local pos, onScreen, depth = WorldToScreen(rootPart.Position)
	if not onScreen or depth < 0 then return nil end
	
	local scaleFactor = 1 / (depth * math.tan(math.rad(Camera.FieldOfView / 2)) * 2) * 1000
	local width = 4.5 * scaleFactor
	local height = 6 * scaleFactor
	
	return {
		Position = pos,
		Size = Vector2.new(width, height),
		OnScreen = onScreen,
		Depth = depth,
		Humanoid = humanoid,
	}
end

local function IsTeammate(player)
	if not ESP.TeamCheck then return false end
	if not LocalPlayer.Team then return false end
	return player.Team == LocalPlayer.Team
end

local function GetTeamColor(player)
	if player.Team then
		return player.TeamColor.Color
	end
	return ESP.BoxColor
end

--[[ ========================================
    CRIAÇÃO DE OBJETOS ESP
======================================== ]]
function ESP:CreateESPObject(player)
	if player == LocalPlayer then return end
	
	local espObject = {
		Player = player,
		Drawings = {},
	}
	
	-- Box (4 linhas)
	espObject.Drawings.BoxTop = Drawing.new("Line")
	espObject.Drawings.BoxBottom = Drawing.new("Line")
	espObject.Drawings.BoxLeft = Drawing.new("Line")
	espObject.Drawings.BoxRight = Drawing.new("Line")
	
	-- Box outline
	espObject.Drawings.BoxTopOutline = Drawing.new("Line")
	espObject.Drawings.BoxBottomOutline = Drawing.new("Line")
	espObject.Drawings.BoxLeftOutline = Drawing.new("Line")
	espObject.Drawings.BoxRightOutline = Drawing.new("Line")
	
	-- Nome
	espObject.Drawings.Name = Drawing.new("Text")
	espObject.Drawings.Name.Center = true
	espObject.Drawings.Name.Outline = true
	espObject.Drawings.Name.Font = 2
	
	-- Distância
	espObject.Drawings.Distance = Drawing.new("Text")
	espObject.Drawings.Distance.Center = true
	espObject.Drawings.Distance.Outline = true
	espObject.Drawings.Distance.Font = 2
	
	-- Health Bar (background + fill)
	espObject.Drawings.HealthBarBG = Drawing.new("Line")
	espObject.Drawings.HealthBar = Drawing.new("Line")
	
	-- Tracer
	espObject.Drawings.Tracer = Drawing.new("Line")
	espObject.Drawings.TracerOutline = Drawing.new("Line")
	
	-- Chams (Highlight)
	espObject.Highlight = nil
	
	ESP.Objects[player] = espObject
	
	return espObject
end

function ESP:RemoveESPObject(player)
	local espObject = ESP.Objects[player]
	if not espObject then return end
	
	for _, drawing in pairs(espObject.Drawings) do
		drawing:Remove()
	end
	
	if espObject.Highlight then
		espObject.Highlight:Destroy()
	end
	
	ESP.Objects[player] = nil
end

--[[ ========================================
    ATUALIZAÇÃO DOS OBJETOS ESP
======================================== ]]
function ESP:UpdateESPObject(espObject)
	local player = espObject.Player
	local character = player.Character
	
	-- Esconder tudo se não estiver válido
	local function hideAll()
		for _, drawing in pairs(espObject.Drawings) do
			drawing.Visible = false
		end
		if espObject.Highlight then
			espObject.Highlight.Enabled = false
		end
	end
	
	if not ESP.Enabled then
		hideAll()
		return
	end
	
	if not character then
		hideAll()
		return
	end
	
	if IsTeammate(player) then
		hideAll()
		return
	end
	
	local rootPart = character:FindFirstChild("HumanoidRootPart")
	local head = character:FindFirstChild("Head")
	local humanoid = character:FindFirstChildOfClass("Humanoid")
	
	if not rootPart or not head or not humanoid then
		hideAll()
		return
	end
	
	if humanoid.Health <= 0 then
		hideAll()
		return
	end
	
	local distance = (rootPart.Position - Camera.CFrame.Position).Magnitude
	if distance > ESP.MaxDistance then
		hideAll()
		return
	end
	
	local box = GetBoundingBox(character)
	if not box or not box.OnScreen then
		hideAll()
		return
	end
	
	local color = ESP.TeamColor and GetTeamColor(player) or ESP.BoxColor
	
	-- Posições do box
	local topLeft = Vector2.new(box.Position.X - box.Size.X / 2, box.Position.Y - box.Size.Y / 2)
	local topRight = Vector2.new(box.Position.X + box.Size.X / 2, box.Position.Y - box.Size.Y / 2)
	local bottomLeft = Vector2.new(box.Position.X - box.Size.X / 2, box.Position.Y + box.Size.Y / 2)
	local bottomRight = Vector2.new(box.Position.X + box.Size.X / 2, box.Position.Y + box.Size.Y / 2)
	
	-- BOX
	if ESP.BoxEnabled then
		-- Outline
		espObject.Drawings.BoxTopOutline.From = topLeft
		espObject.Drawings.BoxTopOutline.To = topRight
		espObject.Drawings.BoxTopOutline.Color = Color3.new(0, 0, 0)
		espObject.Drawings.BoxTopOutline.Thickness = ESP.BoxThickness + 2
		espObject.Drawings.BoxTopOutline.Visible = true
		
		espObject.Drawings.BoxBottomOutline.From = bottomLeft
		espObject.Drawings.BoxBottomOutline.To = bottomRight
		espObject.Drawings.BoxBottomOutline.Color = Color3.new(0, 0, 0)
		espObject.Drawings.BoxBottomOutline.Thickness = ESP.BoxThickness + 2
		espObject.Drawings.BoxBottomOutline.Visible = true
		
		espObject.Drawings.BoxLeftOutline.From = topLeft
		espObject.Drawings.BoxLeftOutline.To = bottomLeft
		espObject.Drawings.BoxLeftOutline.Color = Color3.new(0, 0, 0)
		espObject.Drawings.BoxLeftOutline.Thickness = ESP.BoxThickness + 2
		espObject.Drawings.BoxLeftOutline.Visible = true
		
		espObject.Drawings.BoxRightOutline.From = topRight
		espObject.Drawings.BoxRightOutline.To = bottomRight
		espObject.Drawings.BoxRightOutline.Color = Color3.new(0, 0, 0)
		espObject.Drawings.BoxRightOutline.Thickness = ESP.BoxThickness + 2
		espObject.Drawings.BoxRightOutline.Visible = true
		
		-- Main box
		espObject.Drawings.BoxTop.From = topLeft
		espObject.Drawings.BoxTop.To = topRight
		espObject.Drawings.BoxTop.Color = color
		espObject.Drawings.BoxTop.Thickness = ESP.BoxThickness
		espObject.Drawings.BoxTop.Visible = true
		
		espObject.Drawings.BoxBottom.From = bottomLeft
		espObject.Drawings.BoxBottom.To = bottomRight
		espObject.Drawings.BoxBottom.Color = color
		espObject.Drawings.BoxBottom.Thickness = ESP.BoxThickness
		espObject.Drawings.BoxBottom.Visible = true
		
		espObject.Drawings.BoxLeft.From = topLeft
		espObject.Drawings.BoxLeft.To = bottomLeft
		espObject.Drawings.BoxLeft.Color = color
		espObject.Drawings.BoxLeft.Thickness = ESP.BoxThickness
		espObject.Drawings.BoxLeft.Visible = true
		
		espObject.Drawings.BoxRight.From = topRight
		espObject.Drawings.BoxRight.To = bottomRight
		espObject.Drawings.BoxRight.Color = color
		espObject.Drawings.BoxRight.Thickness = ESP.BoxThickness
		espObject.Drawings.BoxRight.Visible = true
	else
		espObject.Drawings.BoxTop.Visible = false
		espObject.Drawings.BoxBottom.Visible = false
		espObject.Drawings.BoxLeft.Visible = false
		espObject.Drawings.BoxRight.Visible = false
		espObject.Drawings.BoxTopOutline.Visible = false
		espObject.Drawings.BoxBottomOutline.Visible = false
		espObject.Drawings.BoxLeftOutline.Visible = false
		espObject.Drawings.BoxRightOutline.Visible = false
	end
	
	-- NAME
	if ESP.NameEnabled then
		espObject.Drawings.Name.Text = player.DisplayName
		espObject.Drawings.Name.Size = ESP.TextSize
		espObject.Drawings.Name.Position = Vector2.new(box.Position.X, topLeft.Y - ESP.TextSize - 2)
		espObject.Drawings.Name.Color = ESP.TeamColor and GetTeamColor(player) or ESP.NameColor
		espObject.Drawings.Name.Visible = true
	else
		espObject.Drawings.Name.Visible = false
	end
	
	-- DISTANCE
	if ESP.DistanceEnabled then
		espObject.Drawings.Distance.Text = string.format("[%dm]", math.floor(distance))
		espObject.Drawings.Distance.Size = ESP.TextSize - 2
		espObject.Drawings.Distance.Position = Vector2.new(box.Position.X, bottomLeft.Y + 2)
		espObject.Drawings.Distance.Color = Color3.fromRGB(200, 200, 200)
		espObject.Drawings.Distance.Visible = true
	else
		espObject.Drawings.Distance.Visible = false
	end
	
	-- HEALTH BAR
	if ESP.HealthEnabled then
		local healthPercent = humanoid.Health / humanoid.MaxHealth
		local barHeight = box.Size.Y
		local barX = topLeft.X - 5
		
		-- Background
		espObject.Drawings.HealthBarBG.From = Vector2.new(barX, topLeft.Y)
		espObject.Drawings.HealthBarBG.To = Vector2.new(barX, bottomLeft.Y)
		espObject.Drawings.HealthBarBG.Color = Color3.new(0, 0, 0)
		espObject.Drawings.HealthBarBG.Thickness = 4
		espObject.Drawings.HealthBarBG.Visible = true
		
		-- Health
		local healthBarBottom = topLeft.Y + barHeight * (1 - healthPercent)
		espObject.Drawings.HealthBar.From = Vector2.new(barX, bottomLeft.Y)
		espObject.Drawings.HealthBar.To = Vector2.new(barX, healthBarBottom)
		
		-- Cor baseada na saúde
		local healthColor
		if healthPercent > 0.5 then
			healthColor = Color3.fromRGB(0, 255, 0)
		elseif healthPercent > 0.25 then
			healthColor = Color3.fromRGB(255, 255, 0)
		else
			healthColor = Color3.fromRGB(255, 0, 0)
		end
		
		espObject.Drawings.HealthBar.Color = healthColor
		espObject.Drawings.HealthBar.Thickness = 2
		espObject.Drawings.HealthBar.Visible = true
	else
		espObject.Drawings.HealthBarBG.Visible = false
		espObject.Drawings.HealthBar.Visible = false
	end
	
	-- TRACER
	if ESP.TracerEnabled then
		local viewport = Camera.ViewportSize
		local startPos
		
		if ESP.TracerOrigin == "Bottom" then
			startPos = Vector2.new(viewport.X / 2, viewport.Y)
		elseif ESP.TracerOrigin == "Center" then
			startPos = Vector2.new(viewport.X / 2, viewport.Y / 2)
		elseif ESP.TracerOrigin == "Mouse" then
			local mouse = game:GetService("Players").LocalPlayer:GetMouse()
			startPos = Vector2.new(mouse.X, mouse.Y)
		else
			startPos = Vector2.new(viewport.X / 2, viewport.Y)
		end
		
		-- Outline
		espObject.Drawings.TracerOutline.From = startPos
		espObject.Drawings.TracerOutline.To = Vector2.new(box.Position.X, bottomLeft.Y)
		espObject.Drawings.TracerOutline.Color = Color3.new(0, 0, 0)
		espObject.Drawings.TracerOutline.Thickness = ESP.TracerThickness + 2
		espObject.Drawings.TracerOutline.Visible = true
		
		-- Main
		espObject.Drawings.Tracer.From = startPos
		espObject.Drawings.Tracer.To = Vector2.new(box.Position.X, bottomLeft.Y)
		espObject.Drawings.Tracer.Color = ESP.TeamColor and GetTeamColor(player) or ESP.TracerColor
		espObject.Drawings.Tracer.Thickness = ESP.TracerThickness
		espObject.Drawings.Tracer.Visible = true
	else
		espObject.Drawings.Tracer.Visible = false
		espObject.Drawings.TracerOutline.Visible = false
	end
	
	-- CHAMS
	if ESP.ChamsEnabled then
		if not espObject.Highlight then
			local highlight = Instance.new("Highlight")
			highlight.FillColor = ESP.ChamsColor
			highlight.OutlineColor = ESP.ChamsOutlineColor
			highlight.FillTransparency = 0.5
			highlight.OutlineTransparency = 0
			highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
			highlight.Adornee = character
			highlight.Parent = character
			espObject.Highlight = highlight
		else
			espObject.Highlight.FillColor = ESP.ChamsColor
			espObject.Highlight.OutlineColor = ESP.ChamsOutlineColor
			espObject.Highlight.Enabled = true
			espObject.Highlight.Adornee = character
		end
	else
		if espObject.Highlight then
			espObject.Highlight.Enabled = false
		end
	end
end

--[[ ========================================
    LOOP PRINCIPAL
======================================== ]]
function ESP:Start()
	-- Criar ESP para jogadores existentes
	for _, player in ipairs(Players:GetPlayers()) do
		ESP:CreateESPObject(player)
	end
	
	-- Conexões
	table.insert(ESP.Connections, Players.PlayerAdded:Connect(function(player)
		ESP:CreateESPObject(player)
	end))
	
	table.insert(ESP.Connections, Players.PlayerRemoving:Connect(function(player)
		ESP:RemoveESPObject(player)
	end))
	
	-- Loop de atualização
	table.insert(ESP.Connections, RunService.RenderStepped:Connect(function()
		for player, espObject in pairs(ESP.Objects) do
			ESP:UpdateESPObject(espObject)
		end
	end))
end

function ESP:Stop()
	-- Desconectar tudo
	for _, connection in ipairs(ESP.Connections) do
		connection:Disconnect()
	end
	ESP.Connections = {}
	
	-- Remover todos os objetos ESP
	for player, _ in pairs(ESP.Objects) do
		ESP:RemoveESPObject(player)
	end
end

function ESP:Toggle(enabled)
	ESP.Enabled = enabled
	if enabled then
		ESP:Start()
	else
		-- Apenas esconder, não parar completamente
		for _, espObject in pairs(ESP.Objects) do
			for _, drawing in pairs(espObject.Drawings) do
				drawing.Visible = false
			end
			if espObject.Highlight then
				espObject.Highlight.Enabled = false
			end
		end
	end
end

return ESP





