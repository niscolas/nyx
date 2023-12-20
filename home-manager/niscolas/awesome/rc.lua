pcall(require, "luarocks.loader")

local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")

local beautiful = require("beautiful")
local naughty = require("naughty")
local hotkeys_popup = require("awful.hotkeys_popup")
require("awful.hotkeys_popup.keys")

local command_executed = false

_G.spawn = awful.spawn
_G.shell = spawn.with_shell

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify {
        preset = naughty.config.presets.critical,
        title = "Oops, there were errors during startup!",
        text = awesome.startup_errors,
    }
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function(err)
        -- Make sure we don't go into an endless error loop
        if in_error then
            return
        end
        in_error = true

        naughty.notify {
            preset = naughty.config.presets.critical,
            title = "Oops, an error happened!",
            text = tostring(err),
        }
        in_error = false
    end)
end
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
beautiful.init("/home/niscolas/.config/awesome/themes/gruvbox.lua")

-- This is used later as the default terminal and editor to run.
terminal = "alacritty"
terminal_cmd = terminal .. " -e "
editor = os.getenv("EDITOR") or "nvim"
editor_cmd = terminal_cmd .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
    awful.layout.suit.tile,
    awful.layout.suit.spiral,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max,
    awful.layout.suit.max.fullscreen,
    awful.layout.suit.magnifier,
    awful.layout.suit.corner.nw,
    awful.layout.suit.floating,
    awful.layout.suit.corner.ne,
    awful.layout.suit.corner.sw,
    awful.layout.suit.corner.se,
}
-- }}}

local function set_wallpaper(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(function(s)
    set_wallpaper(s)

    awful.tag(
        { "1", "2", "3", "4", "5", "6", "7", "8", "9" },
        s,
        awful.layout.layouts[1]
    )
end)
-- }}}

