fx_version 'cerulean'
games { 'gta5' }
author 'JoeV2@Freech\'s Development'
description 'A Simple Optimized Headbag Script for standalone servers'
version '1.0.0'
lua54 'yes'

ui_page 'html/index.html'

shared_scripts {
    '@ox_lib/init.lua'
}

client_scripts {
    'client/client.lua'
}

server_scripts {
    'config.lua',
    'server/server.lua'
}

files {
    'html/index.html',
    'html/js/script.js',
    'html/css/style.css',
    'html/img/*',
    'html/audio/headbag.mp3'
}

dependency 'ox_lib'

data_file 'DLC_ITYP_REQUEST' 'stream/prop_headbag.ytyp'