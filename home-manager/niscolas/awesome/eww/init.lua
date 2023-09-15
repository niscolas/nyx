local awful = require("awful")
local naughty = require("naughty")
local pl = require("pl.import_into")()

local function update_eww_workspaces_widget()
    local cache_dir = os.getenv("XDG_CACHE_HOME")
        or (os.getenv("HOME") .. "/.cache")
    local log_file_path = cache_dir .. "/eww_workspaces"
    local log_file = io.open(log_file_path, "a")

    if not log_file then
        return
    end

    local not_focused_icon = ""
    local focused_icon = ""

    local log =
        "(box :class 'workspaces-content' :spacing 12 :space-evenly 'false'"

    local tags = awful.screen.focused().tags
    for _, t in ipairs(tags) do
        local workspace_icon = not_focused_icon
        local classes = "workspace "

        local is_urgent = false
        for _, c in ipairs(t:clients()) do
            is_urgent = c.urgent
            if is_urgent then
                break
            end
        end

        if #t:clients() > 0 then
            classes = classes .. "workspace-occupied "
        elseif is_urgent then
            classes = classes .. "workspace-urgent "
        else
            classes = classes .. "workspace-unoccupied "
        end

        local is_focused = pl.tablex.find(
            awful.screen.focused().selected_tags,
            t
        ) ~= nil

        if is_focused then
            classes = classes .. "workspace-focused "
            workspace_icon = focused_icon
        end

        log = log
            .. "(button "
            .. string.format(":onclick 'notify-send %s' ", t.name)
            .. string.format(":class '%s' ", classes)
            .. string.format("'%s' ) ", workspace_icon)
    end

    log = log .. ")\n"

    log_file:write(log)
    log_file:close()
end

tag.connect_signal("property::selected", function()
    update_eww_workspaces_widget()
end)

client.connect_signal("focus", function()
    update_eww_workspaces_widget()
end)

client.connect_signal("unfocus", function()
    update_eww_workspaces_widget()
end)

client.connect_signal("manage", function(c)
    update_eww_workspaces_widget()
end)
