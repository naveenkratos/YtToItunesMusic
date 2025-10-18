**Youtube to Itunes Playlist:**

Steps to follow:

1. DoubleClick setup.bat file. if prompted, provide admin privilage. "Wait fot setup to complete!"
2. In config.ini file, Add your playlist link to be in sync with your itunes
3. If you want to sync only once DoubleClick auto_sync.bat
4. For Auto Sync YT -> itunes Playlist,
   open Task Scheduler,
   In General Tab,
     click Create Task, "Note: don't create basic task"
     Give name as 'YouTube Music To iTunes Auto Sync'
     check Run only when user is logged on.
   In Trigger tab,
     click create new,
     Select "on workstation unlock"
     check specific user
     check delay task and select seconds and then edit it to 45 seconds
     check enabled
   In Action Tab,
     create new,
     select "Start a program"
     click browse, navigate to YtToItunesMusic and select auto_sync.bat
   In condition Tab,
     Uncheck all
     Then check "Start Task only when computer is on AC Power" and
     "start only if network connection is available"
     select "Any available network"
   

**Note: while Syncing or running scripts if itunes opens by itself dont close it.**
