fx_version 'cerulean'
game 'gta5'

author 'CodingFleet'
description 'Crafting system using recipes, ESX, ox_inventory, ox_lib'
version '1.0.0'

lua54 'yes'

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua',
    'locale/locale.lua'
}

client_scripts {
    'data/client.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'data/server.lua'
}

dependencies {
    'es_extended',
    'ox_inventory',
    'ox_lib'
}