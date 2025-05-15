	local function DebugPrint(...)
		if Config.Debug then print(...) end
	end

	local ESX = exports['es_extended']:getSharedObject()
	local cooldowns = {}

	local function L(str, ...) 
		if _L then return _L(str, ...) end
		return string.format(str, ...)
	end

	RegisterNetEvent('crafting:craftItem', function(recipe, identifier)
		DebugPrint("craftItem event received from", source)
		local src = source
		local xPlayer = ESX.GetPlayerFromId(src)
		if not xPlayer then
			DebugPrint("xPlayer not found for source", src)
			return
		end

		cooldowns[src] = cooldowns[src] or {}
		local cooldown = recipe.Cooldown or 10
		local id = identifier or (recipe.result and recipe.result.name) or "default"
		if cooldowns[src][id] and os.time() < cooldowns[src][id] then
			TriggerClientEvent('crafting:notify', src, 'error', L('You must wait before crafting this again.'))
			DebugPrint("Cooldown active for", src, "on recipe", id)
			return
		end

		-- Check ingredients
		for _, ing in ipairs(recipe.ingredients) do
			local have = exports.ox_inventory:GetItem(src, ing.name, nil, true)
			DebugPrint("Checking ingredient", ing.name, "needed:", ing.count, "have:", have)
			if have < ing.count then
				TriggerClientEvent('crafting:notify', src, 'error', L('You are missing: %s', ing.name))
				DebugPrint("Missing ingredient", ing.name)
				return
			end
		end

		-- Remove ingredients
		for _, ing in ipairs(recipe.ingredients) do
			if ing.remove == nil or ing.remove == true then
				local removed = exports.ox_inventory:RemoveItem(src, ing.name, ing.count)
				DebugPrint("Removed", ing.count, ing.name, "from player", src, "success:", removed)
				if not removed then
					TriggerClientEvent('crafting:notify', src, 'error', L('Failed to remove ingredient: %s', ing.name))
					return
				end
			else
				DebugPrint("Did not remove ingredient (tool):", ing.name)
			end
		end

		-- Add result
		local added = exports.ox_inventory:AddItem(src, recipe.result.name, recipe.result.count or 1)
		DebugPrint("Added", recipe.result.count or 1, recipe.result.name, "to player", src, "success:", added)
		if not added then
			TriggerClientEvent('crafting:notify', src, 'error', L('Failed to add crafted item!'))
			return
		end

		cooldowns[src][id] = os.time() + cooldown
		TriggerClientEvent('crafting:notify', src, 'success', L('Crafted: %s', recipe.result.label or recipe.result.name))
	end)

	AddEventHandler('playerDropped', function(reason)
		cooldowns[source] = nil
	end)
