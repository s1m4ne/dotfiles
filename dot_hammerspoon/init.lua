function appWatcher(name, event, app)
  if event == hs.application.watcher.activated then
    if name == "Alacritty" or name == "ターミナル" then
      if not hs.keycodes.currentSourceID("com.apple.keylayout.US") then
        hs.keycodes.currentSourceID("com.apple.keylayout.ABC")
      end
    end
  end end appWatcher = hs.application.watcher.new(appWatcher)
appWatcher:start()

local saveDir = "/Users/matsulab/Documents/スクリーンショット"
hs.fs.mkdir(saveDir)

local minW, minH = 3, 3
local lastHandled = -1

local function saveClipboardImage()
  local img = hs.pasteboard.readImage()
  if not img then return end
  local sz = img:size()
  if sz.w < minW or sz.h < minH then return end
  local filename = os.date("Screenshot_%Y-%m-%d_%H-%M-%S.png")
  local path = string.format("%s/%s", saveDir, filename)
  img:saveToFile(path)
end

clipboardWatcher = hs.pasteboard.watcher.new(function(changeCount)
  if changeCount == lastHandled then return end
  lastHandled = changeCount
  hs.timer.doAfter(0.15, saveClipboardImage)
end):start()

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "C", function()
  if clipboardWatcher:isRunning() then
    clipboardWatcher:stop()
  else
    clipboardWatcher:start()
  end
end)
