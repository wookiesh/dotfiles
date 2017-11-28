local m = {}

-- Yep, trim that string
function m.trim(s)
  return (s:gsub("^%s*(.-)%s*$", "%1"))
end

-- util string function to display time
function m.SecondsToClock(seconds)
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
function m.kill(list)
  for i, name in ipairs(list) do
    local app = hs.application.get(name)
    if app ~= nil then
      app:kill()
    end
  end
end

function m.ToggleWifi()
  if select(4, hs.execute('networksetup -getairportpower en0|grep On')) == 0 then
    hs.execute('networksetup -setairportpower airport off')
  else
    hs.execute('networksetup -setairportpower airport on')
  end
end

return m