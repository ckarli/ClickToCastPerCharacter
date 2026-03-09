-- ClickToCastPerCharacter
-- Saves and restores the "Hold to Cast" setting on a per-character basis

local addonName, addon = ...

-- The CVar for Hold to Cast setting
local HOLD_TO_CAST_CVAR = "ActionButtonUseKeyHeldSpell"

-- Create the main frame for event handling
local frame = CreateFrame("Frame")

-- Get a unique key for the current character
local function GetCharacterKey()
    local name = UnitName("player")
    local realm = GetRealmName()
    return name .. "-" .. realm
end

-- Get the current Hold to Cast setting
local function GetHoldToCastSetting()
    return GetCVar(HOLD_TO_CAST_CVAR) == "1"
end

-- Set the Hold to Cast setting
local function SetHoldToCastSetting(enabled)
    SetCVar(HOLD_TO_CAST_CVAR, enabled and "1" or "0")
end

-- Save the current setting for this character
local function SaveSetting()
    local key = GetCharacterKey()
    local enabled = GetHoldToCastSetting()
    
    ClickToCastPerCharacterDB = ClickToCastPerCharacterDB or {}
    ClickToCastPerCharacterDB[key] = enabled
    
    return enabled
end

-- Load and apply the saved setting for this character
local function LoadSetting()
    local key = GetCharacterKey()
    
    if ClickToCastPerCharacterDB and ClickToCastPerCharacterDB[key] ~= nil then
        local savedSetting = ClickToCastPerCharacterDB[key]
        SetHoldToCastSetting(savedSetting)
        return savedSetting, true
    end
    
    return GetHoldToCastSetting(), false
end

-- Toggle the Hold to Cast setting
local function ToggleSetting()
    local currentSetting = GetHoldToCastSetting()
    local newSetting = not currentSetting
    
    SetHoldToCastSetting(newSetting)
    SaveSetting()
    
    return newSetting
end

-- Print a message to chat
local function PrintMessage(msg)
    print("|cFF00FF00[ClickToCast]|r " .. msg)
end

-- Print the current status
local function PrintStatus()
    local enabled = GetHoldToCastSetting()
    local status = enabled and "|cFF00FF00enabled|r" or "|cFFFF0000disabled|r"
    PrintMessage("Hold to Cast is currently " .. status .. " for " .. GetCharacterKey())
end

-- Handle slash commands
local function HandleSlashCommand(msg)
    msg = msg and msg:lower():trim() or ""
    
    if msg == "on" or msg == "enable" or msg == "1" then
        SetHoldToCastSetting(true)
        SaveSetting()
        PrintMessage("Hold to Cast |cFF00FF00enabled|r for " .. GetCharacterKey())
    elseif msg == "off" or msg == "disable" or msg == "0" then
        SetHoldToCastSetting(false)
        SaveSetting()
        PrintMessage("Hold to Cast |cFFFF0000disabled|r for " .. GetCharacterKey())
    elseif msg == "toggle" then
        local newSetting = ToggleSetting()
        local status = newSetting and "|cFF00FF00enabled|r" or "|cFFFF0000disabled|r"
        PrintMessage("Hold to Cast " .. status .. " for " .. GetCharacterKey())
    elseif msg == "status" or msg == "" then
        PrintStatus()
    else
        PrintMessage("Commands:")
        PrintMessage("  /ctc - Show current status")
        PrintMessage("  /ctc on - Enable Hold to Cast")
        PrintMessage("  /ctc off - Disable Hold to Cast")
        PrintMessage("  /ctc toggle - Toggle Hold to Cast")
        PrintMessage("  /ctc status - Show current status")
    end
end

-- Register slash commands
SLASH_CLICKTOCASTPERCHAR1 = "/ctc"
SLASH_CLICKTOCASTPERCHAR2 = "/clicktocast"
SLASH_CLICKTOCASTPERCHAR3 = "/holdtocast"
SlashCmdList["CLICKTOCASTPERCHAR"] = HandleSlashCommand

-- Event handler
frame:SetScript("OnEvent", function(self, event, ...)
    if event == "ADDON_LOADED" then
        local loadedAddon = ...
        if loadedAddon == addonName then
            -- Addon loaded, wait for player login
            self:UnregisterEvent("ADDON_LOADED")
        end
    elseif event == "PLAYER_LOGIN" then
        -- Player has logged in, load the saved setting
        local setting, hadSavedSetting = LoadSetting()
        
        if hadSavedSetting then
            local status = setting and "enabled" or "disabled"
            PrintMessage("Loaded saved setting: Hold to Cast " .. status)
        else
            -- First time for this character, save current setting
            SaveSetting()
            PrintMessage("First login detected. Current Hold to Cast setting saved.")
        end
        
        PrintMessage("Type /ctc for commands.")
    elseif event == "PLAYER_LOGOUT" then
        -- Save setting on logout in case it was changed via game settings
        SaveSetting()
    end
end)

-- Register events
frame:RegisterEvent("ADDON_LOADED")
frame:RegisterEvent("PLAYER_LOGIN")
frame:RegisterEvent("PLAYER_LOGOUT")
