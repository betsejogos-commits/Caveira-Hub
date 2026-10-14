-- =============================================================================
-- MASTER HUB - INTERFACE.LUA (PARTE 1 DE 3: PROTEÇÃO CONTRA RESPAWN DO FAST ATK)
-- Cole este bloco no início do seu arquivo Interface.lua no GitHub
-- =============================================================================

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

_G.MasterHubUI = {}

-- 1. CRIAÇÃO DA SCREEN GUI COM TRAVA ANTIDESTRUIÇÃO POR RESPAWN
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MasterHubOfficialUI"
screenGui.ResetOnSpawn = false -- DESATIVADO! Impede o Roblox de deletar a UI quando você dá Respawn
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Injeta na CoreGui (Protege contra resets do personagem e esconde de prints/vídeos)
pcall(function()
    screenGui.Parent = CoreGui
end)
if not screenGui.Parent then
    screenGui.Parent = PlayerGui
end

-- 2. PAINEL PRINCIPAL ESCURO (ESTILO TEDDY/NICK HUB)
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 540, 0, 360)
mainFrame.Position = UDim2.new(0.5, -270, 0.5, -180)
mainFrame.BackgroundColor3 = Color3.fromRGB(24, 24, 28) -- Tom escuro idêntico ao seu print
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner", mainFrame)
mainCorner.CornerRadius = UDim.new(0, 8)

-- Barra Superior de Título (TitleBar)
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 38)
titleBar.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleCorner = Instance.new("UICorner", titleBar)
titleCorner.CornerRadius = UDim.new(0, 8)

local titleText = Instance.new("TextLabel")
titleText.Size = UDim2.new(1, -100, 1, 0)
titleText.Position = UDim2.new(0, 12, 0, 0)
titleText.BackgroundTransparency = 1
titleText.Text = "Master Hub | Blox Fruits (Anti-Reset Core Active)"
titleText.TextColor3 = Color3.fromRGB(240, 240, 245)
titleText.TextXAlignment = Enum.TextXAlignment.Left
titleText.Font = Enum.Font.SourceSansBold
titleText.TextSize = 13
titleText.Parent = titleBar

-- 3. SISTEMA DE ARRASTO DRAGGABLE COMPATIVEL COM CORREÇÃO DE POSIÇÃO NO CELULAR
local dragging, dragInput, dragStart, startPos
titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then 
                dragging = false 
            end
        end)
    end
end)

titleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input == dragInput then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- 4. MONITOR DE SEGURANÇA DE RE-CONEXÃO (Caso o boneco mude de posição bruscamente ou resete)
LocalPlayer.CharacterAdded:Connect(function(novoCharacter)
    -- Garante que mesmo mudando de corpo, a UI força sua permanência no topo gráfico
    task.wait(0.2)
    pcall(function()
        if screenGui.Parent ~= CoreGui and screenGui.Parent ~= PlayerGui then
            screenGui.Parent = CoreGui or PlayerGui
        end
    end)
end)

-- =============================================================================
-- MASTER HUB - INTERFACE.LUA (PARTE 2 DE 3: SIDEBAR FIXA E SISTEMA DE ABAS)
-- Cole este bloco logo abaixo do final da Parte 1 no seu arquivo Interface.lua
-- =============================================================================

-- CONTAINER DA SIDEBAR LATERAL (MENU ESQUERDO FIXO ANTI-RESPAWN)
local sidebar = Instance.new("Frame", mainFrame)
sidebar.Name = "Sidebar"
sidebar.Size = UDim2.new(0, 150, 1, -38)
sidebar.Position = UDim2.new(0, 0, 0, 38)
sidebar.BackgroundColor3 = Color3.fromRGB(18, 18, 22) -- Tom cinza escuro correspondente
sidebar.BorderSizePixel = 0
sidebar.ZIndex = 5 -- Mantém as abas travadas sempre na camada da frente

local sidebarLayout = Instance.new("UIListLayout", sidebar)
sidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
sidebarLayout.Padding = UDim.new(0, 6)

local sidebarPadding = Instance.new("UIPadding", sidebar)
sidebarPadding.PaddingTop = UDim.new(0, 10)
sidebarPadding.PaddingLeft = UDim.new(0, 8)

