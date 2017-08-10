require("miro-windows-management")

-- Global config
hs.window.animationDuration = 0
super = {"ctrl","alt"}

-- Reload config
hs.hotkey.bind(hyper, "R", hs.reload)
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

-- Wifi Watcher
local lastNetwork = nil
local menuItem = nil
local startTime = nil
local timer = nil

-- util string function to display time
function SecondsToClock(seconds)
  local seconds = tonumber(seconds)

  if seconds <= 0 then
    return "00:00:00";
  else
    hours = string.format("%02.f", math.floor(seconds/3600));
    mins = string.format("%02.f", math.floor(seconds/60 - (hours*60)));
    -- secs = string.format("%02.f", math.floor(seconds - hours*3600 - mins *60));
    return hours..":"..mins -- ..":"..secs
  end
end

-- callback called when wifi network changes
local function ssidChangedCallback()
    local newNetwork = hs.wifi.currentNetwork()
    if not newNetwork then return end

    -- send notification if we're on a different network than we were before
    if lastNetwork ~= newNetwork then
      hs.notify.new({
        title = 'Wi-Fi Status',
        subTitle = newNetwork and 'Network:' or 'Disconnected',
        informativeText = newNetwork and 'Now connected to ' .. newNetwork or '',
        --contentImage = m.cfg.icon,
        autoWithdraw = true,
        hasActionButton = false,
      }):send()

      lastNetwork = newNetwork
      print("ssidChangedCallback: old:"..(lastNetwork or "nil").." new:"..(newNetwork or "nil"))

      -- Home Network
      if newNetwork == "ehuuuuesh" then
        hs.audiodevice.current().device:setOutputMuted(false)
        menuItem:removeFromMenuBar()
        menuItem = nil
        startTime = nil
        timer.stop()
        timer = nil

        hs.application.find("outlook"):kill()
        hs.application.find("onedrive"):kill()
        hs.application.find("skype"):kill()
      
      end

      -- Work Network
      if newNetwork == "goweb" then
        hs.audiodevice.current().device:setOutputMuted(true)
        menuItem = hs.menubar.new()
        menuItem:setTitle("@Work..")
        startTime = os.time()
        timer = hs.timer.doEvery(60, function() menuItem:setTitle("@Work - " .. SecondsToClock(os.time()-startTime)) end )        
      end
    end
end

hs.wifi.watcher.new(ssidChangedCallback):start()