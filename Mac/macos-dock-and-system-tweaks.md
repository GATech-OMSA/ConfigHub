# Useful macOS Terminal Commands

## Dock Modifications

### Faster Dock Hiding
```bash
defaults write com.apple.dock autohide-time-modifier -int 0;killall Dock
```

### Faster Dock Show
```bash
defaults write com.apple.dock autohide-time-modifier -float 0.15;killall Dock
```

### Undo Faster Dock Hiding
```bash
defaults delete com.apple.dock autohide-time-modifier;killall Dock
```

### Add Dock Spacer
(Paste for each spacer you want to add)
```bash
defaults write com.apple.dock persistent-apps -array-add '{tile-data={}; tile-type="spacer-tile";}' && killall Dock
```

### Add Half-Height Dock Spacer
(Paste for each spacer you want to add)
```bash
defaults write com.apple.dock persistent-apps -array-add '{"tile-type"="small-spacer-tile";}' && killall Dock
```

## Disk Warnings

### Disable Annoying Disk Warning
(Must restart Mac to take effect)
```bash
sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.DiskArbitration.diskarbitrationd.plist DADisableEjectNotification -bool YES && sudo pkill diskarbitrationd
```

### Re-Enable Annoying Disk Warning
```bash
sudo defaults delete /Library/Preferences/SystemConfiguration/com.apple.DiskArbitration.diskarbitrationd.plist DADisableEjectNotification && sudo pkill diskarbitrationd
```

Alternatively, download Ejectify: [https://ejectify.app](https://ejectify.app)

## Screenshot Settings

### Change Screenshot Default to JPG
(Replace 'jpg' with 'png' to undo)
```bash
defaults write com.apple.screencapture type jpg
```

## Hidden Apps

### Make Hidden Apps Transparent
```bash
defaults write com.apple.Dock showhidden -bool TRUE && killall Dock
```
</antArt
