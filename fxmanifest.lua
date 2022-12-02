fx_version 'bodacious'
game 'gta5'

name "RollDice"
description "An optimised and standalone RollDice system for FiveM."
author "SpecialStos"
version "1.0.0"

client_scripts {
    'config.lua',
    'client.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'config.lua',
    'server.lua',
}

