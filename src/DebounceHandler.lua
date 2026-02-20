--[[
	Debounce Module
	----------------
	Sistema de controle de tempo (cooldown) baseado em chave.

	Permite:
	- Criar debounce por chave (string, número, instância, etc.)
	- Definir duração personalizada
	- Verificar se já pode executar novamente
	- Esperar até liberar

	Uso comum:
	- Evitar spam de eventos
	- Controlar cooldown de habilidades
	- Evitar múltiplos cliques rápidos
]]

-- Tabela principal do módulo
local Debounce = {}

-- Tabela interna que armazena as chaves ativas
-- Estrutura:
-- _keys[key] = tempo_em_que_expira
Debounce._keys = {}



-- =========================================================
-- Adiciona uma chave ao debounce
-- =========================================================
function Debounce:Add(key: any, duration: number?): ()
	
	-- Se não for passada duração, usa 1 segundo como padrão
	local duration: number = duration or 1
	
	-- Armazena o tempo atual + duração
	-- tick() retorna o tempo atual em segundos
	self._keys[key] = tick() + duration
end



-- =========================================================
-- Remove manualmente uma chave
-- =========================================================
function Debounce:Remove(key: any): ()
	
	-- Remove a chave da tabela
	self._keys[key] = nil
end



-- =========================================================
-- Verifica se a chave pode ser usada novamente
-- =========================================================
function Debounce:Check(key: any): boolean
	
	-- Se:
	-- 1) A chave não existe
	-- OU
	-- 2) O tempo atual já passou do tempo armazenado
	if not self._keys[key] or tick() >= self._keys[key] then
		
		-- Remove a chave (limpeza automática)
		self._keys[key] = nil
		
		-- Pode executar
		return true
	else
		
		-- Ainda está em cooldown
		return false
	end
end



-- =========================================================
-- Espera até o debounce liberar
-- =========================================================
function Debounce:WaitFor(key: any): ()
	
	-- Enquanto Check retornar falso,
	-- espera um frame
	while not self:Check(key) do
		task.wait()
	end
end



-- Retorna o módulo
return Debounce
