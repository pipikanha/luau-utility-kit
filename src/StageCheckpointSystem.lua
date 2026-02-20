-- Serviços utilizados
local players = game:GetService("Players") -- Serviço que controla os jogadores
local datastore = game:GetService("DataStoreService") -- Serviço para salvar dados
local checkpointsData = datastore:GetDataStore("Checkpoints") -- DataStore onde os estágios serão salvos

-- Pasta no Workspace onde ficam os checkpoints (Parts numeradas: 1, 2, 3...)
local checkpointsFolder = workspace:FindFirstChild("Checkpoints")


-- =========================================================
-- QUANDO UM JOGADOR ENTRA NO SERVIDOR
-- =========================================================
players.PlayerAdded:Connect(function(player)

	-- Criação da pasta leaderstats
	local leaderstats = Instance.new("Folder", player)
	leaderstats.Name = "leaderstats"

	-- Criação do valor Stage (estágio atual do jogador)
	local stage = Instance.new("IntValue", leaderstats)
	stage.Name = "Stage"
	stage.Value = 0 -- Começa no estágio 0

	-- Tenta carregar os dados salvos do jogador
	local sucess, result = pcall(function()
		return checkpointsData:GetAsync("Player_" .. player.UserId)
	end)

	-- Se conseguiu carregar e existir valor salvo, aplica ao jogador
	if sucess and result then
		stage.Value = result
	end


	-- =========================================================
	-- QUANDO O PERSONAGEM DO JOGADOR NASCE
	-- =========================================================
	player.CharacterAdded:Connect(function(character)

		-- Espera o HumanoidRootPart existir
		local hrp = character:WaitForChild("HumanoidRootPart")

		-- Pega o estágio atual do jogador
		local playerStage = player.leaderstats.Stage.Value

		-- Procura o checkpoint correspondente ao número do estágio
		local checkPoint = checkpointsFolder:FindFirstChild(tostring(playerStage))

		-- Se existir, teleporta o jogador para ele
		if checkPoint then
			hrp.CFrame = checkPoint.CFrame + Vector3.new(0, 5, 0)
		end
	end)
end)


-- =========================================================
-- FUNÇÃO PARA SALVAR DADOS
-- =========================================================
local function SaveData(player)

	local success, errorMessage = pcall(function()
		checkpointsData:SetAsync("Player_" .. player.UserId, player.leaderstats.Stage.Value)
	end)

	if not success then
		warn("Erro ao salvar dados de " .. player.Name .. ": " .. errorMessage)
	end
end


-- Quando jogador sai do servidor
players.PlayerRemoving:Connect(function(player)
	SaveData(player)
end)

-- Quando o servidor fecha
game:BindToClose(function()
	for _, player in pairs(players:GetPlayers()) do
		SaveData(player)
	end
end)



-- =========================================================
-- SISTEMA DE DETECÇÃO DOS CHECKPOINTS
-- =========================================================
for _, part in pairs(checkpointsFolder:GetChildren()) do

	-- Conecta o evento Touched de cada checkpoint
	part.Touched:Connect(function(hit)

		-- Verifica se quem tocou foi um jogador
		local player = game.Players:GetPlayerFromCharacter(hit.Parent)

		if player then

			local humanoid = hit.Parent:FindFirstChild("Humanoid")

			-- Verifica se o jogador está vivo
			if humanoid and humanoid.Health > 0 then

				local playerStage = player.leaderstats.Stage
				local checkPointValue = tonumber(part.Name)

				-- Só avança se for exatamente o próximo checkpoint
				if checkPointValue == playerStage.Value + 1 then
					playerStage.Value = checkPointValue
				end
			end
		end
	end)
end
