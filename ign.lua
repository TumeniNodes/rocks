--
-- Igneous Layer
--

-- Basalt       Ex/Mafic   hard  same as diorite, byt limit=0.5
minetest.register_node( "rocks:basalt", {  
	description = S("Basalt"),
	tiles = { "rocks_Basalt.png" },
	groups = {cracky=3, stone=1}, 
	is_ground_content = true, sounds = default.node_sound_stone_defaults(),
})
minetest.register_alias("mapgen_stone", "rocks:basalt")

-- ^ does not work. Seems we can not overwrite an alias.
-- If the alias in default/mapgen.lua is deleted, this works.

-- more rock defs
minetest.register_node( "rocks:granite", {  
	description = S("Granite"),
	tiles = { "rocks_Granite.png" },
	is_ground_content = true, sounds = default.node_sound_stone_defaults(),
	groups = {cracky=3, stone=1}, 
})
minetest.register_node( "rocks:diorite", {  
	description = S("Diorite"),
	tiles = { "rocks_Diorite.png" },
	groups = {cracky=3, stone=1}, 
	is_ground_content = true, sounds = default.node_sound_stone_defaults(),
})
minetest.register_node( "rocks:gabbro", {  
	description = S("Gabbro"),
	tiles = { "rocks_Gabbro.png" },
	groups = {cracky=3, stone=1}, 
	is_ground_content = true, sounds = default.node_sound_stone_defaults(),
})

local reg=function(name,param)
 minetest.register_ore({
   ore    = name,
   wherein= { "mapgen_stone" },
   ore_type       = "scatter",
   clust_scarcity = 10^3,
   clust_num_ores = 20^3,
   clust_size     = 20,
   height_min     = -31000,
   height_max     = -5,
   noise_treshhold=param.treshold,
   noise_params={
          offset = 0, scale = 1, octaves = 3, persist = 0.5,
          spread = {x=param.spread, y=param.height, z=param.spread},
          seed=rocksl.GetNextSeed(),
        },
        })
end
rocks.register_igneous_stratus=reg

-- rock registration
 reg("rocks:granite", { spread=40, height=32, treshold=0.06})
 reg("rocks:diorite", { spread=40, height=32, treshold=0.23})
 reg("rocks:gabbro",  { spread=40, height=32, treshold=0.36})

-- vein stuff

local regv=function(name,param)
 minetest.log("error","stub called, rocks.register_vein")
 minetest.register_ore({
   ore    = name,
   wherein= param.wherein,
   ore_type       = "blob",
   clust_scarcity = param.rarity^3,
   clust_num_ores = 8,
   clust_size     = 10*2,
   height_min     = -31000,
   height_max     = 50,
   noise_threshhold = 0.5, --< determined experimentally
   noise_params={
          offset = 1-param.radius.amplitude, scale = param.radius.amplitude, octaves = 3, persist = 0.5,
          spread = {x=param.radius.frequency, y=param.radius.frequency, z=param.radius.frequency},
          seed=rocksl.GetNextSeed(),
        },
  })
end

rocks.register_vein=regv

rocks.register_vein("default:nyancat",{
  wherein={"rocks:granite", "air"},
  miny=-160, maxy=20,
  radius={ average=10, amplitude=0.1, frequency=8 },
  density=100,
  rarity=70, -- this^3*mapblock_volume veins per mapblock
  ores={
    { ore="default:sand", percent=30 },
    { ore="default:dirt", percent=30 },
  }
  })


-- ~ Tomas Brod