-- {{{ Key bindings
globalkeys = gears.table.join(
    awful.key(
        { modkey },
        "s",
        hotkeys_popup.show_help,
        { description = "show help", group = "awesome" }
    ),

    awful.key(
        { modkey },
        "Escape",
        awful.tag.history.restore,
        { description = "go back", group = "tag" }
    ),

    awful.key({ modkey }, "h", function()
        awful.client.focus.global_bydirection("left")
    end, { description = "focus next by index", group = "client" }),

    awful.key({ modkey }, "j", function()
        awful.client.focus.global_bydirection("down")
    end, { description = "focus next by index", group = "client" }),

    awful.key({ modkey }, "k", function()
        awful.client.focus.global_bydirection("up")
    end, { description = "focus previous by index", group = "client" }),

    awful.key({ modkey }, "l", function()
        awful.client.focus.global_bydirection("right")
    end, { description = "focus previous by index", group = "client" }),

    -- Layout manipulation
    -- Swap
    awful.key({ modkey, "Shift" }, "h", function()
        awful.client.swap.global_bydirection("left")
    end, { description = "swap with left client", group = "client" }),

    awful.key({ modkey, "Shift" }, "j", function()
        awful.client.swap.global_bydirection("down")
    end, { description = "swap with down client", group = "client" }),

    awful.key({ modkey, "Shift" }, "k", function()
        awful.client.swap.global_bydirection("up")
    end, { description = "swap with up client", group = "client" }),

    awful.key({ modkey, "Shift" }, "l", function()
        awful.client.swap.global_bydirection("right")
    end, { description = "swap with right client", group = "client" }),

    -- Focus
    awful.key({ modkey, "Control" }, "h", function()
        awful.screen.focus_bydirection("left")
    end, { description = "focus the left screen", group = "screen" }),

    awful.key({ modkey, "Control" }, "j", function()
        awful.screen.focus_bydirection("down")
    end, { description = "focus the down screen", group = "screen" }),

    awful.key({ modkey, "Control" }, "k", function()
        awful.screen.focus_bydirection("up")
    end, { description = "focus the up screen", group = "screen" }),

    awful.key({ modkey, "Control" }, "l", function()
        awful.screen.focus_bydirection("right")
    end, { description = "focus the right screen", group = "screen" }),

    -- Urgent
    awful.key(
        { modkey },
        "u",
        awful.client.urgent.jumpto,
        { description = "jump to urgent client", group = "client" }
    ),

    awful.key({ modkey }, "Tab", function()
        awful.client.focus.history.previous()
        if client.focus then
            client.focus:raise()
        end
    end, { description = "go back", group = "client" }),

    -- Standard programs
    awful.key({ modkey }, "Return", function()
        awful.spawn(terminal)
    end, { description = "open a terminal", group = "launcher" }),

    awful.key(
        { modkey, "Control" },
        "r",
        awesome.restart,
        { description = "reload awesome", group = "awesome" }
    ),

    awful.key(
        { modkey, "Shift" },
        "q",
        awesome.quit,
        { description = "quit awesome", group = "awesome" }
    ),

    awful.key({ modkey, "Mod1" }, "l", function()
        awful.tag.incmwfact(0.05, awful.screen.focused().selected_tag)
    end, { description = "increase master width factor", group = "layout" }),

    awful.key({ modkey, "Mod1" }, "h", function()
        awful.tag.incmwfact(-0.05, awful.screen.focused().selected_tag)
    end, { description = "decrease master width factor", group = "layout" }),

    -- awful.key({ modkey, "" }, "h", function()
    --     awful.tag.incnmaster(1, nil, true)
    -- end, {
    --     description = "increase the number of master clients",
    --     group = "layout",
    -- }),
    --
    -- awful.key({ modkey, "Shift" }, "l", function()
    --     awful.tag.incnmaster(-1, nil, true)
    -- end, {
    --     description = "decrease the number of master clients",
    --     group = "layout",
    -- }),

    -- awful.key({ modkey, "Control" }, "h", function()
    --     awful.tag.incncol(1, nil, true)
    -- end, { description = "increase the number of columns", group = "layout" }),
    --
    -- awful.key({ modkey, "Control" }, "l", function()
    --     awful.tag.incncol(-1, nil, true)
    -- end, { description = "decrease the number of columns", group = "layout" }),

    awful.key({ modkey, "Control" }, "n", function()
        awful.layout.inc(1)
        naughty.notify { title = tostring(awful.layout.getname()) }
    end, { description = "select next", group = "layout" }),

    -- awful.key({ modkey, "Shift" }, "space", function()
    --     awful.layout.inc(-1)
    -- end, { description = "select previous", group = "layout" }),
    --

    awful.key({ modkey, "Control" }, "n", function()
        local c = awful.client.restore()
        -- Focus restored client
        if c then
            c:emit_signal(
                "request::activate",
                "key.unminimize",
                { raise = true }
            )
        end
    end, { description = "restore minimized", group = "client" }),

    awful.key({ modkey }, "space", function()
        shell("~/.config/rofi/launchers/type-3/launcher.sh")
    end, { description = "show the app launcher", group = "launcher" }),

    awful.key({ modkey, "Shift" }, "p", function()
        shell("~/.config/rofi/powermenu/type-2/powermenu.sh")
    end, { description = "show the power menu", group = "launcher" }),

    awful.key({ modkey, "Shift" }, "x", function()
        shell("flameshot gui")
    end, { description = "show flameshot", group = "launcher" }),

    awful.key({ modkey, "Shift" }, ",", function()
        shell("keyboard_swap_layout.nu")
    end, { description = "swap keyboard layout", group = "launcher" }),

    awful.key({ modkey }, "z", function()
        local current_tag = awful.screen.focused().selected_tag

        -- Get all the clients with the specific tag
        local clients_with_tag = current_tag:clients()

        -- Print the clients
        for _, c in ipairs(clients_with_tag) do
            naughty.notify {
                title = "Client",
                text = c.class,
                timeout = 5,
            }
        end
        -- Put the code snippet here
    end, { description = "Print clients with specific tag", group = "tag" })
)

clientkeys = gears.table.join(
    awful.key({ modkey }, "f", function(c)
        c.fullscreen = not c.fullscreen
        c:raise()
    end, { description = "toggle fullscreen", group = "client" }),

    awful.key({ modkey }, "q", function(c)
        c:kill()
    end, { description = "close", group = "client" }),

    awful.key(
        { modkey, "Control" },
        "space",
        awful.client.floating.toggle,
        { description = "toggle floating", group = "client" }
    ),

    awful.key({ modkey, "Control" }, "Return", function(c)
        c:swap(awful.client.getmaster())
    end, { description = "move to master", group = "client" }),

    awful.key({ modkey }, "o", function(c)
        c:move_to_screen()
    end, { description = "move to screen", group = "client" }),

    awful.key({ modkey }, "t", function(c)
        c.ontop = not c.ontop
    end, { description = "toggle keep on top", group = "client" }),

    -- awful.key({ modkey }, "n", function(c)
    --     -- The client currently has the input focus, so it cannot be
    --     -- minimized, since minimized clients can't have the focus.
    --     c.minimized = true
    -- end, { description = "minimize", group = "client" }),

    awful.key({ modkey }, "m", function(c)
        c.maximized = not c.maximized
        c:raise()
    end, { description = "(un)maximize", group = "client" }),

    awful.key({ modkey, "Control" }, "m", function(c)
        c.maximized_vertical = not c.maximized_vertical
        c:raise()
    end, { description = "(un)maximize vertically", group = "client" }),

    awful.key({ modkey, "Shift" }, "m", function(c)
        c.maximized_horizontal = not c.maximized_horizontal
        c:raise()
    end, { description = "(un)maximize horizontally", group = "client" })
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = gears.table.join(
        globalkeys,

        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9, function()
            local screen = awful.screen.focused()
            local tag = screen.tags[i]
            if tag then
                tag:view_only()
            end
        end, { description = "view tag #" .. i, group = "tag" }),

        -- Toggle tag display.
        awful.key({ modkey, "Control" }, "#" .. i + 9, function()
            local screen = awful.screen.focused()
            local tag = screen.tags[i]
            if tag then
                awful.tag.viewtoggle(tag)
            end
        end, { description = "toggle tag #" .. i, group = "tag" }),

        -- Move client to tag.
        awful.key(
            { modkey, "Shift" },
            "#" .. i + 9,
            function()
                if client.focus then
                    local tag = client.focus.screen.tags[i]
                    if tag then
                        client.focus:move_to_tag(tag)
                    end
                end
            end,
            { description = "move focused client to tag #" .. i, group = "tag" }
        ),

        -- Toggle tag on focused client.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9, function()
            if client.focus then
                local tag = client.focus.screen.tags[i]
                if tag then
                    client.focus:toggle_tag(tag)
                end
            end
        end, {
            description = "toggle focused client on tag #" .. i,
            group = "tag",
        })
    )
end

clientbuttons = gears.table.join(
    awful.button({}, 1, function(c)
        c:emit_signal("request::activate", "mouse_click", { raise = true })
    end),
    awful.button({ modkey }, 1, function(c)
        c:emit_signal("request::activate", "mouse_click", { raise = true })
        awful.mouse.client.move(c)
    end),
    awful.button({ modkey }, 3, function(c)
        c:emit_signal("request::activate", "mouse_click", { raise = true })
        awful.mouse.client.resize(c)
    end)
)

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    {
        rule = {},
        properties = {
            border_width = beautiful.border_width,
            border_color = beautiful.border_normal,
            focus = awful.client.focus.filter,
            raise = true,
            keys = clientkeys,
            buttons = clientbuttons,
            screen = awful.screen.preferred,
            placement = awful.placement.no_overlap
                + awful.placement.no_offscreen,
        },
    },

    -- Floating clients.
    {
        rule_any = {
            instance = {
                "DTA", -- Firefox addon DownThemAll.
                "copyq", -- Includes session name in class.
                "pinentry",
            },
            class = {
                "Arandr",
                "Blueman-manager",
                "Gpick",
                "Kruler",
                "MessageWin", -- kalarm.
                "Sxiv",
                "Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
                "Wpa_gui",
                "Yad",
                "veromix",
                "xtightvncviewer",
                "yad",
            },

            -- Note that the name property shown in xprop might be set slightly after creation of the client
            -- and the name shown there might not match defined rules here.
            name = {
                "Event Tester", -- xev.
            },
            role = {
                "AlarmWindow", -- Thunderbird's calendar.
                "ConfigManager", -- Thunderbird's about:config.
                "pop-up", -- e.g. Google Chrome's (detached) Developer Tools.
            },
        },
        properties = { floating = true },
    },

    {
        rule_any = { type = { "normal", "dialog" } },
        properties = { titlebars_enabled = false },
    },

    {
        rule_any = {
            class = {
                "Hidamari",
                "eww",
                "Eww",
                "trayer",
            },
        },
        properties = {
            border_width = 0,
            buttons = {},
            focusable = false, -- Prevent the client from receiving focus
            raise = false, -- Prevent the client from being raised above other windows
            sticky = true,
        },
    },

    {
        rule = {
            class = "stalonetray",
        },
        properties = {
            border_width = 0,
            buttons = {},
            focusable = false,
            raise = false,
            screen = 1,
        },
    },

    {
        rule = { class = "discord" },
        properties = {
            tag = "2",
        },
    },

    {
        rule = { class = "firefox" },
        properties = {
            tag = "3",
        },
    },

    {
        rule_any = { class = { "logseq", "Logseq" } },
        properties = {
            tag = "4",
        },
    },

    {
        rule = {
            class = "com-azefsw-audioconnect-desktop-app-MainKt",
        },
        properties = {
            tag = "8",
        },
    },

    {
        rule_any = {
            class = {
                "cpupower-gui",
                "easyeffects",
                "pavucontrol",
                "Pavucontrol",
                "pritunl",
            },
        },
        properties = {
            tag = "9",
        },
    },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function(c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if
        awesome.startup
        and not c.size_hints.user_position
        and not c.size_hints.program_position
    then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    c:emit_signal("request::activate", "mouse_enter", { raise = false })
end)

client.connect_signal("focus", function(c)
    c.border_color = beautiful.border_focus
end)

client.connect_signal("unfocus", function(c)
    c.border_color = beautiful.border_normal
end)

client.connect_signal("x::reload", function()
    -- Reset the flag when reloading the configuration
    command_executed = false
end)

-- Force minimized clients to unminimize.
client.connect_signal("property::minimized", function(c)
    c.minimized = false
end)
-- }}}

client.connect_signal("property::urgent", function(c)
    if c.urgent then
        awful.client.urgent.jumpto()
    end
end)

awesome.connect_signal("startup", function()
    shell("nm-applet")
    shell("xfce4-power-manager")
    shell("syncthing -no-browser")

    -- xss-lock grabs a logind suspend inhibit lock and will use i3lock to lock the
    -- screen before suspend. Use loginctl lock-session to lock your screen.
    -- shell("lxsession")
    -- spawn("light-locker")

    spawn("hidamari --background")

    spawn("compfy")

    shell("setxkbmap us")
    shell('setxkbmap -option "compose:menu"')

    require("eww")

    spawn("firefox")
    spawn("logseq")
    spawn("easyeffects")
    spawn("pavucontrol")

    shell("sleep 1sec; display_setup.nu internal")
end)

naughty.config.defaults["icon_size"] = 100
