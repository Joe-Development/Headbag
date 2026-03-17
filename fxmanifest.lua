fx_version 'cerulean'
games { 'gta5' }
author 'JoeV2@Freech\'s Development'
description 'A Simple Optimized Headbag Script for standalone servers'
version '1.2.1'
lua54 'yes'

ui_page 'html/index.html'

shared_scripts {
    'shared/bridge.lua'
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

data_file 'DLC_ITYP_REQUEST' 'stream/prop_headbag.ytyp'
