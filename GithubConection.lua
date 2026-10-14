-- =============================================================================
-- BLUE X HUB - GITHUB_CONECTION.LUA (CONECTOR E INJETOR PRINCIPAL ATUALIZADO)
-- Cole este código exatamente dentro do seu arquivo GithubConection.lua
-- =============================================================================

repeat task.wait() until game:IsLoaded() and game.Players.LocalPlayer
task.wait(0.5)

print("➔ [BLUE X HUB] Iniciando conexao segura com o GitHub...")

-- Links RAW atualizados do seu repositório Caveira-Hub
local LINK_INTERFACE = "https://raw.githubusercontent.com/betsejogos-commits/Caveira-Hub/refs/heads/main/Interface.lua"
local LINK_COMBATE   = "https://raw.githubusercontent.com/betsejogos-commits/Caveira-Hub/refs/heads/main/main.lua"

-- =============================================================================
-- 1. CARREGAMENTO DO MÓDULO VISUAL: INTERFACE.LUA
-- =============================================================================
local sucessoInterface, erroInterface = pcall(function()
    return loadstring(game:HttpGet(LINK_INTERFACE))()
end)

if not sucessoInterface then
    warn("❌ [ERRO] Falha critica ao baixar a Interface.lua do GitHub: " .. tostring(erroInterface))
    return
end

-- Aguarda a confirmacao de segurança de que a interface carregou totalmente
repeat task.wait(0.1) until _G.BlueXInterfaceCarregada == true

-- =============================================================================
-- 2. CARREGAMENTO DO MÓDULO PESADO: MAIN.LUA (COMBATE & REDIRECIONAMENTO)
-- =============================================================================
local sucessoCombate, erroCombate = pcall(function()
    return loadstring(game:HttpGet(LINK_COMBATE))()
end)

if not sucessoCombate then
    warn("❌ [ERRO] Falha critica ao baixar o main.lua do GitHub: " .. tostring(erroCombate))
    return
end

-- =============================================================================
-- 3. MONTAGEM AUTOMÁTICA DAS ABAS E VINCULAÇÃO DE INTERRUPTORES (TOGGLES)
-- =============================================================================
pcall(function()
    -- Gera as abas no menu lateral esquerdo da sua janela transparente
    local FarmTab   = _G.BlueXInterface:CriarAba("Farm Principal")
    local RaidTab   = _G.BlueXInterface:CriarAba("Dungeon Raid")
    local CombatTab = _G.BlueXInterface:CriarAba("Combat PVP")

    -- Elementos visuais da aba de Farm (Skypiea 3 Forçado e Baús)
    FarmTab:CriarSecao("Configuracoes de Level")
    
    FarmTab:CriarToggle("Auto Farm Level (Skypiea 3 Forcado)", "AutoFarm", function(estado)
        print("➔ [STATUS] Auto Farm Level definido como: ", estado)
    end)

    FarmTab:CriarToggle("Ataque Rapido [M1 NoCooldown]", "Seriality", function(estado)
        print("➔ [STATUS] No Cooldown definido como: ", estado)
    end)

    FarmTab:CriarToggle("Auto Chest [◇ Coleta Baus ◇]", "AutoChest", function(estado)
        print("➔ [STATUS] Auto Chest definido como: ", estado)
    end)

    FarmTab:CriarToggle("Hitbox Grande (Expandir 65 Studs)", "ExpandirHitbox", function(estado)
        if estado then 
            _G.NOVO_TAMANHO = Vector3.new(65, 65, 65) 
        else 
            _G.NOVO_TAMANHO = Vector3.new(15, 15, 15) 
        end
    end)

    -- Elementos visuais da aba de Dungeons e Raids
    RaidTab:CriarSecao("Coordenador de Dungeon")
    
    RaidTab:CriarToggle("Auto Raid Dungeon Event", "AutoRaid", function(estado)
        print("➔ [STATUS] Auto Raid definido como: ", estado)
    end)
    
    -- Elementos visuais da aba de Trava PVP e Utilidades extras
    CombatTab:CriarSecao("Trava e Auxilio PVP")
    
    CombatTab:CriarToggle("Aimbot Habilidades Trava PVP", "AimBotPVP", function(estado)
        print("➔ [STATUS] AimBot PVP definido como: ", estado)
    end)

    CombatTab:CriarToggle("Hop If Not Spawned Awakened", "HopAwakened", function(estado)
        print("➔ [STATUS] Server Hop de Bosses definido como: ", estado)
    end)

    CombatTab:CriarToggle("Auto Roll Fruit (Gacha Gira)", "AutoRoll", function(estado)
        print("➔ [STATUS] Gacha Automático definido como: ", estado)
    end)
end)

print("➔ [BLUE X HUB] Sincronizacao completa! Os codigos do GitHub estao integrados.")
