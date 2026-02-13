# Debounce.lua

Simple and reusable debounce handler for Roblox (Luau).

Prevents repeated execution of actions using custom keys.

---

## Installation

1. Create a `ModuleScript`
2. Name it `Debounce`
3. Paste the module code inside
4. Require it in your script:

```lua
local Debounce = require(path.to.Debounce)
```

---

## Usage

### Create an instance

```lua
local Debounce = require(path.to.Debounce)

local db = Debounce.new()
```

### Basic cooldown example

```lua
if db:Check(player) then
    db:Add(player, 2) -- 2 seconds cooldown
    print("Action executed")
end
```

---

## Example with Touched

```lua
local Debounce = require(path.to.Debounce)
local db = Debounce.new()

workspace.Part.Touched:Connect(function(hit)
    local character = hit.Parent
    local player = game.Players:GetPlayerFromCharacter(character)
    if not player then return end

    if db:Check(player) then
        db:Add(player, 3)
        print(player.Name .. " activated the part")
    end
end)
```

---

## API

### `Debounce.new()`
Creates a new debounce instance.

### `:Add(key, duration?)`
Adds a key with a cooldown (default = 1 second).

### `:Check(key)`
Returns `true` if the key can execute.

### `:Remove(key)`
Removes a key manually.

### `:WaitFor(key)`
Waits until the key is available again.
