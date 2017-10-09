--[[
This is my attempt to implement a jumpcut replacement in Lua/Hammerspoon.
It monitors the clipboard/pasteboard for changes, and stores the strings you copy to the transfer area.
You can access this history on the menu (Unicode scissors icon).
Clicking on any item will add it to your transfer area.
If you open the menu while pressing option/alt, you will enter the Direct Paste Mode. This means that the selected item will be
"typed" instead of copied to the active clipboard.
The clipboard persists across launches.
-> Ng irc suggestion: hs.settings.set("jumpCutReplacementHistory", clipboard_history)

Migrated to new module implementation on 9/10/2017 by @eagleamon

]]--

-- Module set up
local m = {} 

-- Feel free to change those settings
m.frequency = 0.8 -- Speed in seconds to check for clipboard changes. If you check too frequently, you will loose performance, if you check sparsely you will loose copies
m.hist_size = 20 -- How many items to keep on history
m.label_length = 40 -- How wide (in characters) the dropdown menu should be. Copies larger than this will have their label truncated and end with "…" (unicode for elipsis ...)
m.honor_clearcontent = false --asmagill request. If any application clears the pasteboard, we also remove it from the history https://groups.google.com/d/msg/hammerspoon/skEeypZHOmM/Tg8QnEj_N68J
m.pasteOnSelect = false -- Auto-type on click

-- Don't change anything bellow this line
local jumpcut = hs.menubar.new()
jumpcut:setTooltip("Jumpcut replacement")
local pasteboard = require("hs.pasteboard") -- http://www.hammerspoon.org/docs/hs.pasteboard.html
local settings = require("hs.settings") -- http://www.hammerspoon.org/docs/hs.settings.html
local last_change = pasteboard.changeCount() -- displays how many times the pasteboard owner has changed // Indicates a new copy has been made

--Array to store the clipboard history
local clipboard_history = settings.get("so.victor.hs.jumpcut") or {} --If no history is saved on the system, create an empty history

-- Append a history counter to the menu
local function setTitle()
  if (#clipboard_history == 0) then
    jumpcut:setTitle("✂") -- Unicode magic
    else
      jumpcut:setTitle("✂ ("..#clipboard_history..")") -- updates the menu counter
  end
end

local function putOnPaste(string,key)
  if (m.pasteOnSelect) then
    hs.eventtap.keyStrokes(string)
    pasteboard.setContents(string)
    last_change = pasteboard.changeCount()
  else
    if (key.alt == true) then -- If the option/alt key is active when clicking on the menu, perform a "direct paste", without changing the clipboard
      hs.eventtap.keyStrokes(string) -- Defeating paste blocking http://www.hammerspoon.org/go/#pasteblock
    else
      pasteboard.setContents(string)
      last_change = pasteboard.changeCount() -- Updates last_change to prevent item duplication when putting on paste
    end
  end
end

-- Clears the clipboard and history
local function clearAll()
  pasteboard.clearContents()
  clipboard_history = {}
  settings.set("so.victor.hs.jumpcut",clipboard_history)
  now = pasteboard.changeCount()
  setTitle()
end

-- Clears the last added to the history
local function clearLastItem()
  table.remove(clipboard_history,#clipboard_history)
  settings.set("so.victor.hs.jumpcut",clipboard_history)
  now = pasteboard.changeCount()
  setTitle()
end

local function pasteboardToClipboard(item)
  -- Loop to enforce limit on qty of elements in history. Removes the oldest items
  while (#clipboard_history >= m.hist_size) do
    table.remove(clipboard_history,1)
  end
  table.insert(clipboard_history, item)
  settings.set("so.victor.hs.jumpcut",clipboard_history) -- updates the saved history
  setTitle() -- updates the menu counter
end

-- Dynamic menu by cmsj https://github.com/Hammerspoon/hammerspoon/issues/61#issuecomment-64826257
function populateMenu(key)
  setTitle() -- Update the counter every time the menu is refreshed
  menuData = {}
  if (#clipboard_history == 0) then
    table.insert(menuData, {title="None", disabled = true}) -- If the history is empty, display "None"
  else
    for k,v in pairs(clipboard_history) do
      if (string.len(v) > m.label_length) then
        table.insert(menuData,1, {title=string.sub(v,0,m.label_length).."…", fn = function() putOnPaste(v,key) end }) -- Truncate long strings
      else
        table.insert(menuData,1, {title=v, fn = function() putOnPaste(v,key) end })
      end -- end if else
    end-- end for
  end-- end if else
  -- footer
  table.insert(menuData, {title="-"})
  table.insert(menuData, {title="Clear All", fn = function() clearAll() end })
  if (key.alt == true or m.pasteOnSelect) then
    table.insert(menuData, {title="Direct Paste Mode ✍", disabled=true})
  end
  return menuData
end

-- If the pasteboard owner has changed, we add the current item to our history and update the counter.
local function storeCopy()
  now = pasteboard.changeCount()
  if (now > last_change) then
    current_clipboard = pasteboard.getContents()
    -- asmagill requested this feature. It prevents the history from keeping items removed by password managers
    if (current_clipboard == nil and m.honor_clearcontent) then
      clearLastItem()
    else
      pasteboardToClipboard(current_clipboard)
    end
    last_change = now
  end
end

--Checks for changes on the pasteboard. Is it possible to replace with eventtap?
m.timer = hs.timer.new(m.frequency, storeCopy)
m.timer:start()

setTitle() --Avoid wrong title if the user already has something on his saved history
jumpcut:setMenu(populateMenu)

return m