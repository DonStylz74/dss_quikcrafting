	Locales = {}

	Locales['en'] = {
		crafting = "Crafting...",
		crafting_success = "You crafted: %s",
		crafting_failed = "Crafting failed!",
		missing_ingredients = "You don't have the required ingredients.",
		cooldown = "You must wait before crafting again.",
		cannot_craft = "You can't craft right now.",
		minigame_failed = "You failed the minigame!",
		dead = "You can't craft while dead.",
		incar = "You can't craft in a vehicle."
	}

	function _L(key, ...)
		local str = Locales['en'][key] or key
		return string.format(str, ...)
	end
