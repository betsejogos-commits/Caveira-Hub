-- =============================================================================
-- BLUE X HUB - GITHUB_CONECTION.LUA (CONECTOR E INJETOR PRINCIPAL)
-- Cole este código dentro do arquivo GithubConection.lua no seu repositório.
-- =============================================================================

repeat task.wait() until game:IsLoaded() and game.Players.LocalPlayer
task.wait(0.5)

print("➔ [BLUE X HUB] Iniciando conexão segura com o GitHub...")

-- 1. LINKS CONFIGURÁVEIS (Troque pelos seus links RAW reais do GitHub)
-- Dica: Vá no seu GitHub pelo celular, clique em 'main.lua' e 'Interface.lua', 
-- clique nos 3 pontinhos, escolha 'View Raw' e copie o link do navegador.
local LINK_INTERFACE = "https://githubusercontent.com"
local LINK_COMBATE   = "https://githubusercontent.com"

-- =============================================================================
-- 2. CARREGAMENTO DO MÓDULO 1: INTERFACE GRÁFICA TRANSPARENTE
-- =============================================================================
local sucessoInterface, erroInterface = pcall(function()
    return loadstring(game:HttpGet(LINK_INTERFACE))()
end)

if not sucessoInterface then
    warn("❌ [ERRO] Falha crítica ao baixar a Interface.lua do GitHub: " .. tostring(erroInterface))
    return
end

-- Aguarda a confirmação de que a estrutura visual foi montada com sucesso na memória do jogo
repeat task.wait(0.1) until _G.BlueXInterfaceCarregada == true

-- =============================================================================
-- 3. CARREGAMENTO DO MÓDULO 2: LOGICA DE COMBATE & FARM PARA SKYPIEA 3
-- =============================================================================
local sucessoCombate, erroCombate = pcall(function()
    return loadstring(game:HttpGet(LINK_COMBATE))()
end)

if not sucessoCombate then
    warn("❌ [ERRO] Falha crítica ao baixar o main.lua do GitHub: " .. tostring(erroCombate))
    return
end

-- =============================================================================
-- 4. VINCULAÇÃO E MONTAGEM DAS ABAS DO PAINEL DE DEMONSTRAÇÃO
-- =============================================================================
-- Aqui o script junta os botões visuais do Interface.lua com os motores do main.lua
pcall(function()
    -- Criando as Abas Laterais na Sidebar transparente
    local FarmTab   = _G.BlueXInterface:CriarAba("Farm Principal")
    local RaidTab   = _G.BlueXInterface:CriarAba("Dungeon Raid")
    local CombatTab = _G.BlueXInterface:CriarAba("Combat PVP")

    -- Montando os Toggles internos da Aba de Farm
    FarmTab:CriarSecao("Configurações de Level")
    
    FarmTab:CriarToggle("Auto Farm Level (Skypiea 3 Forçado)", "AutoFarm", function(estado)
        print("➔ [STATUS] Auto Farm Level definido como: ", estado)
    end)

    FarmTab:CriarToggle("Ataque Rápido [M1 NoCooldown]", "Seriality", function(estado)
        print("➔ [STATUS] No Cooldown definido como: ", estado)
    end)

    FarmTab:CriarToggle("Auto Chest [◇ Coleta Baús ◇]", "AutoChest", function(estado)
        print("➔ [STATUS] Auto Chest definido como: ", estado)
    end)

    FarmTab:CriarToggle("Hitbox Grande (Expandir 65 Studs)", "ExpandirHitbox", function(estado)
        if estado then 
            _G.NOVO_TAMANHO = Vector3.new(65, 65, 65) 
        else 
            _G.NOVO_TAMANHO = Vector3.new(15, 15, 15) 
        end
    end)

    -- Montando os Toggles internos da Aba de Raids / Dungeon
    RaidTab:CriarSecao("Coordenador de Dungeon")
    
    RaidTab:CriarToggle("Auto Raid Dungeon Event", "AutoRaid", function(estado)
        print("➔ [STATUS] Auto Raid definido como: ", estado)
    end)
    
    -- Montando os Toggles internos da Aba de Combate / PVP
    CombatTab:CriarSecao("Trava e Auxílio PVP")
    
    CombatTab:CriarToggle("Aimbot Habilidades Trava PVP", "AimBotPVP", function(estado)
        print("➔ [STATUS] AimBot PVP definido como: ", estado)
    end)

    CombatTab:CriarToggle("Hop If Not Spawned Awakened", "HopAwakened", function(estado)
        print("➔ [STATUS] Server Hop de Bosses definido como: ", estado)
    end)

    CombatTab:CriarToggle("Auto Roll Fruit (Gacha Gira)", "AutoRoll", function(estado)
        print("➔ [STATUS] Gacha Automático definido como: ", estado)
    end)
end)

print("➔ [BLUE X HUB] Sincronização completa! Todos os módulos estão ativos e integrados.")
