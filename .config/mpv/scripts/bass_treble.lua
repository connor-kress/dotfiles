local mp = require("mp")

local bass = 0
local treble = 0
local step = 2

local function display_bass()
    mp.osd_message(string.format("Bass: %d dB", bass), 1.5)
end

local function display_treble()
    mp.osd_message(string.format("Treble: %d dB", treble), 1.5)
end

local function apply_filters()
    local af = string.format(
        "lavfi=[bass=g=%d,treble=g=%d]",
        bass,
        treble
    )
    mp.set_property("af", af)
end

mp.add_key_binding("b", "bass_up", function()
    bass = bass + step
    apply_filters()
    display_bass()
end)

mp.add_key_binding("B", "bass_down", function()
    bass = bass - step
    apply_filters()
    display_bass()
end)

mp.add_key_binding("t", "treble_up", function()
    treble = treble + step
    apply_filters()
    display_treble()
end)

mp.add_key_binding("T", "treble_down", function()
    treble = treble - step
    apply_filters()
    display_treble()
end)

mp.add_key_binding("r", "reset_eq", function()
    bass = 0
    treble = 0
    apply_filters()
    mp.osd_message("Reset equalizer filters", 1.5)
end)
