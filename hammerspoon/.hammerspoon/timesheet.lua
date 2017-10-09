local m = {}

-- Send start to db
function m.startTimer()
  m.menu:setTitle('@' .. (hs.wifi.currentNetwork() or 'No Wifi') .. ' ' .. utils.trim(hs.execute('cd ~/Work/time; /Users/joseph/.virtualenvs/time/bin/python ~/Work/time/tracker.py start')))
  m.timer:start()
end

-- send stop to db
function m.stopTimer()
  m.menu:setTitle("@" .. (hs.wifi.currentNetwork() or 'No Wifi'))
  hs.execute('cd ~/Work/time; /Users/joseph/.virtualenvs/time/bin/python ~/Work/time/tracker.py stop')
  m.timer:stop()
end

m.menu = hs.menubar.new(false)
m.timer = hs.timer.new(60, m.startTimer)

-- test 
m.menu:setTitle("@" .. (hs.wifi.currentNetwork() or 'No Wifi'))
m.menu:setMenu({
  {title="Start", fn = m.startTimer},
  {title="Stop", fn = m.stopTimer}
})

return m