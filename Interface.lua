-- =============================================================================
-- CAVEIRA HUB - INTERFACE.LUA (PARTE 1 DE 5: CRIAÇÃO DA JANELA TRANSPARENTE)
-- Cole este bloco no início do seu arquivo Interface.lua no GitHub
-- =============================================================================

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

_G.BlueXInterface = {}

-- Criando a tela que vai segurar o cheat (ScreenGui) com proteção visual
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "BlueX_PremiumUI"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Tenta colocar na CoreGui para esconder dos prints e vídeos de hackers, senão usa PlayerGui
pcall(function()
    screenGui.Parent = CoreGui
end)
if not screenGui.Parent then
    screenGui.Parent = PlayerGui
end

-- Painel Principal Escuro Transparente Premium (Bordas Arredondadas)
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 530, 0, 350)
mainFrame.Position = UDim2.new(0.5, -265, 0.5, -175)
mainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
mainFrame.BackgroundTransparency = 0.22 -- Transparência perfeita igual você pediu
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner", mainFrame)
mainCorner.CornerRadius = UDim.new(0, 10)

-- Barra de Título Superior (Onde fica o texto do Hub)
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 36)
titleBar.BackgroundColor3 = Color3.fromRGB(10, 10, 14)
titleBar.BackgroundTransparency = 0.4
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleCorner = Instance.new("UICorner", titleBar)
titleCorner.CornerRadius = UDim.new(0, 10)

local titleText = Instance.new("TextLabel")
titleText.Size = UDim2.new(1, -100, 1, 0)
titleText.Position = UDim2.new(0, 12, 0, 0)
titleText.BackgroundTransparency = 1
titleText.Text = "Caveira Hub | Blox Fruits V3.1.3 (Design Transparente)"
titleText.TextColor3 = Color3.fromRGB(245, 245, 250)
titleText.TextXAlignment = Enum.TextXAlignment.Left
titleText.Font = Enum.Font.SourceSansBold
titleText.TextSize = 14
titleText.Parent = titleBar

-- =============================================================================
-- CAVEIRA HUB - INTERFACE.LUA (PARTE 2 DE 5: ARRASTO MOBILE/PC E SIDEBAR)
-- Cole este bloco logo abaixo do final da Parte 1.
-- =============================================================================

-- Sistema de Arrasto Draggable nativo por extenso (Bypass de Emulação de Toque)
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

-- CONTAINER DA SIDEBAR (MENU LATERAL ESQUERDO)
local sidebar = Instance.new("Frame", mainFrame)
sidebar.Name = "Sidebar"
sidebar.Size = UDim2.new(0, 145, 1, -36)
sidebar.Position = UDim2.new(0, 0, 0, 36)
sidebar.BackgroundColor3 = Color3.fromRGB(10, 10, 14)
sidebar.BackgroundTransparency = 0.5
sidebar.BorderSizePixel = 0

local sidebarLayout = Instance.new("UIListLayout", sidebar)
sidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
sidebarLayout.Padding = UDim.new(0, 5)

local sidebarPadding = Instance.new("UIPadding", sidebar)
sidebarPadding.PaddingTop = UDim.new(0, 8)
sidebarPadding.PaddingLeft = UDim.new(0, 6)

-- CONTAINER CENTRAL DE CONTEÚDO (PASTAS DE PÁGINAS)
local containerArea = Instance.new("Frame", mainFrame)
containerArea.Name = "ContainerArea"
containerArea.Size = UDim2.new(1, -145, 1, -36)
containerArea.Position = UDim2.new(0, 145, 0, 36)
containerArea.BackgroundTransparency = 1

local pagesFolder = Instance.new("Folder", containerArea)
pagesFolder.Name = "Pages"

local primeiraPagina = true

-- =============================================================================
-- CAVEIRA HUB - INTERFACE.LUA (PARTE 3 DE 5: FUNÇÃO GERENCIADORA DE ABAS)
-- Cole este bloco logo abaixo do final da Parte 2.
-- =============================================================================

