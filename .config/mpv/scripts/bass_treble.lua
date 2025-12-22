local mp = require("mp")
local msg = require("mp.msg")

local function parse_number_after(s, key)
    local i = s:find(key, 1, true)
    if not i then
        return nil
    end
    i = i + #key
    local j = i

    while j <= #s do
        local c = s:sub(j, j)
        if not (c:match("[%d%.%-]")) then
            break
        end
        j = j + 1
    end
    return tonumber(s:sub(i, j - 1))
end

local function parse_bass_treble_from_af()
    local af = mp.get_property("af")
    msg.debug("Raw af: " .. tostring(af))
    if not af or af == "" then
        return 0, 0
    end
    local bass = parse_number_after(af, "bass=g=")
    local treble = parse_number_after(af, "treble=g=")
    return bass or 0, treble or 0
end

local step = 1
local bass = 0
local treble = 0

mp.register_event("file-loaded", function()
    -- properties restored, tracks selected, watch-later applied
    bass, treble = parse_bass_treble_from_af()
    -- msg.info("Bass: " .. bass .. " dB, Treble: " .. treble .. " dB")
end)

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
end, { repeatable = true })

mp.add_key_binding("B", "bass_down", function()
    bass = bass - step
    apply_filters()
    display_bass()
end, { repeatable = true })

mp.add_key_binding("t", "treble_up", function()
    treble = treble + step
    apply_filters()
    display_treble()
end, { repeatable = true })

mp.add_key_binding("T", "treble_down", function()
    treble = treble - step
    apply_filters()
    display_treble()
end, { repeatable = true })

mp.add_key_binding("r", "reset_eq", function()
    bass = 0
    treble = 0
    apply_filters()
    mp.osd_message("Reset equalizer filters", 1.5)
end)
