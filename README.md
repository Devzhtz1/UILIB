# 🌟 Aurora UI Library

<div align="center">

![Version](https://img.shields.io/badge/Version-1.0.0-blue?style=for-the-badge)
![Lua](https://img.shields.io/badge/Lua-5.1+-purple?style=for-the-badge&logo=lua)
![Platform](https://img.shields.io/badge/Platform-Roblox-red?style=for-the-badge&logo=roblox)
![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)

**Uma biblioteca de UI moderna e completa para Roblox**

[Features](#-features) • [Instalação](#-instalação) • [Uso](#-uso-rápido) • [Documentação](#-documentação) • [Temas](#-temas)

<img src="https://i.imgur.com/placeholder.png" alt="Preview" width="600">

</div>

---

## ✨ Features

| Componente | Descrição |
|------------|-----------|
| **Window** | Janela arrastável com glow effect |
| **Tab** | Sistema de abas |
| **GroupBox** | Grupos de elementos |
| **Tabbox** | Grupos com sub-abas |
| **Toggle** | Checkbox com modo Risky |
| **Slider** | Controle deslizante |
| **Button** | Botões simples e com confirmação |
| **Dropdown** | Menu (single/multi-select) |
| **Input** | Campo de texto |
| **ColorPicker** | Seletor de cores HEX/RGB |
| **KeyPicker** | Seletor de teclas |
| **DependencyBox** | Elementos condicionais |
| **ESP** | Sistema completo de ESP/Overlay |

### 🎯 8 Temas Predefinidos

| Tema | Cor |
|------|-----|
| 🟠 Aurora | Laranja (padrão) |
| 🔵 Ocean | Azul |
| 🟣 Midnight | Roxo |
| 🟢 Emerald | Verde |
| 🌸 Rose | Rosa |
| 🔴 Crimson | Vermelho |
| 💜 Cyberpunk | Neon |
| ⚪ Light | Claro |

---

## 📦 Instalação

### Via Loadstring (Executors)
```lua
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Devzhtz1/UILIB/main/loader.lua"))()
```

### Via Download
1. Baixe todos os arquivos
2. Coloque em uma pasta no Roblox Studio
3. Use `require(path.to.AuroraUILib)`

---

## 🚀 Uso Rápido

```lua
-- Carregar biblioteca
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Devzhtz1/UILIB/main/loader.lua"))()

-- Criar janela
local Window = Library:CreateWindow({
    Title = "Meu Script",
    Center = true,
    AutoShow = true,
})

-- Criar aba
local Tab = Window:AddTab("Main")

-- Criar grupo
local Group = Tab:AddLeftGroupbox("Options")

-- Adicionar toggle
Group:AddToggle("MyToggle", {
    Text = "Enable Feature",
    Default = false,
    Callback = function(Value)
        print("Toggle:", Value)
    end
})

-- Adicionar slider
Group:AddSlider("Speed", {
    Text = "Walk Speed",
    Default = 16,
    Min = 0,
    Max = 100,
    Rounding = 0,
    Callback = function(Value)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
    end
})

-- Adicionar botão
Group:AddButton({
    Text = "Click Me",
    Func = function()
        Library:Notify("Clicked!", 3)
    end
})
```

---

## 📚 Documentação

### Criando Window

```lua
local Window = Library:CreateWindow({
    Title = "Título",
    Center = true,
    AutoShow = true,
    TabPadding = 2,
    MenuFadeTime = 0.2,
})
```

### Toggle

```lua
Group:AddToggle("ID", {
    Text = "Toggle Text",
    Default = false,
    Tooltip = "Tooltip",
    Risky = false,
    Callback = function(Value) end
})

-- Acessar
Library.Toggles.ID.Value
Library.Flags.ID
```

### Slider

```lua
Group:AddSlider("ID", {
    Text = "Slider",
    Default = 50,
    Min = 0,
    Max = 100,
    Rounding = 0,
    Suffix = "%",
    Callback = function(Value) end
})
```

### Button

```lua
-- Simples
Group:AddButton({
    Text = "Click",
    Func = function() end
})

-- Com confirmação
Group:AddButton({
    Text = "Danger",
    DoubleClick = true,
    Func = function() end
})

-- Lado a lado
Group:AddButton({ Text = "A", Func = function() end }):AddButton({ Text = "B", Func = function() end })
```

### Dropdown

```lua
-- Single select
Group:AddDropdown("ID", {
    Text = "Select",
    Values = {"A", "B", "C"},
    Default = "A",
    Callback = function(Value) end
})

-- Multi select
Group:AddDropdown("ID", {
    Text = "Select",
    Values = {"A", "B", "C"},
    Multi = true,
    Default = {"A"},
    Callback = function(Value) end
})
```

### Input

```lua
Group:AddInput("ID", {
    Text = "Input",
    Default = "",
    Placeholder = "Type...",
    Numeric = false,
    Finished = false,
    Callback = function(Value) end
})
```

### ColorPicker

```lua
local Label = Group:AddLabel("Color")
Label:AddColorPicker("ID", {
    Default = Color3.fromRGB(255, 0, 0),
    Callback = function(Value) end
})
```

### KeyPicker

```lua
Toggle:AddKeyPicker("ID", {
    Default = "E",
    Mode = "Toggle", -- "Always", "Toggle", "Hold"
    Callback = function(Active) end
})
```

### DependencyBox

```lua
Group:AddToggle("Master", { Text = "Show", Default = false })

local Box = Group:AddDependencyBox()
Box:SetupDependencies({ { Library.Toggles.Master, true } })

Box:AddToggle(...)  -- Só aparece quando Master = true
```

---

## 🎨 Temas

```lua
-- Mudar tema
Library:SetTheme("Ocean")

-- Listar temas
Library:GetThemeNames()

-- Criar tema
Library:CreateCustomTheme("MeuTema", {
    FontColor = Color3.fromRGB(255, 255, 255),
    MainColor = Color3.fromRGB(30, 30, 30),
    BackgroundColor = Color3.fromRGB(20, 20, 20),
    AccentColor = Color3.fromRGB(0, 255, 128),
    OutlineColor = Color3.fromRGB(50, 50, 50),
    RiskColor = Color3.fromRGB(255, 0, 0),
})

-- Mudar cor accent
Library:SetAccentColor(Color3.fromRGB(255, 0, 128))
```

---

## 👁️ ESP

```lua
local ESP = Library.ESP

ESP:Toggle(true)

ESP.BoxEnabled = true
ESP.NameEnabled = true
ESP.HealthEnabled = true
ESP.DistanceEnabled = true
ESP.TracerEnabled = false
ESP.ChamsEnabled = false
ESP.TeamCheck = false
ESP.MaxDistance = 1000
ESP.TracerOrigin = "Bottom" -- "Bottom", "Center", "Mouse"

ESP.BoxColor = Color3.fromRGB(255, 255, 255)
ESP.TracerColor = Color3.fromRGB(255, 0, 0)
ESP.ChamsColor = Color3.fromRGB(255, 0, 255)
```

---

## 🔧 Funções Úteis

```lua
-- Notificação
Library:Notify("Mensagem", 5)
Library:Notify("Mensagem", 5, "center")

-- Watermark
Library:SetWatermarkVisibility(true)
Library:SetWatermark("Meu Script | FPS: 60")

-- Keybind List
Library:SetKeyListVisibility(true)

-- Window Glow
Library:SetGlowVis(true)

-- Toggle Key (padrão: RightControl)
Library.ToggleKey = Enum.KeyCode.RightControl

-- Unload
Library:Unload()
```

---

## 📁 Arquivos

```
UILIB/
├── init.lua          # Módulo principal
├── Components.lua    # Carregador
├── Window.lua        # Window, Tab, GroupBox
├── Elements.lua      # Toggle, Slider, Button, etc.
├── BaseAddons.lua    # ColorPicker, KeyPicker
├── ESP.lua           # Sistema ESP
├── Signal.lua        # Eventos
├── Spring.lua        # Animações
├── loader.lua        # Loader para executors
├── example.lua       # Exemplo completo
├── README.md         # Documentação
└── LICENSE           # MIT
```

---

## 📄 Licença

MIT License - Uso livre

---

<div align="center">

**⭐ Se gostou, deixe uma estrela! ⭐**

Made by **Devzhtz1**

[![GitHub](https://img.shields.io/badge/GitHub-Devzhtz1-black?style=for-the-badge&logo=github)](https://github.com/Devzhtz1)

</div>
