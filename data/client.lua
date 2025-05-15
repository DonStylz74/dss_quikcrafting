	local function DebugPrint(...)
		if Config.Debug then print(...) end
	end

	local function playAnimation(anim)
		if not anim or not anim.dict or not anim.name then return end
		RequestAnimDict(anim.dict)
		while not HasAnimDictLoaded(anim.dict) do Wait(10) end
		TaskPlayAnim(PlayerPedId(), anim.dict, anim.name, 1.0, 1.0, anim.time or -1, anim.flag or 49, 0, false, false, false)
	end

	local function spawnProp(prop)
		if not prop or not prop.model then return nil end
		local ped = PlayerPedId()
		local obj

		RequestModel(prop.model)
		local timer = 0
		while not HasModelLoaded(prop.model) and timer < 5000 do Wait(10) timer = timer + 10 end
		if not HasModelLoaded(prop.model) then
			DebugPrint("Failed to load prop model:", tostring(prop.model))
			return nil
		end

		if prop.inHand then
			obj = CreateObject(prop.model, 0.0, 0.0, 0.0, true, true, false)
			local bone = prop.bone or 57005 -- default: hand
			local offset = prop.offset or vector3(0.1, 0.0, 0.0)
			local rotation = prop.rotation or vector3(0.0, 0.0, 0.0)
			AttachEntityToEntity(obj, ped, GetPedBoneIndex(ped, bone), offset.x, offset.y, offset.z, rotation.x, rotation.y, rotation.z, true, true, false, true, 1, true)
		else
			local coords = GetEntityCoords(ped)
			local forward = GetEntityForwardVector(ped)
			local spawnDist = prop.distance or 0.5
			local spawnCoords = coords + (forward * spawnDist)
			obj = CreateObject(prop.model, spawnCoords.x, spawnCoords.y, spawnCoords.z, true, true, false)
			SetEntityHeading(obj, GetEntityHeading(ped))
			PlaceObjectOnGroundProperly(obj)
			return obj, spawnCoords
		end
		return obj, nil -- if in hand, no coords needed
	end

	local function clearAnimation()
		ClearPedTasks(PlayerPedId())
	end

	function StartCrafting(recipe)
		-- Minigame first
		if recipe.useminigame or recipe.UseMinigame then
			local difficulties = recipe.minigamedifficulty or recipe.MinigameDifficulty or {"easy"}
			DebugPrint("Running minigame with difficulties:", json.encode(difficulties))
			local passed = lib.skillCheck(difficulties)
			if not passed then
				DebugPrint("Skill check failed")
				lib.notify({type = 'error', description = 'You failed the skill check!'})
				return
			end
		end

		-- Animation/Prop
		if recipe.animation then
			DebugPrint("Playing animation:", recipe.animation.dict, recipe.animation.name)
			playAnimation(recipe.animation)
		end
		local propEntity
		if (recipe.useprop == nil or recipe.useprop == true) and recipe.prop then
			propEntity = spawnProp(recipe.prop)
		end

		-- Progress bar/circle
		local duration = recipe.animation and recipe.animation.time or 8000
		local label = recipe.result and ("Crafting " .. (recipe.result.label or recipe.result.name)) or "Crafting..."
		local progressType = recipe.ProgressType or recipe.progresstype or "bar"
		local progressPosition = recipe.progressposition or Config.DefaultProgressPosition or "bottom"
		DebugPrint("Showing progress", progressType, "for", duration, "ms at", progressPosition)
		local progressSuccess
		if progressType == "circle" then
			progressSuccess = lib.progressCircle({
				duration = duration,
				label = label,
				useWhileDead = false,
				canCancel = true,
				disable = { move = true, car = true, combat = true },
				position = progressPosition
			})
		else
			progressSuccess = lib.progressBar({
				duration = duration,
				label = label,
				useWhileDead = false,
				canCancel = true,
				disable = { move = true, car = true, combat = true },
				position = progressPosition
			})
		end

		if not progressSuccess then
			DebugPrint("Crafting cancelled by user")
			lib.notify({type = 'error', description = 'Crafting cancelled!'})
			if propEntity and DoesEntityExist(propEntity) then DeleteEntity(propEntity) end
			clearAnimation()
			return
		end

		-- Clean up
		if propEntity and DoesEntityExist(propEntity) then DeleteEntity(propEntity) end
		DebugPrint("Deleting prop entity")
		clearAnimation()

		-- Actually craft the item (call server)
		DebugPrint("Triggering server event crafting:craftItem for recipe:", recipe and recipe.result and recipe.result.name or "unknown")
		TriggerServerEvent('crafting:craftItem', recipe)
	end

	RegisterNetEvent('crafting:startCraftingFromItem', function(item, slot, data)
		DebugPrint("Event: crafting:startCraftingFromItem | item:", item and item.name, "slot:", slot, "data:", json.encode(data))
		for _, recipe in ipairs(Config.Recipes) do
			if recipe.usableItem == item.name then
				DebugPrint("Found recipe for usableItem:", item.name)
				StartCrafting(recipe)
				return
			end
		end
		DebugPrint("No crafting recipe found for usableItem:", item and item.name)
		lib.notify({type = 'error', description = 'No crafting recipe found for this item!'})
	end)

	RegisterNetEvent('crafting:startCrafting', function(recipe)
		DebugPrint("Event: crafting:startCrafting | recipe:", recipe and recipe.result and recipe.result.name or "unknown")
		DebugPrint("StartCrafting called for recipe:", recipe and recipe.result and recipe.result.name or "unknown")
		StartCrafting(recipe)
	end)

	RegisterNetEvent('crafting:notify', function(type, msg)
		lib.notify({type = type, description = msg})
	end)
