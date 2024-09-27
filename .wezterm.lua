-- These are the basic's for using wezterm.
-- Mux is the mutliplexes for windows etc inside of the terminal
-- Action is to perform actions on the terminal
local wezterm = require("wezterm")
local mux = wezterm.mux
local act = wezterm.action

-- Find home directory
-- Get the home directory
local home_dir = wezterm.home_dir
print(home_dir)

-- These are vars to put things in later (i dont use em all yet)
local config = {}
local keys = {}
local mouse_bindings = {}
local launch_menu = {}

-- This is for newer wezterm vertions to use the config builder
if wezterm.config_builder then
	config = wezterm.config_builder()
end

-- Default config settings
-- These are the default config settins needed to use Wezterm
-- Just add this and return config and that's all the basics you need

-- How many lines of scrollback you want to retain per tab
config.scrollback_lines = 3500
-- Enable the scrollbar.
-- It will occupy the right window padding space.
-- If right padding is set to 0 then it will be increased
-- to a single cell width
config.enable_scroll_bar = true

-- Color scheme, Wezterm has 100s of them you can see here:
-- https://wezfurlong.org/wezterm/colorschemes/index.html
config.color_scheme = "Oceanic Next (Gogh)"
-- This is my chosen font, we will get into installing fonts on windows later
config.font = wezterm.font("Hack Nerd Font")
config.font_size = 15
config.launch_menu = launch_menu
-- makes my cursor blink
config.default_cursor_style = "BlinkingBar"
config.disable_default_key_bindings = true
-- this adds the ability to use ctrl+v to paste the system clipboard
config.keys = {
	{
		key = "h",
		mods = "CTRL|ALT|SHIFT",
		action = act.ActivatePaneDirection("Left"),
	},
	{
		key = "l",
		mods = "CTRL|ALT|SHIFT",
		action = act.ActivatePaneDirection("Right"),
	},
	{
		key = "k",
		mods = "CTRL|ALT|SHIFT",
		action = act.ActivatePaneDirection("Up"),
	},
	{
		key = "j",
		mods = "CTRL|ALT|SHIFT",
		action = act.ActivatePaneDirection("Down"),
	},
	{
		key = '"',
		mods = "CTRL|SHIFT|ALT",
		action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
	},
	{
		key = "%",
		mods = "CTRL|SHIFT|ALT",
		action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},
	{
		key = "d",
		mods = "CTRL|ALT|SHIFT",
		action = wezterm.action.ShowDebugOverlay,
	},
	{
		key = "r",
		mods = "CTRL|ALT|SHIFT",
		action = act.PromptInputLine({
			description = "Enter new name for tab",
			action = wezterm.action_callback(function(window, _, line)
				-- line will be `nil` if they hit escape without entering anything
				-- An empty string if they just hit enter
				-- Or the actual line of text they wrote
				if line then
					window:active_tab():set_title(line)
				end
			end),
		}),
	},
	{
		key = "w",
		mods = "CTRL|ALT|SHIFT",
		action = wezterm.action.SpawnCommandInNewWindow({
			domain = "CurrentPaneDomain",
		}),
	},
	{
		key = "t",
		mods = "CTRL|ALT|SHIFT",
		action = wezterm.action({ SpawnTab = "CurrentPaneDomain" }),
	},
	{
		key = "x",
		mods = "CTRL|ALT|SHIFT",
		action = wezterm.action({ CloseCurrentTab = { confirm = true } }),
	},
	{
		key = "v",
		mods = "CTRL|SHIFT",
		action = act.PasteFrom("Clipboard"),
	},
	-- Switch to the next tab
	{
		key = "n",
		mods = "CTRL|SHIFT|ALT",
		action = wezterm.action({ ActivateTabRelative = 1 }),
	},
	-- Switch to the previous tab
	{
		key = "b",
		mods = "CTRL|SHIFT|ALT",
		action = wezterm.action({ ActivateTabRelative = -1 }),
	},
	{
		key = "-",
		mods = "CTRL",
		action = wezterm.action.DecreaseFontSize,
	},
	{
		key = "=",
		mods = "CTRL",
		action = wezterm.action.IncreaseFontSize,
	},
	{
		key = "0",
		mods = "CTRL",
		action = wezterm.action.ResetFontSize,
	},
	{
		key = "c",
		mods = "CTRL|SHIFT",
		action = act.CopyTo("Clipboard"),
	},
	-- Add this new key binding for search functionality
	{
		key = "f",
		mods = "CTRL|SHIFT",
		action = act.Search("CurrentSelectionOrEmptyString"),
	},
}
config.mouse_bindings = mouse_bindings

-- There are mouse binding to mimc Windows Terminal and let you copy
-- To copy just highlight something and right click. Simple
mouse_bindings = {
	{
		event = { Down = { streak = 3, button = "Left" } },
		action = wezterm.action.SelectTextAtMouseCursor("SemanticZone"),
		mods = "NONE",
	},
	{
		event = { Down = { streak = 1, button = "Right" } },
		mods = "NONE",
		action = wezterm.action_callback(function(window, pane)
			local has_selection = window:get_selection_text_for_pane(pane) ~= ""
			if has_selection then
				window:perform_action(act.CopyTo("ClipboardAndPrimarySelection"), pane)
				window:perform_action(act.ClearSelection, pane)
			else
				window:perform_action(act({ PasteFrom = "Clipboard" }), pane)
			end
		end),
	},
}

-- This is used to make my foreground (text, etc) brighter than my background
config.foreground_text_hsb = {
	hue = 1.0,
	saturation = 1.2,
	brightness = 1.5,
}

-- This is used to set an image as my background
-- config.background = {
-- 	{
-- 		source = {
-- 			File = { path = home_dir .. "/Documents/WezTerm/black.jpg" },
-- 		},
-- 		opacity = 3,
-- 		width = "100%",
-- 		hsb = { brightness = 0.25 },
-- 	},
-- }

-- function tab_title(tab_info)
-- 	local title = tab_info.tab_title

-- 	-- if the tab title is explicitly set, take that

-- 	if title and #title > 0 then
-- 		return title
-- 	end

-- 	-- Otherwise, use the title from the active pane

-- 	-- in that tab

-- 	return tab_info.active_pane.title
-- end

function tab_title(tab_info)
	local title = tab_info.tab_title

	-- First, check if there's a title set by the terminal
	if tab_info.active_pane.title and #tab_info.active_pane.title > 0 then
		return tab_info.active_pane.title
	end

	-- If not, use the tab title if explicitly set
	if title and #title > 0 then
		return title
	end

	-- Otherwise, use a default title or the process name
	return tab_info.active_pane.foreground_process_name
end

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
	local title = tab_title(tab)

	if tab.is_active then
		return {

			{ Background = { Color = "blue" } },

			{ Text = " " .. title .. " " },
		}
	end

	return title
end)

return config
