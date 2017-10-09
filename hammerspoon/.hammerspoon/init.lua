require("miro-windows-management")
require("jumpcut")
ts = require("timesheet")
utils = require("utils")

-- aliases
i = hs.inspect

-- Global config
hs.window.animationDuration = 0
super = {"ctrl","alt"}

-- Reload config
hs.hotkey.bind(hyper, "R", hs.reload)
hs.hotkey.bind(hyper, "C", hs.toggleConsole)
hs.alert.show("Config loaded")

-- # Window management (Complement to Miro)
-- multi monitor
hs.hotkey.bind(hyper, "N", hs.grid.pushWindowNextScreen)

-- move windows
hs.hotkey.bind(hyper, 'H', hs.grid.pushWindowLeft)
hs.hotkey.bind(hyper, 'J', hs.grid.pushWindowDown)
hs.hotkey.bind(hyper, 'K', hs.grid.pushWindowUp)
hs.hotkey.bind(hyper, 'L', hs.grid.pushWindowRight)

-- Window Hints
hs.hotkey.bind(hyper, '=', hs.hints.windowHints)

-- Lock screen
hs.hotkey.bind(super, "L", hs.caffeinate.lockScreen)

-- callback called when wifi network changes
local function ssidChangedCallback()
    local newNetwork = hs.wifi.currentNetwork()
    if not newNetwork then return end

    -- send notification if we're on a different network than we were before
    if lastNetwork ~= newNetwork then
      lastNetwork = newNetwork

      menu:setTitle('@'..newNetwork)

      -- Home Network
      if newNetwork == "ehuuuuesh" then
        hs.audiodevice.current().device:setOutputMuted(false)

        utils.kill({"Skype for Business", "Microsoft Outlook", "OneDrive - Goodyear"})  
      end

      -- Work Network
      if newNetwork == "goweb" then
        hs.audiodevice.current().device:setOutputMuted(true)        
        startTimer()
      end
    end
end

-- Wifi Watcher
local lastNetwork = nil
hs.wifi.watcher.new(ssidChangedCallback):start()

-- Spoons
hs.loadSpoon('speedmenu')