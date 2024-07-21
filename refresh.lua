
-----------------------------------------------------------------------------------
--Name: load_user_files()
--Args:
---- None
-----------------------------------------------------------------------------------
--Returns:
---- user_env, a table of all of the player defined functions and their current
---- variables.
-----------------------------------------------------------------------------------
function load_user_files()
    local player_name = windower.ffxi.get_player().name
    local player_main_job = windower.ffxi.get_player().main_job
    local file_name = player_main_job:lower() .. '.lua'
    local path
    path = pathsearch({file_name}, player_name)
    if not path then
        local dir = windower.addon_path .. 'data/' .. player_name

        -- create the directory and file if it doesn't exist
        if not windower.dir_exists(dir) then
            windower.add_to_chat(207, 'Exemplar: Creating new directory for ' .. player_name .. ' at ' .. dir)
            windower.create_dir(dir)
        end
        path = dir .. '/' .. file_name
        local file = io.open(path, "w")

        if file then
            windower.add_to_chat(207, 'Exemplar: Created new file for ' .. player_name .. ' at ' .. path)
            file:close()
        else
            print("Could not create file at path: " .. file_path)
        end
        -- inform the user that we successfully created the file
        
    end
end


-----------------------------------------------------------------------------------
--Name: pathsearch()
--Args:
---- files_list - table of strings of the file name to search.
-----------------------------------------------------------------------------------
--Returns:
---- path of a valid file, if it exists. False if it doesn't.
-----------------------------------------------------------------------------------
function pathsearch(files_list, player_name)

    -- base directory search order:
    -- windower
    -- %appdata%/Windower/GearSwap

    -- sub directory search order:
    -- libs-dev (only in windower addon path)
    -- libs (only in windower addon path)
    -- data/player.name
    -- data/common
    -- data

    local gearswap_data = windower.addon_path .. 'data/'
    local gearswap_appdata = (os.getenv('APPDATA') or '') .. '/Windower/GearSwap/'

    local search_path = {
        [1] = windower.addon_path .. 'libs-dev/',
        [2] = windower.addon_path .. 'libs/',
        [3] = gearswap_data .. player_name .. '/',
        [4] = gearswap_data .. 'common/',
        [5] = gearswap_data,
        [6] = gearswap_appdata .. player_name .. '/',
        [7] = gearswap_appdata .. 'common/',
        [8] = gearswap_appdata,
        [9] = windower.windower_path .. 'addons/libs/'
    }

    local user_path
    local normal_path

    for _,basepath in ipairs(search_path) do
        if windower.dir_exists(basepath) then
            for i,v in ipairs(files_list) do
                if v ~= '' then
                    if include_user_path then
                        user_path = basepath .. include_user_path .. '/' .. v
                    end
                    normal_path = basepath .. v

                    if user_path and windower.file_exists(user_path) then
                        return user_path,basepath,v
                    elseif normal_path and windower.file_exists(normal_path) then
                        return normal_path,basepath,v
                    end
                end
            end
        end
    end

    return false
end
