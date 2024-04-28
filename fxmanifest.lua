
Author "Fezco"
description "Loods"
fx_version 'cerulean'
game 'gta5'
lua54 'yes'

shared_scripts {'@ox_lib/init.lua'}

client_scripts {
    'config.lua',
    'client/main.lua'
}
server_scripts {
    'config.lua',
    '@mysql-async/lib/MySQL.lua',
    'server/main.lua'
}
escrow_ignore {
    'config.lua'
}
dependency '/assetpacks'