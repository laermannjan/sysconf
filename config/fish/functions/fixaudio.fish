function fixaudio --description 'Restart coreaudiod to rescan audio devices. Fixes USB audio devices not found. (Tahoe bug with TS4 dock)'
    # macOS Tahoe fails to re-enumerate USB audio devices after sleep/wake
    # when connected through a dock chain (TS4 → monitor → MacBook).
    # HID devices recover fine, but the TS4 audio codec disappears from
    # Audio MIDI Setup. Restarting coreaudiod forces a rescan.
    sudo killall coreaudiod
end