-- FUNÇÃO DINÂMICA DE CRIAÇÃO DE MULTI-TABS (Exportada para uso global)
function _G.BlueXInterface:CriarAba(nomeAba)
    local tabButton = Instance.new("TextButton", sidebar)
    tabButton.Name = nomeAba .. "_Btn"
    tabButton.Size = UDim2.new(1, -6, 0, 32)
    tabButton.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
    tabButton.BackgroundTransparency = 0.6
    tabButton.Text = "  " .. nomeAba
    tabButton.TextColor3 = Color3.fromRGB(160, 160, 170)
    tabButton.TextXAlignment = Enum.TextXAlignment.Left
    tabButton.Font = Enum.Font.SourceSansBold
    tabButton.TextSize = 12
    Instance.new("UICorner", tabButton).CornerRadius = UDim.new(0, 4)

    -- Criando a ScrollingPage com barra de rolagem fina inteligente para mobile
    local pageFrame = Instance.new("ScrollingFrame", pagesFolder)
    pageFrame.Name = nomeAba .. "_Page"
    pageFrame.Size = UDim2.new(1, 0, 1, 0)
    pageFrame.BackgroundTransparency = 1
    pageFrame.BorderSizePixel = 0
    pageFrame.ScrollBarThickness = 3
    pageFrame.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 90)
    pageFrame.Visible = false

    local pageLayout = Instance.new("UIListLayout", pageFrame)
    pageLayout.SortOrder = Enum.SortOrder.LayoutOrder
    pageLayout.Padding = UDim.new(0, 6)

    local pagePadding = Instance.new("UIPadding", pageFrame)
    pagePadding.PaddingTop = UDim.new(0, 10)
    pagePadding.PaddingLeft = UDim.new(0, 10)
    pagePadding.PaddingRight = UDim.new(0, 10)

    -- Seta o visual ativo automaticamente se for a primeira aba instanciada
    if primeiraPagina then
        pageFrame.Visible = true
        tabButton.BackgroundColor3 = Color3.fromRGB(0, 140, 240)
        tabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        primeiraPagina = false
    end

    -- Alternador visual automático que troca de página ao clicar na aba
    tabButton.MouseButton1Click:Connect(function()
        for _, p in pairs(pagesFolder:GetChildren()) do
            p.Visible = false
        end
        for _, b in pairs(sidebar:GetChildren()) do
            if b:IsA("TextButton") then
                b.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
                b.TextColor3 = Color3.fromRGB(160, 160, 170)
            end
        end
        pageFrame.Visible = true
        tabButton.BackgroundColor3 = Color3.fromRGB(0, 140, 240)
        tabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    end)

    -- Tabela de encapsulamento de métodos para gerar os objetos internos
    local subMetodos = {}

    -- =============================================================================
    -- CAVEIRA HUB - INTERFACE.LUA (PARTE 4 DE 5: SEÇÕES DE TEXTO E MOTORES DOS TOGGLES)
    -- Cole este bloco logo abaixo do final da Parte 3.
    -- =============================================================================

    -- Método Construtor de Seções de Texto (Headers de organização interna)
    function subMetodos:CriarSecao(tituloSecao)
        local sectionLabel = Instance.new("TextLabel", pageFrame)
        sectionLabel.Size = UDim2.new(1, 0, 0, 20)
        sectionLabel.BackgroundTransparency = 1
        sectionLabel.Text = "--- " .. tituloSecao .. " ---"
        sectionLabel.TextColor3 = Color3.fromRGB(0, 140, 240)
        sectionLabel.Font = Enum.Font.SourceSansBold
        sectionLabel.TextSize = 11
        sectionLabel.TextXAlignment = Enum.TextXAlignment.Left
    end

    -- Método Construtor dos Toggles (Interruptores Modernos Com Animação)
    function subMetodos:CriarToggle(tituloToggle, configGlobal, callback)
        local toggleFrame = Instance.new("Frame", pageFrame)
        toggleFrame.Size = UDim2.new(1, 0, 0, 38)
        toggleFrame.BackgroundColor3 = Color3.fromRGB(14, 14, 18)
        toggleFrame.BackgroundTransparency = 0.4
        Instance.new("UICorner", toggleFrame).CornerRadius = UDim.new(0, 6)

        local titleLabel = Instance.new("TextLabel", toggleFrame)
        titleLabel.Size = UDim2.new(1, -60, 0, 38)
        titleLabel.Position = UDim2.new(0, 10, 0, 0)
        titleLabel.BackgroundTransparency = 1
        titleLabel.Text = tituloToggle
        titleLabel.TextColor3 = Color3.fromRGB(225, 225, 230)
        titleLabel.TextXAlignment = Enum.TextXAlignment.Left
        titleLabel.Font = Enum.Font.SourceSansBold
        titleLabel.TextSize = 12

        local switchBg = Instance.new("TextButton", toggleFrame)
        switchBg.Size = UDim2.new(0, 36, 0, 18)
        switchBg.Position = UDim2.new(1, -46, 0.5, -9)
        switchBg.BackgroundColor3 = Color3.fromRGB(55, 55, 65)
        switchBg.BorderSizePixel = 0
        switchBg.Text = ""
        
        local switchCorner = Instance.new("UICorner", switchBg)
        switchCorner.CornerRadius = UDim.new(1, 0)

        local circle = Instance.new("Frame", switchBg)
        circle.Size = UDim2.new(0, 14, 0, 14)
        circle.Position = UDim2.new(0, 2, 0.5, -7)
        circle.BackgroundColor3 = Color3.fromRGB(220, 220, 225)
        circle.BorderSizePixel = 0
        local circleCorner = Instance.new("UICorner", circle)
        circleCorner.CornerRadius = UDim.new(1, 0)

        -- Verifica se o estado já iniciou verdadeiro no ambiente global e atualiza o visual
        if _G[configGlobal] then
            circle.Position = UDim2.new(1, -16, 0.5, -7)
            switchBg.BackgroundColor3 = Color3.fromRGB(0, 140, 240)
        end

        local ativo = _G[configGlobal] or false
        switchBg.MouseButton1Click:Connect(function()
            ativo = not ativo
            _G[configGlobal] = ativo -- Define o estado global que o script de combate monitora
            
            if ativo then
                TweenService:Create(circle, TweenInfo.new(0.1), {Position = UDim2.new(1, -16, 0.5, -7)}):Play()
                TweenService:Create(switchBg, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(0, 140, 240)}):Play()
            else
                TweenService:Create(circle, TweenInfo.new(0.1), {Position = UDim2.new(0, 2, 0.5, -7)}):Play()
                TweenService:Create(switchBg, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(55, 55, 65)}):Play()
            end
            callback(ativo)
        end)
    end

    -- =============================================================================
    -- CAVEIRA HUB - INTERFACE.LUA (PARTE 5 DE 5: BOTÕES E FINALIZAÇÃO DO MÓDULO)
    -- Cole este bloco logo abaixo do final da Parte 4 para concluir o arquivo.
    -- =============================================================================

    -- Método Construtor de Botões Simples (Ações Instantâneas)
    function subMetodos:CriarBotao(textoBotao, callback)
        local button = Instance.new("TextButton", pageFrame)
        button.Size = UDim2.new(1, 0, 0, 34)
        button.BackgroundColor3 = Color3.fromRGB(24, 24, 30)
        button.BackgroundTransparency = 0.3
        button.BorderSizePixel = 0
        button.Text = textoBotao
        button.TextColor3 = Color3.fromRGB(235, 235, 240)
        button.Font = Enum.Font.SourceSansBold
        button.TextSize = 12
        local buttonCorner = Instance.new("UICorner", button)
        buttonCorner.CornerRadius = UDim.new(0, 6)

        button.MouseButton1Click:Connect(function()
            button.BackgroundTransparency = 0.6
            task.wait(0.08)
            button.BackgroundTransparency = 0.3
            callback()
        end)
    end

    return subMetodos
end

-- Avisa o conector e o main.lua que todo o visual transparente premium foi montado
_G.BlueXInterfaceCarregada = true
print("➔ [CAVEIRA HUB] Arquivo Interface.lua finalizado e pronto para o boot!")