-- CONTAINER CENTRAL DE CONTEÚDO (ÁREA DIREITA ISOLADA PARA OS BOTÕES DE FARM)
local containerArea = Instance.new("Frame", mainFrame)
containerArea.Name = "ContainerArea"
containerArea.Size = UDim2.new(1, -160, 1, -48)
containerArea.Position = UDim2.new(0, 155, 0, 42) -- Afastamento seguro da sidebar
containerArea.BackgroundTransparency = 1
containerArea.ZIndex = 2

local pagesFolder = Instance.new("Folder", containerArea)
pagesFolder.Name = "Pages"

local primeiraPagina = true

-- FUNÇÃO EXTENSA PARA CRIAR ABAS DO MASTER HUB
function _G.MasterHubUI:CriarAba(nomeAba)
    local tabButton = Instance.new("TextButton", sidebar)
    tabButton.Name = nomeAba .. "_Btn"
    tabButton.Size = UDim2.new(1, -8, 0, 34)
    tabButton.BackgroundColor3 = Color3.fromRGB(30, 30, 36)
    tabButton.Text = "  " .. nomeAba
    tabButton.TextColor3 = Color3.fromRGB(170, 170, 180)
    tabButton.TextXAlignment = Enum.TextXAlignment.Left
    tabButton.Font = Enum.Font.SourceSansBold
    tabButton.TextSize = 13
    tabButton.ZIndex = 6
    Instance.new("UICorner", tabButton).CornerRadius = UDim.new(0, 4)

    -- Criando a página rolável sob medida para os botões de farm
    local pageFrame = Instance.new("ScrollingFrame", pagesFolder)
    pageFrame.Name = nomeAba .. "_Page"
    pageFrame.Size = UDim2.new(1, 0, 1, 0)
    pageFrame.BackgroundTransparency = 1
    pageFrame.BorderSizePixel = 0
    pageFrame.ScrollBarThickness = 3
    pageFrame.ScrollBarImageColor3 = Color3.fromRGB(70, 70, 80)
    pageFrame.Visible = false
    pageFrame.ZIndex = 3

    local pageLayout = Instance.new("UIListLayout", pageFrame)
    pageLayout.SortOrder = Enum.SortOrder.LayoutOrder
    pageLayout.Padding = UDim.new(0, 6)

    local pagePadding = Instance.new("UIPadding", pageFrame)
    pagePadding.PaddingTop = UDim.new(0, 5)
    pagePadding.PaddingLeft = UDim.new(0, 5)
    pagePadding.PaddingRight = UDim.new(0, 5)

    -- Abre a primeira aba criada na tela automaticamente como padrão inicial
    if primeiraPagina then
        pageFrame.Visible = true
        tabButton.BackgroundColor3 = Color3.fromRGB(0, 150, 255) -- Azul selecionado
        tabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        primeiraPagina = false
    end

    -- Alternador visual de cliques para navegar entre as páginas de Farm
    tabButton.MouseButton1Click:Connect(function()
        for _, p in pairs(pagesFolder:GetChildren()) do
            p.Visible = false
        end
        for _, b in pairs(sidebar:GetChildren()) do
            if b:IsA("TextButton") then
                b.BackgroundColor3 = Color3.fromRGB(30, 30, 36)
                b.TextColor3 = Color3.fromRGB(170, 170, 180)
            end
        end
        pageFrame.Visible = true
        tabButton.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
        tabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    end)

    local subMetodos = {}

    -- =============================================================================
    -- MASTER HUB - INTERFACE.LUA (PARTE 3 DE 3: CONSTRUTORES DE BOTÕES DE FARM)
    -- Cole este bloco logo abaixo do final da Parte 2 para fechar o arquivo.
    -- =============================================================================

    -- Método para criar Seções de organização corrigido (Design sem bugar layouts)
    function subMetodos:CriarSecao(tituloSecao)
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 0, 24)
        label.BackgroundTransparency = 1
        label.Text = "  " .. tituloSecao
        label.TextColor3 = Color3.fromRGB(0, 150, 255) -- Azul de destaque do Master Hub
        label.Font = Enum.Font.SourceSansBold
        label.TextSize = 13
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.ZIndex = 4
        label.Parent = pageFrame -- Garante o isolamento dentro da página certa
    end

    -- Método Construtor de Toggles (Interruptores com design moderno e bolinhas)
    function subMetodos:CriarToggle(tituloToggle, configGlobal, callback)
        local toggleFrame = Instance.new("Frame")
        toggleFrame.Size = UDim2.new(1, -6, 0, 40) -- Usa -6 para não estourar a borda direita
        toggleFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
        toggleFrame.BackgroundTransparency = 0.3
        toggleFrame.BorderSizePixel = 0
        toggleFrame.ZIndex = 4
        toggleFrame.Parent = pageFrame

        Instance.new("UICorner", toggleFrame).CornerRadius = UDim.new(0, 6)

        local titleLabel = Instance.new("TextLabel")
        titleLabel.Size = UDim2.new(1, -60, 1, 0)
        titleLabel.Position = UDim2.new(0, 10, 0, 0)
        titleLabel.BackgroundTransparency = 1
        titleLabel.Text = tituloToggle
        titleLabel.TextColor3 = Color3.fromRGB(220, 220, 225)
        titleLabel.TextXAlignment = Enum.TextXAlignment.Left
        titleLabel.Font = Enum.Font.SourceSansBold
        titleLabel.TextSize = 12
        titleLabel.ZIndex = 5
        titleLabel.Parent = toggleFrame

        local switchBg = Instance.new("TextButton")
        switchBg.Size = UDim2.new(0, 36, 0, 18)
        switchBg.Position = UDim2.new(1, -46, 0.5, -9)
        switchBg.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
        switchBg.Text = ""
        switchBg.BorderSizePixel = 0
        switchBg.ZIndex = 5
        switchBg.Parent = toggleFrame
        Instance.new("UICorner", switchBg).CornerRadius = UDim.new(1, 0)

        local circle = Instance.new("Frame")
        circle.Size = UDim2.new(0, 14, 0, 14)
        circle.Position = UDim2.new(0, 2, 0.5, -7)
        circle.BackgroundColor3 = Color3.fromRGB(240, 240, 245)
        circle.BorderSizePixel = 0
        circle.ZIndex = 6
        circle.Parent = switchBg
        Instance.new("UICorner", circle).CornerRadius = UDim.new(1, 0)

        -- Sistema de persistência: se o script já salvou ativo, renderiza ligado de primeira
        if _G[configGlobal] then
            circle.Position = UDim2.new(1, -16, 0.5, -7)
            switchBg.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
        end

        local ativo = _G[configGlobal] or false
        switchBg.MouseButton1Click:Connect(function()
            ativo = not ativo
            _G[configGlobal] = ativo -- Sincroniza dinamicamente com as threads do main.lua
            if ativo then
                TweenService:Create(circle, TweenInfo.new(0.12), {Position = UDim2.new(1, -16, 0.5, -7)}):Play()
                TweenService:Create(switchBg, TweenInfo.new(0.12), {BackgroundColor3 = Color3.fromRGB(0, 150, 255)}):Play()
            else
                TweenService:Create(circle, TweenInfo.new(0.12), {Position = UDim2.new(0, 2, 0.5, -7)}):Play()
                TweenService:Create(switchBg, TweenInfo.new(0.12), {BackgroundColor3 = Color3.fromRGB(60, 60, 70)}):Play()
            end
            callback(ativo)
        end)
    end

    -- Método Construtor de Botões (Ideal para Farms Instantâneos e Rolls)
    function subMetodos:CriarBotao(textoBotao, callback)
        local button = Instance.new("TextButton")
        button.Size = UDim2.new(1, -6, 0, 36) -- Largura inteligente baseada no contêiner
        button.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
        button.BackgroundTransparency = 0.2
        button.BorderSizePixel = 0
        button.Text = textoBotao
        button.TextColor3 = Color3.fromRGB(235, 235, 240)
        button.Font = Enum.Font.SourceSansBold
        button.TextSize = 12
        button.ZIndex = 4
        button.Parent = pageFrame -- Garante que o botão não cubra a Sidebar lateral esquerdo
        
        Instance.new("UICorner", button).CornerRadius = UDim.new(0, 6)

        button.MouseButton1Click:Connect(function()
            button.BackgroundTransparency = 0.5
            task.wait(0.08)
            button.BackgroundTransparency = 0.2
            callback()
        end)
    end

    return subMetodos
end

-- Ativa o sinalizador na memória global para o main.lua prosseguir com o carregamento
_G.BlueXInterfaceCarregada = true
print("➔ [MASTER HUB] Interface.lua finalizada com isolamento de contêiner e anti-respawn!")
