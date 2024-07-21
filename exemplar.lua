_addon.name = 'Exemplar'
_addon.version = '0.0.0'
_addon.author = 'onedough83'
_addon.commands = {'ep','exe','exemplar'}

require 'refresh'

windower.register_event('addon command',function (...)
    -- setup the player load_user_files
    load_user_files()
end)