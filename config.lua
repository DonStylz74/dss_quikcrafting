	Config = {}

	Config.Debug = false -- Set to false to disable debug prints

	Config.DefaultProgressPosition = "bottom" -- options: "bottom", "top", "left", "right", "middle"

	Config.Recipes = {
		{
			result = { name = "watering_can", label = "Watering Can", count = 1 },  --  crafting output item
			ingredients = {
				{ name = "water_refill", count = 1, remove = true },  --  Required items 
				{ name = "wateringcan_empty", count = 1, remove = true }
			},
			usableItem = "water_refill",   --  item to be used to start item crafting
			allowVehicle = false,  --  allow crafting in vehicle true or false.
			animation = {
				dict = "amb@world_human_gardener_plant@male@base",
				name = "base",
				time = 8000,
				flag = 1  -- 1 = Full body anim  -  49 = upper body only
			},
			prop = {
				model = `prop_wateringcan`,
				inHand = false, -- tru for prop in hand or false for prop on ground
				bone = 57005,  -- optional, default: hand
				offset = vector3(0.1, 0.0, 0.0), -- optional
				rotation = vector3(0.0, 0.0, 0.0) -- optional
			},
			Cooldown = 10, -- seconds
			ProgressType = "circle", -- progress type "bar" or "circle"
			progressposition = "bottom", -- override per recipe (optional)
			UseMinigame = true,  --  skill test to create item
			MinigameDifficulty = { "easy", "easy", "easy" },
			SpawnProp = true
		},

		{
			result = { name = "rollpaper", label = "Rolling Paper", count = 6 },
			ingredients = {
				{ name = "rollpapers", count = 1,  remove = true  }
			},
			usableItem = "rollpapers",
			allowVehicle = true,
			animation = {
				dict = "missheistfbisetup1",
				name = "hassle_intro_loop_f",
				time = 4000,
				flag = 49  -- 1 = Full body anim  -  49 = upper body only
			},
			useprop = false,  --  use a prop true or false
			prop = {
				model = `prop_sh_joint_01`,  -- prop name
				inHand = true, -- true prop in hand - false on ground
				bone = 57005,  -- optional, default: hand
				offset = vector3(0.1, 0.0, 0.0), -- optional
				rotation = vector3(0.0, 0.0, 0.0) -- optional
			},
			Cooldown = 8, -- seconds
			ProgressType = "circle", -- "bar" or "circle"
			progressposition = "bottom", -- override per recipe (optional)
			UseMinigame = true,
			MinigameDifficulty = { "easy", "easy", "easy" },
			SpawnProp = true
		}

		-- Add more recipes here, with their own settings

	--[[
 --  ITEM TEMPLATE  -- 
		{
			result = { name = "watering_can", label = "Watering Can", count = 1 },
			ingredients = {
				{ name = "water_refill", count = 1 },
				{ name = "wateringcan_empty", count = 1 }
			},
			usableItem = "water_refill",
			animation = {
				dict = "amb@medic@standing@tendtodead@idle_a",
				name = "idle_a",
				time = 8000,
				flag = 1  -- 1 = Full body anim  -  49 = upper body only
			},
			prop = {
				model = `prop_wateringcan`,
				inHand = false, -- or false for on ground
				bone = 57005,  -- optional, default: hand
				offset = vector3(0.1, 0.0, 0.0), -- optional
				rotation = vector3(0.0, 0.0, 0.0) -- optional
			},
			Cooldown = 10, -- seconds
			ProgressType = "circle", -- "bar" or "circle"
			progressposition = "bottom", -- override per recipe (optional)
			UseMinigame = true,
			MinigameDifficulty = { "easy", "easy", "medium" },
			SpawnProp = true
		},
	]]--

	}
