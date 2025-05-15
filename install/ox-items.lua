-- ox item formats

-- usable items - 
------------------
		['water_refill'] = {
			label = 'Water Refill',
			weight = 100,
			stack = true,
			close = true,
			description = 'Water refill  item',
			client = {
				event = 'crafting:startCraftingFromItem',
				image = "water_refill.png"
			}
		},

	['rollpapers'] = {
		label = 'Rolling Papers',
		stack = true,
		weight = 5,
    	close = false,
    	description = "Pack of 6 rolling papers.",
		client = {
			event = 'crafting:startCraftingFromItem',
			image = "rollpapers.png"
		}
	},


-- basic items - 
-----------------
		  ["wateringcan_empty"] = {
			label = "Empty Watering Can",
			weight = 250,
			stack = true,
			close = false,
			description = "Empty watering can",
			client = {
				image = "wateringcan_empty.png",
			}
		  },

		["watering_can"] = {
			label = "Watering Can",
			weight = 500,
			stack = true,
			close = false,
			description = "Use this Watering Can to water plants.",
			client = {
				image = "watering_can.png",
			}
		},

	["rollpaper"] = {
		label = "Rolling Paper",
		weight = 1,
		stack = true,
		close = false,
		description = "Paper used for making joints.",
		client = {
			image = "rollpaper.png",
		}
	},