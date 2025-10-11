function appWatcher(name, event, app)
  if event == hs.application.watcher.activated then
    if name == "Alacritty" or name == "ターミナル" then
      if not hs.keycodes.currentSourceID("com.apple.keylayout.US") then
        hs.keycodes.currentSourceID("com.apple.keylayout.ABC")
      end
    end
  end end appWatcher = hs.application.watcher.new(appWatcher)
appWatcher:start()
