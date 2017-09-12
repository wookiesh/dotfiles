require("miro-windows-management")

-- Global config
hs.window.animationDuration = 0
super = {"ctrl","alt"}

-- Reload config
hs.hotkey.bind(hyper, "R", hs.reload)
hs.hotkey.bind(hyper, "C", function() hs.application.open("Hammerspoon") end)
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

function trim(s)
  return (s:gsub("^%s*(.-)%s*$", "%1"))
end

-- Send start to goole sheet
local function startTimer()
  menu:setTitle('@' .. hs.wifi.currentNetwork() .. ' ' .. trim(hs.execute('cd ~/Work/time; /Users/joseph/.virtualenvs/time/bin/python ~/Work/time/tracker.py start')))
  timer:start()
end

-- send stop to google sheet
local function stopTimer()
  menu:setTitle("@" .. hs.wifi.currentNetwork())
  hs.execute('cd ~/Work/time; /Users/joseph/.virtualenvs/time/bin/python ~/Work/time/tracker.py stop')
  timer:stop()
end

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

-- try to find and kill apps in list
function kill(list)
  for i, name in ipairs(list) do
    local app = hs.application.get(name)
    if app ~= nil then
      app:kill()
    end
  end
end

-- callback called when wifi network changes
local function ssidChangedCallback()
    local newNetwork = hs.wifi.currentNetwork()
    if not newNetwork then return end

    -- send notification if we're on a different network than we were before
    if lastNetwork ~= newNetwork then
      -- hs.notify.new({
      --   title = 'Wi-Fi Status',
      --   subTitle = 'Network',
      --   informativeText = 'Now connected to ' .. newNetwork,
      --   --contentImage = m.cfg.icon,
      --   autoWithdraw = true,
      --   hasActionButton = false,
      -- }):send()
      lastNetwork = newNetwork

      menu:setTitle('@'..newNetwork)

      -- Home Network
      if newNetwork == "ehuuuuesh" then
        hs.audiodevice.current().device:setOutputMuted(false)

        kill({"Skype for Business", "Microsoft Outlook", "OneDrive - Goodyear"})  
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
menu = hs.menubar.new(false)
timer = hs.timer.new(60, startTimer)
hs.wifi.watcher.new(ssidChangedCallback):start()

-- test 
menu:setTitle("@" .. hs.wifi.currentNetwork())
menu:setMenu({
  {title="Start", fn = startTimer},
  {title="Stop", fn = stopTimer}
})