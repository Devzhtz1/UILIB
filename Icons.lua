--[[
    Sistema de Ícones - Estilo FontAwesome/Rayfield
    Suporta ícones via ImageLabel ou TextLabel (FontAwesome)
]]

local Icons = {}

-- Ícones via ImageLabel (rbxassetid)
Icons.Images = {
    -- Navigation
    Target = "rbxassetid://6034818372",
    Eye = "rbxassetid://6034818372",
    Person = "rbxassetid://6034818372",
    Globe = "rbxassetid://6034818372",
    Gear = "rbxassetid://6034818372",
    Document = "rbxassetid://6034818372",
    Mouse = "rbxassetid://6034818372",
    Percentage = "rbxassetid://6034818372",
    
    -- Actions
    Plus = "rbxassetid://6034818372",
    Minus = "rbxassetid://6034818372",
    Settings = "rbxassetid://6034818372",
    ArrowUp = "rbxassetid://6034818372",
    ArrowDown = "rbxassetid://6034818372",
    ArrowLeft = "rbxassetid://6034818372",
    ArrowRight = "rbxassetid://6034818372",
    Check = "rbxassetid://6034818372",
    X = "rbxassetid://6034818372",
    
    -- Common
    Info = "rbxassetid://6034818372",
    Warning = "rbxassetid://6034818372",
    Error = "rbxassetid://6034818372",
    Success = "rbxassetid://6034818372",
}

-- Ícones via Font (FontAwesome style)
-- Usa uma fonte customizada ou símbolos Unicode
Icons.Font = {
    -- Navigation
    Target = "●",
    Eye = "👁",
    Person = "👤",
    Globe = "🌐",
    Gear = "⚙",
    Document = "📄",
    Mouse = "🖱",
    Percentage = "%",
    
    -- Actions  
    Plus = "+",
    Minus = "-",
    Settings = "⚙",
    ArrowUp = "▲",
    ArrowDown = "▼",
    ArrowLeft = "◄",
    ArrowRight = "►",
    Check = "✓",
    X = "✕",
    
    -- Common
    Info = "ℹ",
    Warning = "⚠",
    Error = "✕",
    Success = "✓",
}

-- Função para criar ícone
function Icons:CreateIcon(IconName, Size, Parent, UseImage)
    local iconType = UseImage and "ImageLabel" or "TextLabel"
    
    if UseImage then
        local icon = Instance.new("ImageLabel")
        icon.Image = self.Images[IconName] or self.Images.Gear
        icon.BackgroundTransparency = 1
        icon.Size = UDim2.new(0, Size or 16, 0, Size or 16)
        icon.BorderSizePixel = 0
        icon.ImageColor3 = Color3.new(1, 1, 1)
        if Parent then icon.Parent = Parent end
        return icon
    else
        local icon = Instance.new("TextLabel")
        icon.Text = self.Font[IconName] or self.Font.Gear
        icon.BackgroundTransparency = 1
        icon.Size = UDim2.new(0, Size or 16, 0, Size or 16)
        icon.BorderSizePixel = 0
        icon.TextColor3 = Color3.new(1, 1, 1)
        icon.TextSize = Size or 16
        icon.Font = Enum.Font.GothamBold
        icon.TextXAlignment = Enum.TextXAlignment.Center
        icon.TextYAlignment = Enum.TextYAlignment.Center
        if Parent then icon.Parent = Parent end
        return icon
    end
end

return Icons

