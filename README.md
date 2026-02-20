# Roblox Utils

Utility modules for Roblox (Luau).

---

## Modules

### Debounce

Simple cooldown handler.

```lua
local Debounce = require(path.to.Debounce)
local db = Debounce.new()

if db:Check(player) then
    db:Add(player, 2)
end
```

### CheckpointService

Lightweight stage and respawn system for Roblox.

Handles:
- Stage progression
- Respawn positioning
- DataStore saving
- Anti-skip validation
